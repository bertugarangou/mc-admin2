# MC-ADMIN RLDD

Port for new debian, minecraft and openjdk 17 jdk.

## Description
Basic administration bash scripts when Minecraft is running with in a screen on Linux

Features:
* Start/stop Minecraft
* Access Minecraft console (basically accessing the screen)
* Copy Minecraft directory to a backup folder

## Files:
* mc-admin.sh: console, start/stop, backup
* backup.sh: alternative backup
* startMC.sh: just start the server. Add it on crontab: `crontab -e` and append `@reboot <route>/startMC.sh`

Known issues:
- [ ] If you input a letter instead of a number in the menu selection might cause error.

Remember to set permisions to files. Use crontab with non-root user and execute mc-admin or the other tools without sudo if possible.
