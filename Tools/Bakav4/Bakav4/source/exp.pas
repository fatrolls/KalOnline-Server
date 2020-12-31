unit exp;

interface

procedure LoadExp(filename:string);
function GetExp(lvl:byte):longword;

implementation

var ExpForLvl:array[1..90] of longword; //whwhahah

procedure LoadExp(filename:string);
 type tread=record
 a:longword;
end;
var list:file;
    i,read:integer;
    readd:tread;
begin
 //soso load
 assignfile(list,filename);
 reset(list,1);
 i:=1;
 repeat
  blockread(list,readd,sizeof(readd),read);
  EXpForLvl[i]:=readd.a;
  i:=i+1;
 until read=0;
 closefile(list);
end;

function GetExp(lvl:byte):longword;

begin
 //soso..
 result:=ExpForLvl[lvl];
end;

end.
