## Set up environment variables:
Create a .env file with your database credentials:
bash

echo "MOODLE_DB_NAME=moodle
MOODLE_DB_USER=moodle_user
MOODLE_DB_PASSWORD=your_secure_password
MOODLE_DB_HOST=host.docker.internal
MOODLE_DB_PORT=3306" > .env

## Start the containers:
bash

docker-compose up -d --build

## Set up Nginx reverse proxy:
bash

sudo cp nginx-host-config/moodle.conf /etc/nginx/sites-available/moodle
sudo ln -s /etc/nginx/sites-available/moodle /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx



## Database Setup

Ensure your database exists and has proper permissions:
# login to sql as Root user 

CREATE DATABASE moodle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'moodle_user'@'%' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON moodle.* TO 'moodle_user'@'%';


Access Moodle:
Open your browser to:

    http://localhost (via Nginx proxy)

    http://localhost:8080 (direct access)


## To find container IP address

docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' your_conatiner_name


## To move inside the Docker conatiner

docker exec -it container_name  /bin/bash