# Datenschutz

**Stand: 18.05.2026**

KERN ist eine App für innere Arbeit — und hier geht es in erster Linie um persönliche Dinge. Deshalb behandeln wir deine Daten so, wie wir selbst behandelt werden wollen: ehrlich, transparent, mit Respekt.

Diese Erklärung sagt dir in einfacher Sprache, was wir speichern, wo das landet, und was wir bewusst **nicht** tun.

---

## Kurzfassung — du bist safe

Bevor die Details kommen, hier in einfacher Sprache, was du wissen darfst:

- **Wir wissen nicht, wer du bist.** Kein Name, keine Email, keine Telefonnummer.
- **Was du der KI schickst, geht anonym.** Anthropic (die Firma hinter der KI) bekommt den Text deiner Reflexion, aber keine Identität, die zu dir zurückführt.
- **Deine Inhalte bleiben deine.** Kein Verkauf, kein KI-Training auf deinen Worten, keine Weitergabe an Dritte.
- **Du wählst, wo deine Daten liegen.** Standard: nur auf deinem iPhone. Optional: verschlüsselt als Backup auf EU-Servern.
- **Kein Drittanbieter-Tracking, keine Werbe-Analytics, keine Cookies.** Auch Push-Notifications laufen komplett lokal auf deinem iPhone — kein Server schaut mit, auch nicht Apple.
- **Anonyme Nutzungs-Metriken** (Anzahl Reflexionen, Durchschnitts-Dauer einer Meditation, Zeichen-Anzahl pro Antwort): Diese **Zahlen** sammeln wir, um KERN besser zu machen. **Keine Inhalte** — wir sehen nie, *was* du reflektierst. Details in [Abschnitt 5](#5-was-wir-anonym-messen-und-was-nicht).
- **Alles löschen geht jederzeit** mit einem Tap in den Einstellungen.

Der Rest dieser Seite erklärt es im Detail, falls du tiefer schauen willst.

---

## 1. Wer ist verantwortlich?

Verantwortlich für die Verarbeitung deiner Daten in dieser App ist:

Dennis Lisk
Brunnenstr. 28
10119 Berlin
Deutschland

E-Mail: hello@getkern.app

Bei Fragen zum Datenschutz schreib uns direkt an: datenschutz@getkern.app

## 2. Was wir speichern

KERN funktioniert mit drei Ebenen von Daten:

### a) Was du in der App tust (lokal auf deinem Gerät)

Diese Daten leben **immer** auf deinem iPhone — egal welche Backup-Wahl du triffst:

- Deine Onboarding-Antworten
- Ziele und Blockaden, die du formulierst
- Reflexionen (frei + geführt)
- Erkenntnisse, die KERN aus deinen Texten zieht
- Affirmationen / Integrationen, die du dir erstellst
- Festgehaltene Gedanken
- Meditations-Sessions (Zeitpunkt, Dauer, Kategorie)
- Einstellungen (Sprache, Stimme, Benachrichtigungen)

**Du gibst uns dabei keine Identifikatoren** — keine Email, kein Name, keine Telefonnummer. Das Profil ist anonym auf deinem Gerät.

### b) Was unsere Server auf jeden Fall sehen — auch ohne Cloud-Backup

Damit KERN überhaupt funktionieren kann (z.B. KI-Antworten generieren, Rate-Limits prüfen), brauchen wir eine technische Identität für dich. Beim ersten App-Start legt KERN deshalb automatisch eine **anonyme User-UUID** auf unseren Servern in Frankfurt an. Diese UUID:

- Ist eine zufällige Zeichenkette — **kein Name, keine Email, keine Telefonnummer**
- Kann nicht zu dir als Person zurückverfolgt werden
- Wird gebraucht, damit dein nächster Reflexions-Spiegel mit deinen früheren in derselben Konversation zusammenhängt

### c) Cloud-Backup (nur wenn du es willst)

Im Onboarding wählst du **zusätzlich**, ob KERN deine *Inhalte* (Reflexionen, Erkenntnisse, Vision, Verlauf) auf unseren Servern spiegelt. Diese Wahl kannst du **jederzeit** in den Einstellungen ändern.

- **Cloud-Backup an**: Deine Inhalte werden auf EU-Servern (Frankfurt, Deutschland) gespeichert — sowohl bei der Übertragung (TLS-Verschlüsselung) als auch im Ruhezustand (AES-256) verschlüsselt. **Wichtig zu wissen**: Wir haben dabei im Notfall technischen Zugriff darauf, weil unser Cloud-Anbieter Supabase die Schlüssel hält. Das ist **keine** End-to-End-Verschlüsselung. End-to-End — bei der selbst wir nicht reinschauen können — bauen wir nach der Beta ein. Wenn du dein iPhone verlierst, kommst du wieder rein.
- **Nur auf diesem Gerät**: Deine *Inhalte* (Reflexionen, Erkenntnisse, Verlauf, Vision) verlassen dein iPhone nicht. Nur die anonyme User-UUID aus Abschnitt b) existiert weiter auf unseren Servern. Maximale Privatsphäre für deine Inhalte, aber kein Recovery wenn das Gerät weg ist.

