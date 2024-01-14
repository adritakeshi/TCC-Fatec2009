unit frmCadCat2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, DBCtrls, Mask, ComCtrls;

type
  TFCadCat = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    CatAnoCad: TDBEdit;
    Label5: TLabel;
    DBMemo1: TDBMemo;
    Novo: TButton;
    Limpar: TButton;
    Salvar: TButton;
    Cancelar: TButton;
    DtaInc: TDBEdit;
    Label2: TLabel;
    DBMemo2: TDBMemo;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Label6: TLabel;
    Alterar: TButton;
    DBCheckBox1: TDBCheckBox;
    Button1: TButton;
    Excluir: TButton;
    Button2: TButton;
    Salvar2: TButton;
    Cancelar2: TButton;
    CDtaInc: TDBEdit;
    Label4: TLabel;
    ADOQuery1: TADOQuery;
    ADODataSet1: TADODataSet;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    ADODataSet2: TADODataSet;
    ADODataSet2CatAno: TIntegerField;
    ADODataSet2CatDtIng: TDateTimeField;
    ADODataSet2CatVig: TBooleanField;
    ADODataSet2CatObs: TMemoField;
    ADODataSet2MaxPreReq: TIntegerField;
    GroupBox5: TGroupBox;
    GroupBox2: TGroupBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Cancelar2Click(Sender: TObject);
    procedure CancelarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DBMemo1KeyPress(Sender: TObject; var Key: Char);
    procedure CatAnoCadKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure ExcluirClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Salvar2Click(Sender: TObject);
    procedure AlterarClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure LimparClick(Sender: TObject);
    procedure SalvarClick(Sender: TObject);
    procedure NovoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CarregaCombo;
    procedure DefineTabOrder;
    procedure Altera;
    function SalvarCatalogo(): Boolean;
    procedure DBMemo2KeyPress(Sender: TObject; var Key: Char);
    procedure MaxPreReqKeyPress(Sender: TObject; var Key: Char);
    procedure CMaxPreReqKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    Form2Paint, Form3Paint, Vigente: Boolean;
  end;

var
  FCadCat: TFCadCat;

implementation

uses frmcadmat2, frmimp, principal;

{$R *.dfm}

procedure TFCadCat.FormCreate(Sender: TObject);
begin

  Form2Paint := false;
  Form3Paint := false;

  //Foca na tab1
  pagecontrol1.ActivePageIndex := 0;

  //Insere os anos dos cat�logos no Combo box
  CarregaCombo;

  //Muda as cores dos objetos read only
  CatAnoCad.Enabled := false;
  CatAnoCad.Color := RGB(215,228,242);
  DtaInc.Enabled := false;
  DtaInc.Color := RGB(215,228,242);
  DBMemo1.Enabled := false;
  DBMemo1.Color := RGB(215,228,242);
  CDtaInc.Enabled := false;
  CDtaInc.Color := RGB(215,228,242);
  DBMemo2.Enabled := false;
  DBMemo2.Color := RGB(215,228,242);
  DBCheckBox1.Enabled := false;

  //Muda os bot�es para read only
  Alterar.Enabled := false;
  Limpar.Enabled := false;
  Salvar.Enabled := false;
  Salvar2.Enabled := false;
  Excluir.Enabled := false;
  Cancelar.Enabled := false;
  Cancelar2.Enabled := false;

  //Faz o ADODataSet2 n�o retornar nenhum registro
  adodataset2.Close;
  adodataset2.CommandType := cmdText;
  adodataset2.commandtext := 'select * from catalogo where CatDtIng = 0';
  adodataset2.Open;

  //Define a TabOrder dos objetos
  DefineTabOrder;

  DBCheckBox1.Checked := false;
end;

procedure TFCadCat.NovoClick(Sender: TObject);
begin
  //Muda a cor dos campos que est�o enabled = true
  CatAnoCad.Enabled := true;
  CatAnoCad.Color := RGB(255,255,255);
  DBMemo1.Enabled := true;
  DBMemo1.Color := RGB(255,255,255);
  Cancelar.Enabled := true;
  Novo.enabled := false;

  //P�e o foco no CatAnoCad
  CatAnoCad.SetFocus;

  //Prepara o ADODataSet1 para inser��o
  adodataset1.Close;
  adodataset1.open;
  adodataset1.Insert;
  dtainc.Text := FormatDateTime('dd/mm/yyyy', Now);
