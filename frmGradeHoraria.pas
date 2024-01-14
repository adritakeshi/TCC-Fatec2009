unit frmGradeHoraria;
//Tem que receber o valor do semestre do Aluno
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Buttons, DB, ADODB, Horarios, Feagri;//CaminhoCritico_Yu;

type
  TFGrade = class(TForm)
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    StringGrid1: TStringGrid;
    Label2: TLabel;
    Label3: TLabel;
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SelecionaPrimeiraCelula;
    procedure VerificaPreReq;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FGrade: TFGrade;
  SemOri: integer;
  Sem: integer;
  Hor: THorarios;
  CredSim: integer;
  ContCred: integer;
  Bloqueado: Boolean;
  CodSim: integer;

  //Simulacao e Materia a simular devem ser variáveis da tela do Yanagui
  Simulacao: boolean;
  MatSim: String;

implementation

uses principal, Builder;

{$R *.dfm}

procedure TFGrade.FormCreate(Sender: TObject);
var i, j, k: integer;
begin

  Simulacao := Builder.Simula;
  MatSim := Builder.MatSimulacao;
  SemOri:= Builder.origem;

  if (SemOri > 1) then
    Sem := Builder.origem
    else
     Sem:= 1;  

  label1.Font.Height := 20;
  label1.Left := 185;
  label1.Top := 35;

  Bitbtn1.Caption := '<';
  Bitbtn1.Width := 25;
  Bitbtn1.Left := 144;
  Bitbtn1.Top := 32;

  Bitbtn2.Caption := '>';
  Bitbtn2.Width := 25;
  Bitbtn2.Left := 376;
  Bitbtn2.Top := 32;

  StringGrid1.Left := 25;
  StringGrid1.Top := 88;

  Label1.Caption := 'Horário do ' + IntToStr(Sem) + 'º Semestre';

  if Sem = 1 then
    bitbtn1.Enabled := false;

  StringGrid1.Cells[1,0] := 'Segunda-feira';
  StringGrid1.Cells[2,0] := '   Terça-feira';
  StringGrid1.Cells[3,0] := '  Quarta-feira';
  StringGrid1.Cells[4,0] := '  Quinta-feira';
  StringGrid1.Cells[5,0] := '   Sexta-feira';
  StringGrid1.Cells[6,0] := '    Sábado';

  StringGrid1.Cells[0,1] := '  07:00';
  StringGrid1.Cells[0,2] := '  08:00';
  StringGrid1.Cells[0,3] := '  09:00';
  StringGrid1.Cells[0,4] := '  10:00';
  StringGrid1.Cells[0,5] := '  11:00';

  StringGrid1.Cells[0,7] := '  14:00';
  StringGrid1.Cells[0,8] := '  15:00';
  StringGrid1.Cells[0,9] := '  16:00';
  StringGrid1.Cells[0,10] := '  17:00';
  StringGrid1.Cells[0,11] := '  18:00';

  StringGrid1.Cells[0,13] := '  19:00';
  StringGrid1.Cells[0,14] := '  20:00';
  StringGrid1.Cells[0,15] := '  21:00';
  StringGrid1.Cells[0,16] := '  22:00';

  SelecionaPrimeiraCelula;

  if Simulacao = true then
  begin
    CredSim := Builder.Catalogo.ConsultaMateria(MatSim).credito;
    ContCred := CredSim;
  
   // FGrade.Height := FGrade.Height + 50;
    label1.Top := label1.Top + 50;
    Bitbtn1.Top := Bitbtn1.Top + 50;
    Bitbtn2.Top := Bitbtn2.Top + 50;
    StringGrid1.Top := StringGrid1.Top + 50;

    Label2.Caption := 'Simulação da Matéria: ' + MatSim;
    label2.Font.Height := 20;
    Label2.Left := 96;
    Label2.Top := 35;
    Label2.Visible := true;

    Label3.Caption := 'Crédito: ' + IntToStr(CredSim);
    label3.Font.Height := 20;
    Label3.Left := 352;
    Label3.Top := 35;
    Label3.Visible := true;
  end
  else
  begin
    Label2.Visible := false;
    Label3.Visible := false;
  end;

    for i := 0 to (high(Builder.Catalogo.SemestreFeagri)-1) do
      for j := 2 to 7 do
        for k := 1 to 16 do
          if (Builder.Horarios.GradeSem[i].Semana[j].Hora[k].MatLog = MatSim) then
            Dec(ContCred);

  CodSim := Builder.Catalogo.ConsultaMateria(MatSim).codigo;

  Builder.Horarios.PreencheHorarioNormal(StringGrid1, Sem, MatSim);
  Builder.Horarios.PreencheHorarioSimulado(StringGrid1, Sem);
  VerificaPreReq;


