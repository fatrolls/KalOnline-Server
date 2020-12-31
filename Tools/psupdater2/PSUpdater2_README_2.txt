************************************************************************
***********************   PSUpdater 2.0 README   ***********************
************************************************************************

I do not provide the source code becuase of people changing version/copyright information and title then calling 
it there own updater without giving any Credit

PSUpdater v2.0 has the following new fetures

- File By File downloading (like real updater)

************************************************************************
***********************    Whats to Come v2.1    ***********************
************************************************************************

-Skinning
-Server Status
-Selfupdating (updater can update itself if new version comes out)

************************************************************************
***********************   Webserver Side Setup   ***********************
************************************************************************

1) make a new folder for your update files eg yourhost.com/updater/

2) open filelist.php scroll to the very bottom and replace YOURPASSWORDHERE (with a password of your choice) in this line if(isset($_POST['submit']) && $_POST['pa'] == "YOURPASSWORDHERE")

3) place filelist.php in the new folder you just created

4) upload the files you wish to update (make sure to upload folders and all) eg if you want to update config.pk you would put data/config/config.pk into yourhost.com/updater/ folder so you would have yourhost.com/updater/data/config/config.pk.

5) goto http://yourhost.com/updater/filelist.php type in the password you set in step 2 and hit "Do It" this creates file.list and contains a list of files for the users updater to download

6) whenever you add new files to the updater dir run filelist.php to create a new file.list if you forget to do this your users wont have up todate files


STEP 4 IS VERY IMPORTANT IF THIS IS NOT DONE UPDATER WILL HAVE ERRORS WHEN DOWNLOADING THE UPDATES TO THE USERS

NEVER DELETE ANY FILES ONCE UPLOADED JUST OVERRIGHT THEM WHEN YOU HAVE A NEW VERSION 

NEVER DELETE FILE.LIST

REMEMBER STEP 6

************************************************************************
***********************  Client Side User files  ***********************
************************************************************************

1) PSUpdater2.exe
- Main Updater exe file

2) updater.ini

Zip the files and give to your users

************************************************************************
***********************       Updater.ini        ***********************
************************************************************************

The updater.ini file looks like the following which i will explain below

[Settings]
UpdateHost=http://yourhost.com/updater
UpdateFile=file.list
NoticeFile=notice.txt
WebsiteButtonURL=http://yourhost.com
UpdaterTitle=My Updater Title :)



UpdateHost       - web address that is holding the updates make sure there is no end slash / 
UpdateFile       - file.list This can not be changed its hardcoded in the updater exe if changed update will not work
NoticeFile       - Name of your notice file to hold information and notices about your server 
WebsiteButtonURL - Website Address of your Server webpage for registerion etc
UpdaterTitle     - Title of the Updater to be displayed in the title bar of the updater

MAKE SURE YOU EDIT updater.ini WITH YOUR SERVER SETTINGS BEFORE GIVING IT TO ANYONE

