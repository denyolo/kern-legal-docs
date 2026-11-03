# Datenschutz

**Stand: 03.11.2026**

KERN ist eine App für innere Arbeit - und hier geht es in erster Linie um persönliche Dinge. Deshalb behandeln wir deine Daten so, wie wir selbst behandelt werden wollen: respektvoll.

Diese Erklärung sagt dir in einfacher Sprache, was wir speichern, wo das landet, und was wir bewusst **nicht** tun.

---

## Kurzfassung - du bist safe hier

Bevor die Details kommen, hier in einfacher Sprache, was im Hintergrund passiert.

- **Du startest ohne Konto-Angaben.** Kein Name, keine E-Mail, keine Telefonnummer. KERN kennt dich nur unter einer zufälligen Kennung. Nur wenn du dein Konto freiwillig mit Apple sicherst, speichern wir die E-Mail-Adresse, die Apple uns dafür übermittelt (auf Wunsch eine anonyme Weiterleitungsadresse von Apple).
- **In der Cloud kannst nur du lesen, was du in KERN schreibst.** Dort liegen deine Texte verschlüsselt, den Schlüssel hast nur du. Auch wir können sie nicht lesen. Wir verkaufen deine Daten nicht und trainieren keine KI mit deinen Worten. Weitergegeben wird nur an die Dienste, die KERN für seine Funktionen braucht (Abschnitt 4), und an Behörden nur, wenn wir rechtlich dazu verpflichtet sind (Abschnitt 9).
- **Die KI bekommt deinen Text, aber keinen Namen dazu.** Damit KERN dir antworten kann, geht dein Text mit etwas Kontext aus deinen Einträgen an die KI von Anthropic. Einen Namen, eine E-Mail oder eine Kennung, die zu dir führt, schickt KERN dabei nicht mit. Laut Anthropic wird dein Text nicht zum Training genutzt. Bevor Text an die KI geht, fragt KERN dich um Erlaubnis.
- **Du wählst, wo deine Daten liegen.** Voreingestellt ist ein **Ende-zu-Ende-verschlüsseltes** Backup auf EU-Servern - **nur dein Gerät kann deine Inhalte darin lesen, wir nicht.** Alternativ bleiben deine Inhalte nur auf deinem iPhone. Umschalten kannst du in den Einstellungen.
- **Kein Drittanbieter-Tracking, keine Werbe-Analytics, keine Cookies.** Erinnerungen plant und zeigt dein iPhone selbst, ohne Push-Server.
- **Nur Zahlen, nie Inhalte.** Wie viele Reflexionen entstehen, wie lange Meditationen dauern, wie lang Antworten sind: Diese Zahlen helfen uns, KERN besser zu machen. Sie stehen unter einem Decknamen statt unter deiner Kennung (das meint „pseudonymisiert“), und was du schreibst, ist nie dabei. Details in [Abschnitt 5](#5-was-wir-pseudonymisiert-messen---und-was-nicht).
- **Dein Konto löschen geht jederzeit** in den Einstellungen - mit allen Inhalten, lokal und in der Cloud. In unseren täglichen Datenbank-Sicherungen ist es danach noch bis zu 7 Tage enthalten.

Der Rest dieser Seite erklärt es im Detail, falls du tiefer schauen willst.

---

## 1. Wer ist verantwortlich?

Verantwortlich für die Verarbeitung deiner Daten in dieser App und auf unserer Website ist:

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
- Wann du Wissens-Artikel geöffnet hast
- Einstellungen (Sprache, Stimme, Benachrichtigungen)

**Für die Nutzung brauchst du keine Angaben zu deiner Person** - keine E-Mail, kein Name, keine Telefonnummer (zur freiwilligen Sicherung mit Apple siehe Abschnitt b).

### b) Was unsere Server auf jeden Fall sehen - auch ohne Cloud-Backup

Damit KERN überhaupt funktionieren kann (z.B. KI-Antworten generieren, Nutzungsgrenzen prüfen), brauchen wir eine technische Identität für dich. Beim ersten App-Start legt KERN deshalb automatisch eine **zufällige User-UUID** auf unseren Servern in Frankfurt an. Diese UUID:

- Ist eine zufällige Zeichenkette - **kein Name, keine E-Mail, keine Telefonnummer**
- Verweist für sich genommen nicht auf dich als Person - einen Namen oder eine E-Mail-Adresse kennen wir dazu nicht, es sei denn, du sicherst dein Konto mit Apple oder schickst uns deine Kennung selbst (z.B. mit einer Anfrage per E-Mail)
- Wird gebraucht, um Nutzungsgrenzen und deinen Abo-Status zu prüfen und - wenn aktiv - dein Backup deinem Konto zuzuordnen

Zu dieser UUID speichert unser Server außerdem technische Angaben: wann du dich angemeldet hast (dazu zählt auch die automatische Anmeldung beim ersten Start), zu jeder Anmeldung die IP-Adresse und eine technische Beschreibung von App und Betriebssystem (der sogenannte User-Agent, z.B. App- und iOS-Version), deine Nutzungszähler (für die Grenzen der kostenlosen Version) und deinen Abo-Status (ob Premium aktiv ist, bis wann und welches Abo). Solange du KERN nutzt, verlängert die App deine Anmeldung automatisch. Dabei ersetzt unser Server IP-Adresse und User-Agent jedes Mal durch die aktuellen Werte und speichert, wann das zuletzt war. Die Angaben zu einer Anmeldung bleiben gespeichert, bis diese Anmeldung endet, etwa wenn du dich abmeldest, spätestens bis du dein Konto löschst (eine Ausnahme steht weiter unten in diesem Abschnitt).

**Optional: Konto mit Apple sichern.** Wenn du dein Konto freiwillig mit „Mit Apple anmelden“ sicherst (im Onboarding, beim Wiederherstellen oder in den Einstellungen), fragt KERN bei Apple nach deiner E-Mail-Adresse und deinem Namen. Gespeichert werden bei uns (im Anmeldedienst von Supabase) die E-Mail-Adresse, die Apple uns übermittelt, und eine von Apple vergebene Anmelde-Kennung. Wählst du bei Apple „E-Mail-Adresse verbergen“, ist das eine anonyme Weiterleitungsadresse von Apple. **Deinen Namen speichern wir nicht.** Zweck: Damit du dich wieder anmelden und dein Konto auf einem neuen Gerät wiederherstellen kannst. Dein Konto ist damit mit dieser E-Mail-Adresse verknüpft.

**Wenn du dein Konto schon mit Apple gesichert hast.** Etwa auf einem neuen Gerät oder nach dem Abmelden legt KERN automatisch eine neue Kennung an (eine User-UUID wie oben), bevor es wissen kann, dass du schon ein Konto hast. Meldest du dich dann mit Apple an, gehören in der Regel zwei Kennungen zu einer Person, zu dir: die deines Kontos und die automatische. Die automatische Kennung trägt keinen Namen und keine E-Mail-Adresse, und deine Inhalte darunter sind verschlüsselt, wir können sie nicht lesen. Weil diese Kennung trotzdem zu dir gehört, steht hier, was mit ihr passiert:

- **Was unter der automatischen Kennung gesichert ist:** Holst du dein Konto zurück, bleibt es unverändert, und KERN löscht diese Einträge, auch von deinem iPhone. Ist dein Konto noch leer, ziehen sie in dein Konto um und gehören damit zu deiner Anmeldung mit Apple. Das Gleiche gilt, wenn du beim Anmelden „Hier neu anfangen“ wählst, nur löscht KERN vorher, was bisher in deinem Konto lag. Hast du in diesen beiden Fällen „Nur auf diesem Gerät“ gewählt, zieht nichts um: KERN löscht nur die Kopie dieser Einträge auf unseren Servern, und sie bleiben auf deinem iPhone.
- **Die automatische Kennung selbst:** Danach löschen wir sie samt den Angaben zu ihren Anmeldungen, ihren Nutzungszählern und ihrem Eintrag bei RevenueCat, unserem Dienst für Abos (Abschnitt 4). Das läuft im Hintergrund. Klappt es gerade nicht, etwa ohne Netz, versucht KERN es beim nächsten Öffnen der App noch einmal.
- **Läuft unter ihr noch ein Abo oder eine Freischaltung:** Die Einträge unter ihr ziehen trotzdem um oder werden gelöscht, wie oben beschrieben. Nur die automatische Kennung bleibt bestehen, weil das Abo an ihr hängt, mit den eben genannten Angaben und ihrem Abo-Status, solange es läuft, auch wenn du dein Konto löschst. Danach löschen wir sie bei einer regelmäßigen Prüfung.
- **Zur Sicherheit:** Dieses Aufräumen läuft seit KERN 1.2.7 von selbst. Für eine frühere Anmeldung, oder wenn du sichergehen möchtest, schreib uns mit deiner aktuellen Kennung aus Einstellungen → Sicherheit an datenschutz@getkern.app. Wir suchen dann nach der früheren automatischen Kennung und löschen sie. Weil sie keinen Namen trägt, geht das nur über technische Angaben wie Zeitpunkte, nie über Inhalte (Abschnitt 5), und klappt nicht immer.

### c) Cloud-Backup

Ob KERN deine *Inhalte* (Reflexionen, Erkenntnisse, Ziele, Verlauf) zusätzlich auf unseren Servern sichert, entscheidest du. Bis du gewählt hast, ist das verschlüsselte Backup eingeschaltet - auch wenn du dich in KERN erst umschaust oder meditierst, bevor du im Gespräch von dir erzählst. Im Onboarding fragt KERN dich danach, das verschlüsselte Backup ist dort vorausgewählt. Später änderst du die Wahl unter Einstellungen → App-Einstellungen → Daten & Privatsphäre.

**Cloud-Backup an**

Deine Inhalte werden **auf deinem iPhone verschlüsselt, bevor sie unsere Server erreichen** (Ende-zu-Ende, AES-256-GCM); zusätzlich ist die Übertragung TLS-gesichert. Auf den EU-Servern (Frankfurt, Deutschland) liegen deine **Inhalte** damit **nur als unlesbarer Chiffretext** - **selbst wir können sie nicht lesen**, auch nicht im Notfall, auch wenn wir wollten.

Der Schlüssel liegt in deinem **iCloud-Schlüsselbund** (Apple synct ihn Ende-zu-Ende zwischen deinen Geräten) und sonst nur dort, wo du selbst eine Kopie ablegst (Einstellungen → Sicherheit → „Schlüssel sichern“); KERN sieht ihn nie. Auf einem neuen Gerät kommst du wieder an deine Inhalte, wenn dein Konto mit Apple gesichert ist und dein iCloud-Schlüsselbund aktiv ist. Ist er aus und dein Gerät weg, brauchst du zusätzlich einen Schlüssel, den du vorher selbst gesichert hast. Ohne ihn sind die Inhalte nicht wiederherstellbar - das ist der Preis echter Vertraulichkeit. Ohne Apple-Sicherung findet ein neues Gerät dein Konto in der Regel nicht, auch wenn der Schlüssel dort ankommt.

**Eine bewusste Ausnahme**: Wenn KERN dir mit der KI antwortet, gehen der dafür nötige Text und ein kurzer Kontext aus deinen bisherigen Einträgen (siehe Abschnitt d) im Klartext (TLS-gesichert, aber nicht Ende-zu-Ende) durch unseren Server zur KI. **Unser Server reicht sie nur durch und speichert sie nicht**; bei Anthropic gelten die Fristen aus Abschnitt 4.

Lesbar bleiben technische Angaben, keine deiner Texte. KERN braucht sie zum Zählen, Sortieren und Wiederherstellen:

- Zeitpunkte (z.B. wann ein Eintrag entstanden ist, aufgelöst oder geübt wurde)
- Welche Art Eintrag es ist (z.B. Meditation, Reflexion oder Gedanke)
- Wie lange eine Meditation oder Reflexion gedauert hat, die gewählte Länge und Kategorie einer Meditation
- Welche Wissens-Artikel du ausgeblendet hast
- Welche Kurse du abgeschlossen hast und wann du sie begonnen hast (damit der Vorschlag, KERN weiterzuempfehlen, am Kursende nur einmal erscheint)
- Bewertungen und Skalenwerte (z.B. wie nah du dich einem Ziel fühlst oder wie stimmig sich eine Sichtweise anfühlt)
- Wie oft du eine Sichtweise geübt hast
- Der Status eines Eintrags (z.B. erreicht, aufgelöst oder verborgen)
- Welche Einträge zusammengehören (nur als Kennungen, z.B. welches Ziel zu welchem Lebensbereich gehört)
- Deine Einstellungen (z.B. Sprache, Stimme, Erinnerungszeiten) und wann du der KI zugestimmt hast
- Die Gesamtzahlen deiner Reise

Zwei technische Eigenheiten der Verschlüsselung: Wie lang ein verschlüsselter Text ungefähr ist, lässt sich an der Chiffre ablesen, sein Inhalt nicht. Und die Kennung, unter der eine Blockade in der Cloud liegt, berechnet KERN seit Version 1.2.7 auf deinem Gerät aus ihrem Text und deinem Schlüssel. Ohne den Schlüssel verrät sie nichts über den Text. Ältere Einträge stellt KERN um, sobald du die neue Version mit eingeschaltetem Backup nutzt. Bis dahin ist ihre Kennung nur aus dem Text berechnet: Zurückrechnen lässt er sich daraus nicht; wer Zugriff auf die Datenbank hat, also auch wir, könnte aber prüfen, ob ein erratener Wortlaut stimmt, bei kurzen Namen wie einem einzelnen Wort leichter als bei langen. Das tun wir nicht.

**Nur auf diesem Gerät**

Ab dieser Wahl werden deine *Inhalte* nicht mehr in der Cloud gesichert. Dein iPhone verlassen sie dann nur noch in zwei Fällen: kurz, wenn KERN dir mit der KI antwortet (Abschnitt d), und wenn Apple deine Spracheingabe auf seinen Servern in Text umwandelt (Abschnitt 4). Maximale Privatsphäre für deine Inhalte, aber kein Recovery, wenn das Gerät weg ist.

Was schon in der Cloud liegt, löscht KERN dort, sofern es geprüft hat, dass deine Einträge auch auf deinem iPhone liegen. Nutzt du KERN auf mehreren Geräten, erkennt die Prüfung nicht jede Änderung, die nur auf dem anderen Gerät liegt. Wählst du es in den Einstellungen und fehlt auf deinem iPhone ein Eintrag aus der Cloud, fragt KERN dich vorher; klappt das Löschen nicht vollständig, bleibt das Backup eingeschaltet und KERN sagt dir Bescheid. Wählst du es im Onboarding, löscht KERN nur, wenn die Prüfung eindeutig ist; sonst (z.B. ohne Netz) bleibt dein bisheriges Backup in der Cloud, mit verschlüsselten Inhalten. Möchtest du sichergehen, dass dort nichts mehr liegt, schreib uns mit deiner Kennung aus Einstellungen → Sicherheit an datenschutz@getkern.app, dann löschen wir dieses Backup. Bei einem Wechsel in ein anderes Konto (Abschnitt b) löscht KERN, was unter der früheren User-UUID noch in der Cloud liegt, ohne diese Prüfung.

Danach liegen auf unseren Servern nur noch die technischen Daten aus Abschnitt b), die Nutzungszahlen aus Abschnitt 5 sowie die Server-Protokolle und die Protokolle unserer Zugriffe aus Abschnitt 6; in den täglichen Datenbank-Sicherungen (Abschnitt 6) steckt das Gelöschte noch bis zu 7 Tage.

