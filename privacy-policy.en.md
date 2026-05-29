# Privacy Policy

**Last updated: May 27, 2026**

KERN is an app for inner work — and this is first and foremost about personal things. So we handle your data the way we'd want ours handled: respectfully.

This policy tells you in plain language what we store, where it goes, and what we deliberately **don't** do.

---

## Quick read — you're safe here

Before the details, here's in plain language what happens in the background.

- **We don't know who you are.** No name, no email, no phone number.
- **What you send to the AI goes anonymously.** Anthropic (the company behind the AI) receives the text of your reflection, but no identity that traces back to you.
- **Your content stays yours.** No selling, no AI training on your words, no third-party sharing.
- **You choose where your data lives.** Default: only on your iPhone. Optional: encrypted as backup on EU servers.
- **No third-party tracking, no advertising analytics, no cookies.** Push notifications also run entirely locally on your iPhone — no server watches along, not even Apple.
- **Anonymous usage metrics** (number of reflections, average meditation duration, character count per answer): We collect these **numbers** to improve KERN. **No content** — we never see *what* you reflect on. Details in [section 5](#5-what-we-anonymously-measure--and-what-not).
- **Delete everything anytime** with one tap in settings.

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

This data **always** lives on your iPhone — regardless of which backup option you choose:

- Your onboarding answers
- Goals and blocks you formulate
- Reflections (free + guided)
- Insights KERN extracts from your texts
- Affirmations / integrations you create
- Saved thoughts
- Meditation sessions (time, duration, category)
- Settings (language, voice, notifications)

**You don't give us any identifiers** — no email, no name, no phone number. The profile is anonymous on your device.

### b) What our servers see in any case — even without cloud backup

For KERN to work at all (e.g. to generate AI responses, check rate limits), we need a technical identity for you. So on first app launch, KERN automatically creates an **anonymous user UUID** on our servers in Frankfurt. This UUID:

- Is a random string — **no name, no email, no phone number**
- Cannot be traced back to you as a person
- Is needed so your next reflection mirror connects to the same conversation as previous ones

### c) Cloud backup (only if you want it)

During onboarding you **additionally** choose whether KERN mirrors your *content* (reflections, insights, vision, history) on our servers. You can change this choice **anytime** in settings.

- **Cloud backup on**: Your content is stored on EU servers (Frankfurt, Germany) — encrypted both in transit (TLS) and at rest (AES-256). **Important to know**: We can technically access this data if needed, because our cloud provider Supabase holds the keys. This is **not** end-to-end encryption. End-to-end — where even we cannot look in — is something we're building post-beta. If you lose your iPhone, you can get back in.
- **Only on this device**: Your *content* (reflections, insights, history, vision) doesn't leave your iPhone. Only the anonymous user UUID from section b) continues to exist on our servers. Maximum privacy for your content, but no recovery if you lose the device.

When cloud backup is on, we additionally process:

- Sign-in timestamps (for account recovery)
- With Apple Sign-In: your Apple user ID (hashed, anonymized by Apple)

### d) AI responses (when you reflect)

When KERN responds to a reflection or summarizes an insight, the **text** of your reflection is sent to Anthropic (the company behind the Claude AI model) — **without your identity**. Anthropic does not learn *who* writes, only *what*. Anthropic does **not** train on your content (contractually excluded) and stores API inputs for at most 30 days as an operations log, then deletes them. Transmission runs TLS-encrypted. More details in section 4.

## 3. What we use this data for

- To make the app work (history, stats, vision tracking)
- To give you AI-supported mirrors (Mirror, affirmations, insight classification)
- To restore your data **if** you chose cloud backup
- For nothing else

**We don't use your data for advertising. We don't sell it. We don't train AI on your content.**

Legal basis: Art. 6(1)(b) GDPR (contract — you use the app, we provide the function) and Art. 6(1)(a) GDPR (your consent for the cloud choice).

## 4. Who sees your data?

We work with two processors. These are the only external parties that technically process your data:

### Supabase (EU)

- **Processing location**: Frankfurt am Main, Germany (EU)
- **Purpose**: Cloud backup of your data + technical bridge to Anthropic (AI)
- **Legal basis**: Data Processing Agreement per Art. 28 GDPR
- **What they see**: Encrypted data + technical metadata

Supabase is always active (for your anonymous UUID, see section 2.b). Your **content** (reflections, insights, etc.) only goes to Supabase if you've enabled cloud backup or when KERN is fetching an AI response for you.

### Anthropic (USA)

- **Location**: San Francisco, USA
- **Purpose**: AI models (Claude) generate KERN's responses and analyze your reflections
- **What goes out**: Only the **text** of your current reflection / question / affirmation. No name, no email, no user ID.
- **Legal basis**: Standard Contractual Clauses (SCC) per Art. 46(2)(c) GDPR. Anthropic is, according to their own statements, certified under the EU-US Data Privacy Framework.
- **What Anthropic does NOT do**: train on your content. This is contractually excluded in the API agreement.
- **Retention at Anthropic**: 30-day operational log, then deleted. No permanent storage of API inputs.

**If the US transfer feels too uncertain despite SCC, you can continue to use the app, but AI features (Mirror, automatic insight extraction, affirmation generation) won't be available.** We're currently building an option to route all AI calls through EU-hosted models — update to follow.

### Apple (USA)

If you sign in with Apple Sign-In, Apple handles the login. Apple sees only that you use KERN, not **what** you input. Details: [apple.com/legal/privacy](https://www.apple.com/legal/privacy/en-ww/).

## 5. What we anonymously measure — and what **not**

> 🔍 **These statements are auditable.** Schema, code-of-conduct and all relevant database migrations live in the public [kern-legal-docs](https://github.com/denyolo/kern-legal-docs) repository — with full version history and commit reasoning. If anything is different from what's described here, you can see it yourself.

So you know exactly what happens:

**What we measure in numbers** (anonymous, no content):

- Number of reflections, affirmations, meditations per day/month (aggregated)
- Average character count of your answers (no texts — only length)
- When a reflection is aborted (which step, without content)
- Which meditation category is played how often
- How long an onboarding session takes
- When a free-tier limit is reached
- App engagement (how long you use KERN per session)

These numbers help us improve the app (e.g., "is the character cap too tight?", "where do users drop off?"). They land in a separate database table `usage_events` that by design has **no text columns for content**. Your user ID is **hashed** with a secret key before saving — we see "Hash-User-abc had 5 reflections", not "Anna had 5 reflections".

Schema publicly visible in our Legal repo: [migrations/0005_usage_events.sql](https://github.com/denyolo/kern-legal-docs/blob/main/migrations/0005_usage_events.sql) (Repo: [kern-legal-docs](https://github.com/denyolo/kern-legal-docs))

**What we deliberately don't do**:

- We use **no** third-party analytics like Google Analytics, Mixpanel, Amplitude
- We use **no** advertising SDKs (no Facebook Pixel, no AppsFlyer, no AdMob)
- We use **no** cookies in the app
- We use **no** tracking pixels
- We **never** read the content of your reflections, affirmations, thoughts, or vision texts
- We don't sell your data to anyone, ever
- We don't pass your data to authorities, unless legally compelled (see section 9)

## 6. How long we keep your data

- **Local on your device**: as long as you have the app installed. Uninstalling deletes all local data (iOS standard).
- **In the cloud (if active)**: as long as your account exists. You can choose "Delete all data" in settings anytime — we then wipe both local and (if active) cloud data.
- **AI processing logs at Anthropic**: max. 30 days.

## 7. Your rights (GDPR)

You have the right, anytime, to:

- **Access** your data stored with us (Art. 15)
- **Rectification** of incorrect data (Art. 16)
- **Erasure** ("right to be forgotten", Art. 17)
- **Restriction of processing** (Art. 18)
- **Data portability** (Art. 20) — we'll provide a JSON export on request
- **Object** to processing (Art. 21)
- **Withdraw consent** once given (Art. 7(3)) — e.g. turn off cloud backup, anytime

For all of these: send a short email to datenschutz@getkern.app. We respond within 30 days. Usually much faster.

**Inside the app:**

- "Delete all data" lives in Settings → Account. One tap removes everything locally and (if active) in the cloud.
- Change cloud preference in Settings → Data & Privacy.

## 8. Right to lodge a complaint

If you believe we're not handling your data properly, you can complain to the data protection authority. For KERN, the responsible authority is:

**Berlin Commissioner for Data Protection and Freedom of Information (BlnBDI)**
Friedrichstr. 219, 10969 Berlin, Germany
Phone: +49 30 13889-0
Email: mailbox@datenschutz-berlin.de

## 9. Government requests

We only disclose data to authorities when legally required — i.e. when a German court or competent German authority compels us under valid law. In that case we notify you, to the extent legally permitted.

We do **not** disclose data to US authorities on US requests, because our data is in the EU and we are not subject to US jurisdiction.

## 10. Push notifications

If you enable push notifications (optional), they run **entirely locally on your iPhone**. Content and timing are decided on your device — no server watches along, not even Apple's. Apple sees neither that you use notifications, nor when, nor with what content.

## 11. Changes to this policy

If processing changes, we update this page and show you a note on the next app start. The date at the top tells you when the policy was last changed.

## 12. Contact

Questions? Concerns? Write us: hello@getkern.app

For formal privacy requests: datenschutz@getkern.app

---

*KERN — Reflect · Meditate · Manifest.*
*Your inner movements belong to you.*
