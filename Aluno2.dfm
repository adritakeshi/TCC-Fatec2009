object alu02: Talu02
  Left = 279
  Top = 374
  Caption = 'alu02'
  ClientHeight = 161
  ClientWidth = 544
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LBLnome: TLabel
    Left = 24
    Top = 46
    Width = 27
    Height = 13
    Caption = 'Nome'
  end
  object LBLra: TLabel
    Left = 324
    Top = 42
    Width = 14
    Height = 13
    Caption = 'RA'
  end
  object LBLsemlet: TLabel
    Left = 262
    Top = 76
    Width = 77
    Height = 13
    Caption = 'Semestre Letivo'
  end
  object LBLcat: TLabel
    Left = 11
    Top = 76
    Width = 43
    Height = 13
    Caption = 'Cat'#225'logo'
  end
  object DBnome: TDBEdit
    Left = 56
    Top = 40
    Width = 193
    Height = 21
    DataField = 'AluNom'
    DataSource = DataSource2
    TabOrder = 0
  end
  object DBcat: TDBEdit
    Left = 56
    Top = 72
    Width = 57
    Height = 21
    DataField = 'CatCod'
    DataSource = DataSource2
    TabOrder = 2
  end
  object DBsemlet: TDBEdit
    Left = 344
    Top = 72
    Width = 49
    Height = 21
    DataField = 'SemLet'
    DataSource = DataSource2
    TabOrder = 3
  end
  object DBra: TDBEdit
    Left = 344
    Top = 40
    Width = 97
    Height = 21
    DataField = 'AluRA'
    DataSource = DataSource2
    TabOrder = 1
  end
  object BTNnovo: TButton
    Left = 32
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Novo'
    TabOrder = 4
    OnClick = BTNnovoClick
  end
  object BTNbusca: TBitBtn
    Left = 256
    Top = 40
    Width = 33
    Height = 25
    Caption = 'B'
    TabOrder = 5
    OnClick = BTNbuscaClick
  end
  object Edit1: TEdit
    Left = 56
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 6
    Text = 'Edit1'
  end
  object BTNfecha: TButton
    Left = 120
    Top = 111
    Width = 75
    Height = 25
    Caption = 'Fechar'
    TabOrder = 7
    OnClick = BTNfechaClick
  end
  object ADODataSet1: TADODataSet
    Connection = formprincipal.Feagri_Conector
    CursorType = ctStatic
    CommandText = 'Aluno'
    CommandType = cmdTable
    Parameters = <>
    Left = 480
    Top = 16
  end
  object DataSource1: TDataSource
    DataSet = ADODataSet1
    Left = 512
    Top = 16
  end
  object ADODataSet2: TADODataSet
    Connection = formprincipal.Feagri_Conector
    CommandText = 'Aluno'
    CommandType = cmdTable
    DataSource = DataSource1
    Parameters = <>
    Left = 480
    Top = 48
  end
  object DataSource2: TDataSource
    DataSet = ADODataSet1
    Left = 512
    Top = 48
  end
end
