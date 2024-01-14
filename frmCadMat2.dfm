object FCadMat: TFCadMat
  Left = 0
  Top = 0
  Width = 725
  Height = 502
  Caption = 'Cadastro e Consulta de Mat'#233'rias'
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
  object Label2: TLabel
    Left = 48
    Top = 16
    Width = 136
    Height = 19
    Caption = 'Mat'#233'rias do Cat'#225'logo '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object CatAno: TLabel
    Left = 192
    Top = 16
    Width = 48
    Height = 19
    Caption = 'CatAno'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object PageControl1: TPageControl
    Left = 24
    Top = 48
    Width = 657
    Height = 393
    ActivePage = TabSheet2
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Cadastro de Mat'#233'rias'
      object GroupBox4: TGroupBox
        Left = 20
        Top = 9
        Width = 601
        Height = 342
        Caption = 'Cadastro de Mat'#233'rias'
        TabOrder = 0
        object Label10: TLabel
          Left = 96
          Top = 90
          Width = 56
          Height = 13
          Caption = 'Sem. Letivo'
        end
        object Label8: TLabel
          Left = 24
          Top = 88
          Width = 35
          Height = 13
          Caption = 'Cr'#233'dito'
        end
        object Label7: TLabel
          Left = 320
          Top = 32
          Width = 46
          Height = 13
          Caption = 'Descri'#231#227'o'
        end
        object Label5: TLabel
          Left = 88
          Top = 32
          Width = 27
          Height = 13
          Caption = 'Nome'
        end
        object Label4: TLabel
          Left = 24
          Top = 32
          Width = 33
          Height = 13
          Caption = 'C'#243'digo'
        end
        object Label15: TLabel
          Left = 168
          Top = 88
          Width = 60
          Height = 13
          Caption = '% Conclu'#237'da'
        end
        object MatSemLet: TDBEdit
          Left = 96
          Top = 109
          Width = 57
          Height = 21
          DataField = 'MatSem'
          DataSource = DataSource2
          MaxLength = 2
          TabOrder = 0
        end
        object MatCred: TDBEdit
          Left = 24
          Top = 109
          Width = 57
          Height = 21
          DataField = 'MatCred'
          DataSource = DataSource2
          MaxLength = 1
          TabOrder = 1
        end
        object DBMemo1: TDBMemo
          Left = 320
          Top = 53
          Width = 265
          Height = 108
          DataField = 'MatDef'
          DataSource = DataSource2
          TabOrder = 2
        end
        object MatCod: TDBEdit
          Left = 24
          Top = 53
          Width = 49
          Height = 21
          DataField = 'MatCod'
          DataSource = DataSource2
          MaxLength = 5
          TabOrder = 3
        end
        object MatNom: TDBEdit
          Left = 88
          Top = 51
          Width = 209
          Height = 21
          DataField = 'MatNom'
          DataSource = DataSource2
          TabOrder = 4
        end
        object CSalvar: TButton
          Left = 216
          Top = 172
          Width = 75
          Height = 25
          Caption = 'Salvar'
          TabOrder = 5
          OnClick = CSalvarClick
        end
        object Limpar: TButton
          Left = 128
          Top = 172
          Width = 75
          Height = 25
          Caption = 'Limpar'
          TabOrder = 6
          OnClick = LimparClick
        end
        object CNovo: TButton
          Left = 40
          Top = 172
          Width = 75
          Height = 25
          Caption = 'Novo'
          TabOrder = 7
          OnClick = CNovoClick
        end
        object DBGrid3: TDBGrid
          Left = 10
          Top = 211
          Width = 580
          Height = 117
          DataSource = DataSource4
          ReadOnly = True
          TabOrder = 8
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnCellClick = DBGrid3CellClick
          Columns = <
            item
              Expanded = False
              FieldName = 'MatCod'
              Title.Caption = 'Mat'#233'ria'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'MatNom'
              Title.Caption = 'Nome'
              Width = 245
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
              Width = 60
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
              Visible = False
            end
            item
              Expanded = False
              FieldName = 'MatCP'
              Title.Caption = '% Conc.'
              Width = 45
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'HorOk'
              Visible = True
            end>
        end
        object Alterar: TButton
          Left = 304
          Top = 172
          Width = 75
          Height = 25
          Caption = 'Alterar'
          TabOrder = 9
          OnClick = AlterarClick
        end
        object Excluir: TButton
          Left = 392
          Top = 172
          Width = 75
          Height = 25
          Caption = 'Excluir'
          TabOrder = 10
          OnClick = ExcluirClick
        end
        object MatCP: TDBEdit
          Left = 168
          Top = 109
          Width = 57
          Height = 21
          DataField = 'MatCP'
          DataSource = DataSource2
          MaxLength = 2
          TabOrder = 11
        end
        object RadioButton1: TRadioButton
          Left = 24
          Top = 144
          Width = 113
          Height = 17
          Caption = 'Obrigat'#243'ria'
          TabOrder = 12
        end
        object RadioButton2: TRadioButton
          Left = 115
          Top = 144
          Width = 113
          Height = 17
          Caption = 'Eletiva'
          TabOrder = 13
        end
        object Cancelar: TButton
          Left = 482
          Top = 172
          Width = 75
          Height = 25
          Caption = 'Cancelar'
          TabOrder = 14
          OnClick = CancelarClick
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Hor'#225'rios e Pr'#233'-Requisitos'
      ImageIndex = 1
      object Materia: TLabel
        Left = 263
        Top = 14
        Width = 50
        Height = 16
        Caption = 'Materia'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 16
        Top = 16
        Width = 241
        Height = 13
        Caption = 'Defina os Hor'#225'rios e os Pr'#233'-Requisitos da Mat'#233'ria:'
      end
      object GroupBox1: TGroupBox
        Left = 17
        Top = 40
        Width = 329
        Height = 297
        Caption = 'Hor'#225'rio'
        TabOrder = 0
        object Label12: TLabel
          Left = 24
          Top = 40
          Width = 75
          Height = 13
          Caption = 'Dia da Semana:'
        end
        object Label11: TLabel
          Left = 192
          Top = 40
          Width = 82
          Height = 13
          Caption = 'Hor'#225'rio de In'#237'cio:'
        end
        object Label9: TLabel
          Left = 24
          Top = 20
          Width = 118
          Height = 13
          Caption = 'Quantidade de Cr'#233'ditos:'
        end
        object Creditos: TLabel
          Left = 151
          Top = 18
          Width = 54
          Height = 16
          Caption = 'Cr'#233'ditos'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object DBGrid2: TDBGrid
          Left = 24
          Top = 128
          Width = 281
          Height = 120
          DataSource = DataSource3
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnCellClick = DBGrid2CellClick
          Columns = <
            item
              Expanded = False
              FieldName = 'MatCod'
              Title.Caption = 'Mat'#233'ria'
              Width = 55
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DiaHor'
              Title.Caption = 'Dia da Semana'
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'IniHor'
              Title.Caption = 'Hor'#225'rio de In'#237'cio'
              Width = 90
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CMTHCod'
              Visible = False
            end>
        end
        object ComboBox1: TComboBox
          Left = 33
          Top = 59
          Width = 105
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          OnChange = ComboBox1Change
        end
        object ComboBox2: TComboBox
          Left = 192
          Top = 59
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          OnChange = ComboBox2Change
        end
        object Button1: TButton
          Left = 121
          Top = 91
          Width = 75
          Height = 25
          Caption = 'Inserir'
          TabOrder = 3
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 126
          Top = 258
          Width = 75
          Height = 25
          Caption = 'Excluir'
          TabOrder = 4
          OnClick = Button2Click
        end
      end
      object prereq: TGroupBox
        Left = 360
        Top = 40
        Width = 273
        Height = 297
        Caption = 'Pr'#233'-Requisitos'
        TabOrder = 1
        object Label1: TLabel
          Left = 16
          Top = 24
          Width = 45
          Height = 13
          Caption = 'Mat'#233'rias:'
        end
        object Label6: TLabel
          Left = 168
          Top = 24
          Width = 69
          Height = 13
          Caption = 'Pr'#233'-Requisitos'
        end
        object ListBox2: TListBox
          Left = 165
          Top = 49
          Width = 88
          Height = 193
          ItemHeight = 13
          TabOrder = 0
        end
        object ListBox1: TListBox
          Left = 13
          Top = 49
          Width = 88
          Height = 193
          ItemHeight = 13
          TabOrder = 1
        end
        object Gravar: TButton
          Left = 97
          Top = 258
          Width = 75
          Height = 25
          Caption = 'Gravar'
          TabOrder = 2
          OnClick = GravarClick
        end
      end
      object Add: TBitBtn
        Left = 476
        Top = 136
        Width = 33
        Height = 25
        Caption = '-->'
        TabOrder = 2
        OnClick = AddClick
      end
      object Remove: TBitBtn
        Left = 476
        Top = 196
        Width = 33
        Height = 25
        Caption = '<--'
        TabOrder = 3
        OnClick = RemoveClick
      end
    end
  end
  object MatSemAno: TDBEdit
    Left = 624
    Top = 29
    Width = 57
    Height = 21
    DataField = 'MatSemOfer'
    DataSource = DataSource2
    MaxLength = 2
    TabOrder = 1
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 445
    Width = 121
    Height = 52
    Caption = 'Cadastro em Mat'#233'rias'
    TabOrder = 2
    Visible = False
  end
  object GroupBox3: TGroupBox
    Left = 136
    Top = 445
    Width = 113
    Height = 52
    Caption = 'Cadastro em CatMat'
    TabOrder = 3
    Visible = False
  end
  object GroupBox5: TGroupBox
    Left = 248
    Top = 445
    Width = 129
    Height = 52
    Caption = 'Inser'#231#227'o de Hor'#225'rios'
    TabOrder = 4
    Visible = False
  end
  object GroupBox6: TGroupBox
    Left = 376
    Top = 445
    Width = 113
    Height = 52
    Caption = 'Cadastro em CatMat'
    TabOrder = 5
    Visible = False
  end
  object DataSource1: TDataSource
    Left = 56
    Top = 456
  end
  object ADODataSet1: TADODataSet
    Connection = formprincipal.Feagri_Conector
    CursorType = ctStatic
    CommandText = 'materias'
    CommandType = cmdTable
    Parameters = <>
    Left = 24
    Top = 456
    object ADODataSet1MatCod: TWideStringField
      FieldName = 'MatCod'
      Size = 6
    end
  end
  object ADODataSet2: TADODataSet
    Connection = formprincipal.Feagri_Conector
    CursorType = ctStatic
    CommandText = 'cat_mat'
    CommandType = cmdTable
    Parameters = <>
    Left = 144
    Top = 456
    object ADODataSet2CMCod: TAutoIncField
      FieldName = 'CMCod'
      ReadOnly = True
    end
    object ADODataSet2CatCod: TIntegerField
      FieldName = 'CatCod'
    end
    object ADODataSet2MatCod: TWideStringField
      FieldName = 'MatCod'
      Size = 6
    end
    object ADODataSet2MatNom: TWideStringField
      FieldName = 'MatNom'
      Size = 255
    end
    object ADODataSet2MatCred: TIntegerField
      FieldName = 'MatCred'
    end
    object ADODataSet2MatSemOfer: TIntegerField
      FieldName = 'MatSemOfer'
    end
    object ADODataSet2MatSem: TIntegerField
      FieldName = 'MatSem'
    end
    object ADODataSet2MatDef: TMemoField
      FieldName = 'MatDef'
      BlobType = ftMemo
    end
    object ADODataSet2MatCP: TIntegerField
      FieldName = 'MatCP'
    end
  end
  object DataSource2: TDataSource
    DataSet = ADODataSet2
    Left = 176
    Top = 456
  end
  object ADODataSet3: TADODataSet
    Connection = formprincipal.Feagri_Conector
    CommandText = 'cat_mat_tur_hor'
    CommandType = cmdTable
    Parameters = <>
    Left = 256
    Top = 456
  end
  object DataSource3: TDataSource
    DataSet = ADOQuery3
    Left = 312
    Top = 456
  end
  object ADOQuery3: TADOQuery
    Connection = formprincipal.Feagri_Conector
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'Select cm.MatCod, DiaHor, IniHor, CMTHCod from Cat_Mat_Tur_Hor c' +
        'mth, Cat_Mat cm where cmth.CMCod = cm.CMCod;')
    Left = 344
    Top = 456
    object ADOQuery3MatCod: TWideStringField
      FieldName = 'MatCod'
      Size = 6
    end
    object ADOQuery3DiaHor: TWideStringField
      FieldName = 'DiaHor'
      Size = 255
    end
    object ADOQuery3IniHor: TWideStringField
      FieldName = 'IniHor'
      Size = 8
    end
    object ADOQuery3CMTHCod: TAutoIncField
      FieldName = 'CMTHCod'
      ReadOnly = True
    end
  end
  object DataSource4: TDataSource
    DataSet = ADOQuery4
    Left = 424
    Top = 456
  end
  object ADOQuery4: TADOQuery
    Connection = formprincipal.Feagri_Conector
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select MatCod, MatNom, MatSemOfer, MatSem, '
      '                          MatCred, MatCP, HorOk from Cat_Mat')
    Left = 456
    Top = 456
    object ADOQuery4MatCod: TWideStringField
      FieldName = 'MatCod'
      Size = 6
    end
    object ADOQuery4MatNom: TWideStringField
      FieldName = 'MatNom'
      Size = 255
    end
    object ADOQuery4MatSemOfer: TIntegerField
      FieldName = 'MatSemOfer'
    end
    object ADOQuery4MatSem: TIntegerField
      FieldName = 'MatSem'
    end
    object ADOQuery4MatCred: TIntegerField
      FieldName = 'MatCred'
    end
    object ADOQuery4MatCP: TIntegerField
      FieldName = 'MatCP'
    end
    object ADOQuery4HorOk: TBooleanField
      FieldName = 'HorOk'
    end
  end
  object ADODataSet: TADODataSet
    Parameters = <>
    Left = 520
    Top = 456
  end
  object DataSource: TDataSource
    Left = 552
    Top = 456
  end
  object ADOQuery: TADOQuery
    Parameters = <>
    Left = 584
    Top = 456
  end
end
