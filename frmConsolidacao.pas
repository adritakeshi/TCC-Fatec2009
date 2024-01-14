unit frmConsolidacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Feagri;

type
  TFConsolidacao = class(TForm)

    btnOK: TButton;
    btnCancelar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    Label3: TLabel;
    CheckBox2: TCheckBox;
    Label4: TLabel;
    CheckBox3: TCheckBox;
    Label5: TLabel;
    CheckBox4: TCheckBox;
    Label6: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FConsolidacao: TFConsolidacao;
  N, Sem: integer;
  MatCons : array [1 .. 15] of TLabel;
  ChkApr  : array [1 .. 15] of TCheckBox;

implementation

uses principal, Builder;

{$R *.dfm}


procedure TFConsolidacao.FormCreate(Sender: TObject);
var a, i: integer;
 
begin
  Sem := Builder.SemCons; //Sem tem que receber o n�mero do semestre

  N := 1;

  While (Builder.Catalogo.SemestreFeagri[sem-1].MateriaSemestre[N].legenda <> '') do
    inc(N);

  dec(N);
  a:= 64;
  For i:= 1 to N do
  begin
    //Criando Labels das Mat�rias a serem consolidadas
    MatCons[i] := TLabel.Create(nil);
    MatCons[i].Parent := Self;
    MatCons[i].Left := 48;
    MatCons[i].Top := a;
    MatCons[i].Height := 20;
    MatCons[i].Visible := true;
    MatCons[i].Caption := Builder.Catalogo.SemestreFeagri[sem-1].MateriaSemestre[i].Legenda;
    MatCons[i].Font.Height := 20;
    MatCons[i].AutoSize := True;

    //Criando CheckBoxes para as mat�rias aprovadas
    ChkApr[i] := TCheckBox.Create(nil);
    ChkApr[i].Parent := Self;
    ChkApr[i].Left := 192;
    ChkApr[i].Top := a + 3;
    ChkApr[i].Width := 16;
    ChkApr[i].Visible := true;
    ChkApr[i].Caption := '';

    a:= a + 35;
  end;

  //Ajustando a posi��o dos bot�es e o tamanho do form
  btnOk.Top := a + 17;
  btnCancelar.Top := a + 17;
  self.Height := a + 100;
end;


procedure TFConsolidacao.btnOKClick(Sender: TObject);
var Mens, Mensagem: String;
    Cont, i, j: Integer;
    MatOk : array [1 .. 15] of String;
begin
  Mens := '';
  Cont := 0;
  For i := 1 to N do begin
      if ChkApr[i].Checked = true then begin
          if cont <> n then
              inc(Cont);
          MatOk[Cont] := MatCons[i].Caption;
      end;
  end;
  if cont <> 0 then
      For i := 1 to Cont do begin
          if Cont = 1 then
              Mens := Mens + MatOk[i]
          else
          if i < Cont - 1 then
              Mens := Mens + MatOk[i] + ', '
          else
          if (i = Cont - 1) or (i <> Cont) then
              Mens := Mens + MatOk[i]
          else
              Mens := Mens + ' e ' + MatOk[i];
      end;

  if Cont = 0 then
    Mensagem := 'Deseja consolidar o ' + IntToStr(sem) + '� Semestre?'
  else
  if Cont = 1 then
    Mensagem := 'Deseja consolidar o ' + IntToStr(sem) + '� Semestre com a mat�ria '
            + Mens + '?'
  else
  if Cont > 1 then
    Mensagem := 'Deseja consolidar o ' + IntToStr(sem) + '� Semestre com as mat�rias '
            + Mens + '?';

  if Messagedlg(Mensagem, mtinformation, [mbyes, mbno], 0) = idYes then
  begin

    For i := 1 to N do
    begin
      if ChkApr[i].Checked = true then
      begin
          Builder.Catalogo.SemestreFeagri[sem-1].MateriaSemestre[i].estado:= 1;
      end;
    end;

    if Cont = 0 then
      ShowMessage(IntToStr(Sem) + '� Semestre Consolidado com Sucesso.');

    if Cont = 1 then
      ShowMessage(IntToStr(Sem) + '� Semestre Consolidado com Sucesso.' +
                  #13 + 'Mat�ria: ' + Mens);

    if Cont > 1 then
      ShowMessage(IntToStr(Sem) + '� Semestre Consolidado com Sucesso.' +
                 #13 + 'Mat�rias: ' + Mens);

    Builder.Catalogo.ConsolidaSemestre(Sem, Builder.Horarios, Builder.PreReq);
    FrmBuilder.ConsolidadoOk(Sem);
    close;
  end;
end;


procedure TFConsolidacao.btnCancelarClick(Sender: TObject);
begin
  close;
end;


procedure TFConsolidacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=cafree;
end;

end.