end;

procedure TFGrade.SelecionaPrimeiraCelula;
var MyRect: TGridRect;
begin
  MyRect.Left:=0; // coluna inicial
  MyRect.Right:=0; // coluna final
  MyRect.Top:=0; // linha inicial
  MyRect.Bottom:=0; // linha final
  stringGrid1.Selection:=MyRect;
end;

procedure TFGrade.BitBtn1Click(Sender: TObject);
begin
  bitbtn2.Enabled := true;
  SelecionaPrimeiraCelula;
  if Sem > 1 then
    dec(Sem);

  if Sem = 1 then
    bitbtn1.Enabled := false;

  Label1.Caption := 'Horário do ' + IntToStr(Sem) + 'º Semestre';

  Builder.Horarios.PreencheHorarioNormal(StringGrid1, Sem, MatSim);
  Builder.Horarios.PreencheHorarioSimulado(StringGrid1, Sem);
  VerificaPreReq;


end;

procedure TFGrade.BitBtn2Click(Sender: TObject);
begin
  bitbtn1.Enabled := true;
  SelecionaPrimeiraCelula;

  if Sem < (high(Builder.Catalogo.SemestreFeagri)+1) then
    inc(Sem);

  if Sem = (high(Builder.Catalogo.SemestreFeagri)+1) then
    bitbtn2.Enabled := false;

  Label1.Caption := 'Horário do ' + IntToStr(Sem) + 'º Semestre';

  Builder.Horarios.PreencheHorarioNormal(StringGrid1, Sem, MatSim);
  Builder.Horarios.PreencheHorarioSimulado(StringGrid1, Sem);
  VerificaPreReq;

end;

