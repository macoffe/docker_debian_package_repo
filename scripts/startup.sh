#!/bin/bash

#gpg key creation and adding it to the repository config file.
gpg --batch --gen-key gen_key_script
GPG_KEY=$(gpg --list-secret-key --with-subkey-fingerprint | tail -n2 | grep -o "[0-9,1-Z]*")
echo "SignWith: "${GPG_KEY} >> /conf/distributions

#apache configuration.
service apache2 start
mv /conf/repos.conf /etc/apache2/conf-available/ && a2enconf repos
service apache2 reload

#creating repository directory structure and adding config files.
mkdir -p /srv/repos/apt/debian /packages
mv conf /srv/repos/apt/debian/.

#export public gpg key.
cd /srv/repos/apt/debian/
gpg --armor --output my_repo_public.gpg.key --export-options export-minimal --export ${GPG_KEY}

#wait for a file with ".deb" extension to be added in /packages directory, and try to add it to the repository.
inotifywait -m /packages/ -e create -e moved_to |
    while read directory action file; do
        if [[ "${file}" =~ .*deb$ ]]; then
            reprepro -S package -P package includedeb bullseye ${directory}${file}
            echo "${file} added to the repository." >> /repo.log
        else
            echo "${file} received but it don't have .deb extension, not added to the repository." >> /repo.log
        fi
    done