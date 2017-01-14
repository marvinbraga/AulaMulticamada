unit Marvin.AulaMulticamada.Controlador.TipoCliente;

interface

uses
  { embarcadero }
  Classes,
  { marvin }
  uMRVControladorBase,
  uMRVClasses,
  uMRVClassesServidor,
  { interfaces }
  Marvin.AulaMulticamada.Controlador.Intf,
  { exceções }
  Marvin.AulaMulticamada.Excecoes.Cliente,
  Marvin.AulaMulticamada.Excecoes.TipoCliente,
   { cadastros }
  Marvin.AulaMulticamada.Cadastro.Cliente,
  Marvin.AulaMulticamada.Cadastro.TipoCliente,
   { classes de dados e listas }
  Marvin.AulaMulticamada.Classes.TipoCliente,
  Marvin.AulaMulticamada.Classes.Cliente,
  Marvin.AulaMulticamada.Listas.Cliente;

type
  coMRVControladorTipoCliente = class
  public
    class function Create(ATipoCliente: TMRVCadastroTipoCliente;
      ACliente: TMRVCadastroCliente): IMRVControladorTipoCliente;
  end;

implementation

uses
   { marvin }
  uMRVCadastroBase;

type
  TMRVControladorTipoCliente = class(TMRVControladorBase, IMRVControladorTipoCliente)
  private
      { cadastros }
    FCadastroCliente: TMRVCadastroCliente;
    FCadastroTipoCliente: TMRVCadastroTipoCliente;
    procedure TipoClienteExiste(const ATipoCliente: TMRVTipoCliente);
  protected
    procedure ExistemDependencias(const AItem: TMRVDadosBase); virtual;
    procedure ComplementarDados(const AItem: TMRVDadosBase);
  public
      { recebe os cadastros que serão utilizados }
    constructor Create(ATipoCliente: TMRVCadastroTipoCliente;
      ACliente: TMRVCadastroCliente); reintroduce; overload;
    destructor Destroy; override;
      { métodos do diagrama de casos de uso }
    procedure Inserir(const AItem: TMRVDadosBase); virtual;
    procedure Excluir(const AItem: TMRVDadosBase); virtual;
    procedure Alterar(const AItem: TMRVDadosBase); virtual;
    function ProcurarItem(const ACriterio, AResultado: TMRVDadosBase): Boolean; virtual;
    function ProcurarItens(const ACriterio: TMRVDadosBase; const AListaResultado:
      TMRVListaBase; const ASearchOption: TMRVSearchOption): Boolean; virtual;
    function RecuperarItens(const ACriterio: TMRVDadosBase; const
      AListaResultado: TMRVListaBase; const ASearchOption: TMRVSearchOption): Boolean;
  end;

{ coMRVControladorTipoCliente }

class function coMRVControladorTipoCliente.Create(ATipoCliente: TMRVCadastroTipoCliente;
  ACliente: TMRVCadastroCliente): IMRVControladorTipoCliente;
begin
  Result := TMRVControladorTipoCliente.Create(ATipoCliente, ACliente);
end;


{ TMRVControladorCliente }

constructor TMRVControladorTipoCliente.Create(ATipoCliente: TMRVCadastroTipoCliente;
  ACliente: TMRVCadastroCliente);
begin
  inherited Create;
   { recupera as referências de todos os cadastros }
  FCadastroCliente := ACliente;
  FCadastroTipoCliente := ATipoCliente;
end;

destructor TMRVControladorTipoCliente.Destroy;
begin
   { aterra todos os cadastros }
  FCadastroCliente := nil;
  FCadastroTipoCliente := nil;
  inherited;
end;

procedure TMRVControladorTipoCliente.Inserir(const AItem: TMRVDadosBase);
begin
  { Inclui o tipo de cliente }
  FCadastroTipoCliente.Inserir(AItem);
end;

procedure TMRVControladorTipoCliente.Excluir(const AItem: TMRVDadosBase);
begin
   { Realiza o tratamento das dependências }
  Self.ExistemDependencias(AItem);
   { Exclui o objeto principal }
  FCadastroTipoCliente.Excluir(AItem);
end;

procedure TMRVControladorTipoCliente.Alterar(const AItem: TMRVDadosBase);
begin
  { Inclui o tipo de cliente }
  FCadastroTipoCliente.Alterar(AItem);
end;

function TMRVControladorTipoCliente.ProcurarItem(const ACriterio, AResultado:
  TMRVDadosBase): Boolean;
begin
  { procura o tipo de cliente }
  Result := FCadastroTipoCliente.ProcurarItem(ACriterio, AResultado);
end;

function TMRVControladorTipoCliente.ProcurarItens(const ACriterio: TMRVDadosBase;
  const AListaResultado: TMRVListaBase; const ASearchOption: TMRVSearchOption): Boolean;
begin
  { procura por tipos de cliente }
  Result := FCadastroTipoCliente.ProcurarItems(ACriterio, AListaResultado, ASearchOption);
end;

procedure TMRVControladorTipoCliente.ExistemDependencias(const AItem: TMRVDadosBase);
begin
  inherited;
  Self.TipoClienteExiste(AItem as TMRVTipoCliente);
end;

function TMRVControladorTipoCliente.RecuperarItens(const ACriterio: TMRVDadosBase;
  const AListaResultado: TMRVListaBase; const ASearchOption: TMRVSearchOption): Boolean;
var
  LIndex: Integer;
begin
  { esse método é utilizados quando existem objetos agregados }
  Result := FCadastroTipoCliente.ProcurarItems(ACriterio, AListaResultado, ASearchOption);
  for LIndex := 0 to AListaResultado.Count - 1 do
  begin
    Self.ComplementarDados(AListaResultado.ProcurarPorIndice(LIndex));
  end;
end;

procedure TMRVControladorTipoCliente.TipoClienteExiste(const ATipoCliente: TMRVTipoCliente);
var
  LCliente: TMRVCliente;
  LSearchOption: TMRVSearchOption;
  LListaClientes: TMRVListaCliente;
begin
  { verifica se o tipo de cliente existe }
  LCliente := TMRVCliente.Create;
  try
    LSearchOption := TMRVSearchOption.Create(LCliente);
    try
      LListaClientes := TMRVListaCliente.Create;
      try
        { recupera o ID para consulta }
        LCliente.TipoClienteId := ATipoCliente.TipoClienteId;
        { informa a propriedade que será pesquisada }
        LSearchOption.SetSearchingFor(['TipoClienteId']);
        { faz a consulta }
        if FCadastroCliente.ProcurarItems(LCliente, LListaClientes,
          LSearchOption) then
        begin
          { se existirem clientes então informa que não pode excluir }
          raise EMRVTipoClienteFereIntegridadeReferencial.Create(
            'Este Tipo de Cliente não pode ser excluído.' + #13#10 +
            'Existem clientes associados a ele.');
        end;
      finally
        LListaClientes.Free;
      end;
    finally
      LSearchOption.Free;
    end;
  finally
    LCliente.Free;
  end;
end;

procedure TMRVControladorTipoCliente.ComplementarDados(const AItem: TMRVDadosBase);
begin
  { esse método é utilizados quando existem objetos agregados }
end;

end.
