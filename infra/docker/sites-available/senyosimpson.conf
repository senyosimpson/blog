server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /var/www/senyosimpson.com;
    index index.html;
    server_name senyosimpson.com www.senyosimpson.com;
    location / {
         try_files $uri.html $uri $uri/ =404;
    }
}