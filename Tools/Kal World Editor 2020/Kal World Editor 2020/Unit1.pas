unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLWin32Viewer, GLMisc, GLScene, GLObjects, GLMesh, StdCtrls,
  GLTexture, VectorTypes, VectorGeometry, ExtCtrls, GLVectorFileObjects,
  GLNavigator, GLCadencer, Keyboard, Menus, KalClientMap,GLGraph, XPMan,
  ComCtrls, GLFile3ds, Buttons,INIFiles, math, GLWaterPlane, GLHUDObjects,
  GLGui, GLWindows, GLBitmapFont, GLWindowsFont, ShellApi, ToolWin, ClipBrd,
  XPStyleActnCtrls, ActnList, ActnMan, StdActns, ActnCtrls, ActnMenus, Registry,
  jpeg, dds;

type
  TKWETool=( tKSM_HeightBased ,tKSM_PaintBrush  ,tKSM_OPLBased
            ,tKCM_HeightBrush ,tKCM_SetHeight   ,tKCM_Flatten
            ,tKCM_TexturePaint,tKCM_WholeMap    ,tKCM_GrassPaint
            ,tOPL_Position    ,tOPL_Scale       ,tOPL_AddNode
            ,tOPL_RotateX     ,tOPL_RotateY     ,tOPL_RotateZ
            ,null);
  TSelected_OPL=record
    Index:Integer;
    Tex:String;
  end;
  TSelected_OPLs=Array of TSelected_OPL;
  TForm_Main = class(TForm)
    GLScene: TGLScene;
    GLSceneViewer: TGLSceneViewer;
    GLDummyCube: TGLDummyCube;
    Panel_General: TPanel;
    Image_General: TImage;
    ListBox_File: TListBox;
    Label_File: TLabel;
    ListBox_FileAspect: TListBox;
    Label_FileAspect: TLabel;
    GroupBox_AspectToChange: TGroupBox;
    Label_BrushSize: TLabel;
    TrackBar_BrushSize: TTrackBar;
    GroupBox_KSMDRAW: TGroupBox;
    GroupBox_KSMDraw_GeneralValues: TGroupBox;
    GroupBox_KSMDraw_SpecifiedValues: TGroupBox;

    Label_BrushColor: TLabel;
    Image_ColorDraw1: TImage;
    GroupBox_KSMHEIGHT: TGroupBox;
    Label_IndicaterHeight: TLabel;
    Label_ColorDraw: TLabel;
    Image_ColorDraw2: TImage;
    TrackBar_IndicatorHeight: TTrackBar;
    GroupBox4: TGroupBox;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    GroupBox5: TGroupBox;

    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    RadioButton14: TRadioButton;
    RadioButton15: TRadioButton;
    RadioButton16: TRadioButton;

    GLFreeForm_Indicator: TGLFreeForm;
    GLFreeForm_water: TGLFreeForm;
    GLHeightField: TGLHeightField;
    KSMHEIGHT_ButtonDown: TBitBtn;
    KSMHEIGHT_ButtonUp: TBitBtn;

    GroupBox_KCMTexturePaint: TGroupBox;

    //KCM Height panel
    GroupBox_KCMHEIGHT: TGroupBox;
    RadioButton_KCMHEIGHT_UP: TRadioButton;
    RadioButton_KCMHEIGHT_DOWN: TRadioButton;
    TrackBar_KCMHEIGHT_Diameter: TTrackBar;
    TrackBar_KCMHEIGHT_Intensity: TTrackBar;
    Label_KCMHEIGHT_Diameter: TLabel;
    Label_KCMHEIGHT_Intensity: TLabel;

    //KCM Set Height Panel
    GroupBox_KCMSetHeight: TGroupBox;
    TrackBar_KCMSetHeight_Diameter: TTrackBar;
    TrackBar_KCMSetHeight_Height: TTrackBar;
    Label_KCMSetHeight_diameter: TLabel;
    Edit_KCMSetHeight_Height: TEdit;

    //KCM Flatten panel
    GroupBox_KCMFlatten: TGroupBox;
    Label_KCMFlatten_Diameter: TLabel;
    TrackBar_KCMFlatten_Diameter: TTrackBar;

    //KCM Texture paint components
    Label_KCMTexturePaint_TextureMap: TLabel;
    Label_KCMTexturePaint_OuterCicle: TLabel;
    Label_KCMTexturePaint_OuterDiameter: TLabel;
    Label_KCMTexturePaint_Intensity: TLabel;
    TrackBar_KCMTexturePaint_OuterDiameter: TTrackBar;
    TrackBar_KCMTexturePaint_InnerDiameter: TTrackBar;
    TrackBar_KCMTexturePaint_Intensity: TTrackBar;
    RadioButton_KCMTexturPaint_Whiten: TRadioButton;
    RadioButton_KCMTexturPaint_Darken: TRadioButton;
    ComboBox_TextureMap: TComboBox;
    Image_KCMTextuePaint_BrushPreview: TImage;

    //OPL general
    GroupBox_OPL: TGroupBox;
    GroupBox_OPL_Model: TGroupBox;
    Edit_OPL_Model: TEdit;
    GroupBox_OPL_Position: TGroupBox;
    Edit_OPL_PosX: TEdit;
    Edit_OPL_PosY: TEdit;
    Edit_OPL_PosZ: TEdit;
    Label_OPL_PosX: TLabel;
    Label_OPL_PosY: TLabel;
    Label_OPL_PosZ: TLabel;
    GroupBox_OPL_Rotation: TGroupBox;
    Label_OPL_RotationX: TLabel;
    Label_OPL_RotationY: TLabel;
    Label_OPL_RotationZ: TLabel;
    Label_OPL_RotationW: TLabel;
    Edit_OPL_RotationW: TEdit;
    GroupBox_OPL_Scale: TGroupBox;
    Label_OPL_ScaleX: TLabel;
    Label_OPL_ScaleY: TLabel;
    Label_OPL_ScaleZ: TLabel;
    Edit_OPL_ScaleX: TEdit;
    Edit_OPL_ScaleY: TEdit;
    Edit_OPL_ScaleZ: TEdit;

    //ToolBar
    ToolBar_3DShow: TToolBar;
    CoolBar_3DShow: TCoolBar;
    Panel_ToolBar: TPanel;
    CheckBox_ShowWater: TCheckBox;
    CheckBox_ShowOPLNodes: TCheckBox;
    CheckBox_OPL_Position_STM: TCheckBox;
    CheckBox_LockBorders: TCheckBox;
    CheckBox_StickOPLtoKCM: TCheckBox;
    CheckBox_CoordSys: TCheckBox;

    //KSM Panel
    GroupBox_KSMOPLBased: TGroupBox;
    Label_KSMOpl_PaintSize: TLabel;
    Label_KSMOpl_ColorToPaint: TLabel;
    Image_KSMOpl_Color: TImage;
    TrackBar_KSMOpl_PaintSize: TTrackBar;
    GroupBox_KSMOpl_GeneralValue: TGroupBox;
    RadioButton_KSMOpl_Gen_Normal: TRadioButton;
    RadioButton_KSMOpl_Gen_NoMob: TRadioButton;
    GroupBox_KSMOpl_SpecifiedValue: TGroupBox;
    RadioButton_KSMOpl_Spe_NoSpec: TRadioButton;
    RadioButton_KSMOpl_Spe_OneWayPortal: TRadioButton;
    RadioButton_KSMOpl_Spe_TwoWayPortal: TRadioButton;
    RadioButton_KSMOpl_Spe_Town: TRadioButton;
    RadioButton_KSMOpl_Spe_PKFree: TRadioButton;
    RadioButton_KSMOpl_Spe_Castle: TRadioButton;
    Button_KSMOpl_Paint: TButton;

    MainMenu: TMainMenu;
    MainMenu_File: TMenuItem;
    MainMenu_File_LoadKCMFile: TMenuItem;
    MainMenu_File_SaveKCMFile: TMenuItem;
    MainMenu_File_SaveKCMFileAs: TMenuItem;
    N1: TMenuItem;
    MainMenu_File_LoadKSMFile: TMenuItem;
    MainMenu_File_SaveKSMFile: TMenuItem;
    MainMenu_File_SaveKSMFileAs: TMenuItem;
    MainMenu_File_NewKSMFile: TMenuItem;
    N2: TMenuItem;
    MainMenu_File_LoadOPLFile: TMenuItem;
    MainMenu_File_SaveOPLFile: TMenuItem;
    MainMenu_File_SaveOPLFileAs: TMenuItem;
    GLDummyCube_OPLObjects: TGLDummyCube;
    MainMenu_KCMFile: TMenuItem;
    MainMenu_KCMFile_TextureCenter: TMenuItem;
    MainMenu_KCMFile_BorderCenter: TMenuItem;
    MainMenu_KCMFile_HeaderInfo: TMenuItem;
    MainMenu_KCMFile_RenderColorMap: TMenuItem;
    MainMenu_OPLFile: TMenuItem;
    GLSphere1: TGLSphere;
    GLHUDTextX: TGLHUDText;
    GLHUDTextY: TGLHUDText;
    GLHUDTextZ: TGLHUDText;
    Font: TGLWindowsBitmapFont;
    XPManifest1: TXPManifest;
    GLCamera: TGLCamera;
    PopupMenu_CoordinateSys: TPopupMenu;
    MainMenu_Options: TMenuItem;
    PopUp_CoordSys_CopyXY: TMenuItem;
    PopUp_CoordSys_CopyXYZ: TMenuItem;
    PopUp_CoordSys_CopyXYSpawn: TMenuItem;
    PopUp_CoordSys_CopyX: TMenuItem;
    PopUp_CoordSys_CopyY: TMenuItem;
    PopUp_CoordSys_CopyZ: TMenuItem;
    PopupMenu_CoordSys_CopyXYZ: TMenuItem;
    RadioButton_OPLRotation_Z: TRadioButton;
    Edit_OPL_RotationZ: TEdit;
    RadioButton_OPLRotation_Y: TRadioButton;
    Edit_OPL_RotationY: TEdit;
    RadioButton_OPLRotation_X: TRadioButton;
    Edit_OPL_RotationX: TEdit;
    Button_OPLGeneral_Save: TButton;
    CheckBox_OPLGeneral_RotateW: TCheckBox;
    MainMenu_KCM_NewKCMFile: TMenuItem;
    MainMenu_OPLFile_HeaderInfo: TMenuItem;
    MainMenu_OPLFile_AddNode: TMenuItem;
    MainMenu_OPLFile_DeleteNode: TMenuItem;
    MainMenu_OPLFile_DeleteAll: TMenuItem;
    N3: TMenuItem;
    Button_LayerCenter: TButton;
    N4: TMenuItem;
    MainMenu_File_Exit: TMenuItem;
    MainMenu_File_NewOPLFile: TMenuItem;
    GroupBox_KCMSetHeight_Height: TGroupBox;
    TrackBar_KCMSetHeight_Height2: TTrackBar;
    Button_OPL_BrowseModel: TButton;
    GLLightSource1: TGLLightSource;
    CheckBox_ShowOPLModels: TCheckBox;
    GLMaterialLibrary: TGLMaterialLibrary;
    CheckBox_ShowOPLTextures: TCheckBox;
    Timer_AutoSave: TTimer;
    GroupBox_KCMGrassPaint: TGroupBox;
    Label_KCMGrassPaint_Type: TLabel;
    Trackbar_KCMGrassPaint_Type: TTrackBar;
    Label_KCMGrassPaint_Intensity: TLabel;
    Trackbar_KCMGrassPaint_Intensity: TTrackBar;
    Label_KCMGrassPaint_AreaDiameter: TLabel;
    TrackBar_KCMGrassPaint_Diameter: TTrackBar;
    RadioButton_KCMGrassPaint_Spawn: TRadioButton;
    RadioButton_KCMGrassPaint_Remove: TRadioButton;
    GLDummyCube_Center: TGLDummyCube;


    //General
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CreateIndicator;
    procedure CreateWater;
    procedure Image_GeneralMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);

    //HeightField Painters
    procedure GLHeightFieldPaintColorMap(const x, y: Single; var z: Single;var color: TVector4f; var texPoint: TTexPoint);
    procedure GLHeightFieldPaintKSMMap(const x, y: Single; var z: Single;var color: TVector4f; var texPoint: TTexPoint);
    procedure GLHeightFieldPaintTextureMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
    procedure GLHeightFieldPaintMiniMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
    procedure GLHeightFieldPaintCustomPic(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
    procedure GLHeightFieldPaintObjectMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);

    //View controls
    procedure GLSceneViewerMouseMove(Sender: TObject; Shift: TShiftState;X, Y: Integer);
    procedure GLSceneViewerMouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;MousePos: TPoint; var Handled: Boolean);

    //MainMenu_Click Events
    procedure MainMenu_FileClick(Sender: TObject);
    procedure MainMenu_File_LoadKCMFileClick(Sender: TObject);
    procedure MainMenu_File_LoadKSMFileClick(Sender: TObject);
    procedure MainMenu_File_LoadOPLFileClick(Sender: TObject);
    procedure MainMenu_File_SaveKCMfileClick(Sender: TObject);
    procedure MainMenu_File_SaveKSMFileClick(Sender: TObject);
    procedure MainMenu_File_SaveOPLFileClick(Sender: TObject);
    procedure MainMenu_File_SaveKSMFileasClick(Sender: TObject);
    procedure MainMenu_File_ExitClick(Sender: TObject);
    procedure MainMenu_KCMFileClick(Sender: TObject);
    procedure MainMenu_KCMFile_TextureCenterClick(Sender: TObject);
    procedure MainMenu_KCMFile_RenderColorMapClick(Sender: TObject);
    procedure MainMenu_OptionsClick(Sender: TObject);

    //General tool requirements
    procedure ListBox_FileClick(Sender: TObject);
    procedure ListBox_FileAspectClick(Sender: TObject);
    procedure RadioButtons_ValuesClick(Sender: TObject);

    //KSMEdit_Brush
    procedure TrackBar_DiameterChange(Sender: TObject);

    //KSMEdit_HeightBased
    procedure KSMHEIGHT_ButtonUpClick(Sender: TObject);
    procedure KSMHEIGHT_ButtonDownClick(Sender: TObject);
    procedure TrackBar_IndicatorHeightChange(Sender: TObject);

    //KCM Set height
    procedure Edit_KCMSetHeight_HeightChange(Sender: TObject);
    procedure TrackBar_KCMSetHeight_HeightChange(Sender: TObject);

    //KCM texture paint
    procedure TrackBar_KCMTexturePaint_OuterDiameterChange(ender: TObject);
    procedure TrackBar_KCMTexturePaint_InnerDiameterChange(Sender: TObject);
    procedure TrackBar_KCMTexturePaint_IntensityChange(Sender: TObject);
    procedure BrushCreate(Brush:TBitmap;InWidth,OutWidth,Intensity:Integer);
    procedure ComboBox_TextureMapClick(Sender: TObject);

    //OPL
    procedure OPLChange(Sender: TObject);
    procedure CheckBox_OPL_Position_STMClick(Sender: TObject);
    procedure GroupBox_OPL_PositionClick(Sender: TObject);
    procedure GroupBox_OPL_RotationClick(Sender: TObject);
    procedure GroupBox_OPL_ModelClick(Sender: TObject);
    procedure GroupBox_OPL_ScaleClick(Sender: TObject);
    procedure AllignGroupBox_OPL;
    procedure PositionOPL(UpdateModels,TrueModels,TrueTextures:Boolean);
    procedure PositionOPLNode(x1:Integer;UpdateModel:Boolean;TrueModel:Boolean = True;TrueTex:Boolean = True);
    procedure DisplayOPLNodeInfo(Nodes:TSelected_OPLs);

    //ToolBar
    procedure CheckBox_ShowWaterClick(Sender: TObject);
    procedure CheckBox_ShowOPLNodesClick(Sender: TObject);
    procedure Button_KSMOpl_PaintClick(Sender: TObject);
    procedure MainMenu_KCMFile_BorderCenterClick(Sender: TObject);
    procedure MainMenu_File_NewKSMFileClick(Sender: TObject);
    procedure MainMenu_OPLFileClick(Sender: TObject);
    procedure MainMenu_OPLFile_DeleteNodeClick(Sender: TObject);
    procedure MainMenu_OPLFile_DeleteAllClick(Sender: TObject);
    procedure MainMenu_OPLFile_AddNodeClick(Sender: TObject);
    procedure CheckBox_CoordSysClick(Sender: TObject);
    procedure PopUp_CoordSys_CopyXYClick(Sender: TObject);
    procedure PopUp_CoordSys_CopyXYZClick(Sender: TObject);
    procedure PopUp_CoordSys_CopyXYSpawnClick(Sender: TObject);
    procedure PopUp_CoordSys_CopyXClick(Sender: TObject);
    procedure PopUp_CoordSys_CopyYClick(Sender: TObject);
    procedure PopUp_CoordSys_CopyZClick(Sender: TObject);
    procedure PopupMenu_CoordSys_CopyXYZClick(Sender: TObject);
    procedure RadioButton_OPLRotationClick(Sender: TObject);
    procedure MainMenu_File_SaveKCMFileAsClick(Sender: TObject);
    procedure CheckBox_OPLGeneral_RotateWClick(Sender: TObject);
    procedure Button_OPLGeneral_SaveClick(Sender: TObject);
    procedure MainMenu_KCMFile_HeaderInfoClick(Sender: TObject);
    procedure MainMenu_OPLFile_HeaderInfoClick(Sender: TObject);
    procedure MainMenu_KCM_NewKCMFileClick(Sender: TObject);
    procedure Button_LayerCenterClick(Sender: TObject);

    procedure ResetRealm;
    procedure MainMenu_File_NewOPLFileClick(Sender: TObject);
    procedure MainMenu_File_SaveOPLFileAsClick(Sender: TObject);
    procedure Button_OPL_BrowseModelClick(Sender: TObject);
    procedure CheckBox_ShowOPLModelsClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit_OPL_ModelKeyPress(Sender: TObject; var Key: Char);
    procedure Timer_AutoSaveTimer(Sender: TObject);
    procedure CheckBox_ShowOPLTexturesClick(Sender: TObject);

  private
    Previous_KCM:Array[0..9] of TKCMHeightMap;
    Nilled_KCM:TKCMHeightMap;
    //Previous_KSM:Array[0..9] of TKalServerMap;
    //Previous_OPL:Array[0..9] of TOPLFile;
  public
    FBrush,FPBrush,KCMMinimap,KCMCustomPic:TBitmap;

    KCM           :TKalClientMap;
    KSM           :TKalServerMap;
    env         :TKalEnvironmentFile;
    map           :TKSMMap;
    Client_Path, MainSvr_Path, KSMInital_Path,KCMInital_Path :String;
    CurTMap       :Integer;
    OPL           :TOPLFile;
    TOOL,Tool_Old: TKWETool;
    GroupBox_OPL_Position_Big,GroupBox_OPL_Model_Big,GroupBox_OPL_Rotation_Big,GroupBox_OPL_Scale_Big:Boolean;
    UseOldCenter:Boolean;
  end;
var
  Form_Main: TForm_Main;
  ViewX,Viewy:Integer;
  FMin, FMax,c   : TAffineVector;
  Values:TValues;
  CoordSys_X,CoordSys_Y,CoordSys_Z:Integer;
  Selected_OPLs: TSelected_OPLs;



implementation

uses Unit2, Unit3, Unit_SplashScreen, Unit4, Unit5, Unit6, Unit7, Unit8,
  Unit9, Unit10;

{$R *.dfm}

procedure TForm_Main.FormCreate(Sender: TObject);
var
  Size:Integer;
  x,y:Integer;
  reg: TRegistry;
  ProgressBarStyle: integer;
