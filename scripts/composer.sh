#!/usr/bin/env bash

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

# Test if HHVM is installed
hhvm --version > /dev/null 2>&1
HHVM_IS_INSTALLED=$?

[[ $HHVM_IS_INSTALLED -ne 0 && $PHP_IS_INSTALLED -ne 0 ]] && { printf "!!! PHP/HHVM is not installed.\n    Installing Composer aborted!\n"; exit 0; }

# Test if Composer is installed
composer -v > /dev/null 2>&1
COMPOSER_IS_INSTALLED=$?

# Getting the arguments
GITHUB_OAUTH=$1
COMPOSER_PACKAGES=$2

PROFILE=~/.profile
BASHRC=~/.bashrc

# True, if composer is not installed
if [[ $COMPOSER_IS_INSTALLED -ne 0 ]]; then
    echo ">>> Installing Composer"
    if [[ $HHVM_IS_INSTALLED -eq 0 ]]; then
        # Install Composer
        sudo wget --quiet https://getcomposer.org/installer
        hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 installer
        sudo mv composer.phar /usr/local/bin/composer
        sudo rm installer

        # Resource .profile
        # Doesn't seem to work do! The alias is only usefull from the moment you log in: vagrant ssh
        
		# Re-source .profile if exists
		if [[ -f $PROFILE ]]; then 

			# Add an alias that will allow us to use composer without timeout's
			printf "\n# Add an alias for sudo\n%s\n# Use HHVM when using Composer\n%s" \
			"alias sudo=\"sudo \"" \
			"alias composer=\"hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 -v Eval.Jit=false /usr/local/bin/composer\"" \
			>> $PROFILE
			
			source $PROFILE
		fi
		
		# Re-source .bashrc if exists
		if [[ -f $BASHRC ]]; then
		
		    # Add an alias that will allow us to use composer without timeout's
			printf "\n# Add an alias for sudo\n%s\n# Use HHVM when using Composer\n%s" \
			"alias sudo=\"sudo \"" \
			"alias composer=\"hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 -v Eval.Jit=false /usr/local/bin/composer\"" \
			>> $BASHRC
			source $BASHRC
		fi
    else
        # Install Composer
        curl -sS https://getcomposer.org/installer | php
        sudo mv composer.phar /usr/local/bin/composer
    fi
else
    echo ">>> Updating Composer"

    if [[ $HHVM_IS_INSTALLED -eq 0 ]]; then
        sudo hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 -v Eval.Jit=false /usr/local/bin/composer self-update
    else
        composer self-update
    fi
fi

if [[ $GITHUB_OAUTH != "" ]]; then
    if [[ ! $COMPOSER_IS_INSTALLED -eq 1 ]]; then
        echo ">>> Setting Github Personal Access Token"
        composer config -g github-oauth.github.com $GITHUB_OAUTH
    fi
fi


# Install Global Composer Packages if any are given
if [[ ! -z $COMPOSER_PACKAGES ]]; then
    echo ">>> Installing Global Composer Packages:"
    echo "    " ${COMPOSER_PACKAGES[@]}
    
    # Add Composer's Global Bin to ~/.profile path
    if [[ -f $PROFILE ]]; then
        if ! grep -qsc 'COMPOSER_HOME=' $PROFILE; then
            # Ensure COMPOSER_HOME variable is set. This isn't set by Composer automatically
            printf "\n\nCOMPOSER_HOME=\"/home/ubuntu/.composer\"" >> $PROFILE
            # Add composer home vendor bin dir to PATH to run globally installed executables
            printf "\n# Add Composer Global Bin to PATH\n%s" 'export PATH=$PATH:$COMPOSER_HOME/ubuntu/bin' >> $PROFILE

			source $PROFILE
			source $BASHRC
		fi
	fi
    
    if [[ $HHVM_IS_INSTALLED -eq 0 ]]; then
        hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 -v Eval.Jit=false /usr/local/bin/composer global require ${COMPOSER_PACKAGES[@]}
    else
        composer global require ${COMPOSER_PACKAGES[@]}
    fi
fi
