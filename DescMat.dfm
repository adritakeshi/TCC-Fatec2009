object FDescMat: TFDescMat
  Left = 0
  Top = 0
  BiDiMode = bdLeftToRight
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Descri'#231#227'o de Mat'#233'ria '
  ClientHeight = 317
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ParentBiDiMode = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object lblLeg: TLabel
    Left = 27
    Top = 13
    Width = 37
    Height = 13
    Caption = 'C'#243'digo:'
  end
  object LblCred: TLabel
    Left = 151
    Top = 12
    Width = 44
    Height = 13
    Caption = 'Cr'#233'ditos:'
  end
  object LblDesc: TLabel
    Left = 22
    Top = 180
    Width = 46
    Height = 13
    Caption = 'Descri'#231#227'o'
  end
  object lblNom: TLabel
    Left = 24
    Top = 36
    Width = 31
    Height = 13
    Caption = 'Nome:'
  end
  object LblPrereq: TLabel
    Left = 25
    Top = 87
    Width = 66
    Height = 13
    Caption = 'Pr'#233'-requisitos'
  end
  object MatLeg: TLabel
    Left = 66
    Top = 13
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object MatCred: TLabel
    Left = 199
    Top = 12
    Width = 3
    Height = 13
    Color = clBtnFace
    ParentColor = False
  end
  object MatDesc: TMemo
    Left = 23
    Top = 198
    Width = 346
    Height = 99
    Color = clWhite
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object MatPreReq: TListBox
    Left = 24
    Top = 109
    Width = 81
    Height = 60
    Color = clWhite
    ItemHeight = 13
    TabOrder = 1
  end
  object horario: TStringGrid
    Left = 120
    Top = 96
    Width = 249
    Height = 81
    Color = clWhite
    ColCount = 2
    FixedCols = 0
    RowCount = 15
    TabOrder = 2
    ColWidths = (
      123
      102)
  end
  object MatNom: TEdit
    Left = 25
    Top = 55
    Width = 344
    Height = 21
    ReadOnly = True
    TabOrder = 3
  end
end
