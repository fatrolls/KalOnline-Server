unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellApi, dds, jpeg, KalClientMap;

type
  TForm_LayerCenter = class(TForm)
    Image_LayerPreview: TImage;
    GroupBox_LayerPreview: TGroupBox;
    GroupBox_LayerPaint: TGroupBox;
    RadioButton_KCMColorMap: TRadioButton;
    RadioButton_KCMTextureLayer: TRadioButton;
    RadioButton_KCMMinimap: TRadioButton;
    GroupBox_LayerPaintKCM: TGroupBox;
    GroupBox_LayerPaintKSM: TGroupBox;
    RadioButton_KSM: TRadioButton;
    GroupBox_LayerPaintOther: TGroupBox;
    RadioButton_LoadFromFile: TRadioButton;
    Edit1: TEdit;
    Button_LoadFromFile: TButton;
    ComboBox_LayerPaintTextureLayers: TComboBox;
    GroupBox_SaveToFile: TGroupBox;
    RadioButton_Save_KSM: TRadioButton;
    RadioButton_Save_ColorMap: TRadioButton;
    RadioButton_Save_Minimap: TRadioButton;
    RadioButton_Save_TextureLayer: TRadioButton;
    ComboBox_SaveToFileTextureLayer: TComboBox;
    Button_SaveToFile: TButton;
    Button_SaveAllToFile: TButton;
    procedure LayerPaint_RadioButtonsClick(Sender: TObject);
    procedure Check;
    procedure FormShow(Sender: TObject);
    procedure ComboBox_LayerPaintTextureLayersChange(Sender: TObject);
    procedure Button_LoadFromFileClick(Sender: TObject);
    procedure Button_SaveToFileClick(Sender: TObject);
    procedure Button_SaveAllToFileClick(Sender: TObject);
    procedure RadioButton_Save_Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_LayerCenter: TForm_LayerCenter;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm_LayerCenter.LayerPaint_RadioButtonsClick(Sender: TObject);
begin
  Check;
end;

procedure TForm_LayerCenter.Check;
var
  x,y:integer;
  sX,sY:Integer;
  Map,MapX,MapY,MinimapName,FileName:String;
  Minimap:TImage;
  GTXLoc,DDSLoc:String;
  BMP:TBitmap;
  DDS:TDDSImage;
  JPG:TJPEGImage;
