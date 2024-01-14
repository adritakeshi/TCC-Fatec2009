unit Aluno3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Buttons, Mask, DBCtrls;

type
  TFAluno = class(TForm)
    LBLnome: TLabel;
    LBLra: TLabel;
    LBLcat: TLabel;
    BTNLupa: TBitBtn;
    SetAlu: TADODataSet;
    BTNnovo: TBitBtn;
    BTNfechar: TBitBtn;
    BTNok: TBitBtn;
    EDTNome: TEdit;
    EDTra: TEdit;
    CMBano: TComboBox;
    BTNAlterar: TBitBtn;
    procedure BTNnovoClick(Sender: TObject);
    procedure BTNfecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BTNLupaClick(Sender: TObject);
    procedure EDTNomeKeyPress(Sender: TObject; var Key: Char);
    procedure EDTraKeyPress(Sender: TObject; var Key: Char);
    procedure BTNAlterarClick(Sender: TObject);
    procedure CMBanoKeyPress(Sender: TObject; var Key: Char);
  private
    function valida_campos():Boolean;
    procedure coloca_ano_cbox(a:_recordset);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAluno: TFAluno;
  RA,a,b:string;
  Alun: _recordset;
  respSQL: _recordset;
  Ano: _recordset;
  confirm,flag:boolean;    //flag true se alteração

  implementation

uses Aluno,principal, Builder;

{$R *.dfm}

//**********************procedimentos auxiliares**********************//
function verifica_letra(a:char): Boolean;
var letra:integer;
    flag:boolean;
Begin
flag:=false;
letra:=ord(a);

if ((letra in [97..122]) or (letra in [65..90]) or (letra = 8)or (letra = 32) or (letra=13)) then
     flag:=true;

Result := flag;

End;

function verifica_numero(a:char): Boolean;
var num:integer;
    flag:boolean;
Begin
num:=ord(a);
flag:=true;

  if not ((num in [48..57]) or (num = 8)) then
    flag:=false;

result:= flag;
End;

procedure mensagem(i:integer);
begin
  case i of
    1: Showmessage('O aluno deve ter um Nome entre 2 e 50 caracteres, por favor verifique');
    2: Showmessage('O aluno deve ter um R.A. entre 2 e 20 caracteres, por favor verifique');
    3: Showmessage('O aluno deve ter um ano de Catálogo, por favor selecione');
    4: ShowMessage('RA já cadastrado');
    5: ShowMessage('Dados gravados com sucesso');
    6: ShowMessage('Dados atualizados com sucesso');

  end;
end;

function TFAluno.valida_campos(): Boolean;
var flag: boolean;
begin
flag:=true;
  if ((EDTnome.Text = '') or (Length(EDTnome.Text) < 2)) then
  begin
    mensagem(1);
    EDTnome.SetFocus;
    flag:=false;
  end
  else if ((EDTra.Text = '') or (Length(EDTra.Text) < 2)) then
  begin
    mensagem(2);
    EDTra.SetFocus;
    flag:=false;
  end
  else if (CMBano.text = '') then
  begin
    mensagem(3);
    CMBano.SetFocus;
    flag:=false;
  end;
result:=flag;
end;

procedure TFAluno.coloca_ano_cbox(a:_recordset);
begin
CMBano.Clear;
  //**** Jogando ano na Combobox
if a.RecordCount <> 0 then
 begin
 a.MoveFirst;
 while (not a.EOF) do
  begin
  CMBano.Items.Add(a.Fields[0].value);
  a.MoveNext;
  end;
 end;
end;


//********************** fim dos procedimentos auxiliares**********************//


procedure TFAluno.FormCreate(Sender: TObject);
begin
Alun:= formprincipal.FEAGRI_Conector.Execute('SELECT * FROM Aluno');
flag:=false;
BTNAlterar.Visible:=False;
EDTnome.Enabled:=False;
CMBano.Enabled:=False;
EDTnome.Color:=RGB(215,228,242);
CMBano.Color:=RGB(215,228,242);
end;


procedure TFAluno.BTNAlterarClick(Sender: TObject);
var acho:boolean;
    i:integer;
    vcat:string;
begin
flag:=true;
BTNalterar.Visible:=false;
BTNnovo.Caption:='&Salvar';
EDTNome.Enabled:=True;
EDTra.Enabled:=False;
CMBano.Enabled:=True;
EDTNome.Color:= clwindow;
EDTra.Color:=RGB(215,228,242);
CMBano.Color:= clwindow;
vcat:=FAluno.CMBano.Items.Strings[FAluno.CMBano.ItemIndex];
ano:=formprincipal.FEAGRI_Conector.Execute('Select distinct CatAno from catalogo, aluno  where Catalogo.CatAno = Aluno.CatCod  and  ( catalogo.CatVig = true or  ( aluno.Alura ='+quotedstr(EDTra.text)+') )   order by CatAno');
coloca_ano_cbox(ano);
    i:=0;
    CMBano.ItemIndex:=0;
    acho:=false;
    while (i <= CMBano.Items.Count-1) or (acho <> true)do
    begin
      CMBano.ItemIndex:=i;
      if  (CMBano.Items.Strings[FAluno.CMBano.ItemIndex] = vcat) then
        acho:=true;
      inc(i);
    end;
  btnfechar.Enabled:= True;