Bei aktivem Cloud-Backup verarbeiten wir zusätzlich:

- Anmelde-Zeitpunkte (für Account-Wiederherstellung)
- Bei Apple Sign-In: deine Apple-User-ID (gehashed, anonymisiert von Apple)

### d) AI-Antworten (wenn du eine Reflexion machst)

Wenn KERN dir bei einer Reflexion antwortet oder eine Erkenntnis zusammenfasst, wird der Text deiner Reflexion an einen KI-Dienst geschickt. Mehr dazu in Abschnitt 4.

## 3. Wofür wir diese Daten nutzen

- Um die App zum Laufen zu bringen (Verlauf, Stats, Vision-Tracking)
- Um dir KI-gestützte Spiegel zu geben (Mirror, Affirmationen, Erkenntnis-Klassifikation)
- Um deine Daten wiederherstellen zu können, **wenn** du Cloud-Backup gewählt hast
- Für nichts anderes

**Wir nutzen deine Daten nicht für Werbung. Wir verkaufen sie nicht. Wir trainieren keine KI auf deinen Inhalten.**

Rechtsgrundlage: Art. 6 Abs. 1 lit. b DSGVO (Vertragserfüllung — du nutzt die App, wir liefern die Funktion) bzw. Art. 6 Abs. 1 lit. a DSGVO (deine Einwilligung für die Cloud-Wahl).

## 4. Wer bekommt deine Daten zu sehen?

Wir arbeiten mit zwei Auftragsverarbeitern. Das sind die einzigen externen Stellen, die deine Daten technisch verarbeiten:

### Supabase (EU)

- **Sitz der Datenverarbeitung**: Frankfurt am Main, Deutschland (EU)
- **Wozu**: Cloud-Backup deiner Daten + technische Brücke zu Anthropic (AI)
- **Rechtsbasis**: Auftragsverarbeitungsvertrag nach Art. 28 DSGVO
- **Was sie sehen**: Verschlüsselte Daten + technische Metadaten

Supabase ist immer aktiv (für deine anonyme UUID, siehe Abschnitt 2.b). Deine **Inhalte** (Reflexionen, Erkenntnisse, etc.) gehen nur dann zu Supabase, wenn du Cloud-Backup eingeschaltet hast oder wenn KERN gerade eine KI-Antwort für dich holt.

### Anthropic (USA)

- **Sitz**: San Francisco, USA
- **Wozu**: KI-Modelle (Claude) generieren die KERN-Antworten und werten deine Reflexionen aus
- **Was geht raus**: Nur der **Text** deiner aktuellen Reflexion / Frage / Affirmation. Kein Name, keine Email, keine User-ID.
- **Rechtsbasis**: Standardvertragsklauseln (SCC) nach Art. 46 Abs. 2 lit. c DSGVO. Anthropic ist nach eigenen Angaben unter dem EU-US Data Privacy Framework zertifiziert.
- **Was Anthropic NICHT macht**: trainieren auf deinen Inhalten. Das ist im API-Vertrag vertraglich ausgeschlossen.
- **Speicherdauer bei Anthropic**: 30 Tage Operations-Log, danach Löschung. Keine permanente Speicherung der API-Inputs.

**Wenn dir der USA-Transfer trotz SCC zu unsicher ist, kannst du die App weiter benutzen, aber KI-Funktionen (Mirror, automatische Erkenntnis-Extraktion, Affirmations-Generierung) sind dann nicht verfügbar.** Wir bauen aktuell an einer Option, alle KI-Calls auch über EU-gehostete Modelle laufen zu lassen — Update folgt.

### Apple (USA)

