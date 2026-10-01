# Privacy Policy

**Last updated: October 1, 2026**

KERN is an app for inner work - and this is first and foremost about personal things. So we handle your data the way we'd want ours handled: respectfully.

This policy tells you in plain language what we store, where it goes, and what we deliberately **don't** do.

---

## Quick read - you're safe here

Before the details, here's in plain language what happens in the background.

- **You start anonymously.** No name, no email, no phone number. Only if you choose to secure your account with Apple do we store the email address Apple sends us for that (if you like, an anonymous relay address from Apple).
- **What you send to the AI goes without your ID.** Anthropic (the company behind the AI) receives the text of your conversation and a short context from your previous entries, but no identifier that leads back to your account.
- **Your content stays yours.** No selling, no AI training on your words, no third-party sharing.
- **You choose where your data lives.** The default is an **end-to-end encrypted** backup on EU servers - **only your device can read it, not us.** Alternatively, your content stays only on your iPhone. You can switch anytime in settings.
- **No third-party tracking, no advertising analytics, no cookies.** Push notifications also run entirely locally on your iPhone - no server watches along, not even Apple.
- **Pseudonymized usage metrics** (number of reflections, average meditation duration, character count per answer): We collect these **numbers** under a pseudonym instead of your user ID, to improve KERN. **No content** - we never see *what* you reflect on. Details in [section 5](#5-what-we-measure-pseudonymously---and-what-not).
- **Delete your account anytime** in settings - with all your content, locally and in the cloud.

The rest of this page explains it in detail, if you want to look deeper.

---

## 1. Who is responsible?

The data controller for this app is:

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
- Settings (language, voice, notifications)

**You don't need any identifiers to use KERN** - no email, no name, no phone number. The profile is anonymous on your device (for the optional Apple sign-in, see section b).

### b) What our servers see in any case - even without cloud backup

For KERN to work at all (e.g. to generate AI responses, check usage limits), we need a technical identity for you. So on first app launch, KERN automatically creates an **anonymous user UUID** on our servers in Frankfurt. This UUID:

- Is a random string - **no name, no email, no phone number**
- Cannot be linked to you as a person as long as you use KERN anonymously
- Is needed to check usage limits and your subscription status and - if active - to assign your backup to your account

Alongside this UUID, our server also stores technical data: sign-in timestamps, your usage counters (for the limits of the free version) and your subscription status (whether Premium is active, until when and which plan).

**Optional: secure your account with Apple.** If you choose to secure your account with "Sign in with Apple" (during onboarding, when restoring, or in settings), KERN asks Apple for your email address and name. We store (in Supabase's sign-in service) the email address Apple sends us and a sign-in identifier assigned by Apple. If you choose "Hide My Email" at Apple, this is an anonymous relay address from Apple. **We don't store your name.** Purpose: so you can sign in again and restore your account on a new device. Your account is then no longer anonymous but linked to this email address.

### c) Cloud backup

During onboarding you **additionally** choose whether KERN backs up your *content* (reflections, insights, goals, history) on our servers. The encrypted backup is the default (and preselected in onboarding). You can change this choice **anytime** in settings.

- **Cloud backup on**: Your content is **encrypted on your iPhone before it ever reaches our servers** (end-to-end, AES-256-GCM); transfer is additionally secured via TLS. On our EU servers (Frankfurt, Germany) your **content** is therefore stored **only as unreadable ciphertext** - **even we cannot read it**, not in an emergency, not if we wanted to. Only technical data that KERN needs for counting and sorting stays readable: time, duration and category of a meditation, ratings and scale values (e.g. how close you feel to a goal), the status of an entry (e.g. done, resolved or hidden) and the totals of your journey. The key lives solely in your **iCloud Keychain** (Apple syncs it end-to-end across your devices); KERN never sees it. **One deliberate exception**: when KERN answers you with the AI, the text needed for that and a short context from your previous entries (see section d) pass in cleartext (TLS-secured, but not end-to-end) through our server to the AI. **Our server only passes them on and doesn't store them**; at Anthropic, the retention periods from section 4 apply. Recovery works through your iCloud Keychain: as long as it's on, you regain your content on a new device. If it's off and your device is gone, the encrypted content cannot be recovered - that's the price of true confidentiality.
- **Only on this device**: Your *content* (reflections, insights, history, goals) is not backed up to the cloud. It only leaves your iPhone briefly when KERN answers you with the AI (section d). Our servers then hold only the technical data from section b) and the pseudonymized usage metrics from section 5. Maximum privacy for your content, but no recovery if you lose the device.

### d) AI responses (when KERN answers you)

When KERN answers you, for example in a conversation, for new perspectives, summaries, reviews or course texts, our server sends the text needed for that to Anthropic (the company behind the Claude AI model): the text in question, plus a short context from your previous entries (e.g. your answers from the start of the app, your "About you" summary, goals, life areas, blocks, your recent insights and excerpts from your recent reflections and thoughts), so the answer fits you. **No account identifier is sent** - Anthropic does not learn which account the request belongs to. According to the provider's terms, Anthropic does **not** train on this content and usually deletes it within 30 days. Transmission runs TLS-encrypted. More details in section 4.

## 3. What we use this data for

- To make the app work (history, stats, progress on your goals)
- To give you AI-supported responses (KERN's conversation feature, perspectives, summaries, insight classification)
- To restore your data **if** you chose cloud backup
- To restore your account **if** you secured it with Apple
- To handle purchases and your subscription status
- To improve KERN with pseudonymized usage numbers (see section 5)
- For nothing else

**We don't use your data for advertising. We don't sell it. We don't train AI on your content.**

Legal basis: Art. 6(1)(b) GDPR (contract - you use the app, we provide the function) and Art. 6(1)(a) GDPR (your consent for the cloud choice).

## 4. Who sees your data?

We work with three processors: Supabase, Anthropic and RevenueCat. These are the only external parties that technically process your data on our behalf. In addition, Apple as the platform provider processes some data under its own responsibility (see below).

### Supabase (EU)

- **Processing location**: Frankfurt am Main, Germany (EU)
- **Purpose**: Cloud backup of your data, sign-in + technical bridge to Anthropic (AI)
- **Legal basis**: Data Processing Agreement per Art. 28 GDPR
- **What they see**: Encrypted content + readable technical data (UUID, sign-in timestamps, usage counters, subscription status and the time, duration and scale values named in section 2.c) and - if you secure your account with Apple - your email address

Supabase is always active (for your anonymous UUID, see section 2.b). Your **content** (reflections, insights, etc.) only goes to Supabase if you've enabled cloud backup (then encrypted) or when KERN is fetching an AI response for you.

### Anthropic (USA)

- **Location**: San Francisco, USA
- **Purpose**: AI models (Claude) generate KERN's responses and analyze your reflections
- **What goes out**: The text in question (e.g. your conversation with KERN, a block you're formulating new perspectives for, or your entries for a review), plus a short context from your previous entries (see section 2.d). **No account identifier, no email address.** The request runs through our server, so Anthropic doesn't see your device's IP address either.
- **Legal basis**: Standard Contractual Clauses (SCC) per Art. 46(2)(c) GDPR.
- **What Anthropic does NOT do**: train on your content. According to the provider's terms, this is excluded for content sent via the API.
- **Retention at Anthropic**: According to the provider's terms, inputs and outputs are usually deleted within 30 days. Longer only in exceptional cases, e.g. if a request is flagged as violating Anthropic's usage policy or a legal obligation applies.

**If the US transfer feels too uncertain despite SCC, you can continue to use the app, but AI features (KERN's conversation feature, automatic insight extraction, perspective generation) won't be available.**

### RevenueCat (USA)

- **Location**: San Francisco, USA (data processed on servers in the USA)
- **Purpose**: Handling and verifying purchases and subscriptions (KERN Premium) together with the App Store
- **What they see**: Your anonymous user UUID (from section 2.b), purchase and subscription data from the App Store (e.g. product, purchase date, term, status) and technical data such as app version and operating system. Because the app asks RevenueCat with your UUID at launch whether a subscription is active, RevenueCat knows it even if you don't buy anything. **No content** from your reflections, no payment details (those stay with Apple).
- **What comes back**: RevenueCat reports changes to your subscription to our server. There we only store whether Premium is active, until when, which plan, where the entry comes from (via RevenueCat or a manual unlock by us) and when it last changed.
- **Legal basis**: Art. 6(1)(b) GDPR (contract - you buy a subscription, we unlock it). Data Processing Agreement per Art. 28 GDPR; the transfer to the USA is safeguarded by the Standard Contractual Clauses (Art. 46(2)(c) GDPR) included in it.

### Apple (USA)

If you sign in with Apple Sign-In, Apple handles the login. Apple sees only that you use KERN, not **what** you input. Purchases and subscriptions run through the App Store - your payment details stay with Apple, we don't see them. Details: [apple.com/legal/privacy](https://www.apple.com/legal/privacy/en-ww/).

**Voice input:** If you speak instead of typing, KERN uses Apple's speech recognition. Apple handles the conversion to text - depending on your device and settings, directly on your iPhone or on Apple's servers. KERN doesn't store any audio recordings; only the recognized text ends up in your input field. Voice input is optional; iOS asks for your permission for microphone and speech recognition first.

## 5. What we measure pseudonymously - and what **not**

> 🔍 **These statements are auditable.** Schema, code-of-conduct and all relevant database migrations live in the public [kern-legal-docs](https://github.com/denyolo/kern-legal-docs) repository - with full version history and commit reasoning. If anything is different from what's described here, you can see it yourself.

So you know exactly what happens:

**What we measure in numbers** (pseudonymized, no content):

- Number of reflections, perspectives, meditations per day/month (aggregated)
- Average character count of your answers (no texts - only length)
- When a reflection is aborted (which step, without content)
- Which meditation category is played how often
- How long an onboarding session takes
- When a free-tier limit is reached
- App engagement (how long you use KERN per session)
- Course progress, visits to the subscription page, whether the explainer video was watched, thumbs up/down for a meditation and whether you recommended KERN - each without content

These numbers help us improve the app (e.g., "is the character cap too tight?", "where do users drop off?"). They land in a separate database table `usage_events` that by design has **no text columns for content** - only event type, time, category, numbers and a session identifier that is randomly generated anew each time you open the app. Your user ID is **hashed** together with a secret key before saving - we see "Hash-User-abc had 5 reflections", not "Anna had 5 reflections". This is **pseudonymization**, not anonymization: the entries are stored under a pseudonym instead of your user ID, but with the secret key it would technically be possible to check which user ID an entry belongs to. The numbers are collected regardless of your backup choice.

Schema publicly visible in our Legal repo: [migrations/0005_usage_events.sql](https://github.com/denyolo/kern-legal-docs/blob/main/migrations/0005_usage_events.sql) and [migrations/0006_telemetry_hash_fix.sql](https://github.com/denyolo/kern-legal-docs/blob/main/migrations/0006_telemetry_hash_fix.sql) (Repo: [kern-legal-docs](https://github.com/denyolo/kern-legal-docs))

**What we deliberately don't do**:

- We use **no** third-party analytics like Google Analytics, Mixpanel, Amplitude
- We use **no** advertising SDKs (no Facebook Pixel, no AppsFlyer, no AdMob)
- We use **no** cookies in the app
- We use **no** tracking pixels
- We **never** read the content of your reflections, perspectives, thoughts, or goals
- We don't sell your data to anyone, ever
- We don't pass your data to authorities, unless legally compelled (see section 9)

## 6. How long we keep your data

- **Local on your device**: as long as you have the app installed. Uninstalling makes iOS delete the app data. Two small entries remain in your iPhone's keychain: your sign-in (so your account is back after reinstalling) and - if you use cloud backup - your backup key in your iCloud Keychain.
- **In the cloud (if active)**: as long as your account exists. You can choose "Delete account" in settings anytime - we then delete your account with all content, locally and in the cloud, including an Apple link and the email address stored for it. Your backup key stays in your iCloud Keychain because it applies to all KERN accounts of your Apple ID; after deletion there is no data left that it could decrypt.
- **Pseudonymized usage metrics (section 5)**: remain after you delete your account. They contain no content and no user ID in plain text. Because your account no longer exists afterwards, there is no account we could assign them to.
- **Purchase and subscription data at RevenueCat and Apple**: according to these providers' terms. "Delete account" in KERN doesn't automatically delete it there.
- **AI processing logs at Anthropic**: according to the provider's terms, usually up to 30 days (exceptions see section 4).

## 7. Your rights (GDPR)

You have the right, anytime, to:

- **Access** your data stored with us (Art. 15)
- **Rectification** of incorrect data (Art. 16)
- **Erasure** ("right to be forgotten", Art. 17)
- **Restriction of processing** (Art. 18)
- **Data portability** (Art. 20) - on request we'll provide a JSON export of the data stored with us. Your content in it is encrypted, because only your device can read it.
- **Object** to processing (Art. 21)
- **Withdraw consent** once given (Art. 7(3)) - e.g. turn off cloud backup, anytime

For all of these: send a short email to datenschutz@getkern.app. We respond within 30 days. Usually much faster.

**Inside the app:**

- "Delete account" is at the very bottom of Settings. After a confirmation, it deletes your account with all content, locally and (if active) in the cloud, including an Apple link.
- Change cloud preference in Settings → App settings → Data & Privacy.

## 8. Right to lodge a complaint

If you believe we're not handling your data properly, you can complain to the data protection authority. For KERN, the responsible authority is:

**Berlin Commissioner for Data Protection and Freedom of Information (BlnBDI)**
Friedrichstr. 219, 10969 Berlin, Germany
Phone: +49 30 13889-0
Email: mailbox@datenschutz-berlin.de

## 9. Government requests

We only disclose data to authorities when legally required - i.e. when a German court or competent German authority compels us under valid law. In that case we notify you, to the extent legally permitted.

We do **not** disclose data to US authorities on US requests, because the data we store ourselves is in the EU and we are not subject to US jurisdiction.

## 10. Push notifications

If you enable push notifications (optional), they run **entirely locally on your iPhone**. Content and timing are decided on your device - no server watches along, not even Apple's. Apple sees neither that you use notifications, nor when, nor with what content.

## 11. Changes to this policy

If processing changes, we update this page. The date at the top tells you when the policy was last changed.

## 12. Contact

Questions? Concerns? Write us: hello@getkern.app

For formal privacy requests: datenschutz@getkern.app

---

*KERN - Reflect · Meditate · Manifest.*
*Your inner movements belong to you.*
