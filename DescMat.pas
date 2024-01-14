unit DescMat;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids,feagri;

type
  TFDescMat = class(TForm)
    lblLeg: TLabel;
    LblCred: TLabel;
    LblDesc: TLabel;
    lblNom: TLabel;
    LblPrereq: TLabel;
    MatDesc: TMemo;
    MatLeg: TLabel;
    MatCred: TLabel;
    MatPreReq: TListBox;
    horario: TStringGrid;
    MatNom: TEdit;
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDescMat: TFDescMat;
  Materia:RMateria;
  Aberto:boolean;
  LstPreReq: array[1..5] of string;

implementation

{$R *.dfm}
function InttoHour(hora:integer):string;
begin
  case hora of
     1: result := '07:00';
     2: result := '08:00';
     3: result := '09:00';
     4: result := '10:00';
     5: result := '11:00';
     7: result := '14:00';
     8: result := '15:00';
     9: result := '16:00';
    10: result := '17:00';
    11: result := '18:00';
    13: result := '19:00';
    14: result := '20:00';
    15: result := '21:00';
    16: result := '22:00';
    17: result := '23:00'; 
  end;
end;

function InttoDayOfWeek(dia:integer):string;
begin
  case dia of
     1: result := 'domingo';
     2: result := 'segunda';
     3: result := 'terça';
     4: result := 'quarta';
     5: result := 'quinta';
     6: result := 'sexta';
     7: result := 'sábado';
  end;

end;

procedure TFDescMat.FormCreate(Sender: TObject);
var i: integer;
begin
  horario.Cells[0,0] := 'Dia da semana';
  horario.Cells[1,0] := 'Horário de início';
  MatLeg.Caption := Materia.legenda;
  MatCred.Caption := inttostr(Materia.Credito);
  MatNom.Text := Materia.nome;
  MAtDesc.Text := Materia.desc;
  if length(Materia.hora) = 0 then
      Horario.RowCount := 2
  else Horario.RowCount := length(Materia.hora)+1;

  for i:= low(Materia.hora) to high(Materia.hora) do begin
      horario.Cells[1,i+1]:= InttoHour(Materia.hora[i].Hora);
      horario.Cells[0,i+1]:= InttoDayOfWeek(Materia.hora[i].DiaDaSemana);
  end;

  for I := 1 to 5 do
    if LstPreReq[I] <> '' then self.MatPreReq.Items.Add(LstPreReq[I]);


end;


procedure TFDescMat.FormActivate(Sender: TObject);
var i:integer;
begin

horario.Cells[0,0] := 'Dia da semana';
  horario.Cells[1,0] := 'Horário de início';
  MatLeg.Caption := Materia.legenda;
  MatCred.Caption := inttostr(Materia.Credito);
  MatNom.Text := Materia.nome;
  MAtDesc.Text := Materia.desc;

  for I := 1 to Horario.RowCount do
  begin
    horario.Cells[0,i]:= '';
    horario.Cells[1,i]:= '';
  end;

  if length(Materia.hora) = 0 then
      Horario.RowCount := 2
  else Horario.RowCount := length(Materia.hora)+1;

  for i:= low(Materia.hora) to high(Materia.hora) do begin
      horario.Cells[1,i+1]:= InttoHour(Materia.hora[i].Hora);
      horario.Cells[0,i+1]:= InttoDayOfWeek(Materia.hora[i].DiaDaSemana);
  end;

  self.MatPreReq.Clear;
  for I := 1 to 5 do
    if LstPreReq[I] <> '' then self.MatPreReq.Items.Add(LstPreReq[I]);


end;

procedure TFDescMat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=cafree;
  aberto:=false;
end;

procedure TFDescMat.FormDeactivate(Sender: TObject);
begin
  Close;
end;

end.
