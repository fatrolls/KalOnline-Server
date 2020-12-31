del Out\*.dat
copy /Y Edit\*.dat Out\

FOR %%c in (.\Out\*.dat) DO ..\bin\swordcrypt /key:4 %%c

cd Out
..\..\bin\pkzip25 -add -pass=JKSYEHAB#9052 e *.dat
move /Y e.zip ..\e.pk
cd ..
