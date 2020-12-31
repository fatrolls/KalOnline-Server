unit mob;

interface

uses Types,header,map,windows,SysUtils,exp,item;

type
 myrecordd=record
  level:word;
  exp:int64;
  min_attack:dword;
  max_attack:dword;
  ai:byte;
  itemgroup1:word;
  itemgroup2:word;
  mspeed:word;
  aspeed:word;
  range:word; //sicher ist sicher.. -.-
  hp:word;
 end;

var lastnode,MainNode, CurrNode, PrevNode: Pmob;
    last,somuch:integer;
    mobinfo:array[0..400] of myrecordd;

procedure LoadMobs(filename,mobb:string);
procedure CheckAll;
procedure MobGetDMG(mob:dword;whoattack:Ponline;attackpacket:tnormalattack);
function HowMuch:integer;

implementation

function HowMuch:Integer;
begin
 result:=somuch;
end;

function GetNodeByMob(mo: tmobpacket): Pmob;
begin
 Result := MainNode;
 while Result <> nil do
  begin
    if Result^.Packet.id = mo.id then Break;
    Result := Result^.Next;
  end;
end;

procedure AddMob(themob:tmobpacket);
begin
//do my stuff..
//add new player..
 New(CurrNode);
 CurrNode^.Next := MainNode;
 MainNode := CurrNode;
 CurrNode^.Packet:=themob;
 CurrNode^.lastmove:=gettickcount+random(10000);
 CurrNode^.real_x:=themob.x;
 CurrNode^.real_y:=themob.y;
 CurrNode^.exp:=mobinfo[CurrNode^.Packet.mobtyp-1].exp;
 CurrNode^.lvl:=mobinfo[CurrNode^.Packet.mobtyp-1].level;
 CurrNode^.itemgroup1:=mobinfo[CurrNode^.Packet.mobtyp-1].itemgroup1;
 CurrNode^.itemgroup2:=mobinfo[CurrNode^.Packet.mobtyp-1].itemgroup2;
 CurrNode^.Packet.hp:=round(((56+mobinfo[CurrNode^.Packet.mobtyp-1].hp)*mobinfo[CurrNode^.Packet.mobtyp-1].level/3)+50);
 CurrNode^.Packet.max_hp:=round(((56+mobinfo[CurrNode^.Packet.mobtyp-1].hp)*mobinfo[CurrNode^.Packet.mobtyp-1].level/3)+50);
 CurrNode^.range:=mobinfo[CurrNode^.Packet.mobtyp-1].range;
 if mobinfo[CurrNode^.Packet.mobtyp-1].ai > 1 then
  CurrNode^.aggresive:=true
 else
  CurrNode^.aggresive:=false;

 CurrNode^.underattack:=false;
 CurrNode^.active:=0;
 CurrNode^.last_reset:=0;
 CurrNode^.myattack.size:=sizeof( CurrNode^.myattack);     //<- bug found -.-
 CurrNode^.myattack.typ:=62;
 CurrNode^.myattack.exblow:=0;
 CurrNode^.myattack.dmg:=0;
 CurrNode^.myattack.attacker:=CurrNode^.Packet.id;
 CurrNode^.myattack.somethink:=1;
 CurrNode^.respawn:=random(10000);
 Map.AddMOB(GetNodeByMOB(themob));
end;


procedure LoadMobs(filename,mobb:string);
type
 myrecord=record
  WichMopTyp:word;
  HowMany:dword;
  respawn:dword;
  x,y,xx,yy:dword;
 end;
var
 mobfile:file;
 mobarea:myrecord;
 read:integer;
 i,id:integer;
 themob:tmobpacket;
 grr:myrecordd;