Die Wahl gilt nur für dieses Gerät: Nutzt du dasselbe Konto auch auf einem anderen Gerät mit eingeschaltetem Backup, sichert KERN deine Inhalte von dort aus weiter in der Cloud, wie unter „Cloud-Backup an“ beschrieben.

### d) KI-Antworten (wenn KERN dir antwortet)

Wenn KERN dir antwortet, etwa in einer Reflexion, bei neuen Sichtweisen, Zusammenfassungen, Rückblicken oder Kurs-Texten, schickt unser Server den dafür nötigen Text an Anthropic (Hersteller des KI-Modells Claude): den Text, um den es gerade geht, plus einen kurzen Kontext aus deinen bisherigen Einträgen (z.B. deine Antworten aus dem Einstieg, deine „Über dich“-Zusammenfassung, Ziele, Lebensbereiche, Blockaden, deine letzten Erkenntnisse sowie Auszüge aus deinen letzten Reflexionen und Gedanken), damit die Antwort zu dir passt. **Eine Konto-Kennung geht dabei nicht mit** - Anthropic erfährt nicht, zu welchem Konto die Anfrage gehört. Laut den Bedingungen des Anbieters trainiert Anthropic **nicht** auf diesen Inhalten und löscht sie in der Regel innerhalb von 30 Tagen. Die Übertragung läuft TLS-verschlüsselt. All das passiert nur mit deiner Erlaubnis: KERN fragt dich auf jedem Gerät vorher, ohne dein Einverständnis geht von dort kein Text an Anthropic. Mehr Details in Abschnitt 4.

