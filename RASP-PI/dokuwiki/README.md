# Here is the wiki
## we will use the [DokuWiki](https://hub.docker.com/r/linuxserver/dokuwiki/)

- change the example.env file to your values
- make sure you create a new user for the wiki (or rather docker) with
    - add the user:
        - "sudo useradd -r -s /bin/false dockeruser"
    - check the IDs with:
        - "id dockeruser"
    - change permission of said user with:
        - "sudo chown -R dockeruser:dockeruser ~/dokuwiki"
- then everythink should be working just fine run:
    - "docker compose up -d"
