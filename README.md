# InstallCHW.com
This script installs CamptonHillsWeather.com onto a docker container.
It is made from the scripts at Saratoga Weather. With this repository, I hope to automate putting these scripts into a docker container, making it easier for me to keep up to date and move as my server environment evolves.

```
# To get started, clone the repository, build and run it
$ git clone https://github.com/jkozik/InstallCHW.com
$ docker build -t jkozik/chw.com .
$ docker run -dit --name chw.com-app -p 8083:80 -v /home/weather/public_html:/var/www/html/mount jkozik/chw.com

# shell prompt, logs, and restart needed for rebuild
$ docker exec -it chw.com-app /bin/bash
$ docker logs -f .com-app
$ docker stop chw.com-app; docker rm chw.com-app

```

This container mounts a host directory (see -v option above). The data comes from the Cumulus program that runs in a separte Windows 10 instance.  The following data is expected there:
```
-realtime.txt -- key realtime file updated every minute
-davconfcst.php,davcon24.txt -- data to recreate the Davis Console.  Scripts from Silver Acron Weather
-Reports/ -- Cumulus reports by month
-images/ -- Cumulus station graphes
-awekas_wl.htm -- retrieved by https://www.awekas.at/

```
The Cumulus program has an Internet Files menu tab that generates these files from templates.  Setup for generating these files is outside of the scope for this repository.
