#!/bin/bash

### Change vars to your values
minecraft_dir=/media/minecraft 	#Directory where Minecraft files are located
jar_file=paper.jar 			    #Minecraft .jar file name
backup_dir=/media/backups-mc	    #Directory where Minecraft will save backups, a folder with the date and time will be created inside
screen_name=minesrv			   	#Name of the screen in which Minecraft is running. If you followed Google Cloud guide [1] leave it to mcs
start_command="java -Xms2G -Xmx6G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paper.jar --nogui"
###

# Functions

function print_name(){
	cat << EOF
-------------------------------------------------------------------------
  __  __  ____        _    ____  __  __ ___ _   _   ____  _     _     _
 |  \/  |/ ___|      / \  |  _ \|  \/  |_ _| \ | | |  _ \| | __| | __| |
 | |\/| | |   _____ / _ \ | | | | |\/| || ||  \| | | |_) | |/ _\ |/ _\ |
 | |  | | |__|_____/ ___ \| |_| | |  | || || |\  | |  _ <| | (_| | (_| |
 |_|  |_|\____|   /_/   \_\____/|_|  |_|___|_| \_| |_| \_\_|\__,_|\__,_|
 By MVALSELLS and updated by Carquinyolis
-------------------------------------------------------------------------

EOF
}

function print_menu() {
	cat << EOF
---------------
Main menu
---------------
1. Start Minecraft
2. Stop Minecraft
3. Access Minecraft console
4. Make backup
5. Exit
----
Input menu option number [1-5]:
EOF
}

#Main code

menu=0
        while [ $menu -ne 4 ]
        do
                clear
                print_name
                print_menu
                read -r menu
                case "$menu" in
                        1)

								#Check if SCREEN is already running

								if [ "$(screen -list | grep "$screen_name" -c)" -eq 0 ]
								then
									#If not running asking user if it wants to start a doing so.
	                                echo "Do you want to start Minecraft server? [y/n]"
	                                read -r start
	                                if [ "y" == "$start" ]
	                                then
	                                        echo "Starting Minecraft..."
	                                        if cd "$minecraft_dir" #Try to change direcotry, if it does not exist show an error
	                                        then
		                                        screen -d -m -S "$screen_name" $start_command
		                                        echo -e "Screen started with the name $screen_name, in 20-60 seconds it should be working"
		                                    else
		                                    	echo -e "Error changing directory to $minecraft_dir"
		                                   	fi
	                                else
	                                        echo "Okey, not doing anything"
	                                fi
	                            else
	                            	#Do not try to start a new screen if it is alread -ry runing
	                            	echo -e "It looks like theres is screen running which the name contains $screen_name"
	                            	echo "Not doing anything"
	                            fi;;

	                    2)
							echo "Do you want to stop Minecraft server? [y/n]"
	                        read -r stop
	                        if [ "y" == "$stop" ]
							then
								screen -r "$screen_name" -X stuff 'stop\n'
								echo "Stoping Server, it can take some seconds. Check the logs if needed."
							else
								echo "Okey, not doing anything"
							fi;;
                        3)
							#Remember user how to deatach form screen
                            echo -e "Accessing Minecraft console..."
                            echo -e "-------------------------------------------------------------\nIMPORTANT!!!"
                            echo -e "To exit press ctrl+a followed by d"
                            echo -e "-------------------------------------------------------------\nPress enter key to continue"
                            read
                            screen -r "$screen_name";;
                        4)
							backup_dir="$backup_dir/$(date +%Y-%m-%d--%H-%M-%S)" #Adding time to backup dir
                            mkdir -p "$backup_dir"
							echo -e "Starting backup, be patient...\nI will tell you once I have finished\n.\n..\n..."


                            #Check if the backup has done correctly
                            if cp -rf "$minecraft_dir/"* "$backup_dir"
                            	then
                            	    touch "$backup_dir/00_Backup_OK"
                                    echo -e "Backup created correctly at $backup_dir"
                                else
                                    touch "$backup_dir/00_Backup_NO_OK"
                                    echo -e "\n.\n..\n...\nThere where errors while copying the files, please see errors above"
                             fi;;

						5)exit;;

                        *) echo "Please, type a number between 1 and 5";;
                esac
		echo -e "Press enter key to get back to the main menu"
		read
        done
