unit Marvin.Desktop.GUI.Cadastro.Cliente;

interface

uses
  { sistema }
  Marvin.AulaMulticamada.Classes.Cliente,
  Marvin.AulaMulticamada.Listas.Cliente,
  Marvin.AulaMulticamada.Classes.TipoCliente,
  Marvin.AulaMulticamada.Listas.TipoCliente,
  Marvin.Desktop.GUI.Cadastro.Base,
  { padrão }
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Actions,
  { firemonkey }
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ActnList,
  FMX.TabControl,
  FMX.Effects,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.ListView,
  FMX.Edit,
  FMX.DateTimeCtrls,
  FMX.ListBox,
  FMX.Layouts;

type
  TfraCadastroClientes = class(TfraCadastroBase)
    edtId: TEdit;
    lblId: TLabel;
    GlowEffect2: TGlowEffect;
    edtNome: TEdit;
    lblNome: TLabel;
    GlowEffect3: TGlowEffect;
    edtNumeroDocumento: TEdit;
    lblNumeroDocumento: TLabel;
    GlowEffect4: TGlowEffect;
    dtpDataCadastro: TDateEdit;
    dtpHoraCadastro: TTimeEdit;
    lblDataHoraCadastro: TLabel;
    GlowEffect5: TGlowEffect;
    GlowEffect6: TGlowEffect;
    cbbTipoCliente: TComboBox;
    lblTipoCliente: TLabel;
    GlowEffect7: TGlowEffect;
    rectInformacoesBasicas: TRectangle;
    sdw1: TShadowEffect;
    lblTituloInformacoesBasicas: TLabel;
    inrglwfct1: TInnerGlowEffect;
    retOutrasInformacoes: TRectangle;
    sdw2: TShadowEffect;
    ret1: TRectangle;
    ret2: TRectangle;
    lbl1: TLabel;
    inrglwfct2: TInnerGlowEffect;
    lin1: TLine;
    lin2: TLine;
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
    procedure DoInterfaceToObject(const AItem: TListViewItem); override;
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
  fraCadastroClientes: TfraCadastroClientes;

implementation

{$R *.fmx}

uses
  FMX.Ani,
  FMX.InertialMovement;

{ TfraCadastroClientes }

constructor TfraCadastroClientes.Create(AOwner: TComponent);
begin
  inherited;
  FCliente := TMRVCliente.Create;
  FListaClientes := TMRVListaCliente.Create;
  FListaTiposCliente := TMRVListaTipoCliente.Create;
end;

destructor TfraCadastroClientes.Destroy;
begin
  FreeAndNil(FListaTiposCliente);
  FreeAndNil(FListaClientes);
  FreeAndNil(FCliente);
  inherited;
end;

procedure TfraCadastroClientes.DoCarregarDadosAuxiliares;
begin
  { faz a carga dos dados no combobox de tipos de cliente }
  Self.GetTiposCliente;
  Self.SetTiposCliente;
end;

procedure TfraCadastroClientes.DoExcluir;
var
  LMensagem: string;
  LCliente: TMRVCliente;
begin
  inherited;
  LCliente := TMRVCliente.Create;
  try
    LCliente.Assign(FCliente);
    { manda o ClientModule excluir }
    LMensagem := Self.ClientModule.ClientesExcluir(LCliente);
  finally
    LCliente.DisposeOf;
  end;
  Self.ShowMessageBox(LMensagem);
  { atualiza a lista }
  Self.DoRefresh;
  { muda para a aba de lista }
  ChangeTabActionListagem.ExecuteTarget(lvLista);
end;

procedure TfraCadastroClientes.DoGetClientes;
var
  LCliente: TMRVCliente;
  LListaClientes: TMRVListaCliente;
begin
  LListaClientes := nil;
  { recupera os dados para o listview }
  LCliente := TMRVCliente.Create;
  try
    { pede para o ClientModule recuperar os tipos de clientes cadastrados }
    LListaClientes := Self.ClientModule.ClientesProcurarItens(LCliente) as
      TMRVListaCliente;
    { limpa a lista }
    if Assigned(LListaClientes) then
    begin
      FListaClientes.Clear;
      FListaClientes.AssignObjects(LListaClientes);
      LListaClientes.DisposeOf;
    end;
  finally
    LCliente.DisposeOf;
  end;
end;

procedure TfraCadastroClientes.DoGetFromInterface;
var
  LId: Integer;
begin
  LId := 0;
  if (edtId.Text.Trim <> EmptyStr) then
  begin
    LId := edtId.Text.toInteger;
  end;
  { recupera os dados da GUI }
  FCliente.Clienteid := LId;
  FCliente.Nome := edtNome.Text;
  FCliente.Numerodocumento := edtNumeroDocumento.Text;
  FCliente.Datahoracadastro := dtpDataCadastro.Date + dtpHoraCadastro.Time;
  { recupera o tipo do cliente }
  FCliente.TipoClienteId := Self.DoGetTipoClienteFromInterface;
