unit frmCadMat2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DBCtrls, StdCtrls, Mask, ComCtrls, ADODB, DB, Buttons,
  ExtCtrls;

type
  TFCadMat = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Label12: TLabel;
    Label11: TLabel;
    DBGrid2: TDBGrid;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Button1: TButton;
    Button2: TButton;
    prereq: TGroupBox;
    Label1: TLabel;
    Label6: TLabel;
    ListBox2: TListBox;
    ListBox1: TListBox;
    Gravar: TButton;
    Materia: TLabel;
    Label3: TLabel;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Label15: TLabel;
    MatSemLet: TDBEdit;
    MatCred: TDBEdit;
    DBMemo1: TDBMemo;
    MatCod: TDBEdit;
    MatNom: TDBEdit;
    CSalvar: TButton;
    Limpar: TButton;
    CNovo: TButton;
    DBGrid3: TDBGrid;
    Alterar: TButton;
    Excluir: TButton;
    MatCP: TDBEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label2: TLabel;
    CatAno: TLabel;
    MatSemAno: TDBEdit;
    DataSource1: TDataSource;
    ADODataSet1: TADODataSet;
    ADODataSet1MatCod: TWideStringField;
    ADODataSet2: TADODataSet;
    ADODataSet2CMCod: TAutoIncField;
    ADODataSet2CatCod: TIntegerField;
    ADODataSet2MatCod: TWideStringField;
    ADODataSet2MatNom: TWideStringField;
    ADODataSet2MatCred: TIntegerField;
    ADODataSet2MatSemOfer: TIntegerField;
    ADODataSet2MatSem: TIntegerField;
    ADODataSet2MatDef: TMemoField;
    ADODataSet2MatCP: TIntegerField;
    DataSource2: TDataSource;
    ADODataSet3: TADODataSet;
    DataSource3: TDataSource;
    ADOQuery3: TADOQuery;
    ADOQuery3MatCod: TWideStringField;
    ADOQuery3DiaHor: TWideStringField;
    ADOQuery3IniHor: TWideStringField;
    ADOQuery3CMTHCod: TAutoIncField;
    DataSource4: TDataSource;
    ADOQuery4: TADOQuery;
    ADOQuery4MatCod: TWideStringField;
    ADOQuery4MatNom: TWideStringField;
    ADOQuery4MatSemOfer: TIntegerField;
    ADOQuery4MatSem: TIntegerField;
    ADOQuery4MatCred: TIntegerField;
    ADOQuery4MatCP: TIntegerField;
    ADODataSet: TADODataSet;
    DataSource: TDataSource;
    ADOQuery: TADOQuery;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Add: TBitBtn;
    Remove: TBitBtn;
    ADOQuery4HorOk: TBooleanField;
    Cancelar: TButton;
    Label9: TLabel;
    Creditos: TLabel;
    procedure CancelarClick(Sender: TObject);
    procedure LimparClick(Sender: TObject);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ExcluirClick(Sender: TObject);
    procedure DBGrid3CellClick(Column: TColumn);
    procedure AlterarClick(Sender: TObject);
    procedure GravarClick(Sender: TObject);
    procedure RemoveClick(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CNovoClick(Sender: TObject);
    procedure CSalvarClick(Sender: TObject);
    procedure CarregaCombo;
    procedure PreencheLista;
    procedure MatEnabledTrue;
    procedure MatEnabledFalse;
    procedure CarregaGrid;
    function CamposOK: boolean;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Cancela;


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCadMat: TFCadMat;
  Mat: String;
  Alt: Boolean;

implementation

uses frmcadcat2, principal;

{$R *.dfm}

procedure TFCadMat.CSalvarClick(Sender: TObject);
var rs:_recordset;
CMCod, Cred: integer;
begin

  if CamposOK = false then
    exit;

  //Se for alteração, então atualiza
  if (Alt = true) and (Mat = MatCod.Text) then
  begin
    //Procura o CMCod na tabela Cat_Mat
    rs := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat where CatCod = ' +
                                  CatAno.Caption + ' and MatCod like ' +
                                 quotedstr(MatCod.text));


    CMCod :=  rs.Fields[0].Value;

    //Verifica quantos horários foram gravados pra essa matéria
    rs := formprincipal.Feagri_Conector.execute('Select cm.MatCod, DiaHor, IniHor, CMTHCod from ' +
                                 'Cat_Mat_Tur_Hor cmth, Cat_Mat cm, semana where ' +
                                 'cmth.CMCod = cm.CMCod and DiaHor = DiaSemana ' +
                                 'and cm.CMCod = ' +
                                  IntToStr(CMCod) + ' order by SemCod, IniHor;');


    if (rs.eof <> true and rs.bof <> true) then
    begin

    if (rs.RecordCount = strtoint(MatCred.text)) or (RadioButton2.Checked = true) then

      formprincipal.Feagri_Conector.Execute('Update Cat_Mat set HorOk = true where CMCod = ' +
                                             IntToStr(CMCod));

    if (rs.RecordCount <= strtoint(MatCred.text)) and (RadioButton1.Checked = true) then
      formprincipal.Feagri_Conector.Execute('Update Cat_Mat set HorOk = false where CMCod = ' +
                                             IntToStr(CMCod));


    if (rs.RecordCount > strtoint(MatCred.text)) then
    begin
      ShowMessage('Esta alteração não pode ser realizada devido à quantidade de ' +
                   'Horários já cadastrados. Exclua os horários e faça a ' +
                   'alteração novamente.');
      Cancela;
     exit;
    end;
    end;

    //Se RadioButton1.Checked = true, então a matéria é obrigatória
    if RadioButton1.Checked then
    begin
      if strtoint(MatSemLet.Text) mod 2 = 0 then
        adodataset2.Fields.Fields[5].AsInteger := 2
      else
        adodataset2.Fields.Fields[5].AsInteger := 1;
    end
    else
    begin
      adodataset2.Fields.Fields[5].AsInteger := 6;
    end;


    ADODataSet2.Post;
    ShowMessage('Ateração feita com sucesso');
  end
  //Se não for alteração, grava
  else
  begin
  rs := formprincipal.Feagri_Conector.Execute('select MatCod from Materias where MatCod like ' +
                                quotedstr(MatCod.Text) + ';');
  if rs.EOF then
  begin
    adodataset1.close;
    adodataset1.Open;
    adodataset1.Insert;
    adodataset1.Fields.Fields[0].AsString := MatCod.Text;
    adodataset1.post;
  end;

  rs := formprincipal.Feagri_Conector.execute('Select * from Cat_Mat where' +
                               ' MatCod like ' + quotedstr(MatCod.Text) +
                               ' and CatCod = ' + CatAno.Caption);
  if not rs.eof then
  begin
    showmessage('Essa matéria já existe nesse catálogo');
    matcod.SetFocus;
    exit;
  end;
  adodataset2.Fields.Fields[1].AsInteger := strtoint(CatAno.Caption);
  //Se RadioButton1.Checked = true, então a matéria é obrigatória
  if RadioButton1.Checked then
  begin
    if strtoint(MatSemLet.Text) mod 2 = 0 then
      adodataset2.Fields.Fields[5].AsInteger := 2
    else
      adodataset2.Fields.Fields[5].AsInteger := 1;
  end
  else
    adodataset2.Fields.Fields[5].AsInteger := 6;

  adodataset2.post;


  if RadioButton2.Checked then
  begin
    //Procura o CMCod na tabela Cat_Mat
    rs := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat where' +
       ' CatCod = ' + CatAno.Caption + ' and MatCod like ' +
       quotedstr(MatCod.text));
    CMCod :=  rs.Fields[0].Value;   
    formprincipal.Feagri_Conector.Execute('Update Cat_Mat set HorOk = true' +
       ' where CMCod = ' + IntToStr(CMCod));
  end;

  ShowMessage('Matéria salva com sucesso');
  end;

  Alt := false;

  CSalvar.enabled := false;
  Limpar.Enabled := false;
  Alterar.Enabled := true;
  Excluir.Enabled := true;
  CNovo.Enabled := true;

  CarregaGrid;
  MatEnabledFalse;



