object FCadCat: TFCadCat
  Left = 0
  Top = 0
  Caption = 'Cadastro e Consulta de Cat'#225'logo'
  ClientHeight = 328
  ClientWidth = 436
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 393
    Height = 305
    ActivePage = TabSheet2
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Cadastro de Cat'#225'logo'
      object Label1: TLabel
        Left = 24
        Top = 16
        Width = 80
        Height = 13
        Caption = 'Ano do Cat'#225'logo'
      end
      object Label5: TLabel
        Left = 24
        Top = 64
        Width = 46
        Height = 13
        Caption = 'Descri'#231#227'o'
      end
      object Label2: TLabel
        Left = 130
        Top = 16
        Width = 81
        Height = 13
        Caption = 'Data de Inclus'#227'o'
      end
      object CatAnoCad: TDBEdit
        Left = 24
        Top = 35
        Width = 65
        Height = 21
        DataField = 'CatAno'
        DataSource = DataSource1
        MaxLength = 4
        TabOrder = 0
        OnKeyPress = CatAnoCadKeyPress
      end
      object DBMemo1: TDBMemo
        Left = 24
        Top = 88
        Width = 329
        Height = 121
        DataField = 'CatObs'
        DataSource = DataSource1
        TabOrder = 1
        OnKeyPress = DBMemo1KeyPress
      end
      object Novo: TButton
        Left = 16
        Top = 232
        Width = 75
        Height = 25
        Caption = 'Novo'
        TabOrder = 2
        OnClick = NovoClick
      end
      object Limpar: TButton
        Left = 106
        Top = 232
        Width = 75
        Height = 25
        Caption = 'Limpar'
        TabOrder = 3
        OnClick = LimparClick
      end
      object Salvar: TButton
        Left = 198
        Top = 232
        Width = 75
        Height = 25
        Caption = 'Salvar'
        TabOrder = 4
        OnClick = SalvarClick
      end
      object Cancelar: TButton
        Left = 288
        Top = 232
        Width = 75
        Height = 25
        Caption = 'Cancelar'
        TabOrder = 5
        OnClick = CancelarClick
      end
      object DtaInc: TDBEdit
        Left = 130
        Top = 35
        Width = 71
        Height = 21
        DataField = 'CatDtIng'
        DataSource = DataSource1
        TabOrder = 6
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Consulta de Cat'#225'logo'
      ImageIndex = 1
      object Label3: TLabel
        Left = 24
        Top = 16
        Width = 80
        Height = 13
        Caption = 'Ano do Cat'#225'logo'
      end
      object Label6: TLabel
        Left = 24
        Top = 64
        Width = 46
        Height = 13
        Caption = 'Descri'#231#227'o'
      end
      object Label4: TLabel
        Left = 130
        Top = 16
        Width = 81
        Height = 13
        Caption = 'Data de Inclus'#227'o'
      end
      object DBMemo2: TDBMemo
        Left = 24
        Top = 88
        Width = 329
        Height = 73
        DataField = 'CatObs'
        DataSource = DataSource2
        TabOrder = 0
        OnKeyPress = DBMemo2KeyPress
      end
      object ComboBox1: TComboBox
        Left = 24
        Top = 35
        Width = 65
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnChange = ComboBox1Change
      end
      object Alterar: TButton
        Left = 14
        Top = 200
        Width = 75
        Height = 25
        Caption = 'Alterar'
        TabOrder = 2
        OnClick = AlterarClick
      end
      object DBCheckBox1: TDBCheckBox
        Left = 24
        Top = 171
        Width = 113
        Height = 17
        Caption = 'Cat'#225'logo Vigente'
        DataField = 'CatVig'
        DataSource = DataSource2
        TabOrder = 3
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object Button1: TButton
        Left = 72
        Top = 244
        Width = 113
        Height = 25
        Caption = 'Importar Mat'#233'rias'
        TabOrder = 4
        OnClick = Button1Click
      end
      object Excluir: TButton
        Left = 106
        Top = 200
        Width = 75
        Height = 25
        Caption = 'Excluir'
        TabOrder = 5
        OnClick = ExcluirClick
      end
      object Button2: TButton
        Left = 191
        Top = 244
        Width = 113
        Height = 25
        Caption = 'Mat'#233'rias'
        TabOrder = 6
        OnClick = Button2Click
      end
      object Salvar2: TButton
        Left = 197
        Top = 200
        Width = 75
        Height = 25
        Caption = 'Salvar'
        TabOrder = 7
        OnClick = Salvar2Click
      end
      object Cancelar2: TButton
        Left = 288
        Top = 200
        Width = 75
        Height = 25
        Caption = 'Cancelar'
        TabOrder = 8
        OnClick = Cancelar2Click
      end
      object CDtaInc: TDBEdit
        Left = 130
        Top = 35
        Width = 65
        Height = 21
        DataField = 'CatDtIng'
        DataSource = DataSource2
        TabOrder = 9
      end
    end
  end
  object GroupBox5: TGroupBox
    Left = 152
    Top = 384
    Width = 121
    Height = 73
    Caption = 'Busca de Catalogo'
    TabOrder = 1
    Visible = False
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 384
    Width = 121
    Height = 73
    Caption = 'Cadastro de Cat'#225'logo'
    TabOrder = 2
    Visible = False
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 104
    Top = 472
  end
  object ADODataSet1: TADODataSet
    Connection = formprincipal.Feagri_Conector
    CursorType = ctStatic
    CommandText = 'catalogo'
    CommandType = cmdTable
    Parameters = <>
    Left = 24
    Top = 400
  end
  object DataSource1: TDataSource
    DataSet = ADODataSet1
    Left = 56
    Top = 400
  end
  object DataSource2: TDataSource
    DataSet = ADODataSet2
    Left = 200
    Top = 400
  end
  object ADODataSet2: TADODataSet
    Connection = formprincipal.Feagri_Conector
    CursorType = ctStatic
    CommandText = 'Select * from catalogo'
    Parameters = <>
    Left = 232
    Top = 400
    object ADODataSet2CatAno: TIntegerField
      FieldName = 'CatAno'
    end
    object ADODataSet2CatDtIng: TDateTimeField
      FieldName = 'CatDtIng'
    end
    object ADODataSet2CatVig: TBooleanField
      FieldName = 'CatVig'
    end
    object ADODataSet2CatObs: TMemoField
      FieldName = 'CatObs'
      BlobType = ftMemo
    end
    object ADODataSet2MaxPreReq: TIntegerField
      FieldName = 'MaxPreReq'
    end
  end
end
