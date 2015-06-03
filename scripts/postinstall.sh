cd /var/praekelt/goddard-hub-server
DB_URL=postgres://postgres:@localhost/inmarsat node index.js --migrations --seed
cd -
