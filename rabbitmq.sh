#!/bin/bash


# Install wget and RabbitMQ
echo "Installing wget and RabbitMQ..."
sudo yum install wget -y
cd /tmp/
sudo dnf -y install centos-release-rabbitmq-38
sudo dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server

# Start and enable RabbitMQ service
echo "Starting and enabling RabbitMQ service..."
sudo systemctl enable --now rabbitmq-server

# Setup access to user 'test' and make it admin
echo "Configuring RabbitMQ user 'test'..."
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator

# Restart RabbitMQ service to apply changes
echo "Restarting RabbitMQ service..."
sudo systemctl restart rabbitmq-server

# Start RabbitMQ service
echo "Starting RabbitMQ service..."
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl status rabbitmq-server

echo "RabbitMQ setup is complete."
