unit Marvin.AulaMulticamada.Controlador.Intf;

interface

uses
  uMRVClasses;

type
  IMRVControladorTipoCliente = interface(IMRVInterface)
    ['{9B75598E-A04F-4879-975A-C0682708B47A}']
    procedure Inserir(const AItem: TMRVDadosBase);
    procedure Excluir(const AItem: TMRVDadosBase);
    procedure Alterar(const AItem: TMRVDadosBase);
    function ProcurarItem(const ACriterio, AResultado: TMRVDadosBase): Boolean;
    function ProcurarItens(const ACriterio: TMRVDadosBase; const AListaResultado:
      TMRVListaBase; const ASearchOption: TMRVSearchOption): Boolean;
    function RecuperarItens(const ACriterio: TMRVDadosBase; const
      AListaResultado: TMRVListaBase; const ASearchOption: TMRVSearchOption): Boolean;
  end;

  IMRVControladorCliente = interface(IMRVInterface)
    ['{9B75598E-A04F-4879-975A-C0682708B47A}']
    procedure Inserir(const AItem: TMRVDadosBase);
    procedure Excluir(const AItem: TMRVDadosBase);
    procedure Alterar(const AItem: TMRVDadosBase);
    function ProcurarItem(const ACriterio, AResultado: TMRVDadosBase): Boolean;
    function ProcurarItens(const ACriterio: TMRVDadosBase; const AListaResultado:
      TMRVListaBase; const ASearchOption: TMRVSearchOption): Boolean;
    function RecuperarItens(const ACriterio: TMRVDadosBase; const
      AListaResultado: TMRVListaBase; const ASearchOption: TMRVSearchOption): Boolean;
  end;

implementation

end.
