unit Marvin.Desktop.ClientModule.AulaMulticamada;

interface

uses
  System.SysUtils,
  System.Classes,
  System.SyncObjs,
  { marvin }
  uMRVClasses,
  uMRVExcecoesFramework,
  Marvin.Desktop.ExceptionsModule.AulaMulticamada,
  { embarcadero }
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  Data.DBXJSONReflect,
  Data.DBXJSONCommon,
  { rest }
  REST.Client,
  REST.Types,
  System.JSON,
  IPPeerClient;

type
  { tipo referente à ação que será executada }
  TTipoAcao = (taGet, taPost, taAccept, taCancel, taNone);

  { camada de comunicação - módulo cliente }
  TClientModuleAulaMulticamada = class(TDataModule)
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
  private
    FBaseURL: string;
    FCriticalSection: TCriticalSection;
  protected
    function DoObjectToJSON(ADadoClasse: TMRVDadosBaseClass; const ADado:
      TMRVDadosBase; const AResourceName: string; ATipoAcao: TTipoAcao): string;
    function DoJSONtoObject(const AJSONString: string; ADadoClasse:
      TMRVDadosBaseClass): TMRVDadosBase;
    function DoJSONToObjects(AJSONString: string; AClass: TMRVListaBaseClass):
      TMRVListaBase;
    { métodos }
    function GetBaseUrl: string;
    procedure ResetConnection;
    { propriedades }
    property BaseUrl: string read GetBaseUrl;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { métodos }
    procedure CheckException(const AJSONString: string);
    function ExecuteJSONById(const AUrlId: string; const AParam: string;
      ATipoAcao: TTipoAcao): string;
    function GetResultValue(const AJSONString: string; const AValue: string): string;
    function GetObjects(const AUrlId: string; AClass: TMRVListaBaseClass; const
      AParam: string = '0'): TMRVListaBase;
    function GetObject(const AUrlId: string; AClass: TMRVDadosBaseClass; const
      AParam: string = '0'): TMRVDadosBase;
    function SendObject(const AResourceName: string; const ADado: TMRVDadosBase;
      ADadoClasse: TMRVDadosBaseClass; ATipoAcao: TTipoAcao): TMRVDadosBase;
  end;

var
  ClientModuleAulaMulticamada: TClientModuleAulaMulticamada;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

uses
  uMRVSerializador,
  DateUtils;

const
  FC_BASE_URL: string = 'http://%S:8080/datasnap/rest/TAulaMulticamadaServerMetodos';
  FC_AMAZON: string = 'ec2-52-26-187-179.us-west-2.compute.amazonaws.com';
  {$REGION 'IPs Locais'}
  //FC_LOCAL: string = 'localhost';//'192.168.0.5';
  FC_LOCAL: string = 'marvinbraga.ddns.net';
  {$ENDREGION}

{ /***************************************************************************/
  | Retorna uma mensagem de um JSON.                                          |
  /***************************************************************************/ }
function TClientModuleAulaMulticamada.GetResultValue(const AJSONString: string;
  const AValue: string): string;
var
  LJSONObject: TJSONObject;
  LArrayResult: TJSONArray;
  LArray, LItemArray: TJSONValue;
  LEntrada, LPairString: string;
begin
  { inicializa }
  Result := EmptyStr;
  LEntrada := AJSONString;
  if Pos('"result":', LEntrada) = 0 then
  begin
    LEntrada := Format('{"result":[%S]}', [AJSONString]);
  end;
  { transforma a string em objeto JSON }
  LJSONObject := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(LEntrada),
    0) as TJSONObject;
  try
    { recupera o result }
    LArrayResult := LJSONObject.GetValue<TJSONArray>('result');
    LArray := TJSONArray(LArrayResult.Items[0]);
    { recupera o primeiro dentro do result }
    for LItemArray in TJSONArray(LArray) do
    begin
      LPairString := TJSONPair(LItemArray).JsonString.Value;
      if (LPairString = AValue) then
      begin
        Result := TJSONPair(LItemArray).JsonValue.Value;
        Break;
      end;
    end;
  finally
    LJSONObject.DisposeOf;
  end;
end;

{ /************************************************************************/
  | Verifica e explode exceção que venha do servidor.                      |
  /************************************************************************/ }
procedure TClientModuleAulaMulticamada.CheckException(const AJSONString: string);
var
  LJSONObject: TJSONObject;
  LArrayResult: TJSONArray;
  LArray, LItemArray: TJSONValue;
  LText, LPairString, LType, LMessage: string;
