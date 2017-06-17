unit Marvin.Console.GUI.Lista.TiposCliente;

interface

uses
  { comunicação }
  Marvin.Desktop.Repositorio.AulaMulticamada,
  { exceções }
  Marvin.AulaMulticamada.Excecoes.TipoCliente,
  { classes }
  Marvin.AulaMulticamada.Classes.TipoCliente,
  Marvin.AulaMulticamada.Listas.TipoCliente;

type
  TPaginaListaTiposCliente = class(TObject)
  private
    { comunicação }
    FClientClasses: IMRVRepositorioAulaMulticamada;
    { classes }
    FListaTiposCliente: TMRVListaTipoCliente;
    FTipoCliente: TMRVTipoCliente;
  protected
    { métodos de apoio }
    procedure ApresentarLinha;
    procedure CarregarTiposCliente;
    procedure ExibirCabecalho;
    procedure ExibirTiposCliente;
    procedure ExibirTipoCliente(const ATipoCliente: TMRVTipoCliente);
    procedure MostrarComandos;
    procedure RecuperarComando(var ASair: Boolean);
    procedure DoExcluir;
    function DoExcluirTipoCliente(ACodigo: Integer): Boolean;
    procedure DoNovo;
    procedure DoAlterar;
    function DoAlterarTipoCliente(ACodigo: Integer): Boolean;
    procedure RecuperarTipoCliente(const ACodigo: Integer;
      var AResultado: TMRVTipoCliente);
    { propriedades }
    property ListaClientes: TMRVListaTipoCliente read FListaTiposCliente;
    property Cliente: TMRVTipoCliente read FTipoCliente;
  public
    constructor Create(const AClientClasses: IMRVRepositorioAulaMulticamada); overload;
    destructor Destroy; override;
    procedure Show;
  end;

implementation

uses
  Marvin.Console.Utils,
  Marvin.Console.GUI.Cadastro.TipoCliente,
  System.SysUtils;

{ TPaginaListaTiposCliente }

procedure TPaginaListaTiposCliente.ApresentarLinha;
begin
  TConsoleUtils.WritelnWithColor('/-------------------------------------------------------------------/',
    TConsoleUtils.C_GERAL);
end;

procedure TPaginaListaTiposCliente.CarregarTiposCliente;
var
  LTipoCliente: TMRVTipoCliente;
begin
  if Assigned(FListaTiposCliente) then
  begin
    FreeAndNil(FListaTiposCliente);
  end;
  LTipoCliente := TMRVTipoCliente.Create;
  try
    { carrega a lista de clientes }
    FListaTiposCliente := FClientClasses.TiposClienteProcurarItens(LTipoCliente)
      as TMRVListaTipoCliente;
  finally
    LTipoCliente.DisposeOf;
  end;
end;

constructor TPaginaListaTiposCliente.Create(const AClientClasses:
  IMRVRepositorioAulaMulticamada);
begin
  inherited Create;
  FClientClasses := AClientClasses;
end;

destructor TPaginaListaTiposCliente.Destroy;
begin
  FClientClasses := nil;
  inherited;
end;

procedure TPaginaListaTiposCliente.DoAlterar;
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
    TConsoleUtils.WriteWithColor('] Informe o código do Tipo de Cliente para continuar: ',
      TConsoleUtils.C_GERAL_TEXTO);
    TConsoleUtils.SetConsoleColor(TConsoleUtils.C_TEXTO_ENFASE);
    { recupera o código }
    Readln(Input, LCodigo);
    try
      LSair := (Trim(LCodigo) = EmptyStr);
      if not(LSair) then
      begin
        LSair := Self.DoAlterarTipoCliente(StrToInt(LCodigo));
      end;
    except
      LSair := True;
    end;
  end;
end;

function TPaginaListaTiposCliente.DoAlterarTipoCliente(
  ACodigo: Integer): Boolean;
var
  LPaginaAlterar: TPaginaSalvarTipoCliente;
  LResult: Boolean;
  LTipoCliente: TMRVTipoCliente;
begin
  LResult := True;
  { recupera o tipo de cliente para alterar }
  Self.RecuperarTipoCliente(ACodigo, LTipoCliente);

  LPaginaAlterar := TPaginaSalvarTipoCliente.Create(FClientClasses, psAlterar);
  try
    { informa o código }
    LPaginaAlterar.TipoCliente.Assign(LTipoCliente);
    try
      LPaginaAlterar.Show;
    except
      on E: EMRVExcecoesTipoCliente do
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