begin

  If RadioButton_KSM.Checked=True then
  begin
    Form_Main.GLHeightField.OnGetHeight:=Form_Main.GLHeightFieldPaintKSMMap;
    Form_Main.GLHeightField.StructureChanged;
    For x:=0 to 255 do
    begin
      For y:=0 to 255 do
      begin
        Form_Main.Image_General.Canvas.Pixels[x,y]:=Form_Main.KSM.Map[x][y][2];
        Image_layerPreview.Canvas.Pixels[x,y]:=Form_Main.KSM.Map[x][y][2];
      end;
    end;
  end;
  If RadioButton_KCMColorMap.Checked=True then
  begin
    Form_Main.GLHeightField.OnGetHeight:=Form_Main.GLHeightFieldPaintColorMap;
    Form_Main.GLHeightField.StructureChanged;
    For x:=0 to 255 do
    begin
      For y:=0 to 255 do
      begin
        Form_Main.Image_General.Canvas.Pixels[x,y]:=rgb(Form_Main.KCM.Colormap[x][y][0],Form_Main.KCM.Colormap[x][y][1],Form_Main.KCM.Colormap[x][y][2]);
        Image_layerPreview.Canvas.Pixels[x,y]:=rgb(Form_Main.KCM.Colormap[x][y][0],Form_Main.KCM.Colormap[x][y][1],Form_Main.KCM.Colormap[x][y][2]);
      end;
    end;
  end;
  If RadioButton_KCMTextureLayer.Checked=True then
  begin
    Try
      If (StrToInt(ComboBox_LayerPaintTextureLayers.Text)<=7) and  (StrToInt(ComboBox_LayerPaintTextureLayers.Text)>=0) then
      begin
        Form_Main.CurTMap:=StrToInt(ComboBox_LayerPaintTextureLayers.Text);
        Form_Main.GLHeightField.OnGetHeight:=Form_Main.GLHeightFieldPaintTextureMap;
        Form_Main.GLHeightField.StructureChanged;
        For x:=0 to 255 do
        begin
          For y:=0 to 255 do
          begin
            Form_Main.Image_General.Canvas.Pixels[x,y]:=rgb(Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y]);
            Image_layerPreview.Canvas.Pixels[x,y]:=rgb(Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y]);
          end;
        end;
      end;
    except
    end;
  end;
  If RadioButton_KCMMInimap.Checked=True then
  begin
    //new minimap system: Getting coords

    //Old minimap system: getting single number:
    If (Form_Main.KCM.Header.MapX>=26) and (Form_Main.KCM.Header.MapX<=35) and (Form_Main.KCM.Header.MapY<=39) and (Form_Main.KCM.Header.MapY>=22) then
    begin
      //Old minimap system
      Map:=IntToStr(((Form_Main.KCM.Header.MapX-26) div 2)+(((39-Form_Main.KCM.Header.MapY) div 2)*5));
      For x:=0 to 2 do
      begin
        If Length(Map)<3 then
        begin
          Map:='0'+map;
        end
        else
        begin
          break;
        end;
      end;
      MinimapName:='minimap_n_e_'+map;
    end
    else
    begin
      //New Minimap System
      MapX:=IntToStr((Form_Main.KCM.Header.MapX div 2)*2);
      MapY:=IntToStr((Form_Main.KCM.Header.MapY div 2)*2);

      For x:=0 to 2 do
      begin
        If Length(MapX)<3 then
        begin
          MapX:='0'+mapX;
        end
        else
        begin
          break;
        end;

        If Length(MapY)<3 then
        begin
          MapY:='0'+mapY;
        end
        else
        begin
          break;
        end;
      end;
      MinimapName:='minimap_n_e_'+MapX+'_'+MapY;
    end;



    //Checking if file exists:
    GTXLoc:= Form_Main.Client_Path+'data\HyperText\MiniMap\e\'+MinimapName+'.gtx';
    If FileExists(GTXLoc)=true then
    begin
      DDSLoc:=ExtractFileDir(Application.ExeName)+'\Recources\'+MinimapName+'.dds';
      if fileexists(DDSLoc)=false then
      begin
        ConvertGTX2DDS(GTXLoc,DDSLoc,ExtractFilePath(Application.Exename)+'Recources\encrypt.dat',ExtractFilePath(Application.Exename)+'Recources\decrypt.dat');
      end;

      //Prepairing pica
      Minimap:=TImage.Create(nil);
      Minimap.Height:=256;
      Minimap.Width:=256;
      Minimap.Picture.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Recources\'+MinimapName+'.dds');

      //Preparing Form_Main's Minimap;
      If Form_Main.KCMMinimap=nil then
      begin
        Form_Main.KCMMinimap:=TBitmap.Create();
        Form_Main.KCMMinimap.Height:=256;
        Form_Main.KCMMinimap.Width:=256;
      end;

      //Prepairing
      sX:=round(((Form_Main.KCM.Header.MapX / 2)-(Form_Main.KCM.Header.MapX div 2))*256);
      sY:=round(((Form_Main.KCM.Header.MapY / 2)-(Form_Main.KCM.Header.MapY div 2))*256);
      For x:=0 to 256 do
      begin
        For y:=0 to 256 do
        begin
          Image_LayerPreview.Canvas.Pixels[x,y]:=Minimap.Canvas.Pixels[(x div 2)+sX,(y div 2)+(128-sY)];
          Form_Main.Image_General.Canvas.Pixels[x,y]:=Minimap.Canvas.Pixels[(x div 2)+sX,(y div 2)+(128-sY)];
          Form_Main.KCMMinimap.Canvas.Pixels[x,y]:=Minimap.Canvas.Pixels[(x div 2)+sX,(y div 2)+(128-sY)];
        end;
      end;

      //Deleting Prepaired pica;
      Minimap.Free;

      //Setting KCM's OnHeight procedure
      Form_Main.GLHeightField.OnGetHeight:=Form_Main.GLHeightFieldPaintMiniMap;
      Form_Main.GLHeightField.StructureChanged;
    end;
  end;

  If RadioButton_LoadFromFile.Checked=True then
  begin
    If FileExists(Edit1.Text)=true then
    begin
      BMP:=TBitmap.Create;
      FileName:=Edit1.Text;
      if LowerCase(ExtractFileExt(Edit1.Text))='.gtx' then
      begin
        GTXLoc:=Edit1.Text;
        If FileExists(GTXLoc)=true then
        begin
          DDSLoc:=ExtractFileDir(Application.ExeName)+'\Recources\'+Copy(ExtractFileName(Edit1.Text),0,Length(ExtractFileName(Edit1.Text))-Length(ExtractFileExt(Edit1.Text)))+'.dds';
          if fileexists(DDSLoc)=false then
          begin
            ConvertGTX2DDS(GTXLoc,DDSLoc,ExtractFilePath(Application.Exename)+'Recources\encrypt.dat',ExtractFilePath(Application.Exename)+'Recources\decrypt.dat');
          end;
          //TODO: Load DDS and covert to BMP
          DDS:=TDDSImage.Create;
          DDS.LoadFromFile(DDSLoc);
          BMP.Assign(DDS);
        end;
      end;
      if LowerCase(ExtractFileExt(Edit1.Text))='.dds' then
      begin
        DDS:=TDDSImage.Create;
        DDS.LoadFromFile(DDSLoc);
        BMP.Assign(DDS);
      end;

      if LowerCase(ExtractFileExt(FileName))='.jpg' then
      begin
        JPG:=TJPEGImage.Create;
        JPG.LoadFromFile(FileName);
        BMP.Assign(JPG);
      end;

      if LowerCase(ExtractFileExt(FileName))='.bmp' then
      begin
        BMP.LoadFromFile(FileName);
      end;

      //Prepairing pica
      Minimap:=TImage.Create(nil);
      Minimap.Height:=256;
      Minimap.Width:=256;
      Minimap.Picture.Assign(BMP);

      //Preparing Form_Main's Pica;
      try
        Form_Main.KCMCustomPic.Free;
      except
      end;

      Form_Main.KCMCustomPic:=TBitmap.Create();
      Form_Main.KCMCustomPic.Height:=256;
      Form_Main.KCMCustomPic.Width:=256;

      //Loading Pica to minimap and customPic
      If (Minimap.Picture.Width<=128) and (Minimap.Picture.Height<=128) then
      begin
        For x:=0 to 256 do
        begin
          For y:=0 to 256 do
          begin
            try
              Image_LayerPreview.Canvas.Pixels[x,y]:=Minimap.Canvas.Pixels[(x div 2),(y div 2)];
              Form_Main.Image_General.Canvas.Pixels[x,y]:=Minimap.Canvas.Pixels[(x div 2),(y div 2)];
              Form_Main.KCMCustomPic.Canvas.Pixels[x,y]:=Minimap.Canvas.Pixels[(x div 2),(y div 2)];
            except
            end;
          end;
        end;
      end
      else
      begin
        For x:=0 to 256 do
        begin
          For y:=0 to 256 do
          begin
            try
              Image_LayerPreview.Canvas.Pixels[x,y]:=Minimap.Canvas.Pixels[x,y];
              Form_Main.Image_General.Canvas.Pixels[x,y]:=Minimap.Canvas.Pixels[x,y];
              Form_Main.KCMCustomPic.Canvas.Pixels[x,y]:=Minimap.Canvas.Pixels[x,y];
            except
            end;
          end;
        end;
      end;




        
      Form_Main.GLHeightField.OnGetHeight:=Form_Main.GLHeightFieldPaintCustomPic;
      Form_Main.GLHeightField.StructureChanged;

      //Deleting Prepaired pica;
      Try
        Minimap.Free;
      except
      end;
    end
    else
    begin
      ShowMessage('Image location doesn''t exists');
    end;
  end;
