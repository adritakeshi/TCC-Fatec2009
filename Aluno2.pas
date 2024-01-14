unit Aluno2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB, DB, StdCtrls, Mask, DBCtrls, Buttons;

type
  Talu02 = class(TForm)
    LBLnome: TLabel;
    LBLra: TLabel;
    LBLsemlet: TLabel;
    LBLcat: TLabel;
    ADODataSet1: TADODataSet;
    DataSource1: TDataSource;
    ADODataSet2: TADODataSet;
    DataSource2: TDataSource;
    DBnome: TDBEdit;
    DBcat: TDBEdit;
    DBsemlet: TDBEdit;
    DBra: TDBEdit;
    BTNnovo: TButton;
    BTNbusca: TBitBtn;
    Edit1: TEdit;
    BTNfecha: TButton;
    procedure BTNnovoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BTNbuscaClick(Sender: TObject);
    procedure BTNfechaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  alu02: Talu02;
  vnome2: string;

implementation

uses Aluno,principal;

{$R *.dfm}


procedure Talu02.BTNnovoClick(Sender: TObject);
begin
if BTNnovo.Caption='Novo' then
  begin
    dbnome.Enabled:=True;
    dbra.Enabled:=True;
    dbcat.Enabled:=True;
    dbsemlet.enabled:=True;
    dbnome.SetFocus;

    adodataset1.Open;
    adodataset1.insert;

    adodataset2.open;
    datasource2.DataSet:=adodataset2;
    adodataset2.edit;
    BTNnovo.Caption:='Gravar';
  end
else
  begin
     adodataset2.post;
     showmessage ('dados gravados com sucesso');
     BTNnovo.Caption:='Novo';
     dbnome.Enabled:=false;
     dbra.Enabled:=false;
     dbcat.Enabled:=false;
     dbsemlet.enabled:=false;
  end;
end;

procedure Talu02.FormCreate(Sender: TObject);
begin
dbnome.Enabled:=false;
dbra.Enabled:=false;
dbcat.Enabled:=false;
dbsemlet.enabled:=false;
end;

procedure Talu02.BTNbuscaClick(Sender: TObject);
begin
    Tbusca:=Tbusca.Create(Application);
    if (dbnome.Text<>'')then
      Tbusca.EDbusca.Text:=dbnome.Text;
    Tbusca.Show;

end;

procedure Talu02.BTNfechaClick(Sender: TObject);
begin

close;

end;

procedure Talu02.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=cafree;
end;

end.
