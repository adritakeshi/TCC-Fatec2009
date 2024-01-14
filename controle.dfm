object alteracao: Talteracao
  Left = 0
  Top = 0
  Width = 399
  Height = 299
  Caption = 'Controle das Mat'#233'rias'
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
  object Label1: TLabel
    Left = 208
    Top = 40
    Width = 46
    Height = 13
    Caption = 'Concluido'
  end
  object Label2: TLabel
    Left = 112
    Top = 40
    Width = 46
    Height = 13
    Caption = 'Cursando'
  end
  object Label3: TLabel
    Left = 312
    Top = 40
    Width = 51
    Height = 13
    Caption = 'Pendentes'
  end
  object Label4: TLabel
    Left = 24
    Top = 40
    Width = 41
    Height = 13
    Caption = 'Mat'#233'rias'
  end
  object Label5: TLabel
    Left = 27
    Top = 72
    Width = 45
    Height = 13
    Caption = 'Calculo-A'
  end
  object Label6: TLabel
    Left = 27
    Top = 96
    Width = 49
    Height = 13
    Caption = 'Estat'#237'stica'
  end
  object Label7: TLabel
    Left = 27
    Top = 120
    Width = 36
    Height = 13
    Caption = 'F'#237'sica-B'
  end
  object Label8: TLabel
    Left = 27
    Top = 144
    Width = 48
    Height = 13
    Caption = 'Qu'#237'mica-A'
  end
  object Label9: TLabel
    Left = 27
    Top = 168
    Width = 49
    Height = 13
    Caption = 'Portugu'#234's'
  end
  object Label10: TLabel
    Left = 195
    Top = 224
    Width = 44
    Height = 13
    Caption = 'Cr'#233'ditos:'
  end
  object Label11: TLabel
    Left = 243
    Top = 224
    Width = 24
    Height = 13
    Caption = '1600'
  end
  object CheckBox2: TCheckBox
    Left = 16
    Top = 232
    Width = 169
    Height = 17
    Caption = 'Exibir as mat'#233'rias pendentes'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object CheckBox3: TCheckBox
    Left = 16
    Top = 216
    Width = 169
    Height = 17
    Caption = 'Exibir as mat'#233'rias j'#225' cursadas'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object Button1: TButton
    Left = 80
    Top = 253
    Width = 265
    Height = 17
    Caption = 'Exibir Grade'
    TabOrder = 2
    OnClick = Button1Click
  end
  object StringGrid1: TStringGrid
    Left = 3
    Top = 272
    Width = 461
    Height = 255
    ColCount = 7
    RowCount = 10
    TabOrder = 3
    Visible = False
    RowHeights = (
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24)
  end
  object Button2: TButton
    Left = 288
    Top = 216
    Width = 81
    Height = 25
    Caption = 'Confirmar'
    TabOrder = 4
  end
  object RadioGroup1: TRadioGroup
    Left = 91
    Top = 56
    Width = 289
    Height = 31
    Columns = 3
    Items.Strings = (
      ' '
      ' '
      ' ')
    TabOrder = 5
  end
  object RadioGroup2: TRadioGroup
    Left = 91
    Top = 80
    Width = 289
    Height = 29
    Columns = 3
    Items.Strings = (
      ' '
      ' '
      ' ')
    TabOrder = 6
  end
  object RadioGroup3: TRadioGroup
    Left = 91
    Top = 104
    Width = 289
    Height = 31
    Columns = 3
    Items.Strings = (
      ' '
      ' '
      ' ')
    TabOrder = 7
  end
  object RadioGroup4: TRadioGroup
    Left = 91
    Top = 128
    Width = 289
    Height = 31
    Columns = 3
    Items.Strings = (
      ' '
      ' '
      ' ')
    TabOrder = 8
  end
  object RadioGroup5: TRadioGroup
    Left = 91
    Top = 156
    Width = 289
    Height = 31
    Columns = 3
    Items.Strings = (
      ' '
      ' '
      ' ')
    TabOrder = 9
  end
end