end;


function TFCadCat.SalvarCatalogo;
var rs:_recordset;
begin
  //Verifica se o campo CatAnoCad � nulo
  SalvarCatalogo := false;
  if CatAnoCad.Text = '' then
  begin
    ShowMessage('Insira o Ano do Cat�logo');
    CatAnoCad.setfocus;
    exit;
  end;

  //Verifica se o campo CatAnoCad � v�lido
  if (strtoint(CatAnoCad.Text) < 2000) or (strtoint(CatAnoCad.text) > 3000) then
  begin
    ShowMessage ('Insira um ano v�lido');
    CatAnoCad.SetFocus;
    exit;
  end;

  //Verifica se o cat�logo j� existe
  rs := formprincipal.Feagri_Conector.Execute('select CatAno from catalogo order by CatAno');
  while not rs.EOF do
  begin
    if catanocad.text = rs.Fields[0].Value then
    begin
      showmessage ('Esse cat�logo j� existe.');
      catanocad.SetFocus;
      exit;
    end
    else
      rs.MoveNext;
  end;

  //Verifica se a descri��o est� em branco
  if DBMemo1.Text = '' then
  begin
    ShowMessage('Insira a Descri��o do Cat�logo');
    DBMemo1.SetFocus;
    Exit;
  end;
  adodataset1.post;

  //Muda os campos para read only
  CatAnoCad.Enabled := false;
  CatAnoCad.Color := RGB(215,228,242);
  DBMemo1.Enabled := false;
  DBMemo1.Color := RGB(215,228,242);

  //Muda o estado dos bot�es
  Salvar.enabled := false;
  Limpar.Enabled := false;
  Cancelar.enabled := false;
  Novo.enabled := true;

  Novo.SetFocus;

  showmessage ('Cat�logo salvo com sucesso');
  SalvarCatalogo := true;
end;


procedure TFCadCat.SalvarClick(Sender: TObject);
begin
  SalvarCatalogo;
end;


procedure TFCadCat.LimparClick(Sender: TObject);
begin
  Salvar.enabled := false;
  Limpar.Enabled := false;
  Cancelar.enabled := True;
  CatAnoCad.SetFocus;
  ADODataset1.Close;
  ADODataset1.Open;
  ADODataset1.Insert;
  DtaInc.Text := FormatDateTime('dd/mm/yyyy', Now);
end;



procedure TFCadCat.MaxPreReqKeyPress(Sender: TObject; var Key: Char);
begin
  Limpar.Enabled := true;
  Cancelar.Enabled := true;
end;

procedure TFCadCat.ComboBox1Change(Sender: TObject);
begin
  if combobox1.Text <> '' then
    begin
      adodataset2.Close;
      adodataset2.CommandText:= 'select * from catalogo where catano = ' + combobox1.Text;
      adodataset2.Open;
      alterar.enabled := true;
      DBMemo2.Enabled := False;
      DBMemo2.color := RGB(215,228,242);
      Salvar2.Enabled := false;
      Excluir.enabled := true;
      DBCheckBox1.Enabled := false;
      button1.enabled := true;
      button2.Enabled:= true;
      if DBCheckBox1.Checked = true then
      begin
        alterar.Enabled := false;
        excluir.Enabled := false;
        button1.Enabled := false;
      end;
    end;
end;


procedure TFCadCat.AlterarClick(Sender: TObject);
begin
  DBMemo2.Enabled := true;
  DBMemo2.Color := RGB(255,255,255);

  if DBCheckbox1.checked = true then
  begin
    DBCheckbox1.enabled := false;
    button1.enabled := false;
  end
  else
    DBCheckbox1.Enabled := true;

  salvar2.enabled := true;
  excluir.Enabled := false;
  adodataset2.Edit;
  alterar.Enabled := false;
  cancelar2.Enabled := true;

end;

