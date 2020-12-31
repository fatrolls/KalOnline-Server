unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  type TOPLRecord = packed record
     path_length : longword;
     relative_path : array[0..31] of char;
     // Vector3D (x, y z)
     position_x : Single;
     position_y : Single;
     position_z : Single;
        // Quaternion (x, y z, w)
        rotation_x : Single;
        rotation_y : Single;
        rotation_z : Single;
        rotation_w : Single;
        // Vector3D (x, y z)
        scale_x : real;
        scale_y : real;
        scale_z : real;
   end;
var
  Form1: TForm1;
  OPL: Array[0..1] of TOPLRecord;
  F: TMemoryStream;
implementation

uses opl;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
F:=TMemoryStream.Create;
F.LoadFromFile('file.opl');
F.Position:=40;
//F.Read(OPL, SizeOf(OPL));
//memo1.lines.Add(inttostr(opl[0].path_length));
end;


procedure TForm1.Button2Click(Sender: TObject);
var OPL: TOpl;
begin
OPL:=TOPL.Create;
OPL.Filename:='n_028_035.opl';
OPL.Open;
//showmessage(inttostr(opl.ItemCount));
{memo1.Lines.Add(IntToStr(OPL.OPLArray[0].plength));
memo1.Lines.Add('px='+CurrToStr(OPL.Oplarray[0].position_x));
memo1.Lines.Add('py='+CurrToStr(OPL.Oplarray[0].position_y));
memo1.Lines.Add('pz='+CurrToStr(OPL.Oplarray[0].position_z));}
end;

end.
 