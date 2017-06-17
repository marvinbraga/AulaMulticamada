unit Marvin.AulaMulticamada.REST.Server.Metodos;

interface

uses
  { marvin }
  uMRVClasses,
  Marvin.System.Classes.Ambiente,
  Marvin.System.Classes.Ambiente.Usuario,
  Marvin.AulaMulticamada.Fachada,
  Marvin.AulaMulticamada.Fachada.Singleton,
  Marvin.AulaMulticamada.Listas.TipoCliente,
  Marvin.AulaMulticamada.Classes.TipoCliente,
  Marvin.AulaMulticamada.Listas.Cliente,
  Marvin.AulaMulticamada.Classes.Cliente,
  { embarcadero }
  System.SysUtils,
  System.Classes,
  System.Json,
  Datasnap.DSServer,
  Datasnap.DSAuth;

type
{$METHODINFO ON}
  TAulaMulticamadaServerMetodos = class(TComponent)
  private
    FFachada: TMRVFachadaAulaMulticamada;
    FAmbiente: TMRVAmbiente;
    FAmbienteUsuario: TMRVAmbienteUsuario;
    { métodos de apoio }
    function GetException(const AException: Exception; const ADescricaoOperacao:
      string): TJSONValue;
    function GetResult(const ADado: TMRVDadosBase; const ADescricaoOperacao:
      string): TJSONValue;
    function GetResults(const ALista: TMRVListaBase; const ADescricaoOperacao:
      string): TJSONValue;
  protected
    procedure DoInicializarFachada;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { funções de testes }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    { tipos de cliente }
    function TipoCliente(const AObjectId: Integer): TJSONValue;
    function GetTipoCliente(const AObjectId: Integer): TJSONValue;
    function GetTiposCliente: TJSONValue;
    function UpdateTipoCliente(const ATipoCliente: TMRVTipoCliente): TJSONValue;
    function AcceptTipoCliente(const ATipoCliente: TMRVTipoCliente): TJSONValue;
    function CancelTipoCliente(const AObjectId: Integer): TJSONValue;
    { cliente }
    function Cliente(const AObjectId: Integer): TJSONValue;
    function GetCliente(const AObjectId: Integer): TJSONValue;
    function GetClientes: TJSONValue;
    function UpdateCliente(const ACliente: TMRVCliente): TJSONValue;
    function AcceptCliente(const ACliente: TMRVCliente): TJSONValue;
    function CancelCliente(const AObjectId: Integer): TJSONValue;
  end;
{$METHODINFO OFF}

implementation

uses
  uMRVSerializador,
  System.StrUtils;

constructor TAulaMulticamadaServerMetodos.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAmbienteUsuario := nil;
  FAmbiente := nil;
  { recupera a fachada }
  FFachada := TMRVAulaMulticamadasFacadeSingletonSealed.Instancia;
  { verifica as conexões }
  if not FFachada.IsConnected then
  begin
    FAmbienteUsuario := TMRVAmbienteUsuario.Create;
    FAmbiente := TMRVAmbiente.Create;
  { inicializa a fachada }
    Self.DoInicializarFachada;
  end;
end;

destructor TAulaMulticamadaServerMetodos.Destroy;
begin
  if Assigned(FAmbienteUsuario) then
  begin
    FreeAndNil(FAmbienteUsuario);
  end;
  if Assigned(FAmbiente) then
  begin
    FreeAndNil(FAmbiente);
  end;
  FFachada := nil;
  inherited;
end;

procedure TAulaMulticamadaServerMetodos.DoInicializarFachada;
var
  LServidor, LBancoDados, LBaseDados: string;
begin
  FAmbiente.Descricao := 'init';
  { variáveis }
  { teste local }
  LServidor := 'NOTE-HP-MVB';
  LBancoDados := 'SQLEXPRESS';
  LBaseDados := 'AULAS';
  { passa os dados para o objeto }
  FAmbiente.Servidor := LServidor;
  FAmbiente.BancoDados := LBancoDados;
  FAmbiente.BaseDados := LBaseDados;
  { inicializa a fachada }
  FFachada.Init(FAmbienteUsuario, FAmbiente);
end;