begin
  { transforma a string em objeto JSON }
  LJSONObject := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AJSONString),
    0) as TJSONObject;
  try
    { recupera o result }
    LArrayResult := LJSONObject.GetValue<TJSONArray>('result');
    LArray := TJSONArray(LArrayResult.Items[0]);
    { recupera o primeiro dentro do result }
    for LItemArray in TJSONArray(LArray) do
    begin
      LPairString := TJSONPair(LItemArray).JsonString.Value;
      if (LPairString = 'RaiseExceptionServerMethods') then
      begin
        LText := TJSONPair(LItemArray).JsonValue.Value;
        LType := Self.GetResultValue(LText, 'type');
        LMessage := Self.GetResultValue(LText, 'message');
        { levanta a exceção da comunicação }
        raise TMRVAulaMultiCamadaExceptionsModule.GetException(LType, LMessage);
      end;
      Break;
    end;
  finally
    LJSONObject.DisposeOf;
  end;
end;

{ /************************************************************************/
  | Instancia o ClientModule que se comunicará com o servidor.             |
  /************************************************************************/ }
constructor TClientModuleAulaMulticamada.Create(AOwner: TComponent);
begin
  inherited;
  FBaseURL := EmptyStr;
  { controle de Threads }
  FCriticalSection := TCriticalSection.Create;
end;

{ /************************************************************************/
  | Libera o ClientModule que se comunica com o servidor da memória.       |
  /************************************************************************/ }
destructor TClientModuleAulaMulticamada.Destroy;
begin
  Self.ResetConnection;
  FreeAndNil(FCriticalSection);
  inherited;
end;

{ /************************************************************************/
  | Recupera a URL base que estipula o caminho para o servidor.            |
  /************************************************************************/ }
function TClientModuleAulaMulticamada.GetBaseUrl: string;
var
  LCont: Integer;
  LParam: string;
begin
  if (FBaseURL = EmptyStr) then
  begin
    { recupera a url local }
    FBaseURL := Format(FC_BASE_URL, [FC_LOCAL]);
    { verifica se existem parâmetros referêntes a servidor externo }
    if (System.ParamCount > 0) then
    begin
      for LCont := 1 to System.ParamCount do
      begin
        LParam := ParamStr(LCont);
        { verifica parâmetros }
        if LParam <> EmptyStr then
        begin
          if LParam = '-cloudconnection' then
          begin
            FBaseURL := Format(FC_BASE_URL, [FC_AMAZON]);
          end
          else
          begin
            FBaseURL := Format(FC_BASE_URL, [LParam]);
            Break;
          end;
        end;
      end;
    end;
  end;
  Result := FBaseURL;
end;

{ /************************************************************************/
  | Inicializa os objetos de conexão cliente (request e response).         |
  /************************************************************************/ }
procedure TClientModuleAulaMulticamada.ResetConnection;
begin
  { inicializa os padrões }
  RESTRequest.ResetToDefaults;
  RESTResponse.ResetToDefaults;
  RESTClient.ResetToDefaults;
  { recupera a URL do servidor }
  RESTClient.BaseUrl := Self.BaseUrl;
end;

{ /**************************************************************************/
  | Envia para um objeto POST, PUT ou CANCEL e recebe um novo como resposta. |
  /**************************************************************************/ }
function TClientModuleAulaMulticamada.SendObject(const AResourceName: string;
  const ADado: TMRVDadosBase; ADadoClasse: TMRVDadosBaseClass; ATipoAcao:
  TTipoAcao): TMRVDadosBase;
var
  LJSONString: string;
begin
  Result := nil;
  { controla acesso de threads }
  FCriticalSection.Acquire;
  try
    { envia o objeto convertendo para JSON }
    LJSONString := Self.DoObjectToJSON(ADadoClasse, ADado, AResourceName, ATipoAcao);
    { recupera os dados do JSON para o objeto }
    Result := Self.DoJSONtoObject(LJSONString, ADadoClasse);
  finally
    FCriticalSection.Release;
  end;
end;

{ /************************************************************************/
  | Recupera um objeto através do ID.                                      |
  /************************************************************************/ }
function TClientModuleAulaMulticamada.GetObject(const AUrlId: string; AClass:
  TMRVDadosBaseClass; const AParam: string): TMRVDadosBase;
var
  LJSONString: string;
begin
  { controla threads }
  FCriticalSection.Acquire;
  try
    { faz uma consulta pelo ID }
    LJSONString := Self.ExecuteJSONById(AUrlId, AParam, taGet);
    { transforma o JSON em lista de objetos }
    Result := Self.DoJSONtoObject(LJSONString, AClass);
  finally
    FCriticalSection.Release;
  end;
end;

{ /************************************************************************/
  | Recupera uma lista de objetos através de um ID.                        |
  /************************************************************************/ }
function TClientModuleAulaMulticamada.GetObjects(const AUrlId: string; AClass:
  TMRVListaBaseClass; const AParam: string): TMRVListaBase;
var
  LJSONString: string;
begin
  { controla threads }
  FCriticalSection.Acquire;
  try
    { faz uma consulta pelo ID }
    LJSONString := Self.ExecuteJSONById(AUrlId, AParam, taGet);
    { transforma o JSON em lista de objetos }
    Result := Self.DoJSONToObjects(LJSONString, AClass);
  finally
    FCriticalSection.Release;
  end;
end;