procedure TFGrade.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var i, j, k: integer;
begin

  //Se não for simulação, sai
  if Simulacao = false then
    exit;

  //Se for em horario que nao tem aula, sai
  if (ARow = 6) or (ARow = 12) then
    exit;

  //Se o semestre estiver consolidado, sai
  if Builder.Catalogo.SemestreFeagri[sem - 1].Consolidado = true then
  begin
    ShowMessage('O ' + IntToStr(sem) + 'º semestre está consolidado');
    exit;
  end;

  //Se o semestre estiver trancado, sai
  if Builder.Catalogo.SemestreFeagri[sem - 1].Trancado = true then
  begin
    ShowMessage('O ' + IntToStr(sem) + 'º semestre está trancado');
    exit;
  end;

  //Se o semestre estiver travado, sai
  if Builder.Catalogo.SemestreFeagri[sem - 1].Travado = true then
  begin
    ShowMessage('O ' + IntToStr(sem) + 'º semestre está travado');
    exit;
  end;

  //Se não puder cursar a matéria por causa de pré-requisito, sai
  if Bloqueado = true then
  begin
    ShowMessage('A matéria ' + MatSim + ' depende de pré-requisito(s) para' +
      ' poder ser cursada no ' + IntToStr(sem) + 'º semestre');
    exit;
  end;

  //Se não tiver matéria, cria matéria simulada.
  if StringGrid1.Cells[ACol, ARow] = '' then
  begin
    for i := 0 to (High(Builder.Catalogo.SemestreFeagri)) do
      for j := 2 to 7 do
        for k := 1 to 16 do
          if (builder.Horarios.GradeSem[i].Semana[j].Hora[k].MatLog = MatSim) and (sem <> i) then
          begin
            ShowMessage('Essa matéria já está sendo simulada no ' +
              IntToStr(i) + 'º Semestre');
            exit;
          end;

          
    if ContCred <> 0 then
    begin
      if (ContCred = CredSim) and (Builder.Catalogo.ConsultaSemestre(MatSim) <> Sem) and (not Builder.Catalogo.TemCredito(Sem,CredSim)) then
      begin
       if MessageDlg(Feagri.Mensagens[12] + #13 + Feagri.Mensagens[13], mtInformation, [mbYes, mbNo], 0) = idNo then
        exit;
      end;
     Builder.Horarios.GravaHorarioLogico(sem,ACol+1,ARow,MatSim);
     Builder.Horarios.PreencheHorarioSimulado(StringGrid1, Sem);
     Dec(ContCred);
    end
    else
      ShowMessage('A matéria ' + MatSim + ' já alcançou o limite de créditos');
  end
  else
    //Se já houver uma matéria simulada, deixar o espaço em branco
    if (builder.Horarios.GradeSem[sem].Semana[ACol+1].Hora[ARow].MatLog <> '') and
       (builder.Horarios.GradeSem[sem].Semana[ACol+1].Hora[ARow].MatLog = MatSim)then
    begin
      builder.Horarios.ExcluiHorarioLogico(sem,ACol+1,ARow);
      builder.Horarios.PreencheHorarioNormal(StringGrid1, Sem, MatSim);
      builder.Horarios.PreencheHorarioSimulado(StringGrid1, Sem);
      if ContCred < CredSim then
        inc(ContCred);
    end;
end;


procedure TFGrade.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if Simulacao = True then
 begin
  if (ContCred = 0) then
  begin
    //Builder.Horarios.SalvaHorarios;//(MatSim, ContCred, CredSim);
    Builder.SimuOk := true;
    Builder.Horarios.ExcluiHorarioNormal(MatSim);
    Builder.Catalogo.TornaSimulada(MatSim,SemOri,Sem);
    Builder.SemDestinoSimulacao:= Sem;
    FrmBuilder.SimulacaoOk;
    Action := cafree;
  end
  else
  if (ContCred = CredSim) then
  begin
    Builder.SimuOk := false;
    Builder.MatSimulacao:= '';
    Action := cafree;
  end
  else
  begin
    ShowMessage('Ainda falta(m) ' + IntToStr(ContCred) + ' crédito(s) para a ' +
      'matéria ' + MatSim);
    Action := canone;
    Builder.SimuOk := false;
  end;
 end
 else
  Action:= cafree;
end;




procedure TFGrade.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
Const
  //Defina a cor aqui
  clPaleGreen = TColor($F2E4D7);
begin
  if Builder.Horarios = nil then
    exit;

  //Colorindo as matérias simuladas
  if Builder.Horarios.GradeSem[Sem].Semana[ACol+1].Hora[ARow].MatLog <> '' then
    StringGrid1.Canvas.Brush.color := clPaleGreen
  else
    StringGrid1.Canvas.Brush.Color := clWhite;

  If (ACol > 0) and (ARow > 0) then
  begin
    //Pintando o Fundo
    StringGrid1.canvas.fillRect(Rect);
    //Pintando o Texto
    StringGrid1.canvas.TextOut(Rect.Left + 20, Rect.Top + 2, StringGrid1.Cells[ACol,ARow]);
  end;

end;

procedure TFGrade.VerificaPreReq();
begin

  if (PreReq.PodeCursar(Builder.Catalogo.SemestreFeagri, Builder.Catalogo.AproveitamentoDeEstudos, CodSim, Sem)) and
     (PreReq.PodeCursarPreRequisito(Builder.Catalogo.SemestreFeagri, CodSim, sem)) then
     Bloqueado := false
  else
     Bloqueado := true;

end;



end.
