#!/bin/bash


# Install EPEL release and Memcached
echo "Installing EPEL release and Memcached..."
sudo dnf install memcached -y

# Start and enable Memcached service
echo "Starting and enabling Memcached service..."
sudo systemctl start memcached
sudo systemctl enable memcached
sudo systemctl status memcached

# Configure Memcached to listen on all interfaces
echo "Configuring Memcached to listen on all interfaces..."
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached

# Restart Memcached service to apply changes
echo "Restarting Memcached service..."
sudo systemctl restart memcached

# Start Memcached with specific port settings
echo "Starting Memcached on port 11211 (TCP) and 11111 (UDP)..."
sudo memcached -p 11211 -U 11111 -u memcached -d

echo "Memcached setup is complete."
