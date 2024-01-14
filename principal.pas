unit principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, DB, ADODB, ExtCtrls, ComCtrls,
  Feagri;

type
  Tformprincipal = class(TForm)
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Ajuda1: TMenuItem;
    Sair1: TMenuItem;
    Colaboradores1: TMenuItem;
    Backup1: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Carregarbackup1: TMenuItem;
    Feagri_Conector: TADOConnection;
    Simulacao1: TMenuItem;
    Adminstrador1: TMenuItem;
    Catlogo1: TMenuItem;
    Salvar1: TMenuItem;
    Reset1: TMenuItem;
    procedure HorarioClick(Sender: TObject);
    //procedure Adminstrador1Click(Sender: TObject);
    procedure Simulacao1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Backup1Click(Sender: TObject);
    procedure Carregarbackup1Click(Sender: TObject);
    procedure Colaboradores1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Catlogo1Click(Sender: TObject);
    procedure Salvar1Click(Sender: TObject);
    procedure Reset1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    var AluRA:string;
        AluAno: integer;
        AluNome: string;
   end;

var
  formprincipal: Tformprincipal;

implementation

uses controle, colaboradores,  Aluno3, frmcadcat2, Horarios,
  frmCadMat2, frmConsolidacao, frmGradeHoraria, Builder;

{$R *.dfm}

procedure Tformprincipal.Colaboradores1Click(Sender: TObject);
begin
colab:= tcolab.Create(application);
colab.show;
end;

procedure Tformprincipal.Sair1Click(Sender: TObject);
begin
if Application.MessageBox('Deseja sair do sistema', 'Feagri',36) = 6 then
 close;
end;

procedure Tformprincipal.Salvar1Click(Sender: TObject);
begin
Builder.Catalogo.SalvaCatalogo;
Builder.Horarios.SalvaHorarios;
end;

procedure Tformprincipal.FormCreate(Sender: TObject);
begin
try
 feagri_conector.Open;
except
 Application.MessageBox('Erro ao carregar a base de dados','Feagri',16);
 halt;
end;

end;

procedure Tformprincipal.FormDestroy(Sender: TObject);
begin
halt;
end;

procedure Tformprincipal.Backup1Click(Sender: TObject);
var
origem, destino: string;
begin
origem := ExtractFilePath(Application.ExeName)+'bd\bdfeagri.mdb';
if savedialog1.Execute then
  begin
  destino := savedialog1.Files[0];
  if (CopyFile(PChar(origem),PChar(destino), true)) then
    ShowMessage('Backup efetuado com sucesso')
  else
    ShowMessage('Houve um erro na realização do backup');
  end;
end;

procedure Tformprincipal.Carregarbackup1Click(Sender: TObject);
var origem, destino : string;
begin

 if OpenDialog1.Execute then
  begin
  origem := opendialog1.Files[0];
  destino:= ExtractFilePath(Application.ExeName)+'bd\bdfeagri.mdb';
  if FileExists(destino) then
    begin
    feagri_conector.Close;
    if DeleteFile(destino) then
    begin
       if CopyFile(PChar(origem),PChar(destino), true) then
       begin
        showmessage('Sistema restaurado com sucesso!');
      end;
    end
      else
        showmessage('Erro ao restaurar backup');
      end;
  feagri_conector.ConnectionString :=  origem;
  feagri_conector.Connected := true;
end;

end;

procedure Tformprincipal.Catlogo1Click(Sender: TObject);
begin
FCadCat:= TFCadCat.Create(application);
FCadCat.ShowModal;
end;

procedure Tformprincipal.Simulacao1Click(Sender: TObject);
begin
FAluno:= TFAluno.Create(Application);
FAluno.ShowModal;
end;

procedure Tformprincipal.HorarioClick(Sender: TObject);
begin
Application.CreateForm(TFGrade, FGrade);
end;

procedure Tformprincipal.Reset1Click(Sender: TObject);
var i:integer;
begin

Builder.Catalogo.ResetCatalogo;
Builder.Catalogo:= TCatalogo.Create(AluRA,AluAno);
Builder.Horarios:= THorarios.Create(AluRA,AluAno);
Builder.PreReq:= TPreReq.Create(AluRA,AluAno);

for I := 15 to high(Builder.GrpSem) do
 FrmBuilder.DestroiGrp(Builder.GrpSem[I], 0, I+1);

SetLength(Builder.GrpSem, 15);
FrmBuilder.ConsolidadoOk(0);
end;

end.
