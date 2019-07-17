#!/bin/bash

#########################################################
#	Author: Ashraful Islam <ashraful.py@gmail.com>		#
#   Github: https://github.com/iashraful				#
#	NOTE: This small script will only work for Ubuntu	#
#		and Ubuntu flavors system like Linux mint,		#
#		Xubuntu, Kubuntu etc... 						#
#														#
#					|| Author Speech ||					#
#	This script is for no harm. I'have written for my	#
#	personal use. As per licensing policy everyone can	#
#	update it for their personal use. 					#
#														#
#				|| Developer Notice ||					#
#	Anyone can send PR to it's repository. I'am 		#
# 	expecting Bug, Suggesstion and motivation to 		#
#	something new. Good Luck :)							#
#########################################################

GIT_REPO='git@bitbucket.org:fieldbuzz/'
WORKSPACE='/home/ashraful/workplace'
VIRTUALENV_PATH='/home/ashraful/.virtualenvs'

# Create Workspace if not exists
if [ -d "$WORKSPACE" ]; then
    cd $WORKSPACE
else
    mkdir "$WORKSPACE"
    cd $WORKSPACE
fi

install_dependencies() {
    printf "Installing dependencies\n"
    # sudo apt install git
    # sudo apt install postgresql
    # sudo apt install python3-pip
    printf "\n\n"
}

clone_repo() {
    # First param git REPO URL
    # Second Param app name/virtual env/database name
    # Expecting repo url on $1
    printf "Downloading $1 from git repository...\n"
    git_base_url=$GIT_REPO
    if [ -d "$1" ]; then
        echo "Already found"
        echo "Do you proceed? Anything can happen. y/N"
        read decision
        if [ "$decision" = "y" ]; then
            echo "Thanks for the decision."
        else
            return 0
        fi
        cd $1
    else
        git clone "$git_base_url$1.git"
        printf "Done\n"
    fi
    create_virtualenv $2
    create_database $2
    runnable_project $1 $2
    echo "Done!"
    printf "\n"
}

create_database() {
    printf "Creating Database...\n"
    sudo -u postgres psql -c 'create database '$1';'
    printf "\n\n"
}

create_virtualenv() {
    printf "Creating Virtualenv...\n"
    # Install virtualenv first
    sudo pip3 install virtualenv virtualenvwrapper
    if [ -d "$VIRTUALENV_PATH" ]; then
        cd $VIRTUALENV_PATH
    else
        mkdir -p "$VIRTUALENV_PATH"
        cd $VIRTUALENV_PATH
    fi
    virtualenv -p python3.5 $1 # $1 is the first env variable name
    source $1/bin/activate
    printf "\n\n"
}

runnable_project() {
    printf "Making the project as runnable\n"
    copy_config_files $1 $2
    cd $WORKSPACE/$1/
    if [ -f "bw_libs.sh" ]; then
        echo "Do you want to run bw_libs.sh ? y/N"
        read decision
        if [ "$decision" = "y" ]; then
            ./bw_libs.sh
        else
            echo ""
        fi
    else
        echo ""
    fi
    source $VIRTUALENV_PATH/$2/bin/activate
    echo "Do you like to run pip install -r plugins.txt ? y/N"
    read decision
    if [ "$decision" = "y" ]; then
        pip install -r plugins.txt
    else
        echo ""
    fi
    printf "\n"
}

copy_config_files() {
    # $1 directory name
    # $2 is virtualenv name, database name
    printf "Coping config files...\n"

    if [ -f "$WORKSPACE/$1/config/analytics_config.py" ]
    then
        echo "analytics_config.py found."
    else
        cp "$WORKSPACE"/$1/config/analytics_config.py.example "$WORKSPACE"/$1/config/analytics_config.py
        echo "analytics_config.py copied"
    fi

    if [ -f "$WORKSPACE/$1/config/celery_config.py" ]
    then
        echo "celery_config.py found."
    else
        cp "$WORKSPACE"/$1/config/celery_config.py.example "$WORKSPACE"/$1/config/celery_config.py
        echo "celery_config.py copied"
    fi

    if [ -f "$WORKSPACE/$1/config/cache_config.py" ]
    then
        echo "cache_config.py found."
    else
        cp "$WORKSPACE"/$1/config/cache_config.py.example "$WORKSPACE"/$1/config/cache_config.py
        echo "cache_config.py copied"
    fi

    if [ -f "$WORKSPACE/$1/config/database.py" ]
    then
        echo "database.py found."
    else
        echo "DATABASES = {
            'default': {
                'ENGINE': 'django.contrib.gis.db.backends.postgis',
                'NAME': '$2',
                'USER': 'postgres',
                'PASSWORD': 'postgres',
                'HOST': 'localhost',
                'PORT': '5432',
            }" >> "$WORKSPACE"/$1/config/database.py
        echo "database.py copied"
    fi

    if [ -f "$WORKSPACE/$1/config/dbbackup_restore_config.py" ]
    then
        echo "dbbackup_restore_config.py found."
    else
        cp "$WORKSPACE"/$1/config/dbbackup_restore_config.py.example "$WORKSPACE"/$1/config/dbbackup_restore_config.py
        echo "dbbackup_restore_config.py copied"
    fi

    if [ -f "$WORKSPACE/$1/config/email_config.py" ]
    then
        echo "email_config.py found."
    else
        cp "$WORKSPACE"/$1/config/email_config.py.example "$WORKSPACE"/$1/config/email_config.py
        echo "email_config.py copied"
    fi

    if [ -f "$VIRTUALENV_PATH/$2/lib/python3.5/site-packages/fblibs.pth" ]
    then
        echo "fblibs.pth already exists"
    else
        echo 'import sys; sys.__plen = len(sys.path)' > $VIRTUALENV_PATH/$2/lib/python3.5/site-packages/fblibs.pth
        echo "$WORKSPACE"/fblibs/final >> $VIRTUALENV_PATH/$2/lib/python3.5/site-packages/fblibs.pth
        echo "import sys; new=sys.path[sys.__plen:]; del sys.path[sys.__plen:]; p=getattr(sys,'__egginsert',0); sys.path[p:p]=new; sys.__egginsert = p+len(new);" >> $VIRTUALENV_PATH/$2/lib/python3.5/site-packages/fblibs.pth
        echo "fblibs.pth file prepared"
    fi
    printf "\n\n"
}

_main() {
    install_dependencies
    clone_repo "brac-rwanda-mission-control" "bracrw"
}

_main
