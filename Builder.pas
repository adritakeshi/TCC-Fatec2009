unit Builder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus, Buttons, Feagri, Horarios, frmConsolidacao;

const espacoT = 25; //distancia entre as materias
      TamL = 60;   //tamanho do grupo   original 68
      NQuebra = 5;   //original = 5 ,7
type
  TPosition = record      //usado
    topo: integer;
    esq:  integer;
  end;

  TFrmBuilder = class(TForm)
    PainelPop: TPopupMenu;
    ExibeLeg: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    MSimu: TMenuItem;
    MNormal: TMenuItem;
    MHora: TMenuItem;

    //eventos do painel
    procedure MovePainel(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TeclaUP(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TeclaDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    //eventos do bitbtn
    procedure Tranca(Sender: TObject);
    procedure Trava(Sender: TObject);
    procedure Consolida(Sender: TObject);
    procedure ConsolidadoOk(Sem:integer);
    procedure OrganizaSem(Sem:integer);
    procedure SimulacaoOk;
    procedure DestroiGrp(var Grupo: TGroupBox; tipo,sem: integer);
    procedure AtualizaImagemBtn(sem: Integer);
    procedure DesabilitaBtn(sem: Integer);

    procedure PainelPopPopup(Sender: TObject);
    //BOTÕES do popup
    procedure MSimuClick(Sender: TObject);
    procedure MNormalClick(Sender: TObject);
    procedure MHoraClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExibeDescClick(Sender: TObject);


   //cria grupo de semestre

  private
    { Private declarations }
   procedure CriaPanel(var Panel: TPanel;  Esq, Topo, larg, altura, Sem: integer; title:string);
   procedure CriaGrp(var Grupo: TGroupBox;  Esq, Topo, larg, altura, tipo, Sem: integer);// tipo 0: normal, 1 elet, 2 dispensado e 3 jubilado
   procedure CriaLbl(var Grupo: TGroupBox; var Lbl: TLabel; Esq, Topo, larg, altura: integer; title:string);
   procedure CriaBtn(var Grupo: TGroupBox; var Btn: TBitBtn; Esq, Topo, larg, altura: integer; title:string; estado:boolean);
   procedure CriaGrpCur(i:integer; tranc,trav: boolean);
   procedure AtualizaCred (sem:integer);
   procedure TransferePainel(P:TPanel);
   //   function BooltoInt(bool: boolean):integer;
   //   procedure DestroiGrp(var Grupo: TGroupBox; tipo,sem: integer);// tipo 0: normal, 1 elet, 2 dispensado e 3 jubilado
  function VerificaGrupos(Painel:TPanel): integer; overload;
  function VerificaGrupos(BitBtn:TBitBtn): integer; overload;
  public
    { Public declarations }
  end;

const ImgTranca: array[0..1] of string = ('icon\cadeadoA.bmp','icon\cadeadoF.bmp');
const ImgTrava: array[0..1] of string = ('icon\doorA.bmp','icon\doorF.bmp');

var
  FrmBuilder: TFrmBuilder;

  Catalogo: TCatalogo;
  PreReq: TPreReq;
  Horarios: THorarios;
  move: boolean; // permite mover o panel
  origem:integer; // onde estava o panel
  SemDestinoSimulacao: integer;

  btndown: boolean;
  SemCons: integer;//semestre que se pretende consolidar
  Simula, SimuOk: boolean;
  MatSimulacao: string;
  // objetos
  Rpanel: TPosition;//var q guarda a ultima posicao do painel q é movido
  PanAux: Tpanel;
  GrpSem: array  of TGroupBox;
  GrpElet, GrpDisp, GrpJub:  TGroupBox;
  LblCred, TxtCred: array of TLabel;
  BtnTranca, BtnTrava: array of TBitBtn;
  BtnConsolida: TbitBtn;
  quadro: array of Tpanel;
  //até aqui

implementation

uses frmGradeHoraria, principal, DescMat;
// comandos base
{
  showmessage(inttostr());

função DayOfWeek(Data: Tdate): integer; interno do delphi
1 - domingo
2 - segunda
...
7 - sabado

//showmessage(inttostr(DayOfWeek(strtodate('21/08/2009'))));

  informações uteis
  Parâmetro Significado
Sender O objeto que causou o evento
Button Indica qual o botão envolvido no evento: mbLeft, mbMiddle, or mbRight
Shift Indica o estado das teclas Alt, Ctrl e Shift keys durante o evento de mouse
X, Y São as coordenadas da tela onde ocorreu o evento.

lista de cores: luminosidade 204 (semestre)
01 - $00BADDF8
02 - $00FF7DEF
03 - $007BFBBE
04 - $0029B6FA
05 - $00CEBB97
06 - $00B7889E
07 - $002444FB
08 - $008CF1F7
09 - $002CB121
10 - $0099F731
00 - $00FFFFFF

estilo:
Turma: integer; 1-normal, 2-fora do semestre, 3-simulada, 4-aproveitada com pre-req, 5 - aproveitada sem pre-req
0/1-sem nada - normal
2-italico - fora do semestre  mas mantem o horario
3-negrito - simulada independe do semestre, o horario é diferente do original
4-sublinhada - dispensado parcialmente (ainda tem pre-requisitos pendentes)
5-tachada - dispensada não possui pre-requisitos pendentes

}
{$R *.dfm}

function BooltoInt(bool: boolean):integer;
begin
  If bool then result := 1
  else result := 0;
end;

function InttoBool(n:integer):boolean;
begin
  If n = 0 then result := false
  else result := true;
end;

function ProcuraPosQuadro(Legenda:string):integer;
var i:integer;
begin
  i := low(quadro);
  while Legenda <> quadro[i].Caption do
    inc(i);
    Result:= i;
end;

function TFrmBuilder.VerificaGrupos(painel:TPanel): integer;
var i,res:integer;
begin
//verifica qual é o grupo q está o painel  e retorna
  res:= 0;
  if (Painel.Top + Painel.Height) > (GrpJub.Top) then begin
    res:= -2;
  end
  else if (Painel.Top + Painel.Height) > (GrpElet.Top) then
  begin
    if Painel.Left > GrpDisp.Left then
    res:= -1 else res:= 0;
  end
  else if (Painel.Top + Painel.Height) <= (GrpElet.Top) then begin
    for i:= low(GrpSem) to high(GrpSem) do
      if  (Painel.Left >= GrpSem[i].Left) then
        res := i+1
      else break;
  end;
  result := res;
end;

function TFrmBuilder.VerificaGrupos(BitBtn:TBitBtn): integer;
var res, i:integer;
begin
//verifica qual é o grupo q está o BitBtn  e retorna
   res := 0;
   for i:= low(GrpSem) to high(GrpSem) do begin
        Res := i+1;
        if (BitBtn.Parent = GrpSem[i]) then
           break;
   end;
   Result := res;
end;

function SemestreCor(Semestre:integer):TColor;
begin
//retorna uma cor de acordo com o semestre letivo
  Case Semestre of
    0: Result := $00FFFFFF;
    1: Result := $00BADDF8;
    2: Result := $00FF7DEF;
    3: Result := $007BFBBE;
    4: Result := $0029B6FA;
    5: Result := $00CEBB97;
    6: Result := $00B7889E;
    7: Result := $002444FB;
    8: Result := $008CF1F7;
    9: Result := $002CB121;
    10: Result := $0099F731;
  else
    Result:= clWhite;
  end;
end;

function TipoSimulado(painel:TPanel):boolean;
begin
  if painel.Font.Style = [] then Result := false
  else Result := true;
end;

function EstiloPanel(turma:integer):TfontStyles;
begin
  Case turma of
    0: Result := [];
    1: Result := [];          //normal
    2: Result := [FsItalic];  //fora sem
    3: Result := [fsBold];    //sim
    4: Result := [fsUnderline];  //disp parcial
    5: Result := [fsStrikeOut];  //disp tot
  else
    Result:=[];
  end;
end;

procedure TFrmBuilder.AtualizaCred (sem:integer);
var cred: integer;
begin
if Catalogo.TeveCreditosUltrapassados(sem) then
 TxtCred[sem-1].Font.Style := EstiloPanel(3)
 else TxtCred[sem-1].Font.Style := EstiloPanel(1);
cred := Catalogo.SemestreFeagri[sem-1].Credito;
TxtCred[sem-1].Caption := inttostr(cred);
end;

procedure AlinhaPanel(var P:TPanel; Sem,i: integer);
begin
//alinha o painel de acordo com o frame origem - setor de origem
    if (Sem = 0) then begin
        P.Top := GrpElet.Top + (((i mod NQuebra) +1)*espacoT);
        P.Left:= GrpElet.Left + 8 + (P.Width+2)*(i div NQuebra);
    end else if (Sem = -1) then begin
        P.Top := GrpDisp.Top + (((i mod NQuebra) +1)*espacoT);
        P.Left:= GrpDisp.Left + 8 + (P.Width+2)*(i div NQuebra);
    end else if (Sem = -2) then begin
        P.Top := GrpJub.Top + (espacoT);
        P.Left:= GrpJub.Left + 8 + ((P.Width+2)*i);
    end else begin
        P.Top := GrpSem[Sem-1].Top + ((i)*espacoT);
        P.Left := GrpSem[Sem-1].Left + trunc((GrpSem[Sem-1].Width - P.Width)/2);
    end;
    P.BringToFront;
    if (P.Font.Style <> EstiloPanel(Horarios.ConsultaTurma(P.Caption))) then
       P.Font.Style:= EstiloPanel(Horarios.ConsultaTurma(P.Caption));
end;

procedure TFrmBuilder.OrganizaSem(Sem:integer);
var i: integer;
begin

    case Sem of
      0: begin
            if length(Catalogo.Eletivas) <> 0 then
                for i:= low(Catalogo.Eletivas) to high(Catalogo.Eletivas) do
                    AlinhaPanel(quadro[ProcuraPosQuadro(Catalogo.Eletivas[i].legenda)], sem,i);
          end;
      -1: begin
            if length(Catalogo.AproveitamentoDeEstudos) <> 0 then
                for i:= low(Catalogo.AproveitamentoDeEstudos) to high(Catalogo.AproveitamentoDeEstudos) do
                    AlinhaPanel(quadro[ProcuraPosQuadro(Catalogo.AproveitamentoDeEstudos[i].legenda)], sem,i);
          end;
      -2: begin
            if length(Catalogo.SemestreJubilado) <> 0 then
                for i:= low(Catalogo.SemestreJubilado) to high(Catalogo.SemestreJubilado) do
                    AlinhaPanel(quadro[ProcuraPosQuadro(Catalogo.SemestreJubilado[i].legenda)], sem,i);
          end;
      else begin  //sem normal
            if Catalogo.TamSem(Catalogo.SemestreFeagri[Sem-1].MateriaSemestre,Sem) <> 0 then
                for i:=1 to Catalogo.TamSem(Catalogo.SemestreFeagri[Sem-1].MateriaSemestre, Sem) do
                    AlinhaPanel(quadro[ProcuraPosQuadro(Catalogo.SemestreFeagri[Sem-1].MateriaSemestre[i].legenda)], Sem,i);
           end;
    end;
end;

procedure TFrmBuilder.TransferePainel(P:TPanel);
var destino: integer;
begin
    destino:= VerificaGrupos(P);

    if origem <> (destino) then  begin  // verifica se o painel não está no mesmo grupo
      if not Catalogo.MudaSemestre(P.Caption, origem, destino, horarios, PreReq) then
      begin
          P.Top := RPanel.topo;
          P.Left:= RPanel.esq;
      end else begin
          if origem > 0 then
              AtualizaCred(origem);
          if destino > 0 then
              AtualizaCred(destino);
          P.Font.Style:= EstiloPanel(1);
          OrganizaSem(origem);
          OrganizaSem(destino);
      end;
    end else begin
        P.Top := RPanel.topo;
        P.Left:= RPanel.esq;
    end;
end;

procedure TFrmBuilder.DestroiGrp(var Grupo: TGroupBox; tipo,sem: integer);// tipo 0: normal, 1 elet, 2 dispensado e 3 jubilado
begin
  if (tipo <> 0) then begin
    LblCred[sem].Free;
    LblCred[sem] := nil;

    TxtCred[sem].Free;
    TxtCred[sem] := nil;

    BtnTranca[sem].Free;
    BtnTranca[sem] := nil;

    BtnTrava[sem].Free;
    BtnTrava[sem] := nil;

  setlength(LblCred,length(LblCred)-1);
  setlength(TxtCred,length(TxtCred)-1);
  setlength(BtnTranca,length(BtnTranca)-1);
  setlength(BtnTrava,length(BtnTrava)-1);
  end;

  Grupo.Free; // Método que elimina o objeto da memória.
  Grupo := nil; // anula a referência ao ponteiro do objeto.
  if (tipo <> 0) then
      setlength(GrpSem,length(GrpSem)-1);
end;

procedure TFrmBuilder.CriaPanel(var Panel: TPanel;  Esq, Topo, larg, altura, Sem: integer; Title: string);
begin
    Panel := TPanel.Create(Self);
    Panel.Parent := Self;
    Panel.SetBounds(Esq,Topo,larg,altura); // Ajusta Left, Top, Width, Height.
    Panel.OnMouseDown := TeclaDown;
    Panel.OnMouseUp := TeclaUP;
    Panel.OnMouseMove := MovePainel;
    Panel.Caption := title;
    Panel.Color := SemestreCor(sem);
    Panel.ShowHint := true;
    Panel.Hint := Panel.caption;
    Panel.Font.Style:= EstiloPanel(Horarios.ConsultaTurma(Title));
end;

procedure TFrmBuilder.CriaLbl(var Grupo: TGroupBox; var Lbl: TLabel; Esq, Topo, larg, altura: integer; title:string);
begin
      Lbl := TLabel.Create(Self);
      Lbl.Parent := Grupo;
      Lbl.SetBounds(esq,topo,larg,altura);
      Lbl.Caption := title;
end;

procedure TFrmBuilder.CriaBtn(var Grupo: TGroupBox; var Btn: TBitBtn; Esq, Topo, larg, altura: integer; title:string; estado:boolean);
begin
      Btn := TBitBtn.Create(Self);
      Btn.Parent := Grupo;
      Btn.SetBounds(esq,topo,larg,altura);
      Btn.ShowHint := true;
      Btn.Layout:= blGlyphTop;

      if title = 'tranca' then begin
          Btn.Glyph.LoadFromFile(ImgTranca[BooltoInt(estado)]);
          Btn.OnClick := Tranca;
          Btn.Hint:= 'Cadeado Fechado = Semestre Trancado'
          +#13+'Cadeado Aberto = Semestre Destrancado';
      end
      else if title = 'trava' then begin
          Btn.Glyph.LoadFromFile(ImgTrava[BooltoInt(estado)]);
          Btn.OnClick := Trava;
          Btn.Hint:= 'Porta Fechada = Semestre Travado'
          +#13+'Porta Aberta = Semestre Destravado';
      end
      else begin
          Btn.Glyph.LoadFromFile('icon\duck.bmp');
          Btn.OnClick := Consolida;
          Btn.Hint:= 'Consolida Semestre'
          +#13+'formalizando o término do semestre.';
      end;
      
end;

procedure TFrmBuilder.AtualizaImagemBtn(sem: Integer);
begin
  BtnTranca[sem - 1].Glyph.LoadFromFile(ImgTranca[BooltoInt(Catalogo.SemestreFeagri[sem - 1].Trancado)]);
  BtnTrava[sem - 1].Glyph.LoadFromFile(ImgTrava[BooltoInt(Catalogo.SemestreFeagri[sem - 1].Travado)]);
  GrpSem[sem - 1].Enabled:= True;
end;

procedure TFrmBuilder.CriaGrp(var Grupo: TGroupBox; Esq, Topo, Larg, Altura, Tipo, Sem: integer);// tipo 0: normal, 1 elet, 2 dispensado e 3 jubilado
begin
// cria os objetos
  if (tipo = 0) then begin
      Grupo := TGroupBox.Create(Self);
      Grupo.Parent := Self;
      Grupo.SetBounds(Esq,Topo,Larg,Altura); // Ajusta Left, Top, Width, Height.
      Grupo.Left:= Esq;
      Grupo.Top := topo;
      if (sem) >= 10 then Grupo.Caption := 'Sem '+inttostr(sem)
      else Grupo.Caption := 'Sem 0'+inttostr(sem);

  end else begin
      Grupo := TGroupBox.Create(Self);
      Grupo.Parent := Self;
      Grupo.SetBounds(Esq,Topo,Larg,Altura);
      if (tipo = 1) then Grupo.Caption := 'Eletiva'
      else if (tipo = 2) then Grupo.Caption := 'Dispensadas'
      else if (tipo = 3) then Grupo.Caption := 'Jubiladas';
  end

end;

procedure TFrmBuilder.CriaGrpCur(i:integer; tranc,trav: boolean);
begin
      setlength(GrpSem,length(GrpSem)+1);
      if length(GrpSem) = 1 then
      CriaGrp(GrpSem[i], (i*(TamL-1)), 0, TamL, 500, 0, (i+1))
      else CriaGrp(GrpSem[i], (GrpSem[i-1].Left+GrpSem[i-1].Width), 0, TamL, 500, 0, (i+1));

      setlength(BtnTrava,length(BtnTranca)+1);
      CriaBtn(GrpSem[i],BtnTrava[i],7, 422, 44, 24, 'trava', trav);

      setlength(BtnTranca,length(BtnTranca)+1);
      CriaBtn(GrpSem[i],BtnTranca[i],7, 452, 44, 24, 'tranca', tranc);

      setlength(LblCred,length(LblCred)+1);
      CriaLbl(GrpSem[i],LblCred[i],10, 480, 44, 18, 'C');

      setlength(TxtCred,length(TxtCred)+1);
      CriaLbl(GrpSem[i],TxtCred[i],30, 480, 44, 18, '0');
end;

function RetornaStatus(status:boolean):string;
begin
  if status then Result:= 'Cursando'
  else Result:= 'Jubilado';
end;

procedure TFrmBuilder.FormCreate(Sender: TObject);
var i,j,k:integer;
    min: integer;
begin
// cria os objetos
    Catalogo:= TCatalogo.Create(formprincipal.AluRa,formprincipal.AluAno);
    PreReq := TPreReq.Create(formprincipal.AluRa,formprincipal.AluAno);
    Horarios:= THorarios.Create(formprincipal.AluRa,formprincipal.AluAno);

    formprincipal.Caption:= 'Aluno(a): '+formprincipal.AluNome
    +  ' - RA: '+formprincipal.AluRA + ' - Status: '+ RetornaStatus(Catalogo.Ativo);

    DescMat.Aberto:= false;

    Self.Width := 1020;
    Self.Height := 725;
    //self.WindowState := wsMaximized;

//cria grupo semestre feagri;
    LblCred :=nil;
    TxtCred := nil;
    BtnTrava := nil;
    BtnTranca := nil;
    GrpSem := nil;
    quadro := nil;
    setlength(quadro,0);

    for i := low(Catalogo.SemestreFeagri) to high(Catalogo.SemestreFeagri) do
    begin
      CriaGrpCur(i,Catalogo.SemestreFeagri[i].Trancado,Catalogo.SemestreFeagri[i].Travado);
      DesabilitaBtn(i + 1);

      if Catalogo.TamSem(Catalogo.SemestreFeagri[i].MateriaSemestre,i+1) <> 0 then
      begin
          min := length(quadro);
          setlength(quadro,length(quadro)+Catalogo.TamSem(Catalogo.SemestreFeagri[i].MateriaSemestre,i+1));
          k:=1;
          for j := min to high(quadro) do  begin
            CriaPanel(quadro[j], 10, espacoT, 42, 25, Catalogo.SemestreFeagri[i].MateriaSemestre[k].sem, Catalogo.SemestreFeagri[i].MateriaSemestre[k].legenda);
            AlinhaPanel(quadro[j],i+1,k);
            inc(k);
          end;
      end;
      AtualizaCred(i+1);
    end;

    CriaGrp(GrpElet, 0, GrpSem[high(GrpSem)].Height, (GrpSem[high(GrpSem)].Width+GrpSem[8].Left), 155, 1, 0);
    if Catalogo.TamSem(Catalogo.Eletivas, 0) <> 0 then   //length(Catalogo.Eletivas)
    begin
          min := length(quadro);
          setlength(quadro,length(quadro)+Catalogo.TamSem(Catalogo.Eletivas, 0));
          k:=0;
          for j := min to high(quadro) do  begin
              CriaPanel(quadro[j], 10, espacoT, 42, 25, Catalogo.Eletivas[k].sem, Catalogo.Eletivas[k].legenda);
              AlinhaPanel(quadro[j],0,k);
              inc(k);
          end;
    end;

    CriaGrp(GrpDisp, GrpElet.Width+1, GrpSem[high(GrpSem)].Height,  (GrpSem[high(GrpSem)].Width+GrpSem[5].Left), 155, 2, -1);

    if length(Catalogo.AproveitamentoDeEstudos) <> 0 then
    begin
          min := length(quadro);
          setlength(quadro,length(quadro)+length(Catalogo.AproveitamentoDeEstudos));
          k:=0;
          for j := min to high(quadro) do  begin
              CriaPanel(quadro[j], 10, espacoT, 42, 25, Catalogo.AproveitamentoDeEstudos[k].sem, Catalogo.AproveitamentoDeEstudos[k].legenda);
              AlinhaPanel(quadro[j],-1,k);
              inc(k);
          end;
    end;

    CriaGrp(GrpJub, 0, (GrpElet.Height+GrpElet.Top), (GrpSem[high(GrpSem)].Width+GrpSem[14].Left), 57, 3, -2);
    if length(Catalogo.SemestreJubilado) <> 0 then
    begin
          min := length(quadro);
          setlength(quadro,length(quadro)+length(Catalogo.SemestreJubilado));
          k:=0;
          for j := min to high(quadro) do  begin
              CriaPanel(quadro[j], 10, espacoT, 42, 25, Catalogo.SemestreJubilado[k].sem, Catalogo.SemestreJubilado[k].legenda);
              AlinhaPanel(quadro[j],-2,k);
              inc(k);
          end;
    end;

    i:=0;
    While Catalogo.SemestreFeagri[i].Consolidado = true do
      inc(i);

    if i >= high(Catalogo.SemestreFeagri) then
        i:= high(Catalogo.SemestreFeagri);
    CriaBtn(GrpSem[i],BtnConsolida,7, 392, 44, 24, 'Consol', false);

    move:=false;
    btndown:=false;  

end;

procedure TFrmBuilder.MovePainel(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var Posicao: TPoint;
    painel: Tpanel;
begin
    painel := TPanel(Sender);
    Posicao := FrmBuilder.CalcCursorPos;
    if move = true then begin
        If ((Posicao.Y+ painel.Height)< FrmBuilder.ClientHeight) and ((Posicao.X+ painel.Width)< FrmBuilder.ClientWidth)
        and ((Posicao.Y)> 0) and ((Posicao.X)> 0)  then begin
              painel.Top := Posicao.Y;
              painel.Left := Posicao.X;
        end;
    end;
end;

procedure TFrmBuilder.TeclaUP(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var  painel: Tpanel;

begin
    painel := TPanel(Sender);
    if button = mbLeft then begin
        move := false;
        TransferePainel(painel);
        btndown := false;
    end;
end;

procedure TFrmBuilder.TeclaDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var   Painel: Tpanel;
      Posicao: TPoint;
begin
    Painel := TPanel(Sender);
    origem := VerificaGrupos(Painel);
    Painel.BringToFront;
    if (button = mbLeft) and (not btndown) then begin
        btndown := true;

        if (origem < 1)
        or ((not Catalogo.SemestreFeagri[origem-1].Travado)
        and (not Catalogo.SemestreFeagri[origem-1].Trancado)
        and (not Catalogo.SemestreFeagri[origem-1].Consolidado)) then
            move := true
        else
            move := false;

       if not Catalogo.Ativo then move:= false;

        RPanel.topo := Painel.Top;
        RPanel.esq := Painel.Left;
    end else if (button = mbRight) and (not btndown) then begin
      //ou este
      Posicao := Self.CalcCursorPos;
      PanAux := Painel;
      PainelPop.Popup(Posicao.X,Posicao.Y);
    end;
end;

procedure TFrmBuilder.FormClose(Sender: TObject; var Action: TCloseAction);
//var i,max:integer;
begin

if Catalogo.SimulacaoEstaSalva then
begin
  formprincipal.Simulacao1.enabled:= true;
  formprincipal.Caption:= 'Sistema de Planejamento Acadêmico de Alunos da Feagri - Unicamp';
  Action := caFree;
  formprincipal.Salvar1.Enabled:= false;
  formprincipal.Reset1.Enabled:= false;
end
else
begin
if Application.MessageBox('Deseja sair sem salvar?', 'Feagri',36) = 6 then
begin
  formprincipal.Simulacao1.enabled:= true;
  formprincipal.Caption:='';
  Action := caFree;
  formprincipal.Salvar1.Enabled:= false;
  formprincipal.Reset1.Enabled:= false;
end
else Action := caNone;
end;
{
 max := length(GrpSem)-1;
 for i := max downto 0 do
    DestroiGrp(GrpSem[i],1,i);
 DestroiGrp(grpElet,0,-1);
 }
end;

procedure TFrmBuilder.ExibeDescClick(Sender: TObject);
var i, pos, Local: integer;
    LstPreReq: PreReqDaMateria;
begin
    Local := verificaGrupos(PanAux);

    case Local of
         0: begin
              pos := Catalogo.PosVetMat(Panaux.caption, Catalogo.Eletivas, 0);
              DescMat.Materia :=Catalogo.Eletivas[pos];
             end;
        -1: begin
              pos := Catalogo.PosVetMat(Panaux.caption, Catalogo.AproveitamentoDeEstudos, 0);
              DescMat.Materia :=Catalogo.AproveitamentoDeEstudos[pos];
            end;
        -2: begin
              pos := Catalogo.PosVetMat(Panaux.caption, Catalogo.SemestreJubilado, 0);
              DescMat.Materia :=Catalogo.SemestreJubilado[pos];
            end;
        else begin
              pos := Catalogo.PosVetMat(Panaux.caption, Catalogo.SemestreFeagri[Local-1].MateriaSemestre, Local);
              DescMat.Materia :=Catalogo.SemestreFeagri[Local-1].MateriaSemestre[pos];
             end;
    end;

    LstPreReq:= PreReq.ConsultarPreReq(Catalogo.ConsultaMateria(PanAux.Caption).codigo);
    for I := 1 to 5 do      
     DescMat.LstPreReq[I]:= '';
    for i:= low(LstPreReq) to high(LstPreReq) do
     if LstPreReq[i] <> 0 then
        DescMat.LstPreReq[i]:= Catalogo.ConsultaMateria(LstPreReq[i]).legenda;

   if not DescMat.Aberto then
      FDescMat := DescMat.TFDescMat.Create(application);

end;

procedure TFrmBuilder.PainelPopPopup(Sender: TObject);
var {pos,} Local: integer;
begin

    Local := verificaGrupos(PanAux);
{
    case Local of
         0: pos := Catalogo.PosVetMat(Panaux.caption, Catalogo.Eletivas, 0);
        -1: pos := Catalogo.PosVetMat(Panaux.caption, Catalogo.AproveitamentoDeEstudos, 0);
        -2: pos := Catalogo.PosVetMat(Panaux.caption, Catalogo.SemestreJubilado, 0);
        else pos := Catalogo.PosVetMat(Panaux.caption, Catalogo.SemestreFeagri[Local-1].MateriaSemestre, Local);
    end;
}
    PainelPop.Items.Items[0].Visible := true;
    PainelPop.Items.Items[1].Visible := true;
    if Local <> -1 then begin
        PainelPop.Items.Items[2].Visible := TipoSimulado(PanAux);
        PainelPop.Items.Items[3].Visible := not TipoSimulado(PanAux);
    end
    else begin
        PainelPop.Items.Items[2].Visible := false;
        PainelPop.Items.Items[3].Visible := false;
    end;

    if (not Catalogo.Ativo) or ((Local > 0) and (Catalogo.SemestreFeagri[Local - 1].Consolidado)) then
    begin
     PainelPop.Items.Items[2].Visible := false;
     PainelPop.Items.Items[3].Visible := false;
    end;

end;

procedure TFrmBuilder.MSimuClick(Sender: TObject);
begin
  Simula:= true;
  MatSimulacao:= PanAux.Caption;
  origem:= VerificaGrupos(PanAux);
  FGrade := TFGrade.create(application);
  FGrade.ShowModal;
end;

procedure TFrmBuilder.SimulacaoOk;
begin
 if SimuOk then
 begin
  PanAux.Font.Style:= EstiloPanel(3);
  OrganizaSem(origem);
  if origem > 0 then AtualizaCred(origem);
  OrganizaSem(SemDestinoSimulacao);      
  AtualizaCred(SemDestinoSimulacao);
  MatSimulacao:= ''
 end
   else
   PanAux.Font.Style:= EstiloPanel(1);
end;

procedure TFrmBuilder.MNormalClick(Sender: TObject);
begin
 if Catalogo.TornaNormal(Horarios,PanAux.Caption,VerificaGrupos(PanAux)) then
  PanAux.Font.Style:= EstiloPanel(1);
end;

procedure TFrmBuilder.MHoraClick(Sender: TObject);
begin
    Simula:= false;
    MatSimulacao:= '';
    origem:= VerificaGrupos(PanAux);
 // onEnter - pega o valor do edit antes da possivel alteração do semestre do curso
    FGrade := TFGrade.create(application);
    FGrade.ShowModal;
end;

procedure TFrmBuilder.Trava(Sender: TObject);
var ImgBtn: TBitBtn;
    Local: integer;
begin
    ImgBtn := TBitBtn(Sender);
    Local := verificaGrupos(ImgBtn);
    Catalogo.TravaSemestre(Local);
    ImgBtn.Glyph.LoadFromFile(ImgTrava[BooltoInt(Catalogo.SemestreFeagri[Local-1].Travado)]);

end;

procedure TFrmBuilder.Tranca(Sender: TObject);
var ImgBtn: TBitBtn;
    i, Local: integer;
begin
    ImgBtn := TBitBtn(Sender);
    Local := verificaGrupos(ImgBtn);
    if Catalogo.SemestreFeagri[Local-1].Trancado then
    begin
        Catalogo.DestrancaSemestre(local,Horarios);
        DestroiGrp(GrpSem[high(GrpSem)],1,high(GrpSem));
        OrganizaSem(-2);
    end
    else begin

      if Local = 1 then
      begin
       MessageDlg('Não é possível trancar o 1º semestre', mtWarning, [mbOk], 0);
       exit;
      end;

      if length(GrpSem) = 20 then   // não permite trancar mais de 5 semestres
      begin
       MessageDlg('Não é possível trancar mais semestre', mtWarning, [mbOk], 0);
       exit;
      end;

      Catalogo.TrancaSemestre(Local, Horarios, PreReq);
      CriaGrpCur(high(GrpSem)+1, false,false);
      for i:= -2 to high(GrpSem)+1 do
      begin
          if i > 0 then
          begin
             AtualizaCred(i);
             AtualizaImagemBtn(i);
          end;
           OrganizaSem(i);
       end;
    end;
    
    ImgBtn.Glyph.LoadFromFile(ImgTranca[BooltoInt(Catalogo.SemestreFeagri[Local-1].Trancado)]);

end;

// rotina criada para desabilitar a ação do botão
// como a propriedade enabled some com a imagem, atribui nil para
// a ação do botão para ter o efeito de desabilitar 
procedure TFrmBuilder.DesabilitaBtn(sem: Integer);
begin
  if (not Catalogo.Ativo) or (Catalogo.SemestreFeagri[sem - 1].Consolidado) then
  begin
    GrpSem[sem - 1].Enabled:= False;
  end;
end;

procedure TFrmBuilder.ConsolidadoOk(Sem:integer);
var n:integer;
begin
    if Catalogo.SemestreFeagri[Sem-1].consolidado then begin
        for n:= -2 to high(GrpSem)+1 do
        begin
            if n > 0 then
            begin
                AtualizaCred(n);
                AtualizaImagemBtn(n);
                DesabilitaBtn(n);
  // atualiza a imagem do botão travamento que pode ser alterado na simualção
            end;
            
            OrganizaSem(n);

        end;

        if (Catalogo.Ativo) and (Sem < high(GrpSem)+1) then
        begin
          BtnConsolida.Parent := GrpSem[Sem];
          BtnConsolida.Visible:= True;
        end
        else
          BtnConsolida.Visible:= False;
    end;

      formprincipal.Caption:= 'Aluno(a): '+formprincipal.AluNome
    +  ' - RA: '+formprincipal.AluRA + ' - Status: '+ RetornaStatus(Catalogo.Ativo);
     
end;

procedure TFrmBuilder.Consolida(Sender: TObject);
var   ImgBtn: TBitBtn;
    Local: integer;
begin
    ImgBtn := TBitBtn(Sender);
    Local := verificaGrupos(ImgBtn);
    SemCons:= Local;
    FConsolidacao := TFConsolidacao.Create(application);
    FConsolidacao.ShowModal;
    //Catalogo.SemestreFeagri[Local-1].consolidado:= not Catalogo.SemestreFeagri[Local-1].consolidado;


end;

end.
