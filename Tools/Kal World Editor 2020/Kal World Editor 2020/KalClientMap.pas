unit KalClientMap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Dialogs, ComCtrls, StdCtrls, ExtCtrls, inifiles, math,
   VectorTypes, VectorGeometry, DDS, GLCrossPlatform, DXTC;

type
  TAxel = ( aX,aY,aZ );
  TFileBuffer = Array of Byte;
  TKCMTextureMap = array[0..255] of array[0..255] of byte;
  TKCMTextureMapList = array[0..6] of TKCMTextureMap;
  TKCMTextureList = array[0..6] of byte;
  TKCMHeightMap = array[0..256] of array[0..256] of word;
  TKCMColorMap = array[0..256] of array[0..256] of array [0..2] of byte;
  TKCMObjectMap = array[0..255] of array[0..255] of byte;

  TKSMMap = array[0..255] of array[0..255] of array[0..2] of integer; //Value1,Value2,Color(RGB)
  TValues = array[1..2] of word;

  TENVGrassList = array of string;
  TENVTextureIndexList = array of string;

  //IF you don't have 'VectorTypes, VectorGeometry' in your uses list, enable these...
  //TVector3f = array[0..2] Of single;
  //TVector4f = array[0..3] Of Single;

  //Reader
  TReader = Class(TMemoryStream)
  private
  public
    function ReadByte:Byte;
    function ReadWord:Word;
    function ReadShort:Short;
    function ReadInt32:Integer;
    function ReadSingle:Single;
    function ReadString(Length:Integer):String;
  end;

  //Writer
  TWriter = Class(TMemoryStream)
  private
  public
    procedure WriteByte(byte:Byte);
    procedure WriteWord(word:word);
    procedure WriteShort(short:short);
    procedure WriteInt32(integer:integer);
    procedure Writesingle(single:Single);
    procedure WriteString(str:String);
