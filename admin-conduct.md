# KERN - Admin Code of Conduct

**Stand: 09.11.2026**
**Gilt für: Dennis Lisk und alle künftigen KERN-Team-Mitglieder mit technischem Datenzugriff**

---

**Seit dem 26.06.2026 sind die User-Inhalte (Reflexionen, Erkenntnisse, Onboarding-Antworten, Ziele, Sichtweisen, Verlauf) Ende-zu-Ende verschlüsselt gespeichert - in der Datenbank und in ihren Sicherungen kann ich sie nicht mehr lesen, niemand bei KERN kann das.** Bei Blockaden berechnet die App die Kennung eines Eintrags seit Version 1.2.7 aus seinem Text und dem Schlüssel des Users. Ältere Einträge, die die App noch nicht umgestellt hat, hängen nur am Text; einen erratenen Wortlaut könnte ich damit prüfen, und auch das tue ich nicht (Abschnitt 1). Eine bewusste Ausnahme ist der Weg zur KI: Wenn KERN mit der KI antwortet, reicht unser Server den dafür nötigen Text samt einem kurzen Kontext aus den bisherigen Einträgen im Klartext (TLS-gesichert, aber nicht Ende-zu-Ende) an Anthropic weiter, ohne ihn zu speichern oder zu protokollieren. Hier bleibt es bei meiner Selbstverpflichtung aus Abschnitt 1. Eine zweite Ausnahme gibt es seit Version 1.3.0: Wer eine KI-Antwort meldet und dabei ausdrücklich „Antwort mitschicken“ einschaltet, schickt uns genau diese eine Antwort lesbar, ohne Kennung (Abschnitt 2, letzter Absatz). Die folgenden Verpflichtungen waren schon vor der Verschlüsselung mein Standard und bleiben es.

Ich verpflichte mich:

## 1. Kein proaktives Lesen

Ich schaue **niemals proaktiv** in die Inhalte einzelner User-Accounts. Weder aus Neugier, noch zur Qualitätskontrolle, noch zur Verbesserung von KI-Prompts. Wenn ich Prompt-Qualität verbessern will, frage ich gezielt um Erlaubnis („Darf ich ein Beispiel ohne Bezug zu dir teilen?“) oder nutze meine eigenen Test-Accounts.

## 2. Inhalte einzelner Konten nur in drei Ausnahmefällen

Inhalte einzelner Konten lese, ändere oder lösche ich nur dann, wenn:

a) **Support-Anfrage mit explizitem User-Consent** - der User schreibt „ja, schau bitte rein, ich verstehe einen Bug nicht“, und ich dokumentiere diesen Consent schriftlich (z.B. Email-Thread, Screenshot).

b) **Gesetzlich verpflichtende Behörden-Anordnung** - und nur, soweit mich ein deutsches Gericht oder eine zuständige deutsche Behörde nach gültigem Recht dazu verpflichtet. In diesem Fall benachrichtige ich den betroffenen User, soweit gesetzlich erlaubt.

c) **Löschen, Reparieren und Datenminimierung ohne Lesen** - wenn Daten gelöscht oder dem richtigen Konto zugeordnet werden müssen, weil jemand das wünscht oder damit KERN hält, was die Datenschutzerklärung verspricht (z.B. alte unverschlüsselte Einträge aus der Zeit vor der Verschlüsselung entfernen, eine Angabe leeren, die nicht mehr gespeichert wird, oder Einträge eines gespaltenen Kontos zurück ins richtige Konto hängen). Dabei gilt:

- Ich lese keine Inhalte. Ich arbeite nur mit Kennungen, Zeitstempeln, Zählungen, Längen, Ja/Nein-Angaben ohne Inhalt (z.B. ob ein Feld leer ist, ob ein Konto anonym oder mit Apple verknüpft ist, ob ein Abo oder eine Freischaltung aktiv ist) und der Frage, ob ein Wert mit `k1:` beginnt, also verschlüsselt ist. Die Abfragen geben dabei nie Text aus, nur Zahlen, Zeitpunkte, Kennungen oder Ja/Nein.
- Die pseudonymisierten Nutzungszahlen darf ich einzelnen Konten nur in den vier Fällen zuordnen, die auch die Datenschutzerklärung nennt (dort Abschnitt 5): um ein gespaltenes Konto zu finden (nur Kennungen und Zeitpunkte, nur für diese Reparatur), wenn die Person es selbst verlangt (Auskunft, Widerspruch, Löschung - dann nur ihre eigenen Einträge, nur dafür), wenn mich ein Gericht oder eine Behörde dazu verpflichtet (wie in 2b) und für Summen über alle Käufer (siehe Abschnitt 3 unten). Gebe ich Einträge heraus (an die Person bei einer Auskunft, an das Gericht oder die Behörde bei einer Anordnung), gilt dafür 2a bzw. 2b.
- Vorher prüfe ich, dass eine aktuelle Sicherung existiert, und probiere den Lauf so aus, dass er nichts verändert (Probelauf oder Rücknahme am Ende). Wo es keine Sicherung gibt (Kunden-Reste bei RevenueCat), lösche ich nur nach einem Probelauf und einer ausdrücklichen Bestätigung, und Einträge mit aktivem Premium bleiben stehen.
- Ganze Konten lösche ich auf diesem Weg nur auf Wunsch der Person oder wenn KERN es bei einem Konto-Wechsel aufgeräumt hat, es nur wegen eines Abos oder einer Freischaltung stehen blieb und beides nicht mehr aktiv ist, oder wenn ein anonymes Konto 24 Monate lang nicht genutzt wurde und kein Abo und keine Freischaltung trägt; sonst entferne ich nur die betroffenen Einträge.
- Jeder Lauf wird protokolliert: Datum, Zweck, Umfang (wie viele Konten und Einträge) und Freigabe; bei Arbeiten an einzelnen Konten auch deren Kennungen, bei einer Reparatur zusätzlich die Kennungen der umgehängten Einträge, damit sich der Lauf rückgängig machen lässt. Bei Kunden-Resten bei RevenueCat, deren Konto es bei KERN schon nicht mehr gibt, halte ich nur die Zahlen fest. Das Protokoll enthält keine Inhalte, liegt nicht im öffentlichen Repo und bleibt auch bestehen, wenn ein betroffenes Konto später gelöscht wird.

**Gemeldete KI-Antworten (seit Version 1.3.0, Tabelle `ai_reports`):** Sie sind mit keinem Konto verknüpft. Den Text einer KI-Antwort gibt es dort nur, wenn die Person ihn beim Melden ausdrücklich mitgeschickt hat. Diese Texte lese ich nur, um KERNs Antworten zu prüfen und zu verbessern, und ich versuche von mir aus nie, eine Meldung einem Konto oder einer Person zuzuordnen, auch nicht über Server-Protokolle. Bittet jemand darum, suche ich die Meldung nur über den ungefähren Zeitpunkt und das Gespräch heraus, ohne dafür die Texte zu lesen, und lösche alle, die in Frage kommen. Nach 12 Monaten löscht die Datenbank Meldungen von selbst.

## 3. Audit-Trail muss bestehen

**Operative Regel:** Jeder Zugriff auf User-Inhalte erfolgt ausschließlich über die SQL-Funktion `admin_inspect_user_data(target_user_id, reason)`. Sie schreibt einen Audit-Eintrag in die Tabelle `admin_access_log` und liefert die Einträge aus den Tabellen `profiles`, `reflections`, `insights`, `sessions`, `affirmations`, `goals`, `life_areas` und `blockade_meta` zurück. Die Tabellen `affirmation_practice_events`, `meditation_ratings`, `conversation_history` und `summaries` deckt sie bisher nicht ab. Bräuchte ich dort einmal Inhalte (nur nach Abschnitt 2a oder 2b), erweitere ich vorher die Funktion, damit auch dieser Zugriff protokolliert wird. Ausgenommen ist die Tabelle `ai_reports` (gemeldete KI-Antworten, Abschnitt 2, letzter Absatz): Sie hängt an keinem Konto, die Funktion passt dafür nicht. Diese Meldungen lese ich direkt, nur zu dem dort genannten Zweck.

**Aufruf-Beispiel** (im Supabase SQL Editor):

```sql
SELECT * FROM admin_inspect_user_data(
  'user-uuid-hier',
  'Support-Anfrage von User X - Bug-Reproduktion zu Insight-Verknüpfung, Email-Thread im Anhang'
);
```

**Verbotene Praxis** - direkter SELECT auf User-Inhalt-Tabellen aus dem Dashboard:

```sql
-- NICHT MACHEN - kein Audit-Eintrag, Verletzung dieser Code-of-Conduct
SELECT * FROM reflections WHERE user_id = 'user-uuid';
```

Ausnahme: Metadaten ohne Inhalt - Schema, Rechte, Constraints, Kennungen, Zählungen, Längen, Zeitstempel und Ja/Nein-Angaben (z.B. ob ein Feld leer oder ein Wert verschlüsselt ist) - sind ohne Audit-Eintrag zulässig, auch bezogen auf einzelne Konten, solange dabei kein Inhalt sichtbar wird (Health-Checks, Volumen-Monitoring, Fälle nach 2c), aber nie, um zu schauen, wie eine einzelne Person KERN nutzt. Den Abo-Status verknüpfe ich mit der Nutzung nur als Summe über alle Käufer (siehe [analytics-events.md](analytics-events.md)).

Einträge im `admin_access_log` behalten die Kennung des betroffenen Kontos auch nach dessen Löschung, damit jeder Zugriff nachweisbar bleibt.

