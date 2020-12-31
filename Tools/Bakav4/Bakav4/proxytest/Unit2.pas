unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ScktComp,encode,decode;

type
  tTest = class(TThread)
  private
    { Private declarations }
      client:tclientsocket;
      socket:tcustomwinsocket;
      error:boolean;
      mwait,enc,dec:integer;
    procedure OnError(Sender: TObject;Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;  var ErrorCode: Integer);
  public
    { Public declarations }
    constructor Create(CreateSuspended: Boolean);
    procedure DOStuff(msocket:tcustomwinsocket;host:string;port,wait:integer);
    procedure CheckData;
  protected
    procedure Execute; override;
  end;
  
var test: Ttest;

implementation

type tpacket=packed record
 size:word;
 chars:array[0..65535] of char;
end;

procedure ttest.CheckData;
var size:word;
var typ:byte;
var chars:array[0..65535] of char;
var packet:tpacket;
var i,ye:integer;
begin
  //so..
  ye:=0;
  try
   if client.Socket.ReceiveLength <> 0 then
   begin
    //so so revice..//get from server..
    client.Socket.ReceiveBuf(size,2);
    //client.Socket.ReceiveBuf(typ,1);
    client.socket.ReceiveBuf(chars,size-2);
    //decode stuff..
    for i := 0 to size-2 do
    begin
     packet.chars[i]:=encode.text(chars[i],dec)[1];
    end;
    //if typ=0 ?
    if chars[0] = #$2a then
    begin
     dec:=ord(chars[6]); //yeah 5 what i know..
     enc:=dec;
    end;
    //make packet..
    packet.size:=size;
    //send..
    socket.SendBuf(packet,packet.size); //see ya :P
     ye:=1;
   end;
  except
   //do ntoihing :P
   error:=true;
  end;
  try
   if socket.ReceiveLength <> 0 then
   begin
    //soso send.. i:=i+1 mod 64;
    //so so revice..//get from client..
    Socket.ReceiveBuf(size,2);
    //Socket.ReceiveBuf(typ,1);
    socket.ReceiveBuf(chars,size-2);
    //decode stuff..
    for i := 0 to size-2 do
    begin
     packet.chars[i]:=decode.text(chars[i],enc)[1];
    end;
    //increse enc..
    enc:=(enc+1) mod 64;
    //make packet..
    packet.size:=size;
    //send..
    client.socket.SendBuf(packet,packet.size); //see ya :P
   end;
  except
   client.Socket.Close;
   socket.close;
   terminate;
   exit;
  end;
  if ye=0 then sleep(mwait);
end;

procedure ttest.Execute;
begin
 //MessageDlg('Execute', mtInformation, [mbOk], 0);
 if error then terminate;
 if error then exit;
 try
 repeat
  //application.ProcessMessages;
 until (client.Socket.Connected) or (error);
 except
  error:=true;
 end;
 try
 repeat
   CheckData; // checkdata..
 until (not client.Socket.Connected) or (error) or (terminated); //end when dc..
 //so close..
 except
  client.Socket.Close;
  socket.close;
  terminate;
  exit;
 end;
 try
  client.Socket.Close;
  client.socket.free;
 except
  socket.Close;
  terminate;
  exit;
 end;
 try
  socket.Close;
 except
  client.Socket.Close;
  terminate;
  exit;
 end;
 //close thread.. but how Oo
 Free;
end;

procedure ttest.DOStuff(msocket:tcustomwinsocket;host:string;port,wait:integer);
begin
 error:=false;
 client:=tclientsocket.Create(nil);
 client.OnError:=OnError;
 //set connection
 client.Host:=host;
 client.Port:=port;
 client.Open;
 socket:=msocket;
 socket.OnErrorEvent:=OnError;
 mwait:=wait;
end;

procedure Ttest.OnError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
 //yeah errorhandling
 Errorcode:=0;
 error:=true;
 //clsoe procedure..
 try
   socket.Close;
 except
 end;
 try
  client.Socket.Close;
 except
 end;
 try
  terminate;
 except
 end;
end;

constructor Ttest.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  Priority := tpLower;
  //creaate a connection..
  dec:=0;
  enc:=0;
end;


end.

