_conf() {
    echo "What version of ${pkg_name} do you want to install? "
    read answer
    vpb.pkg.config ${pkg_path} version "$answer"
}

configure() {
    if vpb.pkg.has_config "${pkg_name}" ; then
        echo "Do you wish to install $version ? (y|n) "
        read answer
        case answer in
            n)
                _conf
        esac
    else
        _conf
    fi
}

install() {
    # Install prerequisite: Java
    sudo apt-get install -y openjdk-7-jre-headless

    wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$version.deb
    sudo dpkg -i elasticsearch-$version.deb
    rm elasticsearch-$version.deb
}

post_install() {
    # Configure Elasticsearch for development purposes (1 shard/no replicas, don't allow it to swap at all if it can run without swapping)
    sudo sed -i "s/# index.number_of_shards: 1/index.number_of_shards: 1/" /etc/elasticsearch/elasticsearch.yml
    sudo sed -i "s/# index.number_of_replicas: 0/index.number_of_replicas: 0/" /etc/elasticsearch/elasticsearch.yml
    sudo sed -i "s/# bootstrap.mlockall: true/bootstrap.mlockall: true/" /etc/elasticsearch/elasticsearch.yml
    sudo service elasticsearch restart
}
