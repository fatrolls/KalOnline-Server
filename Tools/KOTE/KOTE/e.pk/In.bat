cd In
rename e.pk e.zip
..\..\bin\pkzip25 -extract -over=all -pass=JKSYEHAB#9052 e *.dat
rename e.zip e.pk
cd ..

del Edit\*.dat
copy /Y In\*.dat Edit\

FOR %%c in (Edit\*.dat) DO ..\bin\swordcrypt /d /key:4 %%c