end;

procedure TFCadMat.CNovoClick(Sender: TObject);
begin

  adodataset1.close;
  adodataset1.open;
  adodataset1.Insert;

  adodataset2.Close;
  adodataset2.open;
  adodataset2.Insert;

  MatEnabledTrue;

  CSalvar.Enabled := true;
  Limpar.Enabled := true;
  Alterar.Enabled := false;
  Excluir.Enabled := false;
  CNovo.enabled := false;

  ADODataSet2.Fields.Fields[8].AsInteger := 0;

  radiobutton1.Checked := true;
  cancelar.enabled := true;
end;

procedure TFCadMat.MatEnabledTrue;
begin
  MatCod.Enabled := true;
  MatCod.Color := RGB (255,255,255);
  MatNom.Enabled := true;
  MatNom.Color := RGB (255,255,255);
  MatCred.Enabled := true;
  MatCred.Color := RGB (255,255,255);
  MatSemLet.Enabled := true;
  MatSemLet.Color := RGB (255,255,255);
  DBMemo1.Enabled := true;
  DBMemo1.Color := RGB (255,255,255);
  MatCP.Enabled := true;
  MatCP.Color := RGB (255,255,255);
  RadioButton1.Enabled := true;
  RadioButton2.Enabled := true;

  MatCod.setfocus;
end;

procedure TFCadMat.MatEnabledFalse;
begin
  MatCod.Enabled := false;
  MatCod.Color := RGB (215,228,242);
  MatNom.Enabled := false;
  MatNom.Color := RGB (215,228,242);
  MatCred.Enabled := false;
  MatCred.Color := RGB (215,228,242);
  MatSemLet.Enabled := false;
  MatSemLet.Color := RGB (215,228,242);
  DBMemo1.Enabled := false;
  DBMemo1.Color := RGB (215,228,242);
  MatCP.Enabled := false;
  MatCP.Color := RGB (215,228,242);
  gravar.Enabled := false;
  RadioButton1.Enabled := false;
  RadioButton2.Enabled := false;
  Cancelar.Enabled := false;
