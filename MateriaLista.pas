unit MateriaLista;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, ADODB, DB;

type
  Requisito = record
    Cod: String;
    Feita: Boolean;
  end;

  DiaSem = record
    Hora: array [1..14] of String;
  end;

  TSemana = record
    Dia: array [1..6] of DiaSem;
  end;

  TMateria = class(TObject) 
    Cod: String;
    Nome: String;
    Sem: Integer;
    Ofer: Integer;
    Cred: Integer;
    Est: integer; {Já cursou; Cursando; A Cursar}
    Per: Integer; {1: Manhã; 2: Tarde; 3: Noite}
    Requisitos: array [1..4] of Requisito;
    Horarios: TSemana;
    Simula: TSemana;
    DP: boolean;
    Porc: Integer;
    Leg: String;
    Cur: String;
    Alteracao: Boolean; 
  end;

  ItemList = class(TObject)
//    private
      Dados: TMateria;
      Frame: TGroupBox;
      Cod: TEdit;
      Cred: TEdit;
      DP: TCheckBox;
      FrameEst: TPanel;
      Est: array [1..3] of TRadioButton;
      FramePer: TPanel;
      Per: array [1..3] of TRadioButton;

      function getVisible : boolean;
      procedure setVisible(value: boolean);
      function getTop: integer;
      procedure setTop(value: integer);
      procedure EstClick(Sender: TObject);
      procedure PerClick(Sender: TObject);
      procedure DPClick(Sender: TObject);

//    public
      constructor Create(Lista: TPanel; data: TMateria);
      destructor Destroy; override;
      property Visible: boolean read getVisible write setVisible;
      property Top: integer read getTop write setTop;
  end;

  MatList = class(TObject)
//    private
      tamanho: integer;
      Itens: array of ItemList;
      Bevel: TPanel;
      Scroll: TScrollBar;
      Container: TPanel;
      Frame: TPanel;

      procedure ScrollChange(Sender: TObject);

//    public
      constructor Create(parente: TWinControl; Left, Top, Width, Height: integer);
      destructor Destroy; override;
      procedure addItem(mat: TMateria);
      procedure mudaItem(var Item: ItemList);
      procedure mudaReq(var Item: ItemList);
      procedure arruma;
      procedure atualiza;
      procedure atualizaHora;
      function getTam: integer;  
      function checaErro: boolean;
      procedure zeraPeriodo;
  end;

var
  TotalCred : integer;
  TotalCredLabel: TLabel;
  HorarioGrid: TStringGrid;
  AcuCred: integer;
  AcuCredLabel: TLabel;
  SemAtu: Integer;
  SemAno: Integer;
  SemCur: Integer;
  CredCur: Integer; //credito total já cursado
  MLista: MatList;
  Semana: TSemana;
  ShowCursadas: boolean;
  ShowCursando: boolean;
  ShowACursarS: boolean;
  ShowACursarC: boolean;

implementation

uses principal;

var RecSim: _RecordSet;

