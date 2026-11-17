# Meeting Voting App - Setup and Deployment Guide

Everything used in this project is 100% free: **Supabase** (database + admin authentication) and **Vercel / Netlify** (hosting).

## Files in This Repository
- `index.html` - The complete application (voter interface + admin dashboard)
- `schema.sql` - Database schema, security policies, and tabulation function
- `README.md` - Main project documentation
- `SETUP_GUIDE.md` - Step-by-step setup guide (English)
- `SETUP_GUIDE_URDU.md` - Step-by-step setup guide (Roman Urdu)

---

## Step 1: Create a Supabase Project
1. Go to [https://supabase.com](https://supabase.com), sign up or log in, and click **New project**.
2. Give your project a name (e.g., `voting`), set a secure database password (make sure to save it), and select the region closest to you.
3. Wait 1–2 minutes while Supabase provisions your project.

## Step 2: Create Database Tables
1. In the left navigation menu, go to **SQL Editor** > **New query**.
2. Copy and paste the entire contents of [`schema.sql`](./schema.sql).
3. Click **Run**. You should see a "Success" message confirming the tables, policies, and RPC function were created.

## Step 3: Create the Admin Account
1. In the left menu, go to **Authentication** > **Users** > **Add user** > **Create new user**.
2. Enter the admin's email and password, and check the **Auto Confirm User** checkbox.
3. This is the login credential that the club admin/organizer will use.
4. **(Important)** Go to **Authentication** > **Providers** > **Email** (or **Sign In / Providers**) and turn **Allow new users to sign up** to **OFF**. This ensures unauthorized public users cannot register as admins.

## Step 4: Copy Supabase API Keys
1. Go to **Project Settings** > **API** (or **Data API**).
2. Copy your **Project URL** and the **anon (public)** key.
3. Open `index.html` in an editor (VS Code, Notepad, etc.) and replace the placeholder values at the top of the script:
```js
const SUPABASE_URL = "PASTE_PROJECT_URL";
const SUPABASE_KEY = "PASTE_ANON_PUBLIC_KEY";
```
*(Note: Only use the **anon / public** key here. Never use the `service_role` secret key in client-side code).*
4. Optionally, customize the `CLUB_NAME` constant to match your club's name.

## Step 5: Deploy the App (Free)

### Option A: Netlify Drop (Easiest & Fastest — No GitHub Required)
1. Go to [https://app.netlify.com/drop](https://app.netlify.com/drop).
2. Drag and drop the folder containing `index.html`.
3. In about 30 seconds, your site will be live with a URL like `https://xyz.netlify.app`.

### Option B: Deploy with Vercel or GitHub Pages
1. Sign up or log in at [https://vercel.com](https://vercel.com).
2. Create a GitHub repository, commit and push your files (`index.html`, `schema.sql`, etc.).
3. In Vercel, click **Add New** > **Project**, import your repository, and click **Deploy**. (Framework preset = **Other**, no build command needed).
4. Alternatively, enable **GitHub Pages** directly from your repository's **Settings** > **Pages** (Source: Deploy from branch `main` / `root`).

Your application is now live at `https://your-site.app/`!

## Step 6: Get Your Permanent Voting QR Code
1. Open `https://your-site.app/#admin` in your browser and log in with your admin credentials.
2. Scroll to the bottom to find the **Voting QR code**.
3. Click **Download QR** and print it onto cards or table stands.
4. **This QR code is permanent.** It always directs voters to whichever meeting is currently open, so you do not need to print new QR codes for future meetings.

---

## Workflow for Every Meeting (For the Organizer / Client)
1. Visit `https://your-site.app/#admin` and log in.
2. **Create New Meeting**: Enter the meeting title, date, and nominee names for each category (one name per line). Click **Save meeting**.
3. When the meeting starts, click **Open voting**.
4. **Category-Level Voting Control (Enable / Disable per Category):**
   - Under the open meeting, you will see buttons for every category (e.g., *Best Table Topic*, *Best Prepared Speech*, *Best Evaluator*).
   - Click any category button to toggle it **OPEN (green)** or **DISABLED (gray)**.
   - You can also click **Enable All** or **Disable All**.
   - Voters will **ONLY** see the categories you have enabled!
   - When one category's voting finishes (e.g., Table Topics), disable it and enable the next category (e.g., Prepared Speeches). Attendees can vote in each round without being blocked.
5. The audience scans the table QR code on their mobile phones to cast their votes. Each phone/browser is restricted to one vote per category.
6. At the end of the meeting, click **Close voting**. Anyone scanning the QR code or refreshing their page will now immediately see the results and designated winners.
7. Organizers can view past meeting results at any time by clicking **Results** under the **Meetings** list in the admin panel.

---

## Database Migration for Category Controls
If you previously created the Supabase tables, run this one line in **Supabase SQL Editor**:
```sql
ALTER TABLE meetings ADD COLUMN IF NOT EXISTS active_categories text[];
```

*Award categories include:* Best Table Topic Speaker, Best Prepared Speaker, Best Evaluator, Best Facilitator / Auxiliary Role, and Best of Big Three (TMOD, Table Topic Master, and General Evaluator).

---

## Important Operational Notes
- **Supabase Free Tier Inactivity Pause:** Supabase projects on the free tier may pause after 1 week of inactivity. Before your meeting, check the Supabase dashboard—if the project is paused, simply click **Restore**. Alternatively, you can set up a free ping at [https://cron-job.org](https://cron-job.org) that sends a daily GET request to `SUPABASE_URL/rest/v1/meetings?select=id` with header `apikey: <anon key>`.
- **Duplicate Vote Prevention:** Each device browser generates and stores a unique device ID. Note that if someone uses a different browser or an incognito window, a new device ID is generated.
- **Account Handover:** Create the Supabase and hosting accounts using the client's/club's email address or transfer project ownership to them after setup.
- **Always Test Before the Meeting:** After deploying, create a test meeting, submit votes from 2 separate phones, close the voting to inspect results, and then delete the test meeting from the admin panel.
