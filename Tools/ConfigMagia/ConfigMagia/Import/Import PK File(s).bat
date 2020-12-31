cd..
cd bin
md "Original Pk Files"
cd..
echo off
if EXIST "Edit Config.pk\*.dat" (
 cls
 echo A Config.PK file is already extracted in this location.
 echo You must delete these files before the new files 
 echo can be extracted
 pause
) ELSE (
 rd /s /q "Edit Config.pk"
 md "Edit Config.pk"
 move import\config.pk "Edit Config.pk\config.pk"
 cd "Edit Config.pk"
  rename Config.pk Config.zip
  ..\bin\pkzip25 -extract -over=all -pass=W08TER007L0K9 Config *.dat
  FOR %%c in (*.dat) DO ..\bin\swordcrypt /d /key:47 %%c
  rename Config.zip Config.pk
  move config.pk "..\bin\Original Pk Files\config.pk"
 cd..
)

if EXIST "Edit E.pk\*.dat" (
 cls
 echo A E.PK file is already extracted in this location.
 echo You must delete these files before the new files 
 echo can be extracted
 pause
) ELSE (
 rd /s /q "Edit e.pk"
 md "Edit e.pk"
 move import\e.pk "Edit e.pk\e.pk"
 cd "Edit e.pk"
  rename e.pk e.zip
  ..\bin\pkzip25 -extract -over=all -pass=W08TER007L0K9 e *.dat
  FOR %%c in (*.dat) DO ..\bin\swordcrypt /d /key:4 %%c
  rename e.zip e.pk
  move e.pk "..\bin\Original Pk Files\e.pk"
 cd..
)