constructor ItemList.Create(Lista: TPanel; data: TMateria);
var i, j: integer;
begin
  inherited Create;

  Dados := TMateria.Create;

  Dados.Cod  := data.Cod;
  Dados.Nome := data.Nome;
  Dados.Sem  := data.Sem;
  Dados.Ofer := data.Ofer;
  Dados.Cred := data.Cred;
  Dados.Est  := data.Est;
  Dados.Per  := data.Per;
  Dados.DP   := data.DP;
  Dados.Porc := data.Porc;
  Dados.Leg  := data.Leg;
  Dados.Cur  := data.Cur;
  Dados.Alteracao := false;

  for i := 1 to 4 do
    Dados.Requisitos[i].Cod := data.Requisitos[i].Cod;

  for i := 1 to 6 do
    for j:= 1 to 12 do
    begin
      Dados.Horarios.Dia[i].Hora[j] := data.Horarios.Dia[i].Hora[j];
      Dados.Simula.Dia[i].Hora[j] := data.Simula.Dia[i].Hora[j];
    end;

  Frame := TGroupBox.Create(nil);
  Frame.Parent := Lista;
  Frame.Left := 0;
  Frame.Height := 64;
  Frame.Width := 468;
  Frame.Ctl3D := False;
  Frame.Visible := True;

  Cod := TEdit.Create(nil);
  Cod.Parent := Frame;
  Cod.Left := 16;
  Cod.Top := 15;
  Cod.Height := 18;
  Cod.Width := 129;
  Cod.ReadOnly := True;
  Cod.Ctl3D := False;
  Cod.Visible := True;

  Cred := TEdit.Create(nil);
  Cred.Parent := Frame;
  Cred.Left := 160;
  Cred.Top := 15;
  Cred.Height := 18;
  Cred.Width := 25;
  Cred.ReadOnly := True;
  Cred.Ctl3D := False;
  Cred.Visible := True;

  dp:= TCheckBox.Create(nil);
  dp.Parent := Frame;
  dp.Left := 16;
  dp.Top := 40;
  dp.Height := 18;
  dp.Width := 40;
  dp.Visible := True;
  dp.Checked := False;
  dp.Caption := 'DP';
  dp.OnClick := DPClick;

  FrameEst := TPanel.Create(nil);
  FrameEst.Parent := Frame;
  FrameEst.Left := 220;
  FrameEst.Top := 8;
  FrameEst.Height := 25;
  FrameEst.Width := 225;
  FrameEst.BevelOuter := bvNone;
  FrameEst.Visible := True;
  for i := 1 to 3 do
  begin
    Est[i] := TRadioButton.Create(nil);
    Est[i].Parent := FrameEst;
    Est[i].Left := (i-1)*80;
    Est[i].Top := 0;
    Est[i].Height := 25;
    Est[i].Width := 80;
    Est[i].OnClick := EstClick;
    Est[i].Checked := false;
    Est[i].Visible := True;
  end;
  Est[1].Caption := 'Cursada';
  Est[2].Caption := 'Cursando';
  Est[3].Caption := 'A cursar';

  FramePer := TPanel.Create(nil);
  FramePer.Parent := Frame;
  FramePer.Left := 220;
  FramePer.Top := 33;
  FramePer.Height := 25;
  FramePer.Width := 225;
  FramePer.BevelOuter := bvNone;
  FramePer.Visible := True;
  for i := 1 to 3 do
  begin
    Per[i] := TRadioButton.Create(nil);
    Per[i].Parent := FramePer;
    Per[i].Left := (i-1)*80;
    Per[i].Top := 0;
    Per[i].Height := 25;
    Per[i].Width := 80;
    Per[i].OnClick := PerClick;
    Per[i].Checked := False;
    Per[i].Visible := True;
    Per[i].Enabled := (Dados.Est = 2);
  end;
  Per[1].Caption := 'Turma A';
  Per[2].Caption := 'Turma S';
  Per[3].Caption := 'Turma E';

  Cod.Text := Dados.Leg; 
  Cred.Text := IntToStr(Dados.Cred);
  if (Dados.Est = 2) then
  begin
    Per[Dados.Per].Checked := True;
    TotalCred := TotalCred + StrToInt(Cred.Text);
    TotalCredLabel.Caption := IntToStr(TotalCred);
  end;

  DP.Checked:= Dados.DP;

  setVisible(true);

end;

destructor ItemList.Destroy;
var i: integer;
begin
  Frame.Destroy;
  Frame.Free;
  Frame := nil;

  Cod.Destroy;
  Cod.Free;
  Cod := nil;

  Cred.Destroy;
  Cred.Free;
  Cred := nil;

  dp.Destroy;
  dp.Free;
  dp := nil;

  FrameEst.Destroy;
  FrameEst.Free;
  FrameEst := nil;

  FramePer.Destroy;
  FramePer.Free;
  FramePer := nil;
  for i := 1 to 3 do
  begin
    Est[i].Destroy;
    Est[i].Free;
    Est[i] := nil;

    Per[i].Destroy;
    Per[i].Free;
    Per[i] := nil;
  end;
