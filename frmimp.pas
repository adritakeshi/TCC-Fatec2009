unit frmimp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Grids, DBGrids;

type
  TFImpMat = class(TForm)
    ComboBox1: TComboBox;
    Label1: TLabel;
    CatAno: TLabel;
    Label3: TLabel;
    ADOQuery1: TADOQuery;
    DataSource: TDataSource;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    ADOQuery2: TADOQuery;
    ADODataSet: TADODataSet;
    ADOQuery2CMCod: TAutoIncField;
    ADOQuery2CatCod: TIntegerField;
    ADOQuery2MatCod: TWideStringField;
    ADOQuery2MatNom: TWideStringField;
    ADOQuery2MatCred: TIntegerField;
    ADOQuery2MatSemOfer: TIntegerField;
    ADOQuery2MatSem: TIntegerField;
    ADOQuery2MatDef: TMemoField;
    ADOQuery2MatCP: TIntegerField;
    ADOQuery1CMCod: TAutoIncField;
    ADOQuery1CatCod: TIntegerField;
    ADOQuery1MatCod: TWideStringField;
    ADOQuery1MatNom: TWideStringField;
    ADOQuery1MatCred: TIntegerField;
    ADOQuery1MatSemOfer: TIntegerField;
    ADOQuery1MatSem: TIntegerField;
    ADOQuery1MatDef: TMemoField;
    ADOQuery1MatCP: TIntegerField;
    DBGrid2: TDBGrid;
    DBGrid1: TDBGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure CarregaGrid;
    procedure CarregaCombo;
    procedure FormPaint(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FImpMat: TFImpMat;
  Adiciona: Boolean;

implementation

uses frmcadcat2, principal;


{$R *.dfm}

//procedure TForm3.FormCreate(Sender: TObject);
//begin
//  CarregaGrid;
//  CarregaCombo;
//end;



procedure TFImpMat.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action:= Cafree;
end;

procedure TFImpMat.FormCreate(Sender: TObject);
begin
  Adiciona := false;
end;

procedure TFImpMat.FormPaint(Sender: TObject);
begin
  if fcadcat.Form3Paint = true then
  begin
    fcadcat.Form3Paint := false;
    CarregaCombo;
    Adiciona := false;
    CarregaGrid;
  end;
end;

procedure TFImpMat.CarregaCombo;
var rs:_recordset;
begin
  ComboBox1.Clear;
  rs:= formprincipal.Feagri_Conector.Execute('select CatAno from catalogo ' +
                              'order by CatAno');
  while not rs.eof do
  begin
    if (StrToInt(CatAno.Caption) <> RS.fields[0].Value) then
      ComboBox1.Items.Add(RS.Fields[0].Value);
    rs.MoveNext;
  end;
end;

procedure TFImpMat.CarregaGrid;
begin
  ADOquery1.Close;
  if combobox1.Text <> '' then
    ADOQuery1.SQL.Text := 'Select * from Cat_Mat where CatCod = ' + ComboBox1.text +
                          ' Order by MatCod;' 
  else
    ADOQuery1.SQL.Text := 'Select * from Cat_Mat where CMCod = 0';
  ADOQuery1.Open;



  if CatAno.caption <> 'CatAno' then
  begin
    ADOQuery2.Close;
    ADOQuery2.SQL.Text := 'Select * from Cat_Mat where CatCod = ' + CatAno.caption;
    ADOQuery2.Open;
  end;
  if adiciona = true then
  begin
    DBGrid2.FieldCount;
    DBGrid2.Fields[DBGrid2.FieldCount]
  end;

  Adiciona := false;
end;

procedure TFImpMat.ComboBox1Change(Sender: TObject);
begin
  if combobox1.Text <> '' then
  begin
    ADOquery1.Close;
    ADOQuery1.SQL.Text := 'Select * from Cat_Mat where CatCod = ' + ComboBox1.text;
    ADOQuery1.Open;
  end;
end;



procedure TFImpMat.Button1Click(Sender: TObject);
var CatCod, MatCred, MatSemOfer, MatSem, MatCP: Integer;
    MatDef, MatNom, MatCod: String;
    rs:_recordset;
begin
  if ComboBox1.Text = '' then
  begin
    ShowMessage('Escolha um catálogo');
    ComboBox1.SetFocus;
    Exit;
  end;

  MatCod := DBGrid1.DataSource.DataSet.Fields.Fields[2].AsString;
  MatNom := DBGrid1.DataSource.DataSet.Fields.Fields[3].AsString;
  MatSem := DBGrid1.DataSource.DataSet.Fields.Fields[6].AsInteger;
  MatSemOfer := DBGrid1.DataSource.DataSet.Fields.Fields[5].AsInteger;
  MatCred := DBGrid1.DataSource.DataSet.Fields.Fields[4].AsInteger;
  MatDef := DBGrid1.DataSource.DataSet.Fields.Fields[7].AsString;
  MatCP := DBGrid1.DataSource.DataSet.Fields.Fields[8].AsInteger;
  CatCod := strtoint(CatAno.caption);

  rs := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat where' +
                               ' CatCod like ' + inttostr(CatCod) +
                               ' and MatCod like ' + quotedstr(MatCod));
  if rs.eof = false then
    ShowMessage('A matéria ' + MatCod + ' já existe no catálogo ' + inttostr(catcod))
  else
  begin
    formprincipal.Feagri_Conector.Execute('Insert into Cat_Mat (CatCod, MatCod, MatNom, ' +
                           'MatCred, MatSemOfer, MatSem, MatDef, MatCP) ' +
                           'values (' +
                            inttostr(CatCod) + ', ' +
                            quotedstr(MatCod) + ', ' +
                            quotedstr(MatNom) + ', ' +
                            inttostr(MatCred) + ', ' +
                            inttostr(MatSemOfer) + ', ' +
                            inttostr(MatSem) + ', ' +
                            quotedstr(MatDef) + ', ' +
                            inttostr(MatCP) +')');

    if MatSemOfer = 6 then
    begin
      rs := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat where' +
                               ' CatCod like ' + inttostr(CatCod) +
                               ' and MatCod like ' + quotedstr(MatCod));
      formprincipal.Feagri_Conector.Execute('Update Cat_Mat set HorOk = true' +
        ' where CMCod = ' + IntToStr(rs.Fields[0].Value));
    end;
    if CatAno.caption <> 'CatAno' then
    begin
      ADOQuery2.Close;
      ADOQuery2.SQL.Text := 'Select * from Cat_Mat where CatCod = ' + CatAno.caption;
      ADOQuery2.Open;
    end;
  end;
