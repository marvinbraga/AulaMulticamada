unit Marvin.Console.GUI.Cadastro.TipoCliente;

interface

uses
  Marvin.Console.Utils,
  { comunicação }
  Marvin.Desktop.Repositorio.AulaMulticamada,
  { exceções }
  Marvin.AulaMulticamada.Excecoes.TipoCliente,
  { classes }
  Marvin.AulaMulticamada.Classes.TipoCliente,
  Marvin.AulaMulticamada.Listas.TipoCliente;

type
  TPaginaSalvarTipoCliente = class(TObject)
  private
    { comunicação }
    FClientClasses: IMRVRepositorioAulaMulticamada;
    { classes }
    FTipoCliente: TMRVTipoCliente;
    { status }
    FPaginaStatus: TPaginaStatus;
  protected
    { métodos de apoio }
    procedure ApresentarLinha;
    procedure ExibirCabecalhoAlterar;
    procedure ExibirCabecalhoNovo;
    procedure ExibirTipoCliente(const ATipoCliente: TMRVTipoCliente);
    procedure MostrarComandosAlterar;
    procedure RecuperarComandoAlterar(var ASair: Boolean);
    procedure RecuperarComandoNovo(var ASair: Boolean);
    procedure DoSalvar;
    procedure DoShowNovo;
    procedure DoShowAlterar;
  public
    constructor Create(const AClientClasses: IMRVRepositorioAulaMulticamada;
      const APaginaStatus: TPaginaStatus); overload;
    destructor Destroy; override;
    procedure Show;
    property TipoCliente: TMRVTipoCliente read FTipoCliente;
  end;

implementation

uses
  System.SysUtils;

{ TPaginaSalvarTipoCliente }

procedure TPaginaSalvarTipoCliente.ApresentarLinha;
begin
  TConsoleUtils.WritelnWithColor('/-------------------------------------------------------------------/',
    TConsoleUtils.C_GERAL);
end;

constructor TPaginaSalvarTipoCliente.Create(
  const AClientClasses: IMRVRepositorioAulaMulticamada;
  const APaginaStatus: TPaginaStatus);
begin
  FClientClasses := AClientClasses;
  FPaginaStatus := APaginaStatus;
  FTipoCliente := TMRVTipoCliente.Create;
end;

destructor TPaginaSalvarTipoCliente.Destroy;
begin
  FTipoCliente.Free;
  FClientClasses := nil
end;

procedure TPaginaSalvarTipoCliente.DoSalvar;
var
  LTipoCliente: TMRVTipoCliente;
begin
  inherited;
  LTipoCliente := nil;
  case FPaginaStatus of
    psNovo:
      begin
        { manda o ClientModule incluir }
        LTipoCliente := FClientClasses.TiposClienteInserir(FTipoCliente) as
          TMRVTipoCliente;
      end;
    psAlterar:
      begin
        { manda o ClientModule alterar }
        LTipoCliente := FClientClasses.TiposClienteAlterar(FTipoCliente) as
          TMRVTipoCliente;
      end;
  end;
  try
    FTipoCliente.Assign(LTipoCliente);
  finally
    { libera o retorno }
    LTipoCliente.DisposeOf;
  end;
end;

procedure TPaginaSalvarTipoCliente.DoShowAlterar;
var
  LSair: Boolean;
begin
  LSair := False;
  while not(LSair) do
  begin
    { exibe informações atuais do Tipo de Cliente }
    Self.ExibirCabecalhoAlterar;
    { recupera os dados }
    Self.ExibirTipoCliente(FTipoCliente);
    { exibe comandos }
    Self.MostrarComandosAlterar;
    { recupera o comando }
    Self.RecuperarComandoAlterar(LSair);
    { salvar }
    if not(LSair) then
    begin
      Self.DoSalvar;
    end;
  end;
end;

procedure TPaginaSalvarTipoCliente.DoShowNovo;
var
  LSair: Boolean;
