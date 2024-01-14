unit Horarios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Grids;

type

 RHorMat = array of record
                     DiaDaSemana: integer;
                     Hora: integer;
                    end;

 DiaSemana =  record
                Hora: array [1..16] of record
                                        Materia:  String;
                                        MatLog:  String;
                                        MatBD:  String;
                                        Simulacao: Boolean;
                                       end;
              end;

 //Semestre na posicao 0 representa o primeiro semestre, posicao 1, segundo semestre...
 Semestre = array of record
                   Semana: array[1..7] of DiaSemana;
                   SemCons: Boolean;
                   SemTranc: Boolean;
                  end;


 THorarios = class(TObject)
   public
   AluRA: String;
   Ano: Integer;
   GradeSem: Semestre;
   constructor Create(AluRA: String; Ano: integer);
   procedure PreencheHorarioNormal(Grade: TStringGrid; Sem: Integer; MatSim: String);
   procedure PreencheHorarioSimulado(Grade: TStringGrid; Sem: Integer);
   Procedure SalvaHorarios;
   Procedure CarregaHorarioNormal();
   Procedure CarregaHorarioSimulado();
   Function  BateHorario(Semestre: Integer; Hora: RHorMat): Boolean;
   Procedure MudaHorario(SemOri: integer; mat: string; Horario: RHorMat; SemDes: integer);
   Procedure GravaHorarioLogico(Sem: Integer; Semana: Integer; Hora: Integer; MatSim: String);
   Procedure ExcluiHorarioLogico(Sem: Integer; Semana: Integer; Hora: Integer);
   function  ConsultaTurma(mat: string): integer;
   procedure DesfazGrade(sem: integer);
   function  RecuperaHorarioSimulado(var semestre: integer; mat: string): RHorMat;
   procedure ExcluiHorarioNormal(mat: string);
   procedure LimpaGrade();

 end;

var
 Hora : array[1..16] of string;
 Semana : array[1..7] of String;
 MaxSem: Integer;

implementation
uses principal;


Constructor THorarios.Create(aluRA: String; Ano: integer);
var i: integer;
    rs:_RecordSet;
begin
  Self.AluRA := AluRA;
  Self.Ano := Ano;
  For i := 1 to 16 do
  begin
    if (i <= 5) or ((i > 12) and (i <= 16)) then
    begin
      if (i + 6 < 10) then
        Hora[i] := '0' + IntToStr(i + 6) + ':00'
      else
        Hora[i] := IntToStr(i + 6) + ':00';
    end
    else
    begin
    if (i > 6) and (i <= 11) then
      if (i + 7 < 10) then
        Hora[i] := '0' + IntToStr(i + 7) + ':00'
      else
        Hora[i] := IntToStr(i + 7) + ':00';
     end;
  end;

  Semana[1] := 'Domingo';
  Semana[2] := 'Segunda';
  Semana[3] := 'Terça';
  Semana[4] := 'Quarta';
  Semana[5] := 'Quinta';
  Semana[6] := 'Sexta';
  Semana[7] := 'Sábado';

  rs:= formprincipal.Feagri_Conector.Execute('select * from semestre where aluRA = '+quotedstr(AluRA));
  MaxSem := rs.RecordCount;
  SetLength(Self.GradeSem,MaxSem+1);

  Self.CarregaHorarioNormal;
  Self.CarregaHorarioSimulado;

end;


procedure THorarios.PreencheHorarioNormal(Grade: TStringGrid; Sem: Integer; MatSim: String);
var i, j: integer;

begin
  For i:= 1 to 6 do
    For j:= 1 to 16 do
       if (j <> 6) and (j <> 12) then
         if Self.GradeSem[Sem].Semana[i+1].Hora[j].Materia = MatSim then
         begin
          // Self.GradeSem[Sem].Semana[i+1].Hora[j].Materia := '';
           Grade.Cells[i,j]:= '';
         end
         else
           Grade.Cells[i,j]:= Self.GradeSem[Sem].Semana[i+1].Hora[j].Materia;
