unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
type tmoney = record
 dice:word;
 group:word;
end;
var i:integer;
var money:tmoney;
var fil:file;
begin
 //change it.. to my mode.. for converting..
 memo1.Clear;
 for i := 0 to memo2.Lines.Count-1 do
 begin
  if length(memo2.Lines.Strings[i]) > 1 then
   if memo2.Lines.Strings[i][1] <> ';' then memo1.Lines.Add(memo2.Lines.Strings[i]);
 end;
 //copy..
 memo1.Text:=stringreplace(memo1.Text,'(itemgroup (index ',#13#10+'!INDEX'+#13#10,[rfReplaceAll, rfIgnoreCase]);
 memo1.Text:=stringreplace(memo1.Text,'(group (',#13#10+'!GROUP'+#13#10,[rfReplaceAll, rfIgnoreCase]);
 memo1.Text:=stringreplace(memo1.Text,')))',#13#10+'!END',[rfReplaceAll, rfIgnoreCase]);
 memo1.Text:=stringreplace(memo1.Text,')','',[rfReplaceAll, rfIgnoreCase]); //yeah away with )
 memo1.Text:=stringreplace(memo1.Text,'(',#13#10+'!GROUP'+#13#10,[rfReplaceAll, rfIgnoreCase]); //yeah away with )
 memo1.Text:=stringreplace(memo1.Text,'!GROUP'+#13#10+'group ','!END',[rfReplaceAll, rfIgnoreCase]); //yeah away with )
 //so save to drop lists..
 i:=0;
 repeat
  if memo1.Lines.Strings[i] = '!INDEX' then
  begin
   //if index than..
   //assignfiles..
   i:=i+1; //next :P
   assignfile(fil,'DROPLIST['+inttostr(strtoint(stringreplace(memo1.Lines.Strings[i],' ','',[rfReplaceAll, rfIgnoreCase])))+'].db');
   rewrite(fil,1);
  end;
  if memo1.Lines.Strings[i] = '!MONEY' then
  begin
   //write money in..
   memo2.Clear;
   i:=i+1;
   memo2.Text:=stringreplace(memo1.Lines.Strings[i],' ',#13#10,[rfReplaceAll, rfIgnoreCase]); //yeah away with )
   memo2.Text:=stringreplace(memo2.Text,#$09,'',[rfReplaceAll, rfIgnoreCase]); //yeah away with )
   money.dice:=strtoint(memo2.Lines.Strings[0]);
   //money.item:=31; // 31 = money.. (i hope)
   //money.prefix:=strtoint(memo2.Lines.Strings[1]); //or how much -.-
   blockwrite(fil,money,sizeof(money));      //write..
  end;
  if memo1.Lines.Strings[i] = '!ITEM' then
  begin
   //write money in..
   memo2.Clear;
   i:=i+1;
   memo2.Text:=stringreplace(memo1.Lines.Strings[i],' ',#13#10,[rfReplaceAll, rfIgnoreCase]); //yeah away with )
   memo2.Text:=stringreplace(memo2.Text,#$09,'',[rfReplaceAll, rfIgnoreCase]); //yeah away with )
   memo2.lines.add('');
   money.dice:=strtoint(memo2.Lines.Strings[0]);
   //money.item:=strtoint(memo2.Lines.Strings[1]); // 31 = money.. (i hope)
   //if memo2.Lines.Strings[2] = '' then memo2.Lines.Strings[2]:='0';
   //money.prefix:=strtoint(memo2.Lines.Strings[2]); //or how much -.-
   blockwrite(fil,money,sizeof(money)); //write..
  end;
  if memo1.Lines.Strings[i] = '!GROUP' then
  begin
   //write money in..
   memo2.Clear;
   i:=i+1;
   memo2.Text:=stringreplace(memo1.Lines.Strings[i],' ',#13#10,[rfReplaceAll, rfIgnoreCase]); //yeah away with )
   memo2.Text:=stringreplace(memo2.Text,#$09,'',[rfReplaceAll, rfIgnoreCase]); //yeah away with )
   memo2.lines.add('');
   money.dice:=strtoint(memo2.Lines.Strings[0]);
   money.group:=strtoint(memo2.Lines.Strings[1]); // 31 = money.. (i hope)
   blockwrite(fil,money,sizeof(money)); //write..
  end;
  if memo1.Lines.Strings[i] = '!END' then
  begin
   closefile(fil);
  end;
  i:=i+1; //next..
 until i > memo1.Lines.Count;
end;

end.