end;


  //Quaternions
  TEuler = class
  private
    pX:extended;
    pY:extended;
    pZ:extended;
  public
    property X:extended read pX write pX;
    property Y:extended read pY write pY;
    property Z:extended read pZ write pZ;
  end;

  TQuaternion = class
  private
    pX:extended;
    pY:extended;
    pZ:extended;
    pW:extended;
  public
    property X:extended read pX write pX;
    property Y:extended read pY write pY;
    property Z:extended read pZ write pZ;
    property W:extended read pW write pW;
    procedure FillWithDegree(Axel:TAxel;Degrees:extended);
    procedure Add(Q2:TQuaternion);
  end;

  //CRC
  TCRC32 = class
  private
    Reader:TReader;
    FileBuffer: TFileBuffer;
    function Checksum(Value: Byte; Crc: Longint) : Longint;
  public
    Seed: LongWord;

    procedure LoadFromFile(FileLocation:String);
    procedure FileClose;

    function CalculateChecksum(StartOffset: LongWord; EndOffset: LongWord; XORit: Boolean): LongInt;

    constructor Create; Overload;
  end;

  //OPL
  TOPLHeader = class
  private
    CRC32:Integer;
    X,Y:Byte;
    SType:Byte;
    Count:Integer;
  public
    property CRC:Integer read CRC32 write CRC32;
    property MapX : byte read X write X;
    property MapY : byte read Y write Y;
    property ObjectCount : Integer read Count write Count;
    property ScaleType:Byte read SType write SType;
  end;

  TOPLNode = class
  private
    nPathLength:Byte;
    nPath:String;
    nPosition:TVector3F;
    nRotation:TVector4F;
    nScale:TVector3F;
    nQRotation:TQuaternion;
  public
    property PathLength:Byte read nPathLength write nPathLength;
    property Path:String read nPath write nPath;
    property Position:TVector3F read nPosition write nPosition;
    property Rotation:TVector4F read nRotation write nRotation;
    property qRotation:TQuaternion read nQRotation write nQRotation;
    property Scale:TVector3F read nScale write nScale;

    constructor Create; overload;
  end;

  TNodes = Array[0..9999] of TOPLNode;
  TOPLFile = class
  private
    nHeader       :TOPLHeader;
    nFileLocation :String;
    nLoaded       :Boolean;
    nSaved        :Boolean;
    Nodes         :TNodes;

    function GetNode(x:integer):TOPLNode;
    procedure SetNode(x:Integer; const OPLNode: TOPLNode);
  public
    property Loaded       :Boolean      read nLoaded        write nLoaded;
    property Header       :TOPLHeader   read nHeader        write nHeader;
    property Node[x:integer] :TOPLNode  read GetNode        write SetNode;

    property FileLocation :String       read nFileLocation  write nFileLocation;
    property Saved        :Boolean      read nSaved         write nSaved;

    procedure LoadFromFile(Filelocation:String);
    procedure SaveToFile(FileLocation:String);

    function ObjectCount:Integer;

    procedure AddObject(Node:TOPLNode);
    procedure RemoveObject(Node:Integer);

    constructor Create; overload;
  end;

  TKalServerMap = class
  private
    nKSMMap       :TKSMMap;
    nFileLocation :String;
    nSaved        :Boolean;
    nLoaded:Boolean;
  public
    property Loaded       :Boolean      read nLoaded        write nLoaded;
    property Map          :TKSMMap  read nKSMMap          write nKSMMap;
    property FileLocation :String   read nFileLocation    write nFileLocation;
    property Saved        :Boolean  read nSaved           write nSaved;

    procedure LoadFromFile(FileLocation:String);
    procedure SaveToFile(FileLocation:String);

    function ValuesToColor(Value1,Value2:DWORD):Integer;
    function ColorToValues(Color:Integer):TValues;
  end;

  TKCMHeader = class
  private
    pMapX         : byte;
    pMapY         : byte;
    pTextureList  : TKCMTextureList;
    pCRC          : longint;
  public
    {Loading functions}
    procedure Get(Reader:TReader);

    {Properties}
    property MapX : byte read pMapX write pMapX;
    property MapY : byte read pMapY write pMapY;
    property TextureList : TKCMTextureList read pTextureList write pTextureList;
    property CRC: longint read pCRC write pCRC;
  end;

  TKalClientMap = class
  private
    nSaved : Boolean;
    nFileLocation : String;
    nHeader :TKCMHeader;
    nTextureMapList : TKCMTextureMapList;
    nHeightMap : TKCMHeightMap;
    nColorMap : TKCMColorMap;
    nOBjectMap : TKCMOBjectMap;
    nLoaded:Boolean;

    procedure GetHeightMap (Reader:TReader);
    procedure GetColorMap  (Reader:TReader);
    procedure GetTextureMap(Reader:TReader;map:byte);
    procedure GetObjectMap (Reader:TReader);
  public
    property Loaded       :Boolean      read nLoaded        write nLoaded;

    //propertys
    property Saved : Boolean read nSaved write nSaved;
    property FileLocation : String read nFileLocation write nFileLocation;
    property Header : TKCMHeader read nHeader write nHeader;
    property TextureMapList : TKCMTextureMapList read nTextureMapList write nTextureMapList;
    property HeightMap : TKCMHeightMap read nHeightMap write nHeightMap;
    property ColorMap : TKCMColorMap read nColorMap write nColorMap;
    property ObjectMap : TKCMObjectMap read nObjectMap write nObjectMap;

    //Loading functions
    procedure LoadFromFile(FileLocation:String);
    procedure SaveToFile(FileLocation:String);
  end;

  TKalEnvironmentFile = class
  private
    nGrassList : TENVGrassList;
    nTextureIndexList : TENVTextureIndexList;
    nGrassCount,nTextureIndexCount:Integer;
  public
    property GrassList : TENVGrassList read nGrassList write nGrassList;
    property TextureIndexList : TENVTextureIndexList read nTextureIndexList write nTextureIndexList;
    property GrassCount : Integer read nGrassCount write nGrassCount;
    property TextureIndexCount : Integer read nTextureIndexCount write nTextureIndexCount;
    procedure LoadFromFile(Filelocation:String);
  end;

  type TCryptBytes = Array[0..255] of byte;

  //De- and Encryption table
  TSwordCrypt = class
  private
    EncryptTable : Array[0..199] of TCryptBytes;
    DecryptTable : Array[0..199] of TCryptBytes;
  public
    constructor Create(EnCryptTabLoc,DeCryptTabLoc:String); overload;
    function Encrypt(Value, Key: Byte): Byte;
    function Decrypt(Value, Key: Byte): Byte;

    function EncryptString(Str:String;Key:Byte):String;
    function DecryptString(Str:String;Key:Byte):String;
  end;

  procedure ConvertGTX2DDS(GTXLoc,DDSLoc,EnCryptTableLoc,DeCryptTableLoc:String);

  {Functions }
  function Vector3F(x,y,z:Single):TVector3F;
  function Vector4F(x,y,z,w:Single):TVector4F;
  procedure CRCFile(FileLocation:String);

  function GetTextureName(FileLocation:String):String;

