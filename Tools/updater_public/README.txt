************************************************************************
***********************    Updater v1.0 README   ***********************
************************************************************************

I am no longer providing the source code becuase of people changing version/copyright information and title then calling 
it there own updater without giving any Credit

Updater v1.0 is a total rewrite from the betas i have posted to RageZone. This version has the following new fetures

- Working progress bar
- Unzip function so that all undates are in 1 zip file
- New and faster download routines
- updater.ini config file system
- Changeable Updater Title bar via the updater.ini file
- Changeable Notice file name via the updater.ini file
- Changeable Update File name via the updater.ini file
- Changeable Website Button URL via the updater.ini file
- Changeable Host via the updater.ini file

************************************************************************
***********************  Update WebServer Files  ***********************
************************************************************************

In order for updates to work the webserver needs to host 3 files 
1) updater.ini 
- Used for update version checking
- Edit this file file before updloading or adding it to user files

2) yourupdatefile.zip 
- Your Update File 
- The name can be changed in updater.ini
- Has to be .zip the functions i use only works for zip files
- The name of yourupdatefile.zip can be changed in updater.ini

3) yournoticefile.txt
- Notice File to display news and notices about your server
- The name of notice.txt can be changed in updater.ini

************************************************************************
***********************  Client Side User files  ***********************
************************************************************************

1) updater.exe
- Main Updater exe file

2) unzip32.dll
- Dll for Unzip functions

3) updater.ini
- Settings file to hold update server information

************************************************************************
***********************       Updater.ini        ***********************
************************************************************************

The updater.ini file looks like the follow which i will explain below

[Settings]
UpdateHost=http://sagemedia.net/~taz1/updater
UpdateFile=update.zip
NoticeFile=notice.txt
WebsiteButtonURL=http://sagemedia.net
UpdaterTitle=My Updater :)
UpdateVersion=1001



UpdateHost       - web address that is holding the updates make sure there is no end slash / 
UpdateFile       - Name of the update file you are using for your updates. Has to be a ZIP file ONLY 
	           DO NOT USE RAR OR ANY OTHER FORM OF COMPRESSION
NoticeFile       - Name of your notice file to hold information and notices about your server 
WebsiteButtonURL - Website Address of your Server webpage for registerion etc
UpdaterTitle     - Title of the Updater to be displayed in the title bar of the updater
UpdateVersion    - Update version number
		 - This should be set to 1000 for client side files 
                 - Then edit the webserver updater.ini UpdateVersion +1 for every new update you add


MAKE SURE YOU EDIT updater.ini WITH YOUR SERVER SETTINGS BEFORE GIVING IT TO ANYONE

Updater.ini on the webserver is for update version checking so it has to be set higher then the one u give users set 
updateversion to 1000 for you users updater, and 1001 for the one u put on the webserver for the first time so that when 
your User load the updater they will get the updates. When the update downloads the updater changes the version to 1001 on 
the users updater.ini.

Every time you put a new update on the server you need to incress the updateversion in the updater.ini on the webserver 