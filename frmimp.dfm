object FImpMat: TFImpMat
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Importar Mat'#233'rias'
  ClientHeight = 507
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 63
    Height = 13
    Caption = 'De Cat'#225'logo:'
  end
  object CatAno: TLabel
    Left = 88
    Top = 222
    Width = 48
    Height = 16
    Caption = 'CatAno'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 224
    Width = 68
    Height = 13
    Caption = 'Para Cat'#225'logo'
  end
  object ComboBox1: TComboBox
    Left = 88
    Top = 13
    Width = 73
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = ComboBox1Change
  end
  object GroupBox1: TGroupBox
    Left = 64
    Top = 448
    Width = 129
    Height = 57
    Caption = 'Grid1'
    TabOrder = 1
    Visible = False
  end
  object GroupBox2: TGroupBox
    Left = 200
    Top = 448
    Width = 129
    Height = 57
    Caption = 'Grid2'
    TabOrder = 2
    Visible = False
  end
  object DBGrid2: TDBGrid
    Left = 16
    Top = 252
    Width = 553
    Height = 117
    DataSource = DataSource2
    ReadOnly = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'MatCod'
        Title.Caption = 'Mat'#233'ria'
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MatNom'
        Title.Caption = 'Nome'
        Width = 260
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MatSemOfer'
        Title.Caption = 'Sem. do Ano'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MatSem'
        Title.Caption = 'Sem. Letivo'
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MatCred'
        Title.Caption = 'Cr'#233'dito'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MatDef'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'MatCP'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CMCod'
        Width = 0
        Visible = True
      end>
  end
  object DBGrid1: TDBGrid
    Left = 16
    Top = 60
    Width = 553
    Height = 117
    DataSource = DataSource1
    ReadOnly = True
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'MatCod'
        Title.Caption = 'Mat'#233'ria'
        Width = 45
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MatNom'
        Title.Caption = 'Nome'
        Width = 260
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MatSemOfer'
        Title.Caption = 'Sem. do Ano'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MatSem'
        Title.Caption = 'Sem. Letivo'
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MatCred'
        Title.Caption = 'Cr'#233'dito'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MatDef'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'MatCP'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CMCod'
        Width = 0
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 184
    Top = 184
    Width = 89
    Height = 25
    Caption = 'Adicionar'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 240
    Top = 384
    Width = 89
    Height = 25
    Caption = 'Remover'
    TabOrder = 6
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 296
    Top = 184
    Width = 89
    Height = 25
    Caption = 'Adicionar Todas'
    TabOrder = 7
    OnClick = Button3Click
  end
  object ADODataSet: TADODataSet
    Connection = formprincipal.Feagri_Conector
    Parameters = <>
    Left = 424
    Top = 472
  end
  object ADOQuery1: TADOQuery
    Connection = formprincipal.Feagri_Conector
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select * from Cat_Mat')
    Left = 136
    Top = 464
    object ADOQuery1CMCod: TAutoIncField
      FieldName = 'CMCod'
      ReadOnly = True
    end
    object ADOQuery1CatCod: TIntegerField
      FieldName = 'CatCod'
    end
    object ADOQuery1MatCod: TWideStringField
      FieldName = 'MatCod'
      Size = 6
    end
    object ADOQuery1MatNom: TWideStringField
      FieldName = 'MatNom'
      Size = 255
    end
    object ADOQuery1MatCred: TIntegerField
      FieldName = 'MatCred'
    end
    object ADOQuery1MatSemOfer: TIntegerField
      FieldName = 'MatSemOfer'
    end
    object ADOQuery1MatSem: TIntegerField
      FieldName = 'MatSem'
    end
    object ADOQuery1MatDef: TMemoField
      FieldName = 'MatDef'
      BlobType = ftMemo
    end
    object ADOQuery1MatCP: TIntegerField
      FieldName = 'MatCP'
    end
  end
  object DataSource: TDataSource
    Left = 456
    Top = 472
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 104
    Top = 464
  end
  object DataSource2: TDataSource
    DataSet = ADOQuery2
    Left = 240
    Top = 464
  end
  object ADOQuery2: TADOQuery
    Connection = formprincipal.Feagri_Conector
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select * from Cat_Mat')
    Left = 272
    Top = 464
    object ADOQuery2CMCod: TAutoIncField
      FieldName = 'CMCod'
      ReadOnly = True
    end
    object ADOQuery2CatCod: TIntegerField
      FieldName = 'CatCod'
    end
    object ADOQuery2MatCod: TWideStringField
      FieldName = 'MatCod'
      Size = 6
    end
    object ADOQuery2MatNom: TWideStringField
      FieldName = 'MatNom'
      Size = 255
    end
    object ADOQuery2MatCred: TIntegerField
      FieldName = 'MatCred'
    end
    object ADOQuery2MatSemOfer: TIntegerField
      FieldName = 'MatSemOfer'
    end
    object ADOQuery2MatSem: TIntegerField
      FieldName = 'MatSem'
    end
    object ADOQuery2MatDef: TMemoField
      FieldName = 'MatDef'
      BlobType = ftMemo
    end
    object ADOQuery2MatCP: TIntegerField
      FieldName = 'MatCP'
    end
  end
end