const
  CRC32TAB : ARRAY[0..255] OF LONGINT = (
      $00000000, $77073096, $EE0E612C, $990951BA, $076DC419, $706AF48F,
      $E963A535, $9E6495A3, $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988,
      $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91, $1DB71064, $6AB020F2,
      $F3B97148, $84BE41DE, $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
      $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC, $14015C4F, $63066CD9,
      $FA0F3D63, $8D080DF5, $3B6E20C8, $4C69105E, $D56041E4, $A2677172,
      $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B, $35B5A8FA, $42B2986C,
      $DBBBC9D6, $ACBCF940, $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
      $26D930AC, $51DE003A, $C8D75180, $BFD06116, $21B4F4B5, $56B3C423,
      $CFBA9599, $B8BDA50F, $2802B89E, $5F058808, $C60CD9B2, $B10BE924,
      $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D, $76DC4190, $01DB7106,
      $98D220BC, $EFD5102A, $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433,
      $7807C9A2, $0F00F934, $9609A88E, $E10E9818, $7F6A0DBB, $086D3D2D,
      $91646C97, $E6635C01, $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
      $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457, $65B0D9C6, $12B7E950,
      $8BBEB8EA, $FCB9887C, $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
      $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2, $4ADFA541, $3DD895D7,
      $A4D1C46D, $D3D6F4FB, $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
      $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9, $5005713C, $270241AA,
      $BE0B1010, $C90C2086, $5768B525, $206F85B3, $B966D409, $CE61E49F,
      $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4, $59B33D17, $2EB40D81,
      $B7BD5C3B, $C0BA6CAD, $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A,
      $EAD54739, $9DD277AF, $04DB2615, $73DC1683, $E3630B12, $94643B84,
      $0D6D6A3E, $7A6A5AA8, $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1,
      $F00F9344, $8708A3D2, $1E01F268, $6906C2FE, $F762575D, $806567CB,
      $196C3671, $6E6B06E7, $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC,
      $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5, $D6D6A3E8, $A1D1937E,
      $38D8C2C4, $4FDFF252, $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
      $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60, $DF60EFC3, $A867DF55,
      $316E8EEF, $4669BE79, $CB61B38C, $BC66831A, $256FD2A0, $5268E236,
      $CC0C7795, $BB0B4703, $220216B9, $5505262F, $C5BA3BBE, $B2BD0B28,
      $2BB45A92, $5CB36A04, $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
      $9B64C2B0, $EC63F226, $756AA39C, $026D930A, $9C0906A9, $EB0E363F,
      $72076785, $05005713, $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38,
      $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21, $86D3D2D4, $F1D4E242,
      $68DDB3F8, $1FDA836E, $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
      $88085AE6, $FF0F6A70, $66063BCA, $11010B5C, $8F659EFF, $F862AE69,
      $616BFFD3, $166CCF45, $A00AE278, $D70DD2EE, $4E048354, $3903B3C2,
      $A7672661, $D06016F7, $4969474D, $3E6E77DB, $AED16A4A, $D9D65ADC,
      $40DF0B66, $37D83BF0, $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
      $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6, $BAD03605, $CDD70693,
      $54DE5729, $23D967BF, $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
      $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D  );

implementation

{Procedures and or functions here }
  function TReader.ReadByte:Byte;
var
  myByte:Byte;
begin
  Self.ReadBuffer(myByte,SizeOf(myByte));
  Result:=myByte;
end;

function TReader.ReadShort:Short;
var
  myShort:Short;
begin
  Self.ReadBuffer(myShort,SizeOf(myShort));
  Result:=myShort;
end;

function TReader.ReadWord:Word;
var
  myWord:Word;
begin
  Self.ReadBuffer(myWord,SizeOf(myWord));
  Result:=myWord;
end;

function TReader.ReadInt32:Integer;
var
  myInt:Integer;
begin
  Self.ReadBuffer(myInt,SizeOf(myInt));
  Result:=myInt;
end;

function TReader.ReadString(Length:Integer):String;
var
  myString:String;
  i:Integer;
begin
  myString:='';
  For i:=1 to Length do begin
    myString:=myString+Char(ReadByte());
  end;

  Result:=myString;
end;

function TReader.ReadSingle:Single;
var
  mySingle:Single;
begin
  Self.ReadBuffer(mySingle,SizeOf(mySingle));
  Result:=mySingle;
end;

procedure TWriter.WriteByte(byte:Byte);
begin
  Self.WriteBuffer(byte,1);
end;

procedure TWriter.WriteWord(word:word);
begin
  Self.WriteBuffer(word,2);
end;

procedure TWriter.WriteShort(short:short);
begin
  Self.WriteBuffer(short,2);
end;

procedure TWriter.WriteInt32(integer:integer);
begin
  Self.WriteBuffer(integer,4);
end;

procedure TWriter.Writesingle(single:Single);
begin
  Self.WriteBuffer(single,4);
end;

procedure TWriter.WriteString(str:String);
var
  x:Integer;
begin
  For x:=1 to Length(Str) do
  begin
    WriteByte(Ord(Str[x]));
  end;
end;

{ ----------------------------------------- }
{ -------------- Quaternions -------------- }
{ ----------------------------------------- }
procedure TQuaternion.FillWithDegree(Axel:TAxel;Degrees:extended);
begin
  Degrees:=Degrees/2;
  Case Axel of
    aX: Begin
          Self.W:=Cos(DegToRad(Degrees));
          Self.X:=1*Sin(DegToRad(Degrees));
          Self.Y:=0*Sin(DegToRad(Degrees));
          Self.Z:=0*Sin(DegToRad(Degrees));
        end;
    aY: Begin
          Self.W:=Cos(DegToRad(Degrees));
          Self.X:=0*Sin(DegToRad(Degrees));
          Self.Y:=1*Sin(DegToRad(Degrees));
          Self.Z:=0*Sin(DegToRad(Degrees));
        end;
    aZ: Begin
          Self.W:=Cos(DegToRad(Degrees));
          Self.X:=0*Sin(DegToRad(Degrees));
          Self.Y:=0*Sin(DegToRad(Degrees));
          Self.Z:=1*Sin(DegToRad(Degrees));
        end;
  end;
end;

procedure TQuaternion.Add(Q2:TQuaternion);
var
  Q1:TQuaternion;
