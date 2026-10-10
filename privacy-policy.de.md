# Datenschutz

**Stand: 09.10.2026**

KERN ist eine App für innere Arbeit - und hier geht es in erster Linie um persönliche Dinge. Deshalb behandeln wir deine Daten so, wie wir selbst behandelt werden wollen: respektvoll.

Diese Erklärung sagt dir in einfacher Sprache, was wir speichern, wo das landet, und was wir bewusst **nicht** tun.

---

## Kurzfassung - du bist safe hier

Bevor die Details kommen, hier in einfacher Sprache, was im Hintergrund passiert.

- **Du startest anonym.** Kein Name, keine E-Mail, keine Telefonnummer. Nur wenn du dein Konto freiwillig mit Apple sicherst, speichern wir die E-Mail-Adresse, die Apple uns dafür übermittelt (auf Wunsch eine anonyme Weiterleitungsadresse von Apple).
- **Was du der KI schickst, geht ohne deine Kennung.** Anthropic (die Firma hinter der KI) bekommt den Text deines Gesprächs und einen kurzen Kontext aus deinen bisherigen Einträgen, aber keine Kennung, die zu deinem Konto führt.
- **Deine Inhalte bleiben deine.** Kein Verkauf, kein KI-Training auf deinen Worten, keine Weitergabe an Dritte.
- **Du wählst, wo deine Daten liegen.** Voreingestellt ist ein **Ende-zu-Ende-verschlüsseltes** Backup auf EU-Servern - **nur dein Gerät kann es lesen, wir nicht.** Alternativ bleiben deine Inhalte nur auf deinem iPhone. Umschalten geht jederzeit in den Einstellungen.
- **Kein Drittanbieter-Tracking, keine Werbe-Analytics, keine Cookies.** Auch Push-Notifications laufen komplett lokal auf deinem iPhone - kein Server schaut mit, auch nicht Apple.
- **Pseudonymisierte Nutzungs-Metriken** (Anzahl Reflexionen, Durchschnitts-Dauer einer Meditation, Zeichen-Anzahl pro Antwort): Diese **Zahlen** sammeln wir unter einem Pseudonym statt deiner User-ID, um KERN besser zu machen. **Keine Inhalte** - wir sehen nie, *was* du reflektierst. Details in [Abschnitt 5](#5-was-wir-pseudonymisiert-messen---und-was-nicht).
- **Dein Konto löschen geht jederzeit** in den Einstellungen - mit allen Inhalten, lokal und in der Cloud.

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

Diese Daten leben **immer** auf deinem iPhone - egal welche Backup-Wahl du triffst:

- Deine Onboarding-Antworten
- Ziele, Lebensbereiche und Blockaden, die du formulierst
- Reflexionen (frei + geführt)
- Erkenntnisse, die KERN aus deinen Texten zieht
- Sichtweisen (neue Glaubenssätze), die du formulierst
- Festgehaltene Gedanken
- Meditations-Sessions (Zeitpunkt, Dauer, Kategorie)
- Kurs-Fortschritt
- Einstellungen (Sprache, Stimme, Benachrichtigungen)

**Für die Nutzung brauchst du keine Identifikatoren** - keine E-Mail, kein Name, keine Telefonnummer. Das Profil ist anonym auf deinem Gerät (zur freiwilligen Sicherung mit Apple siehe Abschnitt b).

### b) Was unsere Server auf jeden Fall sehen - auch ohne Cloud-Backup

Damit KERN überhaupt funktionieren kann (z.B. KI-Antworten generieren, Nutzungsgrenzen prüfen), brauchen wir eine technische Identität für dich. Beim ersten App-Start legt KERN deshalb automatisch eine **anonyme User-UUID** auf unseren Servern in Frankfurt an. Diese UUID:

- Ist eine zufällige Zeichenkette - **kein Name, keine E-Mail, keine Telefonnummer**
- Lässt sich nicht dir als Person zuordnen, solange du KERN anonym nutzt
- Wird gebraucht, um Nutzungsgrenzen und deinen Abo-Status zu prüfen und - wenn aktiv - dein Backup deinem Konto zuzuordnen

Zu dieser UUID speichert unser Server außerdem technische Angaben: Anmelde-Zeitpunkte, deine Nutzungszähler (für die Grenzen der kostenlosen Version) und deinen Abo-Status (ob Premium aktiv ist, bis wann und welches Abo).

**Optional: Konto mit Apple sichern.** Wenn du dein Konto freiwillig mit „Mit Apple anmelden" sicherst (im Onboarding, beim Wiederherstellen oder in den Einstellungen), fragt KERN bei Apple nach deiner E-Mail-Adresse und deinem Namen. Gespeichert werden bei uns (im Anmeldedienst von Supabase) die E-Mail-Adresse, die Apple uns übermittelt, und eine von Apple vergebene Anmelde-Kennung. Wählst du bei Apple „E-Mail-Adresse verbergen", ist das eine anonyme Weiterleitungsadresse von Apple. **Deinen Namen speichern wir nicht.** Zweck: Damit du dich wieder anmelden und dein Konto auf einem neuen Gerät wiederherstellen kannst. Dein Konto ist damit nicht mehr anonym, sondern mit dieser E-Mail-Adresse verknüpft.

### c) Cloud-Backup

Im Onboarding wählst du **zusätzlich**, ob KERN deine *Inhalte* (Reflexionen, Erkenntnisse, Ziele, Verlauf) auf unseren Servern sichert. Voreingestellt (und im Onboarding vorausgewählt) ist das verschlüsselte Backup. Diese Wahl kannst du **jederzeit** in den Einstellungen ändern.

- **Cloud-Backup an**: Deine Inhalte werden **auf deinem iPhone verschlüsselt, bevor sie unsere Server erreichen** (Ende-zu-Ende, AES-256-GCM); zusätzlich ist die Übertragung TLS-gesichert. Auf den EU-Servern (Frankfurt, Deutschland) liegen deine **Inhalte** damit **nur als unlesbarer Chiffretext** - **selbst wir können sie nicht lesen**, auch nicht im Notfall, auch wenn wir wollten. Lesbar bleiben nur technische Angaben, die KERN zum Zählen und Sortieren braucht: Zeitpunkte, Dauer und Kategorie einer Meditation, Bewertungen und Skalenwerte (z.B. wie nah du dich einem Ziel fühlst), der Status eines Eintrags (z.B. erledigt, aufgelöst oder verborgen) und die Gesamtzahlen deiner Reise. Der Schlüssel liegt ausschließlich in deinem **iCloud-Schlüsselbund** (Apple synct ihn Ende-zu-Ende zwischen deinen Geräten); KERN sieht ihn nie. **Eine bewusste Ausnahme**: Wenn KERN dir mit der KI antwortet, gehen der dafür nötige Text und ein kurzer Kontext aus deinen bisherigen Einträgen (siehe Abschnitt d) im Klartext (TLS-gesichert, aber nicht Ende-zu-Ende) durch unseren Server zur KI. **Unser Server reicht sie nur durch und speichert sie nicht**; bei Anthropic gelten die Fristen aus Abschnitt 4. Recovery läuft über deinen iCloud-Schlüsselbund: solange der aktiv ist, kommst du auf einem neuen Gerät wieder an deine Inhalte. Ist er aus und dein Gerät weg, sind die verschlüsselten Inhalte nicht wiederherstellbar - das ist der Preis echter Vertraulichkeit.
- **Nur auf diesem Gerät**: Deine *Inhalte* (Reflexionen, Erkenntnisse, Verlauf, Ziele) werden nicht in der Cloud gesichert. Sie verlassen dein iPhone nur kurz, wenn KERN dir mit der KI antwortet (Abschnitt d). Auf unseren Servern bleiben dann nur die technischen Daten aus Abschnitt b) und die pseudonymisierten Nutzungs-Metriken aus Abschnitt 5. Maximale Privatsphäre für deine Inhalte, aber kein Recovery wenn das Gerät weg ist.