end;


procedure THorarios.PreencheHorarioSimulado(Grade: TStringGrid; Sem: Integer);
var i, j: integer;
begin
  For i:= 1 to 6 do
    For j:= 1 to 16 do
      if (j <> 6) and (j <> 12) then
        if Self.GradeSem[Sem].Semana[i+1].Hora[j].MatLog <> '' then
          Grade.Cells[i,j]:= Self.GradeSem[Sem].Semana[i+1].Hora[j].MatLog;
end;



procedure THorarios.SalvaHorarios;
var i, j, k, CMCod: integer;
    //Eletiva nao term TURMA, tem Histórico
    LogCons, LogMat, LogTurNor, LogTurNorSim, BDCons, BDMat, BDTurNor, BDTurNorSim:_RecordSet;
    LogEletiva, LogNormal, BDNormal, BDEletiva, TransOk: Boolean;
begin
try
  For i := 0 to (maxsem) do
    For j :=  2 to 7 do
      For k := 1 to 16 do
      begin
        if Self.GradeSem[i].Semana[j].Hora[k].Simulacao = true then
        begin
          TransOk := False;
          LogNormal := False;
          LogEletiva := False;
          BDNormal := False;
          BDEletiva := False;

          if Self.GradeSem[i].Semana[j].Hora[k].MatLog <> '' then
          begin
            //Pega o valor do CMCod da Matéria Simulada
            LogMat := FormPrincipal.Feagri_Conector.Execute('Select CMCod,' +
                      ' MatSem from Cat_Mat where MatCod = ' +
                      QuotedStr(Self.GradeSem[i].Semana[j].Hora[k].MatLog) +
                      ' and CatCod = ' + IntToStr(Self.Ano));

            //Verificar se a Matéria é Normal ou Eletiva
            LogCons := FormPrincipal.Feagri_Conector.Execute('Select MatSem from' +
                       ' Cat_Mat where CMCod = ' +
                       IntToStr(LogMat.Fields[0].Value));

            if LogCons.Fields[0].Value = 0 then
              LogEletiva := true
            else
              LogNormal := true;

            //Coletando Dados da Turma Normal
            LogTurNor := FormPrincipal.Feagri_Conector.Execute('Select CMTCod from' +
                         ' Cat_Mat_Tur where CMCod = ' + IntToStr(LogMat.Fields[0].Value) +
                         ' and AluRa is null');

            //Coletando Dados da Turma Normal Simulada
            LogTurNorSim := FormPrincipal.Feagri_Conector.Execute('Select CMTCod from' +
                         ' Cat_Mat_Tur where CMCod = ' +
                         IntToStr(LogMat.Fields[0].Value) +
                         ' and AluRA = ' + QuotedStr(Self.AluRA));
          end;


          if Self.GradeSem[i].Semana[j].Hora[k].MatBD <> '' then
          begin
            //Pega o valor do CMCod da Matéria Simulada
            BDMat := FormPrincipal.Feagri_Conector.Execute('Select CMCod,' +
                     ' MatSem from Cat_Mat where MatCod = ' +
                     QuotedStr(Self.GradeSem[i].Semana[j].Hora[k].MatBD) +
                     ' and CatCod = ' + IntToStr(Self.Ano));

            //Verificar se a Matéria é Normal ou Eletiva
            BDCons := FormPrincipal.Feagri_Conector.Execute('Select MatSem from' +
                      ' Cat_Mat where CMCod = ' +
                      IntToStr(BDMat.Fields[0].Value));

            if BDCons.Fields[0].Value = 0 then
              BDEletiva := true
            else
              BDNormal := true;

            //Coletando Dados da Turma Normal
            BDTurNor := FormPrincipal.Feagri_Conector.Execute('Select CMTCod from' +
                         ' Cat_Mat_Tur where CMCod = ' + IntToStr(BDMat.Fields[0].Value) +
                         ' and AluRa is null');

            //Coletando Dados da Turma Normal Simulada
            BDTurNorSim := FormPrincipal.Feagri_Conector.Execute('Select CMTCod from' +
                            ' Cat_Mat_Tur where CMCod = ' +
                            IntToStr(BDMat.Fields[0].Value) +
                            ' and AluRA = ' + QuotedStr(Self.AluRA));
          end;




        //Normal ou Eletiva e Grava matéria simulada
        if (Self.GradeSem[i].Semana[j].Hora[k].MatLog <> '')
           and (Not TransOK)then
        begin
          if (LogTurNorSim.BOF) and (LogTurNorSim.EOF) then
          begin
            //Criando a Turma Simulada
            FormPrincipal.Feagri_Conector.Execute('Insert into Cat_Mat_Tur' +
              ' (CMCod, TurCod, SemLet, AluRA) values (' +
              IntToStr(LogMat.Fields[0].Value) + ', 3, null, ' +
              QuotedStr(Self.AluRA) + ');');

            //Verificando valor do CMTCod da turma simulada criada acima
            LogTurNorSim := FormPrincipal.Feagri_Conector.Execute('Select CMTCod' +
                           ' from Cat_Mat_Tur where CMCod = ' +
                           IntToStr(LogMat.Fields[0].Value) +
                           ' and AluRA = ' + QuotedStr(Self.AluRA));

            If LogNormal then
            //Mudando o Histórico da Turma Normal para a Turma Simulada
            FormPrincipal.Feagri_Conector.Execute('Update Cat_Mat_Tur_Hist' +
              ' set SemCur = ' + IntToStr(i) + ', CMTCod = ' +
              IntToStr(LogTurNorSim.Fields[0].Value) + ' where CMTCod = ' +
              IntToStr(LogTurNor.Fields[0].Value) + ' and AluRA = ' +
              QuotedStr(Self.AluRA))
            else
            begin
            LogCons := FormPrincipal.Feagri_Conector.Execute('Select CMTCod from' +
                      ' Cat_Mat_Tur_Hist where CMCod = ' +
                      IntToStr(LogMat.Fields[0].Value) + ' and AluRA = ' +
                      QuotedStr(Self.AluRA));

            //Mudando o Histórico da Turma Eletiva para a Turma Simulada
            FormPrincipal.Feagri_Conector.Execute('Update Cat_Mat_Tur_Hist' +
              ' set SemCur = ' + IntToStr(i) + ', CMTCod = ' +
              IntToStr(LogTurNorSim.Fields[0].Value) + ' where CMCod = ' +
              IntToStr(LogMat.Fields[0].Value) + ' and AluRA = ' +
              QuotedStr(Self.AluRA));  

            end;
          end;

          //Inserindo os Horários
          FormPrincipal.Feagri_Conector.Execute('Insert into Cat_Mat_Tur_Hor' +
            ' (IniHor, DiaHor, CMCod, CMTCod) values (' +  quotedstr(Hora[k]) + ', ' +
            QuotedStr(Semana[j]) + ', ' + IntToStr(LogMat.Fields[0].Value) + ', ' +
            IntToStr(LogTurNorSim.Fields[0].Value) + ');');

          if (Self.GradeSem[i].Semana[j].Hora[k].MatLog <> '') and
             (Self.GradeSem[i].Semana[j].Hora[k].MatBD <> '') then
            TransOk := false
          else
            TransOk := true;

          Self.GradeSem[i].Semana[j].Hora[k].MatBD := Self.GradeSem[i].Semana[j].Hora[k].MatLog;

        end;




        //Normal e Exclui matéria simulada
        if (BDNormal = true) and (Self.GradeSem[i].Semana[j].Hora[k].MatBD <> '')
            and (Not TransOk) then
        begin
          if (BDTurNorSim.BOF = false) or (BDTurNorSim.EOF = false) then
          begin
            //Deletando os Horários da Turma Simulada
            FormPrincipal.Feagri_Conector.Execute('Delete from Cat_Mat_Tur_Hor' +
              ' where CMTCod = ' + IntToStr(BDTurNorSim.Fields[0].Value));

            //Mudando a Turma Simulada para turma normal
            FormPrincipal.Feagri_Conector.Execute('Update Cat_Mat_Tur_Hist ' +
              ' set CMTCod = ' + IntToStr(BDTurNor.Fields[0].Value) + ' where CMTCod = ' +
              IntToStr(BDTurNorSim.Fields[0].value) + ' and AluRA = ' +
              QuotedStr(Self.AluRA));

            //Deletando a Turma Simulada
            FormPrincipal.Feagri_Conector.Execute('Delete from Cat_Mat_Tur' +
              ' where CMTCod = ' + IntToStr(BDTurNorSim.Fields[0].Value));

            Self.GradeSem[i].Semana[j].Hora[k].MatBD := '';
            TransOk := True;
          end;
        end;




        //Eletiva e Exclui matéria simulada
        if BDEletiva and (Self.GradeSem[i].Semana[j].Hora[k].MatBD <> '')
           and (Not TransOk) then
        begin
        if (BDTurNorSim.BOF = False) or (BDTurNorSim.EOF = false) then
          begin
            //Deletando os Horários da Turma Simulada
            FormPrincipal.Feagri_Conector.Execute('Delete from Cat_Mat_Tur_Hor' +
              ' where CMTCod = ' + IntToStr(BDTurNorSim.Fields[0].Value));

            //Mudando a Turma Simulada para turma normal
            FormPrincipal.Feagri_Conector.Execute('Update Cat_Mat_Tur_Hist ' +
              ' set SemCur = 0 , CMTCod = null where CMTCod = ' +
              IntToStr(BDTurNorSim.Fields[0].value) + ' and AluRA = ' +
              QuotedStr(Self.AluRA));

            //Deletando a Turma Simulada
            FormPrincipal.Feagri_Conector.Execute('Delete from Cat_Mat_Tur' +
              ' where CMTCod = ' + IntToStr(BDTurNorSim.Fields[0].Value));

            Self.GradeSem[i].Semana[j].Hora[k].MatBD := '';
            TransOk := True;
          end;
        end;
        Self.GradeSem[i].Semana[j].Hora[k].Simulacao := false;
        end;
     end;

     Self.CarregaHorarioNormal;
     Self.CarregaHorarioSimulado;

     Application.MessageBox('Simulação salva com sucesso','Feagri',64);  

     except

     Application.MessageBox('Erro ao gravar os horários' + #13 + 'Contate o administrador','Feagri',16);
     Application.Terminate;

   end;
end;


procedure THorarios.CarregaHorarioNormal();
var i: Integer; //Representa o Semestre
    j: Integer; //Representa o Dia da Semana
    k: Integer; //Representa o Horario
    rs:_RecordSet;
begin
   rs := FormPrincipal.Feagri_Conector.Execute('Select SemCur,' +
        ' DiaHor, IniHor, MatCod, cm.CMCod from Cat_Mat cm,' +
        ' Cat_Mat_Tur cmt, Cat_Mat_Tur_Hor cmthor, Cat_Mat_Tur_Hist cmthist' +
        ' where cmt.turcod = 1 and cm.CMCod = cmt.CMCod and cmthist.cmtcod = ' +
        ' cmt.cmtcod and cmthor.cmtcod = cmt.cmtcod and CatCod = ' +
        IntToStr(Self.Ano) + ' and cmthist.alura = ' + quotedstr(Self.AluRA) +
        ' order by SemCur, DiaHor, IniHor asc;');
  if (rs.BOF = false) or (rs.EOF = false) then
  For i := 1 to (MaxSem) do
    while (not rs.eof) and (rs.Fields[0].Value = i) do
    begin
      For j := 2 to 7 do
      begin
        if UpperCase(rs.Fields[1].Value) = UpperCase(Semana[j]) then
          For k := 1 to 16 do
            if rs.Fields[2].Value = Hora[k] then
            begin
                Self.GradeSem[i].Semana[j].Hora[k].Materia := rs.Fields[3].Value; 
            end;
      end;
      if not rs.EOF then
        rs.MoveNext;
    end;
end;


Procedure THorarios.CarregaHorarioSimulado;
var i: Integer; //Representa o Semestre
    j: Integer; //Representa o Dia da Semana
    k: Integer; //Representa o Horario
    rs:_RecordSet;
begin
   rs := FormPrincipal.Feagri_Conector.Execute('Select SemCur,' +
        ' DiaHor, IniHor, MatCod, cm.CMCod from Cat_Mat cm,' +
        ' Cat_Mat_Tur cmt, Cat_Mat_Tur_Hor cmthor, Cat_Mat_Tur_Hist cmthist' +
        ' where cmt.turcod = 3 and cm.CMCod = cmt.CMCod and cmthist.cmtcod = ' +
        ' cmt.cmtcod and cmthor.cmtcod = cmt.cmtcod and CatCod = ' +
        IntToStr(Self.Ano) + ' and cmthist.alura = ' + quotedstr(Self.AluRA) +
        ' order by MatSem, DiaHor, IniHor asc;');
  if (rs.BOF = false) or (rs.EOF = false) then
  For i := 0 to (MaxSem) do
    while (not rs.eof) and (rs.Fields[0].Value = i) do
    begin
      For j := 2 to 7 do
      begin
        if UpperCase(rs.Fields[1].Value) = UpperCase(Semana[j]) then
          For k := 1 to 16 do
            if rs.Fields[2].Value = Hora[k] then
            begin
              Self.GradeSem[i].Semana[j].Hora[k].MatLog := rs.Fields[3].Value;
              Self.GradeSem[i].Semana[j].Hora[k].MatBD := rs.Fields[3].Value; 
            end;
      end;
      if not rs.EOF then
        rs.MoveNext;
    end;
end;


Function THorarios.BateHorario(Semestre: Integer; Hora: RHorMat): Boolean;
var i: integer;
begin
  BateHorario := false;
  for i:= low(Hora) to High(Hora) do
  begin
    if (Self.GradeSem[Semestre].Semana[(Hora[i].DiaDaSemana)].Hora[Hora[i].Hora].Materia <> '') or
       (Self.GradeSem[Semestre].Semana[(Hora[i].DiaDaSemana)].Hora[Hora[i].Hora].MatLog <> '') then
      BateHorario := true;
  end;
end;

procedure THorarios.MudaHorario(SemOri: integer; mat: string; Horario: RHorMat; SemDes: integer);
var dia, hora, i:integer;
begin

if SemOri > 0 then
for dia := 1 to 7 do
 for hora := 1 to 16 do
 begin
   if (Self.GradeSem[SemOri].Semana[dia].Hora[hora].Materia = mat) then
     Self.GradeSem[SemOri].Semana[dia].Hora[hora].Materia := ''
     else
     if (Self.GradeSem[SemOri].Semana[dia].Hora[hora].MatLog = mat) then
     begin
       self.ExcluiHorarioLogico(SemOri,dia,hora);
     end;
 end;

 if SemDes > 0 then
  for I:= Low(Horario) to High(Horario) do
    Self.GradeSem[SemDes].Semana[(Horario[i].DiaDaSemana)].Hora[Horario[i].Hora].Materia := mat;
end;

Procedure THorarios.GravaHorarioLogico(Sem: Integer; Semana: Integer; Hora: Integer; MatSim: String);
begin
  Self.GradeSem[Sem].Semana[Semana].Hora[Hora].MatLog := MatSim;
  Self.GradeSem[Sem].Semana[Semana].Hora[Hora].Simulacao := True
end;

Procedure THorarios.ExcluiHorarioLogico(Sem: Integer; Semana: Integer; Hora: Integer);
begin
  Self.GradeSem[sem].Semana[Semana].Hora[Hora].MatLog := '';
  if Self.GradeSem[sem].Semana[Semana].Hora[Hora].MatBD <> '' then
    Self.GradeSem[sem].Semana[Semana].Hora[Hora].Simulacao := True
  else
    Self.GradeSem[sem].Semana[Semana].Hora[Hora].Simulacao := false;
end;

procedure THorarios.LimpaGrade();
var i,j,k:integer;
begin
 for i:= 1 to (MaxSem) do
   for j:= 2 to 7 do
     for k:= 1 to 16 do
     begin
       Self.GradeSem[i].Semana[j].Hora[k].Materia := '';
       Self.GradeSem[i].Semana[j].Hora[k].MatLog := '';
       Self.GradeSem[i].Semana[j].Hora[k].MatBD := '';
       Self.GradeSem[i].Semana[j].Hora[k].Simulacao := false;
     end;
end;


procedure THorarios.DesfazGrade(sem: integer);
var semestre,dia,hora: integer;
begin

for semestre := sem to high(self.GradeSem) do
  for dia := 1 to 7 do
   for hora := 1 to 16 do
    if self.GradeSem[semestre].Semana[dia].Hora[hora].Materia <> '' then
     self.GradeSem[semestre].Semana[dia].Hora[hora].Materia := '';

  for semestre := sem to high(self.GradeSem) do
   for dia := 1 to 7 do
    for hora := 1 to 16 do
     if self.GradeSem[semestre].Semana[dia].Hora[hora].MatLog <> '' then
     begin
      self.ExcluiHorarioLogico(semestre,dia,hora);
     end;

end;

procedure THorarios.ExcluiHorarioNormal(mat: string);
var sem,dia,hora: integer;
begin
 for sem := 1 to high(self.GradeSem) do
  for dia := 1 to 7 do
   for hora := 1 to 16 do
    if self.GradeSem[sem].Semana[dia].Hora[hora].Materia = mat then
    begin
      self.GradeSem[sem].Semana[dia].Hora[hora].Materia:= '';
    end; 
end;

function THorarios.ConsultaTurma(mat: string): integer;
var sem,dia,hora: integer;
begin
Result:= 1;

 for sem := 1 to high(self.GradeSem) do
  for dia := 1 to 7 do
   for hora := 1 to 16 do
    if self.GradeSem[sem].Semana[dia].Hora[hora].Materia = mat then
    begin
      Result:= 1;  // normal
      exit;
    end;

  for sem := 1 to high(self.GradeSem) do
   for dia := 1 to 7 do
    for hora := 1 to 16 do
     if self.GradeSem[sem].Semana[dia].Hora[hora].MatLog = mat then
     begin
      Result:= 3; // simulada
      exit;
     end;
     
end;

// apenas utilizado quando a turma é simulada
function THorarios.RecuperaHorarioSimulado(var semestre: Integer; mat: string):RHorMat;
var sem,dia,hora: integer;
    Horas: RHorMat;
begin

 for sem := 1 to high(self.GradeSem) do
   for dia := 1 to 7 do
    for hora := 1 to 16 do
     if self.GradeSem[sem].Semana[dia].Hora[hora].MatLog = mat then
     begin
      SetLength(Horas,length(Horas)+1);
      Horas[length(Horas)-1].DiaDaSemana:= dia;;
      Horas[length(Horas)-1].Hora:= hora;
      semestre:= sem;
     end;

    Result:= Horas;

end;


end.