Wenn du dich mit Apple Sign-In anmeldest, wickelt Apple den Login ab. Apple sieht dabei nur, dass du KERN benutzt, nicht **was** du eingibst. Details: [apple.com/legal/privacy](https://www.apple.com/legal/privacy/de-ww/).

## 5. Was wir anonym messen — und was **nicht**

> 🔍 **Diese Aussagen sind auditierbar.** Schema, Code-of-Conduct und alle relevanten Datenbank-Migrationen liegen im öffentlichen Repo [kern-legal-docs](https://github.com/denyolo/kern-legal-docs) — mit voller Versions-Historie und Commit-Begründungen. Wenn etwas anders ist als hier beschrieben, kannst du das selbst sehen.

Damit du genau weißt was passiert:

**Was wir an Zahlen messen** (anonym, ohne Inhalte):

- Anzahl der Reflexionen, Affirmationen, Meditationen pro Tag/Monat (aggregiert)
- Durchschnittliche Zeichen-Anzahl deiner Antworten (keine Texte — nur die Länge)
- Wann du eine Reflexion abbrichst (welcher Schritt, ohne Inhalt)
- Welche Meditations-Kategorie wie oft gehört wird
- Wie lange eine Onboarding-Session dauert
- Wann ein Free-Limit erreicht wird
- App-Engagement (wie lange du KERN nutzt pro Session)

Diese Zahlen helfen uns die App zu verbessern (z.B. "ist der Zeichen-Cap zu eng?", "wo brechen User ab?"). Sie landen in einer separaten Datenbank-Tabelle `usage_events`, die per Design **keine Text-Spalten für Inhalte** hat. Deine User-ID wird vor dem Speichern mit einem geheimen Schlüssel **gehasht** — wir sehen also nicht "Anna hatte 5 Reflexionen", sondern "Hash-User-abc hatte 5 Reflexionen".

Schema einsehbar im öffentlichen Legal-Repo: [migrations/0005_usage_events.sql](https://github.com/denyolo/kern-legal-docs/blob/main/migrations/0005_usage_events.sql) (Repo: [kern-legal-docs](https://github.com/denyolo/kern-legal-docs))

**Was wir bewusst nicht tun**:

- Wir nutzen **keine** Drittanbieter-Analytics wie Google Analytics, Mixpanel, Amplitude
- Wir nutzen **keine** Werbe-SDKs (kein Facebook Pixel, kein AppsFlyer, kein AdMob)
- Wir nutzen **keine** Cookies in der App
- Wir nutzen **keine** Tracking-Pixel
- Wir lesen **niemals** den Inhalt deiner Reflexionen, Affirmationen, Gedanken oder Vision-Texte
- Wir verkaufen deine Daten an niemanden, niemals
- Wir geben deine Daten nicht an Behörden weiter, außer es liegt eine rechtskräftige gerichtliche Anordnung vor (siehe Abschnitt 9)

## 6. Wie lange wir deine Daten speichern

- **Lokal auf deinem Gerät**: solange du die App installiert hast. Beim Deinstallieren werden alle lokalen Daten gelöscht (iOS-Standard).
- **In der Cloud (wenn aktiv)**: solange dein Account existiert. Du kannst in den Einstellungen jederzeit "Alle Daten löschen" wählen — dann gehen wir sowohl lokal als auch in der Cloud durch und entfernen alles.
- **AI-Verarbeitungs-Logs bei Anthropic**: max. 30 Tage.

## 7. Deine Rechte (DSGVO)

Du hast jederzeit das Recht auf:

- **Auskunft** über deine bei uns gespeicherten Daten (Art. 15)
- **Berichtigung** falscher Daten (Art. 16)
- **Löschung** ("Recht auf Vergessenwerden", Art. 17)
- **Einschränkung der Verarbeitung** (Art. 18)
- **Datenübertragbarkeit** (Art. 20) — wir geben dir auf Anfrage einen Export im JSON-Format
- **Widerspruch** gegen die Verarbeitung (Art. 21)
- **Widerruf** einer einmal erteilten Einwilligung (Art. 7 Abs. 3) — z.B. Cloud-Backup ausschalten, jederzeit

Für all das: schreib eine kurze Email an datenschutz@getkern.app. Wir antworten innerhalb von 30 Tagen. In den meisten Fällen viel schneller.

**Innerhalb der App:**

- "Alle Daten löschen" findest du in den Einstellungen → Konto. Ein Tap entfernt lokal und (wenn aktiv) in der Cloud alles.
- Die Cloud-Wahl änderst du in Einstellungen → Daten & Privatsphäre.

## 8. Beschwerderecht

Wenn du der Meinung bist, dass wir deine Daten nicht ordentlich behandeln, kannst du dich bei der Datenschutz-Aufsichtsbehörde beschweren. Für KERN zuständig ist:

**Berliner Beauftragte für Datenschutz und Informationsfreiheit (BlnBDI)**
Friedrichstr. 219, 10969 Berlin
Telefon: +49 30 13889-0
E-Mail: mailbox@datenschutz-berlin.de

## 9. Behörden-Anfragen

Wir geben Daten an Behörden nur weiter, wenn wir rechtlich verpflichtet sind — also wenn ein deutsches Gericht oder eine zuständige deutsche Behörde uns nach gültigem Recht dazu zwingt. Wir geben dir in dem Fall Bescheid, soweit das gesetzlich erlaubt ist.

Wir geben **keine** Daten an US-Behörden auf US-Anfragen weiter, weil unsere Daten in der EU liegen und wir nicht der US-Jurisdiktion unterliegen.

## 10. Push-Benachrichtigungen

Wenn du Push-Notifications aktivierst (optional), laufen diese **komplett lokal auf deinem iPhone**. Inhalt und Zeitpunkt werden auf deinem Gerät entschieden — kein Server schaut mit, auch nicht Apple. Apple sieht weder dass du Notifications nutzt, noch wann oder mit welchem Inhalt.

## 11. Änderungen dieser Erklärung

Wenn sich an der Verarbeitung etwas ändert, aktualisieren wir diese Seite und zeigen dir beim nächsten App-Start einen Hinweis. Das Datum ganz oben sagt dir, wann die Erklärung zuletzt geändert wurde.

## 12. Kontakt

Fragen? Sorgen? Schreib uns: hello@getkern.app

Für formale Datenschutz-Anfragen: datenschutz@getkern.app

---

*KERN — Reflektieren · Meditieren · Manifestieren.*
*Deine inneren Bewegungen gehören dir.*