function TAulaMulticamadaServerMetodos.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TAulaMulticamadaServerMetodos.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

function TAulaMulticamadaServerMetodos.GetException(const AException: Exception;
  const ADescricaoOperacao: string): TJSONValue;
var
  LJSONInfo: TJSONObject;
begin
  { instancia o retorno }
  Result := TJSONObject.Create;
  { inicializa as informações da exceção }
  LJSONInfo := TJSONObject.Create;
  try
    { informa a classe da exceção }
    LJSONInfo.AddPair('type', AException.ClassName);
    LJSONInfo.AddPair('message', AException.Message);
    LJSONInfo.AddPair('descricaooperacao', ADescricaoOperacao);
    { informa que é uma exceção }
    TJSONObject(Result).AddPair('RaiseExceptionServerMethods', LJSONInfo.ToString);
  finally
    LJSONInfo.Free;
  end;
end;

function TAulaMulticamadaServerMetodos.GetResult(const ADado: TMRVDadosBase;
  const ADescricaoOperacao: string): TJSONValue;
var
  LObjeto: TJSONValue;
  LSerializador: TMRVSerializador;
  LTexto: string;
begin
  { cria o serializador }
  LSerializador := TMRVSerializador.Create;
  try
    LSerializador.TipoSerializacao := TMRVTipoSerializacao.tsJSON;
    LSerializador.Direcao := TMRVDirecaoSerializacao.dsObjetoToTexto;
    LSerializador.Objeto := (ADado as TMRVDadosBase);
    LSerializador.Serializar;
    LTexto := LSerializador.Texto;
  finally
    LSerializador.Free;
  end;
  LObjeto := TJSONObject.ParseJSONValue(LTexto);
  { retorna o objeto JSON }
  Result := LObjeto;
end;

function TAulaMulticamadaServerMetodos.GetResults(const ALista: TMRVListaBase;
  const ADescricaoOperacao: string): TJSONValue;
var
  LObjeto: TJSONValue;
  LSerializador: TMRVSerializador;
  LTexto: string;
begin
  { cria o serializador }
  LSerializador := TMRVSerializador.Create;
  try
    LSerializador.TipoSerializacao := TMRVTipoSerializacao.tsJSON;
    LSerializador.Direcao := TMRVDirecaoSerializacao.dsListaToTexto;
    LSerializador.Lista := (ALista as TMRVListaBase);
    LSerializador.Serializar;
    LTexto := LSerializador.Texto;
  finally
    LSerializador.Free;
  end;
  LObjeto := TJSONObject.ParseJSONValue(LTexto);
  { retorna o objeto JSON }
  Result := LObjeto;
end;

function TAulaMulticamadaServerMetodos.AcceptCliente(const ACliente: TMRVCliente):
  TJSONValue;
var
  LFachada: TMRVFachadaAulaMulticamada;
begin
  { recupera a instância da fachada }
  LFachada := TMRVAulaMulticamadasFacadeSingletonSealed.Instancia;
  try
    { manda a fachada inserir }
    LFachada.ClientesInserir(ACliente);
    { retorna o resultado }
    Result := Self.GetResult(ACliente, 'AcceptCliente');
  except
    on E: Exception do
    begin
      Result := Self.GetException(E, 'AcceptCliente');
    end;
  end;
end;

function TAulaMulticamadaServerMetodos.AcceptTipoCliente(const ATipoCliente:
  TMRVTipoCliente): TJSONValue;
var
  LFachada: TMRVFachadaAulaMulticamada;
begin
  { recupera a instância da fachada }
  LFachada := TMRVAulaMulticamadasFacadeSingletonSealed.Instancia;
  try
    { manda a fachada inserir }
    LFachada.TipoClientesInserir(ATipoCliente);
    { retorna o resultado }
    Result := Self.GetResult(ATipoCliente, 'AcceptTipoCliente');
  except
    on E: Exception do
    begin
      Result := Self.GetException(E, 'AcceptTipoCliente');
    end;
  end;
end;

function TAulaMulticamadaServerMetodos.CancelCliente(const AObjectId: Integer):
  TJSONValue;
var
  LFachada: TMRVFachadaAulaMulticamada;
  LCliente: TMRVCliente;
