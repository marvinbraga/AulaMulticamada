unit Marvin.Console.GUI.Lista.Clientes;

interface

uses
  { comunicação }
  Marvin.Desktop.Repositorio.AulaMulticamada,
  { exceções }
  Marvin.AulaMulticamada.Excecoes.Cliente,
  { classes }
  Marvin.AulaMulticamada.Classes.Cliente,
  Marvin.AulaMulticamada.Listas.Cliente;

type
  TPaginaListaClientes = class(TObject)
  private
    { comunicação }
    FClientClasses: IMRVRepositorioAulaMulticamada;
    { classes }
    FListaClientes: TMRVListaCliente;
    FCliente: TMRVCliente;
  protected
    { métodos de apoio }
    procedure ApresentarLinha;
    procedure CarregarClientes;
    procedure ExibirCabecalho;
    procedure ExibirClientes;
    procedure ExibirCliente(const ACliente: TMRVCliente);
    procedure MostrarComandos;
    procedure RecuperarComando(var ASair: Boolean);
    procedure DoExcluir;
    function DoExcluirCliente(ACodigo: Integer): Boolean;
    procedure DoNovo;
    procedure DoAlterar;
    function DoAlterarCliente(ACodigo: Integer): Boolean;
    procedure RecuperarCliente(const ACodigo: Integer;
      var AResultado: TMRVCliente);
    { propriedades }
    property ListaClientes: TMRVListaCliente read FListaClientes;
    property Cliente: TMRVCliente read FCliente;
  public
    constructor Create(const AClientClasses: IMRVRepositorioAulaMulticamada); overload;
    destructor Destroy; override;
    procedure Show;
  end;

implementation

uses
  Marvin.Console.GUI.Cadastro.Cliente,
  System.SysUtils, Marvin.Console.Utils;

{ TPaginaListaClientes }

procedure TPaginaListaClientes.ApresentarLinha;
begin
  TConsoleUtils.WritelnWithColor(
    '/-------------------------------------------------------------------/',
    TConsoleUtils.C_GERAL);
end;

procedure TPaginaListaClientes.CarregarClientes;
var
  LCliente: TMRVCliente;
begin
  if Assigned(FListaClientes) then
  begin
    FreeAndNil(FListaClientes);
  end;
  LCliente := TMRVCliente.Create;
  try
    { carrega a lista de clientes }
    FListaClientes := FClientClasses.ClientesProcurarItens(LCliente) as TMRVListaCliente;
  finally
    LCliente.DisposeOf;
  end;
end;

constructor TPaginaListaClientes.Create(
  const AClientClasses: IMRVRepositorioAulaMulticamada);
begin
  inherited Create;
  FClientClasses := AClientClasses;
end;

destructor TPaginaListaClientes.Destroy;
begin
  FClientClasses := nil;
  inherited;
end;

procedure TPaginaListaClientes.ExibirCabecalho;
begin
  TConsoleUtils.ClearScreen;
  Self.ApresentarLinha;
  TConsoleUtils.WriteWithColor('|                      ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Lista de Clientes', TConsoleUtils.C_CABECALHO_TEXTO);
  TConsoleUtils.WriteWithColor('                            |',
    TConsoleUtils.C_GERAL);
  Writeln('');
  Self.ApresentarLinha;
  TConsoleUtils.WriteWithColor('| ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Código', TConsoleUtils.C_TITULO_TABELA);
  TConsoleUtils.WriteWithColor(' | ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Nome', TConsoleUtils.C_TITULO_TABELA);
  TConsoleUtils.WriteWithColor(
    '                                                     |', TConsoleUtils.C_GERAL);
  Writeln('');
  Self.ApresentarLinha;
end;

