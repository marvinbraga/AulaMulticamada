unit Marvin.VCL.GUI.Cadastro.Cliente;

interface

uses
  { marvin }
  Marvin.AulaMulticamada.Classes.Cliente,
  Marvin.AulaMulticamada.Listas.Cliente,
  Marvin.AulaMulticamada.Classes.TipoCliente,
  Marvin.AulaMulticamada.Listas.TipoCliente,
  Marvin.VCL.GUI.Cadastro.Base,
  { embarcdero }
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
  Vcl.ToolWin,
  Vcl.WinXCalendars;

type
  TMRVFrameCadastroCliente = class(TMRVFrameCadastroBase)
    PN_TituloInformacoesBasicas: TPanel;
    PN_InformacoesBasicas: TPanel;
    LE_Codigo: TLabeledEdit;
    LE_Nome: TLabeledEdit;
    PN_TituloOutrasInformacoes: TPanel;
    PN_OutrasInformacoes: TPanel;
    DT_DataCadastro: TDateTimePicker;
    LB_DataHoraCadastro: TLabel;
    DT_HoraCadastro: TDateTimePicker;
    LE_NumeroDocumento: TLabeledEdit;
    CB_TipoCliente: TComboBox;
    LB_TipoCliente: TLabel;
  private
    FCliente: TMRVCliente;
    FListaClientes: TMRVListaCliente;
    FListaTiposCliente: TMRVListaTipoCliente;
    procedure DoGetClientes;
    procedure DoShowClientes;
  protected
    { métodos de dados }
    procedure GetTiposCliente;
    procedure SetTiposCliente;
    procedure DoCarregarDadosAuxiliares;
    { métodos de interface GUI }
    procedure DoRefresh; override;
    procedure DoSalvar; override;
    procedure DoExcluir; override;
    procedure DoInterfaceToObject(const AItem: TListItem); override;
    procedure DoObjectToInterface;
    procedure DoGetFromInterface;
    function DoGetTipoClienteFromInterface: Integer;
    function DoGetPositionTipoCliente: Integer;
    procedure DoInitInterface; override;
    procedure DoInit; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Cliente: TMRVCliente read FCliente;
  end;

var
  MRVFrameCadastroCliente: TMRVFrameCadastroCliente;

implementation

{$R *.dfm}

{ TMRVFrameCadastroCliente }

constructor TMRVFrameCadastroCliente.Create(AOwner: TComponent);
begin
  inherited;
  FCliente := TMRVCliente.Create;
  FListaClientes := TMRVListaCliente.Create;
  FListaTiposCliente := TMRVListaTipoCliente.Create;
end;

destructor TMRVFrameCadastroCliente.Destroy;
begin
  FreeAndNil(FListaTiposCliente);
  FreeAndNil(FListaClientes);
  FreeAndNil(FCliente);
  inherited;
end;

procedure TMRVFrameCadastroCliente.DoCarregarDadosAuxiliares;
begin
  { faz a carga dos dados no combobox de tipos de cliente }
  Self.GetTiposCliente;
  Self.SetTiposCliente;
end;

procedure TMRVFrameCadastroCliente.DoExcluir;
var
  LMensagem: string;
  LCliente: TMRVCliente;
begin
  inherited;
  LCliente := TMRVCliente.Create;
  try
    LCliente.Assign(FCliente);
    { manda o ClientModule excluir }
    LMensagem := Self.ClientClasses.ClientesExcluir(LCliente);
  finally
    LCliente.DisposeOf;
  end;
  Self.ShowMessageBox(LMensagem);
  { atualiza a lista }
  Self.DoRefresh;
  { muda para a aba de lista }
  AT_Lista.ExecuteTarget(TS_Lista);
end;

procedure TMRVFrameCadastroCliente.DoGetClientes;
var
  LCliente: TMRVCliente;
  LListaClientes: TMRVListaCliente;
begin
  LListaClientes := nil;
  { recupera os dados para o listview }
  LCliente := TMRVCliente.Create;
  try
    { pede para o ClientModule recuperar os tipos de clientes cadastrados }
    LListaClientes := Self.ClientClasses.ClientesProcurarItens(LCliente) as
      TMRVListaCliente;
    { limpa a lista }
    if Assigned(LListaClientes) then
    begin
      FListaClientes.Clear;
      FListaClientes.AssignObjects(LListaClientes);
      LListaClientes.Free;
    end;
  finally
    LCliente.Free;
  end;
end;

procedure TMRVFrameCadastroCliente.DoGetFromInterface;
var
  LId: Integer;
begin
  LId := 0;
  if (Trim(LE_Codigo.Text) <> EmptyStr) then
  begin
    LId := StrToInt(LE_Codigo.Text);
  end;
  { recupera os dados da GUI }
  FCliente.Clienteid := LId;
  FCliente.Nome := LE_Nome.Text;
  FCliente.Numerodocumento := LE_NumeroDocumento.Text;
  FCliente.Datahoracadastro := DT_DataCadastro.Date + DT_HoraCadastro.Time;
  { recupera o tipo do cliente }
  FCliente.TipoClienteId := Self.DoGetTipoClienteFromInterface;
end;

function TMRVFrameCadastroCliente.DoGetPositionTipoCliente: Integer;
var
  LIndex: Integer;
  LTipoCliente: TMRVTipoCliente;
  LResult: Integer;
begin
  LResult := -1;
  for LIndex := 0 to FListaTiposCliente.Count - 1 do
  begin
    FListaTiposCliente.ProcurarPorIndice(LIndex, LTipoCliente);
    if LTipoCliente.TipoClienteId = FCliente.TipoClienteId then
    begin
      LResult := LIndex;
      Break;
    end;
  end;
  Result := LResult;