procedure TPaginaListaTiposCliente.DoExcluir;
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
    TConsoleUtils.WriteWithColor('] Informe o código do Tipo de Cliente para continuar: ',
      TConsoleUtils.C_GERAL_TEXTO);
    TConsoleUtils.SetConsoleColor(TConsoleUtils.C_TEXTO_ENFASE);
    { recupera o código }
    Readln(Input, LCodigo);
    try
      LSair := (Trim(LCodigo) = EmptyStr);
      if not(LSair) then
      begin
        LSair := Self.DoExcluirTipoCliente(StrToInt(LCodigo));
      end;
    except
      LSair := True;
    end;
  end;
end;

function TPaginaListaTiposCliente.DoExcluirTipoCliente(ACodigo: Integer): Boolean;
var
  LMensagem: string;
  LTipoCliente: TMRVTipoCliente;
  LResult: Boolean;
begin
  LResult := True;
  LTipoCliente := TMRVTipoCliente.Create;
  try
    LTipoCliente.TipoClienteId := ACodigo;
    try
      { manda o ClientModule excluir }
      LMensagem := FClientClasses.TiposClienteExcluir(LTipoCliente);
    except
      on E: EMRVExcecoesTipoCliente do
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
    LTipoCliente.DisposeOf;
  end;
  Result := LResult;
end;

procedure TPaginaListaTiposCliente.DoNovo;
var
  LPaginaNovo: TPaginaSalvarTipoCliente;
begin
  LPaginaNovo := TPaginaSalvarTipoCliente.Create(FClientClasses, psNovo);
  try
    LPaginaNovo.Show;
  finally
    LPaginaNovo.Free;
  end;
end;

procedure TPaginaListaTiposCliente.ExibirCabecalho;
begin
  TConsoleUtils.ClearScreen;
  Self.ApresentarLinha;
  TConsoleUtils.WriteWithColor('|                      ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Lista de Tipos de Cliente', TConsoleUtils.C_CABECALHO_TEXTO);
  TConsoleUtils.WriteWithColor('                    |', TConsoleUtils.C_GERAL);
  Writeln('');
  Self.ApresentarLinha;
  TConsoleUtils.WriteWithColor('| ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Código', TConsoleUtils.C_TITULO_TABELA);
  TConsoleUtils.WriteWithColor(' | ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Descrição', TConsoleUtils.C_TITULO_TABELA);
  TConsoleUtils.WriteWithColor('                                                |',
    TConsoleUtils.C_GERAL);
  Writeln('');
  Self.ApresentarLinha;
end;

procedure TPaginaListaTiposCliente.ExibirTipoCliente(const ATipoCliente: TMRVTipoCliente);
begin
  TConsoleUtils.WriteWithColor('| ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor(Format('%6d', [ATipoCliente.TipoClienteId]),
    TConsoleUtils.C_TEXTO);
  TConsoleUtils.WriteWithColor(' | ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor(Format('%-56S', [ATipoCliente.Descricao]),
    TConsoleUtils.C_TEXTO);
  TConsoleUtils.WriteWithColor(' |', TConsoleUtils.C_GERAL);
  Writeln('');
end;

procedure TPaginaListaTiposCliente.ExibirTiposCliente;
var
  LCont: Integer;
  LTipoCliente: TMRVTipoCliente;
begin
  Self.ExibirCabecalho;
  for LCont := 0 to FListaTiposCliente.Count - 1 do
  begin
    FListaTiposCliente.ProcurarPorIndice(LCont, LTipoCliente);
    Self.ExibirTipoCliente(LTipoCliente);
  end;
  Self.ApresentarLinha;
end;

procedure TPaginaListaTiposCliente.MostrarComandos;
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

procedure TPaginaListaTiposCliente.RecuperarComando(var ASair: Boolean);
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

procedure TPaginaListaTiposCliente.RecuperarTipoCliente(const ACodigo: Integer;
  var AResultado: TMRVTipoCliente);
var
  LIndex: Integer;
  LTipoCliente: TMRVTipoCliente;
begin
  for LIndex := 0 to FListaTiposCliente.Count - 1 do
  begin
    FListaTiposCliente.ProcurarPorIndice(LIndex, LTipoCliente);
    if LTipoCliente.TipoClienteId = ACodigo then
    begin
      AResultado := LTipoCliente;
      Break;
    end;
  end;
end;

procedure TPaginaListaTiposCliente.Show;
var
  LSair: Boolean;
begin
  LSair := False;
  while not (LSair) do
  begin
    Self.CarregarTiposCliente;
    Self.ExibirTiposCliente;
    Self.MostrarComandos;
    Self.RecuperarComando(LSair);
  end;
end;

end.

