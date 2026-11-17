# Meeting Voting App - Setup aur Deployment Guide (Roman Urdu)

Sab kuch free hai: Supabase (database + admin login) + Vercel (hosting).

## Folder mein kya hai
- `index.html` - poori app (voter page + admin panel)
- `schema.sql` - database tables
- `README.md` - GitHub main documentation

---

## Step 1: Supabase project banao
1. https://supabase.com par sign up karo, **New project** pe click karo.
2. Name do (e.g. `voting`), database password set karo (save kar lo), region apne qareeb ka choose karo.
3. 1-2 minute wait karo jab tak project ready ho.

## Step 2: Database tables banao
1. Left menu: **SQL Editor** > **New query**.
2. `schema.sql` ka poora content copy-paste karo.
3. **Run** dabao. "Success" aana chahiye.

## Step 3: Admin account banao
1. Left menu: **Authentication** > **Users** > **Add user** > **Create new user**.
2. Admin ka email + password do, **Auto Confirm User** tick karo.
3. Ye client ko dene wala admin login hai.
4. (Zaroori) **Authentication** > **Sign In / Providers** mein **Allow new users to sign up** OFF kar do, taake koi aur admin account na bana sake.

## Step 4: Keys copy karo
1. **Project Settings** > **API** (ya **Data API**).
2. **Project URL** aur **anon public key** copy karo.
3. `index.html` kholo (Notepad/VS Code) aur top par ye do lines replace karo:
```js
const SUPABASE_URL = "PASTE_PROJECT_URL";
const SUPABASE_KEY = "PASTE_ANON_PUBLIC_KEY";
```
(Sirf **anon/public** key use karo, kabhi `service_role` key nahi.)
4. Chaho to `CLUB_NAME` bhi change kar lo.

## Step 5: Vercel par deploy karo (free)
1. https://vercel.com par sign up karo.
2. **Add New** > **Project**. Agar GitHub use nahi karna to Vercel CLI ya **Netlify Drop** use karo (neeche).
3. **Sabse asaan way - Netlify Drop:** https://app.netlify.com/drop kholo, `voting-app` folder drag-drop karo. 30 second mein link mil jata hai (e.g. `https://xyz.netlify.app`).
4. Vercel prefer ho to: GitHub repo banao, `index.html` push karo, Vercel mein repo import karo, **Deploy** dabao. Framework = **Other**, koi build command nahi.

Ab app live hai: `https://your-site.app/`

## Step 6: QR code
1. Browser mein `https://your-site.app/#admin` kholo, admin login karo.
2. Neeche **Voting QR code** milega. **Download QR** dabao aur print kar lo.
3. Ye QR hamesha wohi rahe ga. Har meeting ke liye dobara print nahi karna.

---

## Har meeting ka workflow (client ke liye)
1. `https://your-site.app/#admin` > login.
2. **New meeting**: title, date, har category mein naam likho (ek line mein ek naam). **Save meeting**.
3. Meeting shuru hone par **Open voting** dabao.
4. **Category Enable / Disable feature:**
   - Open meeting ke neeche har category ka button hoga (e.g. *Best Table Topic*, *Best Prepared Speech*).
   - Button click karke kisi bhi category ko **OPEN (green)** ya **DISABLED (gray)** kar sakte hain.
   - **Enable All** aur **Disable All** buttons bhi hain.
   - Voters ko sirf wohi categories nazar aayengi jo admin ne OPEN ki hongi!
   - Table Topics khatam hone par Table Topics ko disable karein aur Prepared Speech ko enable karein. Audience asani se har round mein vote kar sakti hai.
5. Audience QR scan karke vote karti hai. Ek phone se har category mein ek hi vote ja sakta hai.
6. Meeting ke end par **Close voting** dabao. Ab QR scan karne par sab ko result nazar aata hai.
7. Admin panel ki **Meetings** list mein purane meetings ka **Results** (previous records) kisi bhi waqt dekh sakte hain.

---

## Zaroori Step (Supabase SQL)
Agar pehle se Supabase tables bani hui hain, to Supabase ke **SQL Editor** mein ye ek line chala do:
```sql
ALTER TABLE meetings ADD COLUMN IF NOT EXISTS active_categories text[];
```

Best of Big Three: TMOD, Table Topic Master, General Evaluator (teeno categories form mein already hain).

---

## Important notes
- **Supabase free pause:** 1 hafte inactivity pe project pause ho sakta hai. Meeting se pehle Supabase dashboard kholo, agar paused ho to **Restore** dabao. Ya https://cron-job.org par free job lagao jo roz `SUPABASE_URL/rest/v1/meetings?select=id` ko header `apikey: <anon key>` ke saath call kare.
- **Duplicate vote:** har phone ka browser ek device ID rakhta hai. Koi dusra browser/incognito use kare to dobara vote kar sakta hai. Zyada strict control chahiye to batao.
- **Accounts:** Supabase aur Netlify/Vercel accounts client ke naam pe bana do ya baad mein transfer kar do.
- **Test zaroor karo** deploy ke baad: ek test meeting banao, 2 phones se vote karo, close karke result dekho, phir test meeting delete kar do.
