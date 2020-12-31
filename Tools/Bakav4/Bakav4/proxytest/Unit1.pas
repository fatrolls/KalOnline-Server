unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScktComp,unit2, StdCtrls, ExtCtrls, ComCtrls,encode,decode,
  Menus;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    ListBox1: TListBox;
    ServerSocket2: TServerSocket;
    GroupBox2: TGroupBox;
    TrackBar1: TTrackBar;
    ServerSocket1: TServerSocket;
    GroupBox3: TGroupBox;
    Memo1: TMemo;
    MainMenu1: TMainMenu;
    Server1: TMenuItem;
    Restart1: TMenuItem;
    Shutdown1: TMenuItem;
    User1: TMenuItem;
    New1: TMenuItem;
    state: TServerSocket;
    reg: TServerSocket;
    ListBox2: TListBox;
    Timer2: TTimer;
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket2ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormShow(Sender: TObject);
    procedure ServerSocket2ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket2ClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure FormCreate(Sender: TObject);
    procedure AppException(Sender: TObject; E: Exception);
    procedure ServerSocket2ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Shutdown1Click(Sender: TObject);
    procedure Restart1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure stateClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure stateClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure regClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure regClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure regClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations... .. }
  public
    { Public declarations... ... }
  end;

var
  Form1: TForm1;
  activ:integer;
  shut:boolean=false;
  rest:boolean=false;

implementation

uses Unit3;

{$R *.dfm}

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var hm:ttest;
begin
 hm:=ttest.create(true);
 activ:=activ+1;
 hm.FreeOnTerminate:=true;
 hm.DOStuff(socket,'localhost',30001,trackbar1.Position);
 hm.Resume;
end;

procedure TForm1.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
 errorcode:=0;
 socket.Close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 form1.caption:='Connected Player''s:'+inttostr(activ)+'  Thread''ed PROXY for KalServer4 by BakaBug';
end;

procedure TForm1.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  activ:=serversocket1.Socket.ActiveConnections;
  if serversocket1.Socket.ActiveConnections = 0 then
  begin
   if shut then
   begin
    sleep(5000); //give servertime to save stuff -.-
    close;
   end;
   if rest then
   begin
    //sleep before
    sleep(5000); //yeah give him time to save stuff..
    serversocket2.Socket.Connections[0].Close; //to restart :P
    rest:=false;
    serversocket1.Open; //to start login-server again .. 
   end;
  end;
end;

procedure TForm1.ServerSocket2ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
if (socket.RemoteHost <> 'localhost') or (serversocket2.Socket.ActiveConnections > 1) then
begin
 socket.Close;
 exit;
end;
 Listbox1.Items.Add('KS4 [UW] started..');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 windows.WinExec('KalServer.bin',SW_shownormal)
end;

procedure TForm1.ServerSocket2ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 Listbox1.Items.Add('KS4 [UW] closed.. restart..');
 if application.ExeName <> 'Project1.exe' then windows.WinExec('KalServer.bin',SW_shownormal);
end;

procedure TForm1.ServerSocket2ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
 errorcode:=0;
 socket.close;
end;

procedure TForm1.AppException(Sender: TObject; E: Exception);
begin
 //do nothing shiot buggy think..
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  encode.LoadTable('encodetable.tamago');
  decode.LoadTable('decodetable.tamago');
  application.OnException:=AppException;
end;

procedure TForm1.ServerSocket2ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  memo1.Text:=socket.ReceiveText;
  memo1.Lines.Delete(0);
  memo1.Lines.Delete(0);
  memo1.Lines.Delete(0);
  memo1.Lines.Delete(0);
end;

procedure TForm1.Shutdown1Click(Sender: TObject);
begin
 listbox1.Items.Add('Please wait 5sek .. shutdown');
 listbox1.Repaint;
 shut:=true;
 serversocket1.Close;
 serversocket1.OnClientDisconnect(sender,serversocket1.Socket);
end;

procedure TForm1.Restart1Click(Sender: TObject);
begin
 listbox1.Items.Add('Please wait 5sek .. restart');
 listbox1.Repaint;
 rest:=true;
 serversocket1.Close;
 serversocket1.OnClientDisconnect(sender,serversocket1.Socket);
end;

procedure TForm1.New1Click(Sender: TObject);
begin
 form2.show;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 if not shut then canclose:=false;
 if canclose=false then Shutdown1.Click;
end;

procedure TForm1.stateClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 socket.SendText(inttostr(serversocket1.Socket.ActiveConnections));
 socket.Close;
end;

procedure TForm1.stateClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
 errorcode:=0;
end;

procedure TForm1.regClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
 errorcode:=0;
end;

procedure TForm1.regClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
 t:tstringlist;
 e:tstringlist;
 con:boolean;
 i:integer;
begin
 //add to bann
 listbox2.Items.Add(socket.RemoteAddress);
 e:=tstringlist.Create;
 e.Text:=socket.ReceiveText;
 if e.Count < 2 then
 begin
  socket.Close;
  exit;
 end;
 if length(e.Strings[0]) < 4 then
 begin
  //show message
  socket.SendText('Username must be min. 4 letters long..');
  socket.Close;
  exit;
 end;
 if length(e.Strings[1]) < 4 then
 begin
  //show message
  socket.SendText('Passwort must be min. 4 letters long..');
  socket.Close;
  exit;
 end;
 //check if now confused letters..
 con:=false;
 if length(e.Text) > 30 then
 begin
  socket.SendText('Wtf are you trying your acc/pass is more than to long..');
  socket.Close;
  exit;
 end;
 for i := 1 to length(e.strings[0]) do
 begin
  //open check..
  case ord(e.strings[0][i]) of
   0..ord('A')-1: con:=true;
   ord('Z')+1..ord('a')-1: con:=true;
   ord('z')+1..255: con:=true;
  end;
 end;
 for i := 1 to length(e.strings[1]) do
 begin
  //open check..
  case ord(e.strings[1][i]) of
   0..ord('A')-1: con:=true;
   ord('Z')+1..ord('a')-1: con:=true;
   ord('z')+1..255: con:=true;
  end;
 end;
 if con then
 begin
  socket.SendText('Wrong letters in Username or Password... [Possible: A->Z a->z]');
  socket.Close;
  exit;
 end;
 if FileExists('DataBase\'+e.Strings[0]+'.acc') then
 begin
  //show message
  socket.SendText('Someone already use this account..');
  socket.Close;
  exit;
 end;
 t:=tstringlist.Create;
 t.Clear;
 t.Add(e.Strings[0]);
 t.add(e.Strings[1]);
 t.SaveToFile('DataBase\'+e.Strings[0]+'.acc');
 t.Clear;
 t.Free;
 e.Free;
 socket.SendText('You can login now ;)');
 socket.Close;
end;

procedure TForm1.regClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 if listbox2.Items.IndexOf(socket.RemoteAddress) > -1 then socket.Close;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
 reg.Close;
 listbox2.Clear;
 //start
 reg.Open;
end;

end.
