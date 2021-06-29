Polr on Alpine Linux with Docker
==============================================
![Docker Build Status](https://img.shields.io/docker/cloud/build/ajanvier/polr)
![Docker Image Size](https://img.shields.io/microbadger/image-size/ajanvier/polr)
![Docker Pulls](https://img.shields.io/docker/pulls/ajanvier/polr)
![Docker Latest Version](https://img.shields.io/docker/v/ajanvier/polr?sort=semver)

A Docker image for [Polr](https://github.com/cydrobolt/polr).

Usage
-----
Start the Docker container:

    docker run -p 8080:8080 \
        -e "DB_HOST=localhost" \
        -e "DB_DATABASE=polr" \
        -e "DB_USERNAME=polr" \
        -e "DB_PASSWORD=password" \
        -e "APP_ADDRESS=example.com" \
        -e "ADMIN_USERNAME=admin" \
        -e "ADMIN_PASSWORD=admin" \
        ajanvier/polr

Or use the example docker-compose.yml.

SSL not included, I made it originally to work with nginx-proxy.

Environment variables
-----
| Name | Description |
|--|--|
| DB_CONNECTION | Type of database *(default: mysql)* |
| DB_HOST | **(required)** Host of the MySQL server |
| DB_PORT | Port of the MySQL server *(default: 3306)* |
| DB_DATABASE | Name of the MySQL database *(default: polr)*, or path of sqlite file |
| DB_USERNAME | Name of the MySQL user *(default: polr)* |
| DB_PASSWORD | **(required)** Password of the MySQL user |
|  |  |
| APP_NAME | Your app's name (shown on interface) *(default: My Polr)* |
| APP_PROTOCOL | Protocol to access your app. *(default: https://)* |
| APP_ADDRESS | **(required)** Your app's external address (ex: example.com) |
|  |  |
| ADMIN_USERNAME | **(required)** Username of the admin user |
| ADMIN_PASSWORD | **(required)** Password of the admin user |
| ADMIN_EMAIL | Email of the admin user |
|  |  |
| SETTING_PUBLIC_INTERFACE | Set to true to show an interface to logged off users<br>If false, set the SETTING_INDEX_REDIRECT<br>You may login by heading to /login if the public interface is off<br>*(default: true)* |
| SETTING_SHORTEN_PERMISSION | Set to true to require users to be logged in before shortening URLs<br>*(default: false)* |
| SETTING_INDEX_REDIRECT | You must set SETTING_INDEX_REDIRECT if SETTING_PUBLIC_INTERFACE is false<br>Polr will redirect logged off users to this URL |
| SETTING_REDIRECT_404 | Set to true if you wish to redirect 404s to SETTING_INDEX_REDIRECT<br>Polr will redirect logged off users to this URL |
| SETTING_PASSWORD_RECOV | Set to true to enable password recovery *(default: false)* |
| SETTING_AUTO_API | Set to true to generate API keys for each user on registration *(default: false)* |
| SETTING_ANON_API | Set to true to allow anonymous API access *(default: false)* |
| SETTING_ANON_API_QUOTA | Set the anonymous API quota per IP |
| SETTING_PSEUDORANDOM_ENDING | Set to true to use pseudorandom strings rather than using a counter by default *(default: false)* |
| SETTING_ADV_ANALYTICS | Set to true to record advanced analytics *(default: false)* |
| SETTING_RESTRICT_EMAIL_DOMAIN | Set to true to restrict registration to a specific email domain *(default: false)* |
| SETTING_ALLOWED_EMAIL_DOMAINS | A comma-separated list of permitted email domains |
|  |  |
| POLR_ALLOW_ACCT_CREATION | Set to true to allow signups, false to disable *(default: false)* |
| POLR_ACCT_ACTIVATION | Set to true to require activation by email *(default: false)* |
| POLR_ACCT_CREATION_RECAPTCHA | Set to true to require reCAPTCHAs on sign up pages<br>If this setting is enabled, you must also provide your reCAPTCHA keys in POLR_RECAPTCHA_SITE_KEY and POLR_RECAPTCHA_SECRET_KEY<br>*(default: false)* |
| POLR_BASE | 32 or 62 *(default: 62)* |
| POLR_RECAPTCHA_SITE_KEY | reCAPTCHA site key |
| POLR_RECAPTCHA_SECRET_KEY | reCAPTCHA secret key |
|  |  |
| **Set each to blank to disable mail** |  |
| MAIL_HOST | Hostname of the mail server |
| MAIL_PORT | Port of the mail server |
| MAIL_USERNAME | User name on the mail server |
| MAIL_PASSWORD | User password |
| MAIL_FROM_ADDRESS | "From" address |
| MAIL_FROM_NAME | "From" name |
