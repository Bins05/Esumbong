-- ============================================================================
-- Cleanup: Remove redundant reference trigger from migration 20260926000001
--
-- Discovery: public.incidents.reference already had a DEFAULT of
--   next_incident_reference()
-- which generates references like ES-2026-0004 BEFORE any BEFORE INSERT
-- trigger can run. My trigger's early-exit guard meant it always skipped.
--
-- This migration removes the dead code. The real reference generator
-- (next_incident_reference + its supporting storage) is untouched.
-- ============================================================================

-- 1. Drop the trigger that never fires
drop trigger if exists set_incident_reference on public.incidents;

-- 2. Drop the function it called
drop function if exists public.generate_incident_reference();

-- 3. Drop the counter table that was never used
drop table if exists public.incident_reference_counters;