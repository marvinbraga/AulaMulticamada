unit Marvin.Desktop.ClientClasses.AulaMulticamada;

interface

uses
  uMRVClasses,
  { repositório }
  Marvin.Desktop.Repositorio.AulaMulticamada;

type
  coAulaMulticamadasClientJSON = class
  private
    { singleton }
    class var FInstancia: IMRVRepositorioAulaMulticamada;
  strict private
    class function GetInstancia: IMRVRepositorioAulaMulticamada; static;
  public
    class function Create: IMRVRepositorioAulaMulticamada;
  end;

implementation

uses
  { ClientModule }
  Marvin.Desktop.ClientModule.AulaMulticamada,
  { dados }
  Marvin.AulaMulticamada.Listas.TipoCliente,
  Marvin.AulaMulticamada.Classes.TipoCliente,
  Marvin.AulaMulticamada.Listas.Cliente,
  Marvin.AulaMulticamada.Classes.Cliente,
  { embarcadero }
  System.SysUtils;

type
  TMRVClientClassesAulaMulticamadaJSON = class(TMRVObjetoBase,
    IMRVRepositorioAulaMulticamada)
  private
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    { cliente }
    function ClientesProcurarItens(const ACliente: TMRVDadosBase): TMRVListaBase;
    function ClientesProcurarItem(const ACliente: TMRVDadosBase): TMRVDadosBase;
    function ClientesInserir(const ACliente: TMRVDadosBase): TMRVDadosBase;
    function ClientesAlterar(const ACliente: TMRVDadosBase): TMRVDadosBase;
    function ClientesExcluir(const ACliente: TMRVDadosBase): string;
    { tipo de cliente }
    function TiposClienteProcurarItens(const ATipoCliente: TMRVDadosBase): TMRVListaBase;
    function TiposClienteInserir(const ATipoCliente: TMRVDadosBase): TMRVDadosBase;
    function TiposClienteAlterar(const ATipoCliente: TMRVDadosBase): TMRVDadosBase;
    function TiposClienteExcluir(const ATipoCliente: TMRVDadosBase): string;
  end;

{ coAulaMulticamadasClient }

{ /************************************************************************/
  | Fábrica que irá instanciar um objeto para conexão com o servidor.      |
  /************************************************************************/ }
class function coAulaMulticamadasClientJSON.Create: IMRVRepositorioAulaMulticamada;
begin
  Result := coAulaMulticamadasClientJSON.GetInstancia;
end;

class function coAulaMulticamadasClientJSON.GetInstancia: IMRVRepositorioAulaMulticamada;
begin
  if not (Assigned(FInstancia)) then
  begin
    FInstancia := TMRVClientClassesAulaMulticamadaJSON.Create;
  end;
  Result := FInstancia;
end;

{ TMRVClientClassesAulaMulticamadaJSON }

constructor TMRVClientClassesAulaMulticamadaJSON.Create;
begin
  inherited;
  if not Assigned(ClientModuleAulaMulticamada) then
  begin
    { cria o ClientModule JSON/REST }
    ClientModuleAulaMulticamada := TClientModuleAulaMulticamada.Create(nil);
  end;
end;

destructor TMRVClientClassesAulaMulticamadaJSON.Destroy;
begin
  FreeAndNil(ClientModuleAulaMulticamada);
  inherited;
end;

{$REGION 'Métodos para Cliente.'}
{ /************************************************************************/
  | Métodos para CLIENTE.                                                  |
  /************************************************************************/ }
function TMRVClientClassesAulaMulticamadaJSON.ClientesAlterar(const ACliente:
  TMRVDadosBase): TMRVDadosBase;
begin
  { recupera todos os clientes }
  Result := ClientModuleAulaMulticamada.SendObject('Cliente', ACliente,
    TMRVCliente, taPost);
end;

function TMRVClientClassesAulaMulticamadaJSON.ClientesExcluir(const ACliente:
  TMRVDadosBase): string;
begin
  { excluí o cliente informado }
  Result := ClientModuleAulaMulticamada.ExecuteJSONById('Cliente',
    TMRVCliente(ACliente).Clienteid.ToString, taCancel);
  { verifica se existe alguma exceção }
  ClientModuleAulaMulticamada.CheckException(Result);
  { recupera o resultado }
  Result := ClientModuleAulaMulticamada.GetResultValue(Result, 'Mensagem');
end;

function TMRVClientClassesAulaMulticamadaJSON.ClientesInserir(const ACliente:
  TMRVDadosBase): TMRVDadosBase;
begin
  Result := ClientModuleAulaMulticamada.SendObject('Cliente', ACliente,
    TMRVCliente, taAccept);
end;

function TMRVClientClassesAulaMulticamadaJSON.ClientesProcurarItem(const
  ACliente: TMRVDadosBase): TMRVDadosBase;
begin
  Result := ClientModuleAulaMulticamada.GetObject('Cliente', TMRVCliente);
end;

function TMRVClientClassesAulaMulticamadaJSON.ClientesProcurarItens(const
  ACliente: TMRVDadosBase): TMRVListaBase;
begin
  Result := ClientModuleAulaMulticamada.GetObjects('Cliente', TMRVListaCliente);
end;
{$ENDREGION}

{$REGION 'Métodos para Tipo de Cliente'}
{ /************************************************************************/
  | Métodos para TIPO DE CLIENTE.                                          |
  /************************************************************************/ }
function TMRVClientClassesAulaMulticamadaJSON.TiposClienteAlterar(const
  ATipoCliente: TMRVDadosBase): TMRVDadosBase;
begin
  Result := ClientModuleAulaMulticamada.SendObject('TipoCliente', ATipoCliente,
    TMRVTipoCliente, taPost);
end;

function TMRVClientClassesAulaMulticamadaJSON.TiposClienteExcluir(const
  ATipoCliente: TMRVDadosBase): string;
begin
  { recupera os dados }
  Result := ClientModuleAulaMulticamada.ExecuteJSONById('TipoCliente',
    TMRVTipoCliente(ATipoCliente).TipoClienteId.ToString, taCancel);
  { verifica se existe alguma exceção }
  ClientModuleAulaMulticamada.CheckException(Result);
  { recupera resultado }
  Result := ClientModuleAulaMulticamada.GetResultValue(Result, 'Mensagem');
end;

function TMRVClientClassesAulaMulticamadaJSON.TiposClienteInserir(const
  ATipoCliente: TMRVDadosBase): TMRVDadosBase;
begin
  Result := ClientModuleAulaMulticamada.SendObject('TipoCliente', ATipoCliente,
    TMRVTipoCliente, taAccept);
end;

function TMRVClientClassesAulaMulticamadaJSON.TiposClienteProcurarItens(const
  ATipoCliente: TMRVDadosBase): TMRVListaBase;
begin
  Result := ClientModuleAulaMulticamada.GetObjects('TipoCliente',
    TMRVListaTipoCliente);
end;
{$ENDREGION}

initialization

finalization
  { libera o singleton }
  if Assigned(coAulaMulticamadasClientJSON.FInstancia) then
  begin
    coAulaMulticamadasClientJSON.FInstancia := nil;
  end;

end.