end;


procedure TFCadMat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if CSalvar.Enabled = true then
  begin
    if Messagedlg('Deseja salvar os dados da Matéria?',
                  mtinformation, [mbyes, mbno], 0) = idYes then
    begin
      Action := Canone;
      CSalvarClick(Sender);
    end
    else
      Action:= Cafree;
  end
  else
  if gravar.Enabled = true then
  begin
    if Messagedlg('Deseja salvar as alterações feitas nos pré-requisitos?',
                  mtinformation, [mbyes, mbno], 0) = idYes then
      GravarClick(Sender)
    else
      Action:= Cafree;
  end
  else
    Action:= Cafree;
end;

procedure TFCadMat.FormCreate(Sender: TObject);
begin

  MatSemAno.Visible := false;

  pagecontrol1.ActivePageIndex := 0;

  dbgrid3.Selectedindex := 5;
  dbgrid2.SelectedIndex := 3;

  Alt := false;

  CatAno.Caption := inttostr(2010);

  MatEnabledFalse;

  CarregaCombo;

  ADOQuery3.Close;
  ADOQuery3.SQL.Text := 'Select cm.MatCod, DiaHor, IniHor, CMTHCod from ' +
                        'Cat_Mat_Tur_Hor cmth, Cat_Mat cm, semana where ' +
                        'cmth.CMCod = cm.CMCod and DiaHor = DiaSemana ' +
                        'and cm.MatCod = ' +
                         quotedstr(Materia.Caption) + ' order by SemCod, IniHor;';
  ADOQuery3.Open;

  PreencheLista;

  CarregaGrid;

  if (FCadCat.DBCheckBox1.checked = true) then
    CNovo.Enabled := false;

  CSalvar.enabled := false;
  Limpar.Enabled := false;
  Alterar.Enabled := false;
  Excluir.Enabled := false;

  MatCod.TabOrder := 0;
  MatNom.TabOrder := 1;
  MatCred.TabOrder := 2;
  MatSemLet.TabOrder := 3;
  MatCP.TabOrder := 4;
  DBMemo1.TabOrder := 5;
  CNovo.TabOrder := 6;
  Limpar.TabOrder := 7;
  CSalvar.TabOrder := 8;
  Alterar.TabOrder := 9;
  Excluir.TabOrder := 10;
  DBGrid3.TabOrder := 11;

  ComboBox1.TabOrder := 0;
  ComboBox2.TabOrder := 1;
  Button1.TabOrder := 2;
  DBGrid2.TabOrder := 3;
  Button2.TabOrder := 4;
  ListBox1.TabOrder := 5;
  Add.TabOrder := 6;
  Remove.TabOrder := 7;
  ListBox2.TabOrder := 8;
  Gravar.TabOrder := 9;

end;


procedure TFCadMat.CarregaCombo;
var rs:_recordset;
begin
    rs := formprincipal.Feagri_Conector.Execute('Select * from Semana order by SemCod');
    ComboBox1.Clear;
    while not rs.EOF do
    begin
      ComboBox1.Items.Add(RS.Fields[1].Value);
      rs.MoveNext;
    end;
    rs := formprincipal.Feagri_Conector.Execute('Select * from Horario order by HorIni');
    ComboBox2.Clear;
    while not rs.EOF do
    begin
      ComboBox2.Items.Add(RS.Fields[0].Value);
      rs.MoveNext;
    end;
end;

procedure TFCadMat.CarregaGrid;
var rs:_recordset;
    CMCod: integer;
begin
  rs := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat where CatCod = ' +
                                CatAno.Caption + ' and MatCod like ' +
                                quotedstr(Materia.Caption));
  if not rs.eof then
  begin
  CMCod :=  rs.Fields[0].Value;
  ADOQuery3.Close;
  ADOQuery3.SQL.Text := 'Select cm.MatCod, DiaHor, IniHor, CMTHCod from ' +
                        'Cat_Mat_Tur_Hor cmth, Cat_Mat cm, semana where ' +
                        'cmth.CMCod = cm.CMCod and DiaHor = DiaSemana ' +
                        'and cm.CMCod = ' +
                         inttostr(CMCod) + ' order by SemCod, IniHor;';

  ADOQuery3.Open;
  end;
  ADOQuery4.Close;
  ADOQuery4.sql.Text := 'Select MatCod, MatNom, MatSemOfer, MatSem, ' +
                        'MatCred, MatCP, HorOk from Cat_Mat where CatCod = ' +
                         CatAno.Caption + ' order by MatCod, MatSem, MatSemOfer;';
  ADOQuery4.Open;


end;


//  if fcadcat.Vigente = true then
//    CNovo.enabled := false;