end;

//******Procedimento de BUSCA DE R.A.
procedure TFAluno.BTNLupaClick(Sender: TObject);
begin
CMBano.Clear;
  Tbusca:=TTbusca.Create(Application);
    if (EDTra.Text<>'')then Tbusca.EDbusca.Text:=EDTra.Text;
   Tbusca.ShowModal;
end;

//*****Procedimentos para PERMITIR INCLUSÃO DE DADOS, SALVAR DADOS INSERIDOS E ALTERADOS
procedure TFAluno.BTNnovoClick(Sender: TObject);
var i: integer;
begin
//*****Pegando anos cadastrados
ano:=formprincipal.FEAGRI_Conector.Execute('Select CatAno from catalogo where Catvig = true order by CatAno');

//*****Procedimentos Para INSERIR novos dados
if BTNnovo.Caption='&Novo' then
begin
//limpando residuos de memoria
EDTnome.Clear;
EDTra.Clear;
CMBano.Clear;
//habilitando campos
BTNnovo.Caption:='&Salvar';
flag:=false; // modificação será um insert nao update
EDTnome.Enabled:=true;
EDTnome.SetFocus;
EDTra.Enabled:=true;
CMBano.Enabled:=true;
//colorindo
EDTnome.Color:=clwindow;
EDTra.Color:=clwindow;
CMBano.Color:=clwindow;
//**** Jogando ano na Combobox
coloca_ano_cbox(ano);
end

