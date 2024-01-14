program unicamp;

uses
  Forms,
  principal in 'principal.pas' {formprincipal},
  colaboradores in 'colaboradores.pas' {colab},
  Aluno in 'Aluno.pas' {Tbusca},
  Aluno3 in 'Aluno3.pas' {FAluno},
  frmimp in 'frmimp.pas' {Form3},
  frmCadMat2 in 'frmCadMat2.pas' {FCadMat},
  frmCadCat2 in 'frmCadCat2.pas' {FCadCat},
  horarios in 'horarios.pas',
  frmGradeHoraria in 'frmGradeHoraria.pas' {FGrade},
  frmConsolidacao in 'frmConsolidacao.pas' {FConsolidacao},
  Feagri in 'Feagri.pas',
  Builder in 'Builder.pas' {FrmBuilder},
  DescMat in 'DescMat.pas' {FDescMat};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tformprincipal, formprincipal);
  //Application.CreateForm(Tfgrade, fgrade);
  Application.Run;
end.
