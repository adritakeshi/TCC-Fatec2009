unit Feagri;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Horarios;

 {$REGION 'Constantes utilizadas pela classe TCatalogo'}

const MinCred : array[1..10] of integer = (1,0,26,0,56,0,103,0,154,0);
      // mínimo de créditos que é obrigado cursar até cada semestre para não jubilar

      Mensagens: array[1..16] of string =
      (
          'Não é possível mover matérias para a área de jubiladas',
          'Limite de matérias no semestre',
          'Semestre Consolidado',
          'Semestre Travado',
          'Semestre Trancado',
          'Semestre Errado',
          'Porcentagem de Créditos para cursar a matéria não foi atingida',
          'O pré-requisito desta matéria a impede de ser cursada',
          'Não é possível cursar o pré-requisito depois da matéria consecutiva ',
          'Bate horario',
          'Quantidade de Créditos insuficientes',
          'Seu limite de créditos do semestre acabou!',
          'Foi autorizado a cursar a matéria?',
          'Só é possível cursar a matéria eletiva depois que simular uma turma',
          'Não é possível mover uma matéria normal para eletiva',
          'Não é possível cursar uma matéria eletiva em outro semestre que não tenha turma'
      );
      // mesnsagens de erro ao tentar cursar a matéria em outro semestre
      
      TotElet = 24;  // total de créditos de eletivas que precisa cursar

      Cadastro = 1;
      Atualizacao = 2;
      Exclusao = 3;
      //operações com semestre


{$ENDREGION}

 {$REGION 'Tipos Definidos pelas Regras de Negócio da Feagri'}

 type

 RMateria = record
             codigo: integer;
             legenda: string;
             nome: string;
             credito: integer;
             sem: integer;
             turma: integer;  
             estado: integer;  // 1- cursado, 2- cursando, 3- a cursar
             desc: string;
             cp: integer;
             hora: RHorMat;
             alteracao: boolean;
            end;

 SemestreDoAluno = array of record
                             MateriaSemestre: array[1..15] of RMateria;
                             Consolidado: boolean;
                             Trancado: boolean;
                             Travado: boolean;
                             Credito: integer;
                             Operacao: integer;
                            end;

 CadeiaDePreRequisitos = array of integer;

 PreReqDaMateria = array[1..5] of integer;

{$ENDREGION}

 {$REGION 'Grafo de pre-requisitos'}

 // estrutura de um grafo de pré-requisitos para a movimentação das matérias
 // provocada por uma não aprovação da matéria ou um tranacamento

 type grafo =  ^bloco;
     bloco = record
              pred: integer;   {predecessor da materia}
              suc:  grafo;     {sucessores das matéria}
             end;

     ListaDePreRequisitos = array of record
                                      mat: RMateria;  {código da matéria}
                                      pre: integer;  {contador de pre-requisito}
                                      seq: grafo;
                                     end;

     lstord = ^bloco2;
     bloco2 = record
               mat: RMateria;
               suc:lstord;
              end;

 {$ENDREGION}
   
 {$REGION 'Estrutura da classe TPreReq'}

  TPreReq = class

   constructor Create(aluRA: string; ano: integer);

   private
    ano:integer;
    aluRA:string;
    PreRequisitos: CadeiaDePreRequisitos;

    procedure CarregaPreRequisito;
    function  TemPreRequisito(cod: integer): boolean;
    function  MateriaJaEstaNaLista(cod: Integer): boolean;
    function  MateriaJaEstaNoGrafo(cod: integer):boolean;
    procedure InsereNoGrafo(var g:grafo;c:integer);


    public
     PreReq: array of record
                       codigo: integer;
                       pre_req: PreReqDaMateria;
                      end;
     LstPreReq: ListaDePreRequisitos;
     LstOrdenada: LstOrd;

     function  PodeCursar(Feagri :SemestreDoAluno; Dispensa: array of RMateria; mat, sem:integer): boolean;
     function  PodeCursarPreRequisito(Feagri :SemestreDoAluno; mat: integer; sem: Integer):boolean;
     procedure DescobrirTodaCadeia(cod:integer);
     procedure DescobrirMateriasConsecutivas(cod:integer);
     procedure ConstroiGrafo(sem: integer; Aluno: SemestreDoAluno; Dispensada, Eletiva, Jubilada: array of RMateria);
     procedure DecPred(var d:grafo);
     procedure LstOrdAdd(mat: RMateria; var L:lstord);
     procedure LstOrdRemove(var lst:lstord);
     function  LstIndex(cont:integer; cod: integer):integer;
     procedure LimpaLista;
     function  ConsultarPreReq(codigo: integer): PreReqDaMateria;
     procedure AlocaMateria(mat: RMateria);
     procedure MontaCadeiaDeSucessores(Dispensada, Eletiva, Jubilada: array of RMateria; mat: RMateria);

   end;


 {$ENDREGION}

 {$REGION 'Estrutura da classe TCatalogo'}

  TCatalogo = class

  constructor Create(aluRA: string; aluAno: integer);

   private
    RA: string;
    ano: integer;
    TotalCredito: integer;
    Status: boolean;
    
    procedure CarregaStatusDoAluno;  
    procedure CarregaSemestre;
    procedure CarregaMateriasDoHistorico;
    procedure CarregaMateriasEletivas;
    procedure CarregaMateriasDispensadas;
    procedure CarregaMateriasJubiladas;
    procedure CarregaHorariosDaMateria;
    procedure AdicionaMateriaNaLista(Lista:integer; mat:  RMateria; sem: integer);
    procedure RemoveMateriaDaLista(Lista:integer; mat: RMateria; sem: integer);
   	procedure ApagaMateria(var mat: RMateria);
    procedure OrganizaMateriaDaLista(Lista, indice, sem: integer);
    procedure AdicionaSemestre(var Hora: THorarios);
    procedure RemoveSemestre(var Hora: THorarios);
    procedure MovimentaGrade(sem:integer; var Hora: THorarios; var Req: TPreReq);
    function  VerificaCoeficiente(mat:RMateria;sem:integer):boolean;
    function  VerificaJubilamento(sem:integer):boolean;
    function  CalculaTotalCredito:integer;
    function  SemestrePar(sem:integer): boolean;
    function  CalculaCreditoCursado(sem:integer):integer;
    function  ConsultaCreditoRegra(sem:integer): integer;
    function  MudaSemestre(Disciplina: RMateria; SemOri, SemDes: Integer; var Hora: THorarios; var Req: TPreReq): boolean; overload;
    procedure OrganizaSemestre(sem: integer);
    procedure DesfazCreditos(sem:integer);
    procedure DesfazSemestres(sem:integer);
    function  GetStatus: Boolean;

   public
    SemestreFeagri: SemestreDoAluno;
    Eletivas: array of RMateria;
    AproveitamentoDeEstudos: array of RMateria;
    SemestreJubilado: array of RMateria;

    function  ConsultaMateria(codigo :integer): RMateria; overload;
    function  ConsultaMateria(legenda: string): RMateria; overload;
    function  ConsultaSemestre(codigo: integer): integer; overload;
    function  ConsultaSemestre(legenda: string): integer; overload;
    function  TamSem(sem: array of RMateria; tipo:integer): integer;
    function  PosVetMat(leg:string; sem: array of RMateria; tipo:integer):integer;
    function  TornaNormal(var Hora: THorarios; legenda:string; Sem:integer):boolean;
    procedure TornaSimulada(legenda:string; SemOri,SemDes:integer);
    procedure TravaSemestre(sem:integer);
    procedure TrancaSemestre(sem:integer; var Hora: THorarios; var Req: TPreReq);
    procedure DestrancaSemestre(sem: integer; var Hora: THorarios);
    procedure ConsolidaSemestre(sem:integer; var Hora: THorarios; var Req: TPreReq);
    function  MudaSemestre(mat: string; SemOri, SemDes: Integer; var Hora: THorarios; Req: TPreReq): boolean; overload;
    function  ModificaSemestre(sem: integer): boolean;
    procedure SalvaCatalogo;
    procedure ResetCatalogo;
    function  SimulacaoEstaSalva: boolean;
    function  TemCredito(sem: Integer; cred: integer):boolean;
    function  TeveCreditosUltrapassados(sem: integer):boolean;
    property  Ativo: Boolean read GetStatus;

  end;

 {$ENDREGION}

 implementation

uses principal;

// construtor da classe Catalogo: carrega os objetos da clase