begin
  { recupera a instância da fachada }
  LFachada := TMRVAulaMulticamadasFacadeSingletonSealed.Instancia;
  try
    { prepara a informação }
    LCliente := TMRVCliente.Create;
    try
      LCliente.ClienteId := AObjectId;
      LFachada.ClientesExcluir(LCliente);
    finally
      LCliente.Free;
    end;
    Result := TJSONObject.Create(TJSONPair.Create('OP', 'CancelCliente'));
    TJSONObject(Result).AddPair('Mensagem', Format(
      'Cliente com Id [%d] excluído com sucesso.', [AObjectId]));
  except
    on E: Exception do
    begin
      Result := Self.GetException(E, 'CancelCliente');
    end;
  end;
end;

function TAulaMulticamadaServerMetodos.CancelTipoCliente(const AObjectId:
  Integer): TJSONValue;
var
  LFachada: TMRVFachadaAulaMulticamada;
  LTipoCliente: TMRVTipoCliente;
begin
  { recupera a instância da fachada }
  LFachada := TMRVAulaMulticamadasFacadeSingletonSealed.Instancia;
  try
    { prepara a informação }
    LTipoCliente := TMRVTipoCliente.Create;
    try
      LTipoCliente.TipoClienteId := AObjectId;
      LFachada.TipoClientesExcluir(LTipoCliente);
    finally
      LTipoCliente.Free;
    end;
    Result := TJSONObject.Create(TJSONPair.Create('OP', 'CancelTipoCliente'));
    TJSONObject(Result).AddPair('Mensagem', Format('Tipo de Cliente com Id [%d] excluído com sucesso.',
      [AObjectId]));
  except
    on E: Exception do
    begin
      Result := Self.GetException(E, 'CancelTipoCliente');
    end;
  end;
end;

function TAulaMulticamadaServerMetodos.Cliente(const AObjectId: Integer): TJSONValue;
var
  LResult: TJSONValue;
begin
  LResult := nil;
  { recupera o cliente informado }
  if AObjectId <> 0 then
  begin
    LResult := Self.GetCliente(AObjectId);
  end
  { recupera lista de clientes }
  else
  begin
    LResult := Self.GetClientes;
  end;
  { prepara o retorno }
  Result := LResult;
end;

function TAulaMulticamadaServerMetodos.GetCliente(const AObjectId: Integer): TJSONValue;
var
  LFacade: TMRVFachadaAulaMulticamada;
  LCliente: TMRVCliente;
begin
  { manda a fachada procurar cliente }
  LFacade := TMRVAulaMulticamadasFacadeSingletonSealed.Instancia;
  try
    LCliente := TMRVCliente.Create;
    try
      LCliente.Clienteid := AObjectId;
      LFacade.ClientesProcurarItem(LCliente, LCliente);
      Result := Self.GetResult(LCliente, 'GetCliente');
    finally
      LCliente.Free;
    end;
  except
    on E: Exception do
    begin
      Result := Self.GetException(E, 'GetCliente');
    end;
  end;
end;

function TAulaMulticamadaServerMetodos.GetClientes: TJSONValue;
var
  LFacade: TMRVFachadaAulaMulticamada;
  LCliente: TMRVCliente;
  LListaCliente: TMRVListaCliente;
  LSearchOption: TMRVSearchOption;
begin
  LFacade := TMRVAulaMulticamadasFacadeSingletonSealed.Instancia;
  try
    { instancia os parâmetros }
    LCliente := TMRVCliente.Create;
    try
      LListaCliente := TMRVListaCliente.Create;
      try
        { define o objeto de pesquisa }
        LSearchOption := TMRVSearchOption.Create(LCliente);
        try
          LCliente.Clienteid := 0;
          { manda a fachada recuperar os clientes cadastrados }
          LFacade.ClientesProcurarItens(LCliente, LListaCliente, LSearchOption);
          { transforma para o formato JSON }
          Result := Self.GetResults(LListaCliente, 'GetClientes');
        finally
          LSearchOption.Free;
        end;
      finally
        LListaCliente.Free;
      end;
    finally
      LCliente.Free;
    end;
  except
    on E: Exception do
    begin
      Result := Self.GetException(E, 'GetClientes');
    end;
  end;