procedure TPaginaListaClientes.ExibirCliente(const ACliente: TMRVCliente);
begin
  TConsoleUtils.WriteWithColor(
    '| ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor(Format('%6d', [ACliente.Clienteid]), TConsoleUtils.C_TEXTO);
  TConsoleUtils.WriteWithColor(' | ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor(Format('%-56S', [ACliente.Nome]), TConsoleUtils.C_TEXTO);
  TConsoleUtils.WriteWithColor(' |', TConsoleUtils.C_GERAL);
  Writeln('');
end;

procedure TPaginaListaClientes.ExibirClientes;
var
  LCont: Integer;
  LCliente: TMRVCliente;
begin
  Self.ExibirCabecalho;
  for LCont := 0 to FListaClientes.Count - 1 do
  begin
    FListaClientes.ProcurarPorIndice(LCont, LCliente);
    Self.ExibirCliente(LCliente);
  end;
  Self.ApresentarLinha;
end;

procedure TPaginaListaClientes.MostrarComandos;
begin
  TConsoleUtils.WriteWithColor('|', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor(' Escolha: (', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('N', TConsoleUtils.C_TEXTO_ENFASE);
  TConsoleUtils.WriteWithColor(')ovo, (', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('A', TConsoleUtils.C_TEXTO_ENFASE);
  TConsoleUtils.WriteWithColor(')lterar, (', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('E', TConsoleUtils.C_TEXTO_ENFASE);
  TConsoleUtils.WriteWithColor(')xcluir ou (', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('ENTER', TConsoleUtils.C_TEXTO_ENFASE);
  TConsoleUtils.WriteWithColor(') para voltar...   ', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('|', TConsoleUtils.C_GERAL);
  TConsoleUtils.SetConsoleColor(TConsoleUtils.C_TEXTO);
  Writeln('');
  Self.ApresentarLinha;
end;

procedure TPaginaListaClientes.RecuperarCliente(const ACodigo: Integer;
  var AResultado: TMRVCliente);
var
  LIndex: Integer;
  LCliente: TMRVCliente;
begin
  for LIndex := 0 to FListaClientes.Count - 1 do
  begin
    FListaClientes.ProcurarPorIndice(LIndex, LCliente);
    if LCliente.ClienteId = ACodigo then
    begin
      AResultado := LCliente;
      Break;
    end;
  end;
end;

procedure TPaginaListaClientes.RecuperarComando(var ASair: Boolean);
var
  LComando: string;
begin
  LComando := EmptyStr;
  { recupera }
  TConsoleUtils.WriteWithColor('Escreva: ', TConsoleUtils.C_TEXTO);
  TConsoleUtils.SetConsoleColor(TConsoleUtils.C_TEXTO_ENFASE);
  Readln(Input, LComando);
  { aciona comandos }
  if Trim(UpperCase(LComando)) = 'N' then
  begin
    Self.DoNovo;
  end
  else if Trim(UpperCase(LComando)) = 'A' then
  begin
    Self.DoAlterar;
  end
  else if Trim(UpperCase(LComando)) = 'E' then
  begin
    Self.DoExcluir;
  end;
  ASair := (Trim(LComando) = EmptyStr);
end;

procedure TPaginaListaClientes.DoAlterar;
var
  LCodigo: string;
  LSair: Boolean;
begin
  LSair := False;
  while not(LSair) do
  begin
    Writeln('');
    TConsoleUtils.WriteWithColor('[', TConsoleUtils.C_GERAL_TEXTO);
    TConsoleUtils.WriteWithColor('Alteração', TConsoleUtils.C_TEXTO);
    TConsoleUtils.WriteWithColor('] Informe o código do Cliente para continuar: ',
      TConsoleUtils.C_GERAL_TEXTO);
    TConsoleUtils.SetConsoleColor(TConsoleUtils.C_TEXTO_ENFASE);
    { recupera o código }
    Readln(Input, LCodigo);
    try
      LSair := (Trim(LCodigo) = EmptyStr);
      if not(LSair) then
      begin
        LSair := Self.DoAlterarCliente(StrToInt(LCodigo));
      end;
    except
      LSair := True;
    end;
  end;
end;

function TPaginaListaClientes.DoAlterarCliente(ACodigo: Integer): Boolean;
var
  LPaginaAlterar: TPaginaSalvarCliente;
  LResult: Boolean;
  LCliente: TMRVCliente;
begin
  LResult := True;
  { recupera o cliente para alterar }
  Self.RecuperarCliente(ACodigo, LCliente);

  LPaginaAlterar := TPaginaSalvarCliente.Create(FClientClasses, psAlterar);
  try
    { informa o código }
    LPaginaAlterar.Cliente.Assign(LCliente);
    try
      LPaginaAlterar.Show;
    except
      on E: EMRVExcecoesCliente do
      begin
        LResult := False;
        { exibe mensagem  de erro }
        Writeln('');
        TConsoleUtils.WritelnWithColor('[Informação]' + #13#10 + E.Message,
          TConsoleUtils.C_MENSAGEM_ERRO);
      end;
      else
        raise;
    end;
  finally
    LPaginaAlterar.Free;
  end;
  Result := LResult;
end;

procedure TPaginaListaClientes.DoExcluir;
var
  LCodigo: string;
  LSair: Boolean;
begin
  LSair := False;
  while not(LSair) do
  begin
    Writeln('');
    TConsoleUtils.WriteWithColor('[', TConsoleUtils.C_GERAL_TEXTO);
    TConsoleUtils.WriteWithColor('Exclusão', TConsoleUtils.C_TEXTO);
    TConsoleUtils.WriteWithColor('] Informe o código do Cliente para continuar: ',
      TConsoleUtils.C_GERAL_TEXTO);
    TConsoleUtils.SetConsoleColor(TConsoleUtils.C_TEXTO_ENFASE);
    { recupera o código }
    Readln(Input, LCodigo);
    try
      LSair := (Trim(LCodigo) = EmptyStr);
      if not(LSair) then
      begin
        LSair := Self.DoExcluirCliente(StrToInt(LCodigo));
      end;
    except
      LSair := True;
    end;
  end;
end;

function TPaginaListaClientes.DoExcluirCliente(ACodigo: Integer): Boolean;
var
  LMensagem: string;
  LCliente: TMRVCliente;
  LResult: Boolean;
begin
  LResult := True;
  LCliente := TMRVCliente.Create;
  try
    LCliente.ClienteId := ACodigo;
    try
      { manda o ClientModule excluir }
      LMensagem := FClientClasses.ClientesExcluir(LCliente);
    except
      on E: EMRVExcecoesCliente do
      begin
        LResult := False;
        { exibe mensagem  de erro }
        Writeln('');
        TConsoleUtils.WritelnWithColor('[Informação]' + #13#10 + E.Message,
          TConsoleUtils.C_MENSAGEM_ERRO);
      end;
      else
        raise;
    end;
  finally
    LCliente.DisposeOf;
  end;
  Result := LResult;
end;

procedure TPaginaListaClientes.DoNovo;
var
  LPaginaNovo: TPaginaSalvarCliente;
begin
  LPaginaNovo := TPaginaSalvarCliente.Create(FClientClasses, psNovo);
  try
    LPaginaNovo.Show;
  finally
    LPaginaNovo.Free;
  end;
end;

procedure TPaginaListaClientes.Show;
var
  LSair: Boolean;
begin
  LSair := False;
  while not(LSair) do
  begin
    Self.CarregarClientes;
    Self.ExibirClientes;
    Self.MostrarComandos;
    Self.RecuperarComando(LSair);
  end;
end;

end.
