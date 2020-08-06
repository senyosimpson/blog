FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf
COPY docker/sites-available/senyosimpson.com /etc/nginx/conf.d/senyosimpson.conf

COPY . /var/www/senyosimpson.com
COPY docker/sites-available /etc/nginx/sites-available

RUN mkdir /etc/nginx/sites-enabled
RUN ln -s /etc/nginx/sites-available/senyosimpson.com /etc/nginx/sites-enabled/senyosimpson.com

