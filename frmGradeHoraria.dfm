object FGrade: TFGrade
  Left = 211
  Top = 131
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Grade Hor'#225'ria'
  ClientHeight = 423
  ClientWidth = 549
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 96
    Top = 35
    Width = 161
    Height = 20
    Caption = 'Simula'#231#227'o da Mat'#233'ria: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 352
    Top = 35
    Width = 57
    Height = 20
    Caption = 'Cr'#233'dito:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 185
    Top = 35
    Width = 177
    Height = 20
    Caption = 'Hor'#225'rio do 10'#186' Semestre'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object StringGrid1: TStringGrid
    Left = 25
    Top = 88
    Width = 496
    Height = 273
    ColCount = 7
    Ctl3D = True
    DefaultColWidth = 50
    DefaultRowHeight = 16
    RowCount = 17
    ParentCtl3D = False
    TabOrder = 2
    OnDrawCell = StringGrid1DrawCell
    OnSelectCell = StringGrid1SelectCell
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
      15
      5
      16
      16
      16
      15
      16
      5
      16
      16
      16
      16)
  end
  object BitBtn1: TBitBtn
    Left = 144
    Top = 32
    Width = 25
    Height = 25
    Caption = '<'
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 376
    Top = 32
    Width = 25
    Height = 25
    Caption = '>'
    TabOrder = 1
    OnClick = BitBtn2Click
  end
end
