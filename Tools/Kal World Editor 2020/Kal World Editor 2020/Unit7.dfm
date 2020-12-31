object Form_Login: TForm_Login
  Left = 268
  Top = 167
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Login'
  ClientHeight = 234
  ClientWidth = 335
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button_Login: TButton
    Left = 8
    Top = 192
    Width = 321
    Height = 33
    Caption = 'See you on the other side! '
    TabOrder = 0
    OnClick = Button_LoginClick
  end
  object RichEdit_Intro: TRichEdit
    Left = 8
    Top = 8
    Width = 321
    Height = 177
    Lines.Strings = (
      'This is the completely FREE version of KalWorld Editor (KWE),'
      ''
      
        'Feel free to use this however you like, but don'#39't ever forget me' +
        '; '
      'reb3lzrr the proud creator of this software.'
      ''
      
        'I'#39'll never forget the times of Kal, they will always stay with m' +
        'e...'
      ''
      
        'However, it'#39's time so say goodbuy to this scene forever and move' +
        ' '
      'on...'
      ''
      'See you on the other side guys!'
      ''
      'CHEERS!')
    ReadOnly = True
    TabOrder = 1
  end
end
