unit User;
{$APPTYPE CONSOLE}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, ScktComp,header,map,mob,exp,Math,item;

var MainNode, CurrNode, PrevNode: POnline;
    fortest:integer=0;
    skilltest:integeR=0;
    chara:tstringlist;
    online:tstringlist;

procedure Login(socket:tcustomwinsocket;data:array of char;msize:integer);
procedure NewChar(socket:tcustomwinsocket;data: array of char;msize:integer);
procedure NewOnline(socket:tcustomwinsocket);
procedure LoadToMap(socket:tcustomwinsocket);
procedure SaveUser(socket:integer);
procedure DelChar(socket:tcustomwinsocket);
procedure CharChangePosition(x,y,z:shortint;start:boolean);
procedure SetActivePlayer(socket:tcustomwinsocket);
function  GetName:Ponline;
procedure SendNotic(socket:Tcustomwinsocket;notic:string);
procedure Attack(target:dword);
procedure Revive;
procedure CheckSitRun;
procedure GivePoints(too:byte);
function AllReadyHere(charname:string):boolean;
function AllReadyOnline(username:string):boolean;
procedure StartSystem;

implementation

function AllReadyOnline(username:string):boolean;
begin
 result:=true;
 if online.IndexOf(username) = -1 then result:=false;
end;

function AllReadyHere(charname:string):boolean;
begin
 result:=true;
 if chara.IndexOf(charname) = -1 then result:=false;
end;

procedure StartSystem;
begin
 chara:=tstringlist.Create;
 online:=tstringlist.Create;
 chara.LoadFromFile('DataBase/charnames.db');
end;

function GetName:POnline;
begin
 result:=active;
end;

function GetNodeByPOnline(Handle: POnline): POnline;
begin
 Result := MainNode;
 while Result <> nil do
  begin
    if Result^.userfile.chars.CharId = Handle.userfile.chars.CharId then Break;
    Result := Result^.Next;
  end;
end;

function GetNodeBySocketHandle(Handle: integer): POnline;
begin
 Result := MainNode;
 while Result <> nil do
  begin
    if Result^.sockethandle = Handle then Break;
    Result := Result^.Next;
  end;
end;

procedure DeleteNode(Node: POnline);
var
 Prev: POnline;
begin
if node=nil then exit;
  Prev := MainNode;
  if Node = MainNode then
    MainNode := Node^.Next
  else while Prev <> nil do
  begin
   if Prev^.Next = Node then
    begin
      Prev^.Next := Node^.Next;
      Break;
    end;
    Prev := Prev^.Next;
  end;
  Dispose(Node);
end;

procedure SendNotic(socket:Tcustomwinsocket;notic:string);
begin
 //check if on map
 if GetNodebySocketHandle(socket.Handle)^.OnMap then socket.SendText(notic);
end;

procedure NewOnline(socket:TCustomwinsocket);
begin
//add new player..
 New(CurrNode);
 CurrNode^.Next := MainNode;
 MainNode := CurrNode;
 CurrNode^.socket:=socket;
 CurrNode^.sockethandle:=socket.Handle;
 CurrNode^.OnMap:=false;
 CurrNode^.sit:=false;
 CurrNode^.walk:=false;
 CurrNode^.run:=false;
 CurrNode^.userfile.username:=''; //nothing -.-
end;

procedure SetActivePlayer(socket:tcustomwinsocket);
begin
 active:=GetNodebySocketHandle(socket.Handle);
end;

procedure CharChangePosition(x,y,z:shortint;start:boolean);
var
 xx,yy,zz:string[4];
 s,i:integer;
 movepacket:tmove;
