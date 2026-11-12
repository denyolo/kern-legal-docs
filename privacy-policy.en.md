# Privacy Policy

**Last updated: November 12, 2026**

KERN is an app for inner work - and this is first and foremost about personal things. So we handle your data the way we'd want ours handled: respectfully.

This policy tells you in plain language what we store, where it goes, and what we deliberately **don't** do.

The KERN app is currently available in German. Where we name a menu, we give its German name with the English meaning in parentheses.

---

## Quick read - you're safe here

Before the details, here's in plain language what happens in the background.

- **You start without account details.** No name, no email, no phone number. KERN knows you only by a random identifier. Only if you choose to secure your account with Apple do we store the email address Apple sends us for that (if you like, an anonymous relay address from Apple).
- **In the cloud, only you can read what you write in KERN.** There your texts are encrypted, and only you have the key. We can't read them either. We don't sell your data and don't train any AI on your words. We only share with the services KERN needs for its functions (section 4), and with authorities only when we're legally required to (section 9).
- **The AI gets your text, but no name with it.** So that KERN can answer you, your text goes to Anthropic's AI together with some context from your entries. KERN sends no name, no email and no identifier that leads back to you. According to Anthropic, your text isn't used for training. Before any text goes to the AI, KERN asks for your permission.
- **You choose where your data lives.** The default is an **end-to-end encrypted** backup on EU servers - **only your device can read your content in it, not us.** Alternatively, your content stays only on your iPhone. You can switch in settings.
- **No third-party tracking, no advertising analytics, no cookies.** Reminders are scheduled and shown by your iPhone itself, without a push server.
- **Only numbers, never content.** How many reflections are created, how long meditations last, how long answers are: these numbers help us improve KERN. They are stored under an alias instead of your identifier (that's what "pseudonymized" means), and what you write is never part of them. Details in [section 5](#5-what-we-measure-pseudonymously---and-what-not).
- **Reporting an AI reply is voluntary.** If you explicitly include the reply, we can read exactly this one reply, without your identifier. We delete it after 12 months, even if you delete your account before then (section 2.e).
- **Delete your account anytime** in settings - with all your content, locally and in the cloud. Our daily database backups still contain it for up to 7 days afterwards. Reports about AI replies are not linked to any account; section 2.e applies to them.

The rest of this page explains it in detail, if you want to look deeper.

---

## 1. Who is responsible?

The data controller for this app and our website is:

Dennis Lisk
Brunnenstr. 28
10119 Berlin
Germany

Email: hello@getkern.app

For privacy questions, write directly to: datenschutz@getkern.app

## 2. What we store

KERN works with three layers of data:

### a) What you do in the app (local on your device)

This data **always** lives on your iPhone - regardless of which backup option you choose:

- Your onboarding answers
- Goals, life areas and blocks you formulate
- Reflections (free + guided)
- Insights KERN extracts from your texts
- Perspectives (new beliefs) you formulate
- Saved thoughts
- Meditation sessions (time, duration, category)
- Course progress
- When you opened knowledge articles
- Settings (language, voice, notifications)

**You don't need any personal details to use KERN** - no email, no name, no phone number (for the optional Apple sign-in, see section b).

### b) What our servers see in any case - even without cloud backup

For KERN to work at all (e.g. to generate AI responses, check usage limits), we need a technical identity for you. So on first app launch, KERN automatically creates a **random user UUID** on our servers in Frankfurt. This UUID:

- Is a random string - **no name, no email, no phone number**
- Doesn't point to you as a person on its own - we know no name or email address for it unless you secure your account with Apple or send us your identifier yourself (e.g. with a request by email)
- Is needed to check usage limits and your subscription status and - if active - to assign your backup to your account

Alongside this UUID, our server also stores technical data: when you signed in (this includes the automatic sign-in on first launch), for each sign-in the IP address and a technical description of the app and operating system (the so-called user agent, e.g. app and iOS version), your usage counters (for the limits of the free version) and your subscription status (whether Premium is active, until when and which plan). While you use KERN, the app renews your sign-in automatically. Each time, our server replaces the IP address and user agent with the current values and stores when that last happened. The data for a sign-in stays stored until that sign-in ends, for example when you sign out, and at the latest until you delete your account (for one exception, see further down in this section).

**Optional: secure your account with Apple.** If you choose to secure your account with "Sign in with Apple" (during onboarding, when restoring, or in settings), KERN asks Apple for your email address and name. We store (in Supabase's sign-in service) the email address Apple sends us and a sign-in identifier assigned by Apple. If you choose "Hide My Email" at Apple, this is an anonymous relay address from Apple. **We don't store your name.** Purpose: so you can sign in again and restore your account on a new device. Your account is then linked to this email address.

**If you've already secured your account with Apple.** For example on a new device or after signing out, KERN automatically creates a new identifier (a user UUID as above) before it can know you already have an account. If you then sign in with Apple, two identifiers usually belong to one person, you: your account's and the automatic one. The automatic identifier carries no name and no email address, and your content under it is encrypted, so we can't read it. Because this identifier still belongs to you, here is what happens to it:

- **What's backed up under the automatic identifier:** If you bring back your account, it stays unchanged, and KERN deletes these entries, including from your iPhone. If your account is still empty, they move to your account and are then tied to your Sign in with Apple. The same applies if you choose "Hier neu anfangen" (Start fresh here) when signing in, except that KERN first deletes what was in your account so far. If you've chosen "Nur auf diesem Gerät" (Only on this device) in these two cases, nothing moves: KERN deletes only the copy of these entries on our servers, and they stay on your iPhone.
- **The automatic identifier itself:** We then delete it along with the data about its sign-ins, its usage counters and its record at RevenueCat, our subscription service (section 4). This happens in the background. If it doesn't work right away, for example without a connection, KERN tries again the next time you open the app.
- **If a subscription or unlock is still running under it:** The entries under it are moved or deleted all the same, as described above. Only the automatic identifier stays, because the subscription is tied to it, with the data just mentioned and its subscription status, for as long as it runs, even if you delete your account. After that, we delete it in one of our regular checks.
- **To be sure:** KERN has done this cleanup on its own since version 1.2.7. For an earlier sign-in, or if you want to be sure, write to datenschutz@getkern.app with your current identifier from Einstellungen (Settings) → Sicherheit (Security). We'll then look for the earlier automatic identifier and delete it. Because it carries no name, that only works through technical data such as timestamps, never through content (section 5), and it doesn't always succeed.

### c) Cloud backup

You decide whether KERN additionally backs up your *content* (reflections, insights, goals, history) on our servers. Until you choose, the encrypted backup is on - even while you're just looking around or meditating before you tell KERN about yourself in a conversation. During onboarding KERN asks you about it; the encrypted backup is preselected there. Later you can change your choice under Einstellungen (Settings) → App-Einstellungen (App settings) → Daten & Privatsphäre (Data & privacy).

**Cloud backup on**

Your content is **encrypted on your iPhone before it ever reaches our servers** (end-to-end, AES-256-GCM); transfer is additionally secured via TLS. On our EU servers (Frankfurt, Germany) your **content** is therefore stored **only as unreadable ciphertext** - **even we cannot read it**, not in an emergency, not if we wanted to.

The key lives in your **iCloud Keychain** (Apple syncs it end-to-end across your devices) and otherwise only where you keep a copy yourself (under Einstellungen (Settings) → Sicherheit (Security) → Schlüssel sichern (Back up key)); KERN never sees it. You regain your content on a new device if your account is secured with Apple and your iCloud Keychain is on. If it's off and your device is gone, you also need a key you backed up yourself beforehand. Without it, the content cannot be recovered - that's the price of true confidentiality. Without securing it with Apple, a new device usually won't find your account, even if the key arrives there.

**One deliberate exception**: when KERN answers you with the AI, the text needed for that and a short context from your previous entries (see section d) pass in cleartext (TLS-secured, but not end-to-end) through our server to the AI. **Our server only passes them on and doesn't store them**; at Anthropic, the retention periods from section 4 apply. **A second, voluntary exception**: if you report an AI reply and explicitly include it, we store exactly this reply readably, without your identifier (section e).

Technical data stays readable, none of your texts. KERN needs it for counting, sorting and restoring:

- Timestamps (e.g. when an entry was created, resolved or practiced)
- What kind of entry it is (e.g. meditation, reflection or thought)
- How long a meditation or reflection lasted, the chosen length and category of a meditation
- Which knowledge articles you dismissed
- Which courses you completed and when you started them (so the suggestion to recommend KERN appears only once at the end of a course)
- Ratings and scale values (e.g. how close you feel to a goal or how right a perspective feels)
- How often you practiced a perspective
- The status of an entry (e.g. achieved, resolved or hidden)
- Which entries belong together (as identifiers only, e.g. which goal belongs to which life area)
- Your settings (e.g. language, voice, reminder times) and when you gave your permission for the AI
- The totals of your journey

Two technical details of the encryption: the approximate length of an encrypted text can be read from the ciphertext, its content cannot. And since version 1.2.7, KERN calculates the identifier a block is stored under in the cloud on your device from its text and your key. Without the key it reveals nothing about the text. KERN converts older entries as soon as you use the new version with the backup switched on. Until then their identifier is calculated from the text alone: the text can't be calculated back from it; but anyone with access to the database, including us, could check whether a guessed wording matches, which is easier for short names such as a single word than for long ones. We don't do that.

**Nur auf diesem Gerät (Only on this device)**

From this choice on, your *content* is no longer backed up to the cloud. It then only leaves your iPhone in three cases: briefly when KERN answers you with the AI (section d), when Apple converts your voice input to text on its servers (section 4), and when you report an AI reply and explicitly include it (section e). Maximum privacy for your content, but no recovery if you lose the device.

Whatever is already in the cloud is deleted there by KERN, provided it has checked that your entries are also on your iPhone. If you use KERN on several devices, the check doesn't catch every change that exists only on the other device. If you choose this in Einstellungen (Settings) and an entry from the cloud is missing on your iPhone, KERN asks you first; if deleting doesn't fully work, the backup stays on and KERN tells you. If you choose it during onboarding, KERN only deletes when the check is clear; otherwise (e.g. without a connection) your previous backup stays in the cloud, with its content encrypted. If you want to be sure nothing is left there, write to datenschutz@getkern.app with your identifier (under Einstellungen (Settings) → Sicherheit (Security) → Deine Kennung (Your identifier)) and we'll delete that backup. When switching to a different account (section b), KERN deletes whatever is still in the cloud under the earlier user UUID without this check.

Afterwards our servers hold only the technical data from section b), the usage numbers from section 5, your reports about AI replies (the reply itself only if you included it, without identifier, section e), as well as the server logs and the records of our access from section 6; our daily database backups (section 6) still contain what was deleted for up to 7 days.

The choice applies only to this device: if you use the same account on another device with backup switched on, KERN keeps backing up your content from there, as described under "Cloud backup on".

### d) AI responses (when KERN answers you)

When KERN answers you, for example in a reflection, for new perspectives, summaries, reviews or course texts, our server sends the text needed for that to Anthropic (the company behind the Claude AI model): the text in question, plus a short context from your previous entries (e.g. your answers from the start of the app, your "About you" summary, goals, life areas, blocks, your recent insights and excerpts from your recent reflections and thoughts), so the answer fits you. **No account identifier is sent** - Anthropic does not learn which account the request belongs to. According to the provider's terms, Anthropic does **not** train on this content and usually deletes it within 30 days. Transmission runs TLS-encrypted. All of this only happens with your permission: KERN asks you on each device beforehand, and without your agreement no text goes to Anthropic from there. More details in section 4.

### e) When you report an AI reply

If you find a reply from KERN hurtful, inappropriate, wrong or concerning, you can report it: in the conversation, the guided reflection or the opening conversation, press and hold the reply. We then store the reason you choose, which of these conversations it was in, the time, whether you use an iPhone or an Android device, and the app version. **The reply itself is only included if you switch on "Antwort mitschicken" (Include this reply).** Then we can read exactly this one reply. It may contain words from your conversation and things from your entries, because KERN replies with that context. KERN never includes your own messages.

We store the report with Supabase (EU) without your identifier, and it is not linked to any account. Only our server logs record, as for every request, for up to 7 days which account it came from (section 6); we never combine the two. We use reports only to check and improve KERN's replies, and delete them after 12 months. The basis is your consent (Art. 6(1)(a) GDPR), which you give by sending the report. If you want to take a report back, email datenschutz@getkern.app roughly when it was and in which conversation. Because it carries no identifier, we find it that way and delete it. If several reports match, we delete all of them.

## 3. What we use this data for

- To make the app work (history, stats, progress on your goals)
- To give you AI-supported responses (KERN's conversation feature, perspectives, summaries, insight classification)
- To restore your data from the cloud backup (see section 2.c)
- To restore your account: after a reinstall via your iPhone's keychain (see section 6) and, if you secured it with Apple, also after signing out or on a new device
- To handle purchases and your subscription status
- To improve KERN with usage numbers that contain no content (see section 5)
- To check reported AI replies and improve KERN's replies (see section 2.e)
- To find errors, detect misuse and protect your data against loss (server logs and database backups, see section 6)
- To be able to trace when and why we accessed an account or worked on it technically (records, see section 6)
- To reply to you and handle your request when you write to us (see section 4)
- For nothing else

**We don't use your data for advertising. We don't sell it. We don't train AI on your content.**

**In plain words:** What you write in KERN is encrypted in the cloud, and only you have the key. We can't read it there either. Otherwise your text only becomes readable for Anthropic when the AI answers you (our server only passes it on for that and doesn't store it, and Anthropic usually deletes it within 30 days), and for Apple when you dictate it. Neither gets a name, an email or an identifier from us. What we evaluate ourselves are numbers, never your content. The only thing we can read is an AI reply you explicitly include when reporting it (section 2.e).

Legal bases: What KERN needs for its functions (account, usage limits, subscription, cloud backup and restoring) and the replies to your requests, we process to fulfil the user agreement (Art. 6(1)(b) GDPR); cloud backup is a part of the function you can opt out of. AI responses are based on your consent (Art. 6(1)(a) GDPR), which KERN asks you for beforehand. A report about an AI reply is also based on your consent, which you give by sending it (section 2.e). Versions before 1.2.7 didn't ask yet; there, AI responses were part of the user agreement. The usage numbers from section 5 (only numbers, never content, under an alias instead of your identifier), server logs, database backups and the records of our access and repairs (section 6) are based on our legitimate interest in running KERN reliably and traceably and improving it (Art. 6(1)(f) GDPR). You can object to this at any time (section 7).

## 4. Who sees your data?

We work with three processors: Supabase, Anthropic and RevenueCat. These are the only external parties that technically process your data from the app on our behalf. In addition, Apple as the platform provider processes some data under its own responsibility, and Apple also hosts our email inbox (see below).

### Supabase (EU)

- **Processing location**: Frankfurt am Main, Germany (EU)
- **Purpose**: Cloud backup of your data, sign-in + technical bridge to Anthropic (AI)
- **Legal basis**: Data Processing Agreement per Art. 28 GDPR
- **What they see**: Encrypted content + readable technical data (UUID, sign-in timestamps, IP addresses and user agent of your sign-ins, usage counters, subscription status and the data named in section 2.c), the usage numbers from section 5, the reported AI replies from section 2.e (without identifier), the server logs, the database backups and the records of our access from section 6, as well as - if you secure your account with Apple - your email address and the sign-in identifier assigned by Apple

Supabase is always active (for your user UUID, see section 2.b). Your **content** (reflections, insights, etc.) only goes to Supabase while cloud backup is on (the default, then encrypted) or when KERN is fetching an AI response for you, and readable when you explicitly include an AI reply in a report (section 2.e).

### Anthropic (USA)

- **Location**: San Francisco, USA
- **Purpose**: AI models (Claude) generate KERN's responses and analyze your reflections
- **What goes out**: The text in question (e.g. your conversation with KERN, a block you're formulating new perspectives for, or your entries for a review), plus a short context from your previous entries (see section 2.d). **No account identifier, no email address.** The request runs through our server, so Anthropic doesn't see your device's IP address either.
- **Legal basis**: Standard Contractual Clauses (SCC) per Art. 46(2)(c) GDPR.
- **What Anthropic does NOT do**: train on your content. According to the provider's terms, this is excluded for content sent via the API.
- **Retention at Anthropic**: According to the provider's terms, inputs and outputs are usually deleted within 30 days. Longer only in exceptional cases, e.g. if a request is flagged as violating Anthropic's usage policy or a legal obligation applies.

**If the US transfer feels too uncertain despite SCC:** You can meditate in KERN without anything going to Anthropic. But the AI doesn't only work when you reflect or formulate new perspectives. For example, it also uses your entries to write the weekly and monthly reviews in Tagebuch (Journal), the personal texts in your courses and the suggestion for your next course, as soon as you open Tagebuch or your courses, and after the first seven courses also the home screen. All of this only happens with your permission. It applies to each device, and you can withdraw it there anytime under Einstellungen (Settings) → App-Einstellungen (App settings) → Daten & Privatsphäre (Data & privacy) → KI-Antworten (AI replies). No text goes to Anthropic from that device after that: reflections and new perspectives pause, and no new personal texts are written. KERN shows fixed texts instead or leaves them out, and what was already written stays on your device.

### RevenueCat (USA)

- **Location**: San Francisco, USA (data processed on servers in the USA)
- **Purpose**: Handling and verifying purchases and subscriptions (KERN Premium) together with the App Store
- **What they see**: Your user UUID (from section 2.b), purchase and subscription data from the App Store (e.g. product, purchase date, term, status) and technical data such as app version, operating system and your device's IP address (the app talks to RevenueCat directly). Because the app asks RevenueCat with your UUID at launch whether a subscription is active, RevenueCat knows it even if you don't buy anything. **No content** from your reflections, no payment details (those stay with Apple).
- **What comes back**: RevenueCat reports changes to your subscription to our server. There we only store whether Premium is active, until when, which plan, where the entry comes from (via RevenueCat or a manual unlock by us) and when it last changed.
- **Legal basis**: Art. 6(1)(b) GDPR (contract - you buy a subscription, we unlock it). Data Processing Agreement per Art. 28 GDPR; the transfer to the USA is safeguarded by the Standard Contractual Clauses (Art. 46(2)(c) GDPR) included in it.

### Apple (USA)

If you sign in with Apple Sign-In, Apple handles the login. Apple sees only that you use KERN, not **what** you input. Purchases and subscriptions run through the App Store - your payment details stay with Apple, we don't see them. If you delete an account secured with Apple, our server also ends Sign in with Apple for KERN at Apple. To do so, it returns to Apple the one-time code that Apple issues when you confirm. None of it is stored. Details: [apple.com/legal/privacy](https://www.apple.com/legal/privacy/en-ww/).

**Voice input:** If you speak instead of typing, KERN uses Apple's speech recognition. Apple handles the conversion to text - depending on your device and settings, directly on your iPhone or on Apple's servers. KERN doesn't store any audio recordings; only the recognized text ends up in your input field. Voice input is optional; iOS asks for your permission for microphone and speech recognition first.

**Emails to us:** If you write to us, e.g. to hello@getkern.app (also directly from within KERN) or to datenschutz@getkern.app, your message and your email address are stored in our inbox at Apple (iCloud Mail). We use your address and what you write to us (e.g. your identifier) to reply to you and handle your request.

## 5. What we measure pseudonymously - and what **not**

> 🔍 **These statements are auditable.** Schema, code-of-conduct and all relevant database migrations live in the public [kern-legal-docs](https://github.com/denyolo/kern-legal-docs) repository - with full version history and commit reasoning. If anything is different from what's described here, you can see it yourself.

So you know exactly what happens:

**What we measure in numbers** (pseudonymized, that is, under an alias instead of your identifier, without your personal content):

- Number of reflections, perspectives, meditations per day/month (aggregated)
- Average character count of your answers (no texts - only length)
- When a reflection is aborted (which step, without content)
- Which meditation category is played how often
- How long an onboarding session takes
- When a free-tier limit is reached
- App engagement (how long you use KERN per session)
- Course progress, visits to the subscription page, whether the explainer video was watched, thumbs up/down for a meditation and whether you recommended KERN - each without your personal content
- How right a perspective feels when you practice it (the value 1-10), whether you first explore KERN without a conversation, how many answers you give in the opening conversation and where it stops, how many life areas and blocks KERN recognizes there, which voice a meditation used, whether a summary failed, whether you saw or tapped the card for the next course, whether the window asking for the AI permission appeared, and whether you agreed or chose "Nicht jetzt" (Not now) - each without your personal content

These numbers help us improve the app (e.g., "is the character cap too tight?", "where do users drop off?"). They land in a separate database table `usage_events` that by design has **no text columns for content** - only event type, time, category, numbers, a session identifier that is randomly generated anew each time you open the app, and since version 1.3.0 the platform (iPhone or Android) and the app version. Your user ID is **hashed** together with a secret key before saving - we see "Hash-User-abc had 5 reflections", not "Anna had 5 reflections". This is **pseudonymization**, not anonymization: the entries are stored under a pseudonym, that is, an alias, instead of your user ID, but with the secret key it would technically be possible to check which user ID an entry belongs to. We never do that with content and only in four cases: when you ask us to, when we repair a technically split account, for totals across all subscriptions, and when we are legally required to (section 9). If you ask, e.g. for access or an objection (section 7), we only look up your own entries. For a repair, we match the entries to individual accounts. The totals show what leads to a purchase (e.g. how many buyers completed a course beforehand) - for that, we never look at a single person. The numbers are collected regardless of your backup choice.

Schema publicly visible in our Legal repo: [migrations/0005_usage_events.sql](https://github.com/denyolo/kern-legal-docs/blob/main/migrations/0005_usage_events.sql), [migrations/0006_telemetry_hash_fix.sql](https://github.com/denyolo/kern-legal-docs/blob/main/migrations/0006_telemetry_hash_fix.sql) and [migrations/0037_usage_events_platform_version.sql](https://github.com/denyolo/kern-legal-docs/blob/main/migrations/0037_usage_events_platform_version.sql) (Repo: [kern-legal-docs](https://github.com/denyolo/kern-legal-docs)). The table for reported AI replies: [migrations/0038_ai_reports.sql](https://github.com/denyolo/kern-legal-docs/blob/main/migrations/0038_ai_reports.sql).

**What we deliberately don't do**:

- We use **no** third-party analytics like Google Analytics, Mixpanel, Amplitude
- We use **no** advertising SDKs (no Facebook Pixel, no AppsFlyer, no AdMob)
- We use **no** cookies in the app
- We use **no** tracking pixels
- We **never** read the content of your reflections, perspectives, thoughts, or goals. The only thing readable for us is an AI reply you explicitly include when reporting it (section 2.e)
- We don't sell your data to anyone, ever
- We don't pass your data to authorities unless we are legally required to (see section 9)

## 6. How long we keep your data

- **Local on your device**: as long as you have the app installed. Uninstalling makes iOS delete the app data. Two small entries remain in your iPhone's keychain: your sign-in (so your account is back after reinstalling) and - once KERN has encrypted anything for the cloud, which can happen even before your backup choice - your backup key in your iCloud Keychain. It stays even if you later choose "Nur auf diesem Gerät" (Only on this device).
- **In the cloud (if active)**: as long as your account exists. An anonymous account (not secured with Apple) that hasn't been used for 24 months and has neither a running subscription nor an unlock is deleted, along with its entries in the cloud and the data about its sign-ins. If you choose "Konto löschen" (Delete account) at the very bottom of Einstellungen (Settings), we delete your account with all content, on your iPhone and in the cloud: your entries, your usage counters, your subscription status with us, the data about your sign-ins and - if present - the Apple link with the email address stored for it. If your account is secured with Apple, you briefly confirm the deletion with Apple. We then also end Sign in with Apple for KERN at Apple, and KERN disappears from your "Sign in with Apple" list (section 4, Apple). If you don't confirm or it doesn't work right then, we delete your account anyway, and KERN shows you where to remove it there yourself. If the cleanup of an earlier automatic identifier is still running, KERN takes it along, unless a subscription or unlock is still running under it (section 2.b). If this cleanup doesn't work right away, for example without a connection, KERN tries again the next time you open the app. Our daily database backups and server logs still contain what was deleted for up to 7 days (see below). Your backup key stays in your iCloud Keychain because it applies to all KERN accounts of your Apple ID. Anything of your deleted account that it could decrypt then remains with us only in these backups and logs, and after 7 days at the latest not even there.
- **Reported AI replies (section 2.e)**: 12 months, after which the database deletes them automatically. Because a report is not linked to any account, it remains until then even after you delete your account. On request, we find it by the time and delete it earlier.
- **Usage numbers (section 5)**: remain after you delete your account. They contain no content and no user ID in plain text. Because your account no longer exists afterwards, there is no account we could assign them to.
- **Purchase and subscription data at RevenueCat and Apple**: If you delete your account, we also have your customer record at RevenueCat (your user UUID with purchase history) deleted. One exception for an earlier automatic identifier is in section 2.b. If you're still signed in on a second device, the app on that device can recreate your customer record at RevenueCat under your user UUID; we clean up such leftovers regularly. Receipts and subscriptions at Apple stay with Apple, under Apple's terms. If you have an active subscription, please cancel it first in your iPhone settings - deleting your account in KERN does not end it.
- **Database backups**: So that nothing is lost after a serious technical failure, our database provider Supabase creates a backup of the whole database every day and keeps it for 7 days. A backup is a copy of the database: whatever is encrypted there is also encrypted in the backup. Whatever you delete therefore remains in these backups for up to 7 days and then disappears on its own. A backup is only restored in such an emergency.
- **Server logs**: So we can find errors and detect misuse, our servers log technical events, e.g. when a request came in, which account it belonged to, from which IP address, with which app version and whether it worked. Your content is not in them in plain text. These logs are deleted automatically after 7 days.
- **Records of our access and repairs**: If we access the entries in your account (only with your explicit consent, e.g. for a support request, or because we are legally required to, see section 9) or work technically on individual accounts without reading content (e.g. repairing a split account or removing old unencrypted entries), we record the date, the reason and the account's identifier, and for a repair also the identifiers of the affected entries. These records are kept even after you delete your account, so it remains traceable when and why we did it. They contain no content. We also look at technical data without content (e.g. timestamps, counts, the subscription status or whether an entry is encrypted) of individual accounts, without recording this separately, when running KERN requires it, e.g. to find an error - never to see how you use KERN. We only match the usage numbers from section 5 to an account in the cases listed there.
- **AI processing logs at Anthropic**: according to the provider's terms, usually up to 30 days (exceptions see section 4).

## 7. Your rights (GDPR)

You have the right, anytime, to:

- **Access** your data stored with us (Art. 15)
- **Rectification** of incorrect data (Art. 16)
- **Erasure** ("right to be forgotten", Art. 17)
- **Restriction of processing** (Art. 18)
- **Data portability** (Art. 20) - on request we'll provide a JSON export of the data stored with us. Your content in it is encrypted, because only your device can read it.
- **Object** to processing (Art. 21) - e.g. to the usage numbers from section 5
- **Withdraw consent** once given (Art. 7(3))

For all of these: send a short email to datenschutz@getkern.app. We respond within 30 days. Usually much faster.

**Inside the app:**

- "Konto löschen" (Delete account) is at the very bottom of Einstellungen (Settings). After a confirmation, it deletes your account with all content, locally and (if active) in the cloud, including an Apple link. Reports about AI replies are not linked to any account; we delete them on request (section 2.e).
- Change your cloud preference in Einstellungen (Settings) → App-Einstellungen (App settings) → Daten & Privatsphäre (Data & privacy).
- Withdraw your permission for the AI in the same place under KI-Antworten (AI replies). It applies to each device.

## 8. Right to lodge a complaint

If you believe we're not handling your data properly, you can complain to the data protection authority. For KERN, the responsible authority is:

**Berlin Commissioner for Data Protection and Freedom of Information (BlnBDI)**
Friedrichstr. 219, 10969 Berlin, Germany
Phone: +49 30 13889-0
Email: mailbox@datenschutz-berlin.de

## 9. Government requests

We only disclose data to authorities when legally required - i.e. when a German court or competent German authority compels us under valid law. In that case we notify you, to the extent legally permitted.

We do **not** disclose data to US authorities on US requests, because the data from the app that we store ourselves is in the EU and we are not subject to US jurisdiction.

## 10. Reminders

If you enable reminders (optional), your iPhone schedules and shows them itself. No server sends them, not even Apple's push service. When you want to be reminded is part of your settings and, with cloud backup on, is stored readably in the cloud (section 2.c).

## 11. Who KERN is for

KERN is meant for adults aged 18 and over. If you are younger, please don't use KERN. We don't ask for your age, and we don't knowingly collect data from anyone under 18. You can delete an existing account at any time with "Konto löschen" (Delete account) at the very bottom of Einstellungen (Settings).

## 12. Website and waitlist

This policy also applies to our website getkern.app.

- **Hosting:** The website is hosted by Vercel (USA). Like any web server, Vercel processes technical data such as your IP address and browser when you visit, so the page reaches you and runs securely. The basis is our legitimate interest in a working website (Art. 6(1)(f) GDPR).
- **Fonts:** They are on our own server. Your browser loads nothing from Google for them.
- **No cookies, no tracking** on the website.
- **Android waitlist:** If you enter your email address, we store it with the time and platform in a Google spreadsheet (Google, USA). We use it only for one message once KERN is available for Android, and delete it afterwards. The basis is your consent (Art. 6(1)(a) GDPR). You can withdraw it anytime by emailing datenschutz@getkern.app, and we'll delete your address right away.

## 13. Changes to this policy

If processing changes, we update this page. The date at the top tells you when the policy was last changed.

## 14. Contact

Questions? Concerns? Write us: hello@getkern.app

For formal privacy requests: datenschutz@getkern.app

---

*KERN - Reflect · Meditate · Manifest.*
*Your inner movements belong to you.*
