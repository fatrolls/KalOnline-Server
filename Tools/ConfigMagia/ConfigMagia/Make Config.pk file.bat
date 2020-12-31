pause

cd "Edit Config.pk" 
 md make
 copy *.dat make
 cd make
  FOR %%c in (*.dat) DO ..\..\bin\swordcrypt /key:47 %%c
  ..\..\bin\pkzip25 -add -pass=jWGeCU4csqXtllqCyktScbmckkSck8LiKf2I3QfsmG3AXvkXMi54v84bn56naJj Config *.dat
  move /Y Config.zip ..\..\Config.pk
 cd..
 rd /s /q make
cd ..
