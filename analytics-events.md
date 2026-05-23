# KERN — Anonyme Nutzungs-Metriken (Schema)

**Stand:** 20.05.2026
**Geltungsbereich:** Beta-Phase und darüber hinaus

---

## Zweck

KERN sammelt **anonyme Nutzungs-Zahlen**, um die App besser zu machen — zum Beispiel:
- Sind die Reflexions-Zeichen-Limits zu eng oder zu großzügig?
- Wo brechen User in der geführten Reflexion am häufigsten ab?
- Welche Meditations-Kategorien werden am meisten genutzt?
- Wie lange dauert das Onboarding im Durchschnitt?

**KERN sammelt KEINE Inhalte.** Deine Reflexionen, Affirmationen, Gedanken und Vision-Texte werden niemals in den Analytics-Daten gespeichert.

---

## Was technisch gespeichert wird

Alle Metriken landen in **einer separaten Tabelle** namens `usage_events` (Supabase-Postgres). Diese Tabelle hat per Design **keine Text-Spalten für Inhalte** — nur Zahlen und kontrollierte Enums.

Schema (öffentlich im KERN-Repo einsehbar):
- [`supabase/migrations/0005_usage_events.sql`](https://github.com/denyolo/kern-app/blob/main/supabase/migrations/0005_usage_events.sql)

**Spalten:**

| Spalte | Typ | Was steht drin | Was NICHT drin steht |
|---|---|---|---|
| `id` | UUID | zufällige Zeilen-ID | — |
| `occurred_at` | Timestamp | wann das Event passiert ist | — |
| `event_type` | Text (Enum) | einer von 8 erlaubten Typen (siehe unten) | freie Strings |
| `user_id_hashed` | Text (64 Zeichen Hex) | SHA-256-Hash deiner User-ID mit geheimem Salt | deine echte User-ID, Email, Name |
| `category` | Text (max 64 Zeichen) | z.B. `bodyscan`, `free`, `monthly` | freie User-Eingaben |
| `numeric_1` / `_2` / `_3` | Integer | Zahlen (Zeichen-Anzahl, Sekunden, Counts) | — |
| `session_token` | Text (max 64 Zeichen) | zufällige UUID pro App-Open | User-Identifikation |

**Hard-Constraints in der Datenbank:**
- `event_type` MUSS einer der erlaubten 8 Typen sein (Postgres-CHECK)
- `category` und `session_token` sind auf max 64 Zeichen begrenzt (verhindert dass jemand versucht Inhalte reinzuschmuggeln)
- Niemand außer dem Owner-Konto kann die Tabelle direkt lesen (RLS-Locked)

---

## Die 8 Event-Typen im Detail

### 1. `reflection_completed`
Eine Reflexionssession wurde komplett durchlaufen.
- `category`: `'free'` (Mirror-Chat) oder `'guided'` (vertiefte Reflexion)
- `numeric_1`: Summe aller User-Antwort-**Zeichen** (Länge, nicht Inhalt)
- `numeric_2`: Anzahl Antworten (Turn-Count)
- `numeric_3`: Dauer in Sekunden

### 2. `reflection_aborted`
Eine Reflexion wurde abgebrochen (Discard).
- `category`: `'free'` oder `'guided'`
- `numeric_1`: Summe der bisher geschriebenen User-**Zeichen**
- `numeric_2`: Letzte Frage-Nummer die der User gesehen hat (1-4)

### 3. `affirmation_generated`
Eine Affirmation wurde generiert und gespeichert.
- `numeric_1`: **Zeichen**-Länge des KI-Outputs (nicht der Inhalt)
- `numeric_2`: Wie oft "Neu generieren" geklickt wurde

### 4. `meditation_completed`
Eine Meditation wurde beendet.
- `category`: Meditations-Kategorie (`bodyscan` / `breathwork` / `sleep` / etc.)
- `numeric_1`: Gewählte Dauer in Sekunden
- `numeric_2`: Tatsächlich gehörte Dauer in Sekunden

### 5. `onboarding_completed`
Onboarding wurde abgeschlossen.
- `numeric_1`: Dauer in Sekunden
- `numeric_2`: Anzahl erkannte Lebensbereiche (Zahl)
- `numeric_3`: Anzahl erkannte Blockaden (Zahl)

### 6. `limit_reached`
Ein Free-Tier-Limit wurde erreicht (Rate-Limit-Modal erscheint).
- `category`: `'mirror'` / `'guided'` / `'affirmation'`

### 7. `premium_converted`
Ein Free-User hat ein Premium-Abo abgeschlossen.
- `category`: `'monthly'` / `'yearly'` / `'lifetime'`
- `numeric_1`: Tage seit Account-Erstellung

### 8. `app_session`
Eine App-Nutzungs-Session wurde beendet.
- `numeric_1`: Aktive Nutzungs-Dauer in Sekunden

---

## Wie der User-Hash funktioniert

1. App ruft die Datenbank-Funktion `log_usage_event(...)` auf
2. Funktion liest deine User-ID aus dem Login-Token
3. Funktion kombiniert User-ID mit einem **geheimen Salt** (nur auf dem Server)
4. SHA-256-Hash davon wird gespeichert

**Eigenschaften:**
- Der Hash ist **immer gleich** für dieselbe User-ID — wir können also Cohorts analysieren ("User-Hash-abc hatte 5 Reflexionen und konvertierte nach 14 Tagen")
- Der Hash ist **nicht zurückrechenbar** ohne das Salt
- Das Salt wird **nicht im Code** abgelegt — es lebt nur in einer Postgres-Variable auf dem Server, nicht im öffentlichen GitHub-Repo
- Auch wenn jemand die Tabelle stehlen würde, könnte er nicht herausfinden welche User-ID hinter welchem Hash steht — außer er hätte zusätzlich Server-Zugriff plus alle User-IDs

---

## Wer kann was lesen?

| Akteur | Kann lesen | Kann schreiben |
|---|---|---|
| Du als User | nichts direkt | ja, automatisch beim App-Nutzen (via SECURITY-DEFINER-Funktion) |
| Andere User | nichts | nichts |
| Dennis (Owner-Admin) | aggregierte Statistiken (COUNT, AVG, GROUP BY) | technisch ja, praktisch nicht |
| Externe / Hacker | nichts | nichts |

Der Owner-Admin-Zugriff auf einzelne Rows ist durch die `admin-conduct.md`-Selbstverpflichtung ausgeschlossen — das ist dieselbe Regel die auch für die Inhalts-Tabellen gilt.

---

## Beispiel-Queries die der Owner machen darf

Diese Queries lesen nur **Zusammenfassungen**, keine einzelnen User-Rows:

```sql
-- Wie viele Reflexionen wurden in den letzten 30 Tagen gemacht?
SELECT COUNT(*) FROM usage_events
WHERE event_type = 'reflection_completed'
AND occurred_at > NOW() - INTERVAL '30 days';

-- Durchschnittliche Reflexions-Zeichen-Anzahl?
SELECT AVG(numeric_1) FROM usage_events
WHERE event_type = 'reflection_completed';

-- Wo brechen User in der geführten Reflexion ab?
SELECT numeric_2 AS question_number, COUNT(*) FROM usage_events
WHERE event_type = 'reflection_aborted' AND category = 'guided'
GROUP BY numeric_2 ORDER BY question_number;

-- Welche Meditations-Kategorie am beliebtesten?
SELECT category, COUNT(*) FROM usage_events
WHERE event_type = 'meditation_completed'
GROUP BY category ORDER BY COUNT(*) DESC;
```

---

## Was der Owner explizit NICHT tun darf

```sql
-- VERBOTEN: Einzelne User-Events auflisten (gibt zwar nur Hash, aber widerspricht
-- dem Geist der Selbstverpflichtung — wir sehen Aggregate, nicht Personen)
-- SELECT * FROM usage_events WHERE user_id_hashed = 'abc...';

-- VERBOTEN: Verknüpfung mit Inhalts-Tabellen
-- SELECT * FROM sessions JOIN usage_events ON ...
```

Die `admin-conduct.md`-Verpflichtung gilt sinngemäß auch für die Analytics-Tabelle — wir suchen Verhaltens-Muster, nicht Personen-Profile.

---

## Was wenn du das nicht möchtest?

Aktuell ist das Tracking nicht abschaltbar — es ist Voraussetzung um die App technisch betreiben zu können (Cost-Math, Optimierung). Es enthält **keinerlei Inhalte**, daher gilt es als anonymisierte Nutzungs-Statistik im Sinne der DSGVO.

Wenn du nicht zustimmen kannst:
- Lösche dein Konto in den Einstellungen → "Alle Daten löschen"
- Email an hello@getkern.app mit "Account-Löschung"

In dem Fall werden auch deine bisherigen `usage_events`-Einträge gelöscht (DSGVO-Recht auf Löschung).

---

## Änderungs-Historie

- **20.05.2026** — Initial. `usage_events`-Tabelle eingeführt mit 8 Event-Typen.