end;

function ItemList.getVisible;
begin
  Result := Frame.Visible;
end;

procedure ItemList.setVisible(value: boolean);
begin
  Frame.Visible := value;
end;

function ItemList.getTop;
begin
  Result := Frame.Top;
end;

procedure ItemList.setTop(value: integer);
begin
  Frame.Top := value;
end;

procedure ItemList.DPClick(Sender: TObject);
begin
      if Dp.Checked <> dados.DP then
      begin
        Dados.DP:=DP.Checked;
        Dados.Alteracao := true;
      end;
end;

function Hora(StrHora: String): integer;
begin
  Result := 1;
  if StrHora = '07:00:00' then Result := 1;
  if StrHora = '08:00:00' then Result := 2;
  if StrHora = '09:00:00' then Result := 3;
  if StrHora = '10:00:00' then Result := 4;
  if StrHora = '11:00:00' then Result := 5;
  if StrHora = '14:00:00' then Result := 6;
  if StrHora = '15:00:00' then Result := 7;
  if StrHora = '16:00:00' then Result := 8;
  if StrHora = '17:00:00' then Result := 9;
  if StrHora = '18:00:00' then Result := 10;
  if StrHora = '19:00:00' then Result := 11;
  if StrHora = '20:00:00' then Result := 12;
  if StrHora = '21:00:00' then Result := 13;
  if StrHora = '22:00:00' then Result := 14;
end;


function DiaSemana(Dia: String): Integer;
begin
  if Dia = 'domingo' then Result := 1 Else
  if Dia = 'segunda' then Result := 2 Else
  if Dia = 'terça' then Result := 3 Else
  if Dia = 'quarta' then Result := 4 Else
  if Dia = 'quinta' then Result := 5 Else
  if Dia = 'sexta' then Result := 6 Else
  if Dia = 'sábado' then Result := 7;
end;