end;

procedure TForm_LayerCenter.FormShow(Sender: TObject);
var
  x,y:Integer;
begin
  RadioButton_Save_KSM.Enabled:=True;
  RadioButton_Save_ColorMap.Enabled:=True;
  RadioButton_Save_Minimap.Enabled:=True;
  RadioButton_Save_TextureLayer.Enabled:=True;
  RadioButton_KSM.Enabled:=True;
  RadioButton_KCMColorMap.Enabled:=True;
  RadioButton_KCMMinimap.Enabled:=True;
  RadioButton_KCMTextureLayer.Enabled:=True;
  RadioButton_LoadFromFile.Enabled:=True;

  ComboBox_LayerPaintTextureLayers.Enabled:=True;
  If Form_Main.KSM=nil then
  begin
    RadioButton_KSM.Enabled:=False;
    RadioButton_KSM.Checked:=False;
    RadioButton_Save_KSM.Enabled:=False;
    RadioButton_Save_KSM.Checked:=False;
  end;

  If Form_Main.KCM=nil then
  begin
    RadioButton_KCMColorMap.Enabled:=False;
    RadioButton_KCMMinimap.Enabled:=False;
    RadioButton_KCMTextureLayer.Enabled:=False;
    RadioButton_Save_ColorMap.Enabled:=False;
    RadioButton_Save_Minimap.Enabled:=False;
    RadioButton_Save_TextureLayer.Enabled:=False;
    ComboBox_LayerPaintTextureLayers.Enabled:=False;
  end;

  If Form_Main.TOOL=tKSM_PaintBrush then
  begin
    RadioButton_KSM.Checked:=True;

    RadioButton_KCMColorMap.Enabled:=False;
    RadioButton_KCMMinimap.Enabled:=False;
    RadioButton_KCMTextureLayer.Enabled:=False;
    RadioButton_LoadFromFile.Enabled:=False;
  end;

  //Checking for already loaded layers;
  If Form_Main.TOOL=tKCM_TexturePaint then
  begin
    For x:=0 to 255 do
    begin
      For y:=0 to 255 do
      begin
        Form_Main.Image_General.Canvas.Pixels[x,y]:=rgb(Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y]);
        Image_layerPreview.Canvas.Pixels[x,y]:=rgb(Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y]);
      end;
    end;
    RadioButton_KCMTextureLayer.Checked:=True;
  end;