procedure TFCadCat.Salvar2Click(Sender: TObject);
var rs:_recordset;
begin

  //Verifica se a descri��o est� em branco
  if DBMemo2.Text = '' then
  begin
    ShowMessage('Insira a Descri��o da Mat�ria');
    DBMemo2.SetFocus;
    Exit;
  end;


  //if MessageBox(Application.handle, pchar('O Cat�logo e suas respectivas mat�rias n�o podem ' +
  //              #13 + 'ser alterados depois que o cat�logo estiver vigente.'),MB_yesno) = idyes then

  if DBCheckbox1.Checked = true then
  begin
    rs := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat where' +
          ' CatCod = ' + ComboBox1.Text);
    if (rs.bof) and (rs.eof) then
    begin
      ShowMessage('Este cat�logo n�o possui nenhuma mat�ria. Insira-as ' +
                  'antes de consolidar o cat�logo'  );
      DBCheckBox1.Checked := false;
      exit;
    end;
    if Messagedlg('O Cat�logo e suas respectivas mat�rias n�o podem ' +
            #13 + 'ser alterados depois que o cat�logo estiver vigente.' + #13 + ''+
            #13 + '         Deseja tornar esse cat�logo vigente?',
                  mtinformation, [mbyes, mbno], 0) = idNo then
    begin
      DBCheckBox1.SetFocus;
      exit;
    end
    else
    begin
      excluir.Enabled := false;
      alterar.Enabled := false;
      button1.Enabled := false;
      Altera;
    end;
  end
    else
    begin
      excluir.Enabled := true;
      alterar.Enabled := true;
      Altera;
    end;
end;

procedure TFCadCat.Altera;
  begin
   adodataset2.Post;
   DBMemo2.Enabled := false;
   DBMemo2.Color := RGB(215,228,242);
   salvar2.Enabled := false;
   DBCheckbox1.Enabled := false;
   Cancelar2.Enabled := false;
   showmessage ('Altera��o gravada com sucesso.');
  end;

procedure TFCadCat.CarregaCombo;
var rs:_recordset;
begin
  ComboBox1.Clear;
  rs:= formprincipal.Feagri_Conector.Execute('select CatAno from catalogo ' +
                              'order by CatAno');
  while not rs.eof do
  begin
    ComboBox1.Items.Add(RS.Fields[0].Value);
    rs.MoveNext;
  end;
end;

procedure TFCadCat.PageControl1Change(Sender: TObject);
var a: string;
begin
  if pagecontrol1.TabIndex = 1 then
  begin
    if Combobox1.Text = '' then
      carregacombo
    else
    begin
      a := ComboBox1.text;
      carregacombo;
      ComboBox1.ItemIndex := Combobox1.items.indexof(a);
    end;

  end;
{  begin
    if combobox1.Text = '' then
    begin
      DBCheckBox1.Checked := false;
      CarregaCombo;
      if (CatAnoCad.Text = '') or (combobox1.Items.IndexOf(CatAnoCad.text) = -1) then
      begin
        CDtaInc.Text := '';
        DBMemo2.Text := '';
      end
      else
      begin
        combobox1.ItemIndex := combobox1.Items.IndexOf(CatAnoCad.text);
        adodataset2.Close;
        adodataset2.CommandText:= 'select * from catalogo where catano = ' + combobox1.Text;
        adodataset2.Open;
        alterar.Enabled := true;
        excluir.enabled := true;
      end;
    end;
  end; }
end;

procedure TFCadCat.ExcluirClick(Sender: TObject);
var a: String;
    erro: Boolean;
begin
a := '''cat_mat''';
erro := false;
  try
  formprincipal.Feagri_Conector.Execute('delete from catalogo where CatAno = ' + combobox1.text);
  except
  on E: Exception do
    if (e.Message = 'The record cannot be deleted or changed because table '
                     + a + ' includes related records') then
    begin
      showmessage('Este cat�logo n�o pode ser exclu�do porque ele possui ' +
                  'uma ou mais mat�rias cadastradas.');
      erro := true;
    end
    else
    begin
      showmessage(e.classname + ' erro gerado, com mensagem : ' + e.Message);
      erro := true;
    end;
  end;

    if (erro = false) then
    begin
    CarregaCombo;
    CDtaInc.text := '';
    DBMemo2.text := '';
    Excluir.enabled := false;
    Salvar2.enabled := false;
    alterar.enabled := false;
    DBMemo2.Enabled := false;
    Cancelar2.Enabled := false;
    DBMemo2.Color := RGB(215,228,242);
    ShowMessage ('Cat�logo Excluido com sucesso');
    end;
end;

