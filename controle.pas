unit controle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids;

type
  Talteracao = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Button1: TButton;
    StringGrid1: TStringGrid;
    Label10: TLabel;
    Label11: TLabel;
    Button2: TButton;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    RadioGroup4: TRadioGroup;
    RadioGroup5: TRadioGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  alteracao: Talteracao;
  visivel:boolean;

implementation

{$R *.dfm}

procedure Talteracao.Button1Click(Sender: TObject);
begin
if not visivel then
begin
 visivel:=true;
 stringgrid1.visible:=true;
 windowstate:=wsmaximized;
 button1.caption:='Ocultar Grade';
end
else
begin
 visivel:=false;
 stringgrid1.Visible:=false;
 windowstate:=wsnormal;
 button1.Caption:='Mostar Grade';
end;
end;

procedure Talteracao.FormCreate(Sender: TObject);
begin
visivel:=false;
stringgrid1.cells[1,0]:='  Segunda';
stringgrid1.cells[2,0]:='    Terça';
stringgrid1.cells[3,0]:='  Quarta';
stringgrid1.cells[4,0]:='  Quinta';
stringgrid1.cells[5,0]:='  Sexta';
stringgrid1.cells[6,0]:='  Sabado';
stringgrid1.cells[0,1]:='7:00';
stringgrid1.cells[0,2]:='8:00';
stringgrid1.cells[0,3]:='9:00';
stringgrid1.cells[0,4]:='10:00';
stringgrid1.cells[0,5]:='11:00';
stringgrid1.cells[0,6]:='12:00';
stringgrid1.cells[0,7]:='13:00';
stringgrid1.cells[0,8]:='14:00';
stringgrid1.cells[0,9]:='15:00';

end;
procedure Talteracao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
action:=cafree;
end;

end.