begin
 assignfile(mobfile,mobb);
 reset(mobfile,1);
 i:=0;
 repeat
  blockread(mobfile,grr,sizeof(grr),read);
  mobinfo[i]:=grr;
  i:=i+1;
 until read=0;
 i:=0;
 closefile(mobfile);
 assignfile(mobfile,filename);
 reset(mobfile,1);
 id:=500;
 repeat
  blockread(mobfile,mobarea,sizeof(mobarea),read);
  //so so .. add mob..
  for i := 0 to mobarea.HowMany do
  begin
   //soso
   //if id=500+200 then exit;
   themob.size:=sizeof(themob);
   themob.typ:=51;
   themob.id:=id;
   id:=id+1;
   themob.mobtyp:=mobarea.WichMopTyp;
   themob.x:=mobarea.x+random(mobarea.xx-mobarea.x);
   themob.y:=mobarea.y+random(mobarea.yy-mobarea.y);
   themob.look_x:=random(255);
   themob.look_y:=random(255);
   themob.hp:=100;
   themob.max_hp:=100;
   themob.somestuff:=#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0;
   AddMob(themob);
  end;
 until read=0;
 closefile(mobfile);
end;

procedure CheckAll;
var
 now:pmob;
 alpha:integer;
 move:tmove;
 amob:tmobpacket;
 move_x,move_y:int64;
 a,i:integer;
 d:int64;
 ox,oy,many:integer;
 mypacket:tnormalattack;
begin
now:=lastnode;
a:=gettickcount;
i:=0;
many:=0;
 while (now <> nil) do
  begin
   if (now^.Packet.hp < 1) then
   begin
    //check respawn..//min. 2min
    if now^.lastmove+120000+now^.respawn < gettickcount then
    begin
     now^.packet.hp:=now^.packet.max_hp;
     map.Send(nil,now^.packet,now^.Packet.size,true,false,now^.Packet.x,now^.Packet.y); //soo respawn work now ;)
     now^.active := 1;
     now^.lastmove:=gettickcount+5000;
     now^.underattack := false;
    end;
   end;
   if (now^.active > 0) and (now^.Packet.hp > 0) then
   begin
    many:=many+1;
    if now^.lastmove < a then
    begin
     //yhea yeha lets move :P
     move.size:=sizeof(move);
     move.typ:=37;
     move.id:=now^.Packet.id;
     alpha:=random(360); //random walk
     if not now^.underattack then
     begin
      move.x:=round(sin(alpha)*20);
      move.y:=round(cos(alpha)*20);
      if now^.Packet.x+move.x > now^.real_x+200 then move.x := -30; //other way :P
      if now^.Packet.x+move.x < now^.real_x-200 then move.x := +30; //other way :P
      if now^.Packet.y+move.y > now^.real_y+200 then move.y := -30; //other way :P
      if now^.Packet.y+move.y < now^.real_y-200 then move.y := +30; //other way :P      
      now^.Packet.x:=now^.Packet.x+move.x;
      now^.Packet.y:=now^.Packet.y+move.y;
      now^.Packet.look_x:=move.x;
      now^.Packet.look_y:=move.y;
      move.z:=0; //no z
      map.SendMove(move,nil,now,move.x,move.y);
      now^.lastmove:=a+random(3000)+2200
     end
     else
     begin
      //mob is fighting !!
      //so check his coordiantes..
      ox:=now^.target.userfile.chars.CharX;    //<- hm lol why he got wrong data ?
      oy:=now^.target.userfile.chars.CharY;    //<- hmmm don't know... maybe somedata mix.. ?
      //soso lets wander to him :P *grins*
      move_x:=ox-now^.Packet.x;
      move_y:=oy-now^.Packet.y;
      move.z:=100; //whaha
      //so check how much.. he move
      d:=round(sqrt(sqr(move_x)+sqr(move_y)))-now^.range;
      //if d < 0 then d:=d*-1;
      if d > 30 then
      begin
       move.x:=round(move_x/d*50);
       move.y:=round(move_y/d*50);
       now^.lastmove:=round(now^.lastmove+800*0.7);
      end;
      if d <= 30 then
      begin
       move.x:=0;
       move.y:=0;
       //whaha attacke him :P

       now^.myattack.dmg:=mobinfo[now^.Packet.mobtyp-1].min_attack+random(round(mobinfo[now^.Packet.mobtyp-1].max_attack*1.1-mobinfo[now^.Packet.mobtyp-1].min_attack));
  // writeln('MOB['+inttostr(now^.Packet.mobtyp)+'] ATTACK:'+inttostr(now^.myattack.dmg)+' AI:'+inttostr(mobinfo[now^.Packet.mobtyp-1].ai)+' MAX_DMG:'+inttostr(mobinfo[now^.Packet.mobtyp-1].max_attack));
       now^.myattack.exblow:=0;
       now^.myattack.somethink:=1; //or he would..
       if not now^.target^.userfile.chars.dead then //check if no die...
        map.SendAttack(now^.myattack,now^.target)
        //map.Send(now^.target^.socket,now^.myattack,now^.myattack.size,true,false,now^.target^.userfile.chars.CharX,now^.target^.userfile.chars.CharY)
       else
        now^.underattack:=false; //not attack :D
       now^.lastmove:=now^.lastmove+mobinfo[now^.Packet.mobtyp-1].aspeed;
       now^.last_reset:=0; //reset the last_reset :P
      end;
      if (move.x <> 0) and (move.y <> 0) then
      begin
      //check if reset maybe.. reset coordinates ever 100moves :P
      now^.last_reset:=now^.last_reset+1;
      if now^.last_reset = 10 then
       begin
       //reset..
       //ahm send that i am here ..
      // map.ResetMob(now^.packet);
       now^.underattack:=false;
       now^.last_reset:=0;
      end;
      //set new move
      now^.Packet.x:=now^.Packet.x+move.x;
      now^.Packet.y:=now^.Packet.y+move.y;
      map.SendMove(move,nil,now,move.x,move.y);
      end;
     end;
    end;
    end;
    now := now^.Next;
  end;
  lastnode:=now;               //wtf ?? ah .. yeah
  if lastnode=nil then lastnode:=mainnode;
  somuch:=many;
