<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <!-- ##### start AJAX mods ##### -->
    <script type="text/javascript" src="ajaxCUwx.js"></script>
    <!-- AJAX updates by Ken True - http://saratoga-weather.org/wxtemplates/ -->
    <script type="text/javascript" src="ajaxgizmo.js"></script>
    <script type="text/javascript" src="language-en.js"></script>
	<!-- language for AJAX script included -->
    <meta name="description" content="Personal weather station." />
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
    <link rel="stylesheet" type="text/css" href="weather-screen-blue-narrow.css" media="screen" title="screen" />
    <link rel="stylesheet" type="text/css" href="weather-print-php.css" media="print" />
	<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
	<meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Cache-Control" content="no-cache" />
    <title>CamptonHillsWeather.com - Sample Blank Page</title>
<!-- begin flyout-menu.php CSS definition style='blue' -->
<style type="text/css">
/* ================================================================
This copyright notice must be untouched at all times.

The original version of this stylesheet and the associated (x)html
is available at http://www.cssplay.co.uk/menus/flyout_4level.html
Copyright (c) 2005-2007 Stu Nicholls. All rights reserved.
This stylesheet and the associated (x)html may be modified in any
way to fit your requirements.
Modified by Ken True and Mike Challis for Weather-Display/AJAX/PHP
template set.
=================================================================== */
.flyoutmenu {
font-size:90%;
}

/* remove all the bullets, borders and padding from the default list styling */
.flyoutmenu ul {
position:relative;
z-index:500;
padding:0;
margin:0;
padding-left: 4px; /* mchallis added to center links in firefox */
list-style-type:none;
width: 110px;
}

/* style the list items */
.flyoutmenu li {
color: #336699;
background:white url(./ajax-images/flyout-shade-white.gif);
/* for IE7 */
float:left;
margin:0; /* mchallis added to tighten gaps between links */
}
.flyoutmenu li.sub {background:white url(./ajax-images/flyout-sub.gif) no-repeat right center;}

/* get rid of the table */
.flyoutmenu table {position:absolute; border-collapse:collapse; top:0; left:0; z-index:100; font-size:1em;}

/* style the links */
.flyoutmenu a, .flyoutmenu a:visited {
display:block;
text-decoration:none;
line-height: 1.8em; 
width:95px; /* mchallis changed for adjusting firefox link width */
color:#336699;
padding: 0 2px 0 5px; 
border:1px solid black;
border-width:0 1px 1px 1px;
}
/* hack for IE5.5 */
         /* mchallis lowered the two width values to (101, 100)to fix IE6 links wider than menu width */