procedure ItemList.EstClick(Sender: TObject);
var i, j, k, y, ModSem: integer;
begin

  for i := 1 to 3 do
  begin

    if Est[i].Checked then
    begin
      if (Dados.Est <> i) then
      begin
        case i of

        1:
	      begin
	        if (TotalCred <= AcuCred) and
          (AcuCred - StrToInt(Cred.Text) >= TotalCred) and
          (AcuCred - StrToInt(Cred.Text) >= 0) then
	        begin
	          if Dados.Est = 2 then TotalCred := TotalCred - StrToInt(Cred.Text);
	          for j := 1 to 3 do
	          begin
	            Per[j].Checked := False;
	            Per[j].Enabled := False;
	          end;
	          PerClick(nil);
	          MLista.mudaReq(self);
	          Dados.Est := 1;
	        end
	        else MessageDlg('A quantidade atual de créditos irá ' +
	                          'ultrapassar a quantidade acumulada.',
	                          mtWarning, [mbOk], 0);
	      end;

	      2:
	      begin
	        if (TotalCred + StrToInt(Cred.Text) <= AcuCred) then
	        begin
	          TotalCred := TotalCred + StrToInt(Cred.Text);
	          for j := 1 to 3 do
	          begin
	            Per[j].Checked := False;
              Per[j].Enabled := True;
	          end;
	          PerClick(nil);
	          MLista.mudaReq(self);
	          Dados.Est := 2;
	        end
	        else MessageDlg('A quantidade atual de créditos irá ' +
	                          'ultrapassar a quantidade acumulada.',
	                          mtWarning,[mbOk],0);
	      end;

	      3:
	      begin
	        if (TotalCred <= AcuCred) then
	        begin
	          if Dados.Est = 2 then TotalCred := TotalCred - StrToInt(Cred.Text);
	          for j := 1 to 3 do
	          begin
	            Per[j].Checked := False;
	            Per[j].Enabled := False;
	          end;
	          PerClick(nil);
	          MLista.mudaReq(self);
	          Dados.Est := 3;
	        end
	        else MessageDlg('A quantidade atual de créditos irá ' +
	                          'ultrapassar a quantidade acumulada.',
	                          mtWarning, [mbOk], 0);
	      end;

      end;

      Dados.Alteracao := true;

    end;

      if (Dados.Est < 3)  then
        Dados.Cur := inttostr(SemAno)
      else
        Dados.Cur := '0';

      Est[dados.est].Checked := true;
      TotalCredLabel.Caption := IntToStr(TotalCred);

      if SemAno mod 2 = 0 then ModSem := 2
         else ModSem := 1;

      Per[3].Visible:= False;
      if Dados.Est = 2 then
        for j := 1 to 3 do
        begin
          Per[j].Enabled := False;
          if (Dados.Ofer = ModSem) or (Dados.Ofer = 5) then
          for k := 1 to 6 do
           for y := 1 to 12 do
            if (Dados.Horarios.Dia[k].Hora[y] <> '') then
              Per[1].Enabled := True;

          //verifica parte da simulação
          RecSim:= FormPrincipal.feagri_conector.Execute('select Cat_Mat_Tur_Hor.CMCod, Cat_Mat_Tur.TurCod, IniHor, DiaHor'
                                          + ' from Cat_Mat_Tur_Hor, Turma, Cat_Mat_Tur'
                                          + ' where (Cat_Mat_Tur.CMTCod = Cat_Mat_Tur_Hor.CMTCod) and'
                                          + ' (Cat_Mat_Tur.TurCod = Turma.TurCod) and (SemLet = '+inttostr(SemAno)+') and'
                                          + ' (Cat_Mat_Tur_Hor.CMCod = '+Dados.Cod+')');
           //verifica se ja existe horario de simulação criado para a materia escolhida
           if (RecSim.RecordCount <> 0) then
           begin
              Per[2].Enabled := True;
              // adiciona os horarios
              RecSim.MoveFirst;
              while not RecSim.EOF do
              begin
                  if (Dados.Cod = RecSim.Fields[0].Value) and (strtoint(RecSim.Fields[1].Value) = 3) {and (strtoint(RecSim.Fields[4].Value) = Dados.Sem)} then
                  begin
                    Dados.Simula.Dia[DiaSemana(RecSim.Fields[3].Value)-1].Hora[Hora(RecSim.Fields[2].Value)] := Dados.Leg;//mat.Cod;
                  end;
                  RecSim.MoveNext;
              end;
           end; 

        end;
      end;
  end;
end;

