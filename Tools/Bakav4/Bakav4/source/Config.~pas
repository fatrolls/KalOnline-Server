unit Config;
{$APPTYPE CONSOLE}

interface

uses
  Types, ScktComp, ExtCtrls, Controls, StdCtrls, Classes, Grids, ValEdit, Windows, Messages, SysUtils, Variants, Graphics,  Forms,
  Dialogs,   DataCheck,user, npc,map,mob,CpuUsage,exp,item;

type
  TForm1 = class(TForm)
    ValueListEditor1: TValueListEditor;
    ServerSocket1: TServerSocket;
    checkdata: TTimer;
    newplayers: TListBox;
    awayplayer: TListBox;
    radomemytimer: TTimer;
    ClientSocket1: TClientSocket;
    procedure FormCreate(Sender: TObject);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure checkdataTimer(Sender: TObject);
    procedure ServerSocket1ClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure radomemytimerTimer(Sender: TObject);
    procedure ServerSocket1ThreadStart(Sender: TObject;
      Thread: TServerClientThread);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    procedure AppException(Sender: TObject; E: Exception);
  public
    { Public declarations }
    gamepath,dbpath,packetpath:string;
  end;

var
  Form1: TForm1;
  slag,lag,cpu:Extended;
  lastnotic:int64=0;
  lastmobcheck:int64=0;

implementation

var
 CpuUsage1: TCpuUsage;

{$R *.dfm}

procedure Tform1.AppException(Sender: TObject; E: Exception);
var
 serror:tstringlist;
begin
 writeln('['+e.message+']');
 try
  serror:=tstringlist.Create;
  serror.LoadFromFile('error.txt');
 except
 end;
  serror.Add(e.message);
  serror.SaveToFile('error.txt');
  serror.Free;
 //if not checkdata.Enabled then checkdata.Enabled:=true;
end;

