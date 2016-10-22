{  Arquivo criado automaticamente Gerador Multicamadas
   (Multitiers Generator VERSÃO 0.01)
   Data e Hora: 11/10/2016 - 23:04:17
}

unit Marvin.AulaMulticamada.Cadastro.Cliente;

interface

uses
  Classes,
  { marvin }
  uMRVClasses,
  uMRVCadastroBase,
  uMRVClassesServidor,
  Marvin.AulaMulticamada.Classes.Cliente,
  Marvin.AulaMulticamada.Listas.Cliente,
  Marvin.AulaMulticamada.Repositorio.Cliente;

type
  TMRVCadastroCliente = class(TMRVCadastroBase)
  private
    FCliente: IMRVRepositorioCliente;
  protected
    procedure DoAlterar(const AItem: TMRVDadosBase); override;
    procedure DoExcluir(const AItem: TMRVDadosBase); override;
    procedure DoInserir(const AItem: TMRVDadosBase); override;
    function DoProcurarItem(const ACriterio: TMRVDadosBase; const AResultado:
      TMRVDadosBase = nil): Boolean; override;
    function DoProcurarItems(const ACriterio: TMRVDadosBase; const
      AListaResultado: TMRVListaBase; const ASearchOption: TMRVSearchOption):
      Boolean; override;
    procedure FazerValidacoesDeRegras(AItem: TMRVDadosBase); override;
  public
    constructor Create(var ARepositorio: IMRVRepositorioCliente); reintroduce; virtual;
    destructor Destroy; override;
    property Cliente: IMRVRepositorioCliente read FCliente write FCliente;
  end;

implementation

uses
  uMRVConsts,
  Marvin.AulaMulticamada.Excecoes.Cliente,
  uMRVExcecoesFramework;

{ TMRVCadastroCliente }

constructor TMRVCadastroCliente.Create(var ARepositorio: IMRVRepositorioCliente);
begin
  inherited Create;
  { recebe a referência do objeto criado na Fachada }
  FCliente := ARepositorio;
end;

destructor TMRVCadastroCliente.Destroy;
begin
  FCliente := nil;
  inherited;
end;

procedure TMRVCadastroCliente.DoAlterar(const AItem: TMRVDadosBase);
begin
  Assert(AItem <> nil, 'O parâmetro AItem não pode ser NIL.');
  { verifica se já foi o cadastro anteriormente }
  if not Self.ProcurarItem(AItem) then
  begin
    raise EMRVClienteNaoCadastrado.Create;
  end;
  { verificar regras de negócio }
  Self.FazerValidacoesDeRegras(AItem);
  { manda o Repositório alterar o objeto }
  FCliente.Alterar(AItem);
end;

procedure TMRVCadastroCliente.DoExcluir(const AItem: TMRVDadosBase);
begin
  Assert(AItem <> nil, 'Parâmetro AItem não pode ser NIL.');
  { verifica se já foi o cadastro anteriormente }
  if not Self.ProcurarItem(AItem) then
  begin
    raise EMRVClienteNaoCadastrado.Create;
  end;
  { valida as regras de negócio }
  Self.FazerValidacoesDeRegras(AItem);
  { manda o Repositório excluir o objeto }
  FCliente.Excluir(AItem);
end;

procedure TMRVCadastroCliente.DoInserir(const AItem: TMRVDadosBase);
var
  LCliente: TMRVCliente;

  procedure LPesquisar(AChave: array of string; AExcecaoClass: EMRVExceptionClass);
  var
    LSearchOption: TMRVSearchOption;
    LListaCliente: TMRVListaCliente;
  begin
    LSearchOption := TMRVSearchOption.Create(LCliente);
    try
      LSearchOption.SetSearchingFor(AChave);
      LListaCliente := TMRVListaCliente.Create;
      try
        if Self.ProcurarItems(LCliente, LListaCliente, LSearchOption) then
        begin
            { se encontrou }
          raise AExcecaoClass.Create;
        end;
      finally
         { libera a lista }
        LListaCliente.Free
      end;
    finally
         { libera o critério de procura }
      LSearchOption.Free;
    end;
  end;

