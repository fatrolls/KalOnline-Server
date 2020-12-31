unit opl;

interface

type FOPLHeader = record
         Crap: array[0..34] of char;
         ItemCount: LongWord;
        end;

 type FOPL = packed record
   plength: longword;
   gbpath: array[0..255] of char;
    position_x : Single;
    position_y : Single;
    position_z : Single;
     rotation_x : Single;
     rotation_y : Single;
     rotation_z : Single;
     rotation_w : Single;
      scale_x : real;
      scale_y : real;
      scale_z : real;
    end;

var
        F: File;
        OPLHeader : FOplHeader;

        Filename: String;
        ItemCount: Integer;
        OplArray: array[0..65535] of FOpl;

        procedure Open;

implementation

procedure Open;
var i: integer;
begin
{$I-}
Assign(F,Filename);
 Reset(F,1);
 {****READING HEADER****}
 BlockRead(F,OPLHeader,SizeOf(OPLHeader));
 ItemCount:=OPLHeader.ItemCount;

 {****READING LIST****}
 Seek(F,40);

 for i:=0 to 0 do
  begin
   //GET PATH LENGTH
    BlockRead(F,OPLArray[i].plength, sizeof(OPLArray[i].plength));

   //GET PATH
   BlockRead(F,OPLArray[i].gbpath, OPLArray[i].plength);

   //GET POSITION X
   BlockRead(F,OPLArray[i].position_x, sizeOf(OPLArray[i].position_x));
   //GET POSITION Y
   BlockRead(F,OPLArray[i].position_y, sizeOf(OPLArray[i].position_y));
   //GET POSITION Z
   BlockRead(F,OPLArray[i].position_z, sizeOf(OPLArray[i].position_z));

   //GET ROTATION X
   BlockRead(F,OPLArray[i].rotation_x, sizeOf(OPLArray[i].rotation_x));
   //GET ROTATION Y
   BlockRead(F,OPLArray[i].rotation_y, sizeOf(OPLArray[i].rotation_y));
   //GET ROTATION Z
   BlockRead(F,OPLArray[i].rotation_z, sizeOf(OPLArray[i].rotation_z));
   //GET ROTATION W
   BlockRead(F,OPLArray[i].rotation_w, sizeOf(OPLArray[i].rotation_w));

   //GET SCALE X
   BlockRead(F,OPLArray[i].scale_x, sizeOf(OPLArray[i].scale_x));
   //GET SCALE Y
   BlockRead(F,OPLArray[i].scale_y, sizeOf(OPLArray[i].scale_y));
   //GET SCALE Z
   BlockRead(F,OPLArray[i].scale_z, sizeOf(OPLArray[i].scale_z));
  end;

Close(F);
end;


end.