begin
 active^.userfile.chars.CharX:=active.userfile.chars.CharX+x;
 active^.userfile.chars.CharY:=active.userfile.chars.CharY+y;
 active^.userfile.chars.CharZ:=active.userfile.chars.CharZ+z;
 //so update dword..
 s:=length(active.userfile.chars.CharName);
 xx:=dwordtostring(active.userfile.chars.CharX);
 yy:=dwordtostring(active.userfile.chars.CharY);
 zz:=dwordtostring(active.userfile.chars.CharZ);
 //so so..
 for i := 1 to 4 do active^.userfile.chars.ShowPlayerPacket[3+4+s+1+i]:=xx[i];
 for i := 1 to 4 do active^.userfile.chars.ShowPlayerPacket[3+4+4+s+1+i]:=yy[i];
 for i := 1 to 4 do active^.userfile.chars.ShowPlayerPacket[3+4+4+4+s+1+i]:=zz[i];
 //update look_x,look_y :D
 active^.userfile.chars.ShowPlayerPacket[3+4+4+4+s+1+4+1]:=char(x);
 active^.userfile.chars.ShowPlayerPacket[3+4+4+4+s+1+4+2]:=char(y);
 //update area :P
 //send to all i near that i move..
 movepacket.size:=sizeof(movepacket);
 if     start then
 begin
  active^.walk:=true;
  movepacket.typ:=34;
 end;
 if not start then
 begin
  active^.walk:=false;
  movepacket.typ:=35;
 end;
 movepacket.id:=active.socket.Handle;
 movepacket.x:=x;
 movepacket.y:=y;
 movepacket.z:=z;
 map.SendMove(MovePacket,active,nil,x,y); //player move so mob=nil :P *grins*
 //later first get area..
end;

procedure Send17CharPacket(socket:tcustomwinsocket);
var
 tmp:string;
 pl:POnline;