{ /************************************************************************/
  | Recupera um JSON enviando (GET ou CANCEL) um ID para o servidor.                       |
  /************************************************************************/ }
function TClientModuleAulaMulticamada.ExecuteJSONById(const AUrlId: string;
  const AParam: string; ATipoAcao: TTipoAcao): string;
begin
  Result := EmptyStr;
  { inicializa a conexão REST }
  Self.ResetConnection;
  { recupera a classe que irá trabalhar }
  RESTRequest.Resource := Format('%S/{objectid}', [AUrlId]);
  { recupera a ação }
  case ATipoAcao of
    taGet:
      RESTRequest.Method := TRESTRequestMethod.rmGET;
    taCancel:
      RESTRequest.Method := TRESTRequestMethod.rmDELETE;
    taPost, taAccept, taNone:
      Exit;
  end;
  { informa o parâmetro }
  RESTRequest.Params.AddItem('objectid', AParam, TRESTRequestParameterKind.pkURLSEGMENT);
  { executa  }
  RESTRequest.Execute;
  { recupera o conteúdo }
  Result := RESTResponse.Content;
end;

{ /************************************************************************/
  | Converte um objeto para JSON e envia por parâmetro para o servidor.    |
  /************************************************************************/ }
function TClientModuleAulaMulticamada.DoObjectToJSON(ADadoClasse:
  TMRVDadosBaseClass; const ADado: TMRVDadosBase; const AResourceName: string;
  ATipoAcao: TTipoAcao): string;
var
  LObjeto: TMRVDadosBase;
  LObjetoJSON: TJSONValue;
begin
  Result := EmptyStr;
  { instancia um objeto da classe informada }
  LObjeto := ADadoClasse.Create as TMRVDadosBase;
  try
    { recupera os dados do objeto para um objeto temporário }
    LObjeto.Assign(ADado);
    { converte para JSON }
    LObjetoJSON := TJSONMarshal.Create.Marshal(LObjeto);
    try
      { inicializa componentes para envio }
      Self.ResetConnection;
      RESTRequest.AddBody(LObjetoJSON.ToString,
        ContentTypeFromString('application/json'));
      { configura o envio }
      RESTRequest.Resource := Format('/%S', [AResourceName]);
      { utiliza o método selecionado }
      case ATipoAcao of
        taGet:
          RESTRequest.Method := TRESTRequestMethod.rmGET;
        taPost:
          RESTRequest.Method := TRESTRequestMethod.rmPOST;
        taAccept:
          RESTRequest.Method := TRESTRequestMethod.rmPUT;
        taCancel:
          RESTRequest.Method := TRESTRequestMethod.rmDELETE;
        taNone:
          Exit;
      end;
      { executa consulta }
      RESTRequest.Execute;
      { recupera o conteúdo }
      Result := RESTResponse.Content;
    finally
      LObjetoJSON.DisposeOf;
    end;
  finally
    LObjeto.DisposeOf;
  end;
end;

{ /***************************************************************************/
  | Resebe um JSON, converte-o para um novo objeto e o devolve como resposta. |
  /***************************************************************************/ }
function TClientModuleAulaMulticamada.DoJSONtoObject(const AJSONString: string;
  ADadoClasse: TMRVDadosBaseClass): TMRVDadosBase;
var
  LSerializador: TMRVSerializador;
begin
  { verifica se recebeu alguma exceção }
  Self.CheckException(AJSONString);
  { criao serializador }
  LSerializador := TMRVSerializador.Create;
  try
    LSerializador.TipoSerializacao := TMRVTipoSerializacao.tsJSON;
    LSerializador.Direcao := TMRVDirecaoSerializacao.dsTextoToObjeto;
    { o objeto volta como resultado }
    Result := ADadoClasse.Create;
    { executa a serialização }
    LSerializador.Objeto := Result;
    LSerializador.Texto := AJSONString;
    LSerializador.Serializar;
  finally
    LSerializador.DisposeOf;
  end;
end;

{ /************************************************************************/
  | Recupera uma nova lista de objetos a partir de um JSON.                |
  /************************************************************************/ }
function TClientModuleAulaMulticamada.DoJSONToObjects(AJSONString: string;
  AClass: TMRVListaBaseClass): TMRVListaBase;
var
  LSerializador: TMRVSerializador;
  LLista: TMRVListaBase;
begin
  { verifica se recebeu alguma exceção }
  Self.CheckException(AJSONString);
  { cria o serializador }
  LSerializador := TMRVSerializador.Create;
  try
    LSerializador.TipoSerializacao := TMRVTipoSerializacao.tsJSON;
    LSerializador.Direcao := TMRVDirecaoSerializacao.dsTextoToLista;
    { a lista volta como resultado }
    LLista := AClass.Create;
    { executa a serialização }
    LSerializador.Lista := (LLista as TMRVListaBase);
    LSerializador.Texto := AJSONString;
    LSerializador.Serializar;
  finally
    LSerializador.DisposeOf;
  end;
  { retorna a lista criada }
  Result := LLista;
end;

end.


