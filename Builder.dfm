object FrmBuilder: TFrmBuilder
  Left = 216
  Top = 93
  BorderWidth = 2
  Caption = 'Simula'#231#227'o'
  ClientHeight = 574
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 32
    Top = 8
    Width = 185
    Height = 41
    Caption = 'Panel1'
    Color = 12246520
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 232
    Top = 8
    Width = 185
    Height = 41
    Caption = 'Panel2'
    Color = 16743919
    TabOrder = 1
  end
  object Panel3: TPanel
    Left = 32
    Top = 56
    Width = 185
    Height = 41
    Caption = 'FA'
    Color = 8125374
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsStrikeOut]
    ParentFont = False
    TabOrder = 2
  end
  object Panel4: TPanel
    Left = 232
    Top = 56
    Width = 185
    Height = 41
    Caption = 'Panel4'
    Color = 2733818
    TabOrder = 3
  end
  object Panel5: TPanel
    Left = 32
    Top = 104
    Width = 185
    Height = 41
    Caption = 'Panel5'
    Color = 13548439
    TabOrder = 4
  end
  object Panel6: TPanel
    Left = 232
    Top = 104
    Width = 185
    Height = 41
    Caption = 'Panel6'
    Color = 12028062
    TabOrder = 5
  end
  object Panel7: TPanel
    Left = 32
    Top = 152
    Width = 185
    Height = 41
    Caption = 'Panel7'
    Color = 2376955
    TabOrder = 6
  end
  object Panel8: TPanel
    Left = 232
    Top = 152
    Width = 185
    Height = 41
    Caption = 'Panel8'
    Color = 9236983
    TabOrder = 7
  end
  object Panel9: TPanel
    Left = 32
    Top = 200
    Width = 185
    Height = 41
    Caption = 'Panel9'
    Color = 2928929
    TabOrder = 8
  end
  object Panel10: TPanel
    Left = 232
    Top = 200
    Width = 185
    Height = 41
    Caption = 'Panel10'
    Color = 10090289
    TabOrder = 9
  end
  object PainelPop: TPopupMenu
    OnPopup = PainelPopPopup
    Left = 176
    Top = 144
    object ExibeLeg: TMenuItem
      Caption = 'Exibir Descri'#231#227'o'
      OnClick = ExibeDescClick
    end
    object MHora: TMenuItem
      Caption = 'Exibir Hor'#225'rio'
      OnClick = MHoraClick
    end
    object MNormal: TMenuItem
      Caption = 'Tornar Normal'
      OnClick = MNormalClick
    end
    object MSimu: TMenuItem
      Caption = 'Tornar Simulada'
      OnClick = MSimuClick
    end
  end
end