* html .flyoutmenu a, * html .flyoutmenu a:visited {width:95px; w\idth:94px;}
/* style the link hover */
* html .flyoutmenu a:hover {color:white; background:#3173B1; position:relative;}

.flyoutmenu li:hover {position:relative;}

/* For accessibility of the top level menu when tabbing */
.flyoutmenu a:active, .flyoutmenu a:focus {color:white; background:#3173B1;}

/* retain the hover colors for each sublevel IE7 and Firefox etc */
.flyoutmenu li:hover > a {color:white; background:#3173B1;}

/* hide the sub levels and give them a positon absolute so that they take up no room */
.flyoutmenu li ul {
visibility:hidden;
position:absolute;
top:-10px;
/* set up the overlap (minus the overrun) */
left:90px;
/* set up the overrun area */
padding:10px;
/* this is for IE to make it interpret the overrrun padding */
background:transparent url(./ajax-images/flyout-transparent.gif);
}

/* for browsers that understand this is all you need for the flyouts */
.flyoutmenu li:hover > ul {visibility:visible;}


/* for IE5.5 and IE6 you need to style each level hover */

/* keep the third level+ hidden when you hover on first level link */
.flyoutmenu ul a:hover ul ul{
visibility:hidden;
}
/* keep the fourth level+ hidden when you hover on second level link */
.flyoutmenu ul a:hover ul a:hover ul ul{
visibility:hidden;
}
/* keep the fifth level hidden when you hover on third level link */
.flyoutmenu ul a:hover ul a:hover ul a:hover ul ul{
visibility:hidden;
}

/* make the second level visible when hover on first level link */
.flyoutmenu ul a:hover ul {
visibility:visible;
}
/* make the third level visible when you hover over second level link */
.flyoutmenu ul a:hover ul a:hover ul{
visibility:visible;
}
/* make the fourth level visible when you hover over third level link */
.flyoutmenu ul a:hover ul a:hover ul a:hover ul {
visibility:visible;
}
/* make the fifth level visible when you hover over fourth level link */
.flyoutmenu ul a:hover ul a:hover ul a:hover ul a:hover ul {
visibility:visible;
}

</style>
<!-- end of flyout-menu.php CSS definition -->
<!-- World-ML template from http://saratoga-weather.org/wxtemplates/ -->
<!-- end of top -->
</head>
<body>
<!-- nws-alerts noCron=true .. running nws-alerts.php inline -->
<!-- nws-alerts.php - V1.42 - 27-Jan-2018 -->
<!-- 2 unique Zone entries found. Zones='ILZ012,ILC089' -->
<!-- cache age 370 seconds - no fetch needed -->
<!-- Cron job not used -->
<!-- Total process time: 0.0001 seconds -->
<div id="page"><!-- page wrapper -->
<!-- header -->
    <div id="header">
      <h1 class="headerTitle">
        <a href="index.php" title="Browse to homepage">CamptonHillsWeather.com</a>
      </h1>	
	  <div class="headerTemp">
	    <span class="doNotPrint">
 		  <span class="ajax" id="ajaxbigtemp">44&deg;F		  </span>
		</span>
 	  </div>

      <div class="subHeader">
        Campton Hills, Illinois, USA		      </div>
      <div class="subHeaderRight">
	  <!-- Lang='en' -->
<!-- ajax-gizmo.php V1.14 - 17-Mar-2013 - Multilingual -->
<div class="ajaxgizmo">
   <div class="doNotPrint">
	  <!-- ##### start of AJAX gizmo ##### -->
	    <noscript>[Enable JavaScript for live updates]&nbsp;</noscript>
	    <span class="ajax" id="gizmoindicator">Updated</span>:&nbsp;
		<span class="ajax" id="gizmodate">10-May-2020 11:20am</span>&nbsp; 
		<span class="ajax" id="gizmotime"></span>
		
	  <br/>&nbsp;<img src="./ajax-images/spacer.gif" height="14" width="1" alt=" " />
		<span class="ajaxcontent0" style="display: none">
		  <span class="ajax" id="gizmocurrentcond">Moderate drizzle, Unable to load kdpa data rc=302 object moved</span>
		</span>
		<span class="ajaxcontent1" style="display: none">Temperature: 
			<span class="ajax" id="gizmotemp">44.2&deg;F</span>
            
	        <span class="ajax" id="gizmotemparrow"><img src="./ajax-images/falling.gif" alt="Colder 0.6&deg;F than last hour." title="Colder 0.6&deg;F than last hour." width="7" height="8" style="border: 0; margin: 1px 3px;" />			</span>&nbsp;
			<span class="ajax" id="gizmotemprate">-0.6&deg;F</span>/hr		</span>
		<span class="ajaxcontent2" style="display: none">Humidity: 
		  <span class="ajax" id="gizmohumidity">91</span>%<img src="./ajax-images/rising.gif" alt="Increased 5.0% since last hour." title="Increased 5.0% since last hour." width="7" height="8" style="border: 0; margin: 1px 3px;" />		</span>
		<span class="ajaxcontent3" style="display: none">Dew Point: 
		  <span class="ajax" id="gizmodew">41.7&deg;F</span><img src="./ajax-images/falling.gif" alt="Decreased 0.3&deg;F since last hour." title="Decreased 0.3&deg;F since last hour." width="7" height="8" style="border: 0; margin: 1px 3px;" />		</span>
		<span class="ajaxcontent4" style="display: none">Wind: 
	    	<span class="ajax" id="gizmowindicon"></span> 
			<span class="ajax" id="gizmowinddir">W</span>&nbsp; 
			<span class="ajax" id="gizmowind">2.0 mph</span>
		</span>
		<span class="ajaxcontent5" style="display: none">Gust: 
  			<span class="ajax" id="gizmogust">5.0 mph</span>
		</span>
		<span class="ajaxcontent6" style="display: none">Barometer: 
    		<span class="ajax" id="gizmobaro">29.909  inHg</span>&nbsp;&nbsp;
             <span class="ajax" id="gizmobarotrendtext">Steady</span>			
		</span> 
		<span class="ajaxcontent7" style="display: none">Rain Today: 
    		<span class="ajax" id="gizmorain">0.06 in</span>
		</span>
		<span class="ajaxcontent8" style="display: none">UV Index: 
           <span class="ajax" id="gizmouv">0.9</span>&nbsp;
		   <span style="color: #ffffff">
	         <span class="ajax" id="gizmouvword"><span style="border: solid 1px; color: black; background-color: #A4CE6a;">&nbsp;Low&nbsp;</span></span>
		   </span>
		</span>
	  </div>
	  <!-- ##### end of AJAX gizmo  ##### -->

</div>
<!-- end of ajax-gizmo.php -->
	  </div><!-- end subHeaderRight -->
</div>
<!-- end of header -->	
<!-- menubar -->
<div class="doNotPrint">
      <div class="leftSideBar">
        <p class="sideBarTitle">Navigation</p>
<div class="flyoutmenu">
<!-- begin generated flyout menu -->
<!-- flyout-menu.php (ML) Version 1.08 - 05-Feb-2013 -->
<!-- by Ken True - webmaster[at]saratoga-weather.org and -->
<!-- by Mike Challis - webmaster[at]642weather.com  -->
<!-- Adapted from Stu Nicholl's CSS/XHTML at http://www.cssplay.co.uk/menus/flyout_4level.html -->
<!-- script available at http://saratoga-weather.org/scripts-CSSmenu.php#flyout -->
<!-- using 
Array
(
    [NAME] => blue
    [SHADE_IMAGE] => flyout-shade-white.gif
    [BORDER_COLOR] => black
    [LINK_COLOR] => #336699
    [LINK_BACKGROUND] => white
    [HOVER_COLOR] => white
    [HOVER_BACKGROUND] => #3173B1
)
 -->
<!-- using ./flyout-menu.xml for XML, doTrans=1 -->
<ul>
  <li><a href="wxindex.php" title="Home Page">Home</a></li>
  <!-- not used with CU <li><a href="wxmesonet.php" title="Local Weather Exchange Stations">Mesonet</a></li> -->
  <li class="sub"><a href="#">Radar<!--[if gte IE 7]><!--></a><!--<![endif]-->
    <!--[if lte IE 6]><table><tr><td><![endif]-->
    <ul>
    <li><a href="wxradar.php" title="Radar">Local Radar</a></li>
    </ul>
    <!--[if lte IE 6]></td></tr></table></a><![endif]-->
  </li>
  <li><a href="wxStartNoaaFct.php" title="NOAA Forecast">NOAA Forecast</a></li>
  <li class="sub"><a href="#" title="Weather outlook">Forecast &amp; Advisories<!--[if gte IE 7]><!--></a><!--<![endif]-->
    <!--[if lte IE 6]><table><tr><td><![endif]-->
    <ul>
    <li><a href="wxforecast.php">Forecast details</a></li>
    <li><a href="wxadvisory.php">Advisories</a></li>
    <li><a href="wxsimforecast.php">WXSIM Forecast details</a></li>
    <li><a href="wxuvforecast.php">UV Index Forecast</a></li>
    </ul>
    <!--[if lte IE 6]></td></tr></table></a><![endif]-->
  </li>
  <li class="sub"><a href="#" title="Trends, Sun/Moon, Earthquakes">Almanac<!--[if gte IE 7]><!--></a><!--<![endif]-->
    <!--[if lte IE 6]><table><tr><td><![endif]-->
    <ul>
    <li><a href="wxtrends.php">Weather Trends</a></li>
    <li><a href="wxgraphs.php">Station Graphs</a></li>
    <!-- not used with CU <li><a href="wxstationrecords.php">Station Records</a></li> -->
    <!-- not used with CU <li><a href="wxjournal.php">Station Journal</a></li> -->
    <!-- not used with CU <li><a href="wxrecent.php">Recent Weather Summary</a></li> -->
    <!-- not used with CU <li><a href="wxthismonth.php">Summary This Month</a></li> -->
    <!-- not used with CU <li><a href="wxyearoveryear.php">Summary Year over Year</a></li> -->
    <!-- not used with CU <li><a href="wxhistory.php">Station Monthly Reports</a></li> -->
    <li><a href="wxnoaaclimatereports.php">NOAA reports</a></li>
    <li><a href="wxastronomy.php">Sun/Moon Almanac</a></li>
    <li><a href="wxquake.php">Earthquake activity</a></li>
    <li><a href="wxmetar.php">Nearby METAR Reports</a></li>
    </ul>
    <!--[if lte IE 6]></td></tr></table></a><![endif]-->
  </li>
  <li class="sub"><a href="#">Live Console<!--[if gte IE 7]><!--></a><!--<![endif]-->
    <!--[if lte IE 6]><table><tr><td><![endif]-->
    <ul>
    <li><a href="davconvp2CW.php" title="Live Davis Vantage VP2 weather station Console">VP2 Console</a></li>
    </ul>
    <!--[if lte IE 6]></td></tr></table></a><![endif]-->
  </li>
  <li><a href="wxwebcam.php" title="Web Cams">Web Cams</a></li>
  <li><a href="wxlinks.php">Links</a></li>
  <li><a href="wxabout.php">About</a></li>
  <li><a href="wxstatus.php" title="Status of weather software">Status</a></li>
  <li><a href="wxsitemap.php">Website Map</a></li>
</ul>
<!-- end generated flyout menu -->
</div>
<!-- external links -->
<p class="sideBarTitle">External Links</p>
<ul>
   <li><a href="http://www.wunderground.com/" title="Weather Underground">Weather Underground</a></li>
   <li><a href="https://www.wunderground.com/personal-weather-station/dashboard?ID=KILSTCHA1" title="-KILSTCHA1">-KILSTCHA1</a></li>
   <li><a href="http://www.wxforum.net/" title="WXForum">WXforum.net</a></li>
   <li><a href="http://www.wxqa.com/sss/search1.cgi?keyword=CW3778" title="CW3778">APRS-CW3778</a></li>
</ul>
<!-- nws-alerts icons -->
<p class="sideBarTitle" style="text-align:center">Alerts</p>
<div style="text-align:center">
<a href="wxadvisory.php" title=" &nbsp;Summary" style="width:99%"><br /><img src="./alert-images/A-none.png" alt="No alerts" width="74" height="18" /></a> <br />
</div>
<!-- end nws-alerts icons -->
<!-- end external links -->
  <!-- begin Color Theme Switcher Plugin http://www.642weather.com/weather/scripts.php -->
  <div class="thisPage" style="margin-left: 5px; font-weight: normal;">
  <p class="sideBarTitle" style="margin-left: -5px;">Style Options</p>
<form method="post" name="style_select" action="#">
<p><label for="CSSstyle">Style:</label><br />
	 <select id="CSSstyle" name="CSSstyle"><option value="weather-screen-black.css">Black</option>
<option value="weather-screen-blue.css" selected="selected">Blue</option>
<option value="weather-screen-dark.css">Dark</option>
<option value="weather-screen-fall.css">Fall</option>
<option value="weather-screen-green.css">Green</option>
<option value="weather-screen-icetea.css">Ice Tea</option>
<option value="weather-screen-mocha.css">Mocha</option>
<option value="weather-screen-orange.css">Orange</option>
<option value="weather-screen-pastel.css">Pastel</option>
<option value="weather-screen-purple.css">Purple</option>
<option value="weather-screen-red.css">Red</option>
<option value="weather-screen-salmon.css">Salmon</option>
<option value="weather-screen-silver.css">Silver</option>
<option value="weather-screen-spring.css">Spring</option>
<option value="weather-screen-taupe.css">Taupe</option>
<option value="weather-screen-teal.css">Teal</option>
</select><br />Widescreen:<br /><label for="CSSwidescreenOn">On</label> <input type="radio" id="CSSwidescreenOn" name="CSSwidescreen" value="1"  />
	| <label for="CSSwidescreenOff">Off</label> <input type="radio" id="CSSwidescreenOff" name="CSSwidescreen" value="0"  checked="checked" /><br /><input type="submit" name="Set" value="Set" /></p>
</form>  </div>
  <!-- end Color Theme Switcher Plugin http://www.642weather.com/weather/scripts.php -->
      </div><!-- end leftSidebar -->
</div><!-- end doNotPrint -->	
<!-- end of menubar -->

<div id="main-copy">
  
        <h1>Web Cam</h1>
<img src="../webcam/fixed1.jpg" border="0" width="320" height="240">
    <p></p>
<img src="../webcam/fixed2.jpg" border="0" width="320" height="240">



</div><!-- end main-copy -->

    <!-- ##### Footer ##### -->

    <div id="footer">
      <div class="doNotPrint">
        <a href="#header">Top</a> |

        <a href="mailto:jackkozik at email.com" title="E-mail us">Contact Us</a>
        <script type="text/javascript">
        <!--
        if (navigator.appName == 'Microsoft Internet Explorer' && 
        parseInt(navigator.appVersion) >= 4)
        {
        document.write('| <a href=\"#\" onclick=\"javascript:window.external.AddFavorite        (location.href,document.title)\">');
        document.write('Bookmark Page</a>');
        }else
        {var msg = '| <a href="" title="Bookmark Page" onClick="alert(' + "'Hit CTRL-D to bookmark this page'"+ ');">Bookmark Page</a>';
        if(navigator.appName == "Netscape") msg += " (CTRL-D)";
document.write(msg);
        }
        // -->
        </script>
      </div><!-- end doNotPrint -->

      <div>

        &copy; 2020, CamptonHillsWeather.com<span class="doNotPrint"> |  
          <a href="http://sandaysoft.com/products/cumulus" title="Powered by Cumulus">Cumulus		   (1.9.4-b1099) </a> |
		  <a href="https://validator.w3.org/check?uri=referer">Valid 
          XHTML 1.0</a> |
          <a href="https://jigsaw.w3.org/css-validator/check/referer">Valid CSS</a> 
          </span><br class="doNotPrint" />
      <br/>Never base important decisions on this or any weather information obtained from the Internet.<br class="doNotPrint" />
      </div>
    </div><!-- end id="footer" -->
  </div><!-- end id="page" wrapper -->
  </body>
</html>