procedure TLine;
begin
 writeln('-------------------------------------------------------------------------------');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 CpuUsage1 := TCpuUsage.Create;
 application.OnException:=AppException;
{$APPTYPE CONSOLE}
 application.ShowMainForm:=false;
 writeln('KalServer4 by BakaBug');
 TLine;
 writeln('Loading Configs..');
 ValuelistEditor1.Strings.LoadFromFile('server.ini');
 Tline;
 gamepath:=extractfilepath(application.ExeName)+valuelisteditor1.Values['Config'];
 dbpath:=extractfilepath(application.ExeName)+valuelisteditor1.Values['DataBase'];
 packetpath:=extractfilepath(application.ExeName)+valuelisteditor1.Values['Packets'];
 writeln('GameConfigs: '+#13#10+'  '+gamepath);
 writeln('DataBase: '+#13#10+'  '+dbpath);
 tline;
 writeln('Load Npc''s ...'+#13#10+' '+gamepath+'npc.db');
 npc.LoadNpc(gamepath+'npc.db');
 writeln('Load Mob''s ...'+#13#10+' '+gamepath+'mob.db');
 mob.Loadmobs(gamepath+'mobarea.db',gamepath+'mob.db');
 writeln('Load EXP ...'+#13#10+' '+gamepath+'exp.db');
 exp.LoadExp(gamepath+'exp.db');
 Tline;
 writeln('Load Drops ...');
 item.StartSystem;
 Tline;
 ServerSocket1.Port:=strtoint(valuelisteditor1.Values['Port']);
 writeln('ServerPort: '+#13#10+'  '+valuelisteditor1.Values['Port']);
 writeln('MaxLag: '+#13#10+'  '+'<none>');
 Tline;
 writeln('Starting Server...');
 serversocket1.Open;
 clientsocket1.Open;
 user.StartSystem;
 writeln('Server is ready now !');
 checkdata.Enabled:=true;
end;

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 newplayers.Items.Add(inttostr(socket.Handle));
 writeln('"'+socket.RemoteHost+'" connected..');
 if socket.RemoteHost <> 'localhost' then socket.Close;
end;

procedure TForm1.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
if awayplayer.Items.IndexOf(inttostr(socket.Handle)) = -1 then
 awayplayer.Items.Add(inttostr(socket.Handle));
 writeln('"'+socket.RemoteHost+'" disconnected..');
 //SaveUser(socket);
end;

procedure TForm1.checkdataTimer(Sender: TObject);
var
 con,i:integer;
 hm:tcustomwinsocket;
 startime:integer;
 notic,te:string;
begin
 Application.ProcessMessages;
if (ServerSocket1.Socket.ActiveConnections = 0) and (awayplayer.Count=0) and (newplayers.Count=0) then exit;
 checkdata.Enabled:=false;
 //setnotic
 notic:=' '+#13#10+' '+#13#10+' '+#13#10+' '+#13#10;
 notic:=notic+'KalServer4 [UW] by BakaBug'+#13#10;
 notic:=notic+'Online: '+inttostr(serversocket1.Socket.ActiveConnections)+#13#10;
 //cpu:=((cpu*50+round(CpuUsage1.CpuUsage['KalServer.bin'+#0])) / 51);
 //cpu:=round(CpuUsage1.CpuUsage['KalServer'+#0]);
 //writeln(floattostr(CpuUsage1.CpuUsage['KalServer'+#0]));
 notic:=notic+'Active Mob''s: '+inttostr(HowMuch)+#13#10;
 slag:=lag;
 if slag < 0.0001 then slag:=0.0001;
 notic:=notic+'Lag: '+FloatToStrF(slag,ffGeneral,3,3)+' ms'+#0;
 te:=notic;
 notic:=#1#0#15+notic;
 notic[1]:=chr(length(notic));
 //set lag-counter
 startime:=gettickcount;
 //add all new..
 if newplayers.Items.Count > 0 then
  for i:= 0 to newplayers.Items.Count-1 do
  begin
   for con := 0 to serversocket1.Socket.ActiveConnections-1 do
    if serversocket1.Socket.Connections[con].Handle = strtoint(newplayers.Items.Strings[0]) then
    begin
     hm:=serversocket1.Socket.Connections[con];
     User.NewOnline(hm);
     writeln('Made new Node..')
    end;
    Newplayers.Items.Delete(0);
  end;
 //so check stuff now..
if ServerSocket1.Socket.ActiveConnections > 0 then
 for con := 0 to ServerSocket1.Socket.ActiveConnections-1 do
 begin
 Application.ProcessMessages;
 try
  if serversocket1.Socket.Connections[con].ReceiveLength > 0 then DataCheck.CheckData(serversocket1.Socket.Connections[con]);
  //check new stets or somethink like this..
  //send info
  if lastnotic+2000 < gettickcount then
  begin
   //send notic :D
   user.SendNotic(serversocket1.Socket.Connections[con],notic);
   //check sitorrun ;D
   user.CheckSitRun;
  end;
 except
  Application.ProcessMessages;
 end;
 end;
  //check mob's movements..
 if lastmobcheck+200 < gettickcount then
 begin
  mob.CheckAll;
  lastmobcheck:=lastmobcheck+200;
  if lastmobcheck=200 then lastmobcheck:=gettickcount;
  //send the notic to login-server
 end;
 //delte all old

 if awayplayer.Items.Count > 0 then
  for i:= 0 to awayplayer.Items.Count-1 do
  begin
    writeln('Save: '+awayplayer.Items.Strings[0]);
    User.SaveUser(strtoint(awayplayer.Items.Strings[0]));
    awayplayer.Items.Delete(0);
  end;

 //calculate lag over 50 checks..
 lag:=((lag*50+(gettickcount-startime))/51);   //so my lag-calculator :P whaha
 //lag:=gettickcount-startime;
 if lastnotic = 0 then lastnotic:=gettickcount;
 if lastnotic+2000 < gettickcount then
 begin
  lastnotic:=lastnotic+2000;
  clientsocket1.Socket.SendText(te);
 end;
 checkdata.Enabled:=true;
end;

procedure TForm1.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
 ErrorCode:=0;
 socket.Close; //only for testing :P
end;

procedure TForm1.radomemytimerTimer(Sender: TObject);
begin
 randomize;
end;

procedure TForm1.ServerSocket1ThreadStart(Sender: TObject;
  Thread: TServerClientThread);
begin
 //Thread.
// newplayers.Items.Add(inttostr(socket.Handle));
// writeln('"'+socket.RemoteHost+'" connected..');
end;

procedure TForm1.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
 errorcode:=0;
 // MessageDlg('Server want close becosue SocketError', mtInformation,   [mbOk], 0);
 close;
end;

procedure TForm1.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//  MessageDlg('Server want close becosue LOGIN-SERVER is offline', mtInformation,   [mbOk], 0);
 close;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
// if clientsocket1.Active then canclose:=false;
end;

end.
