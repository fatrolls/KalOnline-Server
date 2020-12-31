program KalWorldEditor;

uses
  Forms,
  KalClientMap in 'KalClientMap.pas',
  Unit1 in 'Unit1.pas' {Form_Main},
  Unit2 in 'Unit2.pas' {Form_KCMTextureCenter},
  Unit3 in 'Unit3.pas' {Form_Options},
  Unit_SplashScreen in 'Unit_SplashScreen.pas' {Form_SplashScreen},
  Unit4 in 'Unit4.pas' {Form_BorderCenter},
  Unit5 in 'Unit5.pas' {Form_MapXY},
  Unit6 in 'Unit6.pas' {Form_LayerCenter},
  Unit7 in 'Unit7.pas' {Form_Login},
  Unit8 in 'Unit8.pas' {Form_Shutdown},
  Unit9 in 'Unit9.pas' {Form_BrowseModel},
  Unit10 in 'Unit10.pas' {Form_Colormap};

{$R *.res}

begin
  Form_SplashScreen := TForm_SplashScreen.Create(Application) ;
  Form_SplashScreen.Show;
  Application.Initialize;
  Form_SplashScreen.Update;
  Application.Title := 'Kal World Editor';
  Application.CreateForm(TForm_Login, Form_Login);
  Application.CreateForm(TForm_Colormap, Form_Colormap);
  //Application.CreateForm(TForm_Shutdown, Form_Shutdown);
  Form_Login.Show;
  //Application.CreateForm(TForm_Main, Form_Main);
  Application.CreateForm(TForm_BrowseModel, Form_BrowseModel);
  Application.CreateForm(TForm_KCMTextureCenter, Form_KCMTextureCenter);
  Application.CreateForm(TForm_Options, Form_Options);
  Application.CreateForm(TForm_BorderCenter, Form_BorderCenter);
  Application.CreateForm(TForm_MapXY, Form_MapXY);
  Application.CreateForm(TForm_LayerCenter, Form_LayerCenter);
  Application.Run;
end.
