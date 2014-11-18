#!/usr/bin/env bash

echo ">>> Installing Screen"

# Screen
# -qq implies -y --force-yes
sudo apt-get install -qq screen
sudo touch /home/vagrant/.screenrc
sudo echo -e "startup_message off\ncaption always '%{= dg} %H %{G}%=%?%{d}%-w%?%{r}(%{d}%n %t%? {%u} %?%{r})%{d}%?%+w%?%=%{G} %{B}%M %d %c:%s '" >> /home/vagrant/.screenrc