procedure TFCadMat.PageControl1Change(Sender: TObject);
begin
  materia.caption := MatCod.Text;
  creditos.Caption := MatCred.Text;
  if fcadcat.Vigente = true then
  begin
    CNovo.Enabled := false;
    Limpar.Enabled := false;
    CSalvar.Enabled := false;
    Alterar.Enabled := false;
    Excluir.Enabled := false;

    Button1.Enabled := false;
    Button2.Enabled := false;
    //Gravar.Enabled := false;
    Add.Enabled := false;
    Remove.Enabled := false;

    ComboBox1.Enabled := false;
    ComboBox2.Enabled := false;
  end
  else
  begin
    ComboBox1.Enabled := true;
    ComboBox2.Enabled := true;
    Add.enabled := true;
    Remove.Enabled := true;
  end;

  if (pagecontrol1.ActivePageIndex = 0) and (gravar.enabled = true) then
  begin
    if Messagedlg('Deseja salvar as alterações feitas nos pré-requisitos?',
                  mtinformation, [mbyes, mbno], 0) = idYes then
      GravarClick(Sender);
  end;

  if pagecontrol1.ActivePageIndex = 1 then
  begin
    if (matcod.text = '') and (MatCod.Enabled = false) then
    begin
      showmessage('Escolha uma mátéria');
      pagecontrol1.ActivePageIndex := 0;
    end
    else
    if matcod.enabled = true then
    begin
      showmessage('Salve a matéria ' + matcod.text + ' antes de definir' +
                  #13 + ' seu horário e pré-requisito');
      pagecontrol1.ActivePageIndex := 0;
    end
    else
    begin
      button1.Enabled := false;
      button2.Enabled := false;
      Materia.Caption := MatCod.text;
      CarregaCombo;
      PreencheLista;
      gravar.Enabled := false;
      if RadioButton2.Checked = true then
      begin
        ComboBox1.Enabled := false;
        ComboBox2.Enabled := false;
        DBGrid2.Enabled := false;
      end
      else
      begin
        ComboBox1.Enabled := true;
        ComboBox2.Enabled := true;
        DBGrid2.Enabled := true;
      end;
    end;
  end;

  dbgrid3.Selectedindex := 5;
  dbgrid2.Selectedindex := 3;

  CarregaGrid;

end;


Procedure TFCadMat.PreencheLista;
var rs:_recordset;
    CMCod: integer;
begin
  //Preenche a ListBox de Pré-Requisitos
  //Procura o CMCod
  rs := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat where CatCod = ' +
                                CatAno.Caption + ' and MatCod like ' +
                                quotedstr(Materia.Caption));
  if not rs.eof then
  begin
  CMCod :=  rs.Fields[0].Value;
  rs := formprincipal.Feagri_Conector.execute('Select MatCod from Pre_Req pr, Cat_MAt cm where ' +
                               'cm.CMCod = pr.CMPCod and pr.CMCod = ' +
                                inttostr(CMCod));
  ListBox2.Clear;
  while not rs.eof do
  begin
    listbox2.Items.Add(RS.Fields[0].Value);
    rs.movenext;
  end;

  if (CMCod <> -1) then
  begin
  //Preenche a listBox de Matérias
  rs := formprincipal.Feagri_Conector.Execute('Select MatCod from Cat_Mat where CatCod = ' +
                                CatAno.Caption + ' and MatCod Not in' +
                               ' (select MatCod from cat_mat cm, Pre_req pr' +
                               ' where cm.CMCod = pr.CMPCod and catcod = ' +
                               CatAno.Caption + '  and pr.CMCod = ' +
                               inttostr(CMCod) + ') and MatCod <> ' +
                               quotedstr(Materia.caption) + ';');
  listbox1.Clear;
  while not rs.EOF do
  begin
    listbox1.Items.Add(RS.Fields[0].Value);
    rs.movenext;
  end;
  end;
  end;
End;

//Insere os Dados necessários nas tabelas: Cat_Mat_Tur e Cat_Mat_Tur_Hor
procedure TFCadMat.Button1Click(Sender: TObject);
var rs:_RecordSet;
    CMCod, CMTCod, Cred: integer;
