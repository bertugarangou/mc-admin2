# Minecraft Linux Scripts

Minecraft server console launcher and command executor

## Description
Basic administration bash scripts when Minecraft is running with in a screen on Linux

So I wanted to create a systemd daemon (in Ubuntu) to run a Minecraft server. After realizing that RCON does not echo the output to RCON shell or being unable to achieve it, I went back to screen (TM). The ol'reliable screen solved the problems once again. This could be done with tmux but I am more comfortable with screen.

This is a personal use script, don't expect to include a 100% working instructions, a project, wiki, issues... Just do whatever the fk you want with this, and give attribution if you desire. I may maintain it if I become famous (I won't). Have fun.

## Features:
* Start/stop Minecraft
* Access the Minecraft console (basically accessing the screen)
* ~~Copy Minecraft directory to a backup folder~~ Too complicate to standarize it since I need to stop the server, mount an external SSD to a virtual cluster or NFS/SMB bla bla bla won't scalate it.

## Files:
* minecraft: Main script file. Save it werever you want.

Remember to set permissions for files. Use crontab with a non-root user and execute minecraft scripts or the other tools without sudo if possible.
* Everything on /home/minecraft:
  sudo chown v minecraft:minecraft /home/minecraft

## Instructions:
Starting from root user:
0. Install openjdk (or Oracle Java) JDK. [Link to Adoptium for LINUX](https://adoptium.net/installation/linux/)

1. Create a minecraft user's folder
   `mkdir /home/minecraft`
   
3. Create minecraft user
    `sudo useradd -r -m -U -d /home/minecraft -s /bin/bash minecraft`
   
4. Create project folders
   ```
   su - minecraft
   cd /home/minecraft
   mkdir tools
   mkdir server
   (make sure every directory and file is owned by minecraft user.
   ```
   
6. Place server.jar on "server" folder
   ```
   cd /server
   "upload server jar file here"
   chmod +x server.jar
   ```
   
7. Place minecraft file from this repo to tools directory
   `cd /home/minecraft/tools`
   upload file tools here
   (make sure the file is owned by minecraft user and +x permission)
  
8. Add minecraft file to path and aliases:
   ```
   exit (go back to root user shell)
   cd
   vim .bashrc
   ```
   
   Add the following lines at the end:
  
   ```
   alias start='minecraft start'
   alias stop='minecraft stop'
   alias status='minecraft status'
   alias shell='minecraft shell'
   ```

   `vim .profile`
   
   Add the following lines at the end:
   ```
   PATH="/home/minecraft/tools:$PATH"
   PATH="/home/minecraft/tools/mcrcon/:$PATH"
   ```

8. Exit root user and log in again (or reconnect to server ssh or console) or apply source (source .profile && source .bashrc) to apply changes
   
9. Something more I just forgot.

Don't forget to give server.jar ownershipt and execution permissions after every update.

## Useful Links:

* [Paper.io aikar's flags](https://docs.papermc.io/paper/aikars-flags) // [Paper launch script generator](https://docs.papermc.io/misc/tools/start-script-gen)
  On 1.20.6, recomended flags are: 

```
java -Xms2G -Xmx6G -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1HeapRegionSize=8M -XX:G1HeapWastePercent=5 -XX:G1MaxNewSizePercent=40 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1NewSizePercent=30 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=15 -XX:MaxGCPauseMillis=200 -XX:MaxTenuringThreshold=1 -XX:SurvivorRatio=32 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paper-MineVer-PaperVer.jar nogui
```
Paper generator website sets the same virtual memory for `-Xms` and `-Xmx`. This is not a good practice on low-end and mid-end devices or servers since will block and reserve the specified memory only for Minecraft. Since the server may not use the whole `-Xmx` memory, it's a good practice to specify a mandatory reserver memory using `-Xms` and a maximum dynamic-reserved memory using `-Xmx`. Reserving memory with `-Xmx` is a bit slower, thus if you have enough free memory to give to Java, go with the same high value on both

Example: I tend to give 6GB but I only want to firstly reserve 3GB. Thus I use: `(...) -Xms3G -Xmx6G (...)`.

If using Paper, Vanilla, Spiggot or any modern non-network-alterable server (like proxies or somethign for hughe server), DO NOT give more than 8G. Minecraft does not know how to propperly work with more than 8GB. However if you use plugins that needs more RAM/virtual memory and creates parallel processes (Ex: dynmap that creates a webserver, thread improver plugins, security...) it's okay to extend to 12 or even 16G since Minecraft is not going to take advantage of the increase but will the parallel threads of the plugins.

To sum up: do whatever yo want.
