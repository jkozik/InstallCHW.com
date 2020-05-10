echo "Customize Settings.php"
sed -i  -e  '/SITE\[\x27organ/s/= \x27.*;/= \x27CamptonHillsWeather.com\x27;/' \
        -e  '/SITE\[\x27copyr/s/Your Weather Website/CamptonHillsWeather.com/' \
        -e  '/SITE\[\x27location/s/Somewhere, SomeState, USA/Campton Hill, Illinois, USA/' \
        -e  '/SITE\[\x27email/s/mailto:somebody@somemail.org/jackkozik at email.com/' \
        -e  '/SITE\[\x27latitude/s/= \x27.*;/= \x2741.96028\x27;/' \
        -e  '/SITE\[\x27longitude/s/= \x27.*;/= \x27-88.42278\x27;/' \
        -e  '/SITE\[\x27cityname/s/Saratoga/Campton Hills/' \
        -e  '/SITE\[\x27tz/s/Los_Angeles/Chicago/' \
        -e  '/SITE\[\x27WXSIM/s/true/false/' \
        -e  '/SITE\[\x27noaazone/s/= \x27.*;/= \x27ILZ012\x27;/' \
        -e  '/SITE\[\x27noaaradar/s/= \x27.*;/= \x27LOT\x27;/' \
        -e  '/SITE\[\x27WUregion/s/= \x27.*;/= \x27mw\x27;/' \
        -e  '/SITE\[\x27WUsatellite/s/= \x27.*;/= \x27nc\x27;/' \
        -e  '/SITE\[\x27GR3radar/s/= \x27.*;/= \x27lot\x27;/' \
        -e   '/SITE\[\x27fcsturlNWS/s@= \x27.*;@= \x27https://forecast\.weather\.gov/MapClick\.php?lat=41\.9861\&lon=-88\.3844\&unit=0\&lg=english\&FcstType=text\&TextType=2\x27;@' \
        Settings.php


sed -i  '/SITE\[\x27NWSforecasts/,/^);/ c\
$SITE[\x27NWSforecasts\x27]   = array( // for the advforecast2.php V3.xx version script \
// use "Zone|Location|Point-printableURL",  as entries .. first one will be the default forecast. \
"ILZ012|Campton Hills|http://forecast.weather.gov/MapClick.php?lat=41.9861&lon=-88.3844&unit=0&lg=english&FcstType=text&TextType=2", \
"ILZ012|St. Charles|http://forecast.weather.gov/MapClick.php?CityName=Saint+Charles&state=IL&site=LOT&textField1=41.9203&textField2=-88.3008&e=0&TextType=2", \
"ILZ013|Naperville|http://forecast.weather.gov/MapClick.php?CityName=Naperville&state=IL&site=LOT&textField1=41.7626&textField2=-88.1543&e=0&TextType=2", \
"ILZ014|Chicago Midway|http://forecast.weather.gov/MapClick.php?CityName=Chicago&state=IL&site=LOT&textField1=41.837&textField2=-87.685&e=1&TextType=2", \
"ILZ014|Chicago OHare|http://forecast.weather.gov/MapClick.php?CityName=Amf+Ohare&state=IL&site=LOT&lat=41.9803&lon=-87.9023&TextType=2" \
);\
' Settings.php

sed -i '/SITE\[\x27NWSalertsCodes\x27/,/^);/ c\
$SITE[\x27NWSalertsCodes\x27] = array( \
"Campton Hills|ILZ012|ILC089", \
"Naperville|ILZ013|ILC043"\
);\
' Settings.php

echo "Customize Settings-weather.php"
sed -i  -e  '/SITE\[\x27realtimefile/s/realtime.txt/mount\/realtime.txt/' \
        -e  '/SITE\[\x27graphImageDir/s/images/mount\/images/' \
        -e  '/SITE\[\x27NOAAdir/s/Reports/mount\/Reports/' \
        -e  '/SITE\[\x27conditionsMETAR/s/= \x27.*;/= \x27KDPA\x27;/' \
        Settings-weather.php

echo "Customize ajaxCUwx.js"
sed -i '/realtimeFile = \x27/s/realtime.txt/.\/mount\/realtime.txt/' ajaxCUwx.js

echo "Customize wxquake.php"
sed -i -e '/$setLatitude/s//#&/' \
       -e '/$setLongitude/s//#&/' \
       -e '/$setLocationName/s//#&/' \
       -e '/$setTimeZone/s//#&/' \
       wxquake.php

