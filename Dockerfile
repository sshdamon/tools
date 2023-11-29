FROM node:20
WORKDIR /var/www/html
COPY /home/netsetsoftware/Downloads/ishang-admin/* /var/www/html/
RUN npm install
EXPOSE 3001