end;

procedure MobGetDMG(mob:dword;whoattack:Ponline;attackpacket:tnormalattack);
var
 thismob:pmob;
 mo:tmobpacket;
 pack:tChangeWhatIdo;
 pa:TsetPoints;
 a,c:integeR;
 lvl:Tsetpoints;
 g:string;
 ef:tshoweffect;
begin
 //set mob nderattack..
 //set his target to the other..
 mo.id:=mob;
 thismob:=GetNodeByMob(mo);
 if thismob = nil then exit;
 //give dmg..
 if attackpacket.dmg+attackpacket.exblow > thismob^.Packet.hp then
 begin
  attackpacket.exblow:=thismob^.Packet.hp;
  attackpacket.dmg:=0;
 end;
 a:=attackpacket.dmg+attackpacket.exblow;
 if thismob^.Packet.hp < 1 then exit; //is already dead..
// if a > thismob^.Packet.hp then a := thismob^.Packet.hp;
 //add exp
 whoattack^.userfile.chars.AddEXP := whoattack^.userfile.chars.AddEXP + ((thismob^.exp*thismob^.lvl)/thismob^.Packet.max_hp*a)*3;
 //check if AddExp > 0.1% ...
 c:=round(whoattack^.userfile.chars.NeedExp/10/100/100);
 if whoattack^.userfile.chars.CharEXP >= whoattack^.userfile.chars.NeedExp then
 begin
  whoattack^.userfile.chars.CharEXP:=whoattack^.userfile.chars.CharEXP-whoattack^.userfile.chars.NeedEXP;
  whoattack^.userfile.chars.CharLvl:=whoattack^.userfile.chars.CharLvl+1;
  lvl.size:=sizeof(lvl);
  lvl.typ:=69;
  lvl.what:=$1A; //$1A = lvl $17 = should be.. statepoints..
  lvl.howmuch:=whoattack^.userfile.chars.CharLvl; //set lvl ;D
  whoattack^.socket.SendBuf(lvl,lvl.size);   //Send lvl
  //send lvlup ani..
  ef.size:=sizeof(ef);
  ef.typ:=73;
  ef.id:=whoattack^.sockethandle;
  ef.effect:=03;
  send(nil,ef,ef.size,true,false,whoattack^.userfile.chars.CharX,whoattack^.userfile.chars.CharY);
  //check up points..
  whoattack^.userfile.chars.statepoints:=whoattack^.userfile.chars.statepoints+5;
  whoattack^.userfile.chars.skillpoints:=whoattack^.userfile.chars.skillpoints+1;
  lvl.what:=$17;
  lvl.howmuch:=whoattack^.userfile.chars.statepoints;  //set statepoints
  whoattack^.socket.SendBuf(lvl,lvl.size); //send it..
  lvl.what:=$17+1; //maybe skillspoints..
  lvl.howmuch:=whoattack^.userfile.chars.skillpoints;  //set skill points
  whoattack^.socket.SendBuf(lvl,lvl.size); //send skillpoints it..
  //updae other states..
  AllZero;
  //not yet :D
  whoattack^.userfile.chars.NeedExp:=GetExp(whoattack^.userfile.chars.CharLvl);
  //updaet exp..
  g:=#1#0#69#$19+dwordtostring(whoattack^.userfile.chars.CharEXP)+#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0;
  g[1]:=chr(length(g));
  whoattack^.socket.SendText(g);
 end;
 if c < 1 then c:=1;
 if whoattack^.userfile.chars.AddEXP > c then
 begin
  //add Exp
  whoattack^.userfile.chars.CharEXP:=whoattack^.userfile.chars.CharEXP+c;
  //..
  whoattack^.userfile.chars.AddEXP:=whoattack^.userfile.chars.AddEXP-c;
  //send that he got exp :P
  g:=#1#0#69#$19+dwordtostring(whoattack^.userfile.chars.CharEXP)+#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0;
  g[1]:=chr(length(g));
  whoattack^.socket.SendText(g);
 end;
 //writeln(inttostr(round(whoattack^.userfile.chars.AddEXP))+' '+inttostr(whoattack^.userfile.chars.CharEXP));
 thismob^.Packet.hp:=thismob^.Packet.hp - a;
 //writeln('MOB''s HP:'+inttostr(thismob^.Packet.hp)); //for debug..
 if thismob^.Packet.hp <= 0 then
 begin
  thismob^.Packet.hp:=0;
  //Send that this mob is dead :P
  //change his state.. with like sit packet..
  pack.size:=sizeof(pack);
  pack.typ:=61;
  pack.id:=thismob^.Packet.id;
  pack.whatchange:=9;
  pack.data:=10;
  thismob^.lastmove:=gettickcount;
  //send to my self .. must change than to all
  //whoattack^.socket.SendBuf(pack,pack.size);
  thismob^.underattack:=false;
  Map.Send(nil,pack,pack.size,true,false,thismob^.Packet.x,thismob^.packet.y);
  //send drop

 // for a := 0 to random(10) do
 // begin
   item.MOBDrop(whoattack^.socket,thismob); //drop for mob's items..
  // AddItem(whoattack,31,random(100)); //get item.. for the moment -.-
 // end;

  //send that you
  whoattack^.userfile.chars.CharHP:=whoattack^.userfile.chars.CharHP+(whoattack^.userfile.chars.CharMaxHP div 10);
  if whoattack^.userfile.chars.CharHP>whoattack^.userfile.chars.CharMaxHP then whoattack^.userfile.chars.CharHP:=whoattack^.userfile.chars.CharMaxHP;
  pa.size:=sizeof(pa);
  pa.typ:=69;
  pa.what:=5;
  pa.howmuch:=whoattack^.userfile.chars.CharHP;
  pa.full:=whoattack^.userfile.chars.CharMaxHP;
  whoattack^.socket.SendBuf(pa,pa.size);
 end;
 if thismob^.packet.hp = 0 then exit;
 map.SendAttack(attackpacket,whoattack); //send attack to all in near..

 if thismob.underattack then exit;

 //so so found
 thismob.underattack:=true; //underattack now :P
 thismob.target:=whoattack; //so so.. ready for attack
 thismob.lastmove:=gettickcount+1500; //that it wilkl next time checked ! :P
 //change attack packet a litte..
 attackpacket.attacker:=thismob^.Packet.id;
 attackpacket.opfer := whoattack^.userfile.chars.CharId;
 thismob.myattack:=attackpacket;
end;

end.