## 3. Wofür wir diese Daten nutzen

- Um die App zum Laufen zu bringen (Verlauf, Statistiken, Fortschritt bei deinen Zielen)
- Um dir KI-gestützte Antworten zu geben (KERNs Gesprächsfunktion, Sichtweisen, Zusammenfassungen, Erkenntnis-Klassifikation)
- Um deine Daten aus dem Cloud-Backup wiederherstellen zu können (siehe Abschnitt 2.c)
- Um dein Konto wiederherzustellen: nach einer Neuinstallation über den Schlüsselbund deines iPhones (siehe Abschnitt 6) und, wenn du es mit Apple gesichert hast, auch nach dem Abmelden oder auf einem neuen Gerät
- Um Käufe und deinen Abo-Status abzuwickeln
- Um KERN mit Nutzungszahlen ohne Inhalte zu verbessern (siehe Abschnitt 5)
- Um Fehler zu finden, Missbrauch zu erkennen und deine Daten gegen Verlust zu sichern (Server-Protokolle und Datenbank-Sicherungen, siehe Abschnitt 6)
- Um nachvollziehen zu können, wann und warum wir auf ein Konto zugegriffen oder technisch daran gearbeitet haben (Protokolle, siehe Abschnitt 6)
- Um dir zu antworten und dein Anliegen zu bearbeiten, wenn du uns schreibst (siehe Abschnitt 4)
- Für nichts anderes

