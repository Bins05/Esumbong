# E-Sumbong

A mobile-first incident reporting system configured for **Barangay Palatiw, Pasig City**, built with Next.js, TypeScript, Tailwind CSS, Supabase, Zod, Storage, RLS, and Realtime-ready tables.

Interactive Pasig City mapping is provided by Leaflet and React-Leaflet using OpenStreetMap tiles. The resident form supports tap-to-pin coordinates, while `/admin/map` provides a filterable operations map. For high-volume production deployments, configure a commercial or self-hosted OSM-compatible tile provider and retain visible OpenStreetMap attribution.

## Run locally

```bash
npm install
npm run dev
```

Open `http://localhost:3000`. The deployment starts with no sample residents, incidents, metrics, or response teams.

## Connect Supabase

1. Create a Supabase project and copy `.env.example` to `.env.local`.
2. Add the project URL and anon key. Never expose the service-role key to browser code.
3. Install the Supabase CLI, link the project, then run `supabase db push`. This applies both the base schema and the Palatiw verification migration.
4. Enable the desired Auth providers (email/password, phone, and/or OAuth) in Supabase.
5. Create the first official account in Supabase Authentication. Then add its profile with the SQL below, replacing the email with that account's email:

```sql
insert into public.users (id, barangay_id, role, full_name, is_verified, verification_status)
select au.id, b.id, 'admin', 'Palatiw Administrator', true, 'verified'
from auth.users au
cross join public.barangays b
where au.email = 'official@palatiw.gov.ph'
  and b.name = 'Palatiw' and b.municipality = 'Pasig City';
```

The service-role key is used only by the registration Server Action to provision a pending resident profile and privately upload ID evidence. Never expose it through a `NEXT_PUBLIC_` variable.

## Important security decisions

- Resident access is enforced in PostgreSQL, not only in the UI.
- Residents cannot submit reports until an authorized Palatiw official approves their Barangay ID.
- Barangay ID evidence is stored in a separate private bucket; residents cannot browse ID documents.
- Anonymous reports intentionally have no `reporter_id`, so they do not appear in the resident tracker.
- `submitted_by` is retained for abuse prevention/auditing but is not exposed by resident policies.
- Officials can only access incidents whose `barangay_id` matches their verified profile.
- Media is private, limited to 10 MB and approved MIME types, and scoped to the uploader or local staff.
- Role and barangay changes cannot be self-assigned by a resident.

## Main routes

- `/` — public landing page
- `/login` — separate resident and barangay-official login
- `/register` — Barangay Palatiw resident registration and ID submission
- `/verification-pending` — restricted-access status page
- `/report` — guided incident report form
- `/resident` — resident tracker and updates
- `/resident/reports/1` — action timeline and follow-up view
- `/admin` — operations overview and analytics
- `/admin/incidents` — filterable Kanban/table incident desk
- `/admin/verifications` — private Barangay ID review queue
- `/admin/map` — interactive Pasig City incident operations map