begin
  Assert(AItem <> nil, 'O parâmetro AItem não pode ser NIL.');
  { realiza o typecast }
  LCliente := AItem as TMRVCliente;
  { Faz uma pesquisa pela chave do objeto a ser inserido }
  LPesquisar(['Nome', 'Numerodocumento'], EMRVClienteJaCadastrado);
  { não pode existir o mesmo número de documento mais de uma vez }
  LPesquisar(['Numerodocumento'], EMRVClienteNumerodocumentoJaCadastrado);

  { recupera o próximo id }
  LCliente.ClienteId := FCliente.GetNextId;
  { Faz as verificações das colunas que não podem ser nulas }
  Self.FazerValidacoesDeRegras(AItem);
  { manda o Repositório inserir o objeto }
  FCliente.Inserir(AItem);
end;

function TMRVCadastroCliente.DoProcurarItem(const ACriterio: TMRVDadosBase;
  const AResultado: TMRVDadosBase = nil): Boolean;
begin
  { verifica se existe um objeto inicializado para ACriterio }
  Assert(ACriterio <> nil, 'O parâmetro ACriterio não pode ser NIL.');
  { manda o repositório procurar o objeto }
  Result := FCliente.ProcurarItem(ACriterio, AResultado);
end;

function TMRVCadastroCliente.DoProcurarItems(const ACriterio: TMRVDadosBase;
  const AListaResultado: TMRVListaBase; const ASearchOption: TMRVSearchOption): Boolean;
begin
  { verifica se existe um objeto inicializado para ACriterio }
  Assert(ACriterio <> nil, 'Parâmetro ACriterio não pode ser NIL.');
  { verifica se existe um objeto inicializado para AListaResultado }
  Assert(AListaResultado <> nil, 'Parâmetro AListaResultado não pode ser NIL.');
  { verifica se existe um objeto inicializado para ASearchOption }
  Assert(ASearchOption <> nil, 'O parâmetro ASearchOption não pode ser nil.');
  { manda o repositório procurar }
  Result := FCliente.ProcurarItems(ACriterio, AListaResultado, ASearchOption);
end;

procedure TMRVCadastroCliente.FazerValidacoesDeRegras(AItem: TMRVDadosBase);
var
  LCliente: TMRVCliente;
begin
  { verifica se existe um objeto inicializado para AItem }
  Assert(AItem <> nil, 'O parâmetro AItem não pode ser NIL.');
  LCliente := AItem as TMRVCliente;

  { Valida as regras de negócio }
  { checa se a propriedade é nula }
  if LCliente.Clienteid = C_INTEGER_NULL then
  begin
    raise EMRVClienteClienteidInvalido.Create;
  end;
   { checa se a propriedade é nula }
  if LCliente.TipoClienteId = C_INTEGER_NULL then
  begin
    raise EMRVClienteTipoClienteIdInvalido.Create;
  end;
   { checa se a propriedade é nula }
  if LCliente.Nome = C_STRING_NULL then
  begin
    raise EMRVClienteNomeInvalido.Create;
  end;
   { checa se não ultrapassa o tamanho máximo de caracteres }
  if Length(LCliente.Nome) > 100 then
  begin
    raise EMRVClienteNomeTamanhoInvalido.Create(100);
  end;
   { checa se a propriedade é nula }
  if LCliente.Numerodocumento = C_STRING_NULL then
  begin
    raise EMRVClienteNumerodocumentoInvalido.Create;
  end;
   { checa se não ultrapassa o tamanho máximo de caracteres }
  if Length(LCliente.Numerodocumento) > 50 then
  begin
    raise EMRVClienteNumerodocumentoTamanhoInvalido.Create(50);
  end;
   { checa se a propriedade é nula }
  if LCliente.Datahoracadastro = C_DATE_TIME_NULL then
  begin
    raise EMRVClienteDatahoracadastroInvalida.Create;
  end;
end;

end.