begin
  //Setting Q1 with same values as current Quaternion
  Q1:=Self;

  //Multiplying it as _Varis_ explained (thank u sir)
  Self.W:=(Q1.W*Q2.W)-(Q1.X*Q2.X)-(Q1.Y*Q2.Y)-(Q1.Z*Q2.Z);
  Self.X:=(Q1.W*Q2.X)+(Q1.X*Q2.W)+(Q1.Y*Q2.Z)-(Q1.Z*Q2.Y);
  Self.Y:=(Q1.W*Q2.Y)-(Q1.X*Q2.Z)+(Q1.Y*Q2.W)+(Q1.Z*Q2.X);
  Self.Z:=(Q1.W*Q2.Z)+(Q1.X*Q2.Y)-(Q1.Y*Q2.X)+(Q1.Z*Q2.W);
end;




{ --------------------------------- }
{ -------------- CRC -------------- }
{ --------------------------------- }
constructor TCRC32.Create;
begin
  Reader:=TReader.Create;
end;
function TCRC32.CalculateChecksum(StartOffset: LongWord; EndOffset: LongWord; XORit: Boolean): LongInt;
var
  crc: longint;
  i: longword;
begin
  CRC:=Seed;

  for i:=StartOffset to EndOffset do
  begin
    CRC:=Checksum(FileBuffer[I],CRC);
  end;

  if XORit then
  begin
    CRC:=CRC XOR SEED;
  end;

  Result:=CRC;
end;

function TCRC32.Checksum(Value: Byte; Crc: Longint) : Longint;
begin
  Result := CRC32TAB[BYTE(CRC XOR LONGINT(VALUE))] XOR
           ((CRC SHR 8) AND $00FFFFFF);
end;

procedure TCRC32.FileClose;
begin
  Reader.Free;
end;
procedure TCRC32.LoadFromFile(FileLocation:String);
var i: longword;
begin

  if fileexists(FileLocation) then
  begin
    Reader.LoadFromFile(FileLocation);
    {$I-}
      SetLength(Filebuffer, Reader.Size);

      for i:=0 to High(FileBuffer) do
      begin
        FileBuffer[I]:=Reader.ReadByte();
      end;
    {$I+}
  end;
end;




{ --------------------------------- }
{ -------------- KCM -------------- }
{ --------------------------------- }
procedure TKalClientMap.LoadFromFile(FileLocation:String);
var
  i:Integer;
  Reader:TReader;
begin
  If FileExists(FileLocation) = True then
  begin
    //Setting filelocation property
    Self.FileLocation:=FileLocation;

    //Preparing reader
    Reader:=TReader.Create;
    Reader.LoadFromFile(FileLocation);

    //Loading header
    Self.Header:=TKCMHeader.Create;
    Self.Header.Get(Reader);

    //Setting position
    Reader.Position:=52;

    //Loading texturemaps
    for i:=0 to 6 do
    begin
      If (Self.Header.TextureList[i]<>$FF) then
      begin
        Self.GetTextureMap(Reader,i);
      end
      else
      begin
        break;
      end;
    end;

    //Loading Height,Color en objectmap
    GetHeightMap(Reader);
    GetColorMap(Reader);
    GetObjectMap(Reader);

    //Loaded succesfully, :)
    Self.Loaded:=True;
  end;
end;

procedure TKCMHeader.Get(Reader:TReader);
var
  I:Integer;
  TextureList:TKCMTextureList;
begin
    Try
      //CRC:=
      Self.CRC:=Reader.ReadInt32();;
      Reader.Position:=8;
      Self.MapX:=Reader.ReadInt32();
      Self.MapY:=Reader.ReadInt32();


      Reader.Position:=37;
      for i:=0 to 6 do
      begin
        TextureList[i]:=Reader.ReadByte();
      end;
      Self.TextureList:=TextureList;
    except
      ShowMessage('Error while loading KCM Header');
    end;
end;

procedure TKalClientMap.GetTextureMap(Reader:TReader;map:Byte);
var
  X,Y:Integer;
  TexMapList:TKCMTexTureMapList;
begin
  try
    TexMapList:=Self.TextureMapList;
    for Y := 255 downto 0 do
    begin
      for X := 0 to  255 do
      begin
        TexMapList[map][x][y] := Reader.ReadByte();
      end;
    end;
    Self.TextureMapList:=TexMapList;
  except
    ShowMessage('Error while loading KCM TextureMap('+IntToStr(map)+')');
  end;
end;

procedure TKalClientMap.GetObjectMap(Reader:TReader);
var
  X,Y:Integer;
  map:TKCMObjectMap;
begin
  try
    for Y := 255 downto 0 do
    begin
      for X := 0 to  255 do
      begin
        try
          map[x][y] := Reader.ReadByte();
        except
          map[x][y] := 0;
        end;
      end;
    end;
    Self.ObjectMap:=map;
  except
    ShowMessage('Error while loading KCM Object map');
  end;
end;

procedure TKalClientMap.GetColorMap(Reader:TReader);
var
  X,Y:Integer;
  map:TKCMColorMap;
begin
  try
    for Y := 255 downto 0 do
    begin
      for X := 0 to  255 do
      begin
        map[x][y][2] := Reader.ReadByte;
        map[x][y][1] := Reader.ReadByte;
        map[x][y][0] := Reader.ReadByte;
      end;
    end;
    Self.ColorMap:=map;
  except
    ShowMessage('Error while loading KCM Object map');
  end;
