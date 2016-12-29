unit Marvin.Desktop.Repositorio.AulaMulticamada;

interface

uses
  { marvin }
  uMRVClasses;

type
  IMRVRepositorioAulaMulticamada = interface(IMRVInterface)
    ['{93929E71-9BDB-4602-A110-3D36D665B704}']
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

implementation

end.
