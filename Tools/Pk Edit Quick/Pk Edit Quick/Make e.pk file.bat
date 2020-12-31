cd "New or Modified Dialogues"
 copy *.* "..\Edit e.pk"
cd..
cd "Edit e.pk" 
 md make
 copy *.dat make
 cd make
  FOR %%c in (*.dat) DO ..\..\bin\swordcrypt /key:4 %%c
  ..\..\bin\pkzip25 -add -pass=PUT PASSWORD HERE e *.dat
  move /Y e.zip ..\..\e.pk
 cd..
 rd /s /q make
cd ..
