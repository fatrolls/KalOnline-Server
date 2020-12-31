object Form_Shutdown: TForm_Shutdown
  Left = 725
  Top = 87
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Contine Shutdown?'
  ClientHeight = 215
  ClientWidth = 266
  Color = clBtnFace
  DefaultMonitor = dmPrimary
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label_Intro: TLabel
    Left = 8
    Top = 8
    Width = 214
    Height = 13
    Caption = 'Are you sure you want to proceed shutdown?'
  end
  object Label_OPL: TLabel
    Left = 222
    Top = 62
    Width = 31
    Height = 13
    Caption = 'Saved'
  end
  object Label_KCM: TLabel
    Left = 222
    Top = 30
    Width = 31
    Height = 13
    Caption = 'Saved'
  end
  object Label_KSM: TLabel
    Left = 222
    Top = 94
    Width = 31
    Height = 13
    Caption = 'Saved'
  end
  object Button_SaveKCM: TButton
    Left = 8
    Top = 24
    Width = 105
    Height = 25
    Caption = 'Save &KCM'
    TabOrder = 0
    OnClick = Button_SaveKCMClick
  end
  object Button_SaveKCMAs: TButton
    Left = 120
    Top = 24
    Width = 99
    Height = 25
    Caption = 'Save KCM As'
    TabOrder = 1
    OnClick = Button_SaveKCMAsClick
  end
  object Button_SaveOPL: TButton
    Left = 8
    Top = 56
    Width = 105
    Height = 25
    Caption = 'Save &OPL'
    TabOrder = 2
    OnClick = Button_SaveOPLClick
  end
  object Button_SaveOPLAs: TButton
    Left = 120
    Top = 56
    Width = 99
    Height = 25
    Caption = 'Save &OPL As'
    TabOrder = 3
    OnClick = Button_SaveOPLAsClick
  end
  object Button_SaveKSM: TButton
    Left = 8
    Top = 88
    Width = 105
    Height = 25
    Caption = 'Save &KSM'
    TabOrder = 4
    OnClick = Button_SaveKSMClick
  end
  object Button_SaveKSMAs: TButton
    Left = 120
    Top = 88
    Width = 99
    Height = 25
    Caption = 'Save &KSM As'
    TabOrder = 5
    OnClick = Button_SaveKSMAsClick
  end
  object Button_SaveAll: TButton
    Left = 8
    Top = 120
    Width = 249
    Height = 25
    Caption = 'Save all, and Shutdown'
    TabOrder = 6
    OnClick = Button_SaveAllClick
  end
  object Button_AbortShutdown: TButton
    Left = 8
    Top = 152
    Width = 249
    Height = 25
    Caption = 'Do &not shutdown, continue KWE'
    TabOrder = 7
    OnClick = Button_AbortShutdownClick
  end
  object Button_Proceed: TButton
    Left = 8
    Top = 184
    Width = 249
    Height = 25
    Caption = 'Proceed shutdown'
    TabOrder = 8
    OnClick = Button_ProceedClick
  end
end