procedure TFCadCat.Button2Click(Sender: TObject);
begin
  if ComboBox1.Text = '' then
  begin
    showmessage('Escolha um cat�logo');
    ComboBox1.SetFocus;
  end
  else
  begin
    Form2Paint := true;

    Application.CreateForm(TFCadMat, FCadMat);
  
    FCadMat.CatAno.Caption := ComboBox1.Text;
    if DBCheckBox1.checked = true then
      Vigente := true
    else
    Vigente:= false;
    FCadMat.CarregaGrid;

    //FCadMat:= TFCadMat.Create(Application);
    FCadMat.ShowModal;

    //Button2.Enabled:= False;
  end;
end;

procedure TFCadCat.CatAnoCadKeyPress(Sender: TObject; var Key: Char);
begin
  Salvar.Enabled := true;
  Limpar.Enabled := true;
  Cancelar.enabled := true;
end;

procedure TFCadCat.CMaxPreReqKeyPress(Sender: TObject; var Key: Char);
begin
  Cancelar.Enabled := true;
  Salvar2.Enabled := true;
end;


procedure TFCadCat.DBMemo1KeyPress(Sender: TObject; var Key: Char);
begin
  Limpar.Enabled := true;
  Cancelar.Enabled := true;
end;

procedure TFCadCat.Button1Click(Sender: TObject);
begin
  if ComboBox1.Text = '' then
  begin
    showmessage('Escolha um cat�logo');
    ComboBox1.SetFocus;
  end
  else
  begin
    Application.CreateForm(TFImpMat, FImpMat);
    Form3Paint := true;
    FImpMat.CatAno.Caption := ComboBox1.Text;
    FImpMat.ShowModal;
    //Button1.Enabled:= False;
    //Form3.CarregaGrid;
    //Form3.CarregaCombo;
  end;
end;

procedure TFCadCat.CancelarClick(Sender: TObject);
begin
  CatAnoCad.Enabled := false;
  CatAnoCad.Color := RGB(215,228,242);
  CatAnoCad.Text := '';
  DtaInc.Enabled := false;
  DtaInc.Color := RGB(215,228,242);
  DtaInc.Text := '';
  DBMemo1.Enabled := false;
  DBMemo1.Color := RGB(215,228,242);
  DBMemo1.Text := '';
  Salvar.enabled := false;
  Limpar.Enabled := false;
  Cancelar.enabled := false;
  Novo.enabled := true;
end;

procedure TFCadCat.Cancelar2Click(Sender: TObject);
begin
  //CarregaCombo;

  CDtaInc.Enabled := false;
  CDtaInc.Color := RGB(215,228,242);
  CDtaInc.Text := '';
  DBMemo2.Enabled := false;
  DBMemo2.Color := RGB(215,228,242);
  DBMemo2.Text := '';
  DBCheckBox1.Enabled := false;
  Alterar.Enabled := false;
  Excluir.Enabled := false;
  Salvar2.Enabled := false;
  Cancelar2.Enabled := false;

  adodataset2.Close;
  adodataset2.CommandText:= 'select * from catalogo where catano = ' + combobox1.Text;
  adodataset2.Open;

  alterar.Enabled := true;
  excluir.enabled := true;
end;


procedure TFCadCat.DBMemo2KeyPress(Sender: TObject; var Key: Char);
begin
  Cancelar.Enabled := true;
  Salvar2.Enabled := true;
end;


procedure TFCadCat.DefineTabOrder;
begin
  CatAnoCad.TabOrder := 0;
  DBMemo1.TabOrder := 1;
  Novo.TabOrder := 2;
  Limpar.TabOrder := 3;
  Salvar.TabOrder := 4;
  Cancelar.TabOrder := 5;

  ComboBox1.TabOrder := 0;
  DBMemo2.TabOrder := 1;
  DBCheckBox1.TabOrder := 2;
  Alterar.TabOrder := 3;
  Excluir.TabOrder := 4;
  Salvar2.TabOrder := 5;
  Cancelar2.TabOrder := 6;
  Button1.TabOrder := 7;
  Button2.TabOrder := 8;
end;

procedure TFCadCat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if CatAnoCad.enabled = true then
  begin
    if Messagedlg('Deseja salvar o Cat�logo antes de sair?',
                   mtinformation, [mbyes, mbno], 0) = idyes then
    begin
      if SalvarCatalogo = false then
        Action := canone
      else
        Action := CaFree;
    end
    else
      Action := CaFree;
  end
  else
    Action := CaFree;
end;

end.