procedure ItemList.PerClick(Sender: TObject);
var i,j,k,tur,dd,hr: integer;
bate: boolean;
begin
 for j := 1 to 6 do
  for k := 1 to 14 do
  if Semana.Dia[j].Hora[k] = Dados.Leg { Dados.Cod} then
    Semana.Dia[j].Hora[k] := '';

  if Per[1].Checked then
    begin
      bate := false;
      for j := 1 to 6 do
       for k := 1 to 14 do
       begin
          if ((Dados.Horarios.Dia[j].Hora[k] <> '') and
          (Semana.Dia[j].Hora[k] <> '') and
          (Semana.Dia[j].Hora[k] <> Dados.Leg { Dados.Cod })) and (not bate) then
          begin
            MessageDlg('O horário da matéria ' + Dados.Leg { Dados.Cod }
                      + ' bate com o horário da matéria ' + Semana.Dia[j].Hora[k] + '.',
                      mtWarning, [mbOk], 0);
            Per[1].Checked := false;
            bate := true;
          end;
       end;
      if not bate then
      begin
        for j := 1 to 6 do
          for k := 1 to 14 do
            if Dados.Horarios.Dia[j].Hora[k] <> '' then
              Semana.Dia[j].Hora[k] :=
              Dados.Horarios.Dia[j].Hora[k];
        if Dados.Per <> 1 then
         Dados.Alteracao:= True;
        Dados.Per := 1;
      end;
    end
    else
    if Per[2].Checked and not bate then
    begin
      bate := false;
      for j := 1 to 6 do
        for k := 1 to 14 do
        begin
          if ((Dados.Simula.Dia[j].Hora[k] <> '') and
          (Semana.Dia[j].Hora[k] <> '') and
          (Semana.Dia[j].Hora[k] <> Dados.Leg { Dados.Cod })) and (not bate) then
          begin
            MessageDlg('O horário da matéria ' + Dados.Leg { Dados.Cod }
                      + ' bate com o horário da matéria ' + Semana.Dia[j].Hora[k] + '.',
                      mtWarning, [mbOk], 0);
            Per[2].Checked := false;
            bate := true;
          end;
        end;
      if not bate then
      begin
        for j := 1 to 6 do
          for k := 1 to 14 do
            if Dados.Simula.Dia[j].Hora[k] <> '' then
              Semana.Dia[j].Hora[k] :=
              Dados.Simula.Dia[j].Hora[k];
        if Dados.Per <> 2 then
         Dados.Alteracao:= True;
        Dados.Per := 2;
      end;
  
  end;
            
  MLista.atualizaHora;
  
end;

constructor MatList.Create(parente: TWinControl; Left, Top, Width, Height: integer);
begin
  inherited Create;

  tamanho := 0;

  Bevel.Free;
  Bevel := nil;
  Bevel := TPanel.Create(nil);
  Bevel.Parent := parente;
  Bevel.BevelInner := bvLowered;
  Bevel.BevelOuter := bvLowered;
  Bevel.Left := Left;
  Bevel.Top := Top;
  Bevel.Height := Height;
  Bevel.Width := Width;
  Bevel.Visible := true;

  Scroll.Free;
  Scroll := nil;
  Scroll := TScrollBar.Create(nil);
  Scroll.Parent := Bevel;
  Scroll.Kind := sbVertical;
  Scroll.Height := Bevel.Height - 6;
  Scroll.Width := 17;
  Scroll.Left := Bevel.Width - Scroll.Width - 3;
  Scroll.Top := 3;
  Scroll.Min := 0;
  Scroll.Max := 100;
  Scroll.Position := 0;
  Scroll.SmallChange := 64;
  Scroll.OnChange := ScrollChange;
  Scroll.Visible := true;
  Scroll.Enabled := false;

  Container.Free;
  Container := nil;
  Container := TPanel.Create(nil);
  Container.Parent := Bevel;
  Container.BevelInner := bvNone;
  Container.BevelOuter := bvNone;
  Container.Left := 3;
  Container.Top := 3;
  Container.Height := Bevel.Height - 6;
  Container.Width := Scroll.Left - 6;
  Container.Visible := true;

  Frame.Free;
  Frame := nil;
  Frame := TPanel.Create(nil);
  Frame.Parent := Container;
  Frame.BevelInner := bvNone;
  Frame.BevelOuter := bvNone;
  Frame.Left := 3;
  Frame.Top := 0;
  Frame.Height := 0;
  Frame.Width := Container.Width - 6;
  Frame.Visible := true;
  CredCur:= 0;
  TotalCred := 0;
  TotalCredLabel.Caption := IntToStr(TotalCred);
  MLista := self;

end;

destructor MatList.Destroy;
var i: integer;
begin
  for i := Low(Itens) to High(Itens) do
  begin
    Itens[i].Destroy;
    Itens[i].Free;
    Itens[i] := nil;
  end;

  Frame.Destroy;
  Frame.Free;
  Frame := nil;

  Container.Destroy;
  Container.Free;
  Container := nil;

  Bevel.Destroy;
  Bevel.Free;
  Bevel := nil;

  inherited destroy;
