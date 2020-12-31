unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, KalClientMap;

type
  THeaderType=(KCM,OPL);
  TForm_MapXY = class(TForm)
    Edit_MapX: TEdit;
    Edit_MapY: TEdit;
    Label_MapX: TLabel;
    Label_MapY: TLabel;
    BitBtn_Ok: TBitBtn;
    BitBtn_Cancel: TBitBtn;
    procedure SetKCMMapXY;
    procedure SetOPLMapXY;
    procedure BitBtn_CancelClick(Sender: TObject);
    procedure BitBtn_OkClick(Sender: TObject);
  private
    HeaderType:THeaderType;
    //pKCMHeader:TKCMHeader;
    //pOPLHeader:TOPLHeader;
  public
    { Public declarations }
  end;

var
  Form_MapXY: TForm_MapXY;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm_MapXY.SetKCMMapXY;
begin
  HeaderType:=KCM;
  //pKCMHeader:=KCMHeader;
  Edit_MapX.Text:=IntToStr(Form_Main.KCM.Header.MapX);
  Edit_MapY.Text:=IntToStr(Form_Main.KCM.Header.MapY);
  Form_MapXY.Show;
  Form_MapXY.BringToFront;
end;

procedure TForm_MapXY.SetOPLMapXY;
begin
  HeaderType:=OPL;
  //Try
    Edit_MapX.Text:=IntToStr(Form_Main.OPL.Header.MapX);
    Edit_MapY.Text:=IntToStr(Form_Main.OPL.Header.MapY);
  //except
  //end;
  Form_MapXY.Show;
  Form_MapXY.BringToFront;
end;

procedure TForm_MapXY.BitBtn_CancelClick(Sender: TObject);
begin
  Form_MapXY.Hide;
end;

procedure TForm_MapXY.BitBtn_OkClick(Sender: TObject);
var
  TempKCMHeader:TKCMHeader;
  TempOPLHeader:TOPLHeader;
begin
  Case HeaderType of
    KCM:  Begin
            TempKCMHeader:=TKCMHeader.Create;
            TempKCMHeader:=Form_Main.KCM.Header;
            TempKCMHeader.MapX:=StrToInt(Edit_MapX.Text);
            TempKCMHeader.MapY:=StrToInt(Edit_MapY.Text);
            Form_Main.KCM.Header:=TempKCMHeader;
          end;
    OPL:  Begin
            TempOPLHeader:=TOPLHeader.Create;
            TempOPLHeader:=Form_Main.OPL.Header;
            TempOPLHeader.MapX:=StrToInt(Edit_MapX.Text);
            TempOPLHeader.MapY:=StrToInt(Edit_MapY.Text);
            Form_Main.OPL.Header:=TempOPLHeader;
          end;
    else  Begin
            MessageBox(Handle,PChar('An error occured while trying to set Map Location:'+#13+'- unknown file'),'Error',mb_Ok);
          end;
  end;
  Form_MapXY.Hide;
end;

end.
