-- ============================================================================
-- E-Sumbong: Incident reference number generator
--
-- Generates incident.reference in format: ESB-YYYY-NNNNN
-- Example: ESB-2026-00123 (123rd incident in 2026)
--
-- Design:
--   - Per-year counter resets on January 1st
--   - Runs BEFORE INSERT so the RLS WITH CHECK policy sees the final row
--   - SECURITY DEFINER so the trigger can write to the counter table even
--     though clients have no access to it
--   - Respects any client-provided reference (backward compatible with PWA)
-- ============================================================================

-- 1. Counter table: one row per year, tracks the last-used sequence number
create table if not exists public.incident_reference_counters (
  year integer primary key,
  counter integer not null default 0
);

-- Lock down the counter table: RLS on, no policies → no client access.
alter table public.incident_reference_counters enable row level security;

-- 2. Trigger function: increments the current year's counter and formats
--    the reference string.
create or replace function public.generate_incident_reference()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  current_year integer;
  next_counter integer;
begin
  -- Skip if the client (or an older client) already set a reference.
  if new.reference is not null and new.reference <> '' then
    return new;
  end if;

  current_year := extract(year from now())::integer;

  insert into public.incident_reference_counters (year, counter)
  values (current_year, 1)
  on conflict (year)
    do update set counter = public.incident_reference_counters.counter + 1
  returning counter into next_counter;

  new.reference :=
    'ESB-' || current_year::text || '-' || lpad(next_counter::text, 5, '0');

  return new;
end;
$$;

-- 3. Attach the trigger. BEFORE INSERT so it runs before the RLS check.
drop trigger if exists set_incident_reference on public.incidents;
create trigger set_incident_reference
  before insert on public.incidents
  for each row
  execute function public.generate_incident_reference();

-- 4. Safety net: ensure reference values are unique. Skipped if the
--    constraint already exists.
do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname = 'incidents_reference_key'
      and conrelid = 'public.incidents'::regclass
  ) then
    alter table public.incidents
      add constraint incidents_reference_key unique (reference);
  end if;
end $$;