end;

procedure TForm_LayerCenter.ComboBox_LayerPaintTextureLayersChange(Sender: TObject);
var
  x,y:integer;
begin
  If RadioButton_KCMTextureLayer.Checked=True then
  begin
    Try
      If (StrToInt(ComboBox_LayerPaintTextureLayers.Text)<=7) and  (StrToInt(ComboBox_LayerPaintTextureLayers.Text)>=0) then
      begin
        Form_Main.CurTMap:=StrToInt(ComboBox_LayerPaintTextureLayers.Text);
        Form_Main.GLHeightField.OnGetHeight:=Form_Main.GLHeightFieldPaintTextureMap;
        Form_Main.GLHeightField.StructureChanged;
        For x:=0 to 255 do
        begin
          For y:=0 to 255 do
          begin
            Image_LayerPreview.Canvas.Pixels[x,y]:=RGB(Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y]);
            Form_Main.Image_General.Canvas.Pixels[x,y]:=RGB(Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y]);
          end;
        end;
      end;
    except
    end;
  end;
end;

procedure TForm_LayerCenter.Button_LoadFromFileClick(Sender: TObject);
var
  OpenFileDialog:TOpenDialog;
begin
    OpenFileDialog:=TOpenDialog.Create(nil);
    OpenFileDialog.Filter:='Supported Images (*.bmp, *.jpg, *.dds, *.gtx)|*.bmp;*.dds;*.gtx;*.jpg';
    OpenFileDialog.Title:='Open image...';
    OpenFileDialog.Options:=[ofHideReadOnly,ofEnableSizing];
    //OpenFileDialog.InitialDir:=KCMInital_Path;
    If OpenFileDialog.Execute Then
    begin
      Edit1.Text:=OpenFileDialog.FileName;
      RadioButton_LoadFromFile.Checked:=True;
      Check;

    end;
end;

procedure TForm_LayerCenter.Button_SaveToFileClick(Sender: TObject);
var
  BMP:TBitmap;
  Minimap:TImage;
  Map,MapX,MapY,MinimapName,FileName:String;
  x1,y1:Integer;
  sX,sY:Integer;
  values:TValues;
  GTXLoc,DDSLoc:String;
  Jpg:TJPEGImage;
