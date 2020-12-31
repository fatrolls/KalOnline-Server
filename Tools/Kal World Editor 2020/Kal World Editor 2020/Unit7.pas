unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtActns, ComCtrls, StdCtrls, jpeg, ExtCtrls, ShellAPI, INIFiles, KalClientMap, Registry, wininet,IdHashMessageDigest, idHash;
//, wininet;


type
  TIPs = Array[1..3] Of String;
  TLogin = class
  private
  public
    Login:String;
    Password:String;
    Email:String;
    AmountOfIP:byte;
    IP:TIPs;
  end;
  TLogins = Array of TLogin;
  TForm_Login = class(TForm)
    Button_Login: TButton;
    RichEdit_Intro: TRichEdit;
    procedure Button_LoginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  Form_Login: TForm_Login;

implementation

uses Unit1, Unit_SplashScreen;


{$R *.dfm}

procedure TForm_Login.Button_LoginClick(Sender: TObject);
begin
  Form_Login.Hide;

  MessageBox(0,PChar('You REALLY thought I''d give KWE away for free? LOL!'),PChar('NOOB'),mb_ok);
  MessageBox(0,PChar('Yeah I did :\ Enjoy...'),PChar('Just trolling...'),mb_ok);

  //Creating the main form here, for safety purposes
  Application.CreateForm(TForm_Main, Form_Main);

  Form_Main.Show;
end;

procedure TForm_Login.FormShow(Sender: TObject);
begin
  Form_Login.BringToFront;
  Form_Login.SetFocus;
end;

end.
