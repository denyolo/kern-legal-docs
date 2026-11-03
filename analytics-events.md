# KERN - Pseudonymisierte Nutzungs-Metriken (Schema)

**Stand:** 03.11.2026
**Geltungsbereich:** seit der Beta-Phase (Mai 2026) und darüber hinaus

---

## Zweck

KERN sammelt **pseudonymisierte Nutzungs-Zahlen**, um die App besser zu machen - zum Beispiel:
- Sind die Reflexions-Zeichen-Limits zu eng oder zu großzügig?
- Wie oft wird eine freie Reflexion am Ende verworfen statt gespeichert?
- Welche Meditations-Kategorien werden am meisten genutzt?
- Wie lange dauert das Onboarding im Durchschnitt?

**KERN sammelt KEINE Inhalte.** Deine Reflexionen, Sichtweisen, Gedanken und Ziele werden niemals in den Analytics-Daten gespeichert.

---

## Was technisch gespeichert wird

Alle Metriken landen in **einer separaten Tabelle** namens `usage_events` (Supabase-Postgres). Diese Tabelle hat per Design **keine Text-Spalten für Inhalte** - nur Zahlen und kontrollierte Enums.

Schema (öffentlich im KERN-Repo einsehbar):
- [`migrations/0005_usage_events.sql`](https://github.com/denyolo/kern-legal-docs/blob/main/migrations/0005_usage_events.sql) (im öffentlichen [kern-legal-docs](https://github.com/denyolo/kern-legal-docs) Repo)
- Die erlaubten Event-Typen stehen in der jeweils neuesten Migration mit `chk_event_type` (Stand: [`migrations/0035_event_type_ai_consent.sql`](https://github.com/denyolo/kern-legal-docs/blob/main/migrations/0035_event_type_ai_consent.sql), 30 Typen)

**Spalten:**

| Spalte | Typ | Was steht drin | Was NICHT drin steht |
|---|---|---|---|
| `id` | UUID | zufällige Zeilen-ID | - |
| `occurred_at` | Timestamp | wann das Event passiert ist | - |
| `event_type` | Text (Enum) | einer der erlaubten Typen (siehe unten) | freie Strings |
| `user_id_hashed` | Text (64 Zeichen Hex) | SHA-256-Hash deiner User-ID mit geheimem Salt | deine echte User-ID, Email, Name |
| `category` | Text (max 64 Zeichen) | z.B. `bodyscan`, `free`, `monthly` | freie User-Eingaben |
| `numeric_1` / `_2` / `_3` | Integer | Zahlen (Zeichen-Anzahl, Sekunden, Counts) | - |
| `session_token` | Text (max 64 Zeichen) | zufällige Kennung, neu bei jeder Rückkehr in die App | User-Identifikation |

**Hard-Constraints in der Datenbank:**
- `event_type` MUSS einer der erlaubten Typen sein (Postgres-CHECK)
- `category` und `session_token` sind auf max 64 Zeichen begrenzt (verhindert, dass jemand versucht, Inhalte reinzuschmuggeln)
- Niemand außer dem Owner-Konto kann die Tabelle direkt lesen (RLS-Locked)

---

## Die ursprünglichen 8 Event-Typen im Detail

### 1. `reflection_completed`
Eine Reflexionssession wurde komplett durchlaufen.
- `category`: `'free'` (freie Reflexion) oder `'guided'` (geführte Reflexion), `'structured'` stammt aus einem früheren Ablauf der freien Reflexion mit festen Fragen
- `numeric_1`: Summe aller User-Antwort-**Zeichen** (Länge, nicht Inhalt)
- `numeric_2`: Anzahl Antworten (Turn-Count)
- `numeric_3`: Dauer in Sekunden

### 2. `reflection_aborted`
Eine freie Reflexion wurde am Ende verworfen statt gespeichert (Knopf „Diese Reflexion verwerfen“ unter der Zusammenfassung). Nur dieser Knopf erzeugt den Eintrag. Das Verwerfen einer geführten Reflexion und ein früheres Verlassen des Gesprächs erzeugen keinen.
- `category`: `'free'` (`'structured'` stammt aus einem früheren Ablauf mit festen Fragen)
- `numeric_1`: Summe der bisher geschriebenen User-**Zeichen**
- `numeric_2`: Anzahl der Antworten im Gespräch (wie bei `reflection_completed`)

### 3. `affirmation_generated`
Eine Sichtweise wurde formuliert und gespeichert.
- `numeric_1`: **Zeichen**-Länge des KI-Outputs (nicht der Inhalt)
- `numeric_2`: Wie oft „Neu generieren“ getippt wurde

### 4. `meditation_completed`
Eine Meditation wurde beendet, nachdem mindestens 5 Minuten gezählt wurden (siehe `numeric_2`). Für kürzere Meditationen entsteht dieser Eintrag nicht.
- `category`: Meditations-Kategorie (`bodyscan` / `breathwork` / `sleep` / etc.)
- `numeric_1`: Gewählte Dauer in Sekunden
- `numeric_2`: Gezählte Dauer in Sekunden (wie lange die Meditation lief, ohne Pausen, höchstens die gewählte Dauer, auf ganze Minuten gerundet)
- `numeric_3`: Welche Stimme lief (1 = männlich, 2 = weiblich, leer bei persönlichen und freien Meditationen)

### 5. `onboarding_completed`
Onboarding wurde abgeschlossen.
- `category`: Variante des Einstiegs (`browse` oder `classic`, je nach App-Version)
- `numeric_1`: Dauer in Sekunden
- `numeric_2`: Anzahl erkannte Lebensbereiche (Zahl)
- `numeric_3`: Anzahl erkannte Blockaden (Zahl)

### 6. `limit_reached`
Ein Free-Tier-Limit wurde erreicht (Rate-Limit-Modal erscheint).
- `category`: `'mirror'` / `'guided'` / `'affirmation'`
- `numeric_1`: derzeit immer 0

### 7. `premium_converted`
Ein Free-User hat ein Premium-Abo abgeschlossen.
- `category`: `'monthly'` / `'yearly'`
- `numeric_1`: Tage seit Account-Erstellung
- Hinweis: Dieser Typ ist im Code vorgesehen, wird derzeit aber nicht gesendet.

### 8. `app_session`
Eine App-Nutzungs-Session wurde beendet.
- `numeric_1`: Aktive Nutzungs-Dauer in Sekunden

---

## Weitere Event-Typen (seit Juli 2026 nach und nach ergänzt)

Alle streng ohne Inhalte, nur Enums und Zahlen.

| Typ | Wann | Felder |
|---|---|---|
| `affirmation_practiced` | Eine bestehende Sichtweise wurde erneut geübt | `numeric_1`: wie stimmig sie sich anfühlt (1-10, 0 = ohne Bewertung) |
| `onboarding_started` | Das Einstiegsgespräch wurde geöffnet | `category`: Variante des Einstiegs (`browse` oder `classic`, je nach App-Version) |
| `browse_entered` | KERN wurde ohne Gespräch erkundet | `category`: `intro` (erster Besuch), `return` (Rückkehr) oder `reinstall` |
| `meditation_started` | Eine Meditation wurde angetippt | `category`: Meditations-Kategorie |
| `onboarding_intro_advanced` | Eine Seite des Intros wurde erreicht | `category`: Variante des Einstiegs, `numeric_1`: welche Seite |
| `onboarding_turn` | Eine Antwort im Einstiegsgespräch wurde gesendet | `category`: Variante des Einstiegs, `numeric_1`: der wievielte Zug |
| `onboarding_reveal_reached` | Die Seite „Das hat KERN verstanden“ wurde erreicht | `category`: Variante des Einstiegs |
| `onboarding_backup_reached` | Die Backup-Wahl wurde erreicht | `category`: Variante des Einstiegs |
| `onboarding_abandoned` | Das Einstiegsgespräch wurde über den Zurück-Pfeil verlassen | `category`: Variante des Einstiegs, `numeric_1`: wie weit es gekommen war |
| `course_started` | Ein Kurs wurde gestartet | `category`: Kurs-Kennung (bei Themen-Kursen nur `theme`, nie der Name des Lebensbereichs) |
| `course_day_completed` | Ein Kurstag wurde abgeschlossen | `category`: wie oben, `numeric_1`: Tag |
| `course_completed` | Ein Kurs wurde abgeschlossen | `category`: wie oben, `numeric_1`: Kalendertage seit Start |
| `meditation_rated` | Daumen hoch oder runter für eine Meditation | `category`: Kategorie, `numeric_1`: 1 = gut, 0 = weniger |
| `paywall_viewed` | Die Abo-Seite wurde geöffnet | `category`: von wo (z.B. eine gesperrte Meditation oder das Ende von Kurs 1) |
| `reflection_summary_failed` | Die Zusammenfassung einer Reflexion hat nicht geklappt | `category`: `free` oder `guided`, `numeric_1`: Fehlerart (kein Inhalt) |
| `explainer_started` / `explainer_ended` / `explainer_cta` | Erklärvideo gestartet, beendet, Knopf am Ende | Herkunft; beim Ende zusätzlich, wie es endete (zu Ende geschaut, übersprungen, geschlossen, Fehler) und die geschauten Sekunden; beim Knopf, welcher Knopf |
| `share_opened` | Das Weiterempfehlen-Fenster wurde geöffnet | `category`: Ort, `numeric_1`: 1 = wirklich geteilt |
| `ai_consent` | Die Frage nach der Erlaubnis für die KI wurde beantwortet | `category`: wo gefragt wurde, `numeric_1`: 1 = Einverstanden, 0 = Nicht jetzt |
| `next_course_card_viewed` / `next_course_card_tapped` | Die Karte zum nächsten Kurs wurde gesehen oder angetippt | `category`: nächster Kurs, `numeric_1`: Tage seit Abschluss von Kurs 1; beim Antippen zusätzlich `numeric_2`: ob die Angebotszeile sichtbar war |

---

## Wie der User-Hash funktioniert

1. App ruft die Datenbank-Funktion `log_usage_event(...)` auf
2. Funktion liest deine User-ID aus dem Login-Token
3. Funktion kombiniert User-ID mit einem **geheimen Salt** (nur auf dem Server)
4. SHA-256-Hash davon wird gespeichert

**Eigenschaften:**
- Der Hash ist **immer gleich** für dieselbe User-ID - wir können also Gruppen über die Zeit auswerten (z.B. „Wie viele, die in ihrer ersten Woche meditiert haben, kommen in der zweiten Woche wieder?“)
- Der Hash ist **nicht zurückrechenbar** ohne das Salt
- Das Salt wird **nicht im Code** abgelegt - es liegt in einer eigenen, gesperrten Tabelle der Datenbank (`app_secrets`), die nur der Server lesen kann, nicht im öffentlichen GitHub-Repo
- Auch wenn jemand die Tabelle stehlen würde, könnte er nicht herausfinden, welche User-ID hinter welchem Hash steht - außer er hätte zusätzlich Server-Zugriff plus alle User-IDs

Das ist eine **Pseudonymisierung**, keine Anonymisierung: Mit dem Salt ließe sich prüfen, zu welcher User-ID ein Hash gehört. Wann wir das tun dürfen, steht unten.

---

## Wer kann was lesen?

| Akteur | Kann lesen | Kann schreiben |
|---|---|---|
| Du als User | nichts direkt | ja, automatisch beim App-Nutzen (via SECURITY-DEFINER-Funktion) |
| Andere User | nichts | nichts |
| Dennis (Owner-Admin) | aggregierte Statistiken (COUNT, AVG, GROUP BY) | technisch ja, praktisch nicht |
| Externe / Hacker | nichts | nichts |

Der Owner-Admin-Zugriff auf einzelne Rows ist durch die `admin-conduct.md`-Selbstverpflichtung begrenzt - das ist dieselbe Regel, die auch für die Inhalts-Tabellen gilt.

---

## Beispiel-Queries, die der Owner machen darf

Diese Queries lesen nur **Zusammenfassungen**, keine einzelnen User-Rows:

```sql
-- Wie viele Reflexionen wurden in den letzten 30 Tagen gemacht?
SELECT COUNT(*) FROM usage_events
WHERE event_type = 'reflection_completed'
AND occurred_at > NOW() - INTERVAL '30 days';

-- Durchschnittliche Reflexions-Zeichen-Anzahl?
SELECT AVG(numeric_1) FROM usage_events
WHERE event_type = 'reflection_completed';

-- Wie oft wird eine freie Reflexion am Ende verworfen statt gespeichert?
SELECT event_type, COUNT(*) FROM usage_events
WHERE event_type IN ('reflection_completed', 'reflection_aborted')
AND category = 'free'
GROUP BY event_type;

-- Welche Meditations-Kategorie am beliebtesten?
SELECT category, COUNT(*) FROM usage_events
WHERE event_type = 'meditation_completed'
GROUP BY category ORDER BY COUNT(*) DESC;
```

Vier eng begrenzte Ausnahmen, alle ohne Inhalte:
- **Was führt zu einem Kauf?** Der Abo-Status darf mit den Nutzungszahlen verknüpft werden, aber nur als Summe über alle Käufer (z.B. „wie viele Käufer haben vorher Kurs 1 abgeschlossen“), nie für den Blick auf eine einzelne Person.
- **Ein gespaltenes Konto reparieren.** Um Konten zu finden, die durch einen technischen Fehler zweigeteilt sind, dürfen Nutzungszahlen einzelnen Konten zugeordnet werden - nur Kennungen und Zeitpunkte, nur für diese Reparatur, jeder Lauf protokolliert (`admin-conduct.md`, Abschnitt 2c).
- **Auf deinen Wunsch.** Verlangst du Auskunft, widersprichst du den Nutzungszahlen oder möchtest du sie gelöscht haben, suchen wir genau deine Einträge heraus - nur dafür.
- **Bei rechtlicher Pflicht.** Verpflichtet uns ein deutsches Gericht oder eine zuständige deutsche Behörde nach gültigem Recht dazu, suchen wir genau die verlangten Einträge heraus - nur dafür (Datenschutzerklärung, Abschnitt 9).

---

## Was der Owner explizit NICHT tun darf

```sql
-- VERBOTEN: Einzelne User-Events auflisten, um eine Person anzuschauen
-- (Ausnahmen nur: Reparatur eines gespaltenen Kontos nach admin-conduct 2c, auf Wunsch der Person selbst oder bei rechtlicher Pflicht)
-- SELECT * FROM usage_events WHERE user_id_hashed = 'abc...';

-- VERBOTEN: Verknüpfung mit Inhalts-Tabellen
-- SELECT * FROM sessions JOIN usage_events ON ...
```

Die `admin-conduct.md`-Verpflichtung gilt sinngemäß auch für die Analytics-Tabelle - wir suchen Verhaltens-Muster, nicht Personen-Profile.

---

## Was wenn du das nicht möchtest?

Aktuell lässt sich das Erfassen in der App nicht abschalten. Die Einträge enthalten keine Inhalte und stehen unter einem Pseudonym statt deiner User-ID. Das ist eine Pseudonymisierung, keine Anonymisierung (Details in der Datenschutzerklärung, Abschnitt 5). Rechtsgrundlage ist unser berechtigtes Interesse, KERN stabil zu betreiben und zu verbessern (Art. 6 Abs. 1 lit. f DSGVO); du kannst widersprechen.

Wenn du widersprechen möchtest, schreib uns an datenschutz@getkern.app.

Möchtest du KERN nicht mehr nutzen, kannst du dein Konto ganz unten in den Einstellungen löschen („Konto löschen“). Deine bisherigen `usage_events`-Einträge bleiben danach bestehen, aber es gibt kein Konto mehr, dem wir sie zuordnen könnten (Datenschutzerklärung, Abschnitt 6). Nutzt du KERN danach doch weiter, entstehen neue Einträge unter einer neuen zufälligen User-ID und damit unter einem neuen Pseudonym.

---

## Änderungs-Historie

- **20.05.2026** - Initial. `usage_events`-Tabelle eingeführt mit 8 Event-Typen.
- **03.11.2026** - Stand nachgezogen: 30 Event-Typen (zuletzt neu: `ai_consent`, Migration 0035), Pseudonymisierung statt „anonym“, die vier eng begrenzten Ausnahmen (Kauf-Auswertung als Summe, Konto-Reparatur, auf Wunsch der Person, rechtliche Pflicht), Konto-Löschen ehrlich beschrieben, `reflection_aborted`, `meditation_completed` und die Onboarding-Felder genauer beschrieben.
