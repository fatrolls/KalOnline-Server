unit opl;

interface
uses Dialogs,Classes, SysUtils;

type FOPLHeader = record
         Crap: array[0..34] of char;
         ItemCount: LongWord;
        end;

 type FOPL = packed record
   plength: longword;
   gbpath: array of char;
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

    type TOpl = class
      private
        F: File;
        OPLHeader : FOplHeader;

      public
        Filename: String;
        ItemCount: Integer;
        OplArray: array[0..65535] of FOpl;

        procedure Open;
        function getPath(i: integer): string;

    end;

implementation

function TOPL.getPath(i: integer): string;
var tmp: string;
    ch: word;
begin
tmp:='';
for ch:=0 to High(OPLArray[i].gbpath)do
tmp:=tmp+OPLArray[i].gbpath[ch];

result:=tmp;
end;

procedure TOPL.Open;
var i: integer;
begin
{$I-}
AssignFile(F,Filename);
 Reset(F,1);
 {****READING HEADER****}
 BlockRead(F,OPLHeader,SizeOf(OPLHeader));
 ItemCount:=OPLHeader.ItemCount;

 {****READING LIST****}
// SetLength(OPLArray,ItemCount*40);

 Showmessage('size='+inttostr(SizeOf(OPLArray)));;

 Seek(F,40);

 for i:=0 to ItemCount-1 do
  begin
   //GET PATH LENGTH
    BlockRead(F,OPLArray[i].plength, sizeof(OPLArray[i].plength));

   //GET PATH
   SetLength(OPLArray[i].gbpath,OPLArray[i].plength);
   BlockRead(F,OPLArray[i].gbpath, 32);

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
   //GET SCALE Y
   BlockRead(F,OPLArray[i].scale_z, sizeOf(OPLArray[i].scale_z));
  end;

CloseFile(F);
end;


end.