**Wir nutzen deine Daten nicht für Werbung. Wir verkaufen sie nicht. Wir trainieren keine KI auf deinen Inhalten.**

**In einfachen Worten:** Was du in KERN schreibst, liegt in der Cloud verschlüsselt, den Schlüssel hast nur du. Auch wir können es dort nicht lesen. Lesbar wird dein Text sonst nur für Anthropic, wenn die KI dir antwortet (unser Server reicht ihn dafür nur weiter und speichert ihn nicht, Anthropic löscht ihn in der Regel innerhalb von 30 Tagen), und für Apple, wenn du ihn einsprichst. Einen Namen, eine E-Mail oder eine Kennung bekommen beide dabei nicht von uns. Was wir selbst auswerten, sind Zahlen, nie deine Inhalte.

Rechtsgrundlagen: Was KERN für seine Funktionen braucht (Konto, Nutzungsgrenzen, Abo, Cloud-Backup und Wiederherstellen) und die Antworten auf deine Anfragen, verarbeiten wir zur Erfüllung des Nutzungsvertrags (Art. 6 Abs. 1 lit. b DSGVO); das Cloud-Backup ist dabei ein Teil der Funktion, den du abwählen kannst. KI-Antworten beruhen auf deiner Einwilligung (Art. 6 Abs. 1 lit. a DSGVO), um die KERN dich vorher fragt. In Versionen vor 1.2.7 gab es diese Frage noch nicht, dort waren KI-Antworten Teil des Nutzungsvertrags. Die Nutzungszahlen aus Abschnitt 5 (nur Zahlen, nie Inhalte, unter einem Decknamen statt unter deiner Kennung), die Server-Protokolle, die Datenbank-Sicherungen und die Protokolle unserer Zugriffe und Reparaturen (Abschnitt 6) beruhen auf unserem berechtigten Interesse, KERN stabil und nachvollziehbar zu betreiben und zu verbessern (Art. 6 Abs. 1 lit. f DSGVO). Dagegen kannst du jederzeit widersprechen (Abschnitt 7).

## 4. Wer bekommt deine Daten zu sehen?

Wir arbeiten mit drei Auftragsverarbeitern: Supabase, Anthropic und RevenueCat. Das sind die einzigen externen Stellen, die deine Daten aus der App in unserem Auftrag technisch verarbeiten. Daneben verarbeitet Apple als Plattform-Anbieter einige Daten in eigener Verantwortung, und bei Apple liegt auch unser E-Mail-Postfach (siehe unten).

### Supabase (EU)

- **Sitz der Datenverarbeitung**: Frankfurt am Main, Deutschland (EU)
- **Wozu**: Cloud-Backup deiner Daten, Anmeldung + technische Brücke zu Anthropic (KI)
- **Rechtsbasis**: Auftragsverarbeitungsvertrag nach Art. 28 DSGVO
- **Was sie sehen**: Verschlüsselte Inhalte + lesbare technische Angaben (UUID, Anmelde-Zeitpunkte, IP-Adressen und User-Agent deiner Anmeldungen, Nutzungszähler, Abo-Status und die in Abschnitt 2.c genannten Angaben), die Nutzungszahlen aus Abschnitt 5, die Server-Protokolle, die Datenbank-Sicherungen und die Protokolle unserer Zugriffe aus Abschnitt 6 sowie - wenn du dein Konto mit Apple sicherst - deine E-Mail-Adresse und die von Apple vergebene Anmelde-Kennung