end;

procedure TFImpMat.Button2Click(Sender: TObject);
var a,b:string;
begin
  a := '''cat_mat_tur''';
  b := '''pre_req''';
  //Aplicar tratamento de erro para não excluir matérias que sejam
  //pré-requisito ou que tenham um registro no cat_mat_tur_hor

  try
  formprincipal.Feagri_Conector.Execute('Delete from Cat_Mat where MatCod = ' +
                                quotedstr(DBGrid2.DataSource.DataSet.
                                Fields.Fields[2].AsString) +
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
  Adiciona := true;
  CarregaGrid;
  Button3.Enabled := true;
end;

procedure TFImpMat.Button3Click(Sender: TObject);
var CatCod, MatCred, MatSemOfer, MatSem, MatCP: Integer;
    MatDef, MatNom, MatCod: String;
    a, i: Integer;
    rs1, rs2, rs3:_RecordSet;
begin
  if Combobox1.Text = '' then
  begin
    Showmessage('Escolha um Catálogo');
    ComboBox1.SetFocus;
    exit;
  end;

  rs1 := formprincipal.Feagri_Conector.Execute('Select Count(*) from Cat_Mat where CatCod = ' +
                                Combobox1.text);
  a := strtoint(rs1.fields[0].value);
  rs1 := formprincipal.Feagri_Conector.Execute('select * from Cat_Mat where CatCod = ' +
                                ComboBox1.text);
  For i := 1 to a do
  begin
    MatCod := rs1.Fields[2].Value;
    MatNom := rs1.Fields[3].Value;
    MatSem := rs1.Fields[6].Value;
    MatSemOfer := rs1.Fields[5].Value;
    MatCred := rs1.Fields[4].Value;
    MatDef := rs1.Fields[7].Value;
    MatCP := rs1.Fields[8].Value;
    CatCod := strtoint(CatAno.caption);
    rs1.MoveNext;
    rs2 := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat where' +
                                  ' CatCod like ' + inttostr(CatCod) +
                                  ' and MatCod like ' + quotedstr(MatCod));
    if rs2.eof then
    begin
      formprincipal.Feagri_Conector.Execute('Insert into Cat_Mat (CatCod, MatCod, MatNom, ' +
                             'MatCred, MatSemOfer, MatSem, MatDef, MatCP) ' +
                             'values (' +
                              inttostr(CatCod) + ', ' +
                              quotedstr(MatCod) + ', ' +
                              quotedstr(MatNom) + ', ' +
                              inttostr(MatCred) + ', ' +
                              inttostr(MatSemOfer) + ', ' +
                              inttostr(MatSem) + ', ' +
                              quotedstr(MatDef) + ', ' +
                              inttostr(MatCP) +')');
    if MatSemOfer = 6 then
    begin
      rs3 := formprincipal.Feagri_Conector.Execute('Select * from Cat_Mat where' +
                               ' CatCod like ' + inttostr(CatCod) +
                               ' and MatCod like ' + quotedstr(MatCod));
      formprincipal.Feagri_Conector.Execute('Update Cat_Mat set HorOk = true' +
        ' where CMCod = ' + IntToStr(rs3.Fields[0].Value));
    end;
    end;
  end;

  Adiciona := true;
  CarregaGrid;
  button3.Enabled := false;
end;



end.