//Ações para salvar
else if ((BTNnovo.caption = '&Salvar') and (flag=false)) then
 begin
  //Pesquisando para ver s o RA já existe e pegando o ano do catalogo gravado
 respSQL:=formprincipal.FEAGRI_Conector.Execute('Select AluRA,CatCod,AluNom from Aluno where AluRA='+quotedstr(EDTra.Text));
 //SALVANDO NOVOS DADOS
 //****Procedimentos para GRAVAR UM R.A. AINDA NÃO CADASTRADO
  if (respSQL.recordcount <> 0) then
  begin
  //**** Procedimento para R.A. já cadastrado
  mensagem(4);
  EDTra.SetFocus;
  end
 else if valida_campos() then
  begin
  //Mensagem de confirmação dos dados
  confirm:=MessageDlg('Os dados digitados estão corretos? '+#13+' Nome: '+EDTnome.Text+'  RA:  '+EDTra.Text+'  Catálogo:  '+CMBano.Text+#13+'Após a Confirmação o R.A. NÃO poderão ser alterados', mtInformation, [mbYes, mbNo], 0)=idYes;
  if confirm then
  begin
    formprincipal.FEAGRI_Conector.Execute('Insert into Aluno (AluRA, AluNom,'+
      ' CatCod, SemLet,Status) values('+quotedstr(EDTra.Text) + ', ' +
      quotedstr(EDTnome.Text) + ', ' + CMBano.Text+', 1, 1)');
    //****Cadastrando Cat_Mat_TUR_HIST
//MUDEI ESSE SELECT YU
    Alun:=formprincipal.FEAGRI_Conector.Execute('SELECT CMTCod, MatSem, cm.CMCod from ' +
      ' Cat_Mat cm, Cat_Mat_Tur cmt where TurCod = 1 and cm.CMCod = cmt.CMCod and CatCod = ' +
      CMBAno.Text);
    Alun.movefirst;
    while (not Alun.EOF) do
      begin
//mudei esse insert Yu
      formprincipal.FEAGRI_Conector.Execute('Insert into cat_mat_tur_hist ' +
        '(HistCod, CMTCod, SemCur, AluRA, CMCod) values (3,' +
        inttostr(Alun.Fields[0].Value) + ', ' +
        inttostr(Alun.Fields[1].Value) + ', ' + quotedstr(EDTra.text)+', '
        + inttostr(Alun.Fields[2].Value) + ')');
      Alun.movenext;
      end;

       Alun:=formprincipal.FEAGRI_Conector.Execute('SELECT MatSem, CMCod from ' +
      ' Cat_Mat where MatSem = 0  and CatCod = ' + CMBAno.Text);
    Alun.movefirst;
    
    while (not Alun.EOF) do
      begin
//mudei esse insert Yu
      formprincipal.FEAGRI_Conector.Execute('Insert into cat_mat_tur_hist ' +
        '(HistCod, CMTCod, SemCur, AluRA, CMCod) values (3, null, ' +
        inttostr(Alun.Fields[0].Value) + ', ' + quotedstr(EDTra.text)+', '
        + inttostr(Alun.Fields[1].Value) + ')');
      Alun.movenext;
      end;  


//Inseri esse For Yu
    For i := 1 to 15 do
    begin
      FormPrincipal.Feagri_Conector.Execute('Insert into Semestre (SemCod,' +
        ' AluRA) values (' + inttostr(i) + ', ' + quotedstr(EDTra.text) + ')');
    end;

    mensagem(5);
    BTNnovo.Caption:='&Novo';
    //desabilitando
    EDTNome.Enabled:=False;
    EDTra.Enabled:=False;
    CMBano.Enabled:=False;
    //colorindo^^
    EDTNome.Color:=RGB(215,228,242);
    EDTra.Color:=RGB(215,228,242);
    CMBano.Color:=RGB(215,228,242);

    btnfechar.Enabled:= True;

    end;
  end;
 end
else
//Salvando ALTERAÇÕES
if (flag=true)then begin
BTNAlterar.Visible:=false;
respSQL:=formprincipal.FEAGRI_Conector.Execute('Select AluRA,CatCod,AluNom from Aluno where AluRA='+quotedstr(EDTra.Text));
if (respSQL.Fields[1].Value<>CMBano.Text) then
begin
confirm:=MessageDlg('Alterações no ANO do catálogo provocarão perda de TODOS os dados do histório', mtInformation, [mbYes, mbNo], 0)=idYes;
if confirm then
 begin
 formprincipal.FEAGRI_Conector.Execute('Update Aluno set Catcod= '+CMBano.Text+' , AluNom = '+quotedstr(EDTnome.Text)+'where AluRA= '+quotedstr(EDTra.Text));
 //Limpando Histórico do aluno
 formprincipal.FEAGRI_Conector.Execute('Delete * from cat_mat_tur_hist where AluRA= '+ quotedstr(EDTra.Text));
 //****Cadastrando Cat_Mat_TUR_HIST
 Alun:=formprincipal.FEAGRI_Conector.Execute('Select CMCod from cat_mat where catcod= ' + CMBAno.Text);
 Alun.movefirst;
 while (not Alun.EOF) do
  begin
  formprincipal.FEAGRI_Conector.Execute('Insert into cat_mat_tur_hist (HistCod,CMCod,AluRA) values (3,'+inttostr(Alun.Fields[0].Value)+','+quotedstr(EDTra.text)+')');
  Alun.movenext;
  end;
 mensagem(6);
 BTNnovo.Caption:='&Novo';
 EDTnome.Enabled:=False;
 CMBano.Enabled:=False;
 EDTnome.Color:=RGB(215,228,242);
 CMBano.Color:=RGB(215,228,242);
 end;
end
else  if  (respSQL.Fields[2].Value<>EDTnome.Text) then
  begin
  formprincipal.FEAGRI_Conector.Execute('Update Aluno set AluNom = '+quotedstr(EDTnome.Text)+'where AluRA= '+quotedstr(EDTra.Text));
  mensagem(6);
  BTNnovo.Caption:='&Novo';
  EDTnome.Enabled:=False;
  CMBano.Enabled:=False;
  EDTnome.Color:=RGB(215,228,242);
  CMBano.Color:=RGB(215,228,242);
  end
else
  begin
  BTNnovo.Caption:='&Novo';
  EDTnome.Enabled:=False;
  CMBano.Enabled:=False;
  EDTnome.Color:=RGB(215,228,242);
  CMBano.Color:=RGB(215,228,242);
  end;
end;
end;

procedure TFAluno.CMBanoKeyPress(Sender: TObject; var Key: Char);
begin
if key=chr(13) then
  btnnovo.SetFocus;
end;

procedure TFAluno.EDTNomeKeyPress(Sender: TObject; var Key: Char);
begin
  if (not verifica_letra(key)) then
     key:=chr(0)
  else if key = chr(13) then
       EDTra.SetFocus;
end;

procedure TFAluno.EDTraKeyPress(Sender: TObject; var Key: Char);
begin
   if ((not verifica_letra(key)) and (not verifica_numero(key))) then
      key:=chr(0)
   else if key = chr(13) then
      CMBano.SetFocus;
end;

procedure TFAluno.BTNfecharClick(Sender: TObject);
begin
if ((BTNnovo.Caption='&Novo') and (EDTra.text=''))then
begin
 MessageDlg('Nenhum aluno foi selecionado. Não é possível iniciar a simulação?', mtWarning, [mbOk], 0);
end
else
begin
 formprincipal.AluRA:= EDTra.text;
 formprincipal.AluAno:= strtoint(CMBAno.Text);
 formprincipal.AluNome:= EDTNome.Text;
 FrmBuilder:= TFrmBuilder.Create(Application);
 formprincipal.Simulacao1.enabled:= false;
 formprincipal.Salvar1.Enabled:= true;
 formprincipal.Reset1.Enabled:= true;
 close;
end;
end;

procedure TFAluno.FormClose(Sender: TObject; var Action: TCloseAction);
begin
action:=cafree;
end;
end.
