-- Supabase > SQL Editor > New query > paste > Run (purane schema.sql ke BAAD chalao)

-- 1) Roles: sirf 'admin' role wale hi admin panel use kar sakte hain
create table if not exists profiles(
  id uuid primary key references auth.users on delete cascade,
  email text,
  role text not null default 'member' check (role in ('admin','member'))
);
alter table profiles enable row level security;

create or replace function is_admin() returns boolean
language sql security definer stable set search_path = public as $$
  select exists(select 1 from profiles where id = auth.uid() and role = 'admin')
$$;
grant execute on function is_admin() to anon, authenticated;

drop policy if exists "read own profile" on profiles;
create policy "read own profile" on profiles for select to authenticated
  using (id = auth.uid() or is_admin());

-- 2) APNA ADMIN EMAIL YAHAN LIKHO (jo Authentication > Users mein banaya tha)
insert into profiles(id, email, role)
select id, email, 'admin' from auth.users where email = 'admin@toastmasters.com'
on conflict (id) do update set role = 'admin';

-- 3) Participants roster (admin naam add/remove kar sakta hai)
create table if not exists participants(
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  created_at timestamptz default now()
);
alter table participants enable row level security;
drop policy if exists "admin manage participants" on participants;
create policy "admin manage participants" on participants for all to authenticated
  using (is_admin()) with check (is_admin());

-- 4) Purani policies tight karo: ab har logged-in banda nahi, sirf admin
drop policy if exists "admin manage meetings" on meetings;
create policy "admin manage meetings" on meetings for all to authenticated using (is_admin()) with check (is_admin());
drop policy if exists "admin manage candidates" on candidates;
create policy "admin manage candidates" on candidates for all to authenticated using (is_admin()) with check (is_admin());
drop policy if exists "admin read votes" on votes;
create policy "admin read votes" on votes for select to authenticated using (is_admin());

create or replace function get_results(m uuid)
returns table(category text, candidate_id uuid, name text, votes bigint)
language sql security definer set search_path = public as $$
  select c.category, c.id, c.name, count(v.id)
  from candidates c left join votes v on v.candidate_id = c.id
  where c.meeting_id = m
    and ((select status from meetings where id = m) = 'closed' or is_admin())
  group by c.category, c.id, c.name
$$;
