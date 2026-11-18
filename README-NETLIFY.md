# Bashid Store — публикация на Netlify

Это статический сайт, сборка не нужна. Загрузи распакованную папку через Netlify **Deploy manually** или подключи её как Git-репозиторий. Если Netlify запросит настройки сборки, оставь команду сборки пустой, а папку публикации укажи `.`.

## Вход через Google

Кнопки входа используют Supabase Auth OAuth. Регистрация в отдельной форме отсутствует: новый пользователь создаёт аккаунт, подтверждая вход Google.

1. В Google Cloud Console создай OAuth Client ID типа **Web application**.
2. В **Authorized redirect URIs** добавь callback Supabase: `https://oazgnuzihekwafffuwjb.supabase.co/auth/v1/callback`.
3. В Supabase открой **Authentication → Sign In / Providers → Google**, включи Google и внеси Client ID и Client Secret. Секрет храни только в Supabase.
4. В Supabase **Authentication → URL Configuration** укажи основной адрес магазина в **Site URL** и добавь его в **Redirect URLs**. Для локального просмотра добавь локальный адрес разработки, например `http://localhost:5500/**`.
5. В Google Cloud добавь адрес сайта в **Authorized JavaScript origins**. После подключения Netlify используй свой домен `*.netlify.app` или назначенный домен.
6. Включи миграцию `20261118161801_require_google_identity_to_publish.sql` через Supabase GitHub Integration. Она запрещает анонимным сессиям публиковать программы и загружать файлы.
7. В Supabase **Authentication → Settings → User Signups** отключи **Allow anonymous sign-ins**, если анонимная публикация больше не нужна.

Не добавляй Google Client Secret в файлы магазина. Код использует `signInWithOAuth` и возвращает пользователя на страницу, с которой он начал вход.

## Хранилище и публикация

Загрузка файлов защищена RLS: файлы хранятся в личной папке аккаунта, а публичная роль `anon` не может загружать файлы. Установщики до 500 МБ делятся на части; обложки и видео — до 50 МБ. Файлы и записи занимают квоту Supabase Storage.
