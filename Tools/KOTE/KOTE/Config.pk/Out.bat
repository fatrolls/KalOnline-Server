del Out\*.dat
copy /Y Edit\*.dat Out\

FOR %%c in (.\Out\*.dat) DO ..\bin\swordcrypt /key:47 %%c

cd Out
..\..\bin\pkzip25 -add -pass=JKSYEHAB#9052 Config *.dat
move /Y Config.zip ..\Config.pk
cd ..