echo "Customize wxmetar.php"
sed -i '/MetarList = array/,/^);/ c\
$MetarList = array ( // set this list to your local METARs \
// Metar(ICAO) | Name of station | dist-mi | dist-km | direction | \
  "KDPA|Chicago/Dupage, Illinois, USA|9|15|ESE|", // lat=41.9167,long=-88.2500, elev=231, dated=24-MAY-17 \
  "KARR|Chicago/Aurora, Illinois, USA|14|22|SSW|", // lat=41.7667,long=-88.4833, elev=215, dated=24-MAY-17 \
  "KDKB|De Kalb, Illinois, USA|14|23|W|", // lat=41.9333,long=-88.7000, elev=279, dated=24-MAY-17 \
  "KORD|Chicago O\x27hare, Illinois, USA|25|41|E|", // lat=41.9833,long=-87.9333, elev=200, dated=24-MAY-17 \
  "KPWK|Palwaukee, Illinois, USA|29|47|ENE|", // lat=42.1167,long=-87.9000, elev=203, dated=24-MAY-17 \
  "KLOT|Romeoville/Chi, Illinois, USA|30|48|SE|", // lat=41.6000,long=-88.1000, elev=205, dated=24-MAY-17 \
  "KJOT|Joliet, Illinois, USA|33|53|SSE|", // lat=41.5167,long=-88.1833, elev=177, dated=24-MAY-17 \
  "KRPJ|Rochelle/Koritz, Illinois, USA|34|55|W|", // lat=41.8833,long=-89.0833, elev=238, dated=24-MAY-17 \
  "KC09|Morris-Washburn, Illinois, USA|36|59|S|", // lat=41.4333,long=-88.4167, elev=178, dated=24-MAY-17 \
  "KMDW|Chicago, Illinois, USA|37|59|ESE|", // lat=41.7833,long=-87.7500, elev=188, dated=24-MAY-17 \
  "KRFD|Rockford, Illinois, USA|38|62|WNW|", // lat=42.2000,long=-89.1000, elev=221, dated=24-MAY-17 \
  "KUGN|Waukegan, Illinois, USA|42|68|NE|", // lat=42.4167,long=-87.8667, elev=222, dated=24-MAY-17 \
  "KBUU|Burlington, Wisconsin, USA|50|81|N|", // lat=42.6833,long=-88.3000, elev=237, dated=11-SEP-17 \
// list generated Sun, 10-May-2020 10:14am PDT at https://saratoga-weather.org/wxtemplates/find-metar.php \
);\
' wxmetar.php




echo "Customize menubar.php"
sed -i '/External Links/, /^<.ul>/ c\
<p class="sideBarTitle"><?php langtrans(\x27External Links\x27); ?></p>\
<ul>\
   <li><a href="http://www.wunderground.com/" title="Weather Underground">Weather Underground</a></li>\
   <li><a href="https://www.wunderground.com/personal-weather-station/dashboard?ID=KILSTCHA1" title="-KILSTCHA1">-KILSTCHA1</a></li>\
   <li><a href="http://www.wxforum.net/" title="WXForum">WXforum.net</a></li>\
   <li><a href="http://www.wxqa.com/sss/search1.cgi?keyword=CW3778" title="CW3778">APRS-CW3778</a></li>\
</ul>\
' menubar.php

echo "Customize include-wxstatus.php"
sed -i '/realtimefile/s/15/60/' include-wxstatus.php

echo "Customize noaafct/noaaSettings.php"
sed -i -e '/myLatitude/s/= \x27.*\x27;/= \x2741.96028\x27;/' \
       -e '/myLongitude/s/= \x27.*\x27;/= \x27-88.42278\x27;/'   \
       -e '/myArea/s/= \x27.*\x27;/= \x27CamptonHills\x27;/'   \
       -e '/myStation/s/= \x27.*\x27;/= \x27CamptonHillsWeather.com\x27;/'   noaafct/noaaSettings.php

echo "Customize noaafct/noaaDigitalGenerateHtml.php"
sed -i '/<?php/a\
error_reporting(0);
' noaafct/noaaDigitalGenerateHtml.php

echo "Customize davconvp2CW.php"
sed -i '/graphurl/s/davcon24.txt/mount\/davcon24.txt/'  davconvp2CW.php