begin

  //Procura o CMCod na tabela Cat_Mat
  rs := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat where CatCod = ' +
                                CatAno.Caption + ' and MatCod like ' +
                                quotedstr(Materia.Caption));
  CMCod :=  rs.Fields[0].Value;

  //Verifica quantidade de Crédito
  rs := formprincipal.Feagri_Conector.Execute('Select MatCred from Cat_Mat where CMCod = ' +
                                  IntToStr(CMCod));

  Cred := rs.Fields[0].value;

  //Verifica quantos horários foram gravados pra essa matéria
  rs := formprincipal.Feagri_Conector.execute('Select cm.MatCod, DiaHor, IniHor, CMTHCod from ' +
                               'Cat_Mat_Tur_Hor cmth, Cat_Mat cm, semana where ' +
                               'cmth.CMCod = cm.CMCod and DiaHor = DiaSemana ' +
                               'and cm.CMCod = ' +
                                IntToStr(CMCod) + ' order by SemCod, IniHor;');



  if rs.RecordCount >= Cred then
  begin
    ShowMessage('Esta matéria atingiu a quantidade de créditos requeridos.');
    exit;
  end;


  if combobox1.Text = '' then
  begin
    showmessage('Escolha um dia da semana');
    combobox1.SetFocus;
    exit;
  end;

  if combobox2.Text = '' then
  begin
    showmessage('Escolha um horário');
    combobox2.SetFocus;
    exit;
  end;


  rs := formprincipal.Feagri_Conector.Execute('SELECT MatCod from cat_mat_tur_hor cmth,' +
                               ' cat_mat cm where cmth.CMCod = cm.CMCod' +
                               ' and catcod = ' + CatAno.Caption +
                               ' and DiaHor like ' + quotedstr(ComboBox1.Text) +
                               ' and inihor like ' + quotedstr(ComboBox2.Text) +
                               ' and MatSemOfer = ' + MatSemAno.text +
                               ' and Matsem = ' + MatSemLet.text);
  if not rs.eof then
  begin
    showmessage('A Matéria ' + rs.Fields[0].Value + ' já está cadastrada nesse horário');
    Combobox1.SetFocus;
    exit;
  end;

  //Vê se já existe o vínculo entre Turma e Matéria do Catálogo
  rs := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat_Tur where TurCod = 1 and '
                                + 'CMCod = ' + IntToStr(CMCod));
  //Se não existir o vínculo, ele é criado
  if rs.eof then
  formprincipal.Feagri_Conector.Execute('Insert into Cat_Mat_Tur (CMCod, TurCod) values ('
                          + inttostr(CMCod) + ', 1)');

  //Procura o CMTCod gerado na tabela Cat_Mat_Tur pela inserção do vínculo acima
  rs := formprincipal.Feagri_Conector.execute('Select * from Cat_Mat_Tur where CMCod = ' +
                                IntToStr(CMCod) + ' and TurCod = 1');
  CMTCod := rs.fields[0].value;
  //Verifica se a tabela Cat_Mat_Tur_Hor possui o registro

  rs := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat_Tur_Hor where' +
                               ' IniHor like ' + quotedstr(ComboBox2.Text) +
                               ' and DiaHor like ' + quotedstr(ComboBox1.Text) +
                               ' and CMCod = ' + IntToStr(CMCod) +
                               ' and CMTCod = ' + IntToStr(CMTCod) + ';');
  //Se não possuir, ele é criado.
  if rs.eof then
  formprincipal.Feagri_Conector.Execute('Insert into Cat_Mat_Tur_Hor (IniHor, DiaHor, CMCod,' +
                         ' CMTCod) values ('
                         + quotedstr(ComboBox2.Text) + ', '
                         + quotedstr(ComboBox1.Text) + ', '
                         + IntToStr(CMCod) + ', '
                         + IntToStr(CMTCod) + ')')
  else
  begin
    ShowMessage('Essa Matéria já está cadastrada neste horário.');
    combobox1.SetFocus;
    exit;
  end;

    ADOQuery3.Close;
    ADOQuery3.SQL.Text := 'Select cm.MatCod, DiaHor, IniHor, CMTHCod from ' +
                          'Cat_Mat_Tur_Hor cmth, Cat_Mat cm, semana where ' +
                          'cmth.CMCod = cm.CMCod and DiaHor = DiaSemana ' +
                          'and cm.CMCod = ' +
                           IntToStr(CMCod) + ' order by SemCod, IniHor;';
    ADOQuery3.Open;

    if ADOQuery3.RecordCount = Cred then
    begin
      formprincipal.Feagri_Conector.Execute('Update Cat_Mat set HorOk = true where CMCod = ' +
                              IntToStr(CMCod));
    end;

end;


