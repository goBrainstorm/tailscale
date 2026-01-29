# Use of WOL
## Usacase
you can use this script on your local machine when you want to waku up antoher machine on your network with a jump host. the jumphost can be any device in the same network and ssh access. 

## how to use
1. Write down the MAC Adress of the target machine.
    - make sure the machine has WOL activated in BIOS!
2. Ensure you have SSH Access to your Jumphost.
3. On your local machine create a folder with:
    - `.env`
    - `WOL.sh`
4. Make WOL.sh executable with `chmod +x WOL.sh`
5. Check that the `.env` file correctly stores:
    - `JUMP_USER=` ← this is the username you use to connect via SSH 
    - `JUMP_HOST` ← this is the adress available to you in the Tailscale machines overlay
    - `DEVICE_NAME` ← the MAC adress of the machine that you want to wake.
