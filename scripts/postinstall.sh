cd /var/praekelt/goddard-hub-server
npm install
DB_URL=postgres://postgres:@localhost/inmarsat node_modules/.bin/sequelize db:migrate
cd -
