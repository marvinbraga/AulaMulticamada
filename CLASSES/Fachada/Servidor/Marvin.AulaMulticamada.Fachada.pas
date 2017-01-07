{  Arquivo criado automaticamente Gerador Multicamadas
   (Multitiers Generator VERSÃO 0.01)
   Data e Hora: 11/10/2016 - 23:04:17
}
unit Marvin.AulaMulticamada.Fachada;

interface

uses
  uMRVClasses,
  { ambiente }
  Marvin.System.Facade.Ambiente,
  { interface }
  Marvin.AulaMulticamada.Controlador.Intf,
  {controladores}
  Marvin.AulaMulticamada.Controlador.Cliente,
  Marvin.AulaMulticamada.Controlador.TipoCliente,
  { cadastros }
  Marvin.AulaMulticamada.Cadastro.Cliente,
  Marvin.AulaMulticamada.Cadastro.TipoCliente;

type
  TMRVFachadaAulaMulticamada = class(TMRVFachadaAmbiente)
  strict private
    { cadastros }
    FCadastroCliente: TMRVCadastroCliente;
    FCadastroTipoCliente: TMRVCadastroTipoCliente;
    { controladores }
    FControladorCliente: IMRVControladorCliente;
    FControladorTipoCliente: IMRVControladorTipoCliente;
  protected
    { inicialização }
    procedure DoContinuarInicializandoCadastros; override;
    procedure DoLiberarCadastros; override;
    { Cliente }
    procedure DoClientesInserir(const AItem: TMRVDadosBase);
    procedure DoClientesAlterar(const AItem: TMRVDadosBase);
    procedure DoClientesExcluir(const AItem: TMRVDadosBase);
    { TipoCliente }
    procedure DoTipoClientesInserir(const AItem: TMRVDadosBase);
    procedure DoTipoClientesAlterar(const AItem: TMRVDadosBase);
    procedure DoTipoClientesExcluir(const AItem: TMRVDadosBase);
  public
    { métodos externos }
    constructor Create; override;
    destructor Destroy; override;
    { Cliente }
    procedure ClientesInserir(const AItem: TMRVDadosBase);
    procedure ClientesAlterar(const AItem: TMRVDadosBase);
    procedure ClientesExcluir(const AItem: TMRVDadosBase);
    function ClientesProcurarItem(const ACriterio: TMRVDadosBase; const
      AResultado: TMRVDadosBase = nil): Boolean;
    function ClientesProcurarItens(const ACriterio: TMRVDadosBase; const
      AListaResultado: TMRVListaBase; const ASearchOption: TMRVSearchOption): Boolean;
    { TipoCliente }
    procedure TipoClientesInserir(const AItem: TMRVDadosBase);
    procedure TipoClientesAlterar(const AItem: TMRVDadosBase);
    procedure TipoClientesExcluir(const AItem: TMRVDadosBase);
    function TipoClientesProcurarItem(const ACriterio: TMRVDadosBase; const
      AResultado: TMRVDadosBase = nil): Boolean;
    function TipoClientesProcurarItens(const ACriterio: TMRVDadosBase; const
      AListaResultado: TMRVListaBase; const ASearchOption: TMRVSearchOption): Boolean;
  end;

implementation

uses
  SysUtils,
  { BD }
  Marvin.AulaMulticamada.Bd.Cliente,
  Marvin.AulaMulticamada.Bd.TipoCliente,
  { repositórios }
  Marvin.AulaMulticamada.Repositorio.Cliente,
  Marvin.AulaMulticamada.Repositorio.TipoCliente;

{ TMRVFachadaPolitica }

procedure TMRVFachadaAulaMulticamada.ClientesAlterar(const AItem: TMRVDadosBase);
begin
  { controla a transação }
  Self.DataBase.StartTransaction;
  try
    { chama o método interno }
    DoClientesAlterar(AItem);
    Self.DataBase.Commit;
  except
    Self.DataBase.Rollback;
    raise;
  end;
  Self.ClientesProcurarItem(AItem, AItem);
end;

function TMRVFachadaAulaMulticamada.ClientesProcurarItem(const ACriterio,
  AResultado: TMRVDadosBase): Boolean;
begin
  { controlador executa o método e não o cadastro }
  Result := FControladorCliente.ProcurarItem(ACriterio, AResultado);
end;

procedure TMRVFachadaAulaMulticamada.ClientesExcluir(const AItem: TMRVDadosBase);
begin
  { controla a transação }
  Self.DataBase.StartTransaction;
  try
    { chama o método interno }
    DoClientesExcluir(AItem);
    Self.DataBase.Commit;
  except
    Self.DataBase.Rollback;
    raise;
  end;
end;

procedure TMRVFachadaAulaMulticamada.ClientesInserir(const AItem: TMRVDadosBase);
begin
  { controla a transação }
  Self.DataBase.StartTransaction;
  try
    { chama o método interno }
    DoClientesInserir(AItem);
    Self.DataBase.Commit;
  except
    Self.DataBase.Rollback;
    raise;
  end;
end;

function TMRVFachadaAulaMulticamada.ClientesProcurarItens(const ACriterio:
  TMRVDadosBase; const AListaResultado: TMRVListaBase; const ASearchOption:
  TMRVSearchOption): Boolean;
