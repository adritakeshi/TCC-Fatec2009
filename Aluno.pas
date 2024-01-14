unit Aluno;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Mask, DBCtrls, Buttons, Grids, DBGrids;

type
  TTbusca = class(TForm)
    EDbusca: TEdit;
    RBnome: TRadioButton;
    RBra: TRadioButton;
    Label1: TLabel;
    BTNVolta: TButton;
    GBusca: TDBGrid;
    Qbusc: TADOQuery;
    SCRbusc: TDataSource;
    procedure FormCreate(Sender: TObject);

    procedure BTNVoltaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EDbuscaChange(Sender: TObject);
    procedure GBuscaCellClick(Column: TColumn);
    procedure RBraClick(Sender: TObject);
    procedure RBnomeClick(Sender: TObject);

 //   procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
   Tbusca: TTbusca;
   vra,colra,vnome,vcat,vsem: string;

implementation
uses aluno3,principal;
{$R *.dfm}

procedure TTbusca.BTNVoltaClick(Sender: TObject);
begin
//Inseri esse IF (Yu)
if (GBusca.FieldCount <> 0) and ((vra='') and (vnome='') and (vcat=''))then
begin
 vra:=GBusca.Fields[0].Text;
 vnome:=GBusca.Fields[1].Text;
 vcat:=GBusca.Fields[2].Text;
end;

if ((vra='') and (vnome='') and (vcat='')) then
else
  begin
    FAluno.EDTra.text:= vra;
    FAluno.EDTNome.text:=vnome;
    FAluno.CMBano.Items.Add(vcat);
    FAluno.CMBano.ItemIndex:= FAluno.CMBano.Items.Count-1;

    FAluno.EDTra.Enabled:=False;
    FAluno.EDTNome.Enabled:=False;
    FAluno.CMBano.Enabled:=False;

    FAluno.EDTra.Color:=RGB(215,228,242);
    FAluno.EDTNome.Color:=RGB(215,228,242);
    FAluno.CMBano.Color:=RGB(215,228,242);

    FAluno.BTNAlterar.Visible:=true;
    FAluno.BTNfechar.Enabled:= True;
  end;
close;
end;

procedure TTbusca.EDbuscaChange(Sender: TObject);
begin
Trim(EDbusca.Text);
Qbusc.Close;
  if (RBnome.checked) then
     Qbusc.SQL.Text:=('Select * from Aluno where AluNom like '+quotedstr('%'+EDbusca.text+'%'))

  else
    Qbusc.SQL.Text:=('Select * from Aluno where AluRA like '+quotedstr('%'+EDbusca.text+'%'));
Qbusc.Open;
end;

procedure TTbusca.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    action:=cafree;
end;

procedure TTbusca.GBuscaCellClick(Column: TColumn);
begin
//valor do campo: DBGrid1.Fields[DBGrid1.SelectedIndex].Text;
//valor da coluna: DBGrid1.Fields[DBGrid1.SelectedIndex].FieldName;
if GBusca.FieldCount <> 0 then
begin
 vra:=GBusca.Fields[0].Text;
 vnome:=GBusca.Fields[1].Text;
 vcat:=GBusca.Fields[2].Text;
end;
end;

procedure TTbusca.RBnomeClick(Sender: TObject);
begin
 EDbusca.Text:='';
 EDbusca.SetFocus;
 Qbusc.Close;
end;

procedure TTbusca.RBraClick(Sender: TObject);
begin
 EDbusca.Text:='';
 EDbusca.SetFocus;
 Qbusc.Close;
end;

procedure TTbusca.FormCreate(Sender: TObject);
begin
  GBusca.SelectedIndex := 0; 
end;

end.
