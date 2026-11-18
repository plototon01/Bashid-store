create index programs_user_id_idx on public.programs (user_id);
drop policy "Signed-in users can add their programs" on public.programs;
create policy "Signed-in users can add their programs" on public.programs
for insert to authenticated with check ((select auth.uid()) = user_id);
