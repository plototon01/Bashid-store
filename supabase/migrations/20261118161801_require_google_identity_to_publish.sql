drop policy "Signed-in users can add their programs" on public.programs;
create policy "Google users can add their programs" on public.programs
for insert to authenticated
with check (
  (select auth.uid()) = user_id
  and coalesce(((select auth.jwt()) ->> 'is_anonymous')::boolean, false) = false
);

drop policy "Signed-in users upload their files" on storage.objects;
create policy "Google users upload their files" on storage.objects
for insert to authenticated
with check (
  bucket_id in ('program-files', 'program-media')
  and (storage.foldername(name))[1] = (select auth.uid())::text
  and coalesce(((select auth.jwt()) ->> 'is_anonymous')::boolean, false) = false
);
