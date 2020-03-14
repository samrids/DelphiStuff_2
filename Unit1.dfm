object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 201
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    447
    201)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 288
    Top = 160
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 364
    Top = 160
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 8
    Width = 431
    Height = 146
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = DataSource1
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=root'
      'Password=chelseafc'
      'Database=vms'
      'DriverID=MySql')
    TxOptions.AutoStart = False
    TxOptions.AutoStop = False
    LoginPrompt = False
    Left = 128
    Top = 80
  end
  object FDQuery1: TFDQuery
    CachedUpdates = True
    OnUpdateError = FDQuery1UpdateError
    Connection = FDConnection1
    SQL.Strings = (
      'select * from department')
    Left = 352
    Top = 32
  end
  object tsRead: TFDTransaction
    Options.AutoStart = False
    Options.AutoStop = False
    Connection = FDConnection1
    Left = 368
    Top = 120
  end
  object tsWrite: TFDTransaction
    Options.AutoStart = False
    Options.AutoStop = False
    Connection = FDConnection1
    Left = 136
    Top = 33
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 272
    Top = 96
  end
end