Supabase ist immer aktiv (für deine User-UUID, siehe Abschnitt 2.b). Deine **Inhalte** (Reflexionen, Erkenntnisse, etc.) gehen nur zu Supabase, solange das Cloud-Backup eingeschaltet ist (voreingestellt, dann verschlüsselt) oder wenn KERN gerade eine KI-Antwort für dich holt.

### Anthropic (USA)

- **Sitz**: San Francisco, USA
- **Wozu**: KI-Modelle (Claude) generieren die KERN-Antworten und werten deine Reflexionen aus
- **Was geht raus**: Der Text, um den es gerade geht (z.B. dein Gespräch mit KERN, eine Blockade, zu der du neue Sichtweisen formulierst, oder deine Einträge für einen Rückblick), plus ein kurzer Kontext aus deinen bisherigen Einträgen (siehe Abschnitt 2.d). **Keine Konto-Kennung, keine E-Mail-Adresse.** Die Anfrage läuft über unseren Server, deshalb sieht Anthropic auch nicht die IP-Adresse deines Geräts.
- **Rechtsbasis**: Standardvertragsklauseln (SCC) nach Art. 46 Abs. 2 lit. c DSGVO.
- **Was Anthropic NICHT macht**: auf deinen Inhalten trainieren. Laut den Bedingungen des Anbieters ist das für Inhalte, die über die API geschickt werden, ausgeschlossen.
- **Speicherdauer bei Anthropic**: Laut den Bedingungen des Anbieters werden Eingaben und Antworten in der Regel innerhalb von 30 Tagen gelöscht. Länger nur in Ausnahmefällen, z.B. wenn eine Anfrage als Verstoß gegen Anthropics Nutzungsrichtlinien markiert wird oder eine gesetzliche Pflicht besteht.

**Wenn dir der USA-Transfer trotz SCC zu unsicher ist:** Meditieren kannst du in KERN, ohne dass etwas an Anthropic geht. Die KI arbeitet aber nicht nur, wenn du reflektierst oder neue Sichtweisen formulierst. Aus deinen Einträgen schreibt sie zum Beispiel auch die Wochen- und Monatsrückblicke in deinem Tagebuch, die persönlichen Texte in deinen Kursen und den Vorschlag für deinen nächsten Kurs, und zwar schon, sobald du das Tagebuch oder deine Kurse öffnest, nach den ersten sieben Kursen auch die Startseite. All das passiert nur mit deiner Erlaubnis. Sie gilt für das jeweilige Gerät, und du nimmst sie dort jederzeit unter Einstellungen → App-Einstellungen → Daten & Privatsphäre → KI-Antworten zurück. Dann geht von diesem Gerät kein Text mehr an Anthropic: Reflexionen und neue Sichtweisen pausieren, und neue persönliche Texte entstehen nicht mehr. KERN zeigt stattdessen feste Texte oder lässt sie weg, schon geschriebene bleiben auf deinem Gerät.

### RevenueCat (USA)

- **Sitz**: San Francisco, USA (Datenverarbeitung auf Servern in den USA)
- **Wozu**: Abwicklung und Prüfung von Käufen und Abos (KERN Premium) zusammen mit dem App Store
- **Was sie sehen**: Deine User-UUID (aus Abschnitt 2.b), Kauf- und Abo-Daten aus dem App Store (z.B. Produkt, Kaufdatum, Laufzeit, Status) und technische Angaben wie App-Version, Betriebssystem und die IP-Adresse deines Geräts (die App spricht direkt mit RevenueCat). Weil die App beim Start mit deiner UUID bei RevenueCat nachfragt, ob ein Abo aktiv ist, kennt RevenueCat sie auch, wenn du nichts kaufst. **Keine Inhalte** aus deinen Reflexionen, keine Zahlungsdaten (die bleiben bei Apple).
- **Was zurückkommt**: RevenueCat meldet Änderungen an deinem Abo an unseren Server. Dort speichern wir nur, ob Premium aktiv ist, bis wann, welches Abo, woher der Eintrag stammt (über RevenueCat oder eine manuelle Freischaltung durch uns) und wann er sich zuletzt geändert hat.
- **Rechtsbasis**: Art. 6 Abs. 1 lit. b DSGVO (Vertragserfüllung - du kaufst ein Abo, wir schalten es frei). Auftragsverarbeitungsvertrag nach Art. 28 DSGVO; die Übermittlung in die USA ist über die darin enthaltenen Standardvertragsklauseln (Art. 46 Abs. 2 lit. c DSGVO) abgesichert.

### Apple (USA)