begin
  { controlador executa o método e não o cadastro }
  Result := FControladorCliente.ProcurarItens(ACriterio, AListaResultado, ASearchOption);
end;

procedure TMRVFachadaAulaMulticamada.DoClientesInserir(const AItem: TMRVDadosBase);
begin
  { controlador executa o método e não o cadastro }
  FControladorCliente.Inserir(AItem);
end;

procedure TMRVFachadaAulaMulticamada.DoClientesAlterar(const AItem: TMRVDadosBase);
begin
  { controlador executa o método e não o cadastro }
  FControladorCliente.Alterar(AItem);
end;

procedure TMRVFachadaAulaMulticamada.DoClientesExcluir(const AItem: TMRVDadosBase);
begin
  { controlador executa o método e não o cadastro }
  FControladorCliente.Excluir(AItem);
end;

constructor TMRVFachadaAulaMulticamada.Create;
begin
  inherited;
  { aterra os cadastros }
  FCadastroCliente := nil;
  FCadastroTipoCliente := nil;
  { controladores }
  FControladorCliente := nil;
  FControladorTipoCliente := nil;
end;

destructor TMRVFachadaAulaMulticamada.Destroy;
begin
  inherited;
end;

procedure TMRVFachadaAulaMulticamada.DoContinuarInicializandoCadastros;
var
  LBdCliente: IMRVRepositorioCliente;
  LBdTipoCliente: IMRVRepositorioTipoCliente;
begin
  inherited;
  { Cliente }
  if (FCadastroCliente <> nil) then
  begin
    LBdCliente := nil;
    FreeAndNil(FCadastroCliente);
  end;
  LBdCliente := CoMRVBdCliente.Create(Self.DataBase);
  FCadastroCliente := TMRVCadastroCliente.Create(LBdCliente);
  { TipoCliente }
  if (FCadastroTipoCliente <> nil) then
  begin
    LBdTipoCliente := nil;
    FreeAndNil(FCadastroTipoCliente);
  end;
  LBdTipoCliente := CoMRVBdTipoCliente.Create(Self.DataBase);
  FCadastroTipoCliente := TMRVCadastroTipoCliente.Create(LBdTipoCliente);
  { inicializa os controladores passando os cadastros por parâmetro }
  FControladorCliente := coMRVControladorCliente.Create(FCadastroCliente,
    FCadastroTipoCliente);
  FControladorTipoCliente := coMRVControladorTipoCliente.Create(FCadastroTipoCliente,
    FCadastroCliente);
end;

procedure TMRVFachadaAulaMulticamada.DoLiberarCadastros;
begin
  inherited;
  { libera os cadastros }
  FreeAndNil(FCadastroCliente);
  { libera os cadastros }
  FreeAndNil(FCadastroTipoCliente);
  { libera os controladores }
  FControladorCliente := nil;
  FControladorTipoCliente := nil;
end;

procedure TMRVFachadaAulaMulticamada.DoTipoClientesAlterar(const AItem: TMRVDadosBase);
begin
  FControladorTipoCliente.Alterar(AItem);
end;

procedure TMRVFachadaAulaMulticamada.DoTipoClientesExcluir(const AItem: TMRVDadosBase);
begin
  FControladorTipoCliente.Excluir(AItem);
end;

procedure TMRVFachadaAulaMulticamada.DoTipoClientesInserir(const AItem: TMRVDadosBase);
begin
  FControladorTipoCliente.Inserir(AItem);
end;

procedure TMRVFachadaAulaMulticamada.TipoClientesAlterar(const AItem: TMRVDadosBase);
begin
  { controla a transação }
  Self.DataBase.StartTransaction;
  try
    { chamao método interno }
    DoTipoClientesAlterar(AItem);
    Self.DataBase.Commit;
  except
    Self.DataBase.Rollback;
    raise;
  end;
  Self.TipoClientesProcurarItem(AItem, AItem);
end;

procedure TMRVFachadaAulaMulticamada.TipoClientesExcluir(const AItem: TMRVDadosBase);
begin
  { controla a transação }
  Self.DataBase.StartTransaction;
  try
    { chama o método interno }
    DoTipoClientesExcluir(AItem);
    Self.DataBase.Commit;
  except
    Self.DataBase.Rollback;
    raise;
  end;
end;

procedure TMRVFachadaAulaMulticamada.TipoClientesInserir(const AItem: TMRVDadosBase);
begin
  { controla a transação }
  Self.DataBase.StartTransaction;
  try
    { chama o método interno }
    DoTipoClientesInserir(AItem);
    Self.DataBase.Commit;
  except
    Self.DataBase.Rollback;
    raise;
  end;
end;

function TMRVFachadaAulaMulticamada.TipoClientesProcurarItem(const ACriterio,
  AResultado: TMRVDadosBase): Boolean;
begin
  Result := FControladorTipoCliente.ProcurarItem(ACriterio, AResultado);
end;

function TMRVFachadaAulaMulticamada.TipoClientesProcurarItens(const ACriterio:
  TMRVDadosBase; const AListaResultado: TMRVListaBase; const ASearchOption:
  TMRVSearchOption): Boolean;
begin
  Result := FControladorTipoCliente.ProcurarItens(ACriterio, AListaResultado, ASearchOption);
end;

end.