begin
  LSair := False;
  while not(LSair) do
  begin
    FTipoCliente.Clear;
    { exibe informações atuais do Tipo de Cliente }
    Self.ExibirCabecalhoNovo;
    { recupera o comando }
    Self.RecuperarComandoNovo(LSair);
    { salvar }
    if not(LSair) then
    begin
      try
        Self.DoSalvar;
        LSair := True;
      except
        on E: EMRVExcecoesTipoCliente do
        begin
          LSair := False;
          { exibe mensagem  de erro }
          Writeln('');
          TConsoleUtils.WritelnWithColor('[Informação]' + #13#10 + E.Message,
            TConsoleUtils.C_MENSAGEM_ERRO);
          Readln;
        end;
        else
          raise;
      end;
    end;
  end;
end;

procedure TPaginaSalvarTipoCliente.ExibirCabecalhoAlterar;
begin
  TConsoleUtils.ClearScreen;
  Self.ApresentarLinha;
  TConsoleUtils.WriteWithColor('|                      ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Alterar Tipo de Cliente', TConsoleUtils.C_CABECALHO_TEXTO);
  TConsoleUtils.WriteWithColor('                      |', TConsoleUtils.C_GERAL);
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

procedure TPaginaSalvarTipoCliente.ExibirCabecalhoNovo;
begin
  TConsoleUtils.ClearScreen;
  Self.ApresentarLinha;
  TConsoleUtils.WriteWithColor('|                      ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Inserir Tipo de Cliente', TConsoleUtils.C_CABECALHO_TEXTO);
  TConsoleUtils.WriteWithColor('                      |', TConsoleUtils.C_GERAL);
  Writeln('');
  Self.ApresentarLinha;
  TConsoleUtils.WriteWithColor('| ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Informe a ', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('Descrição', TConsoleUtils.C_TEXTO_ENFASE);
  TConsoleUtils.WriteWithColor(' para o NOVO Tipo de Cliente.       ', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('           |', TConsoleUtils.C_GERAL);
  Writeln('');
  Self.ApresentarLinha;
end;

procedure TPaginaSalvarTipoCliente.ExibirTipoCliente(
  const ATipoCliente: TMRVTipoCliente);
begin
  TConsoleUtils.WriteWithColor('| ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor(Format('%6d', [ATipoCliente.TipoClienteId]),
    TConsoleUtils.C_TEXTO);
  TConsoleUtils.WriteWithColor(' | ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor(Format('%-56S', [ATipoCliente.Descricao]),
    TConsoleUtils.C_TEXTO);
  TConsoleUtils.WriteWithColor(' |', TConsoleUtils.C_GERAL);
  Writeln('');
  Self.ApresentarLinha;
end;

procedure TPaginaSalvarTipoCliente.MostrarComandosAlterar;
begin
  TConsoleUtils.WriteWithColor('|', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor(' Informe o novo valor para a ', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('Descrição', TConsoleUtils.C_TEXTO_ENFASE);
  TConsoleUtils.WriteWithColor(' do Tipo de Cliente.', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('         |', TConsoleUtils.C_GERAL);
  TConsoleUtils.SetConsoleColor(TConsoleUtils.C_TEXTO);
  Writeln('');
  Self.ApresentarLinha;
end;

procedure TPaginaSalvarTipoCliente.RecuperarComandoAlterar(var ASair: Boolean);
var
  LComando: string;
begin
  { recupera }
  TConsoleUtils.WriteWithColor('Escreva: ', TConsoleUtils.C_TEXTO);
  TConsoleUtils.SetConsoleColor(TConsoleUtils.C_TEXTO_ENFASE);
  Readln(Input, LComando);
  ASair := (Trim(LComando) = EmptyStr);
  if not(ASair) then
  begin
    FTipoCliente.Descricao := Trim(LComando);
  end;
end;

procedure TPaginaSalvarTipoCliente.RecuperarComandoNovo(var ASair: Boolean);
var
  LComando: string;
begin
  { recupera }
  TConsoleUtils.WriteWithColor('Escreva: ', TConsoleUtils.C_TEXTO);
  TConsoleUtils.SetConsoleColor(TConsoleUtils.C_TEXTO_ENFASE);
  Readln(Input, LComando);
  ASair := (Trim(LComando) = EmptyStr);
  if not(ASair) then
  begin
    FTipoCliente.Descricao := Trim(LComando);
  end;
end;

procedure TPaginaSalvarTipoCliente.Show;
begin
  case FPaginaStatus of
    psNovo: Self.DoShowNovo;
    psAlterar: Self.DoShowAlterar;
  end;
end;

end.
