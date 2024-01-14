unit frmHorario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls;

type
  TFormHorario = class(TForm)
    StringGrid1: TStringGrid;
    BtnSimular: TButton;
    procedure BtnSimularClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    telasim:boolean;
  end;

var
  FormHorario: TFormHorario;

implementation
uses Simulacao;
{$R *.dfm}

procedure TFormHorario.BtnSimularClick(Sender: TObject);
begin
//      frmMultiMat.FormMultiMat := TFormMultiMat.Create(Self);
   if telasim = false then
     simulacao.SimulaTurma := TSimulaTurma.Create(Self);
end;

end.
