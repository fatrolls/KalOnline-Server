uses crt, opl;
begin
clrscr;
writeln('OPLRead');


 writeln('Otwieram plik...');
 Filename:='pliczek.opl';
 Open;



 writeln('Liczba obiektow OPL: ',ItemCount);
 writeln('-----------------------------');

  writeln('Pozycja X,Y,Z obiektu nr 1:');
   writeln('Pos_X=',OPLArray[0].position_x:4:4);
   writeln('Pos_Y=',OPLArray[0].position_y:4:4);
   writeln('Pos_Z=',OPLArray[0].position_z:4:4);
  writeln('Obrot X,Y,Z,W obiektu nr 1:');
   writeln('Rot_X=',OPLArray[0].rotation_x:4:4);
   writeln('Rot_Y=',OPLArray[0].rotation_y:4:4);
   writeln('Rot_Z=',OPLArray[0].rotation_z:4:4);
   writeln('Rot_W=',OPLArray[0].rotation_w:4:4);
  writeln('Skala X,Y,Z obiektu nr 1:');
   writeln('Scal_x=',OPLArray[0].scale_x:4:4);
   writeln('Scal_y=',OPLArray[0].scale_y:4:4);
   writeln('Scal_z=',OPLArray[0].scale_z:4:4);
 readln;

end.
