#!/bin/bash


# Update package list and install EPEL release
echo "Installing EPEL release..."
sudo yum install epel-release -y

# Install MariaDB and Git
echo "Installing MariaDB and Git..."
sudo yum install git mariadb-server -y

# Start and enable MariaDB service
echo "Starting and enabling MariaDB service..."
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Run mysql_secure_installation script automatically
echo "Securing MariaDB..."
sudo yum install expect -y
sudo expect <<EOF
spawn mysql_secure_installation
expect "Enter current password for root (enter for none):"
send "\r"
expect "Set root password? \[Y/n\]"
send "y\r"
expect "New password:"
send "admin123\r"
expect "Re-enter new password:"
send "admin123\r"
expect "Remove anonymous users? \[Y/n\]"
send "y\r"
expect "Disallow root login remotely? \[Y/n\]"
send "y\r"
expect "Remove test database and access to it? \[Y/n\]"
send "y\r"
expect "Reload privilege tables now? \[Y/n\]"
send "y\r"
expect eof
EOF

# Configure MariaDB: Create database and user
echo "Configuring MariaDB database and user..."
sudo mysql -u root -padmin123 <<MYSQL_SCRIPT
CREATE DATABASE accounts;
GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY 'admin123';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Download source code and initialize database
echo "Cloning source code and initializing database..."
sudo git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
sudo mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql

# Restart MariaDB service
echo "Restarting MariaDB service..."
sudo systemctl restart mariadb