end;

procedure TKalClientMap.GetHeightMap(Reader:TReader);
var
  X,Y:Integer;
  map:TKCMHeightMap;
begin
  try
    for Y := 256 downto 0 do
    begin
      for X := 0 to  256 do
      begin
        map[x][y] := Reader.Readword();
      end;
    end;
    Self.HeightMap:=Map;
  except
    ShowMessage('Error while loading KCM Height map');
  end;
end;


procedure TKalClientMap.SaveToFile(FileLocation:String);
var
  x,y,u:integer;
  myByte:Byte;
  Writer:TWriter;
begin

  //Deleting the file so we can start from scratch
  Self.FileLocation:=FileLocation;
  If FileExists(FileLocation)=True then
  begin
    WINDOWS.DeleteFile(PChar(FileLocation));
  end;

  //Assinging the just created file
  Writer:=TWriter.Create;

  //Writing the first 52 bytes with 00';
  For x:=0 to 52 do
  begin
    Writer.WriteByte(0);
  end;

  //writing maps
  Writer.Position:=8;
  Writer.WriteInt32(Self.Header.MapX);
  Writer.WriteInt32(Self.Header.MapY);

  //Something else
  Writer.Position:=$20;
  Writer.WriteByte($07);

  //Writing texturelist
  Writer.Position:=$25;
  //Writer.WriteByte($5A);
  For X:=0 to 6 do
  begin
    Writer.WriteByte(Self.Header.Texturelist[x]);
  end;

  //Writing bs?
  For x:=0 to 7 do
  begin
    Writer.WriteByte(x);
  end;


  //Writing texture maps
  Writer.Position:=52;
  for U:=0 to 7 do
  begin
    If Self.Header.TextureList[U]<>$FF then
    begin
      for Y := 255 downto 0 do
      begin
        for X := 0 to 255 do
        begin
          Writer.WriteByte(TextureMapList[u][x][y]);
        end;
      end;
    end
    else
    begin
      Break;
    end;
  end;

  //Writing height map
  for Y := 256 downto 0 do
  begin
    for X := 0 to 256 do
    begin
      Writer.WriteWord(Self.Heightmap[x][y]);
    end;
  end;

  //Writing texture map ( not rgb, but bgr )
  for Y := 255 downto 0 do
  begin
    for X := 0 to 255 do
    begin
      Writer.WriteByte(Self.ColorMap[x][y][2]);
      Writer.WriteByte(Self.ColorMap[x][y][1]);
      Writer.WriteByte(Self.ColorMap[x][y][0]);
    end;
  end;

  //Writing Object map
  for Y := 255 downto 0 do
  begin
    for X := 0 to 255 do
    begin
      Writer.WriteByte(Self.ObjectMap[x][y]);
    end;
  end;

  Writer.SaveToFIle(FileLocation);
  Writer.Free;

  CRCFile(FileLocation);
end;

procedure TKalServerMap.LoadFromFile(FileLocation:String);
var
  X,Y:integer;
  map:TKSMMap;
  Reader:TReader;
begin
  If fileexists(FileLocation)=true then
  begin
    Reader:=TReader.Create;
    Reader.LoadFromFile(FileLocation);
    Reader.Position:=4;
    for Y := 255 downto 0 do
    begin
      for X := 0 to  255 do
      begin
        map[x][y][0]:=Reader.ReadWord;
        map[x][y][1]:=Reader.ReadWord;

        map[x][y][2]:=ValuesToColor(map[x][y][0],map[x][y][1]);
      end;
    end;
    Self.Map:=Map;
    Self.Loaded:=True;
    Self.FileLocation:=FileLocation;
  end;
end;

procedure TKalServerMap.SaveToFile(FileLocation:String);
var
  X,Y:Integer;
  Writer:TWriter;
begin
  try
    //Deleting the file so we can start from scratch
    If FileExists(FileLocation)=True then
    begin
      WINDOWS.DeleteFile(PChar(FileLocation));
    end;

    Writer:=TWriter.Create;
    Writer.WriteInt32($01);

    for Y := 255 downto 0 do
    begin
      for X := 0 to 255 do
      begin
        Writer.WriteWord(Self.map[x][y][0]);
        Writer.WriteWord(Self.map[x][y][1]);
      end;
    end;
  finally
    Writer.SaveToFIle(FileLocation);
    Writer.Free;
  end;
end;


function TKalServerMap.ValuesToColor(Value1,Value2:DWORD):Integer;
begin
  If Value1=65535  then
  begin
    Case Value2 of
      0 :result:=rgb(255,0  ,0);
      1 :result:=rgb(255,250,50);
      2 :result:=rgb(255,200,100);
      6 :result:=rgb(255,150,150);
      4 :result:=rgb(255,100,200);
      16:result:=rgb(255,50 ,250);
    else result:=rgb(255,0  ,0);
    end;
  end
  else
    If Value1=0 then
    begin
      Case Value2 of
        0 :result:=rgb(0  ,255,0);
        1 :result:=rgb(250,255,50);
        2 :result:=rgb(200,255,100);
        6 :result:=rgb(150,255,150);
        4 :result:=rgb(100,255,200);
        16:result:=rgb(50 ,255,250);
      else result:=rgb(0  ,255,0);
      end;
    end
    else
    begin
      result:=rgb(255,0  ,0);
    end;