end;

function TAulaMulticamadaServerMetodos.TipoCliente(const AObjectId: Integer): TJSONValue;
var
  LResult: TJSONValue;
begin
  LResult := nil;
  { chama o método da fachada }
  { recupera o TipoCliente informado }
  if AObjectId <> 0 then
  begin
    LResult := Self.GetTipoCliente(AObjectId);
  end
  { recupera lista de TipoClientes }
  else
  begin
    LResult := Self.GetTiposCliente;
  end;
  { prepara o retorno }
  Result := LResult;
end;

function TAulaMulticamadaServerMetodos.GetTipoCliente(const AObjectId: Integer):
  TJSONValue;
var
  LFacade: TMRVFachadaAulaMulticamada;
  LTipoCliente: TMRVTipoCliente;
begin
  { manda a fachada procurar pelo tipo de cliente }
  LFacade := TMRVAulaMulticamadasFacadeSingletonSealed.Instancia;
  try
    LTipoCliente := TMRVTipoCliente.Create;
    try
      LTipoCliente.TipoClienteid := AObjectId;
      LFacade.TipoClientesProcurarItem(LTipoCliente, LTipoCliente);
      Result := Self.GetResult(LTipoCliente, 'GetTipoCliente');
    finally
      LTipoCliente.Free;
    end;
  except
    on E: Exception do
    begin
      Result := Self.GetException(E, 'GetTipoCliente');
    end;
  end;
end;

function TAulaMulticamadaServerMetodos.GetTiposCliente: TJSONValue;
var
  LFacade: TMRVFachadaAulaMulticamada;
  LTipoCliente: TMRVTipoCliente;
  LListaTipoCliente: TMRVListaTipoCliente;
  LSearchOption: TMRVSearchOption;
begin
  LFacade := TMRVAulaMulticamadasFacadeSingletonSealed.Instancia;
  try
    { instancia os parâmetros }
    LTipoCliente := TMRVTipoCliente.Create;
    try
      LListaTipoCliente := TMRVListaTipoCliente.Create;
      try
        { define o objeto de pesquisa }
        LSearchOption := TMRVSearchOption.Create(LTipoCliente);
        try
          LTipoCliente.TipoClienteid := 0;
          { manda a fachada recuperar os TipoClientes cadastrados }
          LFacade.TipoClientesProcurarItens(LTipoCliente, LListaTipoCliente,
            LSearchOption);
          { transforma para o formato JSON }
          Result := Self.GetResults(LListaTipoCliente, 'GetTipoClientes');
        finally
          LSearchOption.Free;
        end;
      finally
        LListaTipoCliente.Free;
      end;
    finally
      LTipoCliente.Free;
    end;
  except
    on E: Exception do
    begin
      Result := Self.GetException(E, 'GetTiposCliente');
    end;
  end;
end;

function TAulaMulticamadaServerMetodos.UpdateCliente(const ACliente: TMRVCliente):
  TJSONValue;
var
  LFachada: TMRVFachadaAulaMulticamada;
begin
  { recupera a instância da fachada }
  LFachada := TMRVAulaMulticamadasFacadeSingletonSealed.Instancia;
  try
    { manda a fachada inserir }
    LFachada.ClientesAlterar(ACliente);
    { retorna o resultado }
    Result := Self.GetResult(ACliente, 'UpdateCliente');
  except
    on E: Exception do
    begin
      Result := Self.GetException(E, 'UpdateCliente');
    end;
  end;
end;

function TAulaMulticamadaServerMetodos.UpdateTipoCliente(const ATipoCliente:
  TMRVTipoCliente): TJSONValue;
var
  LFachada: TMRVFachadaAulaMulticamada;
begin
  { recupera a instância da fachada }
  LFachada := TMRVAulaMulticamadasFacadeSingletonSealed.Instancia;
  try
    { manda a fachada inserir }
    LFachada.TipoClientesAlterar(ATipoCliente);
    { retorna o resultado }
    Result := Self.GetResult(ATipoCliente, 'UpdateTipoCliente');
  except
    on E: Exception do
    begin
      Result := Self.GetException(E, 'UpdateTipoCliente');
    end;
  end;
end;

end.


