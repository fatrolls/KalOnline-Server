unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtActns, ComCtrls, StdCtrls, jpeg, ExtCtrls, ShellAPI, INIFiles, FILECTRL, Unzip;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Image1: TImage;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private
      UFuncs: USERFUNCTIONS;
      DCList: DCL;
  public
procedure URL_OnDownloadProgress

           (Sender: TDownLoadURL;

            Progress, ProgressMax: Cardinal;

            StatusCode: TURLDownloadStatus;

            StatusText: String; var Cancel: Boolean);

    function DoDownload(const strWhichURL,strLocalFile:string): boolean;
    function DoReadINI(const strFile,strWhichSection,strString:string): string;
    procedure DoWriteINI(const strFileWRI,strWhichSectionWRI, strNameWRI, strStringWRI:string);
    procedure CompareStrings(const string1, string2: string);
  end;

   procedure CallbackMessage (ucsize, csiz, cfactor, mo, dy, yr, hh, mm: Longword; c: Byte; fname, meth: PChar; crc: Longword; fCrypt: Byte); stdcall;
   function CallbackPassword (pwbuf: PChar; size: Longint; m, efn: PChar): EDllPassword; stdcall;
   function CallbackPrint (buffer: PChar; size: Longword): EDllPrint; stdcall;
   function CallbackReplace (filename: PChar): EDllReplace; stdcall;
   function CallbackService (efn: PChar; details: Longword): EDllService; stdcall;


const

   PATH_TO_ZIPFILE: PChar =     'update.zip';   // path to the sample archive
   PATH_TO_OUTPUTDIR: PChar =   './';        // path to the output directory
   SOME_ZIPPED_FILE: PChar =    nil;     // a file inside the sample archive
   SOME_GREP_STRING: PChar =    nil;      // a string inside a file inside the sample archive


var
  Form1: TForm1;

implementation

{$R *.dfm}


{*
========================
   callback functions
========================
*}

procedure CallbackMessage (ucsize, csiz, cfactor, mo, dy, yr, hh, mm: Longword; c: Byte; fname, meth: PChar; crc: Longword; fCrypt: Byte);
begin ShowMessage(Format('unzip32 Message: %u%s%u  %u%s  %u-%u-%u  %u:%u  %s', [ucsize, '/', csiz, cfactor, '%', mo, dy, yr, hh, mm, fname])); end;


function CallbackPassword (pwbuf: PChar; size: Longint; m, efn: PChar): EDllPassword;
begin Result := IZ_PW_NONE; end;


function CallbackPrint (buffer: PChar; size: Longword): EDllPrint;
begin
 {  ShowMessage('unzip32 Print: ' + buffer);  }
   Result := size;
end;


function CallbackReplace (filename: PChar): EDllReplace;
begin Result := IDM_REPLACE_NONE; end;


function CallbackService (efn: PChar; details: Longword): EDllService;
begin Result := UZ_ST_CONTINUE; end;


procedure TForm1.URL_OnDownloadProgress;

begin

  ProgressBar1.Max:= ProgressMax;

  ProgressBar1.Position:= Progress;

end;

function TForm1.DoReadINI(const strFile,strWhichSection,strString:string): string;
 var
    ReadINI : TINIFile;
begin
try
    ReadINI := TINIFile.Create(strFile);
    result := ReadINI.ReadString(strWhichSection, strString, 'Default');
    finally
    ReadINI.Free;
end;
end;

procedure TForm1.DoWriteINI(const strFileWRI,strWhichSectionWRI,strNameWRI,strStringWRI:string);
 var
    WriteINI : TINIFile;
begin
try
    WriteINI := TINIFile.Create(strFileWRI);
    WriteINI.WriteString(strWhichSectionWRI, strNameWRI, strStringWRI);
    finally
    WriteINI.Free;
end;
end;

function TForm1.DoDownload(const strWhichURL,strLocalFile:string): boolean;

begin
    Result:=True;
  with TDownloadURL.Create(nil) do

  try

    URL := strWhichURL;

    FileName := strLocalFile;

    OnDownloadProgress := URL_OnDownloadProgress;
     try
    ExecuteTarget(nil);
    except
    ShowMessage('Can not Download ' + strWhichURL);
    Result:=False
    end;


    finally

    Free;
    ProgressBar1.Position := 0;

  end;

end;


procedure TForm1.CompareStrings(const string1, string2: string);
  var result : Integer;
  var UpdateFile,UpdateLocalFile,VersionServer,UpdateVersionFile: string;
  var
   incl:      array of PChar;
   excl:      array of PChar;
begin
  result := AnsiCompareStr(string1, string2);

  if result < 0 then
  begin
