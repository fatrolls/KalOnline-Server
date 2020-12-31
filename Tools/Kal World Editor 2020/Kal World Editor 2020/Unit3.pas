unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, IniFiles, XPMan, FileCtrl;

type
  TForm_Options = class(TForm)
    Edit_ClientPath: TEdit;
    Label_ClientPath: TLabel;
    Label_MainSvrPath: TLabel;
    Edit_MainSvrPath: TEdit;
    BitBtn1: TBitBtn;
    Edit_KSMInitialPath: TEdit;
    Label_KSMInitialPath: TLabel;
    Edit_KCMInitialPath: TEdit;
    Label_KCMInitialPath: TLabel;
    Button_BrowseClient: TButton;
    XPManifest1: TXPManifest;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit_AutoSaveInt: TEdit;
    Label_AutoSave: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button_BrowseClientClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Options: TForm_Options;
  INIFile:TINIFIle;

implementation

{$R *.dfm}

procedure TForm_Options.BitBtn1Click(Sender: TObject);
begin
  INIFile:=TINIFile.Create(ExtractFilePath(Application.ExeName)+Copy(ExtractFileName(Application.ExeName),0,Length(ExtractFileName(Application.ExeName))-Length(ExtractFileExt(Application.ExeName)))+'.ini');
  If Edit_MainSvrPath.Text[Length(Edit_MainSvrPath.Text)]<>'\' then
  begin
    Edit_MainSvrPath.Text:=Edit_MainSvrPath.Text+'\';
  end;
  If Edit_ClientPath.Text[Length(Edit_ClientPath.Text)]<>'\' then
  begin
    Edit_ClientPath.Text:=Edit_ClientPath.Text+'\';
  end;
  If Edit_KCMInitialPath.Text[Length(Edit_KCMInitialPath.Text)]<>'\' then
  begin
    Edit_KCMInitialPath.Text:=Edit_KCMInitialPath.Text+'\';
  end;
  If Edit_KSMInitialPath.Text[Length(Edit_KSMInitialPath.Text)]<>'\' then
  begin
    Edit_KSMInitialPath.Text:=Edit_KSMInitialPath.Text+'\';
  end;
  INIFile.WriteString('Settings','Client_Path',Edit_ClientPath.Text);
  INIFile.WriteString('Settings','MainSvr_Path',Edit_MainSvrPath.Text);
  INIFile.WriteString('Settings','KCMInital_Path',Edit_KCMInitialPath.Text);
  INIFile.WriteString('Settings','KSMInital_Path',Edit_KSMInitialPath.Text);
  INIFile.WriteInteger('Settings','AutoSaveInterval',StrToInt(Edit_AutoSaveInt.Text));
  INIFIle.Free;
  MessageBox(Handle, pchar('Settings have succesfully been saved. You have to restart the application to take effect.'),PChar('Settings saved.'),mb_OK);

end;

procedure TForm_Options.FormShow(Sender: TObject);
begin
  Try
    INIFile:=TINIFile.Create(ExtractFilePath(Application.ExeName)+Copy(ExtractFileName(Application.ExeName),0,Length(ExtractFileName(Application.ExeName))-Length(ExtractFileExt(Application.ExeName)))+'.ini');
    Edit_ClientPath.Text:=INIFile.ReadString('Settings','Client_Path','');
    Edit_MainSvrPath.Text:=INIFile.ReadString('Settings','MainSvr_Path','');
    Edit_KCMInitialPath.text:=INIFile.ReadString('Settings','KCMInital_Path','');
    Edit_KSMInitialpath.text:=INIFile.ReadString('Settings','KSMInital_Path','');
    Edit_AutoSaveInt.Text:=IntToSTr(INIFile.ReadInteger('Settings','AutoSaveInterval',30));

    If Edit_MainSvrPath.Text[Length(Edit_MainSvrPath.Text)]<>'\' then
    begin
      Edit_MainSvrPath.Text:=Edit_MainSvrPath.Text+'\';
    end;
    If Edit_ClientPath.Text[Length(Edit_ClientPath.Text)]<>'\' then
    begin
      Edit_ClientPath.Text:=Edit_ClientPath.Text+'\';
    end;
    //INIFIle.Free;
  except
  end;
end;

procedure TForm_Options.Button_BrowseClientClick(Sender: TObject);
var
  ChosenDir:string;
begin
  if SelectDirectory('Please Select Client Directory','',ChosenDir) then
  begin
    Edit_CLientPath.Text:=ChosenDir+'\';
  end;
end;

procedure TForm_Options.Button1Click(Sender: TObject);
var
  ChosenDir:string;
begin
  if SelectDirectory('Please Select Server Directory','',ChosenDir) then
  begin
    Edit_MainSvrPath.Text:=ChosenDir+'\';
  end;

end;

procedure TForm_Options.Button2Click(Sender: TObject);
var
  ChosenDir:string;
begin
  if SelectDirectory('Please Select KCM Directory','',ChosenDir) then
  begin
    Edit_KCMInitialPath.Text:=ChosenDir+'\';
  end;
end;

procedure TForm_Options.Button3Click(Sender: TObject);
var
  ChosenDir:string;
begin
  if SelectDirectory('Please Select KSM Directory','',ChosenDir) then
  begin
    Edit_KSMInitialPath.Text:=ChosenDir+'\';
  end;

end;

end.
