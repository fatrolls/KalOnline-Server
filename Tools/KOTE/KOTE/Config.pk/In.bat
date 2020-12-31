cd In
rename Config.pk Config.zip
..\..\bin\pkzip25 -extract -over=all -pass=JKSYEHAB#9052 Config *.dat
rename Config.zip Config.pk
cd ..

del Edit\*.dat
copy /Y In\*.dat Edit\

FOR %%c in (Edit\*.dat) DO ..\bin\swordcrypt /d /key:47 %%c
