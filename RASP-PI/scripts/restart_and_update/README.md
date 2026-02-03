# Automatic Daily Update

A cron job entry that automatically updates system packages on your Raspberry Pi.

## What it does

- Runs daily at 4:00 AM
- Updates package lists (`apt-get update`)
- Upgrades all installed packages (`apt-get full-upgrade`)
- Removes unused packages (`apt-get autoremove`)
- Logs output to `/var/log/daily_update.log`

## Installation

Add the cron job by editing your crontab:

```bash
sudo crontab -e
```

Then paste the contents of `restart_and_update.sh` and save.

## Verify

Check that the cron job is active:

```bash
sudo crontab -l
```

Check update logs:

```bash
cat /var/log/daily_update.log
```

## Remove

To disable automatic updates, edit crontab and remove the line:

```bash
sudo crontab -e
```