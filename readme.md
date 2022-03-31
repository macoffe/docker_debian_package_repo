# Docker debian package repository

*works for debian bullseye(11)*

## Setup the repository 

#### To build the docker image:

*inside the project folder*

    docker build -t debian_repo .

#### To run the container:

    docker run -it -p 80:80 -v /srv/packages:/packages --name my-repo debian_repo

#### Each time you want to add a package to the repository:

in one terminal window, reconnect in interactive mode to the repo container if you closed it.

    docker attach my-repo

in another terminal window, copy your package to the repo.

    cp package_example.deb /srv/packages/.

in the first terminal window, enter the gpg key passphrase (by default *"repo4u5er"*).

![alt text](https://github.com/macoffe/images/blob/main/gpg_passphrase?raw=true)

## Import the repository

*repository_host_ip* is the ip of the host where we have setup the repository.

#### To retrieve the gpg public key:
    wget -O - http://repository_host_ip/repos/apt/debian/my_repo_public.gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/my_repo-archive-keyring.gpg

#### To add the repository in the sources list:
    echo "deb [signed-by=/usr/share/keyrings/my_repo-archive-keyring.gpg] http://repository_host_ip/repos/apt/debian/ bullseye main" | sudo tee /etc/apt/sources.list.d/my_repo.list > /dev/null

---
- to access the repository in a web browser, type the url: "*repository_host_ip*/repos/apt/debian".
- */var/log/repo.log* is a simple log file that allow you to keep track of the imported packages.