begin
  BMP:=TBitmap.Create;
  BMP.Width:=256;
  BMP.Height:=256;

  //Saving the KSM map;
  If RadioButton_Save_KSM.Checked=True then
  begin
    For x1:=0 to 256 do
    begin
      For y1:=0 to 256 do
      begin
        Values[1]:=Form_Main.KSM.map[x1][y1][0];
        Values[2]:=Form_Main.KSM.map[x1][y1][1];
        BMP.Canvas.Pixels[x1,y1]:=Form_Main.KSM.ValuesToColor(Values[1],Values[2]);
      end;
    end;
    {$I-}
      MkDir(ExtractFilePath(Application.ExeName)+'images');
      MkDir(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY));
    {$I+}
    BMP.SaveToFile(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY)+'\KSM - KSMMap.bmp');
  end;

  //Saving the colormap;
  If RadioButton_Save_ColorMap.Checked=True then
  begin
    For x1:=0 to 256 do
    begin
      For y1:=0 to 256 do
      begin
        BMP.Canvas.Pixels[x1,y1]:=RGB(Form_Main.KCM.ColorMap[x1][y1][0],Form_Main.KCM.ColorMap[x1][y1][1],Form_Main.KCM.ColorMap[x1][y1][2]);
      end;
    end;
    {$I-}
      MkDir(ExtractFilePath(Application.ExeName)+'images');
      MkDir(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY));
    {$I+}
    Jpg:=TJPEgImage.Create;
    Jpg.Assign(Bmp);
    Jpg.SaveToFile(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY)+'\KCM - ColorMap.jpg');
    Showmessage('done');
  end;

  //Saving minimap
  If RadioButton_Save_MiniMap.Checked=True then
  begin
    If (Form_Main.KCM.Header.MapX>=26) and (Form_Main.KCM.Header.MapX<=35) and (Form_Main.KCM.Header.MapY<=39) and (Form_Main.KCM.Header.MapY>=22) then
    begin
      //Old minimap system
      Map:=IntToStr(((Form_Main.KCM.Header.MapX-26) div 2)+(((39-Form_Main.KCM.Header.MapY) div 2)*5));
      For x1:=0 to 2 do
      begin
        If Length(Map)<3 then
        begin
          Map:='0'+map;
        end
        else
        begin
          break;
        end;
      end;
      MinimapName:='minimap_n_e_'+map;
    end
    else
    begin
      //New Minimap System
      MapX:=IntToStr((Form_Main.KCM.Header.MapX div 2)*2);
      MapY:=IntToStr((Form_Main.KCM.Header.MapY div 2)*2);

      For x1:=0 to 2 do
      begin
        If Length(MapX)<3 then
        begin
          MapX:='0'+mapX;
        end
        else
        begin
          break;
        end;

        If Length(MapY)<3 then
        begin
          MapY:='0'+mapY;
        end
        else
        begin
          break;
        end;
      end;
      MinimapName:='minimap_n_e_'+MapX+'_'+MapY;
    end;



    //Checking if file exists:
    GTXLoc:= Form_Main.Client_Path+'data\HyperText\MiniMap\e\'+MinimapName+'.gtx';
    If FileExists(GTXLoc)=true then
    begin
      DDSLoc:=ExtractFileDir(Application.ExeName)+'\Recources\'+MinimapName+'.dds';
      if fileexists(DDSLoc)=false then
      begin
        ConvertGTX2DDS(GTXLoc,DDSLoc,ExtractFilePath(Application.Exename)+'Recources\encrypt.dat',ExtractFilePath(Application.Exename)+'Recources\decrypt.dat');
      end;

      //Prepairing pica
      Minimap:=TImage.Create(nil);
      Minimap.Height:=256;
      Minimap.Width:=256;
      Minimap.Picture.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Recources\'+MinimapName+'.dds');

      //Preparing Form_Main's Minimap;
      If Form_Main.KCMMinimap=nil then
      begin
        Form_Main.KCMMinimap:=TBitmap.Create();
        Form_Main.KCMMinimap.Height:=256;
        Form_Main.KCMMinimap.Width:=256;
      end;

      //Prepairing
      sX:=round(((Form_Main.KCM.Header.MapX / 2)-(Form_Main.KCM.Header.MapX div 2))*256);
      sY:=round(((Form_Main.KCM.Header.MapY / 2)-(Form_Main.KCM.Header.MapY div 2))*256);
      For x1:=0 to 256 do
      begin
        For y1:=0 to 256 do
        begin
          BMP.Canvas.Pixels[x1,y1]:=Minimap.Canvas.Pixels[(x1 div 2)+sX,(y1 div 2)+(128-sY)];
        end;
      end;

      //Deleting Prepaired pica;
      Minimap.Free;

      //Saving it to BMP file
      {$I-}
        MkDir(ExtractFilePath(Application.ExeName)+'images');
        MkDir(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY));
      {$I+}
      BMP.SaveToFile(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY)+'\KCM - Minimap.bmp');

    end;
  end;

  //Saving TextureLayer
  If RadioButton_Save_TextureLayer.Checked=True then
  begin
    Try
      map:=IntToStr(StrToInt(ComboBox_SaveToFileTextureLayer.text));
      For x1:=0 to 256 do
      begin
        For y1:=0 to 256 do
        begin
          BMP.Canvas.Pixels[x1,y1]:=RGB(Form_Main.KCM.TextureMapList[StrToInt(map)][x1][y1],Form_Main.KCM.TextureMapList[StrToInt(map)][x1][y1],Form_Main.KCM.TextureMapList[StrToInt(Map)][x1][y1])
        end;
      end;
      {$I-}
        MkDir(ExtractFilePath(Application.ExeName)+'images');
        MkDir(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY));
      {$I+}
      BMP.SaveToFile(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY)+'\KCM - TextureMap '+map+ '.bmp');
    except
    end;
  end;
