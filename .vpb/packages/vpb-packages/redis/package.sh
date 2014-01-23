configure() {
    echo "Do you want to ${pkg_name} be persistent (y/n) ? "
    read answer
    case $answer in
        y)
            vpb.pkg.config ${pkg_path} persist "true"
            ;;
        *)
            vpb.pkg.config ${pkg_path} persist "false"
            ;;
    esac
}

install() {
    sudo apt-get install -y redis-server
}

post_install() {
    # Redis Configuration
    sudo mkdir -p /etc/redis/conf.d

    # transaction journaling - config is written, only enabled if persistence is requested
    cat << EOF | sudo tee /etc/redis/conf.d/journaling.conf
appendonly yes
appendfsync everysec
EOF

    # Persistence
    if [ "$persist" == "true" ]; then

        # add the config to the redis config includes
        if ! cat /etc/redis/redis.conf | grep -q "journaling.conf"; then
            sudo echo "include /etc/redis/conf.d/journaling.conf" >> /etc/redis/redis.conf
        fi

        # schedule background append rewriting		
        if ! crontab -l | grep -q "redis-cli bgrewriteaof"; then
            line="*/5 * * * * /usr/bin/redis-cli bgrewriteaof > /dev/null 2>&1"
            (sudo crontab -l; echo "$line" ) | sudo crontab -
        fi
    fi

    sudo service redis-server restart
}