constructor TCatalogo.Create(aluRA: string; aluAno: Integer);
begin
  self.RA:= aluRa;
  self.ano:= aluAno;
  try
   self.CarregaStatusDoAluno;
   self.CarregaSemestre;
   self.CarregaMateriasDoHistorico;
   self.CarregaMateriasEletivas;
   self.CarregaMateriasDispensadas;
   self.CarregaMateriasJubiladas;
   self.CarregaHorariosDaMateria;
   TotalCredito:= self.CalculaTotalCredito;
  except
   Application.MessageBox('Erro ao carregar os dados' + #13 + 'Contate o administrador','Feagri',16);
   Application.Terminate;
  end;
end;

 {$REGION 'Métodos Privados de negócio da classe TCatalogo'}

procedure TCatalogo.CarregaStatusDoAluno;
var rs: _recordset;
begin
rs:= formprincipal.Feagri_Conector.Execute('select Status from Aluno where aluRA = '+quotedstr(self.RA));
self.Status:= StrToBool(rs.Fields[0].Value);
end;

// carrega os semestres do aluno e os seus status
procedure TCatalogo.CarregaSemestre;
var rs: _recordset;
begin
rs:= formprincipal.Feagri_Conector.Execute('select * from semestre where aluRA = '+quotedstr(self.RA));
SetLength(self.SemestreFeagri,rs.RecordCount);

while not rs.EOF do
begin
 with (self.SemestreFeagri[strtoint(rs.Fields[0].Value)-1]) do
 begin
  Consolidado:= StrToBool(rs.Fields[2].Value);
  Trancado:= StrToBool(rs.Fields[3].Value);
  Travado:= StrToBool(rs.Fields[4].Value);
  Operacao:= 0;
 end;
 rs.MoveNext;
end;

end;

// carrega as matérias do semestre do histórico do aluno
procedure TCatalogo.CarregaMateriasDoHistorico;
var rs: _recordset;
    sem: integer;
    mat: integer;
begin
rs:= formprincipal.Feagri_Conector.Execute('select semcur, cat_mat.cmcod, matcod, matnom,'
+ ' matcred, matsem, matdef, matcp, histcod from cat_mat_tur_hist, cat_mat'
+ ' where cat_mat.cmcod = cat_mat_tur_hist.cmcod and semcur >= '+inttostr(low(self.SemestreFeagri)+1)
+ ' and semcur <= '+inttostr(high(self.SemestreFeagri)+1)+' and aluRA = '+ quotedstr(self.RA) + ' order by semcur, matsem');

sem:=0;
mat:=1;

while not rs.EOF do
begin
 if (sem <> rs.Fields[0].Value) then
 begin
  sem:= rs.Fields[0].Value;
  mat:=1;
 end;
 with (self.SemestreFeagri[StrToInt(rs.Fields[0].Value)-1].MateriaSemestre[mat]) do
 begin
  codigo:= StrToInt(rs.Fields[1].Value);
  legenda:= rs.Fields[2].Value;
  nome:= rs.Fields[3].Value;
  credito:= StrToInt(rs.Fields[4].Value);
  sem:= StrToInt(rs.Fields[5].Value);
  desc:= rs.Fields[6].Value;
  cp:= StrToInt(rs.Fields[7].Value);
  estado:= StrToInt(rs.Fields[8].Value);
  alteracao:= false;
 end;
 self.SemestreFeagri[StrToInt(rs.Fields[0].Value)-1].Credito:=
  self.SemestreFeagri[StrToInt(rs.Fields[0].Value)-1].Credito + rs.Fields[4].Value;
 Inc(mat);
 rs.MoveNext;
end;

end;

// carrega as matérias eletivas do catálogo
procedure TCatalogo.CarregaMateriasEletivas;
var rs: _recordset;
  I: Integer;
begin
rs:= formprincipal.Feagri_Conector.Execute('select cat_mat.cmcod, matcod, matnom,'
+ ' matcred, matsem, matdef, matcp, histcod from cat_mat_tur_hist, cat_mat'
+ ' where cat_mat.cmcod = cat_mat_tur_hist.cmcod and semcur = 0 and aluRA = '
+ quotedstr(self.RA) + ' order by matcod');

SetLength(self.Eletivas,rs.RecordCount);

for I := Low(self.Eletivas) to High(self.Eletivas) do
begin
 with (self.Eletivas[I]) do
 begin
  codigo:= StrToInt(rs.Fields[0].Value);
  legenda:= rs.Fields[1].Value;
  nome:= rs.Fields[2].Value;
  credito:= StrToInt(rs.Fields[3].Value);
  sem:= StrToInt(rs.Fields[4].Value);
  desc:= rs.Fields[5].Value;
  cp:= StrToInt(rs.Fields[6].Value);
  estado:= StrToInt(rs.Fields[7].Value);
  alteracao:= false;
 end;
 rs.MoveNext;
end;

end;

// carrega as matérias dispensadas do aluno
procedure TCatalogo.CarregaMateriasDispensadas;
var rs: _recordset;
    I: integer;
begin
rs:= formprincipal.Feagri_Conector.Execute('select cat_mat.cmcod, matcod, matnom,'
+ ' matcred, matsem, matdef, matcp, histcod from cat_mat_tur_hist, cat_mat'
+ ' where cat_mat.cmcod = cat_mat_tur_hist.cmcod and semcur = -1 and aluRA = '+quotedstr(self.RA)
+ ' order by matcod');

SetLength(self.AproveitamentoDeEstudos,rs.RecordCount);

for I := Low(self.AproveitamentoDeEstudos) to High(self.AproveitamentoDeEstudos) do
begin
 with (self.AproveitamentoDeEstudos[I]) do
 begin
  codigo:= StrToInt(rs.Fields[0].Value);
  legenda:= rs.Fields[1].Value;
  nome:= rs.Fields[2].Value;
  credito:= StrToInt(rs.Fields[3].Value);
  sem:= StrToInt(rs.Fields[4].Value);
  desc:= rs.Fields[5].Value;
  cp:= StrToInt(rs.Fields[6].Value);
  estado:= StrToInt(rs.Fields[7].Value);
  alteracao:= false;
 end;
 rs.MoveNext;
end;

end;

// carrega as matérias que ultrapassaram o semestre limite do aluno
procedure TCatalogo.CarregaMateriasJubiladas;
var rs: _recordset;
    I: integer;
begin
rs:= formprincipal.Feagri_Conector.Execute('select cat_mat.cmcod, matcod, matnom,'
+ ' matcred, matsem, matdef, matcp, histcod from cat_mat_tur_hist, cat_mat'
+ ' where cat_mat.cmcod = cat_mat_tur_hist.cmcod and semcur = -2 and aluRA = '+ quotedstr(self.RA)
+ ' order by matcod');

SetLength(self.SemestreJubilado,rs.RecordCount);

for I := Low(self.SemestreJubilado) to High(self.SemestreJubilado) do
begin
 with (self.SemestreJubilado[I]) do
 begin
  codigo:= StrToInt(rs.Fields[0].Value);
  legenda:= rs.Fields[1].Value;
  nome:= rs.Fields[2].Value;
  credito:= StrToInt(rs.Fields[3].Value);
  sem:= StrToInt(rs.Fields[4].Value);
  desc:= rs.Fields[5].Value;
  cp:= StrToInt(rs.Fields[6].Value);
  estado:= StrToInt(rs.Fields[7].Value);
  alteracao:= false;
 end;
 rs.MoveNext;
end;

end;

// converte a hora em um índice
function GetHourOfDay(hora:string):integer;
begin
Result:= 1;
if hora = '07:00' then Result:= 1;
if hora = '08:00' then Result:= 2;
if hora = '09:00' then Result:= 3;
if hora = '10:00' then Result:= 4;
if hora = '11:00' then Result:= 5;
if hora = '14:00' then Result:= 7;
if hora = '15:00' then Result:= 8;
if hora = '16:00' then Result:= 9;
if hora = '17:00' then Result:= 10;
if hora = '18:00' then Result:= 11;
if hora = '19:00' then Result:= 13;
if hora = '20:00' then Result:= 14;
if hora = '21:00' then Result:= 15;
if hora = '22:00' then Result:= 16;
if hora = '23:00' then Result:= 17;
end;

// converte o dia da semana em um índice
function GetDayOfWeek(dia:string):integer;
begin
Result:= 1;
if dia = 'segunda' then Result:= 2;
if dia = 'terça'   then Result:= 3;
if dia = 'quarta'  then Result:= 4;
if dia = 'quinta'  then Result:= 5;
if dia = 'sexta'   then Result:= 6;
if dia = 'sábado'  then Result:= 7;
end;

// carrega os horários do catálogo da matéria
procedure TCatalogo.CarregaHorariosDaMateria;
var rs:_recordset;
    I,J:integer;
begin
rs:= formprincipal.Feagri_Conector.Execute('select Cat_Mat.CMCod, IniHor, DiaHor, Cat_Mat_Tur.CMTCod from cat_mat_tur, cat_mat_tur_hor, cat_mat '
+ ' where Cat_Mat_Tur_Hor.CMTCod = Cat_Mat_Tur.CMTCod and Cat_Mat.CMCod = Cat_Mat_Tur_Hor.CMCod and CatCod = '+IntToStr(self.ano) + ' and matsem <> 0 and TurCod = 1');
while not rs.EOF do
begin

 for I := low(SemestreFeagri) to high(SemestreFeagri) do
  for J := 1 to 15 do
   if self.SemestreFeagri[I].MateriaSemestre[J].codigo = rs.Fields[0].Value then
   begin
     self.SemestreFeagri[I].MateriaSemestre[J].turma := strtoint(rs.Fields[3].Value);
     SetLength(self.SemestreFeagri[I].MateriaSemestre[J].hora,high(self.SemestreFeagri[I].MateriaSemestre[J].hora)+2);
     self.SemestreFeagri[I].MateriaSemestre[J].hora[high(self.SemestreFeagri[I].MateriaSemestre[J].hora)].DiaDaSemana:= GetDayOfWeek(rs.fields[2].value);
     self.SemestreFeagri[I].MateriaSemestre[J].hora[high(self.SemestreFeagri[I].MateriaSemestre[J].hora)].Hora:= GetHourOfDay(rs.fields[1].value);
   end;

  for I := low(self.AproveitamentoDeEstudos) to high(self.AproveitamentoDeEstudos) do
   if self.AproveitamentoDeEstudos[I].codigo = rs.Fields[0].Value then
   begin
     self.AproveitamentoDeEstudos[I].turma := strtoint(rs.Fields[3].Value);
     SetLength(self.AproveitamentoDeEstudos[I].hora,high(self.AproveitamentoDeEstudos[I].hora)+2);
     self.AproveitamentoDeEstudos[I].hora[high(self.AproveitamentoDeEstudos[I].hora)].DiaDaSemana:= GetDayOfWeek(rs.fields[2].value);
     self.AproveitamentoDeEstudos[I].hora[high(self.AproveitamentoDeEstudos[I].hora)].Hora:= GetHourOfDay(rs.fields[1].value);
   end;

  for I := low(self.SemestreJubilado) to high(self.SemestreJubilado) do
   if self.SemestreJubilado[I].codigo = rs.Fields[0].Value then
   begin
     self.SemestreJubilado[I].turma := strtoint(rs.Fields[3].Value);
     SetLength(self.SemestreJubilado[I].hora,high(self.SemestreJubilado[I].hora)+2);
     self.SemestreJubilado[I].hora[high(self.SemestreJubilado[I].hora)].DiaDaSemana:= GetDayOfWeek(rs.fields[2].value);
     self.SemestreJubilado[I].hora[high(self.SemestreJubilado[I].hora)].Hora:= GetHourOfDay(rs.fields[1].value);
   end;

 rs.MoveNext;
end;

end;

// adiciona a matéria no objeto da classe correspondente a mudança do seu status 
procedure TCatalogo.AdicionaMateriaNaLista(Lista: integer; mat: RMateria; sem: Integer);
var I: Integer;
begin
case Lista of
 1:   //normal
 for I := 1 to 15 do
 begin
  if (self.SemestreFeagri[sem-1].MateriaSemestre[I].legenda = '') then
  begin
   mat.alteracao:= true;
   mat.estado:= 3;
   self.SemestreFeagri[sem - 1].MateriaSemestre[I]:= mat;
   self.SemestreFeagri[sem - 1].Credito:= self.SemestreFeagri[sem - 1].Credito + self.SemestreFeagri[sem - 1].MateriaSemestre[I].Credito;
   exit;
  end;
 end;

 2:   // eletiva
 begin
  SetLength(self.Eletivas,high(self.Eletivas)+2);
  mat.alteracao:= true;
  mat.estado:= 3;
  self.Eletivas[high(self.Eletivas)]:= mat;
  exit;
 end;

 3:   //dispensada
 begin
  SetLength(self.AproveitamentoDeEstudos,high(self.AproveitamentoDeEstudos)+2);
  mat.alteracao:= true;
  mat.estado:= 5;
  self.AproveitamentoDeEstudos[high(self.AproveitamentoDeEstudos)]:= mat;
  exit;
 end;

 4:    // jubilada
 begin
  SetLength(self.SemestreJubilado,high(self.SemestreJubilado)+2);
  mat.alteracao:= true;
  mat.estado:= 6;
  self.SemestreJubilado[high(self.SemestreJubilado)]:= mat;
  exit;
 end;

end;
end;

// remove os dados da matéria em um item da lista
procedure TCatalogo.ApagaMateria(var mat: RMateria);
begin
 mat.codigo:= 0;
 mat.legenda:= '';
 mat.nome:= '';
 mat.credito:= 0;
 mat.sem:= 0;
 mat.turma:= 0;
 mat.desc:= '';
 mat.cp:= 0;
 mat.hora:= nil;
end;

// remove a matéria do objeto da classe correspondente
procedure TCatalogo.RemoveMateriaDaLista(Lista:integer; mat: RMateria; sem: Integer);
var I,indice: Integer;
begin
indice:=0;
case Lista of
 1:   // normal
 begin
  for I := 1 to 15 do
  begin
   if (self.SemestreFeagri[sem-1].MateriaSemestre[I].legenda = mat.legenda) then
   begin
    self.SemestreFeagri[sem -1].Credito:= self.SemestreFeagri[sem - 1].Credito - self.SemestreFeagri[sem - 1].MateriaSemestre[I].Credito;
    self.ApagaMateria(self.SemestreFeagri[sem-1].MateriaSemestre[I]);
    indice:= I;
    break;
   end;
  end;
 end;

 2: // eletiva
 begin
   for I := low(self.Eletivas) to high(self.Eletivas) do
   begin
     if (self.Eletivas[I].legenda = mat.legenda) then
     begin
       self.ApagaMateria(self.Eletivas[I]);
       indice:= I;
       break;
     end;
   end;
 end;

 3:  //dispensada
 begin
   for I := low(self.AproveitamentoDeEstudos) to high(self.AproveitamentoDeEstudos) do
   begin
     if (self.AproveitamentoDeEstudos[I].legenda = mat.legenda) then
     begin
       self.ApagaMateria(self.AproveitamentoDeEstudos[I]);
       indice:= I;
       break;
     end;
   end;
  end;

 4:  //jubilada
 begin
   for I := low(self.SemestreJubilado) to high(self.SemestreJubilado) do
   begin
     if (self.SemestreJubilado[I].legenda = mat.legenda) then
     begin
       self.ApagaMateria(self.SemestreJubilado[I]);
       indice:= I;
       break;
     end;
   end;
 end;

end;
self.OrganizaMateriaDaLista(Lista,indice,sem);

end;

// organiza o objeto da classe para liberar o item que foi removido
procedure TCatalogo.OrganizaMateriaDaLista(Lista: Integer; indice: Integer; sem: Integer);
var I:integer;
begin
case Lista of
 1:    //normal
 begin
  for I := indice to 14 do
   self.SemestreFeagri[sem-1].MateriaSemestre[I]:= self.SemestreFeagri[sem-1].MateriaSemestre[I+1];
  self.ApagaMateria(self.SemestreFeagri[sem-1].MateriaSemestre[15]);
  exit;
 end;

 2:  //eletiva
 begin
  for I := indice to high(self.Eletivas) - 1 do
   self.Eletivas[I]:= self.Eletivas[I+1];
  self.ApagaMateria(self.Eletivas[high(self.Eletivas)]);
  SetLength(self.Eletivas,high(self.Eletivas));
  exit;
 end;

 3:   //dispensada
 begin
  for I := indice to high(self.AproveitamentoDeEstudos) - 1 do
   self.AproveitamentoDeEstudos[I]:= self.AproveitamentoDeEstudos[I+1];
  self.ApagaMateria(self.AproveitamentoDeEstudos[high(self.AproveitamentoDeEstudos)]);
  SetLength(self.AproveitamentoDeEstudos,high(self.AproveitamentoDeEstudos));
  exit;
 end;

 4: //jubilada
 begin
  for I := indice to high(self.SemestreJubilado) - 1 do
   self.SemestreJubilado[I]:= self.SemestreJubilado[I+1];
  self.ApagaMateria(self.SemestreJubilado[high(self.SemestreJubilado)]);
  SetLength(self.SemestreJubilado,high(self.SemestreJubilado));
  exit;
 end;

end;
end;

// organiza o objeto SemestreFeagri em ordem crescente de semestre
procedure TCatalogo.OrganizaSemestre(sem: integer);
var I,J,Tam:Integer;
    Materia: RMateria;
begin
 Tam:= 1;
 while self.SemestreFeagri[sem - 1].MateriaSemestre[Tam].legenda <> '' do inc(Tam);
 dec(Tam);

 for I := 1 to Tam - 1 do
  for J :=  I+1 to Tam do
  begin
   if self.SemestreFeagri[sem - 1].MateriaSemestre[I].sem > self.SemestreFeagri[sem - 1].MateriaSemestre[J].sem then
   begin
     Materia:= self.SemestreFeagri[sem - 1].MateriaSemestre[I];
     self.SemestreFeagri[sem - 1].MateriaSemestre[I]:= self.SemestreFeagri[sem - 1].MateriaSemestre[J];
     self.SemestreFeagri[sem - 1].MateriaSemestre[J]:= Materia;
   end;
  end;
  
end;

// adiciona um item do objeto SemestreFeagri para armazenar os dados de mais
// um semestre que foi atribuido por ter trancado um semestre
procedure TCatalogo.AdicionaSemestre(var Hora: THorarios);
begin
  SetLength(self.SemestreFeagri, high(self.SemestreFeagri)+2);
  SetLength(Hora.GradeSem, high(self.SemestreFeagri)+2);
  self.SemestreFeagri[high(self.SemestreFeagri)].Operacao:= Cadastro;
end;

// remove o último item do objeto SemestreFeagri
// por ter destrancado o semestre
procedure TCatalogo.RemoveSemestre(var Hora: THorarios);
begin
  SetLength(self.SemestreFeagri, high(self.SemestreFeagri));
  SetLength(Hora.GradeSem, high(Hora.GradeSem));
end;

// verifica se o semestre é par
function TCatalogo.SemestrePar(sem: Integer):boolean;
begin
 Result:= (sem mod 2 = 0);
end;

// verifica se foi jubilado em um semestre por causa da quantidade de
// créditos cursados definidos pela regra da Feagri
function TCatalogo.VerificaJubilamento(sem: Integer): boolean;
var I,SemTrancado:Integer;
begin
 SemTrancado:= 0;
 for I := low(self.SemestreFeagri) to sem - 1 do
  if self.SemestreFeagri[I].Trancado = True then
   Inc(SemTrancado);
 Result:= (self.CalculaCreditoCursado(sem) < MinCred[sem - SemTrancado]);
end;

// calcula crédito total para a conclusão do curso
function TCatalogo.CalculaTotalCredito:integer;
var I,J,Cred:integer;
begin
 Cred:= TotElet;

  for I := low(self.SemestreFeagri) to high(self.SemestreFeagri) do
   for J := 1 to 15 do
    if (self.SemestreFeagri[I].MateriaSemestre[J].legenda <> '') and (SemestreFeagri[I].MateriaSemestre[J].sem in [1..10]) then
     Cred:= Cred + SemestreFeagri[I].MateriaSemestre[J].credito;

  for I := low(self.AproveitamentoDeEstudos) to high(self.AproveitamentoDeEstudos) do
    if AproveitamentoDeEstudos[I].sem in [1..10] then

     Cred:= Cred + self.AproveitamentoDeEstudos[I].credito;

   for I := low(self.SemestreJubilado) to high(self.SemestreJubilado) do
    if self.SemestreJubilado[I].sem in [1..10] then
     Cred:= Cred + self.SemestreJubilado[I].credito;

 Result:= Cred;
end;

// calcula o crédito que é atribuido em um semestre
function TCatalogo.ConsultaCreditoRegra(sem:integer): integer;
var I,SemTrancado,SemLetivo:Integer;
begin
 SemTrancado:= 0;
 for I := low(self.SemestreFeagri) to sem - 1 do
  if self.SemestreFeagri[I].Trancado = True then
   Inc(SemTrancado);
 SemLetivo:= sem - SemTrancado;
 Result:= 30 + ((SemLetivo - 1)*48);
end;

// verifica se uma matéria obteve seu coeficiente de créditos para ser cursada
function TCatalogo.VerificaCoeficiente(mat: RMateria; sem: Integer):boolean;
var Cred:integer;
    Porcentagem: real;
begin
 Porcentagem:= (self.CalculaCreditoCursado(sem) / self.TotalCredito)*100;
 Result:= (Porcentagem >= mat.cp);
end;

// calcula a quantidade de créditos cursados até um semestre
function TCatalogo.CalculaCreditoCursado(sem:integer):integer;
var I,TotCred:integer;
begin
 TotCred:= 0;
 for I := 0 to sem - 1 do
  TotCred:= TotCred + self.SemestreFeagri[I].Credito;
 Result:= TotCred;
end;

// verifica se tem créditos suficientes para cursar a matéria em um semestre
function TCatalogo.TemCredito(sem: Integer; cred: integer):boolean;
var I,TotCred:integer;
begin
TotCred:= 0;
for I := low(self.SemestreFeagri) to sem - 1 do
begin
 if Self.CalculaCreditoCursado(I+1) > self.ConsultaCreditoRegra(i+1) then
  TotCred:= self.ConsultaCreditoRegra(i+1)
  else
   TotCred:= TotCred + self.SemestreFeagri[I].Credito;
end;
 TotCred:= self.ConsultaCreditoRegra(sem) - TotCred;
 Result:= (TotCred >= cred);
end;

// zera os créditos do aluno para refazer a grade
procedure TCatalogo.DesfazCreditos(sem:integer);
var i: integer;
begin
 for I := sem - 1 to high(self.SemestreFeagri) do
  self.SemestreFeagri[I].Credito:= 0;
end;

//  verifica se um matéria pode ser alocada para um semestre
function TCatalogo.MudaSemestre(Disciplina: RMateria; SemOri, SemDes: Integer; var Hora: THorarios; var Req: TPreReq):boolean;
var erro:boolean;
    ListaDes: integer;
begin

 erro:= false;

 case SemDes of
 -2: ListaDes:= 4;
  0: ListaDes:= 2;
  else ListaDes:= 1;
 end;

 if Disciplina.sem = 0 then ListaDes:= 2;

 if (ListaDes = 1) then
 begin

 // verifica as regras de negócio da Feagri para alocar a matéria
  erro:= (self.SemestreFeagri[SemDes - 1].Trancado = True) or
         (self.SemestrePar(Disciplina.sem) <> self.SemestrePar(SemDes)) or
         (not self.TemCredito(SemDes,Disciplina.credito)) or
         (not self.VerificaCoeficiente(Disciplina,SemDes)) or
         (self.SemestreFeagri[SemDes - 1].MateriaSemestre[15].legenda <> '')
         or (Hora.BateHorario(SemDes,Disciplina.hora));

  //Regra: se o semestre estiver travado, para a movimentação é destravado o semstre
  if not erro then
   if (self.SemestreFeagri[SemDes - 1].Travado) then self.SemestreFeagri[SemDes - 1].Travado:= false;

 end;

 if erro then Result:= false
 else begin
  self.AdicionaMateriaNaLista(ListaDes,Disciplina,SemDes);
  Hora.MudaHorario(0,Disciplina.legenda,Disciplina.hora,SemDes);
  Result:= true;
 end;

end;

// zera os semestres depois do consolidado para refazer a grade
procedure TCatalogo.DesfazSemestres(sem:integer);
var I,J:integer;
begin
 for I := sem - 1 to high(self.SemestreFeagri) do
  for J := 1 to 15 do
   self.ApagaMateria(self.SemestreFeagri[I].MateriaSemestre[J]); 
end;

// movimenta a grade do aluno depois de um fechamento de semestre
procedure TCatalogo.MovimentaGrade(sem:integer; var Hora: THorarios; var Req: TPreReq);
var I,J,K, SemOrigem, SemDestino, SemestreSimulado, Lista:integer;
    Lst: lstord;
    RHora: RHorMat;
    SimulacaoBkp: array of record
                   Horario: RHorMat;
                   mat:string;
                   sem:integer;
                  end;
begin

 // se não houver matérias no semestre não realiza a movimentação
 if self.SemestreFeagri[sem -1].MateriaSemestre[1].legenda = '' then exit;

 i:=1;
 while self.SemestreFeagri[sem - 1].MateriaSemestre[i].legenda <> '' do
  inc(i);
 dec(i);

 j:=1;
 while (i >= j) and (self.SemestreFeagri[sem - 1].MateriaSemestre[j].estado = 1) do
  inc(j);
 dec(j);

  // se todas as matérias do semestre foram aprovadas não realiza a movimentação
  if i = j then exit;

 Req.LstPreReq:= nil;  // apaga o grafo

 // faz backup das turmas simuladas
 for I := sem to high(self.SemestreFeagri) do
  for J := 1 to 15 do
  begin
   if (self.SemestreFeagri[I].MateriaSemestre[J].legenda <> '') then
     if Hora.ConsultaTurma(self.SemestreFeagri[I].MateriaSemestre[J].legenda) = 3 then
     begin
       SetLength(SimulacaoBkp,length(SimulacaoBkp)+1);
       SimulacaoBkp[length(SimulacaoBkp)-1].mat:= self.SemestreFeagri[I].MateriaSemestre[J].legenda;
       SimulacaoBkp[length(SimulacaoBkp)-1].Horario:= Hora.RecuperaHorarioSimulado(SimulacaoBkp[length(SimulacaoBkp)-1].sem,self.SemestreFeagri[I].MateriaSemestre[J].legenda);
     end;
  end;


 // constrói o grafo com as matérias não aprovadas e dos próximos semestres
 Req.ConstroiGrafo(sem,self.SemestreFeagri,self.AproveitamentoDeEstudos,self.Eletivas,self.SemestreJubilado);

 i:=1;

 // remove as matérias reprovadas do semestre
 while self.SemestreFeagri[sem -1].MateriaSemestre[i].legenda <> '' do
 begin
  if self.SemestreFeagri[sem -1].MateriaSemestre[i].estado = 3 then
  begin
   if Hora.ConsultaTurma(self.SemestreFeagri[sem -1].MateriaSemestre[i].legenda) = 1 then
    Hora.ExcluiHorarioNormal(self.SemestreFeagri[sem -1].MateriaSemestre[i].legenda)
    else
    begin
     RHora:= Hora.RecuperaHorarioSimulado(SemOrigem,self.SemestreFeagri[sem -1].MateriaSemestre[i].legenda);
     for J := low(RHora) to high(RHora) do
       Hora.ExcluiHorarioLogico(sem,RHora[J].DiaDaSemana,RHora[J].Hora);
    end;
    self.RemoveMateriaDaLista(1,self.SemestreFeagri[sem -1].MateriaSemestre[i],sem);
   end
   else inc(i);
 end;

  {desfaz a grade, créditos e semestres para remontar com as alterações provocadas
  pelas reprovações de matérias que tenham formam cadeias de pré-requisitos}
 Hora.DesfazGrade(sem + 1);
 self.DesfazCreditos(sem + 1);
 self.DesfazSemestres(sem + 1);
 
 SemDestino:= sem + 1;  // adiciona um semestre para iniciar a remontagem da grade

 // enquanto o semestre não for o limite movimenta o grafo
  while (SemDestino < high(self.SemestreFeagri) + 2) do
  begin

  // para cada matéria sucessora
   for I := low(Req.LstPreReq) to high(Req.LstPreReq) do
   begin
   if (Req.LstPreReq[I].pre = 0) then // verifica se já foram liberados os pré-requisitos
     Req.LstOrdAdd(Req.LstPreReq[I].mat, Req.LstOrdenada);  // adiciona na lista ordenada
   end;

   Lst:= Req.LstOrdenada; 

   while (Lst <> nil) do
   begin
   
    // tenta cursar a matéria da lista no semestre corrente
     if (self.MudaSemestre(Lst^.mat, 1, SemDestino, Hora, Req)) then
     begin
      Dec(Req.LstPreReq[Req.LstIndex(0,Lst^.mat.codigo)].pre); // decrementa um predecessor para cada matéria consecutiva
      Req.DecPred(Req.LstPreReq[Req.LstIndex(0,Lst^.mat.codigo)].seq);
     end;
  
    Lst:= Lst^.suc;

   end;

  Inc(SemDestino);
  Req.LimpaLista;  // apaga a lista ordenada

 end;

 for I := low(Req.LstPreReq) to high(Req.LstPreReq) do
 begin
  if (Req.LstPreReq[I].pre <> -1) then
  // se a matéria não foi alocada em algum semestre, aloca para jubilada
    self.MudaSemestre(Req.LstPreReq[I].mat, 1, -2,Hora,Req);
 end;

 // tenta recuperar as simulações
 for I := low(SimulacaoBkp) to high(SimulacaoBkp) do
  if (not Hora.BateHorario(SimulacaoBkp[I].sem,SimulacaoBkp[I].Horario))
   and (Req.PodeCursar(self.SemestreFeagri,self.AproveitamentoDeEstudos,ConsultaMateria(SimulacaoBkp[I].mat).codigo,SimulacaoBkp[I].sem))
   and (Req.PodeCursarPreRequisito(self.SemestreFeagri,ConsultaMateria(SimulacaoBkp[I].mat).codigo,SimulacaoBkp[I].sem))
   and (self.SemestreFeagri[SimulacaoBkp[I].sem - 1].MateriaSemestre[15].legenda = '') THEN begin
   
    SemOrigem:= self.ConsultaSemestre(SimulacaoBkp[I].mat);

     case SemOrigem of
      -2: Lista:= 4;
      0: Lista:= 2;
      else Lista:= 1;
     end;

    self.AdicionaMateriaNaLista(1,self.ConsultaMateria(SimulacaoBkp[I].mat),SimulacaoBkp[I].sem);
    self.RemoveMateriaDaLista(Lista,self.ConsultaMateria(SimulacaoBkp[I].mat),SemOrigem);
    Hora.MudaHorario(SemOrigem,SimulacaoBkp[I].mat,nil,SimulacaoBkp[I].sem);

    for K := low(SimulacaoBkp[I].Horario) to high(SimulacaoBkp[I].Horario) do
     Hora.GravaHorarioLogico(SimulacaoBkp[I].sem,SimulacaoBkp[I].Horario[K].DiaDaSemana,SimulacaoBkp[I].Horario[K].Hora,SimulacaoBkp[I].mat);

  end;

 for I := sem to high(self.SemestreFeagri) do
   self.OrganizaSemestre(I+1);  //organiza as matérias pelo semestre

 Req.LstPreReq:= nil;

end;

 {$ENDREGION}

 {$REGION 'Métodos Públicos utilizados pelo módulo "Simulação Feagri"'}

function TCatalogo.GetStatus: Boolean;
begin
Result:= self.Status;
end;

// procura o índice da matéria no objeto especificado pelo tipo
function TCatalogo.PosVetMat(leg:string; sem: array of RMateria; tipo:integer):integer;
var pos: integer;
begin
  pos:= low(sem);
  while sem[pos].legenda <> leg do inc(pos);

  if tipo >= 1 then Result := pos+1
  else Result := pos;
end;

// descobre o número de matérias de um semestre
function TCatalogo.TamSem(sem: array of RMateria; tipo:integer): integer;
var i:integer;
begin
  if tipo >= 1 then
  begin
      i := 0;
      if sem[i].legenda = '' then
          Result := 0
      else begin
          while (sem[i].legenda <> '') and (i < 15) do
            inc(i);
          Result := i;
      end;
  end else Result := length(sem);
end;
 
// consulta os dados da matéria através do seu código
function TCatalogo.ConsultaMateria(codigo : Integer): RMateria;
var I,J:integer;
begin
 for I := low(self.SemestreFeagri) to high(self.SemestreFeagri) do
  for J := 1 to 15 do
  if self.SemestreFeagri[I].MateriaSemestre[J].codigo = codigo then
  begin
   Result:= self.SemestreFeagri[I].MateriaSemestre[J];
   exit;
  end;

  for I := low(self.Eletivas) to high(self.Eletivas) do
  if (self.Eletivas[I].codigo = codigo) then
   begin
    Result:= self.Eletivas[I];
    exit;
   end;

   for I := low(self.AproveitamentoDeEstudos) to high(self.AproveitamentoDeEstudos) do
    if (self.AproveitamentoDeEstudos[I].codigo = codigo) then
    begin
     Result:= self.AproveitamentoDeEstudos[I];
     exit;
    end;

   for I := low(self.SemestreJubilado) to high(self.SemestreJubilado) do
    if (self.SemestreJubilado[I].codigo = codigo) then
    begin
     Result:= self.SemestreJubilado[I];
     exit;
    end;

end;

// consulta os dados da matéria através da sua legenda
function TCatalogo.ConsultaMateria(legenda : string): RMateria;
var I,J:integer;
begin
 for I := low(self.SemestreFeagri) to high(self.SemestreFeagri) do
  for J := 1 to 15 do
  if self.SemestreFeagri[I].MateriaSemestre[J].legenda = legenda then
  begin
   Result:= self.SemestreFeagri[I].MateriaSemestre[J];
   exit;
  end;

  for I := low(self.Eletivas) to high(self.Eletivas) do
  if (self.Eletivas[I].legenda = legenda) then
   begin
    Result:= self.Eletivas[I];
    exit;
   end;

   for I := low(self.AproveitamentoDeEstudos) to high(self.AproveitamentoDeEstudos) do
    if (self.AproveitamentoDeEstudos[I].legenda = legenda) then
    begin
     Result:= self.AproveitamentoDeEstudos[I];
     exit;
    end;

   for I := low(self.SemestreJubilado) to high(self.SemestreJubilado) do
    if (self.SemestreJubilado[I].legenda = legenda) then
    begin
     Result:= self.SemestreJubilado[I];
     exit;
    end;

end;

// consulta o semestre de uma matéria através da sua legenda
function TCatalogo.ConsultaSemestre(legenda: string): integer;
var i,j:integer;
begin
Result:= 0;

 for i:= low(self.SemestreFeagri) to high(self.SemestreFeagri) do
  for j:= 1 to 15 do
  begin
   if self.SemestreFeagri[i].MateriaSemestre[j].legenda = legenda then
   begin
     Result:= i + 1;
     exit;
   end;
  end;

  for I := low(self.Eletivas) to high(self.Eletivas) do
  if (self.Eletivas[I].legenda = legenda) then
   begin
    Result:= 0;
    exit;
   end;

  for I := low(self.AproveitamentoDeEstudos) to high(self.AproveitamentoDeEstudos) do
  if (self.AproveitamentoDeEstudos[I].legenda = legenda) then
  begin
    Result:= -1;
    exit;
  end;

  for I := low(self.SemestreJubilado) to high(self.SemestreJubilado) do
  if (self.SemestreJubilado[I].legenda = legenda) then
  begin
   Result:= -2;
   exit;
  end;

end;

// consulta o semestre de uma matéria através do seu código
function TCatalogo.ConsultaSemestre(codigo: integer): integer;
var i,j:integer;
begin
Result:= 0;

 for i:= low(self.SemestreFeagri) to high(self.SemestreFeagri) do
  for j:= 1 to 15 do
  begin
   if self.SemestreFeagri[i].MateriaSemestre[j].codigo = codigo then
   begin
     Result:= i + 1;
     exit;
   end;
  end;

   for I := low(self.Eletivas) to high(self.Eletivas) do
  if (self.Eletivas[I].codigo = codigo) then
   begin
    Result:= 0;
    exit;
   end;

   for I := low(self.AproveitamentoDeEstudos) to high(self.AproveitamentoDeEstudos) do
    if (self.AproveitamentoDeEstudos[I].codigo = codigo) then
    begin
     Result:= -1;
     exit;
    end;

   for I := low(self.SemestreJubilado) to high(self.SemestreJubilado) do
    if (self.SemestreJubilado[I].codigo = codigo) then
    begin
     Result:= -2;
     exit;
    end;

end;

// verifica se o semestre está fechado
function TCatalogo.ModificaSemestre(sem: Integer):boolean;
begin
 Result:= not ((self.SemestreFeagri[sem - 1].Consolidado) or (self.SemestreFeagri[sem - 1].Trancado) or (self.SemestreFeagri[sem - 1].Travado));
end;

// verifica se burlou o limite de créditos de um semestre
function TCatalogo.TeveCreditosUltrapassados(sem: integer):boolean;
begin
Result:= false;
if Self.CalculaCreditoCursado(sem) > self.ConsultaCreditoRegra(sem) then
 Result:= true;
end;

// verifica se uma matéria pode ser mudada de semestre ou de status
// esta verificação é feita na movimentação das matérias dentro das 4 regiões
function TCatalogo.MudaSemestre(mat: string; SemOri, SemDes: Integer; var Hora: THorarios; Req: TPreReq): boolean;
var mensagem:string;
    erro:boolean;
    ListaOri,ListaDes,cont: integer;
    Disciplina: RMateria;
begin

 erro:= false;
 cont:=0;
 mensagem:= 'Não é possível cursar a matéria '+mat+ ' no '+ inttostr(SemDes)
 + 'º semestre pelo(s) motivo(s) abaixo:' + #13;

Disciplina:= self.ConsultaMateria(mat); // consulta os dados da matéria

case SemOri of
 -2: ListaOri:= 4;   // jublilada
 -1: ListaOri:= 3;   // dispensada
  0: ListaOri:= 2;   // eletiva
 else ListaOri:= 1;  // normal
end;

 case SemDes of
 -2: ListaDes:= 4;  // jublilada
 -1: ListaDes:= 3;  // dispensada
  0: ListaDes:= 2;  // eletiva
  else ListaDes:= 1;  // normal
 end;

 // se mover alguma matéria para jubilada notifica com uma mensagem de erro
 if SemDes = -2 then
 begin
  erro:= true;
  mensagem:= Mensagens[1];
 end;

 // apenas dentro da área de semestres é feita a validação de regra de negócio

 if SemDes > 0 then
 begin

 // só permite cursar 15 matérias por semestre

  if self.SemestreFeagri[SemDes-1].MateriaSemestre[15].legenda <> '' then
  begin
   inc(cont);
   mensagem:= mensagem + #13 + inttostr(cont) + 'º - '+ Mensagens[2];
   erro:= true;
  end;

  // não permite cursar matéria em semestre consolidado

  if (self.SemestreFeagri[SemDes - 1].Consolidado) then
  begin
  inc(cont);
   mensagem:= mensagem + #13 + inttostr(cont) + 'º - '+Mensagens[3];
   erro:= true;
  end;

   // não permite cursar matéria em semestre travado

  if (self.SemestreFeagri[SemDes - 1].Travado) then
  begin
  inc(cont);
   mensagem:= mensagem + #13 + inttostr(cont) + 'º - '+Mensagens[4];
   erro:= true;
  end;

    // não permite cursar matéria em semestre trancado

  if (self.SemestreFeagri[SemDes - 1].Trancado) then
  begin
  inc(cont);
   mensagem:= mensagem + #13 + inttostr(cont) + 'º - '+Mensagens[5];
   erro:= true;
  end;

  // não permite cursar a matéria em outro semestre do ano
  
   if (self.SemestrePar(Disciplina.sem) <> self.SemestrePar(SemDes)) then
   begin
   inc(cont);
    mensagem:= mensagem + #13 + inttostr(cont) + 'º - '+Mensagens[6];
    erro:= true;
   end;

   // verifica se atingiu o coeficiente de créditos para cursar

   if (not self.VerificaCoeficiente(Disciplina,SemDes)) then
   begin
   inc(cont);
    mensagem:= mensagem + #13 + inttostr(cont) + 'º - '+Mensagens[7];
    erro:= true;
   end;

   // verifica se os pré-requisitos estão nos semestres anteriores para permitir cursar
    
   if (not Req.PodeCursar(self.SemestreFeagri, self.AproveitamentoDeEstudos, Disciplina.codigo, SemDes)) then
   begin
   inc(cont);
    mensagem:= mensagem + #13 + inttostr(cont) + 'º - '+Mensagens[8];
    erro:= true;
   end;

   // verifica se as matérias consecutivas estão em semestres posteriores pára cursar

   if (not Req.PodeCursarPreRequisito(self.SemestreFeagri, Disciplina.codigo, SemDes)) then
   begin
   inc(cont);
    mensagem:= mensagem + #13 + inttostr(cont) + 'º - '+Mensagens[9];
    erro:= true;
   end;

   // verifica se não bate horário

   if (Hora.BateHorario(SemDes,Disciplina.hora)) then
   begin
   inc(cont);
    mensagem:= mensagem + #13 + inttostr(cont) + 'º - '+Mensagens[10];
    erro:= true;
   end;

   // verifica se tem créditos no semestre para cursar
   // se não pergunta se foi autorizado a burlar a regra.

   if (not erro) and (not self.TemCredito(SemDes,Disciplina.credito)) then
   begin
    mensagem:= mensagem + #13 + inttostr(cont) + 'º - '+Mensagens[11];
    if MessageDlg(Mensagens[12] + #13 + Mensagens[13], mtInformation, [mbYes, mbNo], 0) = idNo then
      erro:= true;
   end;

 end;

 // não permite cursar uma matéria eletiva sem simular turma

 if (SemOri = 0) and (ListaDes = 1) then
 begin
  erro:= true;
  mensagem:=  Mensagens[14];
 end;

 // não permite mover uma matéria normal para eletiva

 if (Disciplina.sem <> 0) and (ListaDes = 2) then
 begin
  erro:= true;
  mensagem:= Mensagens[15];
 end;

 // não permite mover matéria eletiva para outro semestre que não tenha turma simulada
 // para ela

 if (Disciplina.sem = 0) and (ListaOri = 1) and (ListaDes = 1) then
 begin
   erro:= true;
   mensagem:= Mensagens[16];
 end;

 // se houver algum erro, emite para o usuário,
 // senão muda o semestre, os status e o horário
 if (erro) then
 begin
  MessageDlg(mensagem, mtWarning, [mbOk], 0);
  Result:= False;
 end
 else
 begin
   self.RemoveMateriaDaLista(ListaOri,Disciplina,SemOri);
   self.AdicionaMateriaNaLista(ListaDes,Disciplina,SemDes);
   Hora.MudaHorario(SemOri,Disciplina.legenda,Disciplina.hora,SemDes);
   Result:= True;
 end;

end;

// consolida um semestre e movimenta a grade a partir das matérias não aprovadas
procedure TCatalogo.ConsolidaSemestre(sem: integer; var Hora: THorarios; var Req: TPreReq);
var I,SemTrancado:Integer;
begin
 self.SemestreFeagri[sem - 1].Consolidado:= True;

 if self.SemestreFeagri[sem-1].Operacao <> Cadastro then
  self.SemestreFeagri[sem - 1].Operacao:= Atualizacao;

 self.MovimentaGrade(sem,Hora,Req);

 SemTrancado:= 0;

 for I := low(self.SemestreFeagri) to sem - 1 do
  if self.SemestreFeagri[I].Trancado = True then
   Inc(SemTrancado);

 if self.VerificaJubilamento(sem) then
 begin
  MessageDlg('Não é possível terminar o curso pelo motivo abaixo:' + #13 + #13
  + 'Créditos cursados: ' + inttostr(self.CalculaCreditoCursado(sem)) + #13
  + 'Créditos necessários para evitar jubilamento: '+ inttostr(MinCred[sem - SemTrancado]) + #13
  + 'Para reiniciar simulação, pressione [Ctrl+R]', mtWarning, [mbOk], 0);
  self.Status:= False;
 end;

end;

// tranca um semestre e movimenta a grade a partir das matérias do semestre
procedure TCatalogo.TrancaSemestre(sem: integer; var Hora: THorarios; var Req: TPreReq);
begin
 self.SemestreFeagri[sem - 1].Trancado:= True;
 if self.SemestreFeagri[sem-1].Operacao <> Cadastro then
  self.SemestreFeagri[sem - 1].Operacao:= Atualizacao;
 self.AdicionaSemestre(Hora);
 self.MovimentaGrade(sem,Hora,Req);
end;

// destranca um semstre e move as matérias do úlitmo semestre para jubiladas
procedure TCatalogo.DestrancaSemestre(sem: Integer; var Hora: THorarios);
var
  I: Integer;
  Req: TPreReq;
begin
 for I := 1 to 15 do
 if self.SemestreFeagri[high(self.SemestreFeagri)].MateriaSemestre[I].legenda <> '' then
 begin
  self.MudaSemestre(self.SemestreFeagri[high(self.SemestreFeagri)].MateriaSemestre[I],high(self.SemestreFeagri)+1,-2,Hora,Req)
 end;
 self.SemestreFeagri[sem - 1].Trancado:= False;
 if self.SemestreFeagri[sem-1].Operacao <> Cadastro then
  self.SemestreFeagri[sem - 1].Operacao:= Atualizacao;
 self.RemoveSemestre(Hora);
end;

// trava ou destrava um semestre
procedure TCatalogo.TravaSemestre(sem: integer);
begin
 self.SemestreFeagri[sem - 1].Travado:= not self.SemestreFeagri[sem - 1].Travado;
 self.SemestreFeagri[sem - 1].Operacao:= Atualizacao;
end;

// torna a matéria simulada e muda de semestre
procedure TCatalogo.TornaSimulada(legenda:string; SemOri,SemDes:integer);
var ListaOri:Integer;
    Disciplina: RMateria;
begin

 Disciplina:= self.ConsultaMateria(legenda);

 case SemOri of
  -2: ListaOri:= 4;
  -1: ListaOri:= 3;
  0: ListaOri:= 2;
  else ListaOri:= 1;
 end;

 self.AdicionaMateriaNaLista(1, Disciplina, SemDes);;
 self.RemoveMateriaDaLista(ListaOri, Disciplina, SemOri);
 
end;

// verifica se a matéria pode tornar normal. Se possível muda seu status
function TCatalogo.TornaNormal(var Hora: THorarios; legenda:string; Sem:integer):boolean;
var Disciplina: RMateria;
    Horario: RHorMat;
    i: integer;
begin

Disciplina:= self.ConsultaMateria(legenda);

 if (Disciplina.sem = 0) then
 begin
   MessageDlg('Não é possível tornar normal a matéria eletiva', mtWarning, [mbOk], 0);
   Result:= False;
 end
 else
 if (self.SemestrePar(Disciplina.sem) <> self.SemestrePar(Sem)) then
 begin
   MessageDlg('Não é possível tornar normal a matéria ' + legenda + #13 + 'Está fora de semestre', mtWarning, [mbOk], 0);
   Result:= False;
 end
 else
  if (Hora.BateHorario(Sem, Disciplina.hora)) then
  begin
   MessageDlg('Não é possível tornar normal a matéria ' + legenda + #13 + 'Bate horário', mtWarning, [mbOk], 0);
   Result:= False;
  end
  else
  begin
    Horario:= Hora.RecuperaHorarioSimulado(i,legenda);
    for i := low(Horario) to high(Horario) do
     Hora.ExcluiHorarioLogico(Sem,Horario[i].DiaDaSemana,Horario[i].Hora);
    Hora.MudaHorario(Sem,legenda,Disciplina.hora,Sem);
    Result:= True;
  end;

end;

// salva as alterações feitas com a simulação
procedure TCatalogo.SalvaCatalogo;
var I,J:integer;
    rs: _recordset;
begin
try

  rs:= formprincipal.Feagri_Conector.Execute('update Aluno set Status = '
    +BoolToStr(self.Status)+ ' where AluRA = '+quotedstr(self.RA));


  rs:= formprincipal.Feagri_Conector.Execute('select * from Semestre where AluRA = '+quotedstr(self.RA));

  I:= rs.RecordCount;

  while I > high(self.SemestreFeagri) + 1 do
  begin
   formprincipal.Feagri_Conector.Execute('Delete from Semestre where SemCod = ' + inttostr(I));
   Dec(I);
  end;

  for I := low(SemestreFeagri) to high(SemestreFeagri) do
  begin

  if (self.SemestreFeagri[I].Operacao = Atualizacao) then
  begin
    formprincipal.Feagri_Conector.Execute('Update Semestre set SemCons = '
    + booltostr(SemestreFeagri[I].Consolidado)+ ', SemTran = '
    + booltostr(SemestreFeagri[I].Trancado)+ ', SemTrav = '
    + booltostr(SemestreFeagri[I].Travado) + ' where AluRA = '+quotedstr(self.RA)+ ' and SemCod = '+inttostr(I+1));
  end
  else
  if (self.SemestreFeagri[I].Operacao = Cadastro) then
  begin
    formprincipal.Feagri_Conector.Execute('Insert into Semestre (AluRA,SemCod,SemCons,SemTran,SemTrav) '
    + ' values (' + quotedstr(self.RA) + ', ' +inttostr(I+1) + ',' + booltostr(SemestreFeagri[I].Consolidado) + ','
    + booltostr(SemestreFeagri[I].Trancado)+ ',' + booltostr(SemestreFeagri[I].Travado) + ')');
  end;

  self.SemestreFeagri[I].Operacao:= 0;

  for J := 1 to 15 do
  begin
   if SemestreFeagri[I].MateriaSemestre[J].legenda <> '' then
    if (SemestreFeagri[I].MateriaSemestre[J].alteracao) then
    begin
     formprincipal.Feagri_Conector.Execute('Update Cat_Mat_Tur_Hist set SemCur = '
     + inttostr(I+1) + ', HistCod = ' + inttostr(SemestreFeagri[I].MateriaSemestre[J].estado)
     + ' where CMCod = '+inttostr(SemestreFeagri[I].MateriaSemestre[J].codigo)
     + ' and AluRA = '+quotedstr(self.RA));
     self.SemestreFeagri[I].MateriaSemestre[J].alteracao:= false;
    end;
  end;

 end;

 for I := low(self.AproveitamentoDeEstudos) to high(self.AproveitamentoDeEstudos) do
 begin
   if self.AproveitamentoDeEstudos[I].alteracao then
   begin
    formprincipal.Feagri_Conector.Execute('Update Cat_Mat_Tur_Hist set SemCur = '
     + inttostr(-1) + ', HistCod = ' + inttostr(self.AproveitamentoDeEstudos[I].estado)
     + ' where CMCod = '+inttostr(self.AproveitamentoDeEstudos[I].codigo)
     + ' and AluRA = '+quotedstr(self.RA));
       self.AproveitamentoDeEstudos[I].alteracao:= false;
    end;
 end;

 for I := low(self.SemestreJubilado) to high(self.SemestreJubilado) do
 begin
  if self.SemestreJubilado[I].alteracao then
  begin
    formprincipal.Feagri_Conector.Execute('Update Cat_Mat_Tur_Hist set SemCur = '
     + inttostr(-2) + ', HistCod = ' + inttostr(self.SemestreJubilado[I].estado)
     + ' where CMCod = '+inttostr(self.SemestreJubilado[I].codigo)
     + ' and AluRA = '+ quotedstr(self.RA));
      self.SemestreJubilado[I].alteracao:= false;
   end;
 end;

 for I := low(self.Eletivas) to high(self.Eletivas) do
 begin
  if self.Eletivas[I].alteracao then
  begin
    formprincipal.Feagri_Conector.Execute('Update Cat_Mat_Tur_Hist set SemCur = '
     + inttostr(0) + ', HistCod = ' + inttostr(self.Eletivas[I].estado)
     + ' where CMCod = '+inttostr(self.Eletivas[I].codigo)
     + ' and AluRA = '+ quotedstr(self.RA));
     self.Eletivas[I].alteracao:= false;
   end;
 end;

except
  Application.MessageBox('Erro ao gravar' + #13 + 'Contate o administrador','Feagri',16);
  Application.Terminate;
end;

end;

// deleta a simulação feita e volta para o estado inicial do histórico do aluno
procedure TCatalogo.ResetCatalogo;
var I,J:integer;
    rs: _recordset;
begin
try

 rs:= formprincipal.Feagri_Conector.Execute('update Aluno set Status = 1'
    + ' where AluRA = '+quotedstr(self.RA));

  // deleta os semestre que foram atribuidas para o aluno devido um trancamento

  rs:= formprincipal.Feagri_Conector.Execute('select * from Semestre where AluRA = '+quotedstr(self.RA));

  I:= rs.RecordCount;

  while I > 15 do
  begin
   formprincipal.Feagri_Conector.Execute('Delete from Semestre where SemCod = ' + inttostr(I));
   Dec(I);
  end;

  // voltam para o início os semstres do aluno

 for I := low(SemestreFeagri) to high(SemestreFeagri) do
 begin

  if (I >= 0) and (I <= 15) then
   formprincipal.Feagri_Conector.Execute('Update Semestre set SemCons = '+booltostr(false)+', SemTran = '
   + booltostr(false)+ ', SemTrav = '+ booltostr(false) + ' where AluRA = '+quotedstr(self.RA)+ ' and SemCod = '+inttostr(I+1));

  for J := 1 to 15 do
  begin
   if SemestreFeagri[I].MateriaSemestre[J].legenda <> '' then
    if SemestreFeagri[I].MateriaSemestre[J].turma <> 0 then
     formprincipal.Feagri_Conector.Execute('Update Cat_Mat_Tur_Hist set SemCur = '
     + inttostr(SemestreFeagri[I].MateriaSemestre[J].sem) + ', CMTCod = '
     + inttostr(SemestreFeagri[I].MateriaSemestre[J].turma) + ', HistCod = 3 where CMCod = '
     + inttostr(SemestreFeagri[I].MateriaSemestre[J].codigo)+ ' and AluRA = '+ quotedstr(self.RA))
    else
     formprincipal.Feagri_Conector.Execute('Update Cat_Mat_Tur_Hist set SemCur = '
     + inttostr(SemestreFeagri[I].MateriaSemestre[J].sem)+ ', HistCod = 3'
     + ', CMTCod = null where CMCod = '+ inttostr(SemestreFeagri[I].MateriaSemestre[J].codigo)
     + ' and AluRA = '+ quotedstr(self.RA))
   end;

 end;

 // volta para o início as matérias que foram dispensadas

 for I := low(self.AproveitamentoDeEstudos) to high(self.AproveitamentoDeEstudos) do
 begin
  formprincipal.Feagri_Conector.Execute('Update Cat_Mat_Tur_Hist set SemCur = '
     + inttostr(self.AproveitamentoDeEstudos[I].sem) + ', HistCod = 3'
     + ' where CMCod = '+inttostr(self.AproveitamentoDeEstudos[I].codigo)
     + ' and AluRA = '+ quotedstr(self.RA));
 end;

 // volta para o início as matérias que foram para jubiladas

 for I := low(self.SemestreJubilado) to high(self.SemestreJubilado) do
 begin
   formprincipal.Feagri_Conector.Execute('Update Cat_Mat_Tur_Hist set SemCur = '
     + inttostr(self.SemestreJubilado[I].sem) + ', HistCod = 3'
     + ' where CMCod = '+inttostr(self.SemestreJubilado[I].codigo)
     + ' and AluRA = '+quotedstr(self.RA));
 end;

 // volta o status das matérias eletivas para as definidas no catálogo

 for I := low(self.Eletivas) to high(self.Eletivas) do
 begin
   formprincipal.Feagri_Conector.Execute('Update Cat_Mat_Tur_Hist set SemCur = '
     + inttostr(self.Eletivas[I].sem) + ', HistCod = 3'
     + ' where CMCod = '+inttostr(self.Eletivas[I].codigo)
     + ' and AluRA = '+quotedstr(self.RA));
 end;

 // deleta as turmas simuladas

 rs:= FormPrincipal.Feagri_Conector.Execute('select cmtcod from cat_mat_tur where AluRA = '+quotedstr(self.RA));

 while not rs.EOF do
 begin
   i:= strtoint(rs.Fields[0].Value);
   formprincipal.Feagri_Conector.Execute('delete from cat_mat_tur_hor where cmtcod = '+ inttostr(i));
   rs.MoveNext;
 end;

 formprincipal.Feagri_Conector.Execute('delete from cat_mat_tur where AluRA = '+quotedstr(self.RA));

 Application.MessageBox('Simulação resetado com sucesso ','Feagri',64);

except
  Application.MessageBox('Erro ao resetar o simulação' + #13 + 'Contate o administrador','Feagri',16);
  Application.Terminate;
end;

end;

// verifica se a simulação foi salva
function TCatalogo.SimulacaoEstaSalva: boolean;
var I,J,K:Integer;
begin

 Result:= True;
 
 for I := low(SemestreFeagri) to high(SemestreFeagri) do
 begin
  if (self.SemestreFeagri[I].Operacao <> 0) then
  begin
    Result:= False;
    exit;
  end;

  for J := 1 to 15 do
  if SemestreFeagri[I].MateriaSemestre[J].legenda <> '' then
   if (SemestreFeagri[I].MateriaSemestre[J].alteracao) then
   begin
    Result:= False;
    exit;
   end;

 end;

 for I := low(self.AproveitamentoDeEstudos) to high(self.AproveitamentoDeEstudos) do
 if self.AproveitamentoDeEstudos[I].alteracao then
 begin
   Result:= False;
   exit;
 end;

 for I := low(self.SemestreJubilado) to high(self.SemestreJubilado) do
 if self.SemestreJubilado[I].alteracao then
 begin
  Result:= False;
  exit;
 end;

 for I := low(self.Eletivas) to high(self.Eletivas) do
 if self.Eletivas[I].alteracao then
 begin
  Result:= False;
  exit;
 end;

end;


{$ENDREGION}

 {$REGION 'Classe TPreReq'}

// construtor da classe TPreReq, carrega os pré-requisitos das matérias
constructor TPreReq.Create(aluRA: string; ano: Integer);
begin
  self.ano:= ano;
  self.aluRA:= aluRA;
  try
   self.CarregaPreRequisito;
  except
   Application.MessageBox('Erro ao carregar os pre requisitos das matérias' + #13 + 'Contate o administrador','Feagri',16);
   Application.Terminate;
  end;
end;

// carrega o objeto PreReq
procedure TPreReq.CarregaPreRequisito;
var rs: _recordset;
    cod, reqcod:integer;
begin
rs:= formprincipal.Feagri_Conector.Execute('select pre_req.cmcod, cmpcod from pre_req, cat_mat'
+ ' where cat_mat.cmcod = pre_req.cmcod and catcod ='+inttostr(self.ano));
cod:= 0;
reqcod:= 1;
while not rs.EOF do
begin
 if cod <> rs.Fields[0].Value then
 begin
   SetLength(PreReq,high(PreReq)+2);
   PreReq[high(PreReq)].codigo:= strtoint(rs.Fields[0].Value);
   cod:= strtoint(rs.Fields[0].Value);
   reqcod:=1;
 end;
 PreReq[high(PreReq)].pre_req[reqcod]:= strtoint(rs.Fields[1].Value);
 inc(reqcod);
 rs.MoveNext;
end;
end;

// verifica se existe um item no objeto PreRequisitos
function TPreReq.MateriaJaEstaNaLista(cod: Integer):boolean;
var I:Integer;
begin
 Result:= false;
 for I := low(self.PreRequisitos) to high(self.PreRequisitos) do
  if self.PreRequisitos[I] = cod then
  begin
   Result:= True;
   exit;
  end;
end;

// verifica se a materia já foi inserida no grafo de pré-requisitos
function TPreReq.MateriaJaEstaNoGrafo(cod: integer):boolean;
var I:Integer;
begin
 Result:= false;
 for I := low(self.LstPreReq) to high(self.LstPreReq) do
  if self.LstPreReq[I].mat.codigo = cod then
  begin
   Result:= True;
   exit;
  end; 
end;

// insere um item no grafo
procedure TPreReq.InsereNoGrafo(var g:grafo;c:integer);
var g1:grafo;
begin
 if g = nil then
 begin
  new(g1);
  g1^.pred:= c;
  g1^.suc:= nil;
  g:= g1;
 end
 else
  InsereNoGrafo(g^.suc,c);
end;

// verifica se um item existe em uma lista
function AchaItem(cod: Integer; Lst: array of RMateria): boolean;
var
  I: Integer;
begin
Result:= False;
for I := low(Lst) to high(Lst) do
begin
  if cod = Lst[I].codigo then
  begin
    Result:= True;
    exit;
  end;
end;
end;

// aloca um bloco para armazenar a matéria a ser cursada
procedure TPreReq.AlocaMateria(mat: RMateria);
begin
 SetLength(self.LstPreReq,high(self.LstPreReq)+2);
 New(self.LstPreReq[high(self.LstPreReq)].seq);
 self.LstPreReq[high(self.LstPreReq)].seq:= nil;
 self.LstPreReq[high(self.LstPreReq)].mat:= mat;
 self.LstPreReq[high(self.LstPreReq)].pre:= 0;
end;

procedure TPreReq.MontaCadeiaDeSucessores(Dispensada, Eletiva, Jubilada: array of RMateria; mat: RMateria);
var J:integer;
begin
 self.PreRequisitos:= nil;
 self.DescobrirMateriasConsecutivas(mat.codigo);
 for J := low(self.PreRequisitos) to high(self.PreRequisitos) do
 begin
  if (not AchaItem(self.PreRequisitos[J],dispensada))
   and (not AchaItem(self.PreRequisitos[J],eletiva))
   and (not AchaItem(self.PreRequisitos[J],Jubilada)) then
   begin
    InsereNoGrafo(self.LstPreReq[self.LstIndex(0,mat.codigo)].seq, self.PreRequisitos[J]);
    Inc(self.LstPreReq[self.LstIndex(0,self.PreRequisitos[J])].pre);
   end;
  end;
end;

// constrói o grafo de uma matéria
procedure TPreReq.ConstroiGrafo(sem: integer; Aluno: SemestreDoAluno; Dispensada, Eletiva, Jubilada: array of RMateria);
var I,J:Integer;
begin

 for I := 1 to 15 do
  if Aluno[sem - 1].MateriaSemestre[I].legenda <> '' then
   if Aluno[sem - 1].MateriaSemestre[I].estado = 3 then
    self.AlocaMateria(Aluno[sem - 1].MateriaSemestre[I]);

 for I := sem to high(Aluno) do
  for J := 1 to 15 do
   if Aluno[I].MateriaSemestre[J].legenda <> '' then
    self.AlocaMateria(Aluno[I].MateriaSemestre[J]);


 for I := low(self.LstPreReq) to high(self.LstPreReq) do
   self.MontaCadeiaDeSucessores(dispensada,eletiva,jubilada,self.LstPreReq[I].mat);

end;

// procura o índice da lista que está a matéria
function TPreReq.LstIndex(cont:integer; cod:integer):integer;
begin
 if (cont > high(self.LstPreReq)) or (self.LstPreReq[cont].mat.codigo = cod) then
  LstIndex:= 0
  else
   LstIndex:= 1 + LstIndex(cont+1,cod);
end;

 //decrementa um predecessor da matéria
procedure TPreReq.DecPred(var d:grafo);
begin
 if d = nil then exit;
 dec(self.LstPreReq[self.LstIndex(0,d^.pred)].pre);
 decpred(d^.suc);
end;

// rotina que insere uma materia numa lista ordenada
procedure TPreReq.LstOrdAdd(mat:RMateria; var L:lstord);
var n:lstord;
begin
 if (l=nil) or (mat.sem <= l^.mat.sem) then
  begin
   new(n);
   n^.mat:= mat;
   n^.suc:=l;
   l:=n;
  end
  else LstOrdAdd(mat,l^.suc);
end;

// rotina que remove o item de uma lista ordenada
procedure TPreReq.LstOrdRemove(var lst:lstord);
var n:lstord;
begin
 n:=lst;
 lst:=lst^.suc;
 dispose(n);
end;

// rotina que limpa a lista
procedure TPreReq.LimpaLista;
var lt:lstord;
begin
 lt:= self.LstOrdenada;
 if lt = nil then exit;
 while lt <> nil do
 begin
  self.LstOrdenada:= self.LstOrdenada^.suc;
  dispose(lt);
  lt:= self.LstOrdenada;
 end;
end;

// verifica se uma matéria tem pré-requisito
function TPreReq.TemPreRequisito(cod: integer):boolean;
var I:integer;
begin
Result:= false;
for I := low(self.PreReq) to high(self.PreReq) do
begin
  if PreReq[I].codigo = cod then
  begin
    Result:= true;
    exit;
  end;
end;
end;

// verifica se pode cursar uma matéria que tem pré-requisito
function TPreReq.PodeCursar(Feagri :SemestreDoAluno; Dispensa: array of RMateria; mat: integer; sem: Integer):boolean;
var I,K,L:integer;
    PreReqOk: array of boolean;
    LstPreReq: PreReqDaMateria;
begin
Result:= true;
 if not self.TemPreRequisito(mat) then exit
 else
 begin

  LstPreReq:= self.ConsultarPreReq(mat);
  SetLength(PreReqOk,length(LstPreReq));

  for I := low(LstPreReq) to high(LstPreReq) do
  begin

    if LstPreReq[I] <> 0 then
    begin

     PreReqOk[I]:= false;

     for K := low(Feagri) to sem - 2 do
      for L := 1 to 15 do
       if Feagri[K].MateriaSemestre[L].codigo = LstPreReq[I] then PreReqOk[I]:= True;

     for K := low(Dispensa) to high(Dispensa) do
       if Dispensa[K].codigo = LstPreReq[I] then PreReqOk[I]:= True;

     if not PreReqOk[I] then
     begin
      Result:= False;
      exit;
     end;

   end;
   
  end;
 end;
end;


// verifica se pode cursar um pré-requisito em um semestre
function TPreReq.PodeCursarPreRequisito(Feagri :SemestreDoAluno; mat: integer; sem: Integer):boolean;
var I,J,K:Integer;
begin
 Result:= True;
  self.DescobrirTodaCadeia(mat);
  for I := low(self.PreRequisitos) to high(self.PreRequisitos) do
  begin
  for J := low(Feagri) to sem - 1 do
  begin
   for K := 1 to 15 do
    if Feagri[J].MateriaSemestre[K].codigo = self.PreRequisitos[I] then
    begin
     Result:= false;
     self.PreRequisitos:= nil;
     exit;
    end;
   end;
  end;
  self.PreRequisitos:= nil;
end;

// descobre as matéria que tem como pré-requisito a matéria
procedure TPreReq.DescobrirMateriasConsecutivas(cod: Integer);
var J,K:Integer;
begin
 for J := low(self.PreReq) to high(self.PreReq) do
  for K := 1 to 5 do
  begin
   if self.PreReq[J].pre_req[k] = cod then
   begin
    if not self.MateriaJaEstaNaLista(self.PreReq[J].codigo) then
    begin
     SetLength(PreRequisitos,high(PreRequisitos)+2);
     PreRequisitos[high(PreRequisitos)]:= self.PreReq[J].codigo;
    end;
   end;
  end;
end;

//consulta os pré-requisitos de uma matéria
function TPreReq.ConsultarPreReq(codigo: integer): PreReqDaMateria;
var i:integer;
begin
for I := low(self.PreReq) to high(self.PreReq) do
  begin
    if self.PreReq[I].codigo = codigo then
    begin
      Result:= self.PreReq[I].pre_req;
      exit;
    end;
  end;
end;

// descobre a cadeia de matérias
procedure TPreReq.DescobrirTodaCadeia(cod: Integer);
var J,K:Integer;
begin
 for J := low(self.PreReq) to high(self.PreReq) do
  for K := 1 to 5 do
  begin
   if self.PreReq[J].pre_req[k] = cod then
   begin
    if not self.MateriaJaEstaNaLista(self.PreReq[J].codigo) then
    begin
     SetLength(PreRequisitos,high(PreRequisitos)+2);
     PreRequisitos[high(PreRequisitos)]:= self.PreReq[J].codigo;
     self.DescobrirTodaCadeia(self.PreReq[J].codigo);
    end;
   end;
  end;
end;


{$ENDREGION}



end.
