unit npc;

interface

uses header,map;

procedure LoadNpc(filename:string);

var MainNode, CurrNode, PrevNode: Pnpc;

implementation

function GetNodeByNpc(Npc: tnpcpacket): PNpc;
begin
 Result := MainNode;
 while Result <> nil do
  begin
    if Result^.Packet.id = npc.id then Break;
    Result := Result^.Next;
  end;
end;

procedure AddNpc(theNpc:tnpcpacket);
begin
//do my stuff..
//add new player..
 New(CurrNode);
 CurrNode^.Next := MainNode;
 MainNode := CurrNode;
 CurrNode^.Packet:=theNpc;
 Map.AddNPC(GetNodeByNpc(thenpc));
end;

procedure LoadNpc(filename:string);
var
 fil:file;
 THeNpc:tnpcpacket;
 read:integer;
begin
 assignfile(fil,filename);
 reset(fil,1);
 repeat
  blockread(fil,TheNpc,sizeof(TheNpc),read);
 // thenpc.somebyte:=1;     //<-this is wich npc look how he looks
  thenpc.somestuff:=#1#1#1#1#1#1#1#1;
  addnpc(thenpc); //whaha npc added :P so easy..
 until read=0;
 closefile(fil);
end;

end.