end;

function TMRVFrameCadastroCliente.DoGetTipoClienteFromInterface: Integer;
var
  LTipoCliente: TMRVTipoCliente;
begin
  Result := 0;
  if CB_TipoCliente.ItemIndex >= 0 then
  begin
    FListaTiposCliente.ProcurarPorIndice(CB_TipoCliente.ItemIndex, LTipoCliente);
    Result := LTipoCliente.TipoClienteId;
  end;
end;

procedure TMRVFrameCadastroCliente.DoInit;
begin
  inherited;
end;

procedure TMRVFrameCadastroCliente.DoInitInterface;
begin
  inherited;
  { limpa }
  LE_Codigo.Text := EmptyStr;
  LE_Nome.Text := EmptyStr;
  LE_NumeroDocumento.Text := EmptyStr;
  DT_DataCadastro.Date := Now;
  DT_HoraCadastro.Time := Time;
  { vai para o index inicial }
  if CB_TipoCliente.Items.Count > 0 then
  begin
    CB_TipoCliente.ItemIndex := -1;
  end;
  { ajusta }
  LE_Codigo.Enabled := False;
  LE_Nome.SetFocus;
  { carrega dados auxiliares }
  Self.DoCarregarDadosAuxiliares;
end;

procedure TMRVFrameCadastroCliente.DoInterfaceToObject(const AItem: TListItem);
var
  LCliente: TMRVCliente;
begin
  inherited;
  { recupera }
  FCliente.Clear;
  FCliente.ClienteId := AItem.Caption.ToInteger;
  FCliente.Nome := AItem.SubItems[0];
  { recupera os dados da lista }
  FListaClientes.ProcurarPorChave(FCliente.GetKey, LCliente);
  FCliente.Assign(LCliente);
  { carrega dados auxiliares }
  Self.DoCarregarDadosAuxiliares;
  { exibe }
  Self.DoObjectToInterface;
end;

procedure TMRVFrameCadastroCliente.DoObjectToInterface;
begin
  LE_Codigo.Text := FCliente.Clienteid.ToString;
  LE_Nome.Text := FCliente.Nome;
  LE_NumeroDocumento.Text := FCliente.Numerodocumento;
  DT_DataCadastro.Date := FCliente.Datahoracadastro;
  DT_HoraCadastro.Time := FCliente.Datahoracadastro;
  { carrega o combo tipos de cliente }
  CB_TipoCliente.ItemIndex := Self.DoGetPositionTipoCliente;
end;

procedure TMRVFrameCadastroCliente.DoRefresh;
begin
  inherited;
  { carrega a lista de clientes no listview }
  Self.DoGetClientes;
  { exibe os dados }
  Self.DoShowClientes;
end;

procedure TMRVFrameCadastroCliente.DoSalvar;
var
  LCliente: TMRVCliente;
begin
  inherited;
  LCliente := nil;
  Self.DoGetFromInterface;
  case Self.EstadoCadastro of
    ecNovo:
      begin
        { manda o ClientModule incluir }
        LCliente := Self.ClientClasses.ClientesInserir(FCliente) as TMRVCliente;
        Self.EstadoCadastro := ecAlterar;
      end;
    ecAlterar:
      begin
        { manda o ClientModule alterar }
        LCliente := Self.ClientClasses.ClientesAlterar(FCliente) as TMRVCliente;
      end;
  end;
  try
    FCliente.Assign(LCliente);
    { exibe a resposta }
    Self.DoObjectToInterface;
  finally
    { libera o retorno }
    LCliente.DisposeOf;
  end;
end;

procedure TMRVFrameCadastroCliente.DoShowClientes;
var
  LCont: Integer;
  LItem: TListItem;
  LCliente: TMRVCliente;
begin
  LV_Lista.Items.BeginUpdate;
  try
    { limpa o listview }
    LV_Lista.Items.Clear;
    for LCont := 0 to FListaClientes.Count - 1 do
    begin
      FListaClientes.ProcurarPorIndice(LCont, LCliente);
      { exibe na lista }
      LItem := LV_Lista.Items.Add;
      LItem.Caption := LCliente.ClienteId.ToString;
      LItem.SubItems.Add(LCliente.Nome);
    end;
  finally
    LV_Lista.Items.EndUpdate;
  end;
  { carrega dados auxiliares }
  Self.DoCarregarDadosAuxiliares;
end;

procedure TMRVFrameCadastroCliente.GetTiposCliente;
var
  LTipoCliente: TMRVTipoCliente;
  LTiposCliente: TMRVListaTipoCliente;
begin
  LTipoCliente := TMRVTipoCliente.Create;
  try
    { recupera os tipos de cliente no ClientModule }
    LTiposCliente := Self.ClientClasses.TiposClienteProcurarItens(LTipoCliente)
      as TMRVListaTipoCliente;
    try
      FListaTiposCliente.Clear;
      FListaTiposCliente.AssignObjects(LTiposCliente);
    finally
      LTiposCliente.DisposeOf;
    end;
  finally
    LTipoCliente.DisposeOf;
  end;
end;

procedure TMRVFrameCadastroCliente.SetTiposCliente;
var
  LCont: Integer;
  LTipoCliente: TMRVTipoCliente;
begin
  { limpa os itens }
  CB_TipoCliente.Items.Clear;
  CB_TipoCliente.Enabled := False;
  try
    { adiciona os itens da lista de objetos }
    for LCont := 0 to FListaTiposCliente.Count - 1 do
    begin
      FListaTiposCliente.ProcurarPorIndice(LCont, LTipoCliente);
      CB_TipoCliente.Items.Add(LTipoCliente.GetKey);
    end;
  finally
    CB_TipoCliente.Enabled := True;
  end;
end;

end.