end;

procedure MatList.addItem(mat: TMateria);
var tam, i, SemMod: integer;
begin
  inc(tamanho);
  SetLength(Itens, tamanho);
  SemMod := SemAno mod 2;
  if SemMod = 0 then SemMod := 2
     else SemMod := 1;
  tam := High(Itens);

  Itens[tam] := ItemList.Create(Frame, mat);
  mudaItem(Itens[tam]);
  if (mat.Ofer < 3) and (mat.Ofer <> SemMod) then
  begin
    Itens[tam].Est[2].Enabled := False;
    for i := 1 to 3 do
    begin
      Itens[tam].Per[i].Enabled := False;
      Itens[tam].Per[i].Checked := False;
    end;
  end;

end;

procedure MatList.ScrollChange(Sender: TObject);
begin
  Frame.Top := -Scroll.Position;
end;

procedure MatList.mudaItem(var Item: ItemList);
const totcre = (30 + (9)*48);
var i, j: integer;
    credp:integer;
    falta: boolean;
begin
  for i := 1 to 4 do
    if (Item.Dados.Requisitos[i].Cod <> '') then
      for j := Low(Itens) to High(Itens) do
        if (Itens[j].Cod.Text = Item.Dados.Requisitos[i].Cod) then
          Item.Dados.Requisitos[i].Feita := Itens[j].Est[1].Checked;

  falta := false;
  for i := 1 to 4 do
    if (Item.Dados.Requisitos[i].Cod <> '') and
    (not Item.Dados.Requisitos[i].Feita) then
      falta := true;

  if (item.Dados.Porc <> 0) then
  begin
    credp := trunc((totcre/100) * item.Dados.Porc)+1;
    if (CredCur <= CredP) then
        falta:=true;
  end;
 
  if falta then
    begin
      for i := 1 to 3 do
        Item.Est[i].Enabled := False;
      Item.Est[3].Checked := True;
    end
  else
    begin
      for i := 1 to 3 do
      begin
        Item.Est[i].Enabled := False;
        if (i = Item.Dados.Est) then
            Item.Est[i].Checked := true;
        Item.Est[i].Enabled := True;

      end;
  end;

   atualiza;

end;

procedure MatList.mudaReq(var Item: ItemList);
var i, j, tam: integer;
begin
  tam := High(Itens);
  CredCur:=0;
  for i := Low(Itens) to High(Itens) do
        if Itens[i].Est[1].Checked then
            CredCur := CredCur + Itens[i].Dados.Cred;
  for i := Low(Itens) to tam do
  begin
    for j := 1 to 4 do
      if Itens[i].Dados.Requisitos[j].Cod = Item.Cod.Text then
        mudaItem(Itens[i]);
    if (Itens[i].Dados.Porc <> 0) then
        mudaItem(Itens[i]);
  end;

  atualiza;
end;

procedure MatList.arruma;
var i, tam: integer;
begin

  Frame.Height := 0;
  tam := -1;
  for i := Low(Itens) to High(Itens) do
    if Itens[i].Visible then
    begin
      inc(tam);
      Itens[i].Top := tam*64;
    end;

  Frame.Height := (tam+1)*64;
  if Frame.Height > Container.Height - 6 then
  begin
    Scroll.Enabled := true;
    Scroll.Max := Frame.Height - Container.Height + 6;
    Scroll.LargeChange := Scroll.Max div 2;
  end
  else
  begin
    Scroll.Max := 0;
    Scroll.Enabled := false;
  end;

end;

procedure MatList.atualiza;
var i,j,SemMod: integer;
    sim:integer;   
