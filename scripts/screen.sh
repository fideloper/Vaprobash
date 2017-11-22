#!/usr/bin/env bash

echo ">>> Installing Screen"

# Screen
# -qq implies -y --force-yes
sudo apt-get install -qq screen
touch ~/.screenrc

SCREENINFO="startup_message off\ncaption always '%{= dg} %H %{G}%=%?%{d}%-w%?%{r}(%{d}%n %t%? {%u} %?%{r})%{d}%?%+w%?%=%{G} %{B}%M %d %c:%s '"

echo -e $SCREENINFO >> ~/.screenrc