end;

function TKalServerMap.ColorToValues(Color:Integer):TValues;
begin
  If GetRValue(Color)=255 then
  begin
    result[1]:=65535;
    Case GetGValue(Color) of
      0   :result[2]:= 0;
      250 :result[2]:= 1;
      200 :result[2]:= 2;
      150 :result[2]:= 6;
      100 :result[2]:= 4;
      50  :result[2]:= 16;
    else result[2]:= 0;
    end;
  end
  else
    If GetGValue(Color)=255 then
    begin
      result[1]:=0;
      Case GetRValue(Color) of
        0   :result[2]:= 0;
        250 :result[2]:= 1;
        200 :result[2]:= 2;
        150 :result[2]:= 6;
        100 :result[2]:= 4;
        50  :result[2]:= 16;
      else result[2]:= 0;
      end;
    end
    else
    begin
      result[1]:=65335;
      result[2]:=0;
    end;
end;

constructor TOPLNode.Create;
begin
  Self.nQRotation:=TQuaternion.Create;
end;

constructor TOPLFile.Create;
begin
  Self.Header:=TOPLHeader.Create;
end;

procedure TOPLFile.LoadFromFile(Filelocation:String);
var
  SingleBuffer1:single;
  x1:Integer;
  Reader:TReader;
begin

  Self.FileLocation:=FileLocation;
  If FileExists(FileLocation)=true then
  begin
    Self.Header:=TOPLHeader.Create;

    Reader:=TReader.Create;
    Reader.LoadFromFile(FileLocation);

    //Reading CRC
    Self.Header.CRC:=Reader.ReadInt32;

    //Reading MapX
    Reader.Position:=8;
    Self.Header.MapX:=Reader.ReadInt32;

    //Reading MapY
    Self.Header.MapY:=Reader.ReadInt32;

    //Reading Scale Type
    Reader.Position:=32;
    Self.Header.ScaleType:=Reader.ReadByte;

    //Reading Object Count
    Reader.Position:=36;
    Self.Header.ObjectCount:=Reader.ReadInt32;

    Reader.Position:=$28;

    If Self.Header.ObjectCount<>0  then
    begin
      For x1:=0 to Self.Header.ObjectCount-1 do
      begin
        try
          //Creating the node
          Self.Node[x1]:=TOPLNode.Create;

          //Reading path
          Self.Node[x1].Path:=Reader.ReadString(Reader.ReadInt32);

          //Reading position
          Self.Node[x1].Position:=Vector3F(Reader.ReadSingle,Reader.ReadSingle,Reader.ReadSingle);

          //Reading rotation
          Self.Node[x1].Rotation:=Vector4F(Reader.ReadSingle,Reader.ReadSingle,Reader.ReadSingle,Reader.ReadSingle);

          //Reading scale
          If Self.Header.ScaleType=4 then
          begin
            SingleBuffer1:=Reader.ReadByte();
            Self.Node[x1].Scale:=Vector3F(SingleBuffer1,SingleBuffer1,SingleBuffer1);
            Reader.Position:=Reader.Position+4;
          end
          else
          begin
            Self.Node[x1].Scale:=Vector3F(Reader.ReadSingle,Reader.ReadSingle,Reader.ReadSingle);
          end;
        except
          Self.Node[x1]:=nil;
        end;
      end;
      Self.Header.ObjectCount:=x1;
      Self.Loaded:=True;
    end;
  end
  else
  begin
    ShowMessage('Error occured while loading OPL file:'+#13+#13+'ObjectCount = 0');
  end;
end;

function TOPLFile.ObjectCount:Integer;
var
  x1:integer;
begin
  For x1:=0 to 9999 do
  begin
    If Self.Node[x1]=nil then
    begin
      Self.Header.ObjectCount:=x1;
      Result:=x1;
      Break;
    end;
  end;
end;

procedure TKalEnvironmentFile.LoadFromFile(FileLocation:String);
var
  f:File;
  StrLength:integer;
  Index:integer;
  Str:byte;
  Text:String;
  x,i,y:Integer;
  TmpGrassList:TENVGrassList;
  TmpTextureIndexList:TENVTextureIndexList;
begin
  AssignFile(F,FileLocation);
  Reset(F,1);
  Seek(F,$28);

  i:=0;
  Self.GrassCount:=0;
  while i<2 do
  begin
    BlockRead(F,Index,4);
    If Index=1 then
    begin
      i:=i+1;
      If i=2 then
      begin
        Break;
      end;
    end;
    BlockRead(F,StrLength,4);

    Text:='';
    For x:=1 to StrLength do
    begin
      BlockRead(F,Str,SizeOf(1));
      Text:=Text+Char(Str);
    end;
    SetLength(TmpGrassList,Self.GrassCount+1);
    TmpGrassList[GrassCount]:=Text+'.gb';
    //Memo1.Lines.Add('Grass type '+IntToStr(Index)+' = '+Text+'.gb');
    Self.GrassCount:=Self.GrassCount+1;
  end;

  //Loading the GrassList from the TMPGrassList
  Self.GrassList:=TmpGrassList;

  //Getting the offset of the first texture
  For x:=0 to FileSize(F)-1 do
  begin
    Seek(F,X);
    Text:='';
    For y:=1 to 5 do
    begin
      BlockRead(F,Str,1);
      Text:=Text+Char(Str);
    end;
    If Text='b_001' then
    begin
      break;
    end;
  end;

  //Moving 4 bytes back;
  Seek(F,x-4);

  //Reading to end of file
  Self.TextureIndexCount:=0;
  while FilePos(F)<FileSize(F)-1 do
  begin
    try
      BlockRead(F,StrLength,4);

      Text:='';
      For x:=1 to StrLength do
      begin
        BlockRead(F,Str,1);
        Text:=Text+Char(Str);
      end;
      SetLength(TmpTextureIndexList,Self.TextureIndexCount+1);
      TmpTextureIndexList[Self.TextureIndexCount]:=Text+'.gtx';
      //_String:=_String+#13+'('+IntToStr(Self.TextureIndexCount)+')'+Text+'.gtx';
      //Memo1.Lines.Add('Texure index '+IntToStr(y)+' = '+Text+'.gtx');
      If FilePos(F)+8>FileSize(F) Then
      begin
        Break;
      end;
      BlockRead(F,StrLength,4);
      BlockRead(F,StrLength,4);
      Self.TextureIndexCount:=Self.TextureIndexCount+1;
    except
      //When an error occures, its because reading beyond EOF... so break the loop
      Break;
    end;
  end;
  //ShowMessage(_String);

  Self.TextureIndexList:=TMPTextureIndexList;

  closeFile(F)
end;

function Vector3F(x,y,z:Single):TVector3F;
begin
  Result[0]:=x;
  Result[1]:=y;
  Result[2]:=z;
end;

function Vector4F(x,y,z,w:Single):TVector4F;
begin
  Result[0]:=x;
  Result[1]:=y;
  Result[2]:=z;
  Result[3]:=w;
end;


procedure CRCFile(FileLocation:String);
var
  crc:TCRC32;
  CRC32:LongInt;
  x:Integer;
  Reader:TReader;
  Writer:TWriter;
begin
  crc:=tcrc32.create;
  crc.loadfromfile(FileLocation);
  crc.seed:=$A0B0C0D0;

  //Initializing reader + loading it
  Reader:=TReader.Create();
  Reader.LoadFromFile(FileLocation);
  Reader.Position:=4;

  //Calcing CRC;
  CRC32:=crc.calculatechecksum(4, Reader.Size-1, False);

  //Initializing writer
  Writer:=TWriter.Create;
  Writer.Write(CRC32,SizeOf(CRC32));

  //Coping all bytes...
  For x:=4 to Reader.Size-1 do
  begin
    Writer.WriteByte(Reader.ReadByte());
  end;

  Reader.Free;
  Writer.SaveToFile(FileLocation);
  Writer.Free;
  crc.FileClose;
end;

procedure TOPLFile.SaveToFile(FileLocation:String);
var
  F:File;
  myByte:Byte;
  x1,x2:Integer;
  IntegerBuffer:Integer;
  ByteBuffer:Byte;
  Writer:TWriter;
begin
  try
    //Deleting the file so we can start from scratch
    Self.FileLocation:=FileLocation;
    If FileExists(FileLocation)=True then
    begin
      WINDOWS.DeleteFile(PChar(FileLocation));
    end;

    //Assinging the just created file
    Writer:=TWriter.Create;

    //Writing the first 52 bytes with 00';
    For x1:=0 to 52 do
    begin
      Writer.WriteByte(0);
    end;

    //Writing MapX
    Writer.Position:=8;
    Writer.WriteInt32(Self.Header.MapX);

    //Writing MapY
    Writer.Position:=12;
    Writer.WriteInt32(Self.Header.MapY);

    //Writing Scaletype, default = 7;
    Writer.Position:=32;
    Writer.Writeint32(7);

    //Writing object count
    Writer.Position:=36;
    Writer.WriteInt32(ObjectCount);

    Writer.Position:=$28;

    //Writing the Objects here
    for x1:=0 to Self.Header.ObjectCount-1 do
    begin
      //Writing pathlength
      Writer.WriteInt32(Length(Self.Node[x1].Path));
      Writer.WriteString(Self.Node[x1].Path);

      //Writing Position
      Writer.WriteBuffer(Self.Node[x1].Position,12);

      //Writing rotation
      Writer.WriteBuffer(Self.Node[x1].Rotation,16);

      //Writing scale
      Writer.WriteBuffer(Self.Node[x1].Scale,12);
    end;
  finally
    Writer.SaveToFIle(FileLocation);
    Writer.Free;
    CRCFile(FileLocation);
  end;

end;

{Destructor  TOPLFile.Destroy;
begin
  Self.Header.Destroy;

  Inherited;
end;}

{procedure  TOPLFile.Free;
begin
  //inherited;
  //Self.Header.Free;
end;}

procedure TOPLFile.AddObject(Node:TOPLNode);
var
  x:Integer;
begin
  //Adding it
  x:=Self.ObjectCount;

  Self.Nodes[x]:=TOPLNode.Create;
  Self.Nodes[x]:=Node;

  //Calculating new objectcount
  Self.ObjectCount;
end;

procedure TOPLFile.RemoveObject(Node:Integer);
var
  x1:Integer;
begin
  //Removing the node, and shifting every node
  For x1:=Node to Length(Self.Nodes)-2 do
  begin
    Self.Node[x1]:=Self.Node[x1+1];
  end;

  //Calculating new objectcount
  Self.ObjectCount
end;

function TOPLFile.GetNode(x:integer):TOPLNode;
begin
  Result:=Self.Nodes[x];
end;

procedure TOPLFile.SetNode(x:Integer; const OPLNode: TOPLNode);
begin
  Self.Nodes[x]:=OPLNode;
end;

function GetTextureName(FileLocation:String):String;
var
  Str:String;
  x,x1:Integer;
  Reader:TReader;
  buf:Byte;
begin
  If FileExists(FileLocation)=False then begin exit end;

  //Assinging the file
  Reader:=TReader.Create;
  Reader.LoadFromFile(FileLocation);

  //Searching from the back of the file.
  For x:=Reader.Size-10 downto Reader.Size-200 do
  begin
    Reader.Position:=x;
    Str:='';

    //Loading 6 bytes to a string
    For x1:=0 to 6 do
    begin
      try
        Str:=Str+Char(Reader.ReadByte());
      except
      end;
    end;

    //If the string says 'default' then we found the spot.
    If LowerCase(Str)='default' then
    begin
      break;
    end;
  end;

  //searching for dds
  For x:=x+7 to Reader.Size-1 do
  begin
    Reader.Position:=x;
    Str:=Reader.ReadString(Length('.dds'));
    //If the string says 'dds' then we found the spot.
    If LowerCase(Str)='.dds' then
    begin
      break;
    end;
  end;

  For x:=x-1 downto x-100 do
  begin
    try
      Reader.Position:=x;

      buf:=Reader.ReadByte;

      If Buf=0 then begin Result:=Str; break; end;

      Str:=Char(Buf)+Str;
    except
    end;
  end;
end;


constructor TSwordCrypt.Create(EnCryptTabLoc,DeCryptTabLoc:String);
var
  DecryptReader,EnCryptReader:TReader;
  x,y:Integer;
begin
  EnCryptReader:=TReader.Create;
  EnCryptReader.LoadFromFile(EnCryptTabLoc);

  DeCryptReader:=TReader.Create;
  DeCryptReader.LoadFromFile(DeCryptTabLoc);

  for x:=0 to 199 do
  begin
    For y:=0 to 255 do
    begin
      EncryptTable[x][y]:=EnCryptReader.ReadByte();
      DecryptTable[x][y]:=DeCryptReader.ReadByte();
    end;
  end;

  EnCryptReader.Free;
  DecryptReader.Free;
end;

function TSwordCrypt.Encrypt(Value, Key: Byte): Byte;
begin
  Result:=EncryptTable[Key, Value];
end;

function TSwordCrypt.Decrypt(Value, Key: Byte): Byte;
begin
  Result:=DecryptTable[Key, Value];
end;

function TSwordCrypt.EncryptString(Str:String;Key:Byte):String;
var
  x:integer;
begin
  For x:=1 to Length(str) do
  begin
    Result:=Result+Char(Self.Encrypt(Ord(Str[x]),key));
  end;
end;

function TSwordCrypt.DecryptString(Str:String;Key:Byte):String;
var
  x:integer;
begin
  For x:=1 to Length(str) do
  begin
    Result:=Result+Char(Self.Decrypt(Ord(Str[x]),key));
  end;
end;

{constructor TGTXImage.Create();
//var
  //t:TBitmap;
begin
t:=TBitmap.Create();
  t.
  Self.Bitmap.
  Self.Bitmap:=TBitmap.Create(nil);
end;}

procedure ConvertGTX2DDS(GTXLoc,DDSLoc,EnCryptTableLoc,DeCryptTableLoc:String);
var
  Reader:TReader;
  Writer:TWriter;
  SwordCrypt:TSwordCrypt;
  i:integer;
begin
  Reader:=TReader.Create;
  Reader.LoadFromFile(GTXLoc);
  Reader.Position:=3;

  Writer:=TWriter.Create;
  Writer.WriteString('DDS');

  SwordCrypt:=TSwordCrypt.Create(EncryptTableLoc,DeCryptTableLoc);

  for i:=3 to 7 do
  begin
    Writer.WriteByte(Reader.ReadByte())
  end;
  for i:=8 to 71 do
  begin
    Writer.WriteByte(SwordCrypt.Decrypt(Reader.ReadByte,$04));
  end;
  for i:=72 to Reader.Size-1 do
  begin
    Writer.WriteByte(Reader.ReadByte())
  end;

  ForceDirectories(ExtractFileDir(DDSLoc));
  Writer.SaveToFile(DDSLoc);

  Reader.Free;
end;

end.