UpdateFile := DoReadINI('./updater.ini','Settings','UpdateHost') + '/' + DoReadINI('./updater.ini','Settings','UpdateFile');
UpdateLocalFile := DoReadINI('./updater.ini','Settings','UpdateFile');
  { Download Update }
  DoDownload(UpdateFile,UpdateLocalFile);
  { Unzip Start }
  SetLength(incl, 2); incl[0] := '*.*';
   SetLength(excl, 2); excl[0] := nil;

   Wiz_ErrorToStr(Wiz_SingleEntryUnzip(2, incl[0], 2, excl[0], DCList, UFuncs));

  { Unzip Stop }

  { Write New Version to INI}
  UpdateVersionFile :='./tmp/updater.ini';
  VersionServer := DoReadINI(UpdateVersionFile,'Settings','UpdateVersion');
  DoWriteINI('./updater.ini','Settings','UpdateVersion',VersionServer);


  end;
  if result = 0 then
  begin
  { do nothing }

  end;
  if result > 0 then
  begin
  { Local Update is Higher Then Server Update - version tampering}
  ShowMessage('Error In Version');
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
ShellExecute(Form1.Handle, 'open', 'engine.exe', '/load /config debug', nil, SW_SHOWNORMAL);
close;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 ShellExecute(Form1.Handle, 'open', 'engine.exe', '/setup', nil, SW_SHOWNORMAL);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
    SiteButtonURL: string;
begin
SiteButtonURL := DoReadINI('./updater.ini','Settings','WebsiteButtonURL');
ShellExecute(Form1.Handle, 'open', PChar(SiteButtonURL), nil, nil, SW_SHOWNORMAL);

end;

procedure TForm1.FormCreate(Sender: TObject);
var UpdaterTitle,NoticeInetFile,NoticeLocalFile: string;

begin


{ Unzip Functions Start }

// note: the USERFUNCTIONS record contains pointers to your callback
   // functions. it is required for the DLL functions Wiz_Grep(),
   // Wiz_Init(), Wiz_SingleEntryUnzip() and Wiz_UnzipToMemory()

   with self.UFuncs do
      begin
      print := CallbackPrint;
      sound := nil;
      replace := CallbackReplace;
      password := CallbackPassword;
      SendApplicationMessage := CallbackMessage;
      ServCallBk := CallbackService;
      end;

   // note: the DCL record contains settings for the DLL. it is required
   // for the DLL functions Wiz_SetOpts() and Wiz_SingleEntryUnzip().
   // please check Unzip.pas for a description of the various options.

   with self.DCList do
      begin
      ExtractOnlyNewer := 0;
      SpaceToUnderscore := 0;
      PromptToOverwrite := 1;
      fQuiet := 0;
      ncflag := 0;
      ntflag := 0;
      nvflag := 0;
      nfflag := 0;
      nzflag := 0;
      ndflag := 1;
      noflag := 1;
      naflag := 0;
      nZIflag := 0;
      C_flag := 1;
      fPrivilege := 0;
      lpszZipFN := PATH_TO_ZIPFILE;
      lpszExtractDir := PATH_TO_OUTPUTDIR;
      end;

{ Unzip Functions Stop }


UpdaterTitle := DoReadINI('./updater.ini','Settings','UpdaterTitle');
Form1.caption := UpdaterTitle;
NoticeLocalFile := DoReadINI('./updater.ini','Settings','NoticeFile');
NoticeInetFile := DoReadINI('./updater.ini','Settings','UpdateHost') + '/' + DoReadINI('./updater.ini','Settings','NoticeFile');
DoDownload(NoticeInetFile,NoticeLocalFile);
if FileExists(NoticeLocalFile) then
   Memo1.Lines.LoadFromFile(NoticeLocalFile)
else
  ShowMessage('Can not Display Notice File');

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var VersionLocal,VersionServer,UpdateVersionLocal,UpdateVersionServer,UpdateVersionFile,NoticeInetFile,NoticeLocalFile: string;

begin
NoticeLocalFile := DoReadINI('./updater.ini','Settings','NoticeFile');
NoticeInetFile := DoReadINI('./updater.ini','Settings','UpdateHost') + '/' + DoReadINI('./updater.ini','Settings','NoticeFile');
UpdateVersionLocal := DoReadINI('./updater.ini','Settings','UpdateVersion');
UpdateVersionServer := DoReadINI('./updater.ini','Settings','UpdateHost') + '/' + 'updater.ini';
DoDownload(NoticeInetFile,NoticeLocalFile);

Timer1.enabled:=false;

UpdateVersionFile :='./tmp/updater.ini';

if DirectoryExists('tmp') then
    begin
    DoDownload(UpdateVersionServer,UpdateVersionFile);
    end
else
    begin
if CreateDir('tmp') then
    begin
      DoDownload(UpdateVersionServer,UpdateVersionFile);
    end
else
begin
      ShowMessage('Could not create tmp Directory');
      end
    end;


{ Check Update Version }

if DirectoryExists('tmp') then
begin


{ Version Check Code Start }

if FileExists(UpdateVersionFile) then
begin
VersionLocal := DoReadINI('./updater.ini','Settings','UpdateVersion');
VersionServer := DoReadINI(UpdateVersionFile,'Settings','UpdateVersion');
CompareStrings(VersionLocal, VersionServer);

end
else
begin
      ShowMessage('Could not check Update Version');
end

{ Version Check Code End }

end
else
begin
      ShowMessage('Could not check Update Version');
end




end;

end.