begin
  //Preparing the Brush, and the PreviewBrush for KCM Texture Paint purpose
  FBrush := TBitmap.Create;
  FBrush.Width:=100;
  FBrush.Height:=100;
  FPBrush := TBitmap.Create;
  FPBrush.Width:=100;
  FPBrush.Height:=100;

  //Preparing Brush Size
  size:=TrackBar_BrushSize.Position;
  
  //GLSphere1.Material.BlendingMode:=bmAdditive;
  GLSphere1.Material.FrontProperties.PolygonMode:=pmPoints;
  GlSphere1.Rotation.X:=-90;
  GLSphere1.Rotation.Y:=0;
  GLSphere1.Rotation.Z:=0;
  GLSphere1.Scale.X:=size;
  GLSphere1.Scale.Y:=size;
  GLSphere1.Scale.Z:=size;

  //Water
  CreateWater;

  //Loading Settings
  try
    INIFile:=TINIFile.Create(ExtractFilePath(Application.ExeName)+Copy(ExtractFileName(Application.ExeName),0,Length(ExtractFileName(Application.ExeName))-Length(ExtractFileExt(Application.ExeName)))+'.ini');
    Client_Path:=INIFile.ReadString('Settings','Client_Path','');
    MainSvr_Path:=INIFile.ReadString('Settings','MainSvr_Path','');
    KCMInital_Path:=INIFile.ReadString('Settings','KCMInital_Path','');
    KSMInital_Path:=INIFile.ReadString('Settings','KSMInital_Path','');
    If INIFile.ReadInteger('Settings','AutoSaveInterval',30) <> 0 then
    begin
      Timer_AutoSave.Interval:= INIFile.ReadInteger('Settings','AutoSaveInterval',30)*1000;
      Timer_AutoSave.Enabled:=True;
    end;
    If MainSvr_Path[Length(MainSvr_Path)]<>'\' then
    begin
      MainSvr_Path:=MainSvr_Path+'\';
    end;
    If Client_Path[Length(Client_Path)]<>'\' then
    begin
      Client_Path:=Client_Path+'\';
    end;
    INIFIle.Free;
  except
  end;
  MessageBox(Handle, pchar('Please check if these settings are correct, If not please go to ''Options'' otherwise you get shitloads of errors.'+#13+'Client Path = '+Client_Path+#13+'MainSvr Path = '+MainSvr_Path),PChar('Please verify these settings'),mb_OK);
  //Loading n.env
  If FileExists(Client_Path+'data\MAPS\n.env')then
  begin
    try
      env:=TKalEnvironmentFile.Create;
      env.LoadFromFile(Client_Path+'data\MAPS\n.env');
    except
      MessageBox(Handle,pchar('An error occured when trying to load n.env:'+#13+#13+'- Unknown'),PChar('Error while loading n.env'),mb_OK);
    end;
  end
  else
  begin
    MessageBox(Handle,pchar('An error occured when trying to load n.env:'+#13+#13+'- File doesn''t exisits'+#13+#13+'Please check if file '''+Client_Path+'data\MAPS\n.env'' exists'),PChar('File doesn''t exists'),mb_OK);
  end;


  reg := TRegistry.Create;
  reg.RootKey:=HKEY_CLASSES_ROOT;

  {KSM's file association}
  reg.OpenKey('.kcm',True);
  reg.WriteString('','KalWorldEditor.KCM');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.kcm',True);
  reg.WriteString('','KalClientMap');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.KCM\shell\open\command', true);
  reg.WriteString('', '"'+Application.ExeName+'" "%1"');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.KCM\DefaultIcon', true);
  reg.WriteString('', ExtractFilePath(Application.ExeName)+'\Recources\kwe_file[red].ico');
  reg.CloseKey;

  {KSM's file association}
  reg.OpenKey('.ksm',True);
  reg.WriteString('','KalWorldEditor.KSM');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.KSM',True);
  reg.WriteString('','KalServerMap');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.KSM\shell\open\command', true);
  reg.WriteString('', '"'+Application.ExeName+'" "%1"');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.KSM\DefaultIcon', true);
  reg.WriteString('', ExtractFilePath(Application.ExeName)+'\Recources\kwe_file[red].ico');
  reg.CloseKey;

  {OPL's file association}
  reg.OpenKey('.opl',True);
  reg.WriteString('','KalWorldEditor.OPL');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.OPL',True);
  reg.WriteString('','ObjectPositioningList');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.OPL\shell\open\command', true);
  reg.WriteString('', '"'+Application.ExeName+'" "%1"');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.OPL\DefaultIcon', true);
  reg.WriteString('', ExtractFilePath(Application.ExeName)+'\Recources\kwe_file[red].ico');
  reg.CloseKey;

  reg.free;

  //Making sure KSM Brush color etc is filled;
  Values[1]:=0;
  Values[2]:=0;
  For x:=0 to Image_ColorDraw1.Width do
  begin
    For y:=0 to Image_ColorDraw1.Height do
    begin
      Image_ColorDraw1.Canvas.Pixels[x,y]:=KSM.ValuesToColor(Values[1],Values[2]);
      Image_ColorDraw2.Canvas.Pixels[x,y]:=KSM.ValuesToColor(Values[1],Values[2]);
      Image_KSMOPL_Color.Canvas.Pixels[x,y]:=KSM.ValuesToColor(Values[1],Values[2]);
    end;
  end;
end;

procedure TForm_Main.FormShow(Sender: TObject);
var
  x1,y1,x2:Integer;
  ext:Extended;
begin
  //Checking the parameters for files
  If ParamCount > 0 then
  begin
    For x1:=0 to ParamCount do
    begin
      If LowerCase(ExtractFileExt(ParamStr(x1)))='.kcm' then
      begin
        if KCM=nil then
        begin
          If FileExists(ParamStr(x1)) then
          begin
            KCM:=TKalClientMap.Create;
            KCM.LoadFromFile(ParamStr(x1));
            If KSM<>nil then
            begin
              If MessageBox(Handle, pchar('An KSM file has been loaded, want to paint the KCM file with it?'),'Paint?',MB_YESNO) = IDYES then
              begin
                //Want to paint KSM on Heightmap
                GLHeightField.OnGetHeight:=GLHeightFieldPaintKSMmap;
                GLHeightField.StructureChanged;
              end
              else
              begin
                //Dont want to paint KSM on Heightmap
                GLHeightField.OnGetHeight:=GLHeightFieldPaintColormap;
                GLHeightField.StructureChanged;
              end;
            end
            else
            begin
              //If no KSM is loaded painting color map
              GLHeightField.OnGetHeight:=GLHeightFieldPaintColormap;
              GLHeightField.StructureChanged;
            end;
          end;
        end
        else
        begin
          MessageBox(Handle, pchar('An KCM File has already been loaded, can''t load 2 KCM files.'),'Error',MB_OK);
        end;
      end;
      If LowerCase(ExtractFileExt(ParamStr(x1)))='.ksm' then
      begin
        If FileExists(ParamStr(x1)) then
        begin
          If KSM=nil then
          begin
            KSM:=TKalServerMap.Create;
            KSM.LoadFromFile(ParamStr(x1));
            map:=KSM.map;
            for x2:=0 to 255 do
            begin
              for y1:=0 to 255 do
              begin
                Image_General.Canvas.Pixels[x2,y1]:=KSM.map[x2][y1][2];
              end;
            end;

            If KCM<>nil then
            begin
              If MessageBox(Handle, pchar('An KCM file has been loaded, want to paint the KSM file over it?'),'Paint?',MB_YESNO) = IDYES then
              begin
                GLHeightField.OnGetHeight:=GLHeightFieldPaintKSMmap;
                GLHeightField.StructureChanged;
              end;
            end;
          end
          else
          begin
            MessageBox(Handle, pchar('An KSM File has already been loaded, can''t load 2 KSM files.'),'Error',MB_OK);
          end;
        end;
      end;
      If LowerCase(ExtractFileExt(ParamStr(x1)))='.opl' then
      begin
        If FileExists(ParamStr(x1)) then
        begin
          If OPL=nil then
          begin
            OPL:=TOPLFile.Create;
            OPL.LoadFromFile(ParamStr(x1));
            CheckBox_StickOPLtoKCM.Enabled:=True;
            CheckBox_ShowOPLNodes.Enabled:=True;
            CheckBox_ShowOPLNodes.Checked:=True;


            PositionOPL(True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

          end
          else
          begin
            MessageBox(Handle, pchar('An OPL File has already been loaded, can''t load 2 OPL files.'),'Error',MB_OK);
          end;
        end;
      end;
    end;
  end;
  ResetRealm;
end;

procedure TForm_Main.CreateIndicator;
var
  p1, p2, p3, p4: TVertexdata;
  col1, col2, col3, col4: TVector4F;
  lFaceGroup: TFGVertexIndexList;
  lMeshObj: TMeshObject;
begin
  GLFreeForm_Indicator.MeshObjects.Clear;

  lMeshObj := TMeshObject.CreateOwned(GLFreeForm_Indicator.MeshObjects);
  lMeshObj.Mode := momFaceGroups;

  lFaceGroup := TFGVertexIndexList.CreateOwned(lMeshObj.FaceGroups);

  p1.coord[0] := 0;
  p1.coord[1] := 0;
  p1.coord[2] := 0;
  col1[0] := 1 / 255;
  col1[1] := 255 / 255;
  col1[2] := 1 / 255;

  p2.coord[0] := 255;
  p2.coord[1] := 0;
  p2.coord[2] := 0;
  col2[0] := 1 / 255;
  col2[1] := 255 / 255;
  col2[2] := 1 / 255;

  p3.coord[0] := 0;
  p3.coord[1] := 0;
  p3.coord[2] := 255;
  col3[0] := 1 / 255;
  col3[1] := 255 / 255;
  col3[2] := 1 / 255;

  p4.coord[0] := 255;
  p4.coord[1] := 0;
  p4.coord[2] := 255;
  col4[0] := 1 / 255;
  col4[1] := 255 / 255;
  col4[2] := 1 / 255;

  lMeshObj.Vertices.Add(p1.coord);
  lMeshObj.Vertices.Add(p2.coord);
  lMeshObj.Vertices.Add(p3.coord);
  lMeshObj.Vertices.Add(p4.coord);

  lMeshObj.Colors.Add(col1);
  lMeshObj.Colors.Add(col2);
  lMeshObj.Colors.Add(col3);
  lMeshObj.Colors.Add(col4);

  lFaceGroup.Add(lMeshObj.Vertices.Count - 2);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 1);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 3);

  lFaceGroup.Add(lMeshObj.Vertices.Count - 3);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 4);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 2);

  GLFreeForm_Indicator.StructureChanged;
end;

procedure TForm_Main.CreateWater;
var
  p1, p2, p3, p4: TVertexdata;
  col1, col2, col3, col4: TVector4F;
  lFaceGroup: TFGVertexIndexList;
  lMeshObj: TMeshObject;
begin
  GLFreeForm_Water.MeshObjects.Clear;

  lMeshObj := TMeshObject.CreateOwned(GLFreeForm_Water.MeshObjects);
  lMeshObj.Mode := momFaceGroups;

  lFaceGroup := TFGVertexIndexList.CreateOwned(lMeshObj.FaceGroups);

  p1.coord[0] := 0;
  p1.coord[1] := 0;
  p1.coord[2] := 0;
  col1[0] := 1 / 255;
  col1[1] := 100 / 255;
  col1[2] := 255 / 255;

  p2.coord[0] := 255;
  p2.coord[1] := 0;
  p2.coord[2] := 0;
  col2[0] := 1 / 255;
  col2[1] := 100 / 255;
  col2[2] := 255 / 255;

  p3.coord[0] := 0;
  p3.coord[1] := 0;
  p3.coord[2] := 255;
  col3[0] := 1 / 255;
  col3[1] := 100 / 255;
  col3[2] := 255 / 255;

  p4.coord[0] := 255;
  p4.coord[1] := 0;
  p4.coord[2] := 255;
  col4[0] := 1 / 255;
  col4[1] := 100 / 255;
  col4[2] := 255 / 255;

  lMeshObj.Vertices.Add(p1.coord);
  lMeshObj.Vertices.Add(p2.coord);
  lMeshObj.Vertices.Add(p3.coord);
  lMeshObj.Vertices.Add(p4.coord);

  lMeshObj.Colors.Add(col1);
  lMeshObj.Colors.Add(col2);
  lMeshObj.Colors.Add(col3);
  lMeshObj.Colors.Add(col4);

  lFaceGroup.Add(lMeshObj.Vertices.Count - 2);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 1);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 3);

  lFaceGroup.Add(lMeshObj.Vertices.Count - 3);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 4);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 2);

  GLFreeForm_Water.StructureChanged;
end;



procedure TForm_Main.GLSceneViewerMouseMove(Sender: TObject;Shift: TShiftState; X, Y: Integer);
var
  TixX,TixY       : Integer;
  v,u : TAffineVector;
  x1,y1:Integer;
  x2,y2,z2:single;
  TinT:byte;
  maxX,maxy,minX,minY:SmallInt;
  helling,invhelling,i,j,moveX,moveY:single;
  s,w,g,multiply:single;
  KCMHeightMap:TKCMHeightMap;
  TextureMap:TKCMTextureMapList;
  cnt,selected:integer;
  OPLNode:TOPLNode;
  Vector3F:TVector3F;
  Vector4F:TVector4F;
  Point:TPoint;
  ObjMap:TKCMObjectMap;
  dX,dY:Single;
  Model:TGLFreeForm;
  Center:TVector3F;
const
  PI:Extended=3.1415926535897932384626433;
begin
  //Getting mouse cursor position, and
  GLSceneViewer.Cursor:=crDefault;

  Try
    GLDummyCube_OPLObjects.Visible:=False;
    u:=GLSceneViewer.Buffer.PixelRayToWorld(x, y);
    v:=GLHeightField.AbsoluteToLocal(u);
    GLDummyCube_OPLObjects.Visible:=True;

    If KCM<>nil then
    begin
      CoordSys_X:=round((KCM.Header.MapX*8192)+(32*v[0]));
      CoordSys_Y:=round((KCM.Header.MapY*8192)+(8192-(32*v[1])));
      CoordSys_Z:=round(320*-v[2]);
    end;

    GLHudTextX.Text:='X '+IntToStr(CoordSys_X);
    GLHudTextY.Text:='Y '+IntToStr(CoordSys_Y);
    GLHudTextZ.Text:='Z '+IntToStr(CoordSys_Z);
  except
    GLSphere1.Visible:=False;
  end;

  //Making sure no crazy shit happends
  If (ssRight in shift) and (ssLeft in Shift) then
  begin
    Abort;
  end;

  //Positioning the Sphere
  If (ssCtrl in shift) then
  begin

    //Working when GLSphere1.Owner = HeightField
    GlSphere1.Position.X:=v[0];
    GLSphere1.Position.Y:=v[1];
    If (v[0]>0) and (v[0]<256) and (v[1]>0) and (v[1]<256) then
    begin
      GlSphere1.Position.Z:=-KCM.HeightMap[round(v[0])][round(v[1])]/32;
    end;

    //Showing or hiding the sphere, depending on the tool
    GLSphere1.Visible:=True;
    If (Tool=tOPL_Position) or (Tool=tOPL_Scale) or (Tool=null) or (tool=tOPL_AddNode) or (tool=tOPL_RotateY) then
    begin
      GLSphere1.Visible:=False;
    end;

    //Activating the Tools, if its moving, and the coords are in bound;
    If (ssLeft in Shift) and (v[0]>0) and (v[0]<256) and (v[1]>0) and (v[1]<256) then
    begin
      //Getting all coords heights...
      maxX:= round(GLSphere1.Position.x+(GLSphere1.Radius*GLSphere1.Scale.X));
      maxY:= round(GLSphere1.Position.y+(GLSphere1.Radius*GLSphere1.Scale.Y));

      minX:= round(GLSphere1.Position.x-(GLSphere1.Radius*GLSphere1.Scale.X));
      minY:= round(GLSphere1.Position.y-(GLSphere1.Radius*GLSphere1.Scale.y));

      //Putting locks on the range
      If Tool=tOPL_Position then
      begin
        maxX:= round(GLSphere1.Position.x+2);
        maxY:= round(GLSphere1.Position.y+2);

        minX:= round(GLSphere1.Position.x-2);
        minY:= round(GLSphere1.Position.y-2);
      end;

      //Putting locks on the range
      If maxX>255 then begin
        maxX:=256;
        If CheckBox_LockBorders.Checked=True then
        begin
          maxX:=255;
        end;
        If Tool=tKSM_PaintBrush then
        begin
          maxX:=MaxX-1;
        end;
      end;
      If maxY>255 then begin
        maxY:=256;
        If CheckBox_LockBorders.Checked=True then
        begin
          maxY:=255;
        end;
        If Tool=tKSM_PaintBrush then
        begin
          maxY:=MaxY-1;
        end;
      end;
      If minX<1 then begin
        minX:=0;
        If CheckBox_LockBorders.Checked=True then
        begin
          minX:=1;
        end;
      end;
      If minY<1 then begin
        minY:=0;
        If CheckBox_LockBorders.Checked=True then
        begin
          minY:=1;
        end;
      end;

      //KSMBrush------------------------------------------------------------------------------
      If TOOL=tKSM_PaintBrush then
      begin
        For x1:=MinX to MaxX do
        begin
          For y1:=MinY to MaxY do
          begin
            //x2 & y2 will represend the delta ( diffrence in ) distance.
            x2:=GLSphere1.Position.x-x1;
            y2:=GLSphere1.Position.y-y1;

            //Calculating the real distance between the points
            s:=Sqrt((x2*x2)+(y2*y2));

            If ((GLSphere1.Scale.X*GLSphere1.Radius)>= s) then
            begin
              map[x1][y1][0]:=Values[1];
              map[x1][y1][1]:=Values[2];
              map[x1][y1][2]:=KSM.ValuesToColor(Values[1],Values[2]);

              //Using this way instead of "ServerMapToImage(KSM.Map,Image_General);" Because its 25x faster :)
              Image_General.Canvas.Pixels[x1,y1]:= map[x1][y1][2];
            end;
          end;
        end;
        KSM.Map:=map;
        KSM.Saved:=False;

        GLHeightField.StructureChanged;
      end;

      //KCMFlatten------------------------------------------------------------------------------
      If TOOL=tKCM_Flatten then
      begin
        Try
          KCMHeightMap:=KCM.HeightMap;
          For x1:=MinX to MaxX do
          begin
            For y1:=MinY to MaxY do
            begin
              //x2 & y2 will represend the delta ( diffrence in ) distance.
              x2:=GLSphere1.Position.x-x1;
              y2:=GLSphere1.Position.y-y1;

              //Calculating the real distance between the points
              s:=Sqrt((x2*x2)+(y2*y2));

              If ((GLSphere1.Scale.X*GLSphere1.Radius)>= s)then
              begin
                cnt:=0;
                w:=0;
                If (x1+1>=0) and (x1+1<=256) and (y1+1>=0) and (y1+1<=256)then
                begin
                  w:=w+KCM.HeightMap[x1+1][y1+1];
                  cnt:=cnt+1;
                end;
                If (x1  >=0) and (x1  <=256) and (y1+1>=0) and (y1+1<=256)then
                begin
                  w:=w+KCM.HeightMap[x1][y1+1];
                  cnt:=cnt+1;
                end;
                If (x1-1>=0) and (x1-1<=256) and (y1+1>=0) and (y1+1<=256)then
                begin
                  w:=w+KCM.HeightMap[x1-1][y1+1];
                  cnt:=cnt+1;
                end;
                If (x1+1>=0) and (x1+1<=256) and (y1  >=0) and (y1  <=256)then
                begin
                  w:=w+KCM.HeightMap[x1+1][y1];
                  cnt:=cnt+1;
                end;
                If (x1-1>=0) and (x1-1<=256) and (y1  >=0) and (y1  <=256)then
                begin
                  w:=w+KCM.HeightMap[x1-1][y1];
                  cnt:=cnt+1;
                end;
                If (x1+1>=0) and (x1+1<=256) and (y1-1>=0) and (y1-1<=256)then
                begin
                  w:=w+KCM.HeightMap[x1+1][y1-1];
                  cnt:=cnt+1;
                end;
                If (x1  >=0) and (x1  <=256) and (y1-1>=0) and (y1-1<=256)then
                begin
                  w:=w+KCM.HeightMap[x1][y1-1];
                  cnt:=cnt+1;
                end;
                If (x1-1>=0) and (x1-1<=256) and (y1-1>=0) and (y1-1<=256)then
                begin
                  w:=w+KCM.HeightMap[x1-1][y1-1];
                  cnt:=cnt+1;
                end;

                w:=w/cnt;
                KCMHeightMap[x1][y1]:=round(w);
              end;
            end;
          end;
          KCM.HeightMap:=KCMHeightMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
        except
        end;
      end;

      //KCMSetHeight------------------------------------------------------------------------------
      //x1 & y1 will make sure we run every point in the radius.
      If TOOL=tKCM_SetHeight then
      begin
        Try
          KCMHeightMap:=KCM.HeightMap;
          For x1:=MinX to MaxX do
          begin
            For y1:=MinY to MaxY do
            begin
              //x2 & y2 will represend the delta ( diffrence in ) distance.
              x2:=GLSphere1.Position.x-x1;
              y2:=GLSphere1.Position.y-y1;

              //Calculating the real distance between the points
              s:=Sqrt((x2*x2)+(y2*y2));
              If ((GLSphere1.Scale.X*GLSphere1.Radius)>= s) then
              begin
                Try
                  //map[x1][y1]:=StrToInt(Edit_KCMSetHeight_Height.Text);
                  g:=StrToInt(Edit_KCMSetHeight_Height.Text)-KCMHeightMap[x1][y1];

                  KCMHeightMap[x1][y1]:=KCMHeightMap[x1][y1]+round(g*0.2);
                except
                end;
              end;
            end;
          end;
          KCM.HeightMap:=KCMHeightMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
        except
        end;
      end;

      //KCMHeight------------------------------------------------------------------------------
      If TOOL=tKCM_HeightBrush then
      begin
        //x1 & y1 will make sure we run every point in the radius.
        Try
          KCMHeightMap:=KCM.HeightMap;
          For x1:=MinX to MaxX do
          begin
            For y1:=MinY to MaxY do
            begin
              //x2 & y2 will represend the delta ( diffrence in ) distance.
              x2:=GLSphere1.Position.x-x1;
              y2:=GLSphere1.Position.y-y1;

              //Calculating the real distance between the points
              s:=Sqrt((x2*x2)+(y2*y2));

              If (RadioButton_KCMHEIGHT_UP.Checked=True) AND ((GLSphere1.Scale.X*GLSphere1.Radius)>= s) then
              begin
                //Getting the formulla set up right multiplyer*(10-((W*S)*(W*S)));
                w:=(((GLSphere1.Scale.X*GLSphere1.Radius)/2)/Sqrt(2))/(((GLSphere1.Scale.X*GLSphere1.Radius)/2)*((GLSphere1.Scale.X*GLSphere1.Radius)/2));
                multiply:=TrackBar_KCMHEIGHT_Intensity.Position/1000;

                //Check and apply
                If round(KCM.HeightMap[x1][y1]+(multiply*(2-(Power(W*S,2))))) > 65534 then
                begin
                  KCMHeightMap[x1][y1]:=  65534;
                end
                else
                begin
                  KCMHeightMap[x1][y1]:=round(KCMHeightMap[x1][y1]+(multiply*(2-(Power(W*S,2)))));
                end;
              end;
              If (RadioButton_KCMHEIGHT_down.Checked=True) AND ((GLSphere1.Scale.X*GLSphere1.Radius)>= s) then
              begin
                //Getting the formulla set up right multiplyer*(10-((W*S)*(W*S)));
                w:=(((GLSphere1.Scale.X*GLSphere1.Radius)/2)/Sqrt(2))/(((GLSphere1.Scale.X*GLSphere1.Radius)/2)*((GLSphere1.Scale.X*GLSphere1.Radius)/2));
                multiply:=TrackBar_KCMHEIGHT_Intensity.Position/1000;

                //Check and apply
                If round(KCM.Heightmap[x1][y1]-(multiply*(2-(Power(W*S,2))))) <= 0 then
                begin
                  KCMHeightMap[x1][y1]:= 0;
                end
                else
                begin
                  KCMHeightMap[x1][y1]:=round(KCMHeightMap[x1][y1]-(multiply*(2-(Power(W*S,2)))));
                end;
              end;
            end;
          end;
          KCM.HeightMap:=KCMHeightMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
        except
        end;
      end;

      //KCMMove Map------------------------------------------------------------------------------
      If TOOL=tKCM_WholeMap then
      begin
        //x1 & y1 will make sure we run every point in the radius.
        Try
          KCMHeightMap:=KCM.HeightMap;
          If CheckBox_LockBorders.Checked=True then
          begin
            i:=1;
          end
          else
          begin
            i:=0;
          end;

          s:=(ViewY-Y)*1;

          For x1:=round(0+i) to round(256-i) do
          begin
            For y1:=round(0+i) to round(256-i) do
            begin
              If round(KCMHeightMap[x1][y1]+s)>=65534 then
              begin
                KCMHeightMap[x1][y1]:=65534;
              end
              else
              begin
                If round(KCMHeightMap[x1][y1]+s)<=0 then
                begin
                  KCMHeightMap[x1][y1]:=0;
                end
                else
                begin
                  KCMHeightMap[x1][y1]:=round(KCMHeightMap[x1][y1]+s);
                end;
              end;
            end;
          end;
          KCM.HeightMap:=KCMHeightMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
        except
        end;
      end;

      //KCMTexturePaint----------------------------------------------------------------
      //x1 & y1 will make sure we run every point in the radius.
      If TOOL=tKCM_TexturePaint then
      begin
        Try
          TextureMap:=KCM.TextureMapList;
          For x1:=MinX to MaxX do
          begin
            For y1:=MinY to MaxY do
            begin
              //x2 & y2 will represend the delta ( diffrence in ) distance.
              x2:=GLSphere1.Position.x-x1;
              y2:=GLSphere1.Position.y-y1;

              try
                If RadioButton_KCMTexturPaint_Whiten.Checked=True then
                begin
                  If TextureMap[CurTMap][x1][y1]+(255-getRValue(FBrush.Canvas.Pixels[25+round(x2),25+round(y2)]))<255 then
                  begin
                    TextureMap[CurTMap][x1][y1]:=TextureMap[CurTMap][x1][y1]+(255-getRValue(FBrush.Canvas.Pixels[25+round(x2),25+round(y2)]));
                  end
                  else
                  begin
                    TextureMap[CurTMap][x1][y1]:=255;
                  end
                end;
                If RadioButton_KCMTexturPaint_Darken.Checked=True then
                begin
                  If TextureMap[CurTMap][x1][y1]-(255-getRValue(FBrush.Canvas.Pixels[25+round(x2),25+round(y2)]))>0 then
                  begin
                    TextureMap[CurTMap][x1][y1]:=TextureMap[CurTMap][x1][y1]-(255-getRValue(FBrush.Canvas.Pixels[25+round(x2),25+round(y2)]));
                  end
                  else
                  begin
                    TextureMap[CurTMap][x1][y1]:=0;
                  end
                end;
              except
              end;
              //Image_General.Canvas.Pixels[
            end;
          end;

          KCM.TextureMapList:=TextureMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
        except
        end;
      end;
      //KCMTexturePaint----------------------------------------------------------------
      //x1 & y1 will make sure we run every point in the radius.
      If TOOL=tKCM_GrassPaint then
      begin
        Try
          ObjMap:=KCM.ObjectMap;
          For x1:=MinX to MaxX do
          begin
            For y1:=MinY to MaxY do
            begin
              //x2 & y2 will represend the delta ( diffrence in ) distance.
              x2:=GLSphere1.Position.x-x1;
              y2:=GLSphere1.Position.y-y1;

              //Calculating the real distance between the points
              s:=Sqrt((x2*x2)+(y2*y2));

              If ((GLSphere1.Scale.X*GLSphere1.Radius)>= s) then
              begin
                If RadioButton_KCMGrassPaint_Spawn.Checked=True then
                begin
                  If Random(200-Trackbar_KCMGrassPaint_Intensity.Position*3)=0 then
                  begin
                    cnt:=Random(TrackBar_KCMGrassPaint_Type.Position);
                    If cnt<>0 then
                    begin
                      ObjMap[x1][y1]:=cnt;
                    end;
                  end;
                end
                else
                begin
                  If Random(round(200-Trackbar_KCMGrassPaint_Intensity.Position*3.99))=0 then
                  begin
                    ObjMap[x1][y1]:=0;
                  end;
                end;
              end;
            end;
          end;

          KCM.ObjectMap:=ObjMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
        except
        end;
      end;

      //OPLPosition----------------------------------------------------------------
      If TOOL=tOPL_Position then
      begin
        GLSceneViewer.Cursor:=crHandPoint;
        //try
          If (ssLeft in shift) then
          begin
            //Geting pos of first selected node...
            Vector3F:=OPL.Node[Selected_OPLs[0].Index].Position;

            //Detla x and y
            //dx:=(u[0]/256)-Vector3F[0];
            //dy:=(1-(u[2]/256))-Vector3F[1];
            dx:=(u[0]/256)-(c[0]/256);//-Vector3F[0];
            dy:=(1-(u[2]/256))-(1-(c[2]/256));//-Vector3F[1];

            For x1:=0 to Length(Selected_OPLs)-1 do
            begin
              //Loading the position, editing it and applying it back at the node..
              Vector3F:=OPL.Node[Selected_OPLs[x1].Index].Position;
              If ((ssShift in shift)=False) Then
              begin
                Vector3F[0]:=Vector3F[0]+dX;
                Vector3F[1]:=Vector3F[1]+dY;
              end;

              If (ssShift in shift) then
              begin
                Vector3F[2]:=Vector3F[2]+((ViewY-Y)/35);
              end
              else
              begin
                If CheckBox_OPL_Position_STM.Checked=True then
                begin
                  Vector3F[2]:=KCM.HeightMap[round(Vector3F[0]*256)][round(256-(Vector3F[1]*256))];
                end;
              end;

              OPL.Node[Selected_OPLs[x1].Index].Position:=Vector3F;

              PositionOPLNode(Selected_OPLs[x1].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

              DisplayOPLNodeInfo(Selected_OPLs);
            end;
            c:=u;
          end;
        //except
        //end;
      end;

      //OPLAddNode--------------------------------------------------------------
      If Tool=tOPL_AddNode then
      begin
        GLSceneViewer.Hint:='Click here to place the new node';
        Point.X:=X;
        Point.Y:=Y;
        Point:=GLSceneViewer.ClientToScreen(Point);
        Application.ActivateHint(Point) ;
      end;

      //OPLRotate--------------------------------------------------------------
      If Tool=tOPL_RotateY then
      begin
        If Length(Selected_OPLs)=1 then
        begin
          //Creating new data
          Vector4F:=OPL.Node[Selected_OPLs[0].Index].Rotation;
          Vector4F[1]:=sin(ArcSin(Vector4F[1])+((ViewX-X)*0.00004));
          Vector4F[3]:=Cos(ArcSin(Vector4F[1]));

          If (Vector4F[1]>0.9999) then
          begin
            Vector4F[1]:=-0.9999;
            Vector4F[3]:=Cos(ArcSin(Vector4F[1]));
          end
          else
          begin
            If (Vector4F[1]<-0.9999) then
            begin
              Vector4F[1]:=0.9999;
              Vector4F[3]:=Cos(ArcSin(Vector4F[1]));
            end;
          end;

          //Saving the newly created data
          OPL.Node[Selected_OPLs[0].Index].Rotation:=Vector4F;

          PositionOPLNode(Selected_OPLs[0].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

          //Displaying the new info;
          DisplayOPLNodeInfo(Selected_OPLs);
        end
        else
        begin
          If Length(Selected_OPLs)=0 then
          begin
            exit;
          end;

          //Caclculating new center if needed
          If UseOldCenter=False then
          begin
            UseOldCenter:=True;

            Center:=OPL.Node[Selected_OPLs[0].Index].Position;
            If Length(Selected_OPLs)>1 then
            begin
              For x1:=1 to Length(Selected_OPLs)-1 do
              begin
                Center[0]:=(Center[0]+OPL.Node[Selected_OPLs[x1].Index].Position[0])/2;
                Center[1]:=(Center[1]+OPL.Node[Selected_OPLs[x1].Index].Position[1])/2;
                Center[2]:=(Center[2]+OPL.Node[Selected_OPLs[x1].Index].Position[2])/2;
              end;
            end;
          end;

          //GLDummyCube.Children[0].Move
          //Appling to all nodes...
          For x1:=0 to Length(Selected_OPLs)-1 do
          begin
            //GLDummyCube_OPLObjects.Children[Selected_OPLs[x1].Index].Dis
            Vector3F:=OPL.Node[Selected_OPLs[x1].Index].Position;

            //Calculating delta distance.. ( notce the switched x/y because of the matrix... )
            y2:=OPL.Node[Selected_OPLs[x1].Index].Position[0]-Center[0];
            x2:=OPL.Node[Selected_OPLs[x1].Index].Position[1]-Center[1];

            //Calculating the real distance between the points
            s:=Sqrt((x2*x2)+(y2*y2));

            //Calculating the current rotation around the center, and adding some...
            i:=1;
            j:=1;
            If x2<0 then
            begin
              i:=-1;
              j:=-1;
            end;
            Vector3F[0]:=Center[0]+(s*(i*Sin((ArcTan(y2/x2))+((ViewX-X)*0.00004))));
            Vector3F[1]:=Center[1]+(s*(j*Cos((ArcTan(y2/x2))+((ViewX-X)*0.00004))));


            //Updating the rotation
            Vector4F:=OPL.Node[Selected_OPLs[x1].Index].Rotation;
            Vector4F[1]:=sin(ArcSin(Vector4F[1])+((ViewX-X)*0.00002));
            Vector4F[3]:=Cos(ArcSin(Vector4F[1]));

            If (Vector4F[1]>0.9999) then
            begin
              Vector4F[1]:=-0.9999;
              Vector4F[3]:=Cos(ArcSin(Vector4F[1]));
            end
            else
            begin
              If (Vector4F[1]<-0.9999) then
              begin
                Vector4F[1]:=0.9999;
                Vector4F[3]:=Cos(ArcSin(Vector4F[1]));
              end;
            end;

            //Saving the infos
            OPL.Node[Selected_OPLs[x1].Index].Rotation:=Vector4F;
            OPL.Node[Selected_OPLs[x1].Index].Position:=Vector3F;

            //Positioning the node..
            PositionOPLNode(Selected_OPLs[x1].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
          end;
        end;
      end;

      {If Tool=tOPL_RotateX then
      begin
        //Creating new data
        Vector4F:=OPL.Node[Selected_OPLNode].Rotation;
        Vector4F[0]:=sin(ArcSin(Vector4F[0])+((ViewX-X)*0.0001));

        //Saving the newly created data
        OPL.Node[Selected_OPLNode].Rotation:=Vector4F;

        PositionOPLNode(Selected_OPLNode,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

        //Displaying the new info;
        DisplayOPLNodeInfo(Selected_OPLNode);
      end;

      If Tool=tOPL_RotateZ then
      begin
        //Creating new data
        Vector4F:=OPL.Node[Selected_OPLNode].Rotation;
        Vector4F[2]:=sin(ArcSin(Vector4F[2])+((ViewX-X)*0.0001));

        //Saving the newly created data
        OPL.Node[Selected_OPLNode].Rotation:=Vector4F;

        PositionOPLNode(Selected_OPLNode,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

        //Displaying the new info;
        DisplayOPLNodeInfo(Selected_OPLNode);
      end;}

      //OPLScale----------------------------------------------------------------
      If TOOL=tOPL_Scale then
      begin
        If Length(Selected_OPLs)=1 then
        begin
          //Loading the scale, editing it and applying it back at the node..
          Vector3F:=OPL.Node[Selected_OPLs[0].Index].Scale;
          If ((Vector3F[0]+((ViewX-X)*0.0001))>0) and ((Vector3F[1]+((ViewX-X)*0.0001))>0) and ((Vector3F[2]+((ViewX-X)*0.0001))>0)then
          begin
            Vector3F[0]:=Vector3F[0]+((ViewX-X)*0.0001);
            Vector3F[1]:=Vector3F[1]+((ViewX-X)*0.0001);
            Vector3F[2]:=Vector3F[2]+((ViewX-X)*0.0001);
          end
          else
          begin
            Vector3F[0]:=0;
            Vector3F[1]:=0;
            Vector3F[2]:=0;
          end;

          //Saving the new scale
          OPL.Node[Selected_OPLs[0].Index].Scale:=Vector3F;

          //Repositioning the node
          PositionOPLNode(Selected_OPLs[0].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

          //Displaying the new info;
          DisplayOPLNodeInfo(Selected_OPLs);
        end
        else
        begin
          If Length(Selected_OPLs)=0 then
          begin
            exit;
          end;

          //Caclculating new center if needed
          If UseOldCenter=False then
          begin
            UseOldCenter:=True;

            Center:=OPL.Node[Selected_OPLs[0].Index].Position;
            If Length(Selected_OPLs)>1 then
            begin
              For x1:=1 to Length(Selected_OPLs)-1 do
              begin
                Center[0]:=(Center[0]+OPL.Node[Selected_OPLs[x1].Index].Position[0])/2;
                Center[1]:=(Center[1]+OPL.Node[Selected_OPLs[x1].Index].Position[1])/2;
                Center[2]:=(Center[2]+OPL.Node[Selected_OPLs[x1].Index].Position[2])/2;
              end;
            end;
          end;

          //Appling to all nodes...
          For x1:=0 to Length(Selected_OPLs)-1 do
          begin
            Vector3F:=OPL.Node[Selected_OPLs[x1].Index].Scale;
            If ((Vector3F[0]+((ViewX-X)*0.0001))>0) and ((Vector3F[1]+((ViewX-X)*0.0001))>0) and ((Vector3F[2]+((ViewX-X)*0.0001))>0)then
            begin
              Vector3F[0]:=Vector3F[0]+((ViewX-X)*0.0001);
              Vector3F[1]:=Vector3F[1]+((ViewX-X)*0.0001);
              Vector3F[2]:=Vector3F[2]+((ViewX-X)*0.0001);

              //Calculating delta distance.. ( note the switched x/y because of the matrix... )
              y2:=OPL.Node[Selected_OPLs[x1].Index].Position[0]-Center[0];
              x2:=OPL.Node[Selected_OPLs[x1].Index].Position[1]-Center[1];
              z2:=OPL.Node[Selected_OPLs[x1].Index].Position[2]-Center[2];

              //Calculating the ratio between the old Distance to center, and Scale
              j:=OPL.Node[Selected_OPLs[x1].Index].Scale[0]/y2;
              i:=OPL.Node[Selected_OPLs[x1].Index].Scale[1]/x2;
              w:=OPL.Node[Selected_OPLs[x1].Index].Scale[2]/z2;

              //Saving the Scale, loading the position
              OPL.Node[Selected_OPLs[x1].Index].Scale:=Vector3F;
              Vector3F:=OPL.Node[Selected_OPLs[x1].Index].Position;

              //Editing the position thanks to the ratio...
              Vector3F[0]:=Center[0]+(j*OPL.Node[Selected_OPLs[x1].Index].Scale[0]);
              Vector3F[1]:=Center[1]+(i*OPL.Node[Selected_OPLs[x1].Index].Scale[1]);
              Vector3F[2]:=Center[2]+(w*OPL.Node[Selected_OPLs[x1].Index].Scale[2]);

              //Saving the position
              OPL.Node[Selected_OPLs[x1].Index].Position:=Vector3F;
            end
            else
            begin
              Vector3F[0]:=0;
              Vector3F[1]:=0;
              Vector3F[2]:=0;
            end;
            PositionOPLNode(Selected_OPLs[x1].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

          end;
        end;
      end;

      //Sticking OPL's on KCM when editing KCM ---------------------------------
      If (tool=tKCM_HeightBrush) or (tool=tKCM_SetHeight) or (tool=tKCM_Flatten) then
      begin
        If (CheckBox_StickOPLtoKCM.Checked=True) then
        begin
          for x1:=0 to OPL.Header.ObjectCount-1 do
          begin
            try
              Vector3F:=OPL.Node[x1].Position;
              Vector3F[2]:=KCM.HeightMap[round(OPL.Node[x1].Position[0]*256)][round(256-(OPL.Node[x1].Position[1]*256))];

              OPL.Node[x1].Position:=Vector3F;

              PositionOPLNode(x1,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
            except
            end;
          end;
        end;
      end;
    end;
  //No CTRL pressed...
  end
  else
  begin
    If (GetKeyState(vk_Shift)and 128)=128 then
    begin
      //Yeah..
    end
    else
    begin
      if (ssLeft in Shift) then
      begin
        GLCamera.MoveAroundTarget((viewY - y)*(GLCamera.DistanceToTarget/400), (viewX - x)*(GLCamera.DistanceToTarget/400));
      end;

      If ssRight in Shift then
      begin
        //Some security, before getting functions
        If ((GLCamera.Position.X-GLDummyCube.Position.X)=0) or ((GLCamera.Position.Z-GLDummyCube.Position.Z)=0) then
        begin
          //Security is needed to activate:
          If (GlCamera.Position.X-GLDummyCube.Position.X)=0 then
          begin
            helling:=999;
            invhelling:=0;
          end;


          If (GlCamera.Position.Z-GLDummyCube.Position.Z)=0 then
          begin
            invhelling:=999;
            helling:=0;
          end;
        end
        else
        begin
          //Getting the functions where the camera, and the dummy should move on
          helling     := ( GLCamera.Position.Z - GLDummyCube.Position.Z ) / ( GLCamera.Position.X - GLDummyCube.Position.X );
          invhelling  :=  - ( 1 / helling );
        end;

        //Getting the direction to move along the function
        If (GLCamera.Position.Z-GLDummyCube.Position.Z)<0 then
        begin
          i:=1;
        end
        else
        begin
          i:=-1;
        end;

        //Getting the direction to move along the invfunction
        If (GLCamera.Position.X-GLDummyCube.Position.X)<0 then
        begin
          j:=-1;
        end
        else
        begin
          j:=1;
        end;

        //Calculating the amount as X to put in the normal function,
        If helling=0 then
        begin
          moveY:=(ViewY-Y);
        end
        else
        begin
          moveY:=SQRT(Power((ViewY-Y),2)/(Power(helling,2)+1));
          If ((ViewY-Y) < 0) and (MoveY > 0) then
          begin
            moveY:=-moveY;
          end;
        end;

        //Calculating the amount as X to put in the invurse function,
        If invhelling=0 then
        begin
          moveX:=-(ViewX-X);
        end
        else
        begin
          moveX:=SQRT(Power((ViewX-X),2)/(Power(invhelling,2)+1));
          If ((ViewX-X) > 0) and (MoveX > 0) then
          begin
            moveX:=-moveX;
          end;
        end;

        //Zoom is involved too...
        moveX:=moveX*(GLCamera.DistanceToTarget/400);
        moveY:=moveY*(GLCamera.DistanceToTarget/400);

        //Moving the camera and the dummy along the function
        GLCamera.Position.Z:=GLCamera.Position.Z+(j*(helling*moveY));
        GlCamera.Position.X:=GLCamera.Position.X+(j*moveY);
        GLDummyCube.Position.Z:=GLDummyCube.Position.Z+(j*(helling*moveY));
        GlDummyCube.Position.X:=GLDummyCube.Position.X+(j*moveY);

        //Moving the camera and the dummy along the invfunction
        GLCamera.Position.Z:=GLCamera.Position.Z+(i*(invhelling*moveX));
        GlCamera.Position.X:=GLCamera.Position.X+(i*moveX);
        GLDummyCube.Position.Z:=GLDummyCube.Position.Z+(i*(invhelling*moveX));
        GlDummyCube.Position.X:=GLDummyCube.Position.X+(i*moveX);
      end;
    end;
    ViewX := X; ViewY := Y;
  end;
end;

procedure TForm_Main.GLSceneViewerMouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  x1:Integer;
  u,v:TAffineVector;
  Vector3F:TVector3F;
  Vector4F:TVector4F;
  OPLNode:TOPLNode;
  Point:TPoint;
  node:integer;

  pick:TGLSceneObject;

  model:TGLFreeForm;

  i,j:Integer;
begin
  //For rotation and scale...
  UseOldCenter:=False;
  
  viewX := x;
  viewY := y;

  u:=GLSceneViewer.Buffer.PixelRayToWorld(x, y);
  c:=u;

  //Ctrl-Z ( previous ) option
  If (ssCtrl in shift ) then
  begin
    For x1:=9 downto 1 do
    begin
      Previous_KCM[x1]:=Previous_KCM[x1-1];
    end;
    Previous_KCM[0]:=KCM.Heightmap;
  end;

  If (tool=tOPL_AddNode) and (Button=mbLeft) then
  begin
    OPLNode:=TOPLNode.Create;

    Vector3F[0]:=u[0]/256;
    Vector3F[1]:=((256-u[2]))/256;
    Vector3F[2]:=KCM.HeightMap[round(u[0])][round(u[2])];
    OPLNode.Position:=Vector3F;

    Vector3F[0]:=1;
    Vector3F[1]:=1;
    Vector3F[2]:=1;
    OPLNode.Scale:=Vector3F;

    Vector4F[0]:=0;
    Vector4F[1]:=0;
    Vector4F[2]:=0;
    Vector4F[3]:=0;
    OPLNode.Rotation:=Vector4F;

    OPL.AddObject(OPLNode);
    OPL.ObjectCount;

    PositionOPLNode(OPL.ObjectCount-1,True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

    // If the key: Control isnt pressed then terminate the tool.
    if (GetKeyState(vk_Control)and 128)<>128 then
    begin
      tool:=tool_Old;
    end;
  end;

  If (tool=tOPL_Scale) or (tool=tOPL_Position) or (tool=tOPL_RotateX) or (tool=tOPL_RotateY) or (tool=tOPL_RotateZ) then
  begin
    If ((GetKeyState(vk_rbutton)and 128)=128 ) or ((GetKeyState(vk_Control)and 128)=128) then
    begin
      exit;
    end;
      //Pick is the clicked object..
      pick:=(GLSceneViewer.Buffer.GetPickedObject(x, y) as TGLSceneObject);

        //Searching for index of the OPL..
        for x1:=0 to GLDummyCube_OPLObjects.Count-1 do
        begin
          if pick=TGLSceneObject(GLDummyCube_OPLObjects.Children[x1]) then
          begin
            if (GetKeyState(vk_Shift)and 128)=128 then
            begin
              for j:=0 to Length(Selected_OPLs)-1 do
              begin
                If x1=Selected_OPLs[j].Index then
                begin
                  //Already got this index... so no need to extract the following code
                  abort;
                end;
              end;
              //Shift is holded, adding a new 'slot' for the node.
              SetLength(Selected_OPLs,Length(Selected_OPLs)+1);
              Selected_OPLs[Length(Selected_OPLs)-1].Index:=x1;
              Selected_OPLs[Length(Selected_OPLs)-1].Tex:=pick.Material.LibMaterialName;
            end
            else
            begin
              //Shift is not holded, reseting all the textures
              for j:=0 to Length(Selected_OPLs)-1 do
              begin
                model:=TGLFreeForm(GLDummyCube_OPLObjects.Children[Selected_OPLs[j].Index]);
                model.Material.LibMaterialName:=Selected_OPLs[j].Tex;
                model.Material.frontproperties.emission.color:=clrblack;
              end;

              //Setting the selected Nodes info
              SetLength(Selected_OPLs,1);
              Selected_OPLs[0].Index:=x1;
              Selected_OPLs[0].Tex:=Pick.Material.LibMaterialName
            end;

            //Overiding a red color, which indicates its selection.
            for j:=0 to Length(Selected_OPLs)-1 do
            begin
              model:=TGLFreeForm(GLDummyCube_OPLObjects.Children[Selected_OPLs[j].Index]);
              model.Material.LibMaterialName:=Selected_OPLs[j].Tex;
              model.Material.LibMaterialName:='';
              model.Material.frontproperties.emission.color:=clrRed;
            end;

            DisplayOPLNodeInfo(Selected_OPLs);

            Abort;
          end;
      end;
  end;
end;

procedure TForm_Main.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;MousePos: TPoint; var Handled: Boolean);
begin
  If Screen.ActiveControl<>nil then
  begin
    Self.ActiveControl:=nil;
  end;
    //GLCamera.AdjustDistanceToTarget(0.9+(((GLCamera.DistanceToTarget/25)-(GLCamera.DistanceToTarget/50))/100));
    GLCamera.AdjustDistanceToTarget(0.9+((10-(GLCamera.DistanceToTarget/50))/100));
end;

procedure TForm_Main.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;MousePos: TPoint; var Handled: Boolean);
begin
  If Screen.ActiveControl<>nil then
  begin
    Self.ActiveControl:=nil;
  end;
  //GLCamera.AdjustDistanceToTarget(1.0+(((GLCamera.DistanceToTarget/25)-(GLCamera.DistanceToTarget/50))/100));
  GLCamera.AdjustDistanceToTarget(1.0+((10-(GLCamera.DistanceToTarget/50))/100));
end;


/////////////////////////////////////////
/////////////MainMenu_Clicks/////////////
/////////////////////////////////////////

procedure TForm_Main.MainMenu_File_LoadKCMFileClick(Sender: TObject);
var
  Openfiledialog:TOpenDialog;
  x,y,x1:Integer;
  status:extended;
begin
  Try
    OpenFileDialog:=TOpenDialog.Create(nil);
    OpenFileDialog.Filter:='Kal Client Maps (*.kcm)|*.kcm;|All files|*.*';
    OpenFileDialog.Title:='Open file...';
    OpenFileDialog.Options:=[ofHideReadOnly,ofEnableSizing];
    OpenFileDialog.InitialDir:=KCMInital_Path;
    If OpenFileDialog.Execute Then
    begin
      If FileExists(OpenFileDialog.FileName) = True then
      begin
        Try
          KCM.Free;
        except
        end;
        KCM:=TKalClientMap.Create;
        KCM.LoadFromFile(OpenFileDialog.FileName);
        If KSM<>nil then
        begin
          If MessageBox(Handle, pchar('An KSM file has been loaded, want to paint the KCM file with it?'),'Paint?',MB_YESNO) = IDYES then
          begin
            //Want to paint KSM on Heightmap
            GLHeightField.OnGetHeight:=GLHeightFieldPaintKSMmap;
            GLHeightField.StructureChanged;
          end
          else
          begin
            //Dont want to paint KSM on Heightmap
            GLHeightField.OnGetHeight:=GLHeightFieldPaintColormap;
            GLHeightField.StructureChanged;
          end;
        end
        else
        begin
          //If no KSM is loaded painting color map
          GLHeightField.OnGetHeight:=GLHeightFieldPaintColormap;
          GLHeightField.StructureChanged;
        end;
        ResetRealm;
      end;
      For x:=0 to 255 do
      begin
        For y:=0 to 255 do
        begin
          Image_General.Canvas.Pixels[x,y]:=rgb(KCM.Colormap[x][y][0],KCM.Colormap[x][y][1],KCM.Colormap[x][y][2]);
        end;
      end;
    end;
  finally
    //ShowMessage((OpenFileDialog.FileName));
    //ShowMessage(  ExtractFilePath(OpenFileDialog.FileName)+Copy(ExtractFileName(OpenFileDialog.FileName),0,Length(ExtractFileName(OpenFileDialog.FileName))-Length(ExtractFileExt(OpenFileDialog.FileName)))+'.opl');
    If FileExists(ExtractFilePath(OpenFileDialog.FileName)+Copy(ExtractFileName(OpenFileDialog.FileName),0,Length(ExtractFileName(OpenFileDialog.FileName))-Length(ExtractFileExt(OpenFileDialog.FileName)))+'.OPL') = true then
    begin
      If MessageBox(Handle, pchar('An OPL file has been found in the same folder, want to load it?'),'OPL loading',MB_YESNO) = IDYES then
      begin
        try
          try
            OPL.Free;
          finally
            OPL:=TOPLFile.Create;

            OPL.LoadFromFile(ExtractFilePath(OpenFileDialog.FileName)+Copy(ExtractFileName(OpenFileDialog.FileName),0,Length(ExtractFileName(OpenFileDialog.FileName))-Length(ExtractFileExt(OpenFileDialog.FileName)))+'.OPL');

            CheckBox_StickOPLtoKCM.Enabled:=True;
            CheckBox_ShowOPLNodes.Enabled:=True;
            CheckBox_ShowOPLModels.Enabled:=True;
            CheckBox_ShowOPLTextures.Enabled:=True;
            CheckBox_ShowOPLNodes.Checked:=True;

            PositionOPL(True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
          end;
        finally
          GLDummyCube_OPLObjects.Visible:=True;
          GLSceneViewer.Enabled:=True;
        end;
      end;
    end;
  end;
end;

procedure TForm_Main.MainMenu_File_LoadKSMFileClick(Sender: TObject);
var
  Openfiledialog:TOpenDialog;
  x2,y1:Integer;
begin

  Try
    OpenFileDialog:=TOpenDialog.Create(nil);
    OpenFileDialog.Filter:='Kal Server Maps (*.ksm)|*.ksm;All files|*.*';
    OpenFileDialog.Title:='Open file...';
    OpenFileDialog.Options:=[ofHideReadOnly,ofEnableSizing];
    OpenFileDialog.InitialDir:=KSMInital_Path;
    If OpenFileDialog.Execute Then
    begin
      Try
        KSM.Free;
      except
      end;
      KSM:=TkalServerMap.Create;
      KSM.LoadFromFile(OpenFileDialog.FileName);
      for x2:=0 to 255 do
      begin
        for y1:=0 to 255 do
        begin
          Image_General.Canvas.Pixels[x2,y1]:=KSM.map[x2][y1][2];
        end;
      end;
      map:=KSM.map;

      ResetRealm;

      If KCM<>nil then
      begin
        If MessageBox(Handle, pchar('An KCM file has been loaded, want to paint the KSM file over it?'),'Paint?',MB_YESNO) = IDYES then
        begin
          GLHeightField.OnGetHeight:=GLHeightFieldPaintKSMmap;
          GLHeightField.StructureChanged;
        end;
      end;
    end;
  finally
    OpenFileDialog.Free;
  end;
end;

procedure TForm_Main.MainMenu_File_SaveKSMFileClick(Sender: TObject);
begin
  KSM.SaveToFile(KSM.FileLocation);
  MessageBox(handle,PChar('Succesfully saved KSM file to '''+KSM.FileLocation+''''),'Saving succeed',mb_ok);
  KSM.Saved:=True;
end;

procedure TForm_Main.MainMenu_File_SaveKSMFileasClick(Sender: TObject);
var
  SaveDialog:TSaveDialog;
begin
  saveDialog:=TSaveDialog.Create(Form_Main);
  saveDialog.Title:='Save your KalServerMap';
  saveDialog.InitialDir:=ExtractFileDir(Application.ExeName);
  saveDialog.Filter := 'Kal Server Maps|*.ksm;';
  saveDialog.DefaultExt := 'ksm';
  If SaveDialog.Execute Then
  begin
    KSM.FileLocation:=SaveDialog.FileName;
    KSM.SaveToFile(KSM.FileLocation);
    MessageBox(handle,PChar('Succesfully saved KSM file to '''+KSM.FileLocation+''''),'Saving succeed',mb_ok);
    KSM.Saved:=True;
  end;
end;

procedure TForm_Main.ListBox_FileClick(Sender: TObject);
begin
  ListBox_FileAspect.Items.Clear;
  ListBox_FileAspect.Enabled:=false;
  GroupBox_KSMDRAW.Visible:=False;
  GroupBox_KSMHEIGHT.Visible:=False;
  GroupBox_KSMOPLBased.Visible:=False;
  GroupBox_KCMHeight.Visible:=False;
  GroupBox_KCMSetHeight.Visible:=False;
  GroupBox_KCMFlatten.Visible:=False;
  GroupBox_KCMTexturePaint.Visible:=False;
  GroupBox_OPL.Visible:=False;
  GLFreeForm_Indicator.Visible:=False;
  //TOOL:=nil;

  If ListBox_File.Selected[0]=true then
  begin
  {KCM}
    If KCM=nil then
    begin
      //MessageBox(Handle, pchar('Can''t edit KCM.'+#13+'- No KCM file has been loaded.'),'Can''t edit KCM',MB_OK);
      ListBox_FileAspect.Items.Add('[Please load KCM]');
      abort;
    end;
    ListBox_FileAspect.Items.Add('Height - Brush');
    ListBox_FileAspect.Items.Add('Height - Set Height');
    ListBox_FileAspect.Items.Add('Height - Flatten');
    ListBox_FileAspect.Items.Add('Height - Move Whole Map');
    ListBox_FileAspect.Items.Add('Texture - Paint');
    ListBox_FileAspect.Items.Add('Grass - Paint');
    ListBox_FileAspect.Enabled:=True;
  end;

  If ListBox_File.Selected[1]=true then
  begin
  {KSM}
    If KSM=nil then
    begin
      //MessageBox(Handle, pchar('Can''t edit KSM.'+#13+'- No KSM file has been loaded.'),'Can''t edit KSM',MB_OK);
      ListBox_FileAspect.Items.Add('[Please load KSM]');
      abort;
    end;
    ListBox_FileAspect.Items.Add('Draw - Brush');
    ListBox_FileAspect.Items.Add('Draw - Height(KCM) Based');
    ListBox_FileAspect.Items.Add('Draw - Object(OPL) Based');
    ListBox_FileAspect.Enabled:=True;
  end;

  If ListBox_File.Selected[2]=true then
  begin
  {OPL}
    If OPL=nil then
    begin
      //MessageBox(Handle, pchar('Can''t edit OPL.'+#13+'- No OPL file has been loaded.'),'Can''t edit OPL',MB_OK);
      ListBox_FileAspect.Items.Add('[Please load OPL]');
      abort;
    end;
    ListBox_FileAspect.Items.Add('General - Position');
    ListBox_FileAspect.Items.Add('General - Scale');
    ListBox_FileAspect.Items.Add('General - Rotate');
    ListBox_FileAspect.Enabled:=True;
  end;
end;

procedure TForm_Main.ListBox_FileAspectClick(Sender: TObject);
var
  x,y:integer;
  size:Integer;
begin
  GroupBox_KSMDRAW.Visible:=False;
  GroupBox_KSMHEIGHT.Visible:=False;
  GroupBox_KSMOPLBased.Visible:=False;
  GroupBox_KCMHeight.Visible:=False;
  GroupBox_KCMSetHeight.Visible:=False;
  GroupBox_KCMFlatten.Visible:=False;
  GroupBox_KCMTexturePaint.Visible:=False;
  GroupBox_KCMGrassPaint.Visible:=False;
  GroupBox_OPL.Visible:=False;
  GLFreeForm_Indicator.Visible:=False;
  //TOOL:=nil;

  //KCM TOOls--------------
  If ListBox_File.Selected[0]=True then
  begin
    If ListBox_FileAspect.Selected[0]=true then
    begin
      GroupBox_KCMHEIGHT.Visible:=True;
      TOOL:=tKCM_HeightBrush;
    end;
    If ListBox_FileAspect.Selected[1]=true then
    begin
      GroupBox_KCMSetHeight.Visible:=True;
      TOOL:=tKCM_SetHeight;
    end;
    If ListBox_FileAspect.Selected[2]=true then
    begin
      GroupBox_KCMFlatten.Visible:=True;
      TOOL:=tKCM_Flatten;
    end;
    If ListBox_FileAspect.Selected[3]=true then
    begin
      GroupBox_KCMFlatten.Visible:=True;
      TOOL:=tKCM_WholeMap;
    end;
    If ListBox_FileAspect.Selected[4]=true then
    begin
      //Putting in the right size
      size:=TrackBar_KCMTexturePaint_OuterDiameter.Position*2;
      GLSphere1.Scale.X:=size;
      GLSphere1.Scale.Y:=size;
      GLSphere1.Scale.Z:=size;
      TrackBar_KCMTexturePaint_InnerDiameter.Max:=TrackBar_KCMTexturePaint_OuterDiameter.Position;

      //Making and painting the brush
      BrushCreate(FBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTexturePaint_OuterDiameter.Position,TrackBar_KCMTexturePaint_Intensity.Position);
      BrushCreate(FPBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTexturePaint_OuterDiameter.Position,TrackBar_KCMTexturePaint_Intensity.Position*10);
      For x:=0 to 50 do
      begin
        For y:=0 to 50 do
        begin
          Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2),(y*2)]:=FPBrush.Canvas.Pixels[x,y];
          Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)]:=FPBrush.Canvas.Pixels[x,y];
          Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2),(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
          Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
        end;
      end;
      
      GroupBox_KCMTexturePaint.Visible:=True;
      ComboBox_TextureMap.Items.Clear;
      For x:=0 to 7 do
      begin
        If KCM.Header.TextureList[x]<>0 then
        begin
          ComboBox_TextureMap.Items.Add('Texture Map #'+IntToStr(x));
        end;
      end;
      TOOL:=tKCM_TexturePaint;
    end;
    If ListBox_FileAspect.Selected[5]=true then
    begin
      If env<>nil then
      begin
        TrackBar_KCMGrassPaint_Type.Max:=env.GrassCount;
      GroupBox_KCMGrassPaint.Visible:=True;
      TOOL:=tKCM_GrassPaint;
      GLHeightField.OnGetHeight:=GLHeightFieldPaintObjectMap;
      For x:=0 to 256 do
      begin
        For y:=0 to 256 do
        begin
          If KCM.ObjectMap[x][y]<> 0 then
          begin
            Image_General.Canvas.Pixels[x,y]:=RGB(50+KCM.ObjectMap[x][y]*10,0,0);
          end
          else
          begin
            Image_General.Canvas.Pixels[x,y]:=RGB(KCM.ColorMap[x][y][0],KCM.ColorMap[x][y][1],KCM.ColorMap[x][y][2]);
          end;
        end;
      end;
      end
      else
      begin
        ShowMessage('n.env is required for this option, appearntly its not loaded.'+#13+#13+'Please set your settings proporly and restart kwe, it will be loaded on startup');
      end;
    end;
  end;

  //KSM TOOls--------------
  If ListBox_File.Selected[1]=True then
  begin
    If ListBox_FileAspect.Selected[0]=true then
    begin
      GroupBox_KSMDraw.Visible:=True;
      TOOL:=tKSM_PaintBrush;
    end;
    If ListBox_FileAspect.Selected[1]=true then
    begin
      If KCM<>Nil then
      begin
        GroupBox_KSMHEIGHT.Visible:=True;
        TOOL:=tKSM_HeightBased;

        //Creating Indicator
        CreateIndicator;
        GLFreeForm_Indicator.Visible:=True;
      end
      else
      begin
        MessageBox(Handle, pchar('Please load a KCM file first when preforming this function'),'Can''t preform this function...',MB_OK);
      end;
    end;
    If ListBox_FileAspect.Selected[2]=true then
    begin
      If OPL<>Nil then
      begin
      GroupBox_KSMOPLBased.Visible:=True;
      TOOL:=tKSM_OPLBased;
      end
      else
      begin
        MessageBox(Handle, pchar('Please load a OPL file first when preforming this function'),'Can''t preform this function...',MB_OK);
      end;
    end;
  end;

  //OPL TOOLS--------------
  If ListBox_File.Selected[2]=True then
  begin
    If OPL<>Nil then
    begin
      If ListBox_FileAspect.Selected[0]=true then
      begin
        GroupBox_OPL.Visible:=True;
        TOOL:=tOPL_Position;
      end;
      If ListBox_FileAspect.Selected[1]=true then
      begin
        GroupBox_OPL.Visible:=True;
        TOOL:=tOPL_Scale;
      end;
      If ListBox_FileAspect.Selected[2]=true then
      begin
        GroupBox_OPL.Visible:=True;
        TOOL:=null;
        If RadioButton_OPLRotation_X.Checked=true then
        begin
          TOOL:=tOPL_RotateX;
        end;
        If RadioButton_OPLRotation_Y.Checked=true then
        begin
          TOOL:=tOPL_RotateY;
        end;
        If RadioButton_OPLRotation_Z.Checked=true then
        begin
          TOOL:=tOPL_RotateZ;
        end;
      end;
    end
    else
    begin
        MessageBox(Handle, pchar('Please load an OPL file first when preforming this function'),'Can''t preform this function...',MB_OK);
    end;
  end;
end;

procedure TForm_Main.TrackBar_DiameterChange(Sender: TObject);
var
  size:Extended;
  trackbar:TTrackBar;
begin
  If sender = TrackBar_KCMSetHeight_Diameter then
  begin
    TrackBar:=TrackBar_KCMSetHeight_Diameter;
  end;

  If sender = TrackBar_KCMHEIGHT_Diameter then
  begin
    TrackBar:=TrackBar_KCMHEIGHT_Diameter;
  end;

  If sender = TrackBar_KCMFlatten_Diameter then
  begin
    TrackBar:=TrackBar_KCMFlatten_Diameter;
  end;

  If sender = TrackBar_BrushSize then
  begin
    TrackBar:=TrackBar_BrushSize;
  end;

  If sender = TrackBar_KCMGrassPaint_Diameter then
  begin
    TrackBar:=TrackBar_KCMGrassPaint_Diameter;
  end;

  //Setting the other Trackbars to the same pos
  TrackBar_KCMSetHeight_Diameter.Position:=TrackBar.Position;
  TrackBar_KCMHEIGHT_Diameter.Position:=TrackBar.Position;
  TrackBar_KCMFlatten_Diameter.Position:=TrackBar.Position;
  TrackBar_BrushSize.Position:=TrackBar.Position;
  TrackBar_KCMGrassPaint_Diameter.Position:=TrackBar.Position;

  //Setting the sphere his size
  size:=Trackbar.Position;
  GLSphere1.Scale.X:=size;
  GLSphere1.Scale.Y:=size;
  GLSphere1.Scale.Z:=size;
end;

procedure TForm_Main.RadioButtons_ValuesClick(Sender: TObject);
var
  Value1,Value2:word;
  x,y:Integer;
begin
  If GroupBox_KSMDRAW.Visible=True then
  begin
    If (RadioButton1.Checked=True) then
    begin
      RadioButton9.Checked:=True;
      RadioButton_KSMOpl_Gen_Normal.Checked:=True;
      Value1:=0;
    end;
    If (RadioButton2.Checked=True) then
    begin
      RadioButton10.Checked:=True;
      RadioButton_KSMOpl_Gen_NoMob.Checked:=True;
      Value1:=65535;
    end;
    If (RadioButton3.Checked=True) then
    begin
      RadioButton11.Checked:=True;
      RadioButton_KSMOpl_Spe_NoSpec.Checked:=True;
      Value2:=0;
    end;
    If (RadioButton4.Checked=True) then
    begin
      RadioButton12.Checked:=True;
      RadioButton_KSMOpl_Spe_OneWayPortal.Checked:=True;
      Value2:=1;
    end;
    If (RadioButton5.Checked=True) then
    begin
      RadioButton13.Checked:=True;
      RadioButton_KSMOpl_Spe_TwoWayPortal.Checked:=True;
      Value2:=2;
    end;
    If (RadioButton6.Checked=True) then
    begin
      RadioButton14.Checked:=True;
      RadioButton_KSMOpl_Spe_Town.Checked:=True;
      Value2:=6;
    end;
    If (RadioButton7.Checked=True) then
    begin
      RadioButton15.Checked:=True;
      RadioButton_KSMOpl_Spe_PKFree.Checked:=True;
      Value2:=4;
    end;
    If (RadioButton8.Checked=True) then
    begin
      RadioButton16.Checked:=True;
      RadioButton_KSMOpl_Spe_Castle.Checked:=True;
      Value2:=16;
    end;
  end;
  If GroupBox_KSMHEIGHT.Visible=True then
  begin
    If (RadioButton9.Checked=True) then
    begin
      RadioButton1.Checked:=True;
      RadioButton_KSMOpl_Gen_Normal.Checked:=True;
      Value1:=0;
    end;
    If(RadioButton10.Checked=True) then
    begin
      RadioButton2.Checked:=True;
      RadioButton_KSMOpl_Gen_NoMob.Checked:=True;
      Value1:=65535;
    end;

    If (RadioButton11.Checked=True) then
    begin
      RadioButton3.Checked:=True;
      RadioButton_KSMOpl_Spe_NoSpec.Checked:=True;
      Value2:=0;
    end;
    If (RadioButton12.Checked=True) then
    begin
      RadioButton4.Checked:=True;
      RadioButton_KSMOpl_Spe_OneWayPortal.Checked:=True;
      Value2:=1;
    end;
    If (RadioButton13.Checked=True) then
    begin
      RadioButton5.Checked:=True;
      RadioButton_KSMOpl_Spe_TwoWayPortal.Checked:=True;
      Value2:=2;
    end;
    If (RadioButton14.Checked=True) then
    begin
      RadioButton6.Checked:=True;
      RadioButton_KSMOpl_Spe_Town.Checked:=True;
      Value2:=6;
    end;
    If (RadioButton15.Checked=True) then
    begin
      RadioButton7.Checked:=True;
      RadioButton_KSMOpl_Spe_PKFree.Checked:=True;
      Value2:=4;
    end;
    If (RadioButton16.Checked=True) then
    begin
      RadioButton8.Checked:=True;
      RadioButton_KSMOpl_Spe_Castle.Checked:=True;
      Value2:=16;
    end;
  end;

  If GroupBox_KSMOplBased.Visible=True then
  begin
    If (RadioButton_KSMOpl_Gen_Normal.Checked=True) then
    begin
      RadioButton1.Checked:=True;
      RadioButton9.Checked:=True;
      Value1:=0;
    end;
    If(RadioButton_KSMOpl_Gen_NoMob.Checked=True) then
    begin
      RadioButton2.Checked:=True;
      RadioButton10.Checked:=True;
      Value1:=65535;
    end;

    If (RadioButton_KSMOpl_Spe_NoSpec.Checked=True) then
    begin
      RadioButton3.Checked:=True;
      RadioButton11.Checked:=True;
      Value2:=0;
    end;
    If (RadioButton_KSMOpl_Spe_OneWayPortal.Checked=True) then
    begin
      RadioButton4.Checked:=True;
      RadioButton12.Checked:=True;
      Value2:=1;
    end;
    If (RadioButton_KSMOpl_Spe_TwoWayPortal.Checked=True) then
    begin
      RadioButton5.Checked:=True;
      RadioButton13.Checked:=True;
      Value2:=2;
    end;
    If (RadioButton_KSMOpl_Spe_Town.Checked=True) then
    begin
      RadioButton6.Checked:=True;
      RadioButton14.Checked:=True;
      Value2:=6;
    end;
    If (RadioButton_KSMOpl_Spe_PKFree.Checked=True) then
    begin
      RadioButton7.Checked:=True;
      RadioButton15.Checked:=True;
      Value2:=4;
    end;
    If (RadioButton_KSMOpl_Spe_Castle.Checked=True) then
    begin
      RadioButton8.Checked:=True;
      RadioButton16.Checked:=True;
      Value2:=16;
    end;
  end;

  Values[1]:=Value1;
  Values[2]:=Value2;
  For x:=0 to Image_ColorDraw1.Width do
  begin
    For y:=0 to Image_ColorDraw1.Height do
    begin
      Image_ColorDraw1.Canvas.Pixels[x,y]:=KSM.ValuesToColor(Value1,Value2);
      Image_ColorDraw2.Canvas.Pixels[x,y]:=KSM.ValuesToColor(Value1,Value2);
      Image_KSMOPL_Color.Canvas.Pixels[x,y]:=KSM.ValuesToColor(Value1,Value2);
    end;
  end;

end;


procedure TForm_Main.Image_GeneralMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var
  Point:TPoint;
  //Value:TValues;
begin
  If KSM<>nil then
  begin
    //Values:=KSM.ColorToValues(Image_General.Canvas.Pixels[x,y]);
    Image_General.Hint:='KSM info:'+#13+'Value1 : '+IntToStr(KSM.Map[x][y][0])+#13+'Value2 : '+IntToStr(KSM.Map[x][y][1]);
    Point.X:=X;
    Point.Y:=Y;
    Point:=Image_General.ClientToScreen(Point);
    Application.ActivateHint(Point) ;
  end;
end;


procedure TForm_Main.TrackBar_IndicatorHeightChange(Sender: TObject);
begin
  GLFreeForm_Indicator.Position.Y:=TrackBar_IndicatorHeight.Position;
end;

procedure TForm_Main.KSMHEIGHT_ButtonUpClick(Sender: TObject);
var
  X,Y:Integer;
  //Values:TValues;
begin
  If GLFreeForm_Indicator<>nil then
  begin
    If MessageBox(Handle, pchar('Are you sure you want to paint everything above the Indicator your selected color?'),'Continue?',MB_YESNO) = IDYES then
    begin
      For x:=0 to 255 do
      begin
        For Y:=0 to 255 do
        begin
          If (KCM.HeightMap[x][y]/32)>GLFreeForm_Indicator.Position.Y then
          begin
            map[x][y][0]:=Values[1];
            map[x][y][1]:=Values[2];
            map[x][y][2]:=KSM.ValuesToColor(Values[1],Values[2]);
          end;
          Image_General.Canvas.Pixels[x,y]:=map[x][y][2]
        end;
      end;
    end;
  end;
  KSM.Map:=Map;
  KSM.Saved:=False;
  //KSM.ServerMapToImage(KSM.Map,Image_General);
  GLHeightField.StructureChanged;
end;

procedure TForm_Main.KSMHEIGHT_ButtonDownClick(Sender: TObject);
var
  X,Y:Integer;
  //Values:TValues;
begin
  If GLFreeForm_Indicator<>nil then
  begin
    If MessageBox(Handle, pchar('Are you sure you want to paint everything under the Indicator your selected color?'),'Continue?',MB_YESNO) = IDYES then
    begin
      For x:=0 to 255 do
      begin
        For Y:=0 to 255 do
        begin
          If (KCM.HeightMap[x][y]/32)<GLFreeForm_Indicator.Position.Y then
          begin
            map[x][y][0]:=Values[1];
            map[x][y][1]:=Values[2];
            map[x][y][2]:=KSM.ValuesToColor(Values[1],Values[2]);
            Image_General.Canvas.Pixels[x,y]:=map[x][y][2];
          end;
        end;
      end;
      KSM.Map:=map;
      KSM.Saved:=False;
      GLHeightField.StructureChanged;
    end;
  end;
end;

procedure TForm_Main.GLHeightFieldPaintColorMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
begin
  If KCM<>nil then
  begin
    z:=-KCM.HeightMap[round(x)][round(y)]/32;
    Color[0]:=KCM.ColorMap[round(x)][round(y)][0]/255;
    Color[1]:=KCM.ColorMap[round(x)][round(y)][1]/255;
    Color[2]:=KCM.ColorMap[round(x)][round(y)][2]/255;
  end;
end;

procedure TForm_Main.GLHeightFieldPaintKSMMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
var
  i:Integer;
begin
  If KCM<>nil then
  begin
    z:=-KCM.HeightMap[round(x)][round(y)]/32;
  end;
  If KSM<>nil then
  begin
   //Color[0]:=GetRValue(FCanvas.Canvas.Pixels[round(x),round(y)])/255;
    //Color[1]:=GetGValue(FCanvas.Canvas.Pixels[round(x),round(y)])/255;
    //Color[2]:=GetBValue(FCanvas.Canvas.Pixels[round(x),round(y)])/255;
    i:=KSM.ValuesToColor(KSM.Map[round(x)][round(y)][0],KSM.Map[round(x)][round(y)][1]);
    Color[0]:=GetRValue(i)/255;
    Color[1]:=GetGValue(i)/255;
    Color[2]:=GetBValue(i)/255;
  end;
end;

procedure TForm_Main.GLHeightFieldPaintTextureMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
begin
  z:=-KCM.HeightMap[round(x)][round(y)]/32;

  Color[0]:=KCM.TextureMapList[CurTmap][round(x)][round(y)]/255;
  Color[1]:=KCM.TextureMapList[CurTmap][round(x)][round(y)]/255;
  Color[2]:=KCM.TextureMapList[CurTmap][round(x)][round(y)]/255;
end;

procedure TForm_Main.GLHeightFieldPaintMiniMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
begin
  z:=-KCM.HeightMap[round(x)][round(y)]/32;

  Color[0]:=GetRValue(KCMMinimap.Canvas.Pixels[round(x),round(y)])/255;
  Color[1]:=GetGValue(KCMMinimap.Canvas.Pixels[round(x),round(y)])/255;
  Color[2]:=GetBValue(KCMMinimap.Canvas.Pixels[round(x),round(y)])/255;
end;

procedure TForm_Main.GLHeightFieldPaintCustomPic(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
begin
  z:=-KCM.HeightMap[round(x)][round(y)]/32;

  Color[0]:=GetRValue(KCMCustomPic.Canvas.Pixels[round(x),round(y)])/255;
  Color[1]:=GetGValue(KCMCustomPic.Canvas.Pixels[round(x),round(y)])/255;
  Color[2]:=GetBValue(KCMCustomPic.Canvas.Pixels[round(x),round(y)])/255;
end;
procedure TForm_Main.GLHeightFieldPaintObjectMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
begin
  If KCM<>nil then
  begin
    z:=-KCM.HeightMap[round(x)][round(y)]/32;

    If KCM.ObjectMap[round(x)][round(y)]<>0 then
    begin
      Color[0]:=(50+(KCM.ObjectMap[round(x)][round(y)]*10))/255;
      Color[1]:=0;
      Color[2]:=0;
    end
    else
    begin
      Color[0]:=KCM.ColorMap[round(x)][round(y)][0]/255;
      Color[1]:=KCM.ColorMap[round(x)][round(y)][1]/255;
      Color[2]:=KCM.ColorMap[round(x)][round(y)][2]/255;
    end;

  end;
end;


procedure TForm_Main.MainMenu_File_SaveKCMfileClick(Sender: TObject);
begin
  KCM.SaveToFile(KCM.FileLocation);
  MessageBox(handle,PChar('Succesfully saved KCM file to '''+KCM.FileLocation+''''),'Saving succeed',mb_ok);
  KCM.Saved:=True;
end;


procedure TForm_Main.Edit_KCMSetHeight_HeightChange(Sender: TObject);
begin
  TrackBar_KCMSetHeight_Height.Position:=round(StrToInt(Edit_KCMSetHeight_Height.Text)/32);
end;


procedure TForm_Main.TrackBar_KCMSetHeight_HeightChange(Sender: TObject);
begin
  Edit_KCMSetHeight_Height.Text:=IntToStr((TrackBar_KCMSetHeight_Height.Position*128)+(TrackBar_KCMSetHeight_Height2.Position));
end;

procedure TForm_Main.MainMenu_KCMFile_TextureCenterClick(Sender: TObject);
begin
  Form_KCMTextureCenter.Show;
end;

procedure TForm_Main.MainMenu_OptionsClick(Sender: TObject);
begin
  Form_Options.Show;
end;

procedure TForm_Main.MainMenu_KCMFileClick(Sender: TObject);
begin
  MainMenu_KCMFile_TextureCenter.Enabled:=False;
  MainMenu_KCMFile_HeaderInfo.Enabled:=False;
  MainMenu_KCMFile_BorderCenter.Enabled:=False;
  MainMenu_KCMFile_RenderColorMap.Enabled:=False;
  If KCM<>nil then
  begin
    MainMenu_KCMFile_RenderColorMap.Enabled:=True;
    MainMenu_KCMFile_TextureCenter.Enabled:=True;
    MainMenu_KCMFile_BorderCenter.Enabled:=True;
    MainMenu_KCMFile_HeaderInfo.Enabled:=True;
  end;
end;

procedure TForm_Main.MainMenu_FileClick(Sender: TObject);
begin
  MainMenu_File_SaveKCMFile.Enabled:=False;
  MainMenu_File_SaveKCMFileAs.Enabled:=False;
  MainMenu_File_SaveKSMFile.Enabled:=False;
  MainMenu_File_SaveKSMFileAs.Enabled:=False;
  MainMenu_File_SaveOPLFile.Enabled:=False;
  MainMenu_File_SaveOPLFileAs.Enabled:=False;
  Try
    If KCM<>nil then
    begin
      If KCM.FileLocation<>'' then
      begin
        MainMenu_File_SaveKCMFile.Enabled:=True;
      end;
      MainMenu_File_SaveKCMFileAs.Enabled:=True;
    end;
  except
  end;
  Try
    If KSM<>nil then
    begin
      MainMenu_File_SaveKSMFile.Enabled:=True;
      MainMenu_File_SaveKSMFileAs.Enabled:=True;
    end;
  except
  end;
  Try
    If OPL<>nil then
    begin
      MainMenu_File_SaveOPLFile.Enabled:=True;
      MainMenu_File_SaveOPLFileAs.Enabled:=True;
    end;
  except
  end;
end;

procedure TForm_Main.TrackBar_KCMTexturePaint_OuterDiameterChange(ender: TObject);
var
  x,y:Integer;
  size:Single;
begin
  BrushCreate(FBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTexturePaint_OuterDiameter.Position,TrackBar_KCMTexturePaint_Intensity.Position);
  BrushCreate(FPBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTexturePaint_OuterDiameter.Position,TrackBar_KCMTexturePaint_Intensity.Position*10);
  For x:=0 to 50 do
  begin
    For y:=0 to 50 do
    begin
      Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2),(y*2)]:=FPBrush.Canvas.Pixels[x,y];
      Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)]:=FPBrush.Canvas.Pixels[x,y];
      Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2),(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
      Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
    end;
  end;
  TrackBar_KCMTexturePaint_InnerDiameter.Max:=TrackBar_KCMTexturePaint_OuterDiameter.Position;

  size:=TrackBar_KCMTexturePaint_OuterDiameter.Position*2;
  GLSphere1.Scale.X:=size;
  GLSphere1.Scale.Y:=size;
  GLSphere1.Scale.Z:=size;
end;

procedure TForm_Main.TrackBar_KCMTexturePaint_InnerDiameterChange(Sender: TObject);
var
  x,y:Integer;
begin
  BrushCreate(FBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTexturePaint_OuterDiameter.Position,TrackBar_KCMTexturePaint_Intensity.Position);
  BrushCreate(FPBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTexturePaint_OuterDiameter.Position,TrackBar_KCMTexturePaint_Intensity.Position*10);
  For x:=0 to 50 do
  begin
    For y:=0 to 50 do
    begin
      Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2),(y*2)]:=FPBrush.Canvas.Pixels[x,y];
      Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)]:=FPBrush.Canvas.Pixels[x,y];
      Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2),(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
      Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
    end;
  end;
end;

procedure TForm_Main.TrackBar_KCMTexturePaint_IntensityChange(Sender: TObject);
var
  x,y:Integer;
begin
  BrushCreate(FBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTexturePaint_OuterDiameter.Position,TrackBar_KCMTexturePaint_Intensity.Position);
  BrushCreate(FPBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTexturePaint_OuterDiameter.Position,TrackBar_KCMTexturePaint_Intensity.Position*10);
  For x:=0 to 50 do
  begin
    For y:=0 to 50 do
    begin
      Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2),(y*2)]:=FPBrush.Canvas.Pixels[x,y];
      Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)]:=FPBrush.Canvas.Pixels[x,y];
      Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2),(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
      Image_KCMTextuePaint_BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
    end;
  end;
end;

procedure TForm_Main.BrushCreate(Brush:TBitmap;InWidth,OutWidth,Intensity:Integer);
var
  x1,x2:Integer;
  y1,y2:Integer;
  s,u:single;
  c:Integer;
begin
  //Painting inner cicle
  For x1:=0 to 50 do
  begin
    For y1:=0 to 50 do
    begin
      Brush.Canvas.Pixels[x1,y1]:=rgb(255,255,255);
    end;
  end;
  For x1:=25-OutWidth to 25+OutWidth do
  begin
    For y1:=25-OutWidth to 25+OutWidth do
    begin
      //x2 & y2 will represend the delta ( diffrence in ) distance.
      x2:=25-x1;
      y2:=25-y1;

      //Calculating the real distance between the points
      s:=Sqrt((x2*x2)+(y2*y2));

      If s <= InWidth then
      begin
        //Disance to center is smaller then inner circle
        Brush.Canvas.Pixels[x1,y1]:=rgb(255-Intensity,255-Intensity,255-Intensity);
      end
      else
      begin
        //Distance to center is bigger then inner circle
        If (s<= OutWidth) and (s> InWidth)  then
        begin
          u:=(255-Intensity)+((s-InWidth)*((Intensity)/(OutWidth-InWidth)));
          c:=round(u);
          Brush.Canvas.Pixels[x1,y1]:=rgb(c,c,c);
        end;
      end;
    end;
  end;
end;

procedure TForm_Main.ComboBox_TextureMapClick(Sender: TObject);
var
  x,y:Integer;
begin
  For x:=0 to ComboBox_TextureMap.Items.Count-1 do
  begin
    If ComboBox_TextureMap.Text=Combobox_TextureMap.Items[x] then
    begin
      CurTMap:=x;
    end;
  end;

  Form_Main.GLHeightField.OnGetHeight:=Form_Main.GLHeightFieldPaintTextureMap;
  Form_Main.GLHeightField.StructureChanged;
  For x:=0 to 255 do
  begin
    For y:=0 to 255 do
    begin
      Image_General.Canvas.Pixels[x,y]:=RGB(Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y]);
    end;
  end;

  ComboBox_TextureMap.Items.Clear;
  For x:=0 to 7 do
  begin
    If KCM.Header.TextureList[x]<>0 then
    begin
      ComboBox_TextureMap.Items.Add('Texture Map #'+IntToStr(x));
    end;
  end;
  //ShowMEssage(IntToStr(CurTMap));
end;

procedure TForm_Main.MainMenu_KCMFile_RenderColorMapClick(Sender: TObject);
var
  num:String;
  x,x2,x3,y:Integer;
  Red,Green,Blue:Integer;
  Color1,Color2:Integer;
  Color:Array[0..7] of integer;
  BitMap:TImage;
  Highest:Integer;
  LeaderList:TKCMTextureMap;
  ColorMap:TKCMColorMap;
begin
{  BitMap:=TImage.Create(Form_Main);
  BitMap.Width:=256;
  BitMap.Height:=256;

  //Highest:=KCM.TextureMapList[0][x][y];

  //Getting highest transparecy
  Highest:=0;
  for x := 0 to 255 do
  begin
    for y := 0 to 255 do
    begin
      Highest:=0;
      for x2:=0 to 7 do
      begin
        If (KCM.Header.TextureList[x2]<>0) and (KCM.Header.TextureList[x2]<>255) then
        begin
          If  KCM.TextureMapList[x2][x][y]>Highest then
          begin
            LeaderList[x][y]:=x2;
            Highest:=KCM.TextureMapList[x2][x][y];
          end;
        end;
      end;
    end;
  end;


  For x2:=0 to 7 do
  begin
    //ShowMessage(env.TextureIndexList[Form_Main.KCM.Header.TextureList[x2]]);
    If (KCM.Header.TextureList[x2]<>0) and (KCM.Header.TextureList[x2]<>255) then
    begin
      Try
        //Copyint the GTX
        If FileExists(Form_Main.Client_Path+'data\MAPS\Tex\'+env.TextureIndexList[Form_Main.KCM.Header.TextureList[x2]])= true then
        begin
          Windows.CopyFile(PChar(Form_Main.Client_Path+'data\MAPS\Tex\'+env.TextureIndexList[Form_Main.KCM.Header.TextureList[x2]]),PChar(ExtractFileDir(Application.ExeName)+'\Recources\'+env.TextureIndexList[Form_Main.KCM.Header.TextureList[x2]]),false);
        end
        else
        begin
          ShowMessage('Can''t display '''+Form_Main.Client_Path+'data\MAPS\Tex\'+env.TextureIndexList[Form_Main.KCM.Header.TextureList[x2]]+'''  because this file doesnt exists'+#13+#13+'displaying the GTX aborted');
          //ABORT;
        end;

        //Converting GTX to DDS
        ShellExecute(Handle,'open',PChar(ExtractFileDir(Application.ExeName)+'\Recources\GTX2DDS.exe'),PChar('"'+ExtractFileDir(Application.ExeName)+'\Recources\'+env.TextureIndexList[Form_Main.KCM.Header.TextureList[x2]]+'"'),PChar(ExtractFileDir(Application.ExeName)+'\Recources'),SW_NORMAL);

        //Displaying the shit;
        Sleep(400);
        BitMap.Picture.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Recources\'+Copy(env.TextureIndexList[Form_Main.KCM.Header.TextureList[x2]],1,Length(env.TextureIndexList[Form_Main.KCM.Header.TextureList[x2]])-4)+'.dds');

      except
      end;
      //Getting Average color of the texture
      Red:=GetRValue(BitMap.Canvas.Pixels[1,1]);
      Green:=GetGValue(BitMap.Canvas.Pixels[1,1]);
      Blue:=GetBValue(BitMap.Canvas.Pixels[1,1]);
      for x := 0 to 255 do
      begin
        for y := 0 to 255 do
        begin
          Red:=Red+GetRValue(BitMap.Canvas.Pixels[x,y]);
          Green:=Green+GetGValue(BitMap.Canvas.Pixels[x,y]);
          Blue:=Blue+GetBValue(BitMap.Canvas.Pixels[x,y]);
          Red:=Round(Red/1.5);
          Green:=Round(Green/1.5);
          Blue:=Round(Blue/1.5);
          Color[x2]:=RGB(Red,Green,Blue);
        end;
      end;

      //Painting average color on bitmap
      for x := 0 to 255 do
      begin
        for y := 0 to 255 do
        begin
          If KCM.HeightMap[x][y]<1580 then
          begin
            ColorMap[x][y][0]:=50;
            ColorMap[x][y][1]:=125;
            ColorMap[x][y][2]:=255;

            Image_General.Canvas.Pixels[x+1,y+1]:=Rgb(ColorMap[x][y][0],ColorMap[x][y][1],ColorMap[x][y][2]);
          end
          else
          begin
            If LeaderList[x][y]=x2 then
            begin
              //ColorMap[x][y][0]:=round(Red+(((255-red)*((255-KCM.TextureMapList[x2][x][y])/255))*((3500-KCM.HeightMap[x][y]) / 1300)));
              //ColorMap[x][y][1]:=round(Green+(((255-green)*((255-KCM.TextureMapList[x2][x][y])/255))*((3500-KCM.HeightMap[x][y]) / 1300)));
              //ColorMap[x][y][2]:=round(Blue+(((255-Blue)*((255-KCM.TextureMapList[x2][x][y])/255))*((3500-KCM.HeightMap[x][y]) / 1300)));
              //Working (very dark)
              //ColorMap[x][y][0]:=Round(Red+((255-red)*((KCM.HeightMap[x][y]-1584)/5000)));
              //ColorMap[x][y][1]:=Round(Green+((255-Green)*((KCM.HeightMap[x][y]-1584)/5000)));
              //ColorMap[x][y][2]:=Round(Blue+((255-Blue)*((KCM.HeightMap[x][y]-1584)/5000)));

              //Working pretty good actually
              //ColorMap[x][y][0]:=Round(Red-((red)*((KCM.HeightMap[x][y]-1584)/3000)));
              //ColorMap[x][y][1]:=Round(Green-((Green)*((KCM.HeightMap[x][y]-1584)/3000)));
              //ColorMap[x][y][2]:=Round(Blue-((Blue)*((KCM.HeightMap[x][y]-1584)/3000)));

              //Working awsomely? xD
              ColorMap[x][y][0]:=Round(Red-((red)*((KCM.HeightMap[x][y]-2000)/3300)));
              ColorMap[x][y][1]:=Round(Green-((Green)*((KCM.HeightMap[x][y]-2000)/3300)));
              ColorMap[x][y][2]:=Round(Blue-((Blue)*((KCM.HeightMap[x][y]-2000)/3300)));


              //ColorMap[x][y][0]:=round(Red+(((255-red)*((255-KCM.TextureMapList[x2][x][y])/255))*((2500-KCM.HeightMap[x][y]) / 900)));
              //ColorMap[x][y][1]:=round(Green+(((255-green)*((255-KCM.TextureMapList[x2][x][y])/255))*((2500-KCM.HeightMap[x][y]) / 900)));
              //colorMap[x][y][2]:=round(Blue+(((255-Blue)*((255-KCM.TextureMapList[x2][x][y])/255))*((2500-KCM.HeightMap[x][y]) / 900)));

              Image_General.Canvas.Pixels[x+1,y+1]:=Rgb(ColorMap[x][y][0],ColorMap[x][y][1],ColorMap[x][y][2]);
            end;
          end;


        end;
      end;
    end
    else
    begin
      Break;
    end;
  end;
  KCM.ColorMap:=Colormap;
  GLHeightField.StructureChanged;}
  Form_Colormap.Show;
end;

procedure TForm_Main.DisplayOPLNodeInfo(Nodes:TSelected_OPLs);
begin
  //Displaying the notify event, to prevent infinitif loops;
  Edit_OPL_ScaleX.OnChange:=nil;
  Edit_OPL_ScaleY.OnChange:=nil;
  Edit_OPL_ScaleZ.OnChange:=nil;
  Edit_OPL_RotationX.OnChange:=nil;
  Edit_OPL_RotationY.OnChange:=nil;
  Edit_OPL_RotationZ.OnChange:=nil;
  Edit_OPL_RotationW.OnChange:=nil;
  Edit_OPL_PosX.OnChange:=nil;
  Edit_OPL_PosY.OnChange:=nil;
  Edit_OPL_PosZ.OnChange:=nil;
  Edit_OPL_Model.OnChange:=nil;



  //Displaying the new info,
  If Length(Nodes)>1 then
  begin
    Edit_OPL_Model.Text:='[Multiple objects]';

    Edit_OPL_PosX.Text:='[Multiple objects]';
    Edit_OPL_PosY.Text:='[Multiple objects]';
    Edit_OPL_PosZ.Text:='[Multiple objects]';

    Edit_OPL_RotationX.Text:='[Multiple objects]';
    Edit_OPL_RotationY.Text:='[Multiple objects]';
    Edit_OPL_RotationZ.Text:='[Multiple objects]';
    Edit_OPL_RotationW.Text:='[Multiple objects]';

    Edit_OPL_ScaleX.Text:='[Multiple objects]';
    Edit_OPL_ScaleY.Text:='[Multiple objects]';
    Edit_OPL_ScaleZ.Text:='[Multiple objects]';

    Edit_OPL_Model.Enabled:=False;

    Edit_OPL_PosX.Enabled:=False;
    Edit_OPL_PosY.Enabled:=False;
    Edit_OPL_PosZ.Enabled:=False;

    Edit_OPL_RotationX.Enabled:=False;
    Edit_OPL_RotationY.Enabled:=False;
    Edit_OPL_RotationZ.Enabled:=False;
    Edit_OPL_RotationW.Enabled:=False;

    Edit_OPL_ScaleX.Enabled:=False;
    Edit_OPL_ScaleY.Enabled:=False;
    Edit_OPL_ScaleZ.Enabled:=False;

    Button_OPL_BrowseModel.Enabled:=False;
  end
  else
  begin
    //ShowMessage('max index = '+IntToStr(OPL.ObjectCount-1)+#13+
                //'selected index = '+IntToStr(Nodes[0].Index));
    Edit_OPL_Model.Text:=OPL.Node[Nodes[0].Index].Path;

    Edit_OPL_PosX.Text:=FloatToStr(OPL.Node[Nodes[0].Index].Position[0]*8192);
    Edit_OPL_PosY.Text:=FloatToStr((1-OPL.Node[Nodes[0].Index].Position[1])*8192);
    Edit_OPL_PosZ.Text:=FloatToStr(OPL.Node[Nodes[0].Index].Position[2]);

    Edit_OPL_RotationX.Text:=FloatToStr((ArcSin(OPL.Node[Nodes[0].Index].Rotation[0])*2)*57.2957795);
    //Edit_OPL_RotationY.Text:=FloatToStr((ArcSin(OPL.Node[Node].Rotation[1])*2)*57.2957795);
    Edit_OPL_RotationY.Text:=FloatToStr(OPL.Node[Nodes[0].Index].Rotation[1]);
    Edit_OPL_RotationZ.Text:=FloatToStr((ArcSin(OPL.Node[Nodes[0].Index].Rotation[2])*2)*57.2957795);
    Edit_OPL_RotationW.Text:=FloatToStr(OPL.Node[Nodes[0].Index].Rotation[3]);

    Edit_OPL_ScaleX.Text:=FloatToStr(OPL.Node[Nodes[0].Index].Scale[0]);
    Edit_OPL_ScaleY.Text:=FloatToStr(OPL.Node[Nodes[0].Index].Scale[1]);
    Edit_OPL_ScaleZ.Text:=FloatToStr(OPL.Node[Nodes[0].Index].Scale[2]);

    Edit_OPL_Model.Enabled:=True;

    Edit_OPL_PosX.Enabled:=True;
    Edit_OPL_PosY.Enabled:=True;
    Edit_OPL_PosZ.Enabled:=True;

    Edit_OPL_RotationX.Enabled:=True;
    Edit_OPL_RotationY.Enabled:=True;
    Edit_OPL_RotationZ.Enabled:=True;
    Edit_OPL_RotationW.Enabled:=True;

    Edit_OPL_ScaleX.Enabled:=True;
    Edit_OPL_ScaleY.Enabled:=True;
    Edit_OPL_ScaleZ.Enabled:=True;

    Button_OPL_BrowseModel.Enabled:=True;
  end;

  //Displaying the notify event, to prevent infinitif loops;
  Edit_OPL_ScaleX.OnChange:=OPLChange;
  Edit_OPL_ScaleY.OnChange:=OPLChange;
  Edit_OPL_ScaleZ.OnChange:=OPLChange;
  Edit_OPL_RotationX.OnChange:=OPLChange;
  Edit_OPL_RotationY.OnChange:=OPLChange;
  Edit_OPL_RotationZ.OnChange:=OPLChange;
  Edit_OPL_RotationW.OnChange:=OPLChange;
  Edit_OPL_PosX.OnChange:=OPLChange;
  Edit_OPL_PosY.OnChange:=OPLChange;
  Edit_OPL_PosZ.OnChange:=OPLChange;
  Edit_OPL_Model.OnChange:=OPLChange;

end;
procedure TForm_Main.PositionOPLNode(x1:Integer;UpdateModel:Boolean;TrueModel:Boolean = True;TrueTex:Boolean = True);
var
  model:TGLFreeForm;
  DDSLoc,GTXLoc:String;
  libMat:TGLLibMaterial;
  j:integer;
  S:boolean;
begin
  If x1<(GLDummYCube_OPLObjects.Count) then
  begin
    model:=TGLFreeForm.Create(nil) ;
    model:=TGLFreeForm(GLDummyCube_OPLObjects.Children[x1]);
  end
  else
  begin
    model:=TGLFreeForm.Create(nil) ;
    model:=TGLFreeForm(GLDummyCube_OPLObjects.AddNewChild(TGLFreeForm));
  end;

  //model.name:='OPLNode'+IntToStr(x1);
  model.Visible:=True;

  //Updating position
  model.position.x:=OPL.node[x1].position[0]*256;
  model.position.y:=OPL.node[x1].position[2]/32;
  model.position.z:=256-(OPL.node[x1].position[1]*256);

  //Updating rotation
  model.Rotation.X:=((ArcSin(OPL.Node[x1].Rotation[0])*2)*57.2957795)+90;
  model.Rotation.Y:=((ArcSin(OPL.Node[x1].Rotation[2])*2)*57.2957795)+180;
  model.Rotation.Z:=((ArcSin(OPL.Node[x1].Rotation[1])*2)*57.2957795)+180;
  If ((ArcSin(OPL.Node[x1].Rotation[3])*2)*57.2957795)<0 then
  begin
    model.Rotation.z:=(-(ArcSin(OPL.Node[x1].Rotation[1])*2)*57.2957795)+180;
  end;

  //Updating Scale
  If TrueModel=True then
  begin
    model.Scale.X:=OPL.node[x1].scale[0]/32;
    model.scale.Y:=OPL.node[x1].scale[2]/32;
    model.scale.Z:=OPL.node[x1].scale[1]/32;
  end
  else
  begin
    model.Scale.X:=OPL.node[x1].scale[0];
    model.scale.Y:=OPL.node[x1].scale[2];
    model.scale.Z:=OPL.node[x1].scale[1];
  end;

  If UpdateModel=True then
  begin
    If TrueModel=True  then
    begin
      if (FileExists(ExtractFileDir(Application.ExeName)+'\Recources\'+Copy(OPL.Node[x1].Path,6,Length(OPL.Node[x1].Path))+'.3ds')=true) then
      begin
        model.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Recources\'+Copy(OPL.Node[x1].Path,6,Length(OPL.Node[x1].Path))+'.3ds');
        model.NormalsOrientation:=mnoInvert;
      end
      else
      begin
        model.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Recources\model.3ds');
        model.NormalsOrientation:=mnoDefault;
        model.Scale.X:=OPL.node[x1].scale[0];
        model.scale.Y:=OPL.node[x1].scale[2];
        model.scale.Z:=OPL.node[x1].scale[1];
      end;
    end
    else
    begin
      model.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Recources\model.3ds');
      model.NormalsOrientation:=mnoDefault;
    end;
    model.Material.Texture.Disabled:=True;
  end;

  If (TrueTex=True) and (TrueModel=True) then
  begin
    try
      GTXLoc:=Client_Path+ExtractFilePath(OPL.Node[x1].Path)+'tex\'+GetTextureName(Client_Path+OPL.Node[x1].Path+'.gb');
      GTXLoc:=Copy(GTXLoc,1,Length(GTXLoc)-4)+'.gtx';

      If FileExists(GTXLoc) then
      begin
        DDSLoc:=ExtractFileDir(Application.ExeName)+'\Recources\'+GetTextureName(Client_Path+OPL.Node[x1].Path+'.gb');

        If FileExists(DDSLoc)=false then
        begin
          ConvertGTX2DDS(GTXLoc,DDSLoc,ExtractFilePath(Application.Exename)+'Recources\encrypt.dat',ExtractFilePath(Application.Exename)+'Recources\decrypt.dat');
        end;

        libmat:=nil;
        libmat:=GLMaterialLibrary.Materials.GetLibMaterialByName(ExtractFileName(DDSLoc));
        If libmat=nil then
        begin
          libmat:=GLMaterialLibrary.AddTextureMaterial(ExtractFileName(DDSLoc),DDSLoc);
        end;

        s:=False;
        for j:=0 to Length(Selected_OPLs)-1 do
        begin
          If Selected_OPLs[j].Index=x1 then
          begin
            s:=True;
            break;
          end;
        end;
        If s=True then
        begin
          Selected_OPLs[j].Tex:=libMat.Name;
        end
        else
        begin
          model.Material.Texture.Disabled:=False;
          model.Material.MaterialLibrary:=GLMaterialLibrary;
          model.Material.LibMaterialName:=libMat.Name;
        end;
      end
      else
      begin
        model.Material.Libmaterialname:='';
        model.Material.Texture.Disabled:=True;
      end;
    except
    end;
  end
  else
  begin
    model.Material.Libmaterialname:='';
    model.Material.Texture.Disabled:=True;
  end;
end;

procedure TForm_Main.PositionOPL(UpdateModels,TrueModels,TrueTextures:Boolean);
var
  x1:Integer;
begin
  GLDummyCube_OPLObjects.DeleteChildren;
  SetLength(Selected_OPLs,0);
  For x1:=0 to OPL.Header.ObjectCount-1 do
  begin
    try
      PositionOPLNode(x1,UpdateModels,TrueModels,TrueTextures);
    except
    end;
  end;
end;


procedure TForm_Main.CheckBox_ShowWaterClick(Sender: TObject);
begin
  GLFreeForm_Water.Visible:=False;
  If CheckBox_ShowWater.Checked=True then
  begin
    GLFreeForm_Water.Visible:=True;
  end;
end;

procedure TForm_Main.CheckBox_ShowOPLNodesClick(Sender: TObject);
begin
  GLDummyCube_OPLObjects.Visible:=False;
  If CheckBox_ShowOPLNodes.Checked=True then
  begin
    GLDummyCube_OPLObjects.Visible:=True;
  end;
end;

procedure TForm_Main.CheckBox_OPL_Position_STMClick(Sender: TObject);
begin
  Edit_OPL_PosZ.Enabled:=False;
  If (CheckBox_OPL_Position_STM.Checked=False) and (Length(Selected_OPLs)<2) then
  begin
    Edit_OPL_PosZ.Enabled:=True;
  end;
end;

procedure TForm_Main.MainMenu_File_ExitClick(Sender: TObject);
begin
  Form_ShutDown.Show;
  Abort;
end;

procedure TForm_Main.MainMenu_File_LoadOPLFileClick(Sender: TObject);
var
  Openfiledialog:TOpenDialog;
  status:Extended;
  x:Integer;
begin
  Try
    OpenFileDialog:=TOpenDialog.Create(nil);
    OpenFileDialog.Filter:='Object Position List files (*.opl)|*.opl;|All files|*.*';
    OpenFileDialog.Title:='Open file...';
    OpenFileDialog.Options:=[ofHideReadOnly,ofEnableSizing];
    OpenFileDialog.InitialDir:=KCMInital_Path;
    If OpenFileDialog.Execute Then
    begin
      If FileExists(OpenFileDialog.FileName) = True then
      begin
        try
          try
            OPL.Free;
          finally
            OPL:=TOPLFile.Create;

            OPL.LoadFromFile(ExtractFilePath(OpenFileDialog.FileName)+Copy(ExtractFileName(OpenFileDialog.FileName),0,Length(ExtractFileName(OpenFileDialog.FileName))-Length(ExtractFileExt(OpenFileDialog.FileName)))+'.OPL');

            CheckBox_StickOPLtoKCM.Enabled:=True;
            CheckBox_ShowOPLNodes.Enabled:=True;
            CheckBox_ShowOPLModels.Enabled:=True;
            CheckBox_ShowOPLTextures.Enabled:=True;
            CheckBox_ShowOPLNodes.Checked:=True;

            PositionOPL(True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
          end;
        finally
          GLDummyCube_OPLObjects.Visible:=True;
          GLSceneViewer.Enabled:=True;
        end;
      end;
    end;
  except

  end;
end;

procedure TForm_Main.GroupBox_OPL_PositionClick(Sender: TObject);
begin
  If GroupBox_OPL_Position_Big=False then
  begin
    //If Small... going to big
    GroupBox_OPL_Position_Big:=True;
    GroupBox_OPL_Position.Height:=15;
    GroupBox_OPL_Position.Caption:='Position (Press to normalize)';
  end
  else
  begin
    //If Big... going to small
    GroupBox_OPL_Position_Big:=False;
    GroupBox_OPL_Position.Height:=113;
    GroupBox_OPL_Position.Caption:='Position (Press to minimize)'
  end;
  AllignGroupBox_OPL;
end;

procedure TForm_Main.GroupBox_OPL_RotationClick(Sender: TObject);
begin
  If GroupBox_OPL_Rotation_Big=False then
  begin
    //If Small... going to big
    GroupBox_OPL_Rotation_Big:=True;
    GroupBox_OPL_Rotation.Height:=15;
    GroupBox_OPL_Rotation.Caption:='Rotation (Press to normalize)';
  end
  else
  begin
    //If Big... going to small
    GroupBox_OPL_Rotation_Big:=False;
    GroupBox_OPL_Rotation.Height:=113;
    GroupBox_OPL_Rotation.Caption:='Rotation (Press to minimize)'
  end;
  AllignGroupBox_OPL;
end;

procedure TForm_Main.GroupBox_OPL_ModelClick(Sender: TObject);
begin
  If GroupBox_OPL_Model_Big=False then
  begin
    //If Small... going to big
    GroupBox_OPL_Model_Big:=True;
    GroupBox_OPL_Model.Height:=15;
    GroupBox_OPL_Model.Caption:='Model (Press to normalize)';
  end
  else
  begin
    //If Big... going to small
    GroupBox_OPL_Model_Big:=False;
    GroupBox_OPL_Model.Height:=45;
    GroupBox_OPL_Model.Caption:='Model (Press to minimize)'
  end;
  AllignGroupBox_OPL;
end;

procedure TForm_Main.GroupBox_OPL_ScaleClick(Sender: TObject);
begin
  If GroupBox_OPL_Scale_Big=False then
  begin
    //If Small... going to big
    GroupBox_OPL_Scale_Big:=True;
    GroupBox_OPL_Scale.Height:=15;
    GroupBox_OPL_Scale.Caption:='Scale (Press to normalize)';
  end
  else
  begin
    //If Big... going to small
    GroupBox_OPL_Scale_Big:=False;
    GroupBox_OPL_Scale.Height:=89;
    GroupBox_OPL_Scale.Caption:='Scale (Press to minimize)'
  end;
  AllignGroupBox_OPL;
end;

procedure TForm_Main.AllignGroupBox_OPL();
begin
  GroupBox_OPL_Position.Top:=GroupBox_OPL_Model.Top+GroupBox_OPL_Model.Height+2;
  GroupBox_OPL_Rotation.Top:=GroupBox_OPL_Position.Top+GroupBox_OPL_Position.Height+2;
  GroupBox_OPL_Scale.Top:=GroupBox_OPL_Rotation.Top+GroupBox_OPL_Rotation.Height+2;
  Button_OPLGeneral_Save.Top:=GroupBox_OPL_Scale.Top+GroupBox_OPL_Scale.Height+7;
end;

procedure TForm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
var
  saveDialog:TSaveDialog;
  Choice:Integer;
begin
  Application.CreateForm(TForm_Shutdown, Form_Shutdown);
  Form_Shutdown.Show;
  Abort;
  {If OPL<>nil then
  begin
    try
      FreeAndNil(OPL);
      OPL.Destroy;
      GLDummyCube_OPLObjects.Destroy;
    except
    end;
  end;
  If KCM<>nil then
  begin
    If KCM.Saved=False then
    begin
      Choice:=MessageBox(handle,PChar('Do you want to save the changes to your KCM?'),'Kal World Editor',3);

      //If Choice is YES
      If Choice=IDYES then
      begin
        If KCM.FileLocation<>''then
        begin
          KCM.SaveToFile(KCM.FileLocation);
        end
        else
        begin
          saveDialog:=TSaveDialog.Create(Form_Main);
          saveDialog.Title:='Save your KalClientMap';
          saveDialog.InitialDir:=ExtractFileDir(Application.ExeName);
          saveDialog.Filter := 'Kal Client Maps|*.kcm;';
          saveDialog.DefaultExt := 'kcm';
          saveDialog.FileName:='n_0'+IntToStr(KCM.Header.MapX)+'_0'+IntToStr(KCM.Header.MapY)+'.kcm';
          If SaveDialog.Execute Then
          begin
            KCM.SaveToFile(saveDialog.FileName);
          end;
        end;
      end;

      //If Choice is Abort, then exit the procedure
      If Choice=2 then
      begin
        Abort;
      end;
    end;

    //Freeing and destroying all the KCM's info
    try
      FreeAndNil(KCM);
      KCM.Destroy;
      GLHeightField.Free;
      GLHeightField.Destroy;
    except
    end;
  end;
  If KSM<>nil then
  begin
    If KSM.Saved=False then
    begin
      Choice:=MessageBox(handle,PChar('Do you want to save the changes to your KSM?'),'Kal World Editor',3);

      //If Choice is YES
      If Choice=IDYES then
      begin
        If KSM.FileLocation<>''then
        begin
          KSM.SaveToFile(KSM.FileLocation);
        end
        else
        begin
          saveDialog:=TSaveDialog.Create(Form_Main);
          saveDialog.Title:='Save your KalServerMap';
          saveDialog.InitialDir:=ExtractFileDir(Application.ExeName);
          saveDialog.Filter := 'Kal Server Maps|*.ksm;';
          saveDialog.DefaultExt := 'ksm';
          If SaveDialog.Execute Then
          begin
            KSM.SaveToFile(saveDialog.FileName);
          end;
        end;
      end;

      //If Choice is Abort, then exit the procedure
      If Choice=2 then
      begin
        Abort;
      end;

      //Destroying and freeing all KSM info,
      try
        FreeAndNil(KSM);
        KSM.Destroy;
        GLHeightField.Free;
        GLHeightField.Destroy;
      except
      end;
    end;
  end;
  Application.Terminate;}
end;

procedure TForm_Main.OPLChange(Sender: TObject);
var
  Vector4F:TVector4F;
  Vector3F:TVector3F;
begin
  //Saving path
  OPL.Node[selected_OPLs[0].Index].Path:=Edit_OPL_Model.text;

  {//Saving Position
  Vector3F[0]:=StrToFloat(Edit_OPL_PosX.Text)/8192;
  Vector3F[2]:=StrToFloat(Edit_OPL_PosZ.Text)/8192;
  If CheckBox_OPL_Position_STM.Checked=False then
  begin
    Vector3F[1]:=StrToFloat(Edit_OPL_PosY.Text);
  end
  else
  begin
    Vector3F[1]:=KCM.HeightMap[round(Vector3F[0])][round(Vector3F[2])];
  end;
  OPL.Node[selected_OPLNode].Position:=Vector3F;}

  //Saving Scale
  Vector3F[0]:=StrToFloat(Edit_OPL_ScaleX.Text);
  Vector3F[1]:=StrToFloat(Edit_OPL_ScaleY.Text);
  Vector3F[2]:=StrToFloat(Edit_OPL_ScaleZ.Text);
  OPL.Node[selected_OPLs[0].Index].Scale:=Vector3F;

  //Saving Rotation
  //Vector4F[0]:=StrToFloat(Edit_OPL_RotationX.Text);
  //Vector4F[1]:=StrToFloat(Edit_OPL_RotationY.Text);
  //Vector4F[2]:=StrToFloat(Edit_OPL_RotationZ.Text);
  //Vector4F[3]:=StrToFloat(Edit_OPL_RotationW.Text);
  //OPL.Node[selected_OPLNode].Rotation:=Vector4F;


  PositionOPLNode(selected_OPLs[0].Index,True,CheckBox_ShowOPLModels.Checked);

  DisplayOPLNodeInfo(selected_OPLs)

    {//Displaying the new info,
  Edit_OPL_Model.Text:=OPL.Node[Selected_OPLNode].Path;

  Edit_OPL_PosX.Text:=FloatToStr(OPL.Node[Selected_OPLNode].Position[0]*8192);
  Edit_OPL_PosY.Text:=FloatToStr((1-OPL.Node[Selected_OPLNode].Position[1])*8192);
  Edit_OPL_PosZ.Text:=FloatToStr(OPL.Node[Selected_OPLNode].Position[2]);

  Edit_OPL_RotationX.Text:=FloatToStr(OPL.Node[Selected_OPLNode].Rotation[0]);
  Edit_OPL_RotationY.Text:=FloatToStr(OPL.Node[Selected_OPLNode].Rotation[1]);
  Edit_OPL_RotationZ.Text:=FloatToStr(OPL.Node[Selected_OPLNode].Rotation[2]);
  Edit_OPL_RotationW.Text:=FloatToStr(OPL.Node[Selected_OPLNode].Rotation[3]);

  Edit_OPL_ScaleX.Text:=FloatToStr(OPL.Node[Selected_OPLNode].Scale[0]);
  Edit_OPL_ScaleY.Text:=FloatToStr(OPL.Node[Selected_OPLNode].Scale[1]);
  Edit_OPL_ScaleZ.Text:=FloatToStr(OPL.Node[Selected_OPLNode].Scale[2]);}

  //Positioning the selected node at their new position
  //GLDummyCube_OPLObjects.Children[Selected_OPLNode].Scale.x:=OPL.node[Selected_OPLNode].Scale[0];
  //GLDummyCube_OPLObjects.Children[Selected_OPLNode].Scale.y:=OPL.node[Selected_OPLNode].Scale[2];
  //GLDummyCube_OPLObjects.Children[Selected_OPLNode].Scale.z:=OPL.node[Selected_OPLNode].Scale[1];

  //Placing the nodes on their new saved spot
  //GLDummyCube_OPLObjects.Children[Selected_OPLNode].position.x:=OPL.node[Selected_OPLNode].position[0]*256;
  //GLDummyCube_OPLObjects.Children[Selected_OPLNode].position.y:=OPL.node[Selected_OPLNode].position[2]/32;
  //GLDummyCube_OPLObjects.Children[Selected_OPLNode].position.z:=-OPL.node[Selected_OPLNode].position[1]*256;
end;

procedure TForm_Main.MainMenu_File_SaveOPLFileClick(Sender: TObject);
begin
  OPL.SaveToFile(OPL.FileLocation);
  MessageBox(handle,PChar('Succesfully saved OPL file to '''+OPL.FileLocation+''''),'Saving succeed',mb_ok);
  OPL.Saved:=True;
end;

procedure TForm_Main.MainMenu_File_SaveOPLFileAsClick(Sender: TObject);
var
  saveDialog:TSaveDialog;
begin
  saveDialog:=TSaveDialog.Create(Form_Main);
  saveDialog.Title:='Save your ObjectPositionList';
  saveDialog.InitialDir:=KCMInital_Path;
  saveDialog.Filter := 'Object Position List|*.opl;';
  saveDialog.DefaultExt := 'opl';
  saveDialog.FileName:='n_0'+IntToStr(OPL.Header.MapX)+'_0'+IntToStr(OPL.Header.MapY)+'.opl';
  If SaveDialog.Execute Then
  begin
    OPL.SaveToFile(saveDialog.FileName);
    MessageBox(handle,PChar('Succesfully saved OPL file to '''+OPL.FileLocation+''''),'Saving succeed',mb_ok);
    OPL.Saved:=True;
  end;
end;

procedure TForm_Main.Button_KSMOpl_PaintClick(Sender: TObject);
var
  x,x1,y1:Integer;
  Xmax,Xmin,Ymax,Ymin:Integer;
  //Values:TValues;
  //map:TKSMMap;
begin
  For x:=0 to OPL.Header.ObjectCount-1 do
  begin
    //Security
    Xmin:=round((OPL.Node[x].Position[0]*256)-(TrackBar_KSMOpl_PaintSize.Position/2));
    Xmax:=round((OPL.Node[x].Position[0]*256)+(TrackBar_KSMOpl_PaintSize.Position/2));

    ymin:=round(((1-OPL.Node[x].Position[1])*256)-(TrackBar_KSMOpl_PaintSize.Position/2));
    Ymax:=round(((1-OPL.Node[x].Position[1])*256)+(TrackBar_KSMOpl_PaintSize.Position/2));

    If Xmin<0 then
    begin
      Xmin:=0;
    end;
    If Xmax>255 then
    begin
      XMax:=255
    end;

    If Ymin<0 then
    begin
      Ymin:=0;
    end;
    If Ymax>255 then
    begin
      Ymax:=255
    end;

    //The painting
    For x1:=Xmin to Xmax do
    begin
      For y1:=Ymin to Ymax  do
      begin
        try
          map[x1][y1][0]:=Values[1];
          map[x1][y1][1]:=Values[2];
          map[x1][y1][2]:=KSM.ValuesToColor(Values[1],Values[2]);
          Image_General.canvas.Pixels[x1,y1]:=map[x1][y1][2]
        except
        end;
      end;
    end;
  end;

  KSM.Map:=map;
  KSM.Saved:=False;
  GLHeightField.StructureChanged;
end;

procedure TForm_Main.MainMenu_KCMFile_BorderCenterClick(Sender: TObject);
begin
  //Form_BorderCenter.Execute(KCM.Heightmap);
  Form_BorderCenter.Show;
end;

procedure TForm_Main.MainMenu_File_NewKSMFileClick(Sender: TObject);
var
  x1,y1:Integer;
  map:TKSMMap;
begin
  KSM:=TKalServerMap.Create;
  For x1:=0 to 255 do
  begin
    for y1:=0 to 255 do
    begin
      Map[x1][y1][0]:=0;
      Map[x1][y1][1]:=0;
      Image_General.Canvas.Pixels[x1,y1]:=KSM.ValuesToColor(0,0);
    end;
  end;
  KSM.Map:=Map;
  GlHeightField.OnGetHeight:=GLHeightFieldPaintKSMMap;
  GLHeightField.StructureChanged;

end;

procedure TForm_Main.MainMenu_OPLFileClick(Sender: TObject);
begin
  MainMenu_OPLFile_HeaderInfo.Enabled:=False;
  Mainmenu_OPLFile_AddNode.Enabled:=False;
  MainMenu_OPLFile_DeleteNode.Enabled:=False;
  MainMenu_OPLFile_DeleteAll.Enabled:=False;
  If OPL<>Nil then
  begin
    MainMenu_OPLFile_HeaderInfo.Enabled:=True;
    If KCM<>Nil then
    begin
      Mainmenu_OPLFile_AddNode.Enabled:=True;
    end;
    MainMenu_OPLFile_DeleteAll.Enabled:=True;
    If (Length(selected_OPLs)>0) and (Length(selected_OPLs)<>OPL.ObjectCount-1) then
    begin
      MainMenu_OPLFile_DeleteNode.Enabled:=True;
    end;
  end;
end;

procedure TForm_Main.MainMenu_OPLFile_DeleteNodeClick(Sender: TObject);
var
  x1,x2:Integer;
  Selected_OPL:TSelected_OPL;
  NotChanged:Boolean;
begin
      If MessageBox(0,PChar('Are you sure you want to delete the selected node?'),Pchar('Delete this node?'),mb_YesNo)=IDYES then
      begin
        If Length(Selected_OPLs)=0 then
        begin
          exit;
        end;

        //Ordening From lowest index to hieghest
        For x2:=0 to Length(selected_OPLs)-1 do
        begin
          NotChanged:=True;
          For x1:=0 to Length(Selected_OPLs)-2 do
          begin
            If (Selected_OPLs[x1+1].index<Selected_OPLs[x1].index) then
            begin
              //Backing up the record;
              Selected_OPL.Index:=Selected_OPLs[x1+1].Index;
              Selected_OPL.Tex:=Selected_OPLs[x1+1].Tex;

              //Shifting the other record
              Selected_OPLs[x1+1].Index:=Selected_OPLs[x1].Index ;
              Selected_OPLs[x1+1].Tex:=Selected_OPLs[x1].Tex;

              //Reentering the backed up record
              Selected_OPLs[x1].Index:=Selected_OPL.Index;
              Selected_OPLs[x1].Tex:=Selected_OPL.Tex;

              //We changed it, so notchanged = false
              NotChanged:=False;
            end;
          end;
          //If the array hasn't been change then everything is alligned...
          If NotChanged=True then
          begin
            Break;
          end;
        end;

        //The actual deleting
        For x1:=Length(Selected_OPLs)-1 downto 0 do
        begin
          //Deleting the Node in the OPL file...
          OPL.RemoveObject(Selected_OPLs[x1].Index);

          //Shifting the other models;
          For x2:=Selected_OPLs[x1].Index to OPL.ObjectCount-2 do
          begin
            GlDummyCube_OPLObjects.Children[x2].Assign(GLDummyCube_OPLObjects.Children[x2+1]);
          end;
          GLDummyCube_OPLObjects.Children[OPL.ObjectCount].Free;
        end;

        //Reseting the selected OPLs info
        SetLength(Selected_OPLs,0);
      end;
end;

procedure TForm_Main.MainMenu_OPLFile_DeleteAllClick(Sender: TObject);
var
  x1:Integer;
  //OPLNodeList:TOPLNodeList;
begin
  If OPL<>nil then
  begin
    //clearing all the models
    for x1:=0 to 3999 do
    begin
      try
        GLDummyCube.Children[x1].Destroy;
      except
      end;
    end;

    //Faster than 0 to 3999
    for x1:=3999 downto 0 do
    begin
      try
        OPL.RemoveObject(x1);
      except
      end;
    end;

    PositionOPL(True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

  end;
end;

procedure TForm_Main.MainMenu_OPLFile_AddNodeClick(Sender: TObject);
begin
 Tool_Old:=Tool;
 Tool:=tOPL_AddNode;
end;

procedure TForm_Main.CheckBox_CoordSysClick(Sender: TObject);
begin
  GLSceneViewer.PopupMenu:=nil;
  If CheckBox_CoordSys.Checked=True then
  begin
    GLSceneViewer.PopupMenu:=PopupMenu_CoordinateSys;
  end;
end;

procedure TForm_Main.PopUp_CoordSys_CopyXYClick(Sender: TObject);
begin
  Clipboard.AsText:=IntToStr(CoordSys_X)+' ; '+IntToStr(CoordSys_Y);
end;

procedure TForm_Main.PopUp_CoordSys_CopyXYZClick(Sender: TObject);
begin
  Clipboard.AsText:='(xy '+IntToStr(CoordSys_X)+' '+IntToStr(CoordSys_Y)+' '+IntToStr(CoordSys_Z)+')';
end;

procedure TForm_Main.PopUp_CoordSys_CopyXYSpawnClick(Sender: TObject);
begin
  Clipboard.AsText:=IntToStr(round(CoordSys_X/32))+' '+IntToStr(round(CoordSys_Y/32));
end;

procedure TForm_Main.PopUp_CoordSys_CopyXClick(Sender: TObject);
begin
  Clipboard.AsText:=IntToStr(CoordSys_X);
end;

procedure TForm_Main.PopUp_CoordSys_CopyYClick(Sender: TObject);
begin
  Clipboard.AsText:=IntToStr(CoordSys_Y);
end;

procedure TForm_Main.PopUp_CoordSys_CopyZClick(Sender: TObject);
begin
  Clipboard.AsText:=IntToStr(CoordSys_Z);
end;

procedure TForm_Main.PopupMenu_CoordSys_CopyXYZClick(Sender: TObject);
begin
  Clipboard.AsText:=IntToStr(CoordSys_X)+' ; '+IntToStr(CoordSys_Y)+' ; '+IntToStr(CoordSys_Z);
end;

procedure TForm_Main.RadioButton_OPLRotationClick(Sender: TObject);
begin
  Edit_OPL_RotationX.Enabled:=False;
  Edit_OPL_RotationY.Enabled:=False;
  Edit_OPL_RotationZ.Enabled:=False;
  If RadioButton_OPLRotation_X.Checked=True then
  begin
    Edit_OPL_RotationX.Enabled:=True
  end;
  If RadioButton_OPLRotation_Y.Checked=True then
  begin
    Edit_OPL_RotationY.Enabled:=True
  end;
  If RadioButton_OPLRotation_Z.Checked=True then
  begin
    Edit_OPL_RotationZ.Enabled:=True
  end;

  If (tool=tOPL_RotateX) or (tool=tOPL_RotateY) or (tool=tOPL_RotateZ) then
  begin
        If RadioButton_OPLRotation_X.Checked=true then
        begin
          TOOL:=tOPL_RotateX;
        end;
        If RadioButton_OPLRotation_Y.Checked=true then
        begin
          TOOL:=tOPL_RotateY;
        end;
        If RadioButton_OPLRotation_Z.Checked=true then
        begin
          TOOL:=tOPL_RotateZ;
        end;
  end;

end;

procedure TForm_Main.MainMenu_File_SaveKCMFileAsClick(Sender: TObject);
var
  saveDialog:TSaveDialog;
begin
  saveDialog:=TSaveDialog.Create(Form_Main);
  saveDialog.Title:='Save your KalClientMap';
  saveDialog.InitialDir:=KCMInital_Path;
  saveDialog.Filter := 'Kal Client Maps|*.kcm;';
  saveDialog.DefaultExt := 'kcm';
  saveDialog.FileName:='n_0'+IntToStr(KCM.Header.MapX)+'_0'+IntToStr(KCM.Header.MapY)+'.kcm';
  If SaveDialog.Execute Then
  begin
    KCM.SaveToFile(saveDialog.FileName);
    MessageBox(handle,PChar('Succesfully saved KCM file to '''+KCM.FileLocation+''''),'Saving succeed',mb_ok);
    KCM.Saved:=True;
  end;
end;

procedure TForm_Main.CheckBox_OPLGeneral_RotateWClick(Sender: TObject);
begin
  Edit_OPL_RotationW.Enabled:=False;
  If CheckBox_OPLGeneral_RotateW.Checked=True then
  begin
    Edit_OPL_RotationW.Enabled:=True;
    ShowMessage('Enabling ''W'' from the rotation is only recomanded when knowing what to do!');
  end;
end;

procedure TForm_Main.Button_OPLGeneral_SaveClick(Sender: TObject);
var
  Vector4F:TVector4F;
  Vector3F:TVector3F;
begin
  //Saving path
  OPL.Node[selected_OPLs[0].Index].Path:=Edit_OPL_Model.text;

  //Saving Position
  Vector3F[0]:=StrToFloat(Edit_OPL_PosX.text)/8192;
  Vector3F[1]:=1-(StrToFloat(Edit_OPL_PosY.text)/8192);
  Vector3F[2]:=StrToFloat(Edit_OPL_PosZ.text)/8192;
  OPL.Node[selected_OPLs[0].Index].Position:=Vector3F;
end;

procedure TForm_Main.MainMenu_KCMFile_HeaderInfoClick(Sender: TObject);
begin
  Form_MapXY.SetKCMMapXY;
end;

procedure TForm_Main.MainMenu_OPLFile_HeaderInfoClick(Sender: TObject);
begin
  Form_MapXY.SetOPLMapXY;
end;

procedure TForm_Main.MainMenu_KCM_NewKCMFileClick(Sender: TObject);
var
  x1,y1:Integer;
  HeightMap:TKCMHeightMap;
  ColorMap:TKCMColorMap;
begin
  //Cleaning old data
  If KCM<>nil then
  begin
    KCM.Free;
  end;

  //Creating new KCM
  KCM:=TKalClientMap.Create;
  KCM.Header:=TKCMHeader.Create;

  //Prompt for map X/Y
  Form_MapXY.SetKCMMapXY;

  //Creating heightmap
  For x1:=0 to 256 do
  begin
    For y1:=0 to 256 do
    begin
      HeightMap[x1][y1]:=1400;
    end;
  end;
  KCM.HeightMap:=HeightMap;

  //Creating color map
  For x1:=0 to 256 do
  begin
    For y1:=0 to 256 do
    begin
      ColorMap[x1][y1][0]:=100;
      ColorMap[x1][y1][1]:=100;
      ColorMap[x1][y1][2]:=100;
    end;
  end;
  KCM.ColorMap:=ColorMap;
  KCM.Saved:=False;

  MessageBox(Handle,PChar('KCM succesfully created, a few things for you to set:'+#13+#13'- Texture layers( for now its filled in as Grey)'+#13+'- Color Map'),'Succesfully Created a new KCM',mb_ok);

  GlHeightField.OnGetHeight:=GLHeightFieldPaintColorMap;
  GLHeightField.StructureChanged
end;

procedure TForm_Main.Button_LayerCenterClick(Sender: TObject);
begin
  Form_LayerCenter.Show;
end;

procedure TForm_Main.ResetRealm;
begin
  //Resetting Camera Positions
  GlCamera.Position.X:=127;
  GlCamera.Position.Y:=250;
  GlCamera.Position.Z:=300;

  //Resetting DummyCube's Positions
  GlDummyCube.Position.X:=127;
  GlDummyCube.Position.Y:=0;
  GlDummyCube.Position.Z:=127;

  //Reseting the KCM
  GlHeightField.Position.X:=0;
  GlHeightField.Position.Y:=0;
  GlHeightField.Position.Z:=0;

  //Resetting the OPL Objects
  GlDummyCube_OPLObjects.Position.X:=0;
  GlDummyCube_OPLObjects.Position.Y:=0;
  GlDummyCube_OPLObjects.Position.Z:=0;
end;

procedure TForm_Main.MainMenu_File_NewOPLFileClick(Sender: TObject);
begin
        Try
         // OPL.Free;
        except
        end;
  OPL:=TOPLFile.Create;
  Form_MapXY.SetOPLMapXY;
end;


procedure TForm_Main.Button_OPL_BrowseModelClick(Sender: TObject);
begin
  //If FileExists(Form_Main.Client_Path+'\'+Edit_OPL_Model.Text)= true then
  //begin
  Form_BrowseModel.SelectFile(selected_OPLs[0].Index);
  //end;
end;

procedure TForm_Main.CheckBox_ShowOPLModelsClick(Sender: TObject);
begin
  If OPL<>nil then
  begin
    PositionOPL(True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
  end;
end;

procedure TForm_Main.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  x1,x2,x3:Integer;
  x,y:byte;
  NotNil:Boolean;
  OPLnode:TOPLNode;
  Model:TGLFreeForm;
  Selected_OPL:TSelected_OPL;
  NotChanged:Boolean;
  Vector3F:TVector3F;
begin
  If (tool=tOPL_RotateX) or (tool=tOPL_RotateY) or (tool=tOPL_RotateZ) or (tool=tOPL_Position) or (tool=tOPL_Scale) then
  begin
    If (Screen.ActiveControl<>TWinControl(Edit_OPL_Model)) and ((GetKeyState(VK_Delete) AND 128)=128)  then
    begin
      If MessageBox(0,PChar('Are you sure you want to delete the selected node?'),Pchar('Delete this node?'),mb_YesNo)=IDYES then
      begin
        If Length(Selected_OPLs)=0 then
        begin
          exit;
        end;

        //Ordening From lowest index to highest
        For x2:=0 to Length(selected_OPLs)-1 do
        begin
          NotChanged:=True;
          For x1:=0 to Length(Selected_OPLs)-2 do
          begin
            If (Selected_OPLs[x1+1].index<Selected_OPLs[x1].index) then
            begin
              //Backing up the record;
              Selected_OPL.Index:=Selected_OPLs[x1+1].Index;
              Selected_OPL.Tex:=Selected_OPLs[x1+1].Tex;

              //Shifting the other record
              Selected_OPLs[x1+1].Index:=Selected_OPLs[x1].Index ;
              Selected_OPLs[x1+1].Tex:=Selected_OPLs[x1].Tex;

              //Reentering the backed up record
              Selected_OPLs[x1].Index:=Selected_OPL.Index;
              Selected_OPLs[x1].Tex:=Selected_OPL.Tex;

              //We changed it, so notchanged = false
              NotChanged:=False;
            end;
          end;
          //If the array hasn't been change then everything is alligned...
          If NotChanged=True then
          begin
            Break;
          end;
        end;

        //The actual deleting
        For x1:=Length(Selected_OPLs)-1 downto 0 do
        begin
          //Deleting the Node in the OPL file...
          OPL.RemoveObject(Selected_OPLs[x1].Index);

          //Shifting the other models;
          For x2:=Selected_OPLs[x1].Index to OPL.ObjectCount-2 do
          begin
            GlDummyCube_OPLObjects.Children[x2].Assign(GLDummyCube_OPLObjects.Children[x2+1]);
          end;
          GLDummyCube_OPLObjects.Children[OPL.ObjectCount].Free;
        end;

        //Reseting the selected OPLs info
        SetLength(Selected_OPLs,0);
      end;
    end;
  end;

  If ((GetKeyState(VK_CONTROL) AND 128)=128)  and ((GetKeyState(Ord('Z')) AND 128)=128)  then
  begin
    NotNil:=False;
    for x:=0 to 255 do
    begin
      for y:=0 to 255 do
      begin
        If  Previous_KCM[0][x][y]>0 then
        begin
          NotNil:=True;
          break;
          break;
        end;
      end;
    end;
    If Notnil=True then
    begin
      KCM.Heightmap:=Previous_KCM[0];

      GLHeightField.StructureChanged;
      For x1:=0 to 8 do
      begin
        Previous_KCM[x1]:=Previous_KCM[x1+1];
        //Previous_KSM[x1]:=Previous_KSM[x1+1];
        //Previous_OPL[x1]:=Previous_OPL[x1+1];
      end;
      Previous_KCM[9]:=Nilled_KCM;
      //Previous_KSM[9]:=nil;
      //Previous_OPL[9]:=nil;
    end;
  end;

  If (TOOL=tOPL_Position) or (TOOL=tOPL_Scale) or (TOOL=tOPL_RotateX)  or (TOOL=tOPL_RotateY) or (TOOL=tOPL_RotateZ) then
  begin
    If ((GetKeyState(Ord('D')) AND 128)=128) then
    begin
      If Length(Selected_OPLs)=0 then
      begin
        exit;
      end;
        //Ordening From lowest index to highest
        For x2:=0 to Length(selected_OPLs)-1 do
        begin
          NotChanged:=True;
          If Length(Selected_OPLs)>1 then
          begin
            For x1:=0 to Length(Selected_OPLs)-2 do
            begin
              If (Selected_OPLs[x1+1].index<Selected_OPLs[x1].index) then
              begin
                //Backing up the record;
                Selected_OPL.Index:=Selected_OPLs[x1+1].Index;
                Selected_OPL.Tex:=Selected_OPLs[x1+1].Tex;

                //Shifting the other record
                Selected_OPLs[x1+1].Index:=Selected_OPLs[x1].Index ;
                Selected_OPLs[x1+1].Tex:=Selected_OPLs[x1].Tex;

                //Reentering the backed up record
                Selected_OPLs[x1].Index:=Selected_OPL.Index;
                Selected_OPLs[x1].Tex:=Selected_OPL.Tex;

                //We changed it, so notchanged = false
                NotChanged:=False;
              end;
            end;
            //If the array hasn't been change then everything is alligned...
            If NotChanged=True then
            begin
              Break;
            end;
          end;
        end;
      For x1:=0 to Length(Selected_OPLs)-1 do
      begin
        //Creating new OPL
        OPLNode:=TOPLNode.Create;

        //Setting info
        OPLNode.Path:=OPL.Node[Selected_OPLs[x1].Index].Path;
        OPLNode.PathLength:=Length(OPL.Node[Selected_OPLs[x1].Index].Path);
        Vector3F[0]:=OPL.Node[Selected_OPLs[x1].Index].Position[0]+(1/256);
        VEctor3F[1]:=OPL.Node[Selected_OPLs[x1].Index].Position[1]+(1/256);
        If CheckBox_OPL_Position_STM.Checked=true then
        begin
          Vector3F[2]:=KCM.HeightMap[round((OPL.Node[Selected_OPLs[x1].Index].Position[0]+(1/256))*256)][round(256-((OPL.Node[Selected_OPLs[x1].Index].Position[1]+(1/256))*256))];
        end
        else
        begin
          Vector3F[2]:=OPL.Node[Selected_OPLs[x1].Index].Position[2];
        end;

        //OPLNode.Position:=Vector3F(OPL.Node[Selected_OPLs[x1].Index].Position[0]+(1/256),OPL.Node[Selected_OPLs[x1].Index].Position[1]+(1/256),KCM.HeightMap[round((OPL.Node[Selected_OPLs[x1].Index].Position[0]+(1/256))*256)][round(256-((OPL.Node[Selected_OPLs[x1].Index].Position[1]+(1/256))*256))]);
        OPLNode.Position:=Vector3F;
        OPLNode.Scale:=OPL.Node[Selected_OPLs[x1].Index].Scale;
        OPLNode.Rotation:=OPL.Node[Selected_OPLs[x1].Index].Rotation;

        //Adding the node
        OPL.AddObject(OPLNode);

        //Displaying the node
        PositionOPLNode(OPL.ObjectCount-1,True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

        //Restoring old selected OPLs textures
        Model:=TGLFreeForm(GLDummyCube_OPLObjects.Children[Selected_OPLs[x1].Index]);
        model.Material.LibMaterialName:=Selected_OPLs[x1].Tex;
        model.Material.frontproperties.emission.color:=clrblack;

        //Selecting the just created OPL node...
        Selected_OPLs[x1].Index:=OPL.ObjectCount-1;

        //Making new selected OPL node red...
        Model:=TGLFreeForm(GLDummyCube_OPLObjects.Children[Selected_OPLs[x1].Index]);
        Model.Material.LibMaterialName:='';
        Model.material.frontproperties.emission.color:=clrred;
      end;

      //Displaying the info
      DisplayOPLNodeInfo(Selected_OPLs);

      OPL.ObjectCount;
    end;
  end;
end;

procedure TForm_Main.Edit_OPL_ModelKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
  begin
    PositionOPLNode(selected_OPLs[0].Index,True,CheckBox_ShowOPLModels.Checked);
  end;
end;

procedure TForm_Main.Timer_AutoSaveTimer(Sender: TObject);
var
  s:String;
begin
  ForceDirectories(ExtractFilePath(Application.Exename)+'AutoSaves');
  If OPL<>nil then
  begin
    try
    s:=OPL.FileLocation;
    OPL.SaveToFile(ExtractFilePath(Application.Exename)+'AutoSaves\AutoSave_OPL.OPL');
    OPL.FileLocation:=s;
    except
    end;
  end;

  If KCM<>nil then
  begin
    try
    s:=KCM.FileLocation;
    KCM.SaveToFile(ExtractFilePath(Application.Exename)+'AutoSaves\AutoSave_KCM.KCM');
    KCM.FileLocation:=s;
    except
    end;
  end;

  If KSM<>nil then
  begin
    try
    s:=KSM.FileLocation;
    KSM.SaveToFile(ExtractFilePath(Application.Exename)+'AutoSaves\AutoSave_KSM.KSM');
    KSM.FileLocation:=s;
    except
    end;
  end;
end;

procedure TForm_Main.CheckBox_ShowOPLTexturesClick(Sender: TObject);
var
  x1:Integer;
begin
  If OPL<>nil then
  begin
    for x1:=0 to OPL.ObjectCount-1 do
    begin
      PositionOPLNode(x1,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
    end;
  end;
end;

end.

