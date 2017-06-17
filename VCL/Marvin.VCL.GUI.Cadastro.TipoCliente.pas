unit Marvin.VCL.GUI.Cadastro.TipoCliente;

interface

uses
  { sistema }
  Marvin.AulaMulticamada.Classes.TipoCliente,
  Marvin.AulaMulticamada.Listas.TipoCliente,
  Marvin.VCL.GUI.Cadastro.Base,
  { embarcadero }
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Actions,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtActns,
  Vcl.ActnList,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.WinXCtrls,
  Vcl.Buttons,
  Vcl.ToolWin;

type
  TMRVFrameCadastroTipoCliente = class(TMRVFrameCadastroBase)
    PN_InfoTipoCliente: TPanel;
    LE_Codigo: TLabeledEdit;
    LE_Descricao: TLabeledEdit;
  private
    FTipoCliente: TMRVTipoCliente;
    FListaTiposCliente: TMRVListaTipoCliente;
    procedure DoGetTiposCliente;
    procedure DoShowTiposCliente;
  protected
    { métodos de interface GUI }
    procedure DoRefresh; override;
    procedure DoSalvar; override;
    procedure DoExcluir; override;
    procedure DoInterfaceToObject(const AItem: TListItem); override;
    procedure DoObjectToInterface;
    procedure DoGetFromInterface;
    procedure DoInitInterface; override;
    procedure DoInit; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property TipoCliente: TMRVTipoCliente read FTipoCliente;
  end;

var
  MRVFrameCadastroTipoCliente: TMRVFrameCadastroTipoCliente;

implementation

{$R *.dfm}

{ TMRVFrameCadastroTipoCliente }

constructor TMRVFrameCadastroTipoCliente.Create(AOwner: TComponent);
begin
  inherited;
  FTipoCliente := TMRVTipoCliente.Create;
  FListaTiposCliente := TMRVListaTipoCliente.Create;
end;

destructor TMRVFrameCadastroTipoCliente.Destroy;
begin
  FreeAndNil(FTipoCliente);
  FreeAndNil(FListaTiposCliente);
  inherited;
end;

procedure TMRVFrameCadastroTipoCliente.DoExcluir;
var
  LMensagem: string;
  LTipoCliente: TMRVTipoCliente;
begin
  inherited;
  LTipoCliente := TMRVTipoCliente.Create;
  try
    LTipoCliente.Assign(FTipoCliente);
    { manda o ClientModule excluir }
    LMensagem := Self.ClientClasses.TiposClienteExcluir(LTipoCliente);
    { exibe mensagem }
    Self.ShowMessageBox(LMensagem);
    { atualiza a lista }
    Self.DoRefresh;
    { muda para a aba de lista }
    AT_Lista.ExecuteTarget(TS_Lista);
  finally
    LTipoCliente.Free;
  end;
end;

procedure TMRVFrameCadastroTipoCliente.DoGetFromInterface;
var
  LId: Integer;
begin
  LId := 0;
  if (Trim(LE_Codigo.Text) <> EmptyStr) then
  begin
    LId := StrToInt(LE_Codigo.Text);
  end;
  { recupera os dados da GUI }
  FTipoCliente.TipoClienteId := LId;
  FTipoCliente.Descricao := LE_Descricao.Text;
end;

procedure TMRVFrameCadastroTipoCliente.DoGetTiposCliente;
var
  LTipoCliente: TMRVTipoCliente;
  LListaTiposCliente: TMRVListaTipoCliente;
begin
  LListaTiposCliente := nil;
  { recupera os dados para o listview }
  LTipoCliente := TMRVTipoCliente.Create;
  try
    { pede para o ClientModule recuperar os tipos de clientes cadastrados }
    LListaTiposCliente := Self.ClientClasses.TiposClienteProcurarItens(
      LTipoCliente) as TMRVListaTipoCliente;
    { se trouxe dados }
    if Assigned(LListaTiposCliente) then
    begin
      try
        { recupera para a lista }
        FListaTiposCliente.Clear;
        FListaTiposCliente.AssignObjects(LListaTiposCliente);
      finally
        { libera a lista temporária }
        LListaTiposCliente.Free;
      end;
    end;
  finally
    LTipoCliente.Free;
  end;
end;

procedure TMRVFrameCadastroTipoCliente.DoInit;
begin
  inherited;
end;

procedure TMRVFrameCadastroTipoCliente.DoInitInterface;
begin
  inherited;
  { limpa }
  LE_Codigo.Text := EmptyStr;
  LE_Descricao.Text := EmptyStr;
  { ajusta }
  LE_Codigo.Enabled := False;
  LE_Descricao.SetFocus;
end;

procedure TMRVFrameCadastroTipoCliente.DoInterfaceToObject(
  const AItem: TListItem);
begin
  inherited;
  { recupera }
  FTipoCliente.TipoClienteId := AItem.Caption.ToInteger;
  FTipoCliente.Descricao := AItem.SubItems[0];
  { exibe }
  Self.DoObjectToInterface;
end;

procedure TMRVFrameCadastroTipoCliente.DoObjectToInterface;
begin
  case Self.EstadoCadastro of
    ecNovo:
      begin
        LE_Codigo.Enabled := False;
        LE_Descricao.SetFocus;
      end;
    ecAlterar:
      begin
        LE_Codigo.Enabled := True;
        LE_Codigo.SetFocus;
      end;
  end;
  LE_Codigo.Text := FTipoCliente.TipoClienteId.ToString;
  LE_Descricao.Text := FTipoCliente.Descricao;
end;

procedure TMRVFrameCadastroTipoCliente.DoRefresh;
begin
  inherited;
  { recupera os dados para a lista de objetos }
  Self.DoGetTiposCliente;
  { exibe os dados }
  Self.DoShowTiposCliente;
end;

procedure TMRVFrameCadastroTipoCliente.DoSalvar;
var
  LTipoCliente: TMRVTipoCliente;
begin
  inherited;
  LTipoCliente := nil;
  Self.DoGetFromInterface;
  case Self.EstadoCadastro of
    ecNovo:
      begin
        { manda o ClientModule incluir }
        LTipoCliente := Self.ClientClasses.TiposClienteInserir(FTipoCliente) as
          TMRVTipoCliente;
        Self.EstadoCadastro := ecAlterar;
      end;
    ecAlterar:
      begin
        { manda o ClientModule alterar }
        LTipoCliente := Self.ClientClasses.TiposClienteAlterar(FTipoCliente) as
          TMRVTipoCliente;
      end;
  end;
  try
    FTipoCliente.Assign(LTipoCliente);
    { exibe a resposta }
    Self.DoObjectToInterface;
  finally
    { libera o retorno }
    LTipoCliente.Free;
  end;
end;

procedure TMRVFrameCadastroTipoCliente.DoShowTiposCliente;
var
  LCont: Integer;
  LItem: TListItem;
  LTipoCliente: TMRVTipoCliente;
begin
  LV_Lista.Items.BeginUpdate;
  try
    { limpa o listview }
    LV_Lista.Items.Clear;
    for LCont := 0 to FListaTiposCliente.Count - 1 do
    begin
      FListaTiposCliente.ProcurarPorIndice(LCont, LTipoCliente);
      { exibe na lista }
      LItem := LV_Lista.Items.Add;
      LItem.Caption := LTipoCliente.TipoClienteId.ToString;
      LItem.SubItems.Add(LTipoCliente.Descricao);
    end;
  finally
    LV_Lista.Items.EndUpdate;
  end;
end;

end.

