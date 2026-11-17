# 🗳️ Toastmasters Meeting Voting App

A lightweight, zero-download voting web app built for Toastmasters club meetings. Attendees simply scan a permanent table QR code, cast their votes on their phone in seconds, and see live results as soon as voting closes.

---

## ✨ Key Features

- **No App or Account Needed:** Voters simply scan the QR code and vote directly in any mobile browser.
- **One Permanent QR Code:** Print once for table stands; automatically connects to whichever meeting is active.
- **Fair & Tamper-Resistant:** Device-bound restrictions ensure one vote per attendee per category.
- **Organizer Dashboard (`/#admin`):** Protected area for club officers to create meetings, add nominees, open/close voting, and view history.
- **Instant Live Results:** Percentage bars, vote tallies, and winner badges unlock the moment voting closes.
- **Demo Mode (`/#preview`):** Test the voter experience anytime without modifying database records.

---

## 👥 User Roles at a Glance

| Role | How They Use It | Login Required? | Needs Supabase Access? |
| :--- | :--- | :--- | :--- |
| **Voters (Members & Guests)** | Scan table QR code (`https://your-site/`) | ❌ No | ❌ Never |
| **Club Organizer (Client)** | Web dashboard (`https://your-site/#admin`) | ✅ Password only | ❌ Never (uses web UI) |
| **Developer / Maintainer** | Initial setup (Supabase + hosting) | ✅ Free tier accounts | ✅ One-time setup only |

---

## 🚀 Quick Setup (100% Free)

1. **Database:** Create a free project at [Supabase](https://supabase.com) and run [`schema.sql`](./schema.sql) in the SQL Editor.
2. **Config:** Open [`index.html`](./index.html) and paste your Supabase Project URL and anon public key.
3. **Deploy:** Drag and drop the folder to [Netlify Drop](https://app.netlify.com/drop) or deploy via GitHub Pages / Vercel.

👉 **For the complete step-by-step walkthrough, see [SETUP_GUIDE.md](./SETUP_GUIDE.md)**  
*(Roman Urdu version: [SETUP_GUIDE_URDU.md](./SETUP_GUIDE_URDU.md))*

---

## 📁 Repository Structure

```
.
├── index.html            # Complete standalone application (Voter UI + Admin Panel + Demo Mode)
├── schema.sql            # PostgreSQL schema, Row-Level Security policies, and tabulation RPC
├── README.md             # Project overview and quick start (this file)
├── SETUP_GUIDE.md        # Detailed step-by-step setup guide (English)
└── SETUP_GUIDE_URDU.md   # Detailed step-by-step setup guide (Roman Urdu)
```

---

## 👤 Author

Developed by [Laiba Taqdis](https://github.com/LaibaTaqdis).

---

## 📄 License

MIT License © 2026 [Laiba Taqdis](https://github.com/LaibaTaqdis). Free to use and modify.
