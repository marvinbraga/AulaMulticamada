unit Marvin.Desktop.GUI.Cadastro.TipoCliente;

interface

uses
  { sistema }
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
  FMX.Layouts;

type
  TfraCadastroTipoCliente = class(TfraCadastroBase)
    retInformacoesBasicas: TRectangle;
    edtId: TEdit;
    lbl1: TLabel;
    glwfct1: TGlowEffect;
    edtDescricao: TEdit;
    lblDescricao: TLabel;
    glwfct2: TGlowEffect;
    sdw1: TShadowEffect;
    ret1: TRectangle;
    lblTituloInformacoesBasicas: TLabel;
    inrglwfct1: TInnerGlowEffect;
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
    procedure DoInterfaceToObject(const AItem: TListViewItem); override;
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
  fraCadastroTipoCliente: TfraCadastroTipoCliente;

implementation

{$R *.fmx}

{ TfraCadastroTipoCliente }

constructor TfraCadastroTipoCliente.Create(AOwner: TComponent);
begin
  inherited;
  FTipoCliente := TMRVTipoCliente.Create;
  FListaTiposCliente := TMRVListaTipoCliente.Create;
end;

destructor TfraCadastroTipoCliente.Destroy;
begin
  FreeAndNil(FTipoCliente);
  FreeAndNil(FListaTiposCliente);
  inherited;
end;

procedure TfraCadastroTipoCliente.DoExcluir;
var
  LMensagem: string;
  LTipoCliente: TMRVTipoCliente;
begin
  inherited;
  LTipoCliente := TMRVTipoCliente.Create;
  try
    LTipoCliente.Assign(FTipoCliente);
    { manda o ClientModule excluir }
    LMensagem := Self.ClientModule.TiposClienteExcluir(LTipoCliente);
  finally
    LTipoCliente.DisposeOf;
  end;
  ShowMessage(LMensagem);
  { atualiza a lista }
  Self.DoRefresh;
  { muda para a aba de lista }
  ChangeTabActionListagem.ExecuteTarget(lvLista);
end;

procedure TfraCadastroTipoCliente.DoGetFromInterface;
var
  LId: Integer;
begin
  LId := 0;
  if (edtId.Text.Trim <> EmptyStr) then
  begin
    LId := edtId.Text.toInteger;
  end;
  { recupera os dados da GUI }
  FTipoCliente.TipoClienteId := LId;
  FTipoCliente.Descricao := edtDescricao.Text;
end;

procedure TfraCadastroTipoCliente.DoGetTiposCliente;
var
  LTipoCliente: TMRVTipoCliente;
  LListaTiposCliente: TMRVListaTipoCliente;
begin
  LListaTiposCliente := nil;
  { recupera os dados para o listview }
  LTipoCliente := TMRVTipoCliente.Create;
  try
    { pede para o ClientModule recuperar os tipos de clientes cadastrados }
    LListaTiposCliente := Self.ClientModule.TiposClienteProcurarItens(LTipoCliente)
      as TMRVListaTipoCliente;
    { se trouxe dados }
    if Assigned(LListaTiposCliente) then
    begin
      { recupera para a lista }
      FListaTiposCliente.Clear;
      FListaTiposCliente.AssignObjects(LListaTiposCliente);
      { libera a lista temporária }
      LListaTiposCliente.DisposeOf;
    end;
  finally
    LTipoCliente.DisposeOf;
  end;
end;

procedure TfraCadastroTipoCliente.DoInitInterface;
begin
  inherited;
  { limpa }
  edtId.Text := EmptyStr;
  edtDescricao.Text := EmptyStr;
  { ajusta }
  edtId.Enabled := False;
  edtDescricao.SetFocus;
end;

procedure TfraCadastroTipoCliente.DoInit;
begin
  inherited;
end;

procedure TfraCadastroTipoCliente.DoInterfaceToObject(const AItem: TListViewItem);
begin
  inherited;
  { recupera }
  FTipoCliente.TipoClienteId := AItem.Detail.toInteger;
  FTipoCliente.Descricao := AItem.Text;
  { exibe }
  Self.DoObjectToInterface;
end;

procedure TfraCadastroTipoCliente.DoObjectToInterface;
begin
  case Self.EstadoCadastro of
    ecNovo:
      begin
        edtId.Enabled := False;
        edtDescricao.SetFocus;
      end;
    ecAlterar:
      begin
        edtId.Enabled := True;
        edtId.SetFocus;
      end;
  end;
  edtId.Text := FTipoCliente.TipoClienteId.ToString;
  edtDescricao.Text := FTipoCliente.Descricao;
end;

procedure TfraCadastroTipoCliente.DoRefresh;
begin
  inherited;
  { recupera os dados para a lista de objetos }
  Self.DoGetTiposCliente;
  { exibe os dados }
  Self.DoShowTiposCliente;
end;

procedure TfraCadastroTipoCliente.DoSalvar;
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
        LTipoCliente := Self.ClientModule.TiposClienteInserir(FTipoCliente) as
          TMRVTipoCliente;
        Self.EstadoCadastro := ecAlterar;
      end;
    ecAlterar:
      begin
        { manda o ClientModule alterar }
        LTipoCliente := Self.ClientModule.TiposClienteAlterar(FTipoCliente) as
          TMRVTipoCliente;
      end;
  end;
  try
    FTipoCliente.Assign(LTipoCliente);
    { exibe a resposta }
    Self.DoObjectToInterface;
  finally
    { libera o retorno }
    LTipoCliente.DisposeOf;
  end;
end;

procedure TfraCadastroTipoCliente.DoShowTiposCliente;
var
  LCont: Integer;
  LItem: TListViewItem;
  LTipoCliente: TMRVTipoCliente;
begin
  lvLista.BeginUpdate;
  try
    { limpa o listview }
    lvLista.Items.Clear;
    for LCont := 0 to FListaTiposCliente.Count - 1 do
    begin
      FListaTiposCliente.ProcurarPorIndice(LCont, LTipoCliente);
      { exibe na lista }
      LItem := lvLista.Items.Add;
      LItem.Text := LTipoCliente.Descricao;
      LItem.Detail := LTipoCliente.TipoClienteId.ToString;
    end;
  finally
    lvLista.EndUpdate;
  end;
end;

end.


