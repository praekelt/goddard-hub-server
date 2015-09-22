cd /var/praekelt/goddard-hub-server
npm install
DB_URL=postgres://postgres:@localhost/inmarsat node index.js --migrations --seed
cd -