**Zweite Verteidigungslinie (noch nicht eingeschaltet):** Auf unserer Datenbank lässt sich zusätzlich `pgaudit` aktivieren. Dann wäre auch ein direkter SELECT technisch protokolliert. Geplant war das vor dem öffentlichen Start, eingeschaltet ist es bisher nicht. Bis dahin ist die `admin_inspect_user_data`-Disziplin eine Selbstverpflichtung (siehe Abschnitt 6). Sie bleibt auch danach als bewusster Schritt mit Begründungs-Pflicht erhalten.

## 4. Strikte Datentrennung bei Team-Wachstum

Wenn KERN Mitarbeiter einstellt:

- **Default-Rolle**: kein direkter Datenbank-Zugriff. Mitarbeiter arbeiten ausschließlich mit App-internen Tools (Dashboards mit aggregierten Zahlen).
- **Ausnahme**: Support- oder Engineering-Personen mit klar dokumentiertem Need-to-Know erhalten **read-only**-Zugriff auf einzelne Tabellen, nicht auf Inhalte ohne expliziten User-Consent.
- **Owner-Vollzugriff**: bleibt zunächst auf mich begrenzt. Jeder weitere Vollzugriff erfordert dokumentierte Begründung + 4-Augen-Prinzip.

## 5. Bei Verkauf, Übergabe oder Investment

Wenn KERN je verkauft, übertragen oder von Investoren übernommen wird, gilt:

- Diese Code-of-Conduct bleibt Teil der Übergabe-Bedingungen.
- Käufer/Übernehmer müssen sich schriftlich zu diesen Verpflichtungen bekennen.
- User werden über jeden Eigentümerwechsel mindestens 30 Tage im Voraus informiert mit Option zum Daten-Export oder kompletter Löschung.

## 6. Härtungs-Reihenfolge

Diese Verpflichtung wird durch technische Maßnahmen schrittweise verstärkt:

1. **Seit Mai 2026**: Schriftliche Selbstverpflichtung (dieses Dokument) + `admin_inspect_user_data`-Funktion + `admin_access_log`-Tabelle. **Honor System** - direkter SELECT ist technisch möglich, aber durch diese Regel ausgeschlossen.
2. **Offen**: `pgaudit` als technische zweite Verteidigungslinie. Dann wird auch ein direkter SELECT protokolliert. Bisher nicht eingeschaltet (siehe Abschnitt 3).
3. **E2E-Verschlüsselung - live seit 26.06.2026**: User-Inhalte werden client-seitig verschlüsselt. Der Audit-Mechanismus ist damit weniger kritisch, weil **selbst ein Direct-SELECT für Inhalte nur Chiffretext liefert** - für die gespeicherten Inhalte wandelt sich die Selbstverpflichtung von „ich tue es nicht“ zu „ich **kann** es technisch nicht mehr tun“. Ausgenommen sind nur KI-Antworten, die jemand beim Melden ausdrücklich mitschickt (Abschnitt 2).

Mit Stufe 3 (seit 26.06.2026) ist aus dem Versprechen für die gespeicherten Inhalte eine **technische Tatsache** geworden - sie sind verschlüsselt, nicht nur „versprochen unangetastet“. Für den Weg zur KI und für gemeldete KI-Antworten, die jemand mitschickt, bleibt es beim Versprechen aus der Einleitung und Abschnitt 2. Wie in der Privacy Policy ([privacy-policy.de.md](privacy-policy.de.md)) dokumentiert.

---

## Begründung - Warum das hier dokumentiert ist

Dieser Text ist nicht juristisch zwingend - niemand schreibt mir vor, eine Code-of-Conduct zu verfassen. Aber:

- Es bindet **mich selbst**. Schriftlich, datiert, im versionskontrollierten Repo.
- Es ist **Beleg für künftige Audits** (Investor-DD, DSGVO-Beschwerde, gerichtliche Klärung).
- Es macht meinem **künftigen Team** klar, was hier Standard ist - nicht nur Wohlwollen, sondern Norm.
- Es ist **Teil der Mission**. KERN ist eine App für die tiefsten inneren Bewegungen. Die Selbstverpflichtung gehört dazu.

Wenn ich gegen diese Verpflichtung verstoße, bin ich nicht nur unzuverlässig - ich brech die Grundlage, auf der KERN aufgebaut ist.

---

*Diese Datei ist Bestandteil der KERN-Codebasis und versionskontrolliert. Änderungen brauchen Begründung im Commit-Log.*

**Signatur (durch Commit):**
- Dennis Lisk, Owner KERN - initial Commit, 18.05.2026
- Ergänzung 03.11.2026: Ausnahme 2c (Löschen, Reparieren und Datenminimierung ohne Lesen), Weg zur KI, ehrlicher Stand zu `pgaudit` und zur Audit-Funktion, aktuelle Begriffe
- Ergänzung (1.3.0, 09.11.2026): gemeldete KI-Antworten (Einleitung, Abschnitt 2 letzter Absatz, Abschnitt 3 operative Regel, Abschnitt 6 Punkt 3 und der Absatz danach)