begin
 pl:=active;
 tmp:=#17#0#0#0#0#0#1+dwordtostring(socket.Handle+1)+pl.userfile.chars.CharName+chr(pl.userfile.chars.CharClass)+chr(pl.userfile.chars.CharLvl)+pl.userfile.chars.UNKNOWE+chr(pl.userfile.chars.CharSte)+chr(pl.userfile.chars.CharHlt)+chr(pl.userfile.chars.CharInt)+chr(pl.userfile.chars.CharWis)+chr(pl.userfile.chars.CharAgi)+chr(pl.userfile.chars.CharFace)+chr(pl.userfile.chars.CharHair)+#0;
 socket.sendtext(chr(length(tmp)+2)+#0+tmp);
end;

procedure SaveUser(socket:integer);
var
 fil:file;
 userinfo:ponline;
begin
  //save user..
  try
  writeln('LoadNode..');
  userinfo:=GetNodebySocketHandle(socket);
  //make offline..
  if AllReadyOnline(userinfo^.userfile.username) then
   writeln(inttostr(socket)+'='+userinfo^.userfile.username+' Online:YES')
  else
   writeln(inttostr(socket)+'='+userinfo^.userfile.username+' Online:NO');
  if AllReadyOnline(userinfo^.userfile.username) then online.Delete(online.IndexOf(userinfo^.userfile.username));
  if userinfo^.userfile.username <> '' then
  begin
   assign(fil,'DataBase/'+userinfo^.userfile.username+'.acc');
   rewrite(fil,1);
   blockwrite(fil,userinfo^.userfile,sizeof(userinfo^.userfile));
   closefile(fil);
   //delte him to be online..
  end;
  except end;

  try
  if userinfo.OnMap then Map.DeletePlayer(userinfo);
  except end;

  DeleteNode(userinfo);
  writeln('DelteNode..');
end;

procedure Login(socket:tcustomwinsocket;data:array of char;msize:integer);
var
 i:integer;
 username:string;
 password:string;
 a:byte;
 userinfo:tuserfile;
 fil:file;
 new:tstringlist;
begin
 if not FileExists('DataBase/BakaBug.acc') then
 begin
 //save test user..
  userinfo.username:='BakaBug';
  userinfo.password:='Bazzuker';
  userinfo.gm:=true;
  userinfo.HowMuchChars:=0;
  assign(fil,'DataBase/BakaBug.acc');
  rewrite(fil,1);
  blockwrite(fil,userinfo,sizeof(userinfo));
  closefile(fil);
 end;
//start check..
 active^.userfile.username:='';
 a:=0;
 username:='';
 password:='';
 for i := 0 to msize do
 begin
  if data[i] <> #0 then
  begin
   if a=0 then username:=username+data[i];
   if a=1 then password:=password+data[i];
  end
  else
  begin
   a:=a+1;
  end;
 end;
 //check if already here.. :P
 if AllReadyOnline(username) then
 begin
  //already loged in !!
  socket.Close; //dc him..
  exit; //exit procedure..
 end;
 //so check if user is here..
 if not FileExists('DataBase/'+username+'.acc') then
 begin
  //send that user not found..
  socket.SendText(#4#0#43#2);
  exit;
 end;
 //so load userInfo when here..
 assign(fil,'DataBase/'+username+'.acc');
 reset(fil,1);
 if filesize(fil) < sizeof(userinfo) then
 begin
  //new user :P
  closefile(fil); //clsoe files
  new:=tstringlist.Create;      //opne to read username and pass..
  new.LoadFromFile('DataBase/'+username+'.acc');
  userinfo.username:=new.Strings[0];
  userinfo.password:=new.Strings[1];
  userinfo.gm:=false;
  userinfo.HowMuchChars:=0;
  assign(fil,'DataBase/'+userinfo.username+'.acc');
  rewrite(fil,1);
  blockwrite(fil,userinfo,sizeof(userinfo));
  closefile(fil);
  //so open again to read infos :P
  assign(fil,'DataBase/'+username+'.acc');
  reset(fil,1);          //finish user made :P
 end;
 blockread(fil,userinfo,sizeof(userinfo));
 closefile(fil);
 //so check password..
 if password <> userinfo.password then
 begin
  //send that false password
  socket.SendText(#4#0#43#3);
  exit;
 end;
 active^.userfile:=userinfo;
 //set him online..
 online.Add(username);
 active^.userfile.username:=username;
 //so check chars..
 if userinfo.HowMuchChars = 0 then
 begin
  //no chars..
  socket.SendText(#9#0#17#0#0#0#0#0#0);
  socket.SendText(#4#0#25#0);
  exit;
 end;
 //load char
 Send17CharPacket(socket);
 socket.SendText(#4#0#25#0);
end;

procedure NewChar(socket:tcustomwinsocket;data:array of char;msize:integer);
var
 pl:POnline;
 i:integer;
begin
 //make new char..
 pl:=active;
 //so..
 if pl.userfile.HowMuchChars=1 then exit;

 pl.userfile.chars.CharName:=''; //whaha forgoten -.-
 i:=-1;
 repeat
  i:=i+1;
  pl.userfile.chars.CharName:=pl.userfile.chars.CharName+data[i];
 until data[i]=#0;
 if AllReadyHere(pl.userfile.chars.CharName) then exit;
 chara.Add(pl.userfile.chars.CharName);
 chara.SaveToFile('DataBase/charnames.db');
 //writeln(pl.userfile.chars.CharName);
 pl.userfile.chars.CharLvl:=1;
 pl.userfile.chars.CharClass:=ord(ord(data[i+1]));
 pl.userfile.chars.CharSte:=ord(data[i+2]);
 pl.userfile.chars.CharHlt:=ord(data[i+3]);
 pl.userfile.chars.CharInt:=ord(data[i+4]);
 pl.userfile.chars.CharWis:=ord(data[i+5]);
 pl.userfile.chars.CharAgi:=ord(data[i+6]);
 pl.userfile.chars.CharFace:=ord(data[i+7]);
 pl.userfile.chars.CharHair:=ord(data[i+8]);
 pl.userfile.chars.CharX:=257284;
 pl.userfile.chars.CharY:=258364;
 pl.userfile.chars.CharZ:=16150;
 pl.userfile.chars.ReviveX:=257284;
 pl.userfile.chars.ReviveY:=258364;
 pl.userfile.chars.ReviveZ:=16150;
 if pl.userfile.chars.CharSte+pl.userfile.chars.CharHlt+pl.userfile.chars.CharInt+pl.userfile.chars.CharWis+pl.userfile.chars.CharAgi <> 5 then exit;
 if  pl.userfile.chars.CharClass = 2 then //archer
 begin
  pl.userfile.chars.CharSte:=pl.userfile.chars.CharSte+14;
  pl.userfile.chars.CharHlt:=pl.userfile.chars.CharHlt+10;
  pl.userfile.chars.CharInt:=pl.userfile.chars.CharInt+8;
  pl.userfile.chars.CharWis:=pl.userfile.chars.CharWis+10;
  pl.userfile.chars.CharAgi:=pl.userfile.chars.CharAgi+18;
 end;
 if  pl.userfile.chars.CharClass = 1 then //mage
 begin
  pl.userfile.chars.CharSte:=pl.userfile.chars.CharSte+8;
  pl.userfile.chars.CharHlt:=pl.userfile.chars.CharHlt+10;
  pl.userfile.chars.CharInt:=pl.userfile.chars.CharInt+18;
  pl.userfile.chars.CharWis:=pl.userfile.chars.CharWis+16;
  pl.userfile.chars.CharAgi:=pl.userfile.chars.CharAgi+8;
 end;
 if  pl.userfile.chars.CharClass = 0 then //knight
 begin
  pl.userfile.chars.CharSte:=pl.userfile.chars.CharSte+18;
  pl.userfile.chars.CharHlt:=pl.userfile.chars.CharHlt+16;
  pl.userfile.chars.CharInt:=pl.userfile.chars.CharInt+8;
  pl.userfile.chars.CharWis:=pl.userfile.chars.CharWis+8;
  pl.userfile.chars.CharAgi:=pl.userfile.chars.CharAgi+10;
 end;
 pl.userfile.HowMuchChars:= 1;
 pl.userfile.chars.CharEXP:=0;
 pl.userfile.chars.AddEXP:=0;
 pl.userfile.chars.dead:=false;
 pl.userfile.chars.CharLvl:=1;
 pl.userfile.chars.CharId:= 1;
 pl.userfile.chars.CharHP:= 65535;
 pl.userfile.chars.CharMP:= 65535;
 pl.userfile.chars.statepoints:=0;
 pl.userfile.chars.skillpoints:=0;
 for i := 0 to 100 do
 begin
  pl.userfile.chars.Inventory[i].IsHere:=false;
 end;
 Send17CharPacket(socket);
 socket.SendText(#4#0#25#0);
end;


procedure DelChar(socket:tcustomwinsocket);
var
 pl:ponline;
begin
 pl:=active;
 pl.userfile.HowMuchChars:= 0;
 if AllReadyHere(pl.userfile.chars.CharName) then
 begin
  chara.Delete(chara.IndexOf(pl.userfile.chars.CharName));
  chara.SaveToFile('DataBase/charnames.db');
 end;
 socket.SendText(#9#0#17#0#0#0#0#0#0);
 socket.SendText(#4#0#25#0);
end;

procedure LoadToMap(socket:tcustomwinsocket);
var
 camera:TChangeCamera;
 onliner:ponline;
 mypacket:string;
 g:string;
begin
 if active^.OnMap = true then exit;
 socket.SendText(#4#0#4#0);    //clear inventory
 //load invnetory..
 item.LoadInventory(active);
 //load states
 //lvl:
 {//Send lvl up
  sendcommand(socket,69,#$1a+chr(getLvl(socket)));}
 AllZero;
 //load exp :P and set lvl for next lvl :D
 active^.userfile.chars.NeedExp:=GetExp(active^.userfile.chars.CharLvl);
 g:=#1#0#69#$19+dwordtostring(active^.userfile.chars.CharEXP)+#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0;
 g[1]:=chr(length(g));
 active^.socket.SendText(g);
 //loadskils
 //load camera..
 onliner:=active;
 camera.size:=sizeof(camera);
 camera.typ:=27;
 camera.map:=0;
 camera.x:=257284;
 camera.y:=258364;
 socket.SendBuf(camera,camera.size);  //set camera
 //load char..
 if onliner.userfile.chars.Charname[length( onliner.userfile.chars.Charname)] <> #0 then onliner.userfile.chars.Charname:=onliner.userfile.chars.Charname+#0;
 mypacket:=dwordtostring(socket.Handle)+onliner.userfile.chars.CharName+chr(onliner.userfile.chars.CharClass+$80)+dwordtostring(onliner.userfile.chars.CharX)+dwordtostring(onliner.userfile.chars.CharY)+dwordtostring(onliner.userfile.chars.CharZ)+#0#0;
 if active.userfile.chars.dead then
  mypacket:=mypacket+#2#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0
 else
  mypacket:=mypacket+#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0;
 mypacket:=#1#0#50+mypacket;                                                                                                                                                                            // [look_x][look_y][is..][assassin][unknow][elemtar weapon]
 mypacket[1]:=chr(length(mypacket));                                                                                                                                                                //is : 2=3=6=7=dead 4=5=sit
 socket.SendText(#19#0#7#1#1#1#1#1#0#1#1#1#1#1#1#1#1#1#1);
 socket.SendText(mypacket);  //send char..
 //send that i am on map
 mypacket:=dwordtostring(socket.Handle)+onliner.userfile.chars.CharName+chr(onliner.userfile.chars.CharClass+$00)+dwordtostring(onliner.userfile.chars.CharX)+dwordtostring(onliner.userfile.chars.CharY)+dwordtostring(onliner.userfile.chars.CharZ)+#0#0;
 if active.userfile.chars.dead then
  mypacket:=mypacket+#2#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0
 else
  mypacket:=mypacket+#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0; //#0+'R'+#0+'G'+#0;
 mypacket:=#1#0#50+mypacket;
 mypacket[1]:=chr(length(mypacket));
 writeln(inttostr(length(mypacket)));
// socket.SendText(mypacket);
 onliner.userfile.chars.ShowPlayerPacket:=mypacket;
 onliner.userfile.chars.CharId:=socket.Handle;
 map.AddPlayer(onliner);
 active^.OnMap:=true;
end;

procedure Attack(target:dword);
var
 mypacket:tnormalattack;
begin
 mypacket.size:=sizeof(mypacket);
 mypacket.typ:=62;
 mypacket.attacker:=active^.socket.Handle;
 mypacket.opfer:=target;
 mypacket.dmg:=RandomRange(active^.nattack_min,active^.nattack_max);
 //writeln(inttostr(mypacket.dmg));
 mypacket.exblow:=0;
 mypacket.somethink:=1;
 //active^.socket.SendBuf(mypacket,mypacket.size);
 mob.MobGetDMG(target,active,mypacket); //so so..
end;

procedure Revive;
var teleport:Tteleport;
begin
 active.userfile.chars.dead:=false;
 active.userfile.chars.CharEXP:=active.userfile.chars.CharEXP-(active.userfile.chars.CharEXP div 5);
 teleport.size:=sizeof(teleport);
 teleport.typ:=70;
 teleport.somethink:=0;
 teleport.x:=active.userfile.chars.reviveX;
 teleport.y:=active.userfile.chars.reviveY;
 teleport.z:=active.userfile.chars.reviveZ;
 Map.SendTeleport(active,teleport);
 active.userfile.chars.CharHP:=active.userfile.chars.CharMaxHP;
 active.userfile.chars.CharMP:=active.userfile.chars.CharMaxMP;
 AllZero;
end;

procedure CheckSitRun;
var pa:TsetPoints;
    before:integer;
begin
 //soso check the sit..
 if active^.sit then
 begin
  //add some hp :P
  before:=active^.userfile.chars.CharHP+active^.userfile.chars.CharMP;
  active^.userfile.chars.CharHP:=active^.userfile.chars.CharHP+10;
  active^.userfile.chars.CharMP:=active^.userfile.chars.CharMP+10;
  if active^.userfile.chars.CharHP>active^.userfile.chars.CharMaxHP then
   active^.userfile.chars.CharHP:=active^.userfile.chars.CharMaxHP;
  if active^.userfile.chars.CharMP>active^.userfile.chars.CharMaxMP then
   active^.userfile.chars.CharMP:=active^.userfile.chars.CharMaxMP;
  //soso send it..
  if before <> active^.userfile.chars.CharHP+active^.userfile.chars.CharMP then
  begin
   pa.size:=sizeof(pa);
   pa.typ:=69;
   pa.what:=5;
   pa.howmuch:=active^.userfile.chars.CharHP;
   pa.full:=active^.userfile.chars.CharMaxHP;
   active^.socket.SendBuf(pa,pa.size); //send hp
   pa.what:=6; //maybe mp..
   pa.howmuch:=active^.userfile.chars.CharMP;
   pa.full:=active^.userfile.chars.CharMaxMP;
   active^.socket.SendBuf(pa,pa.size); //send mp
  end;
 end;
 if active^.run then
 begin
  //there is more needen to check.. bt run still doesn't work so.. :F
  active^.userfile.chars.CharMP:=active^.userfile.chars.CharMP-2;
  pa.size:=sizeof(pa);
  pa.typ:=69;
  pa.what:=6;
  pa.howmuch:=active^.userfile.chars.CharMP;
  pa.full:=active^.userfile.chars.CharMaxMP;
  active^.socket.SendBuf(pa,pa.size);
 end;
end;

procedure GivePoints(too:byte);
begin
if active^.userfile.chars.StatePoints=0 then exit;
 case too of
  0:active^.userfile.chars.CharSte:=active^.userfile.chars.CharSte+1;
  1:active^.userfile.chars.CharHlt:=active^.userfile.chars.CharHlt+1;
  2:active^.userfile.chars.CharInt:=active^.userfile.chars.CharInt+1;
  3:active^.userfile.chars.CharWis:=active^.userfile.chars.CharWis+1;
  4:active^.userfile.chars.CharAgi:=active^.userfile.chars.CharAgi+1;
 else
  exit;
 end;
 active^.userfile.chars.StatePoints:=active^.userfile.chars.StatePoints-1;
 AllZero;
end;

end.
