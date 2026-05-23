# KERN — Admin Code of Conduct

**Stand: 18.05.2026**
**Gilt für: Dennis Lisk und alle künftigen KERN-Team-Mitglieder mit technischem Datenzugriff**

---

Als alleiniger Owner und Verantwortlicher für KERN habe ich technischen Zugriff auf die User-Daten in unserer Supabase-Datenbank (Reflexionen, Erkenntnisse, Onboarding-Antworten, Vision-Texte, Affirmationen, Verlauf).

Ich verpflichte mich:

## 1. Kein proaktives Lesen

Ich schaue **niemals proaktiv** in die Inhalte einzelner User-Accounts. Weder aus Neugier, noch zur Qualitätskontrolle, noch zur Verbesserung von AI-Prompts. Wenn ich Prompt-Qualität verbessern will, frage ich gezielt um Erlaubnis ("Darf ich anonymisiert ein Beispiel teilen?") oder nutze meine eigenen Test-Accounts.

## 2. Direkt-Queries nur in zwei Ausnahmefällen

Ich greife auf die Datenbank nur dann zu, wenn:

a) **Support-Anfrage mit explizitem User-Consent** — der User schreibt "ja, schau bitte rein, ich verstehe einen Bug nicht", und ich dokumentiere diesen Consent schriftlich (z.B. Email-Thread, Screenshot).

b) **Gesetzlich verpflichtende Behörden-Anordnung** — und nur, soweit von einem deutschen Gericht oder einer zuständigen deutschen Behörde rechtskräftig verfügt. In diesem Fall benachrichtige ich den betroffenen User, soweit gesetzlich erlaubt.

## 3. Audit-Trail muss bestehen

**Operative Regel (Stand Free-Plan):** Jeder Zugriff auf User-Inhalte (reflections, insights, sessions, affirmations, profile, goals, life_areas, blockade_meta) erfolgt ausschließlich über die SQL-Funktion `admin_inspect_user_data(target_user_id, reason)`. Diese Funktion schreibt einen Audit-Eintrag in die Tabelle `admin_access_log` und liefert die Daten zurück.

**Aufruf-Beispiel** (im Supabase SQL Editor):

```sql
SELECT * FROM admin_inspect_user_data(
  'user-uuid-hier',
  'Support-Anfrage von User X — Bug-Reproduktion zu Insight-Verknüpfung, Email-Thread im Anhang'
);
```

**Verbotene Praxis** — direkter SELECT auf User-Inhalt-Tabellen aus dem Dashboard:

```sql
-- NICHT MACHEN — kein Audit-Eintrag, Verletzung dieser Code-of-Conduct
SELECT * FROM reflections WHERE user_id = 'user-uuid';
```

Ausnahme: aggregierte, anonymisierte Stats über `COUNT(*)`, `AVG()`, etc. — solange einzelne User-Inhalte nicht sichtbar werden — sind ohne Audit-Eintrag zulässig (für Health-Checks, Volumen-Monitoring).

**Späterer Upgrade (Pro Plan):** Sobald wir auf Supabase Pro upgraden, aktivieren wir zusätzlich `pgaudit` als technische zweite Verteidigungslinie. Dann ist auch direkter SELECT geloggt — die `admin_inspect_user_data`-Disziplin bleibt aber als bewusster Schritt mit Reason-Pflicht erhalten.

## 4. Strikte Datentrennung bei Team-Wachstum

Wenn KERN Mitarbeiter einstellt:

- **Default-Rolle**: kein direkter Datenbank-Zugriff. Mitarbeiter arbeiten ausschließlich mit App-internen Tools (Dashboards mit aggregierten, anonymisierten Stats).
- **Ausnahme**: Support- oder Engineering-Personen mit klar dokumentiertem Need-to-Know erhalten **read-only**-Zugriff auf einzelne Tabellen, nicht auf Reflexions-/Insight-/Vision-Inhalte ohne expliziten User-Consent.
- **Owner-Vollzugriff**: bleibt zunächst auf mich begrenzt. Jeder weitere Vollzugriff erfordert dokumentierte Begründung + 4-Augen-Prinzip.

## 5. Bei Verkauf, Übergabe oder Investment

Wenn KERN je verkauft, übertragen oder von Investoren übernommen wird, gilt:

- Diese Code-of-Conduct bleibt Teil der Übergabe-Bedingungen.
- Käufer/Übernehmer müssen sich schriftlich zu diesen Verpflichtungen bekennen.
- User werden über jeden Eigentümerwechsel mindestens 30 Tage im Voraus informiert mit Option zum Daten-Export oder kompletter Löschung.

## 6. Härtungs-Reihenfolge

Diese Verpflichtung wird durch technische Maßnahmen schrittweise verstärkt:

1. **Heute (Beta, Free-Plan)**: Schriftliche Selbstverpflichtung (dieses Dokument) + `admin_inspect_user_data`-Funktion + `admin_access_log`-Tabelle. **Honor System** — direkter SELECT ist technisch möglich aber durch diese Regel ausgeschlossen.
2. **Vor Public Launch (Pro-Plan-Upgrade)**: `pgaudit` als technische zweite Verteidigungslinie. Auch direkter SELECT wird geloggt.
3. **Post-Launch (E2E-Verschlüsselung)**: User-Inhalte werden client-side verschlüsselt. Ab da ist der Audit-Mechanismus weniger kritisch, weil **selbst ein Direct-SELECT nur Zeichensalat liefert** — die Selbstverpflichtung wandelt sich von "ich tue es nicht" zu "ich **kann** es technisch nicht mehr tun".

Bis Stufe 3 erreicht ist, gilt diese Verpflichtung als **vertragliches Versprechen mit technischer Möglichkeit zur Verletzung** — wie in der Privacy Policy ([privacy-policy.de.md](privacy-policy.de.md)) transparent dokumentiert.

---

## Begründung — Warum das hier dokumentiert ist

Dieser Text ist nicht juristisch zwingend — niemand schreibt mir vor, eine Code-of-Conduct zu verfassen. Aber:

- Es bindet **mich selbst**. Schriftlich, datiert, im versionskontrollierten Repo.
- Es ist **Beleg für künftige Audits** (Investor-DD, DSGVO-Beschwerde, gerichtliche Klärung).
- Es macht meinem **künftigen Team** klar, was hier Standard ist — nicht nur Wohlwollen, sondern Norm.
- Es ist **Teil der Mission**. KERN ist eine App für die tiefsten inneren Bewegungen. Die Selbstverpflichtung gehört dazu.

Wenn ich gegen diese Verpflichtung verstoße, bin ich nicht nur unzuverlässig — ich brech die Grundlage, auf der KERN aufgebaut ist.

---

*Diese Datei ist Bestandteil der KERN-Codebasis und versionskontrolliert. Änderungen brauchen Begründung im Commit-Log.*

**Signatur (durch Commit):**
- Dennis Lisk, Owner KERN — initial Commit, 18.05.2026
