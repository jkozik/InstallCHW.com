# InstallCHW.com
CamptonHillsWeather.com is made from the scripts at Saratoga Weather. With this repository, I hope to automate putting these scripts into a docker container, making it easier for me to keep up to date and move as my server environment evolves.
First, setup a data storage container that wraps the realtime weather data files (eg realtime.txt) into something that can be shared across multiple containers.  So run below, but only once.  If you are running multiple websites from the same weather data, this container is shared.  So optionally run below:
```
$ docker run -dit --name weather-data -v /mount/weather:/var/www/html/mount php:7.2-apache
$ docker exec -it weather-data /bin/bash     # verify that you can find realtime.txt in the directory sited above
```

Next, clone the repository, build and run it
```
$ git clone https://github.com/jkozik/InstallCHW.com
# Optionally edit customerSettings.sh 
$ docker build -t jkozik/chw.com .
$ docker run -dit --name chw.com-app -p 8083:80 --volumes-from weather-data jkozik/chw.com

# shell prompt, logs, and restart needed for rebuild
$ docker exec -it chw.com-app /bin/bash
$ docker logs -f chw.com-app
$ docker stop chw.com-app; docker rm chw.com-app

```

The wjr-data contain mounts a host directory. The data comes from the Cumulus program that runs in a separte Windows 10 instance.  The following data is expected there:
```
-realtime.txt -- key realtime file updated every minute
-davconfcst.php,davcon24.txt -- data to recreate the Davis Console.  Scripts from Silver Acron Weather
-Reports/ -- Cumulus reports by month
-images/ -- Cumulus station graphes
-awekas_wl.htm -- retrieved by https://www.awekas.at/
```
The Cumulus program has an Internet Files menu tab that generates these files from templates.  Setup for generating these files is outside of the scope for this repository.
The precise paths to the data above are not fixed.  EG, the key file realtime.txt is found at mount/cumulus/realtime.txt.  This path needs to get reflected in Settings.php and Settings-weather.php; I use the customizeSettings.sh script to set this. You'll need to edit customizeSettings.sh for your setup.



This container is a web server that displays weather data.  The scripts that generate the data come from the Saratoga weather web site.
The container gets all of its data from the mount shown in the -v option above.  That data is generated from a program called Cumulus.  It has an ethernet interface to my Davis weather station.  It polls my weather station, generates graphes, screens, and real time data files.
This data gets ftp'd to my host computer.  The data sits outside of my container; the -v option maps that data to my container.

Now in my case.  My host runs VirtualBox.  Within my VB installation I run Virtual Machines for one reason or another.  One of my VMs I use for containers.  So my setup requires that I share data between my host and VB and VB and the container.
```
HOST <-> VB VMs <-> Containers
```

So outside of this install script, my VB VM that runs this container gets the following settings:
```
Shared Folders / Machine Folders
-Folder Path /home/weather/public_html
-Folder Name weather    Auto-mount, Make Permanent
```

And, my VB VM that is running this container must be setup to support VB shared folders:
```
# mkdir /mount; mkdir /mount/weather
# mount -t vboxsf weather /mount/weather
# vi /etc/fstab     -- add the line "weather /mount/weather  vboxsf  defaults 0 0"
# vi /etc/modules   -- add the line "vboxfs"
```

So if I ran docker native on my host I wouldn't need this, but on my host I am running docker, kubernetes, and native applications.  For me, it is easier to keep my projects in VMs to that I don't create dependencies between my projects.  

So why bother with this setup?

I have been running weather software on my home servers for years.  Since 2004. And every couple of years, I am triggered to re-setup everything. By automating my setup as much as possible, I hope to reduce the amount of work I have to do to re-setup everything.  Maybe someday, I'll want to move everything to a hosted / cloud service.  If I am on docker, the setup / re-setup will be lower. All the cloud hosting services support docker with very low getting started monthly costs.  But for now, this is on my home servers rack, and I am purely doing this to save me some time.


https://stackoverflow.com/questions/45928842/multiple-volumes-to-single-target-directory
multiple containers share the same mount point on host

Also check out:
https://github.com/abagayev/docker-bootstrap-collection

I decided to run the CHW.com application straight on the server, no VMs. Here's the two key commands I ran as user jkozik on the server:
```
$ docker run -dit --name weather-data -v /home/weather/public_html:/var/www/html/mount php:7.2-apache
$ docker run -dit --name chw.com-app -p 8083:80 --volumes-from weather-data jkozik/chw.com
```
At this point, it is good to verify that the web server can correctly see the realtime weather data. Run the following test:
```
$ curl http://<my ip address>:8083/mount/cumulus/realtime.txt
```
