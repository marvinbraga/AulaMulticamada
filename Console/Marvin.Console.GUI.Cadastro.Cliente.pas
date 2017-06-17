unit Marvin.Console.GUI.Cadastro.Cliente;

interface

uses
  Marvin.Console.Utils,
  { comunicação }
  Marvin.Desktop.Repositorio.AulaMulticamada,
  { exceções }
  Marvin.AulaMulticamada.Excecoes.Cliente,
  { classes }
  Marvin.AulaMulticamada.Classes.Cliente,
  Marvin.AulaMulticamada.Listas.Cliente;

type
  TPaginaSalvarCliente = class(TObject)
  private
    { comunicação }
    FClientClasses: IMRVRepositorioAulaMulticamada;
    { classes }
    FCliente: TMRVCliente;
    { status }
    FPaginaStatus: TPaginaStatus;
  protected
    { métodos de apoio }
    procedure ApresentarLinha;
    procedure ExibirCabecalhoAlterar;
    procedure ExibirCabecalhoNovo;
    procedure ExibirCliente(const ACliente: TMRVCliente);
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
    property Cliente: TMRVCliente read FCliente;
  end;

implementation

uses
  System.SysUtils;

{ TPaginaSalvarCliente }

procedure TPaginaSalvarCliente.ApresentarLinha;
begin
  TConsoleUtils.WritelnWithColor(
    '/-------------------------------------------------------------------/',
    TConsoleUtils.C_GERAL);
end;

constructor TPaginaSalvarCliente.Create(
  const AClientClasses: IMRVRepositorioAulaMulticamada;
  const APaginaStatus: TPaginaStatus);
begin
  FClientClasses := AClientClasses;
  FPaginaStatus := APaginaStatus;
  FCliente := TMRVCliente.Create;
end;

destructor TPaginaSalvarCliente.Destroy;
begin
  FCliente.Free;
  FClientClasses := nil
end;

procedure TPaginaSalvarCliente.DoSalvar;
var
  LCliente: TMRVCliente;
begin
  inherited;
  LCliente := nil;
  case FPaginaStatus of
    psNovo:
      begin
        { manda o ClientModule incluir }
        LCliente := FClientClasses.ClientesInserir(FCliente) as
          TMRVCliente;
      end;
    psAlterar:
      begin
        { manda o ClientModule alterar }
        LCliente := FClientClasses.ClientesAlterar(FCliente) as
          TMRVCliente;
      end;
  end;
  try
    FCliente.Assign(LCliente);
  finally
    { libera o retorno }
    LCliente.DisposeOf;
  end;
end;

procedure TPaginaSalvarCliente.DoShowAlterar;
var
  LSair: Boolean;
begin
  LSair := False;
  while not(LSair) do
  begin
    { exibe informações atuais do Tipo de Cliente }
    Self.ExibirCabecalhoAlterar;
    { recupera os dados }
    Self.ExibirCliente(FCliente);
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

procedure TPaginaSalvarCliente.DoShowNovo;
var
  LSair: Boolean;
begin
  LSair := False;
  while not(LSair) do
  begin
    FCliente.Clear;
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
        on E: EMRVExcecoesCliente do
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

procedure TPaginaSalvarCliente.ExibirCabecalhoAlterar;
begin
  TConsoleUtils.ClearScreen;
  Self.ApresentarLinha;
  TConsoleUtils.WriteWithColor('|                          ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Alterar Cliente', TConsoleUtils.C_CABECALHO_TEXTO);
  TConsoleUtils.WriteWithColor('                          |', TConsoleUtils.C_GERAL);
  Writeln('');
  Self.ApresentarLinha;
  TConsoleUtils.WriteWithColor('| ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Código', TConsoleUtils.C_TITULO_TABELA);
  TConsoleUtils.WriteWithColor(' | ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Nome', TConsoleUtils.C_TITULO_TABELA);
  TConsoleUtils.WriteWithColor('                                                     |',
    TConsoleUtils.C_GERAL);
  Writeln('');
  Self.ApresentarLinha;
end;

procedure TPaginaSalvarCliente.ExibirCabecalhoNovo;
begin
  TConsoleUtils.ClearScreen;
  Self.ApresentarLinha;
  TConsoleUtils.WriteWithColor('|                         ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Inserir Cliente', TConsoleUtils.C_CABECALHO_TEXTO);
  TConsoleUtils.WriteWithColor('                           |', TConsoleUtils.C_GERAL);
  Writeln('');
  Self.ApresentarLinha;
  TConsoleUtils.WriteWithColor('| ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Informe a seguir os seguintes campos para um NOVO Cliente:', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('        |', TConsoleUtils.C_GERAL);
  Writeln('');
  TConsoleUtils.WriteWithColor('| ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Nome', TConsoleUtils.C_TEXTO_ENFASE);
//  TConsoleUtils.WriteWithColor(', ', TConsoleUtils.C_GERAL_TEXTO);
//  TConsoleUtils.WriteWithColor('Núm. Documento', TConsoleUtils.C_TEXTO_ENFASE);
//  TConsoleUtils.WriteWithColor(' e o ', TConsoleUtils.C_GERAL_TEXTO);
//  TConsoleUtils.WriteWithColor('Tipo de Cliente', TConsoleUtils.C_TEXTO_ENFASE);
  TConsoleUtils.WriteWithColor('                                                              |', TConsoleUtils.C_GERAL);
  Writeln('');
  Self.ApresentarLinha;
end;

procedure TPaginaSalvarCliente.ExibirCliente(const ACliente: TMRVCliente);
begin
  TConsoleUtils.WriteWithColor('| ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor(Format('%6d', [ACliente.ClienteId]),
    TConsoleUtils.C_TEXTO);
  TConsoleUtils.WriteWithColor(' | ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor(Format('%-56S', [ACliente.Nome]),
    TConsoleUtils.C_TEXTO);
  TConsoleUtils.WriteWithColor(' |', TConsoleUtils.C_GERAL);
  Writeln('');
  Self.ApresentarLinha;
end;

procedure TPaginaSalvarCliente.MostrarComandosAlterar;
begin
  TConsoleUtils.WriteWithColor('|', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor(' Informe campo que deseja alterar:', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('1', TConsoleUtils.C_TEXTO_ENFASE);
  TConsoleUtils.WriteWithColor(' - Nome, ', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('2', TConsoleUtils.C_TEXTO_ENFASE);
  TConsoleUtils.WriteWithColor(' - Núm. Doc., ', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('3', TConsoleUtils.C_TEXTO_ENFASE);
  TConsoleUtils.WriteWithColor(' - Tipo Cliente.', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('|', TConsoleUtils.C_GERAL);
  TConsoleUtils.SetConsoleColor(TConsoleUtils.C_TEXTO);
  Writeln('');
  Self.ApresentarLinha;
end;

procedure TPaginaSalvarCliente.RecuperarComandoAlterar(var ASair: Boolean);
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
    FCliente.Nome := Trim(LComando);
    FCliente.Numerodocumento := '123';
    FCliente.Datahoracadastro := Now;
    FCliente.TipoClienteId := 2;
  end;
end;

procedure TPaginaSalvarCliente.RecuperarComandoNovo(var ASair: Boolean);
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
    FCliente.Nome := Trim(LComando);
    FCliente.Numerodocumento := '123';
    FCliente.Datahoracadastro := Now;
    FCliente.TipoClienteId := 2;
  end;
end;

procedure TPaginaSalvarCliente.Show;
begin
  case FPaginaStatus of
    psNovo: Self.DoShowNovo;
    psAlterar: Self.DoShowAlterar;
  end;
end;

end.
