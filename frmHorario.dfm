object FormHorario: TFormHorario
  Left = 133
  Top = 92
  Width = 526
  Height = 384
  BorderIcons = []
  Caption = 'Grade hor'#225'ria'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 9
    Top = 8
    Width = 496
    Height = 273
    ColCount = 7
    DefaultColWidth = 50
    DefaultRowHeight = 16
    RowCount = 17
    TabOrder = 0
    ColWidths = (
      50
      74
      74
      74
      72
      77
      63)
    RowHeights = (
      16
      16
      16
      16
      16
      5
      16
      16
      16
      16
      5
      16
      16
      16
      16
      16
      16)
  end
  object BtnSimular: TButton
    Left = 352
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Simular'
    TabOrder = 1
    OnClick = BtnSimularClick
  end
end
