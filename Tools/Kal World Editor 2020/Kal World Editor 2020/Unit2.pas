unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, dds, ShellApi, INIFiles, KalClientMap;

type
  TForm_KCMTextureCenter = class(TForm)
    GroupBox_Texture: TGroupBox;
    Image_Texture: TImage;
    GroupBox_TextureMap: TGroupBox;
    Image_TextureMap: TImage;
    ListBox_TextureList: TListBox;
    ListBox_Textures: TListBox;
    ListBox_Texture: TListBox;
    procedure FormOnShow(Sender: TObject);
    procedure ListBox_TextureListClick(Sender: TObject);
    procedure ListBox_TextureClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_KCMTextureCenter: TForm_KCMTextureCenter;
  INIFIle:TINIFile;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm_KCMTextureCenter.FormOnShow(Sender: TObject);
var
  x1:Integer;
begin
  If fileexists(ExtractFileDir(Application.ExeName)+'\Recources\GTX2DDS.exe')=False then
  begin
    ShowMEssage(ExtractFileDir(Application.ExeName)+'\Recources\GTX2DDS.exe');
    MessageBox(Handle, pchar('This function is not able to work properly.'+#13+'- No GTX2DDS converter found in the recources map.'),'Can''t open this function',MB_OK);
    Form_KCMTextureCenter.Close;
  end;
  ListBox_TextureList.Items.Clear;

  For x1:= 0 to 6 do
  begin
    If Form_Main.KCM.Header.TextureList[x1]<>$FF then
    begin
      ListBox_TextureList.Items.Add('Texture #'+IntToStr(x1)+' = TID #'+IntToSTr(Form_Main.KCM.Header.TextureList[x1])+' ( '+Form_Main.env.TextureIndexList[Form_Main.KCM.Header.TextureList[x1]]+' )');
    end
    else
    begin
      ListBox_TextureList.Items.Add('Texture #'+IntToStr(x1)+' : none');
    end;
  end;


  ListBox_Texture.Items.Clear;
  ListBox_Texture.Items.Add('none');
  For x1:=0 to Form_main.env.TextureIndexCount-1 do
  begin
    ListBox_Texture.Items.Add(' TID #'+IntToStr(x1)+' ('+Form_Main.env.TextureIndexList[x1]+'.GTX )');
  end;
end;

procedure TForm_KCMTextureCenter.ListBox_TextureListClick(Sender: TObject);
var
  x1,x2,y1,clr:Integer;
  GTXLoc,DDSLoc:String;
begin
  For x2:= 0 to ListBox_TextureList.Items.Count-1 do
  begin
    If ListBox_TextureList.Selected[x2]=true then
    begin
      //Painting the Texture map
      For x1:=0 to 255 do
      begin
        For y1:=0 to 255 do
        begin
          clr:=Form_Main.KCM.TextureMapList[x2][x1][y1];
          Image_TextureMap.Canvas.Pixels[x1,y1]:=Rgb(Clr,Clr,Clr);
        end;
      end;


      If Form_Main.KCM.Header.TextureList[x2]<>$FF then
      begin
        ListBox_Texture.Selected[Form_Main.KCM.Header.TextureList[x2]+1]:=True;
      end
      else
      begin
        ListBox_Texture.Selected[0]:=True;
      end;

      If Form_Main.KCM.Header.TextureList[x2]<>$FF then
      begin
        Try
          DDSLoc:=ExtractFileDir(Application.ExeName)+'\Recources\'+Copy(Form_Main.env.TextureIndexList[Form_Main.KCM.Header.TextureList[x2]],1,Length(Form_Main.env.TextureIndexList[Form_Main.KCM.Header.TextureList[x2]])-4)+'.dds';
          if fileexists(DDSLoc)=false then
          begin
            GTXLoc:=Form_Main.Client_Path+'data\MAPS\Tex\'+Form_Main.env.TextureIndexList[Form_Main.KCM.Header.TextureList[x2]];
            ConvertGTX2DDS(GTXLoc,DDSLoc,ExtractFilePath(Application.Exename)+'Recources\encrypt.dat',ExtractFilePath(Application.Exename)+'Recources\decrypt.dat');
          end;
          Image_Texture.Picture.LoadFromFile(DDSLoc);
          {GTXLoc:=Form_Main.Client_Path+'data\MAPS\Tex\'+Form_Main.env.TextureIndexList[Form_Main.KCM.Header.TextureList[x2]];
          DDSLoc:=ExtractFileDir(Application.ExeName)+'\Recources\'+Copy(Form_Main.env.TextureIndexList[Form_Main.KCM.Header.TextureList[x2]],1,Length(Form_Main.env.TextureIndexList[x2])-4)+'.dds';
          ConvertGTX2DDS(GTXLoc,DDSLoc,ExtractFilePath(Application.Exename)+'Recources\encrypt.dat',ExtractFilePath(Application.Exename)+'Recources\decrypt.dat');
          Image_Texture.Picture.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Recources\'+Copy(Form_Main.env.TextureIndexList[Form_Main.KCM.Header.TextureList[x2]],1,Length(Form_Main.env.TextureIndexList[Form_Main.KCM.Header.TextureList[x2]])-4)+'.dds');}
        except
        end;
      end;
      break;
    end;
  end;
end;

procedure TForm_KCMTextureCenter.ListBox_TextureClick(Sender: TObject);
var
  x1,x2:Integer;
  TextureList:TKCMTextureList;
  GTXLoc,DDSLoc:STring;
  TID:Integer;
begin
  For x2:=0 to ListBox_Texture.Items.Count-1 do
  begin
    If ListBox_Texture.Selected[x2]=true then
    begin
      TID := x2-1;
      If TID > -1 then
      begin
        Try
          GTXLoc:=Form_Main.Client_Path+'data\MAPS\Tex\'+Form_Main.env.TextureIndexList[TID];
          DDSLoc:=ExtractFileDir(Application.ExeName)+'\Recources\'+Copy(Form_Main.env.TextureIndexList[TID],1,Length(Form_Main.env.TextureIndexList[TID])-4)+'.dds';
          ConvertGTX2DDS(GTXLoc,DDSLoc,ExtractFilePath(Application.Exename)+'Recources\encrypt.dat',ExtractFilePath(Application.Exename)+'Recources\decrypt.dat');

          Image_Texture.Picture.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Recources\'+Copy(Form_Main.env.TextureIndexList[TID],1,Length(Form_Main.env.TextureIndexList[TID])-4)+'.dds');
        except
        end;
      end
      else
      begin
        TID:=$FF;
      end;
      break;
    end;
  end;

  For x1:=0 to ListBox_TextureList.Items.Count-1 do
  begin
    If ListBox_TextureList.Selected[x1]=True then
    begin
      TextureList:=Form_Main.KCM.Header.TextureList;
      TextureList[x1]:=TID;
      Form_Main.KCM.Header.TextureList:=TextureList;

      If TID=$FF then
      begin
        ListBox_TextureList.Items[x1]:='Texture #'+IntToStr(x1)+' : none';
      end
      else
      begin
        ListBox_TextureList.Items[x1]:='Texture #'+IntToStr(x1)+' = TID #'+IntToSTr(Form_Main.KCM.Header.TextureList[x1])+' ( '+Form_Main.env.TextureIndexList[Form_Main.KCM.Header.TextureList[x1]]+' )';
      end;

      break;
    end;
  end;

end;

end.