{procedure TForm2.VerDependencias;
var rs:_recordset;
    CMCod, CMTCod: integer;
    prereq, horario: boolean;
Begin
//Vê se há alguma dependência dos horários e dos pré-requisitos para poder excluir.


  rs := ADOConnection1.Execute('Select * from Cat_Mat where CatCod = ' +
                                CatAno.Caption + ' and MatCod like ' +
                                quotedstr(Materia.Caption));
  CMCod :=  rs.Fields[0].Value;

//Verifica se é pré-requisito
  rs := ADOConnection1.execute('Select * from pre_req where CMCod = '
                               + inttostr(CMCod) + ' or CMPCod = '
                               + inttostr(CMCod));
  if not rs.EOF then
    exit;

//Verifica se tem horário
  rs := ADOConnection1.Execute('Select cm.MatCod, DiaHor, IniHor, CMTHCod from ' +
                               'Cat_Mat_Tur_Hor cmth, Cat_Mat cm, semana where ' +
                               'cmth.CMCod = cm.CMCod and DiaHor = DiaSemana ' +
                               'and cm.CMCod = ' +
                                inttostr(CMCod) + ' order by SemCod, IniHor;');
  if rs.recordcount > 1 then
   exit;

   if rs.EOF then
   showmessage ('nada');

  rs := ADOConnection1.execute('Select * from Cat_Mat_Tur where CMCod = ' +
                                IntToStr(CMCod) + ' and TurCod = 1');
    CMTCod := rs.fields[0].value;

    ADOConnection1.Execute('Delete * from Cat_Mat_Tur where' +
                           ' CMCod = ' + IntToStr(CMCod) +
                           ' and CMTCod = ' + IntToStr(CMTCod) +
                           ' and TurCod = 1');

 {//Vê se já existe o vínculo entre Turma e Matéria do Catálogo
  rs := ADOConnection1.Execute('Select * from Cat_Mat_Tur where TurCod = 1 and '
                                + 'CMCod = ' + IntToStr(CMCod));

  // Se já existir o vínculo, ele é excluído
  if not rs.eof then
  begin}
    //Procura o CMTCod gerado na tabela Cat_Mat_Tur pela inserção do vínculo acima

//End; }

procedure TFCadMat.Button2Click(Sender: TObject);
var rs:_recordset;
    CMCod, CMTCod: integer;
begin
  if DBGrid2.DataSource.DataSet.Fields.Fields[3].AsString = '' then
  begin
    showmessage('Escolha um horário para poder excluí-lo');
    exit;
  end;

   formprincipal.Feagri_Conector.Execute('Delete * from cat_mat_tur_hor where CMTHCod like '
            + quotedstr(DBGrid2.DataSource.DataSet.Fields.Fields[3].AsString));

      rs := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat where CatCod = ' +
                                CatAno.Caption + ' and MatCod like ' +
                                quotedstr(Materia.Caption));
  CMCod :=  rs.Fields[0].Value;
    //Verifica se tem horário
  rs := formprincipal.Feagri_Conector.Execute('Select cm.MatCod, DiaHor, IniHor, CMTHCod from ' +
                               'Cat_Mat_Tur_Hor cmth, Cat_Mat cm, semana where ' +
                               'cmth.CMCod = cm.CMCod and DiaHor = DiaSemana ' +
                               'and cm.CMCod = ' +
                                inttostr(CMCod) + ' order by SemCod, IniHor;');
  if rs.eof then
  begin
  rs := formprincipal.Feagri_Conector.execute('Select * from Cat_Mat_Tur where CMCod = ' +
                                IntToStr(CMCod) + ' and TurCod = 1');
    CMTCod := rs.fields[0].value;

    formprincipal.Feagri_Conector.Execute('Delete * from Cat_Mat_Tur where' +
                           ' CMCod = ' + IntToStr(CMCod) +
                           ' and CMTCod = ' + IntToStr(CMTCod) +
                           ' and TurCod = 1');

  end;
  //Atualiza o DBGrid3
    ADOQuery3.Close;
    ADOQuery3.SQL.Text := 'Select cm.MatCod, DiaHor, IniHor, CMTHCod from ' +
                          'Cat_Mat_Tur_Hor cmth, Cat_Mat cm, semana where ' +
                          'cmth.CMCod = cm.CMCod and DiaHor = DiaSemana ' +
                          'and cm.CMCod = ' +
                           IntToStr(CMCod) + ' order by SemCod, IniHor;';
    ADOQuery3.Open;

    formprincipal.Feagri_Conector.Execute('Update Cat_Mat set HorOk = false where CMCod = ' +
                            IntToStr(CMCod));

end;

procedure TFCadMat.AddClick(Sender: TObject);
var a:string;
    b:integer;
begin
  if (Listbox1.ItemIndex) = -1 then
    exit
  else
  begin
    a := ListBox1.Items[Listbox1.itemindex];
    b := Listbox1.Items.IndexOf(a);
    ListBox2.items.Add(a);
    ListBox1.Items.Delete(b);
    gravar.Enabled := true;
  end;
end;

procedure TFCadMat.RadioButton1Click(Sender: TObject);
begin
  if (RadioButton1.Checked = true) and (RadioButton1.Enabled = true) then
  begin
    MatSemLet.text := '';
    MatSemLet.Enabled := true;
    MatSemLet.Color := RGB(255,255,255);
  end;
end;

procedure TFCadMat.RadioButton2Click(Sender: TObject);
begin
  if (RadioButton2.Checked = true) and (RadioButton2.Enabled = true) then
  begin
    MatSemLet.text := inttostr(0);
    MatSemLet.Enabled := false;
    MatSemLet.Color := RGB(215,228,242);
  end;
end;

procedure TFCadMat.RemoveClick(Sender: TObject);
var a:string;
    b:integer;
begin
  if (Listbox2.ItemIndex) = -1 then
    exit
  else
  begin
    a := ListBox2.Items[Listbox2.itemindex];
    b := Listbox2.Items.IndexOf(a);
    ListBox1.items.Add(a);
    ListBox2.Items.Delete(b);
    gravar.enabled := true;
  end;

  If (Listbox2.ItemIndex) = -1 then
    gravar.enabled := false;

end;

procedure TFCadMat.GravarClick(Sender: TObject);
var i, CMCod, CMPCod: integer;
    rs:_recordset;