end;

function TfraCadastroClientes.DoGetPositionTipoCliente: Integer;
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

function TfraCadastroClientes.DoGetTipoClienteFromInterface: Integer;
var
  LTipoCliente: TMRVTipoCliente;
begin
  Result := 0;
  if cbbTipoCliente.ItemIndex >= 0 then
  begin
    FListaTiposCliente.ProcurarPorIndice(cbbTipoCliente.ItemIndex, LTipoCliente);
    Result := LTipoCliente.TipoClienteId;
  end;
end;

procedure TfraCadastroClientes.DoInit;
begin
  inherited;
end;

procedure TfraCadastroClientes.DoInitInterface;
begin
  inherited;
  { limpa }
  edtId.Text := EmptyStr;
  edtNome.Text := EmptyStr;
  edtNumeroDocumento.Text := EmptyStr;
  dtpDataCadastro.Date := Now;
  dtpHoraCadastro.Time := Time;
  { vai para o index inicial }
  if cbbTipoCliente.Items.Count > 0 then
  begin
    cbbTipoCliente.ItemIndex := -1;
  end;
  { ajusta }
  edtId.Enabled := False;
  edtNome.SetFocus;
  { carrega dados auxiliares }
  Self.DoCarregarDadosAuxiliares;
end;

procedure TfraCadastroClientes.DoInterfaceToObject(const AItem: TListViewItem);
var
  LCliente: TMRVCliente;
begin
  inherited;
  { recupera }
  FCliente.Clear;
  FCliente.ClienteId := AItem.Detail.toInteger;
  FCliente.Nome := AItem.Text;
  { recupera os dados da lista }
  FListaClientes.ProcurarPorChave(FCliente.GetKey, LCliente);
  FCliente.Assign(LCliente);
  { carrega dados auxiliares }
  Self.DoCarregarDadosAuxiliares;
  { exibe }
  Self.DoObjectToInterface;
end;

procedure TfraCadastroClientes.DoObjectToInterface;
begin
  edtId.Text := FCliente.Clienteid.ToString;
  edtNome.Text := FCliente.Nome;
  edtNumeroDocumento.Text := FCliente.Numerodocumento;
  dtpDataCadastro.Date := FCliente.Datahoracadastro;
  dtpHoraCadastro.Time := FCliente.Datahoracadastro;
  { carrega o combo tipos de cliente }
  cbbTipoCliente.ItemIndex := Self.DoGetPositionTipoCliente;
end;

procedure TfraCadastroClientes.DoRefresh;
begin
  inherited;
  { carrega a lista de clientes no listview }
  Self.DoGetClientes;
  { exibe os dados }
  Self.DoShowClientes;
end;

procedure TfraCadastroClientes.DoSalvar;
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
        LCliente := Self.ClientModule.ClientesInserir(FCliente) as TMRVCliente;
        Self.EstadoCadastro := ecAlterar;
      end;
    ecAlterar:
      begin
        { manda o ClientModule alterar }
        LCliente := Self.ClientModule.ClientesAlterar(FCliente) as TMRVCliente;
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

procedure TfraCadastroClientes.DoShowClientes;
var
  LCont: Integer;
  LItem: TListViewItem;
  LCliente: TMRVCliente;
begin
  lvLista.BeginUpdate;
  try
    { limpa o listview }
    lvLista.Items.Clear;
    for LCont := 0 to FListaClientes.Count - 1 do
    begin
      FListaClientes.ProcurarPorIndice(LCont, LCliente);
      { exibe na lista }
      LItem := lvLista.Items.Add;
      LItem.Text := LCliente.Nome;
      LItem.Detail := LCliente.ClienteId.ToString;
    end;
  finally
    lvLista.EndUpdate;
  end;
  { carrega dados auxiliares }
  Self.DoCarregarDadosAuxiliares;
end;

procedure TfraCadastroClientes.GetTiposCliente;
var
  LTipoCliente: TMRVTipoCliente;
  LTiposCliente: TMRVListaTipoCliente;
begin
  LTipoCliente := TMRVTipoCliente.Create;
  try
    { recupera os tipos de cliente no ClientModule }
    LTiposCliente := Self.ClientModule.TiposClienteProcurarItens(LTipoCliente)
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

procedure TfraCadastroClientes.SetTiposCliente;
var
  LCont: Integer;
  LTipoCliente: TMRVTipoCliente;
begin
  { limpa os itens }
  cbbTipoCliente.Items.Clear;
  cbbTipoCliente.Enabled := False;
  try
    { adiciona os itens da lista de objetos }
    for LCont := 0 to FListaTiposCliente.Count - 1 do
    begin
      FListaTiposCliente.ProcurarPorIndice(LCont, LTipoCliente);
      cbbTipoCliente.Items.Add(LTipoCliente.GetKey);
    end;
  finally
    cbbTipoCliente.Enabled := True;
  end;
end;

end.


