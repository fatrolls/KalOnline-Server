object Form1: TForm1
  Left = 549
  Top = 616
  BorderStyle = bsToolWindow
  BorderWidth = 4
  Caption = 'Starting..'
  ClientHeight = 189
  ClientWidth = 552
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 276
    Top = 0
    Width = 276
    Height = 129
    Caption = 'Log'
    TabOrder = 0
    object ListBox1: TListBox
      Left = 2
      Top = 15
      Width = 272
      Height = 112
      Align = alClient
      BorderStyle = bsNone
      Color = clBtnFace
      ItemHeight = 13
      Items.Strings = (
        'Starting KS4 [UW]...')
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 132
    Width = 552
    Height = 57
    Caption = 
      'Wait between every check from 1 THREAD [ms] (min. 0ms - max. 100' +
      'ms)'
    TabOrder = 1
    object TrackBar1: TTrackBar
      Left = 2
      Top = 15
      Width = 548
      Height = 40
      Align = alClient
      Max = 100
      Orientation = trHorizontal
      Frequency = 1
      Position = 2
      SelEnd = 0
      SelStart = 0
      TabOrder = 0
      TickMarks = tmBottomRight
      TickStyle = tsAuto
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 0
    Width = 276
    Height = 129
    Caption = 'Status:'
    TabOrder = 2
    object Memo1: TMemo
      Left = 2
      Top = 15
      Width = 272
      Height = 112
      Align = alClient
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'Nothing..')
      ReadOnly = True
      TabOrder = 0
    end
    object ListBox2: TListBox
      Left = 136
      Top = 16
      Width = 121
      Height = 97
      ItemHeight = 13
      TabOrder = 1
      Visible = False
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 360
    Top = 8
  end
  object ServerSocket2: TServerSocket
    Active = True
    Port = 30002
    ServerType = stNonBlocking
    OnClientConnect = ServerSocket2ClientConnect
    OnClientDisconnect = ServerSocket2ClientDisconnect
    OnClientRead = ServerSocket2ClientRead
    OnClientError = ServerSocket2ClientError
    Left = 296
    Top = 8
  end
  object ServerSocket1: TServerSocket
    Active = True
    Port = 101
    ServerType = stNonBlocking
    OnClientConnect = ServerSocket1ClientConnect
    OnClientDisconnect = ServerSocket1ClientDisconnect
    OnClientError = ServerSocket1ClientError
    Left = 328
    Top = 8
  end
  object MainMenu1: TMainMenu
    Left = 264
    Top = 8
    object Server1: TMenuItem
      Caption = 'Server'
      object Restart1: TMenuItem
        Caption = 'Restart'
        OnClick = Restart1Click
      end
      object Shutdown1: TMenuItem
        Caption = 'Shutdown'
        OnClick = Shutdown1Click
      end
    end
    object User1: TMenuItem
      Caption = 'User'
      object New1: TMenuItem
        Caption = 'New'
        OnClick = New1Click
      end
    end
  end
  object state: TServerSocket
    Active = True
    Port = 103
    ServerType = stNonBlocking
    OnClientConnect = stateClientConnect
    OnClientError = stateClientError
    Left = 296
    Top = 40
  end
  object reg: TServerSocket
    Active = False
    Port = 104
    ServerType = stNonBlocking
    OnClientConnect = regClientConnect
    OnClientRead = regClientRead
    OnClientError = regClientError
    Left = 328
    Top = 40
  end
  object Timer2: TTimer
    Interval = 60000
    OnTimer = Timer2Timer
    Left = 104
    Top = 16
  end
end
