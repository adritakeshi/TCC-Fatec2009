object formprincipal: Tformprincipal
  Left = 0
  Top = 0
  Width = 674
  Height = 760
  Caption = 'Sistema de Planejamento Acad'#234'mico de Alunos da Feagri - Unicamp'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  Visible = True
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 8
    Top = 8
    object Arquivo1: TMenuItem
      Caption = '&Sistema'
      object Simulacao1: TMenuItem
        Caption = 'S&imula'#231#227'o'
        ShortCut = 16454
        OnClick = Simulacao1Click
      end
      object Carregarbackup1: TMenuItem
        Caption = 'C&arregar Backup'
        ShortCut = 16460
        OnClick = Carregarbackup1Click
      end
      object Backup1: TMenuItem
        Caption = '&Salvar Backup'
        ShortCut = 16450
        OnClick = Backup1Click
      end
      object Salvar1: TMenuItem
        Caption = 'Salvar'
        Enabled = False
        ShortCut = 16467
        OnClick = Salvar1Click
      end
      object Reset1: TMenuItem
        Caption = 'Reset'
        Enabled = False
        ShortCut = 16466
        OnClick = Reset1Click
      end
      object Sair1: TMenuItem
        Caption = 'Sa&ir'
        OnClick = Sair1Click
      end
    end
    object Adminstrador1: TMenuItem
      Caption = 'Administrador'
      ShortCut = 16449
      object Catlogo1: TMenuItem
        Caption = 'Cat'#225'logo'
        ShortCut = 16449
        OnClick = Catlogo1Click
      end
    end
    object Ajuda1: TMenuItem
      Caption = '&Ajuda'
      object Colaboradores1: TMenuItem
        Caption = 'Colaboradores'
        OnClick = Colaboradores1Click
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 8
    Top = 40
  end
  object OpenDialog1: TOpenDialog
    Left = 8
    Top = 72
  end
  object Feagri_Conector: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=BD/BD' +
      'Feagri.mdb;Mode=Share Deny None;Extended Properties="";Persist S' +
      'ecurity Info=False;Jet OLEDB:System database="";Jet OLEDB:Regist' +
      'ry Path="";Jet OLEDB:Database Password="";Jet OLEDB:Engine Type=' +
      '5;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bul' +
      'k Ops=2;Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Datab' +
      'ase Password="";Jet OLEDB:Create System Database=False;Jet OLEDB' +
      ':Encrypt Database=False;Jet OLEDB:Don'#39't Copy Locale on Compact=F' +
      'alse;Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SF' +
      'P=False'
    LoginPrompt = False
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 8
    Top = 104
  end
end