begin
  if (Listbox2.Count > 0) then
  begin
    For i := 0 to ListBox2.count - 1 do
    begin
      //Procura o CMCod
      rs := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat where CatCod = ' +
                                    CatAno.Caption + ' and MatCod like ' +
                                    quotedstr(Materia.Caption));
      CMCod :=  rs.Fields[0].Value;

      //Procura o CMPCod
      rs := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat where CatCod = ' +
                                    CatAno.Caption + ' and MatCod like ' +
                                    quotedstr(ListBox2.Items[i]));
      CMPCod :=  rs.Fields[0].Value;

      rs := formprincipal.Feagri_Conector.Execute('Select * from Pre_Req where CMCod = ' +
                                    inttostr(CMCod) + ' and CMPCod = ' +
                                    inttostr(CMPCod));

      if rs.EOF then
      begin
        formprincipal.Feagri_Conector.Execute('insert into Pre_Req values (' + inttostr(CMCod)
                               + ', '+ inttostr(CMPCod) + ')');
      end;
    end;
  end;

  if (listbox1.count > 0) then
  begin
    for i:= 0 to ListBox1.Count -1 do
    begin
      //Procura o CMCod
      rs := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat where CatCod = ' +
                                    CatAno.Caption + ' and MatCod like ' +
                                    quotedstr(Materia.Caption));
      CMCod :=  rs.Fields[0].Value;

      //Procura o CMPCod
      rs := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat where CatCod = ' +
                                    CatAno.Caption + ' and MatCod like ' +
                                    quotedstr(ListBox1.Items[i]));
      CMPCod :=  rs.Fields[0].Value;

      rs := formprincipal.Feagri_Conector.Execute('Select * from Pre_Req where CMCod = ' +
                                    inttostr(CMCod) + ' and CMPCod = ' +
                                    inttostr(CMPCod));

      if not rs.EOF then
      begin
       formprincipal.Feagri_Conector.Execute('delete from Pre_Req where CMCod = ' + inttostr(CMCod)
                               + ' and CMPCod = '+ inttostr(CMPCod));
      end;
    end;
  end;

  gravar.Enabled := false;
  showmessage('Pré-Requisitos gravados com sucesso.');
end;



procedure TFCadMat.AlterarClick(Sender: TObject);
begin
  if DBGrid3.DataSource.DataSet.Fields.Fields[0].AsString = '' then
    exit
  else
  begin
    ADODataset2.close;
    ADODataset2.CommandType := cmdText;
    ADODataset2.CommandText := 'Select * from Cat_Mat where MatCod = ' +
                                quotedstr(DBGrid3.DataSource.DataSet.
                                Fields.Fields[0].AsString) +
                                ' and CatCod = ' + CatAno.caption;
    ADODataset2.Open;
    ADODataset2.Edit;

    if ADODataset2.Fields.Fields[5].asInteger = 6 then
      RadioButton2.Checked := true
    else
      RadioButton1.Checked := true;

    Mat := DBGrid3.DataSource.DataSet.Fields.Fields[0].AsString;
    Alt := True;
    MatEnabledTrue;

    CSalvar.Enabled := true;
    Limpar.enabled := true;
    alterar.Enabled := false;
    excluir.Enabled := false;
    Cancelar.enabled := true;

  end;
end;

procedure TFCadMat.DBGrid3CellClick(Column: TColumn);
begin

    //dbgrid3.SelectedIndex := 5;

    if MatCod.enabled = true then
      MatEnabledFalse;

    ADODataset2.close;
    ADODataset2.CommandType := cmdText;
    ADODataset2.CommandText := 'Select * from Cat_Mat where MatCod = ' +
                                quotedstr(DBGrid3.DataSource.DataSet.
                                Fields.Fields[0].AsString) +
                                ' and CatCod = ' + CatAno.caption;
    ADODataset2.Open;

    if ADODataset2.Fields.fields[5].asInteger = 6 then
      RadioButton2.Checked := true
    else
      RadioButton1.Checked := true;

    limpar.Enabled := false;
    CSalvar.enabled := false;

    if fcadcat.DBCheckBox1.checked = false then
    begin
      MatEnabledFalse;
      Alterar.Enabled := true;
      Excluir.Enabled := true;
      CNovo.enabled := true;
    end;

    if fcadcat.DBCheckBox1.checked = true then
      CNovo.enabled := false;


    
end;

procedure TFCadMat.ExcluirClick(Sender: TObject);
var a,b:string;
begin
  a := '''cat_mat_tur''';
  b := '''pre_req''';
  //Aplicar tratamento de erro para não excluir matérias que sejam
  //pré-requisito ou que tenham um registro no cat_mat_tur_hor

  try
  formprincipal.Feagri_Conector.Execute('Delete from Cat_Mat where MatCod = ' +
                                quotedstr(DBGrid3.DataSource.DataSet.
                                Fields.Fields[0].AsString) +
                                ' and CatCod = ' + CatAno.caption);
  except
    on E: Exception do
    //messagedlg()
    if (e.Message = 'The record cannot be deleted or changed because table '
                     + a + ' includes related records') then
      showmessage('Esta matéria não pode ser excluída porque ela possui ' +
                  'um ou mais horários cadastrados.')
    else
      if (e.Message = 'The record cannot be deleted or changed because table '
                     + b + ' includes related records') then
        showmessage('Esta matéria não pode ser excluída porque ela possui ' +
                    'um ou mais pré-requisitos cadastrados.')
      else
          showmessage(e.classname + ' erro gerado, com mensagem : ' + e.Message);
  end;
  CarregaGrid;