begin
  AcuCred := 0;
  SemMod:= SemAno mod 2;

  RecSim:= FormPrincipal.feagri_conector.Execute('select Cat_Mat_Tur_Hor.CMCod, Cat_Mat_Tur.TurCod, IniHor, DiaHor'
               + ' from Cat_Mat_Tur_Hor, Turma, Cat_Mat_Tur'
           + ' where (Cat_Mat_Tur.CMTCod = Cat_Mat_Tur_Hor.CMTCod) and'
            + ' (Cat_Mat_Tur.TurCod = Turma.TurCod) and (SemLet = '+inttostr(SemAno)+')');

  sim:= recsim.RecordCount;

  for i := Low(Itens) to High(Itens) do
  begin
    if Itens[i].Est[1].Checked then
    begin
        AcuCred := AcuCred - Itens[i].Dados.Cred;
    end;
    Itens[i].Visible := (ShowCursadas and Itens[i].Est[1].Checked)
                      or (ShowCursando and Itens[i].Est[2].Checked)
                      or (ShowACursarS and Itens[i].Est[3].Checked
                        and Itens[i].Est[3].Enabled)
                      or (ShowACursarC and Itens[i].Est[3].Checked
                        and not Itens[i].Est[3].Enabled);

    if  ((sim = 0) and ((Itens[i].Dados.Sem mod 2) <> SemMod))  then
    begin
	      Itens[i].Est[2].Enabled := False;

        for j := 1 to 3 do
	      begin
	         Itens[i].Per[j].Enabled := False;
	         Itens[i].Per[j].Checked := False;
        end;
    end
    else
    begin 

          //verifica parte da simulação
           if (RecSim.RecordCount <> 0) then
           begin
               // verifica se encontra simulação
              RecSim.MoveFirst;
              while (not RecSim.EOF) do
              begin
                  if (Itens[i].Dados.Cod = RecSim.Fields[0].Value) then
                  begin
	                    Itens[i].Est[2].Enabled := true;
                      RecSim.MoveLast;
                  end;
                  RecSim.MoveNext;
              end;
           end;
    end;    

  end;
  AcuCred := AcuCred + (30 + (SemAtu-1)*48);
  AcuCredLabel.Caption := IntToStr(AcuCred);
  arruma;

end;

procedure MatList.atualizaHora;
var i: integer;
begin
  for i := 1 to 6 do
  begin
    HorarioGrid.Cells[i,1] := Semana.Dia[i].Hora[1];
    HorarioGrid.Cells[i,2] := Semana.Dia[i].Hora[2];
    HorarioGrid.Cells[i,3] := Semana.Dia[i].Hora[3];
    HorarioGrid.Cells[i,4] := Semana.Dia[i].Hora[4];

    HorarioGrid.Cells[i,6] := Semana.Dia[i].Hora[5];
    HorarioGrid.Cells[i,7] := Semana.Dia[i].Hora[6];
    HorarioGrid.Cells[i,8] := Semana.Dia[i].Hora[7];
    HorarioGrid.Cells[i,9] := Semana.Dia[i].Hora[8];

    HorarioGrid.Cells[i,11] := Semana.Dia[i].Hora[9];
    HorarioGrid.Cells[i,12] := Semana.Dia[i].Hora[10];
    HorarioGrid.Cells[i,13] := Semana.Dia[i].Hora[11];
    HorarioGrid.Cells[i,14] := Semana.Dia[i].Hora[12];
  end;
end;

function MatList.checaErro: boolean;
var i: integer;
begin
  Result := False;
  for i := Low(Itens) to High(Itens) do
    if (Itens[i].Dados.Est = 2) and not
    (Itens[i].Per[1].Checked or
    Itens[i].Per[2].Checked or
    Itens[i].Per[3].Checked) then
      Result := True;

end;

function MatList.getTam: integer;
begin
  Result := tamanho;
end;

procedure MatList.zeraPeriodo;
var i,j: integer;
begin
  for i := Low(Itens) to High(Itens) do
    for j := 1 to 3 do
      Itens[i].Per[j].Checked := False;

  for i := 1 to 6 do
    for j := 1 to 12 do
      Semana.Dia[i].Hora[j] := '';

  atualizaHora;
end;

end.