Wenn du dich mit Apple Sign-In anmeldest, wickelt Apple den Login ab. Apple sieht dabei nur, dass du KERN benutzt, nicht **was** du eingibst. Käufe und Abos laufen über den App Store - deine Zahlungsdaten bleiben bei Apple, wir sehen sie nicht. Details: [apple.com/legal/privacy](https://www.apple.com/legal/privacy/de-ww/).

**Spracheingabe:** Wenn du statt zu tippen sprichst, nutzt KERN die Spracherkennung von Apple. Die Umwandlung in Text übernimmt Apple - je nach Gerät und Einstellungen direkt auf deinem iPhone oder auf Apples Servern. KERN speichert keine Audioaufnahmen; nur der erkannte Text landet in deinem Eingabefeld. Die Spracheingabe ist freiwillig, iOS fragt vorher nach deiner Erlaubnis für Mikrofon und Spracherkennung.

**E-Mails an uns:** Wenn du uns schreibst, etwa an hello@getkern.app (auch direkt aus KERN heraus) oder an datenschutz@getkern.app, liegt deine Nachricht mit deiner E-Mail-Adresse in unserem Postfach bei Apple (iCloud Mail). Deine Adresse und was du uns schreibst (z.B. deine Kennung) nutzen wir, um dir zu antworten und dein Anliegen zu bearbeiten.

## 5. Was wir pseudonymisiert messen - und was **nicht**

> 🔍 **Diese Aussagen sind auditierbar.** Schema, Code-of-Conduct und alle relevanten Datenbank-Migrationen liegen im öffentlichen Repo [kern-legal-docs](https://github.com/denyolo/kern-legal-docs) - mit voller Versions-Historie und Commit-Begründungen. Wenn etwas anders ist als hier beschrieben, kannst du das selbst sehen.

Damit du genau weißt was passiert:

**Was wir an Zahlen messen** (pseudonymisiert, also unter einem Decknamen statt unter deiner Kennung, ohne deine Inhalte):

- Anzahl der Reflexionen, Sichtweisen, Meditationen pro Tag/Monat (aggregiert)
- Durchschnittliche Zeichen-Anzahl deiner Antworten (keine Texte - nur die Länge)
- Wann du eine Reflexion abbrichst (welcher Schritt, ohne Inhalt)
- Welche Meditations-Kategorie wie oft gehört wird
- Wie lange eine Onboarding-Session dauert
- Wann ein Free-Limit erreicht wird
- App-Engagement (wie lange du KERN nutzt pro Session)
- Kurs-Fortschritt, Aufrufe der Abo-Seite, ob das Erklärvideo angesehen wurde, Daumen hoch/runter für eine Meditation und ob du KERN weiterempfohlen hast - jeweils ohne deine persönlichen Inhalte
- Wie stimmig sich eine Sichtweise beim Üben anfühlt (der Wert 1-10), ob du KERN erst ohne Gespräch erkundest, wie viele Antworten du im Einstiegsgespräch gibst und an welcher Stelle es abbricht, wie viele Lebensbereiche und Blockaden KERN dabei erkennt, welche Stimme bei einer Meditation lief, ob eine Zusammenfassung nicht geklappt hat, ob du die Karte zum nächsten Kurs gesehen oder angetippt hast und ob du der Erlaubnis für die KI zugestimmt oder „Nicht jetzt“ gewählt hast - jeweils ohne deine persönlichen Inhalte

Diese Zahlen helfen uns die App zu verbessern (z.B. „ist der Zeichen-Cap zu eng?“, „wo brechen User ab?“). Sie landen in einer separaten Datenbank-Tabelle `usage_events`, die per Design **keine Text-Spalten für Inhalte** hat - nur Ereignis-Typ, Zeitpunkt, Kategorie, Zahlen und eine Sitzungs-Kennung, die bei jedem Öffnen der App neu zufällig erzeugt wird. Deine User-ID wird vor dem Speichern zusammen mit einem geheimen Schlüssel **gehasht** - wir sehen also nicht „Anna hatte 5 Reflexionen“, sondern „Hash-User-abc hatte 5 Reflexionen“. Das ist eine **Pseudonymisierung**, keine Anonymisierung: Die Einträge stehen unter einem Pseudonym, also einem Decknamen, statt unter deiner User-ID, aber mit dem geheimen Schlüssel ließe sich technisch prüfen, zu welcher User-ID ein Eintrag gehört. Das tun wir nie mit Inhalten und nur in vier Fällen: wenn du es selbst verlangst, wenn wir ein technisch gespaltenes Konto reparieren, für Summen über alle Abos und wenn wir rechtlich dazu verpflichtet sind (Abschnitt 9). Verlangst du es, etwa für eine Auskunft oder einen Widerspruch (Abschnitt 7), suchen wir nur deine eigenen Einträge heraus. Für eine Reparatur ordnen wir die Einträge einzelnen Konten zu. Die Summen zeigen, was zu einem Kauf führt (z.B. wie viele Käufer vorher einen Kurs abgeschlossen haben) - dafür schauen wir nie auf eine einzelne Person. Die Zahlen werden unabhängig von deiner Backup-Wahl erfasst.

Schema einsehbar im öffentlichen Legal-Repo: [migrations/0005_usage_events.sql](https://github.com/denyolo/kern-legal-docs/blob/main/migrations/0005_usage_events.sql) und [migrations/0006_telemetry_hash_fix.sql](https://github.com/denyolo/kern-legal-docs/blob/main/migrations/0006_telemetry_hash_fix.sql) (Repo: [kern-legal-docs](https://github.com/denyolo/kern-legal-docs))

**Was wir bewusst nicht tun**:

- Wir nutzen **keine** Drittanbieter-Analytics wie Google Analytics, Mixpanel, Amplitude
- Wir nutzen **keine** Werbe-SDKs (kein Facebook Pixel, kein AppsFlyer, kein AdMob)
- Wir nutzen **keine** Cookies in der App
- Wir nutzen **keine** Tracking-Pixel
- Wir lesen **niemals** den Inhalt deiner Reflexionen, Sichtweisen, Gedanken oder Ziele
- Wir verkaufen deine Daten an niemanden, niemals
- Wir geben deine Daten nicht an Behörden weiter, außer wir sind rechtlich dazu verpflichtet (siehe Abschnitt 9)

## 6. Wie lange wir deine Daten speichern

- **Lokal auf deinem Gerät**: solange du die App installiert hast. Beim Deinstallieren löscht iOS die App-Daten. Im Schlüsselbund deines iPhones bleiben dabei zwei kleine Einträge erhalten: deine Anmeldung (damit dein Konto nach einer Neuinstallation wieder da ist) und - sobald KERN einmal etwas für die Cloud verschlüsselt hat, was auch schon vor deiner Backup-Wahl passieren kann - dein Backup-Schlüssel in deinem iCloud-Schlüsselbund. Er bleibt auch, wenn du danach „Nur auf diesem Gerät“ wählst.
- **In der Cloud (wenn aktiv)**: solange dein Konto existiert. Ein anonymes Konto (nicht mit Apple gesichert), das 24 Monate lang nicht genutzt wurde und unter dem weder ein Abo noch eine Freischaltung läuft, löschen wir mit seinen Einträgen in der Cloud und den Angaben zu seinen Anmeldungen. Wählst du ganz unten in den Einstellungen „Konto löschen“, löschen wir dein Konto mit allen Inhalten, auf deinem iPhone und in der Cloud: deine Einträge, deine Nutzungszähler, deinen Abo-Status bei uns, die Angaben zu deinen Anmeldungen und - falls vorhanden - die Apple-Verknüpfung mit der dafür gespeicherten E-Mail-Adresse. Läuft das Aufräumen einer früheren automatischen Kennung noch, nimmt KERN sie dabei mit, außer unter ihr läuft noch ein Abo oder eine Freischaltung (Abschnitt 2.b). Klappt dieses Aufräumen gerade nicht, etwa ohne Netz, versucht KERN es beim nächsten Öffnen der App noch einmal. In unseren täglichen Datenbank-Sicherungen und Server-Protokollen steckt das Gelöschte noch bis zu 7 Tage (siehe unten). Dein Backup-Schlüssel bleibt in deinem iCloud-Schlüsselbund, weil er für alle KERN-Konten deiner Apple-ID gilt. Was er von deinem gelöschten Konto entschlüsseln könnte, gibt es danach bei uns nur noch in diesen Sicherungen und Protokollen, nach spätestens 7 Tagen auch dort nicht mehr.
- **Nutzungszahlen (Abschnitt 5)**: bleiben auch nach dem Löschen deines Kontos bestehen. Sie enthalten keine Inhalte und keine User-ID im Klartext. Weil dein Konto danach nicht mehr existiert, gibt es kein Konto mehr, dem wir sie zuordnen könnten.
- **Kauf- und Abo-Daten bei RevenueCat und Apple**: Wenn du dein Konto löschst, lassen wir auch deinen Kunden-Eintrag bei RevenueCat (deine User-UUID mit Kaufhistorie) löschen. Eine Ausnahme für eine frühere automatische Kennung steht in Abschnitt 2.b. Bist du auf einem zweiten Gerät noch angemeldet, kann die App auf diesem Gerät deinen Kunden-Eintrag bei RevenueCat unter deiner User-UUID neu anlegen; solche Reste räumen wir regelmäßig auf. Kaufbelege und Abo bei Apple bleiben bei Apple, nach deren Bedingungen. Ein laufendes Abo kündigst du bitte vorher in den Einstellungen deines iPhones - das Löschen in KERN beendet es nicht.
- **Datenbank-Sicherungen**: Damit bei einem schweren technischen Fehler nichts verloren geht, legt unser Datenbank-Anbieter Supabase jeden Tag eine Sicherung der gesamten Datenbank an und bewahrt sie 7 Tage auf. Eine Sicherung ist eine Kopie der Datenbank: Was dort verschlüsselt liegt, ist auch in der Sicherung verschlüsselt. Was du löschst, steckt deshalb noch bis zu 7 Tage in diesen Sicherungen und verschwindet danach von selbst. Zurückgespielt wird eine Sicherung nur in einem solchen Notfall.
- **Server-Protokolle**: Damit wir Fehler finden und Missbrauch erkennen können, protokollieren unsere Server technische Abläufe, z.B. wann eine Anfrage kam, zu welchem Konto sie gehörte, von welcher IP-Adresse, mit welcher App-Version und ob sie geklappt hat. Deine Inhalte stehen darin nicht im Klartext. Diese Protokolle werden nach 7 Tagen automatisch gelöscht.
- **Protokolle unserer Zugriffe und Reparaturen**: Greifen wir auf die Einträge deines Kontos zu (nur mit deiner ausdrücklichen Zustimmung, etwa bei einer Support-Anfrage, oder weil wir rechtlich dazu verpflichtet sind, siehe Abschnitt 9) oder arbeiten wir technisch an einzelnen Konten, ohne Inhalte zu lesen (z.B. ein gespaltenes Konto reparieren oder alte unverschlüsselte Einträge entfernen), halten wir das Datum, den Grund und die Kennung des Kontos fest, bei einer Reparatur auch die Kennungen der betroffenen Einträge. Diese Angaben bleiben auch nach dem Löschen deines Kontos erhalten, damit sich nachvollziehen lässt, wann und warum wir das getan haben. Inhalte stehen darin nicht. Technische Angaben ohne Inhalt (z.B. Zeitpunkte, Zählungen, den Abo-Status oder ob ein Eintrag verschlüsselt ist) sehen wir uns auch bei einzelnen Konten an, ohne das eigens festzuhalten, wenn es für den Betrieb von KERN nötig ist, etwa um einen Fehler zu finden - nie, um zu schauen, wie du KERN nutzt. Die Nutzungszahlen aus Abschnitt 5 ordnen wir dabei nur in den dort genannten Fällen einem Konto zu.
- **KI-Verarbeitungs-Logs bei Anthropic**: laut den Bedingungen des Anbieters in der Regel bis zu 30 Tage (Ausnahmen siehe Abschnitt 4).

## 7. Deine Rechte (DSGVO)

Du hast jederzeit das Recht auf:

- **Auskunft** über deine bei uns gespeicherten Daten (Art. 15)
- **Berichtigung** falscher Daten (Art. 16)
- **Löschung** („Recht auf Vergessenwerden“, Art. 17)
- **Einschränkung der Verarbeitung** (Art. 18)
- **Datenübertragbarkeit** (Art. 20) - wir geben dir auf Anfrage einen Export der bei uns gespeicherten Daten im JSON-Format. Deine Inhalte sind darin verschlüsselt, weil nur dein Gerät sie lesen kann.
- **Widerspruch** gegen die Verarbeitung (Art. 21) - z.B. gegen die Nutzungszahlen aus Abschnitt 5
- **Widerruf** einer einmal erteilten Einwilligung (Art. 7 Abs. 3)

Für all das: schreib eine kurze Email an datenschutz@getkern.app. Wir antworten innerhalb von 30 Tagen. In den meisten Fällen viel schneller.

**Innerhalb der App:**

- „Konto löschen“ findest du ganz unten in den Einstellungen. Nach einer Bestätigung löscht es dein Konto mit allen Inhalten, lokal und (wenn aktiv) in der Cloud, inklusive einer Apple-Verknüpfung.
- Die Cloud-Wahl änderst du in Einstellungen → App-Einstellungen → Daten & Privatsphäre.
- Deine Erlaubnis für die KI nimmst du am selben Ort unter „KI-Antworten“ zurück. Sie gilt für das jeweilige Gerät.

## 8. Beschwerderecht

Wenn du der Meinung bist, dass wir deine Daten nicht ordentlich behandeln, kannst du dich bei der Datenschutz-Aufsichtsbehörde beschweren. Für KERN zuständig ist:

**Berliner Beauftragte für Datenschutz und Informationsfreiheit (BlnBDI)**
Friedrichstr. 219, 10969 Berlin
Telefon: +49 30 13889-0
E-Mail: mailbox@datenschutz-berlin.de

## 9. Behörden-Anfragen

Wir geben Daten an Behörden nur weiter, wenn wir rechtlich verpflichtet sind - also wenn ein deutsches Gericht oder eine zuständige deutsche Behörde uns nach gültigem Recht dazu zwingt. Wir geben dir in dem Fall Bescheid, soweit das gesetzlich erlaubt ist.

Wir geben **keine** Daten an US-Behörden auf US-Anfragen weiter, weil die Daten aus der App, die wir selbst speichern, in der EU liegen und wir nicht der US-Jurisdiktion unterliegen.

## 10. Erinnerungen

Wenn du Erinnerungen aktivierst (optional), plant und zeigt sie dein iPhone selbst. Kein Server verschickt sie, auch nicht Apples Push-Dienst. Wann du erinnert werden willst, gehört zu deinen Einstellungen und liegt bei eingeschaltetem Cloud-Backup lesbar in der Cloud (Abschnitt 2.c).

## 11. Für wen KERN gedacht ist

KERN richtet sich an Erwachsene ab 18 Jahren. Bist du jünger, nutze KERN bitte nicht. Wir fragen kein Alter ab und erheben wissentlich keine Daten von Kindern und Jugendlichen. Ein bestehendes Konto kannst du jederzeit ganz unten in den Einstellungen löschen.

## 12. Website und Warteliste

Diese Erklärung gilt auch für unsere Website getkern.app.

- **Hosting:** Die Website liegt bei Vercel (USA). Wie bei jedem Webserver verarbeitet Vercel beim Aufruf technische Angaben wie deine IP-Adresse und deinen Browser, damit die Seite ankommt und sicher läuft. Grundlage ist unser berechtigtes Interesse an einer funktionierenden Website (Art. 6 Abs. 1 lit. f DSGVO).
- **Schriften:** Sie liegen auf unserem eigenen Server. Dein Browser lädt dafür nichts von Google.
- **Keine Cookies, kein Tracking** auf der Website.
- **Warteliste für Android:** Trägst du deine E-Mail-Adresse ein, speichern wir sie mit Zeitpunkt und Plattform in einer Google-Tabelle (Google, USA). Wir nutzen sie nur für eine Nachricht, sobald KERN für Android da ist, und löschen sie danach. Grundlage ist deine Einwilligung (Art. 6 Abs. 1 lit. a DSGVO). Du kannst sie jederzeit per Mail an datenschutz@getkern.app widerrufen, dann löschen wir deine Adresse sofort.

## 13. Änderungen dieser Erklärung

Wenn sich an der Verarbeitung etwas ändert, aktualisieren wir diese Seite. Das Datum ganz oben sagt dir, wann die Erklärung zuletzt geändert wurde.

## 14. Kontakt

Fragen? Sorgen? Schreib uns: hello@getkern.app

Für formale Datenschutz-Anfragen: datenschutz@getkern.app

---

*KERN - Reflektieren · Meditieren · Manifestieren.*
*Deine inneren Bewegungen gehören dir.*