### d) KI-Antworten (wenn KERN dir antwortet)

Wenn KERN dir antwortet, etwa im Gespräch, bei neuen Sichtweisen, Zusammenfassungen, Rückblicken oder Kurs-Texten, schickt unser Server den dafür nötigen Text an Anthropic (Hersteller des KI-Modells Claude): den Text, um den es gerade geht, plus einen kurzen Kontext aus deinen bisherigen Einträgen (z.B. deine Antworten aus dem Einstieg, deine „Über dich"-Zusammenfassung, Ziele, Lebensbereiche, Blockaden, deine letzten Erkenntnisse sowie Auszüge aus deinen letzten Reflexionen und Gedanken), damit die Antwort zu dir passt. **Eine Konto-Kennung geht dabei nicht mit** - Anthropic erfährt nicht, zu welchem Konto die Anfrage gehört. Laut den Bedingungen des Anbieters trainiert Anthropic **nicht** auf diesen Inhalten und löscht sie in der Regel innerhalb von 30 Tagen. Die Übertragung läuft TLS-verschlüsselt. Mehr Details in Abschnitt 4.

## 3. Wofür wir diese Daten nutzen

- Um die App zum Laufen zu bringen (Verlauf, Statistiken, Fortschritt bei deinen Zielen)
- Um dir KI-gestützte Antworten zu geben (KERNs Gesprächsfunktion, Sichtweisen, Zusammenfassungen, Erkenntnis-Klassifikation)
- Um deine Daten wiederherstellen zu können, **wenn** du Cloud-Backup gewählt hast
- Um dein Konto wiederherzustellen, **wenn** du es mit Apple gesichert hast
- Um Käufe und deinen Abo-Status abzuwickeln
- Um KERN mit pseudonymisierten Nutzungszahlen zu verbessern (siehe Abschnitt 5)
- Für nichts anderes

**Wir nutzen deine Daten nicht für Werbung. Wir verkaufen sie nicht. Wir trainieren keine KI auf deinen Inhalten.**

Rechtsgrundlage: Art. 6 Abs. 1 lit. b DSGVO (Vertragserfüllung - du nutzt die App, wir liefern die Funktion) bzw. Art. 6 Abs. 1 lit. a DSGVO (deine Einwilligung für die Cloud-Wahl).

## 4. Wer bekommt deine Daten zu sehen?

Wir arbeiten mit drei Auftragsverarbeitern: Supabase, Anthropic und RevenueCat. Das sind die einzigen externen Stellen, die deine Daten in unserem Auftrag technisch verarbeiten. Daneben verarbeitet Apple als Plattform-Anbieter einige Daten in eigener Verantwortung (siehe unten).

### Supabase (EU)

- **Sitz der Datenverarbeitung**: Frankfurt am Main, Deutschland (EU)
- **Wozu**: Cloud-Backup deiner Daten, Anmeldung + technische Brücke zu Anthropic (KI)
- **Rechtsbasis**: Auftragsverarbeitungsvertrag nach Art. 28 DSGVO
- **Was sie sehen**: Verschlüsselte Inhalte + lesbare technische Angaben (UUID, Anmelde-Zeitpunkte, Nutzungszähler, Abo-Status und die in Abschnitt 2.c genannten Zeit-, Dauer- und Skalenwerte) und - wenn du dein Konto mit Apple sicherst - deine E-Mail-Adresse

Supabase ist immer aktiv (für deine anonyme UUID, siehe Abschnitt 2.b). Deine **Inhalte** (Reflexionen, Erkenntnisse, etc.) gehen nur dann zu Supabase, wenn du Cloud-Backup eingeschaltet hast (dann verschlüsselt) oder wenn KERN gerade eine KI-Antwort für dich holt.

### Anthropic (USA)

- **Sitz**: San Francisco, USA
- **Wozu**: KI-Modelle (Claude) generieren die KERN-Antworten und werten deine Reflexionen aus
- **Was geht raus**: Der Text, um den es gerade geht (z.B. dein Gespräch mit KERN, eine Blockade, zu der du neue Sichtweisen formulierst, oder deine Einträge für einen Rückblick), plus ein kurzer Kontext aus deinen bisherigen Einträgen (siehe Abschnitt 2.d). **Keine Konto-Kennung, keine E-Mail-Adresse.** Die Anfrage läuft über unseren Server, deshalb sieht Anthropic auch nicht die IP-Adresse deines Geräts.
- **Rechtsbasis**: Standardvertragsklauseln (SCC) nach Art. 46 Abs. 2 lit. c DSGVO.
- **Was Anthropic NICHT macht**: auf deinen Inhalten trainieren. Laut den Bedingungen des Anbieters ist das für Inhalte, die über die API geschickt werden, ausgeschlossen.
- **Speicherdauer bei Anthropic**: Laut den Bedingungen des Anbieters werden Eingaben und Antworten in der Regel innerhalb von 30 Tagen gelöscht. Länger nur in Ausnahmefällen, z.B. wenn eine Anfrage als Verstoß gegen Anthropics Nutzungsrichtlinien markiert wird oder eine gesetzliche Pflicht besteht.

**Wenn dir der USA-Transfer trotz SCC zu unsicher ist, kannst du die App weiter benutzen, aber KI-Funktionen (KERNs Gesprächsfunktion, automatische Erkenntnis-Extraktion, Sichtweisen-Generierung) sind dann nicht verfügbar.**

### RevenueCat (USA)

- **Sitz**: San Francisco, USA (Datenverarbeitung auf Servern in den USA)
- **Wozu**: Abwicklung und Prüfung von Käufen und Abos (KERN Premium) zusammen mit dem App Store
- **Was sie sehen**: Deine anonyme User-UUID (aus Abschnitt 2.b), Kauf- und Abo-Daten aus dem App Store (z.B. Produkt, Kaufdatum, Laufzeit, Status) und technische Angaben wie App-Version und Betriebssystem. Weil die App beim Start mit deiner UUID bei RevenueCat nachfragt, ob ein Abo aktiv ist, kennt RevenueCat sie auch, wenn du nichts kaufst. **Keine Inhalte** aus deinen Reflexionen, keine Zahlungsdaten (die bleiben bei Apple).
- **Was zurückkommt**: RevenueCat meldet Änderungen an deinem Abo an unseren Server. Dort speichern wir nur, ob Premium aktiv ist, bis wann, welches Abo, woher der Eintrag stammt (über RevenueCat oder eine manuelle Freischaltung durch uns) und wann er sich zuletzt geändert hat.
- **Rechtsbasis**: Art. 6 Abs. 1 lit. b DSGVO (Vertragserfüllung - du kaufst ein Abo, wir schalten es frei). Auftragsverarbeitungsvertrag nach Art. 28 DSGVO; die Übermittlung in die USA ist über die darin enthaltenen Standardvertragsklauseln (Art. 46 Abs. 2 lit. c DSGVO) abgesichert.

### Apple (USA)

Wenn du dich mit Apple Sign-In anmeldest, wickelt Apple den Login ab. Apple sieht dabei nur, dass du KERN benutzt, nicht **was** du eingibst. Käufe und Abos laufen über den App Store - deine Zahlungsdaten bleiben bei Apple, wir sehen sie nicht. Details: [apple.com/legal/privacy](https://www.apple.com/legal/privacy/de-ww/).

**Spracheingabe:** Wenn du statt zu tippen sprichst, nutzt KERN die Spracherkennung von Apple. Die Umwandlung in Text übernimmt Apple - je nach Gerät und Einstellungen direkt auf deinem iPhone oder auf Apples Servern. KERN speichert keine Audioaufnahmen; nur der erkannte Text landet in deinem Eingabefeld. Die Spracheingabe ist freiwillig, iOS fragt vorher nach deiner Erlaubnis für Mikrofon und Spracherkennung.

## 5. Was wir pseudonymisiert messen - und was **nicht**

> 🔍 **Diese Aussagen sind auditierbar.** Schema, Code-of-Conduct und alle relevanten Datenbank-Migrationen liegen im öffentlichen Repo [kern-legal-docs](https://github.com/denyolo/kern-legal-docs) - mit voller Versions-Historie und Commit-Begründungen. Wenn etwas anders ist als hier beschrieben, kannst du das selbst sehen.

Damit du genau weißt was passiert:

**Was wir an Zahlen messen** (pseudonymisiert, ohne Inhalte):

- Anzahl der Reflexionen, Sichtweisen, Meditationen pro Tag/Monat (aggregiert)
- Durchschnittliche Zeichen-Anzahl deiner Antworten (keine Texte - nur die Länge)
- Wann du eine Reflexion abbrichst (welcher Schritt, ohne Inhalt)
- Welche Meditations-Kategorie wie oft gehört wird
- Wie lange eine Onboarding-Session dauert
- Wann ein Free-Limit erreicht wird
- App-Engagement (wie lange du KERN nutzt pro Session)
- Kurs-Fortschritt, Aufrufe der Abo-Seite, ob das Erklärvideo angesehen wurde, Daumen hoch/runter für eine Meditation und ob du KERN weiterempfohlen hast - jeweils ohne Inhalte

Diese Zahlen helfen uns die App zu verbessern (z.B. "ist der Zeichen-Cap zu eng?", "wo brechen User ab?"). Sie landen in einer separaten Datenbank-Tabelle `usage_events`, die per Design **keine Text-Spalten für Inhalte** hat - nur Ereignis-Typ, Zeitpunkt, Kategorie, Zahlen und eine Sitzungs-Kennung, die bei jedem Öffnen der App neu zufällig erzeugt wird. Deine User-ID wird vor dem Speichern zusammen mit einem geheimen Schlüssel **gehasht** - wir sehen also nicht "Anna hatte 5 Reflexionen", sondern "Hash-User-abc hatte 5 Reflexionen". Das ist eine **Pseudonymisierung**, keine Anonymisierung: Die Einträge stehen unter einem Pseudonym statt unter deiner User-ID, aber mit dem geheimen Schlüssel ließe sich technisch prüfen, zu welcher User-ID ein Eintrag gehört. Die Zahlen werden unabhängig von deiner Backup-Wahl erfasst.

Schema einsehbar im öffentlichen Legal-Repo: [migrations/0005_usage_events.sql](https://github.com/denyolo/kern-legal-docs/blob/main/migrations/0005_usage_events.sql) und [migrations/0006_telemetry_hash_fix.sql](https://github.com/denyolo/kern-legal-docs/blob/main/migrations/0006_telemetry_hash_fix.sql) (Repo: [kern-legal-docs](https://github.com/denyolo/kern-legal-docs))

**Was wir bewusst nicht tun**:

- Wir nutzen **keine** Drittanbieter-Analytics wie Google Analytics, Mixpanel, Amplitude
- Wir nutzen **keine** Werbe-SDKs (kein Facebook Pixel, kein AppsFlyer, kein AdMob)
- Wir nutzen **keine** Cookies in der App
- Wir nutzen **keine** Tracking-Pixel
- Wir lesen **niemals** den Inhalt deiner Reflexionen, Sichtweisen, Gedanken oder Ziele
- Wir verkaufen deine Daten an niemanden, niemals
- Wir geben deine Daten nicht an Behörden weiter, außer es liegt eine rechtskräftige gerichtliche Anordnung vor (siehe Abschnitt 9)

## 6. Wie lange wir deine Daten speichern

- **Lokal auf deinem Gerät**: solange du die App installiert hast. Beim Deinstallieren löscht iOS die App-Daten. Im Schlüsselbund deines iPhones bleiben dabei zwei kleine Einträge erhalten: deine Anmeldung (damit dein Konto nach einer Neuinstallation wieder da ist) und - falls du Cloud-Backup nutzt - dein Backup-Schlüssel in deinem iCloud-Schlüsselbund.
- **In der Cloud (wenn aktiv)**: solange dein Konto existiert. Du kannst in den Einstellungen jederzeit "Konto löschen" wählen - dann löschen wir dein Konto mit allen Inhalten, lokal und in der Cloud, inklusive einer Apple-Verknüpfung und der dafür gespeicherten E-Mail-Adresse. Dein Backup-Schlüssel bleibt in deinem iCloud-Schlüsselbund, weil er für alle KERN-Konten deiner Apple-ID gilt; nach dem Löschen gibt es keine Daten mehr, die er entschlüsseln könnte.
- **Pseudonymisierte Nutzungs-Metriken (Abschnitt 5)**: bleiben auch nach dem Löschen deines Kontos bestehen. Sie enthalten keine Inhalte und keine User-ID im Klartext. Weil dein Konto danach nicht mehr existiert, gibt es kein Konto mehr, dem wir sie zuordnen könnten.
- **Kauf- und Abo-Daten bei RevenueCat und Apple**: nach den Bedingungen dieser Anbieter. "Konto löschen" in KERN löscht sie dort nicht automatisch mit.
- **KI-Verarbeitungs-Logs bei Anthropic**: laut den Bedingungen des Anbieters in der Regel bis zu 30 Tage (Ausnahmen siehe Abschnitt 4).

## 7. Deine Rechte (DSGVO)

Du hast jederzeit das Recht auf:

- **Auskunft** über deine bei uns gespeicherten Daten (Art. 15)
- **Berichtigung** falscher Daten (Art. 16)
- **Löschung** ("Recht auf Vergessenwerden", Art. 17)
- **Einschränkung der Verarbeitung** (Art. 18)
- **Datenübertragbarkeit** (Art. 20) - wir geben dir auf Anfrage einen Export der bei uns gespeicherten Daten im JSON-Format. Deine Inhalte sind darin verschlüsselt, weil nur dein Gerät sie lesen kann.
- **Widerspruch** gegen die Verarbeitung (Art. 21)
- **Widerruf** einer einmal erteilten Einwilligung (Art. 7 Abs. 3) - z.B. Cloud-Backup ausschalten, jederzeit

Für all das: schreib eine kurze Email an datenschutz@getkern.app. Wir antworten innerhalb von 30 Tagen. In den meisten Fällen viel schneller.

**Innerhalb der App:**

- "Konto löschen" findest du ganz unten in den Einstellungen. Nach einer Bestätigung löscht es dein Konto mit allen Inhalten, lokal und (wenn aktiv) in der Cloud, inklusive einer Apple-Verknüpfung.
- Die Cloud-Wahl änderst du in Einstellungen → App-Einstellungen → Daten & Privatsphäre.

## 8. Beschwerderecht

Wenn du der Meinung bist, dass wir deine Daten nicht ordentlich behandeln, kannst du dich bei der Datenschutz-Aufsichtsbehörde beschweren. Für KERN zuständig ist:

**Berliner Beauftragte für Datenschutz und Informationsfreiheit (BlnBDI)**
Friedrichstr. 219, 10969 Berlin
Telefon: +49 30 13889-0
E-Mail: mailbox@datenschutz-berlin.de

## 9. Behörden-Anfragen

Wir geben Daten an Behörden nur weiter, wenn wir rechtlich verpflichtet sind - also wenn ein deutsches Gericht oder eine zuständige deutsche Behörde uns nach gültigem Recht dazu zwingt. Wir geben dir in dem Fall Bescheid, soweit das gesetzlich erlaubt ist.

Wir geben **keine** Daten an US-Behörden auf US-Anfragen weiter, weil die Daten, die wir selbst speichern, in der EU liegen und wir nicht der US-Jurisdiktion unterliegen.

## 10. Push-Benachrichtigungen

Wenn du Push-Notifications aktivierst (optional), laufen diese **komplett lokal auf deinem iPhone**. Inhalt und Zeitpunkt werden auf deinem Gerät entschieden - kein Server schaut mit, auch nicht Apple. Apple sieht weder dass du Notifications nutzt, noch wann oder mit welchem Inhalt.

## 11. Für wen KERN gedacht ist

KERN richtet sich an Erwachsene ab 18 Jahren. Bist du jünger, nutze KERN bitte nicht. Wir fragen kein Alter ab und erheben wissentlich keine Daten von Kindern und Jugendlichen. Ein bestehendes Konto kannst du jederzeit ganz unten in den Einstellungen löschen.

## 12. Änderungen dieser Erklärung

Wenn sich an der Verarbeitung etwas ändert, aktualisieren wir diese Seite. Das Datum ganz oben sagt dir, wann die Erklärung zuletzt geändert wurde.

## 13. Kontakt

Fragen? Sorgen? Schreib uns: hello@getkern.app

Für formale Datenschutz-Anfragen: datenschutz@getkern.app

---

*KERN - Reflektieren · Meditieren · Manifestieren.*
*Deine inneren Bewegungen gehören dir.*