end;






procedure TFCadMat.ComboBox2Change(Sender: TObject);
begin
  if ComboBox1.Text <> '' then
    button1.enabled := true;
end;

procedure TFCadMat.ComboBox1Change(Sender: TObject);
begin
  if combobox2.Text <> '' then
    button1.Enabled := true;
end;



procedure TFCadMat.DBGrid2CellClick(Column: TColumn);
begin
  //dbgrid2.Selectedindex := 3;
  if fcadcat.Vigente = true then
    button2.Enabled := false
  else
  button2.Enabled := true;
end;


function TFCadMat.CamposOK;
var rs:_recordset;
    //rs2:_recordset;
begin
  CamposOK := true;

  //Validando Código

  if MatCod.Text = '' then
  begin
    ShowMessage('Preencha o campo Código');
    MatCod.SetFocus;
    CamposOK := false;
    exit;
  end;

  if matcod.GetTextLen < 5 then
  begin
    Showmessage ('O Código deve ter 5 caracteres.');
    MatCod.SetFocus;
    CamposOK := false;
    exit;
  end;



  //Validando Nome
  if MatNom.Text = '' then
  begin
    ShowMessage('Preencha o campo Nome');
    MatNom.SetFocus;
    CamposOK := false;
    exit;
  end;

  //Validando Crédito
  if MatCred.Text = '' then
  begin
    ShowMessage('Preencha o campo Crédito');
    MatCred.SetFocus;
    CamposOK := false;
    exit;
  end;

  //Validando Semestre Letivo
  if MatSemLet.Text = '' then
  begin
    ShowMessage('Preencha o campo Sem. Let');
    MatSemLet.SetFocus;
    CamposOK := false;
    exit;
  end;

  if RadioButton1.Checked then
  begin
    if (strtoint(MatSemLet.Text) <= 0) or (strtoint(MatSemLet.Text) > 10) then
     begin
       ShowMessage('O campo Semetre Letivo só pode ser peenchido com valores entre 1 e 10');
       MatSemLet.SetFocus;
       CamposOK := false;
       exit;
     end;
  end;

  //Validando MatCP
  if MatCP.Text = '' then
  begin
    ShowMessage('Preencha o campo MatCP');
    MatCP.SetFocus;
    CamposOK := false;
    exit;
  end;

  if (strtoint(MatCP.Text) < 0) then
  begin
    ShowMessage('O Campo MatCP deve ser preenchido com valores positivos');
    MatCP.SetFocus;
    CamposOK := false;
    exit;
  end;

end;

procedure TFCadMat.FormPaint(Sender: TObject);
begin

  if fcadcat.Form2Paint = True then
  begin

    fcadcat.Form2Paint := false;
    Materia.Caption := '';

    pagecontrol1.ActivePageIndex := 0;

    MatCod.Text := '';
    MatNom.Text := '';
    MatCred.Text := '';
    MatSemAno.text := '';
    MatSemLet.Text := '';
    MatCP.Text := '';
    DBMemo1.Text := '';
    RadioButton1.Checked := false;
    RadioButton2.Checked := false;
  
    ADOQuery3.Close;
    ADOQuery3.SQL.Text := 'Select * from Materias, Cat_Mat_Tur_Hor where MatCod like ''Sunday''';
    ADOQuery3.Open;

    ListBox1.Clear;
    ListBox2.Clear;

    if fcadcat.Vigente = true then
    begin
      CNovo.Enabled := false;
      Limpar.Enabled := false;
      CSalvar.Enabled := false;

      Button1.Enabled := false;
      Button2.Enabled := false;
      Gravar.Enabled := false;
      Add.Enabled := false;
      Remove.Enabled := false;
    end
    else
    CNovo.enabled := true;
    
    Alterar.Enabled := false;
    Excluir.Enabled := false;

  end;
end;

procedure TFCadMat.LimparClick(Sender: TObject);
begin
  MatCod.text := '';
  MatNom.text := '';
  MatCred.text := '';
  MatSemAno.text := '';
  MatSemLet.text := '';
  DBMemo1.text := '';
  MatCP.Text := '';
  ADODataSet2.Fields.Fields[8].AsInteger := 0;
  radiobutton1.Checked := true;
end;



procedure TFCadMat.CancelarClick(Sender: TObject);
begin
  Cancela;
end;

procedure TFCadMat.Cancela;
begin
  MatEnabledFalse;
  ADODataset2.close;
  ADODataset2.CommandType := cmdText;
  ADODataset2.CommandText := 'Select * from Cat_Mat where MatCod = ' +
                              quotedstr(DBGrid3.DataSource.DataSet.
                              Fields.Fields[0].AsString) +
                              ' and CatCod = ' + CatAno.caption;
  ADODataset2.Open;

  CNovo.enabled := true;
  limpar.Enabled := false;
  CSalvar.enabled := false;
  Alterar.enabled := true;
  Excluir.enabled := true;
  Cancelar.enabled := false

end;

end.

