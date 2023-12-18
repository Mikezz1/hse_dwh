echo "Clearing data"
rm -rf ../postgresql-rp/data/*
rm -rf ../postgresql-rp/data-slave/*
docker-compose down
docker-compose down --volumes

docker-compose up -d  postgres_master

echo "Starting postgres_master node..."
sleep 120  # Waits for master node start complete

echo "Prepare replica config..."
docker exec -it postgres_master sh /etc/postgresql/init-script/init.sh
echo "Restart master node"
docker-compose restart postgres_master
sleep 30

echo "Starting slave node..."
docker-compose up -d  postgres_slave
sleep 30  # Waits for node start complete

echo "Done"
