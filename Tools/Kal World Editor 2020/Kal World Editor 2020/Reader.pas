unit Reader;

interface

uses
  Windows, Classes;

type
  TReader = Class(TMemoryStream)
  private
  public
    function ReadByte:Byte;
    function ReadShort:Short;
    function ReadInt32:Integer;
    function ReadSingle:Single;
    function ReadString(Length:Integer):String;
  end;


implementation

function TGBReader.ReadByte:Byte;
var
  myByte:Byte;
begin
  Self.ReadBuffer(myByte,SizeOf(myByte));
  Result:=myByte;
end;

function TGBReader.ReadShort:Short;
var
  myShort:Short;
begin
  Self.ReadBuffer(myShort,SizeOf(myShort));
  Result:=myShort;
end;

function TGBReader.ReadInt32:Integer;
var
  myInt:Integer;
begin
  Self.ReadBuffer(myInt,SizeOf(myInt));
  Result:=myInt;
end;

function TGBReader.ReadString(Length:Integer):String;
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

function TGBReader.ReadSingle:Single;
var
  mySingle:Single;
begin
  Self.ReadBuffer(mySingle,SizeOf(mySingle));
  Result:=mySingle;
end;
