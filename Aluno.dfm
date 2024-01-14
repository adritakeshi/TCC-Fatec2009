object Tbusca: TTbusca
  Left = 336
  Top = 282
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Aluno - Busca'
  ClientHeight = 217
  ClientWidth = 459
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
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 55
    Height = 13
    Caption = 'Buscar Por:'
  end
  object EDbusca: TEdit
    Left = 8
    Top = 48
    Width = 424
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = EDbuscaChange
  end
  object RBnome: TRadioButton
    Left = 88
    Top = 15
    Width = 57
    Height = 17
    Caption = 'Nome'
    TabOrder = 1
    OnClick = RBnomeClick
  end
  object RBra: TRadioButton
    Left = 160
    Top = 15
    Width = 49
    Height = 17
    Caption = 'R.A.'
    Checked = True
    TabOrder = 2
    TabStop = True
    OnClick = RBraClick
  end
  object GBusca: TDBGrid
    Left = 8
    Top = 75
    Width = 424
    Height = 99
    DataSource = SCRbusc
    ReadOnly = True
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellClick = GBuscaCellClick
    Columns = <
      item
        Expanded = False
        FieldName = 'AluRA'
        Title.Caption = 'R.A.'
        Width = 84
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'AluNom'
        Title.Caption = 'Nome'
        Width = 248
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CatCod'
        Title.Caption = 'Cat'#225'logo'
        Width = 55
        Visible = True
      end>
  end
  object BTNVolta: TButton
    Left = 357
    Top = 180
    Width = 75
    Height = 25
    Caption = '&Voltar'
    TabOrder = 3
    OnClick = BTNVoltaClick
  end
  object Qbusc: TADOQuery
    Connection = formprincipal.Feagri_Conector
    Parameters = <>
    Left = 392
  end
  object SCRbusc: TDataSource
    DataSet = Qbusc
    Left = 360
  end
end