end;

procedure TForm_LayerCenter.Button_SaveAllToFileClick(Sender: TObject);
var
  BMP:TBitmap;
  Minimap:TImage;
  MapI:Integer;
  Map,MapX,MapY,MinimapName:String;
  x1,y1:Integer;
  sX,sY:Integer;
  values:TValues;
  GTXLoc,DDSLoc:STring;
  Jpg:TJpegImage;
begin
  If Form_Main.KCM=nil then
  begin
    Abort;
  end;
  BMP:=TBitmap.Create;
  BMP.Width:=256;
  BMP.Height:=256;

  //Saving the KSM map;
  If Form_Main.KSM<>nil then
  begin
    For x1:=0 to 256 do
    begin
      For y1:=0 to 256 do
      begin
        Values[1]:=Form_Main.KSM.map[x1][y1][0];
        Values[2]:=Form_Main.KSM.map[x1][y1][1];
        BMP.Canvas.Pixels[x1,y1]:=Form_Main.KSM.ValuesToColor(Values[1],Values[2]);
      end;
    end;
    {$I-}
      MkDir(ExtractFilePath(Application.ExeName)+'images');
      MkDir(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY));
    {$I+}
    Jpg:=TJPEgImage.Create;
    Jpg.Assign(Bmp);
    Jpg.SaveToFile(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY)+'\KSM - KSMMap.jpg');
  end;

  //works until ksm

  //Saving the colormap;
  If Form_Main.KCM<>nil then
  begin
    For x1:=0 to 256 do
    begin
      For y1:=0 to 256 do
      begin
        BMP.Canvas.Pixels[x1,y1]:=RGB(Form_Main.KCM.ColorMap[x1][y1][0],Form_Main.KCM.ColorMap[x1][y1][1],Form_Main.KCM.ColorMap[x1][y1][2]);
      end;
    end;
    {$I-}
      MkDir(ExtractFilePath(Application.ExeName)+'images');
      MkDir(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY));
    {$I+}
    Jpg:=TJPEgImage.Create;
    Jpg.Assign(Bmp);
    Jpg.SaveToFile(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY)+'\KCM - ColorMap.jpg');
  end;

  //Saving minimap
  If (Form_Main.KCM.Header.MapX>=26) and (Form_Main.KCM.Header.MapX<=35) and (Form_Main.KCM.Header.MapY<=39) and (Form_Main.KCM.Header.MapY>=22) then
  begin
    //Old minimap system
    Map:=IntToStr(((Form_Main.KCM.Header.MapX-26) div 2)+(((39-Form_Main.KCM.Header.MapY) div 2)*5));
    For x1:=0 to 2 do
    begin
      If Length(Map)<3 then
      begin
        Map:='0'+map;
      end
      else
      begin
        break;
      end;
    end;
    MinimapName:='minimap_n_e_'+map;
  end
  else
  begin
    //New Minimap System
    MapX:=IntToStr((Form_Main.KCM.Header.MapX div 2)*2);
    MapY:=IntToStr((Form_Main.KCM.Header.MapY div 2)*2);

    For x1:=0 to 2 do
    begin
      If Length(MapX)<3 then
      begin
        MapX:='0'+mapX;
      end
      else
      begin
        break;
      end;

      If Length(MapY)<3 then
      begin
        MapY:='0'+mapY;
      end
      else
      begin
        break;
      end;
    end;
    MinimapName:='minimap_n_e_'+MapX+'_'+MapY;
  end;

    GTXLoc:= Form_Main.Client_Path+'data\HyperText\MiniMap\e\'+MinimapName+'.gtx';
    If FileExists(GTXLoc)=true then
    begin
      DDSLoc:=ExtractFileDir(Application.ExeName)+'\Recources\'+MinimapName+'.dds';
      if fileexists(DDSLoc)=false then
      begin
        ConvertGTX2DDS(GTXLoc,DDSLoc,ExtractFilePath(Application.Exename)+'Recources\encrypt.dat',ExtractFilePath(Application.Exename)+'Recources\decrypt.dat');
      end;

    //Prepairing pica
    Minimap:=TImage.Create(nil);
    Minimap.Height:=256;
    Minimap.Width:=256;
    Minimap.Picture.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Recources\'+MinimapName+'.dds');

    //Preparing Form_Main's Minimap;
    If Form_Main.KCMMinimap=nil then
    begin
      Form_Main.KCMMinimap:=TBitmap.Create();
      Form_Main.KCMMinimap.Height:=256;
      Form_Main.KCMMinimap.Width:=256;
    end;

    //Prepairing
    sX:=round(((Form_Main.KCM.Header.MapX / 2)-(Form_Main.KCM.Header.MapX div 2))*256);
    sY:=round(((Form_Main.KCM.Header.MapY / 2)-(Form_Main.KCM.Header.MapY div 2))*256);
    For x1:=0 to 256 do
    begin
      For y1:=0 to 256 do
      begin
        BMP.Canvas.Pixels[x1,y1]:=Minimap.Canvas.Pixels[(x1 div 2)+sX,(y1 div 2)+(128-sY)];
      end;
    end;

    //Deleting Prepaired pica;
    Minimap.Free;

    //Saving it to BMP file
    {$I-}
      MkDir(ExtractFilePath(Application.ExeName)+'images');
      MkDir(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY));
    {$I+}
    Jpg.Assign(BMP);
    Jpg.SaveToFile(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY)+'\KCM - Minimap.jpg');
  end;

  //Saving TextureLayer
  Try
    For mapi:=0 to 7 do
    begin
      If Form_Main.KCM.Header.TextureList[mapi]<>0 then
      begin
        For x1:=0 to 256 do
        begin
          For y1:=0 to 256 do
          begin
            BMP.Canvas.Pixels[x1,y1]:=RGB(Form_Main.KCM.TextureMapList[mapi][x1][y1],Form_Main.KCM.TextureMapList[mapi][x1][y1],Form_Main.KCM.TextureMapList[mapi][x1][y1])
          end;
        end;
      end;
      {$I-}
        MkDir(ExtractFilePath(Application.ExeName)+'images');
        MkDir(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY));
      {$I+}
      Jpg.Assign(BMP);
      Jpg.SaveToFile(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(Form_Main.KCM.Header.MapX)+'_0'+IntToStr(Form_Main.KCM.Header.MapY)+'\KCM - TextureMap '+IntToStr(mapi)+ '.jpg');
    end;
  except

  end;
end;


procedure TForm_LayerCenter.RadioButton_Save_Click(Sender: TObject);
begin
  If RadioButton_Save_KSM.Checked=True Then
  begin
    RadioButton_KSm.Checked:=True;
  end;

  If RadioButton_Save_ColorMap.Checked=True Then
  begin
    RadioButton_KCMColorMap.Checked:=True;
  end;

  If RadioButton_Save_Minimap.Checked=True Then
  begin
    RadioButton_KCMMinimap.Checked:=True;
  end;

  If RadioButton_Save_TextureLayer.Checked=True Then
  begin
    RadioButton_KCMTextureLayer.Checked:=True;
  end;
  Check;
end;

end.
