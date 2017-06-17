unit Marvin.Console.GUI.Principal;

interface

uses
  System.Generics.Collections,
  System.Rtti,
  { comunicação }
  Marvin.Desktop.Repositorio.AulaMulticamada,
  Marvin.Desktop.ClientClasses.AulaMulticamada,
  { util }
  Marvin.Console.Utils,
  { listas }
  Marvin.Console.GUI.Lista.Clientes,
  Marvin.Console.GUI.Lista.TiposCliente;

type
  TPrincipal = class(TObject)
  private
    { client module }
    FClientClasses: IMRVRepositorioAulaMulticamada;
    { páginas }
    FPaginaListaClientes: TPaginaListaClientes;
    FPaginaListaTiposCliente: TPaginaListaTiposCliente;
    { campos }
    FCores: TObjectList<TDefaultColor>;
    { métodos de apoio }
    procedure DoInit;
    procedure InicializarListas;
    procedure InicializarCores;
  protected
    procedure ApresentarLinha;
    procedure MostrarCabecalho;
    procedure MostrarMenu;
    procedure MostrarComandos;
    procedure MostrarClientes;
    procedure MostrarTiposCliente;
    procedure RecuperarComando(var ASair: Boolean);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    { métodos de utilização }
    procedure Show;
  end;

implementation

uses
  System.SysUtils;

{ TPrincipal }

procedure TPrincipal.ApresentarLinha;
begin
  TConsoleUtils.WritelnWithColor(
    '/--------------------------------------------------------/',
    TConsoleUtils.C_GERAL);
end;

constructor TPrincipal.Create;
begin
  inherited;
  { cria o controle de cores padrão }
  FCores := TObjectList<TDefaultColor>.Create(TDefaultColorComparer.Create);
  { passa o controle para a classe de utilidades }
  TConsoleUtils.FCores := FCores;
  Self.DoInit;
end;

destructor TPrincipal.Destroy;
begin
  { libera as páginas }
  FPaginaListaClientes.Free;
  FPaginaListaTiposCliente.Free;
  { aterra o clientmodule }
  FClientClasses := nil;
  { libera o controle de cores }
  FCores.Free;
  TConsoleUtils.FCores := nil;
  inherited;
end;

procedure TPrincipal.DoInit;
begin
  { inicializa o client module }
  FClientClasses := coAulaMulticamadasClientJSON.Create;
  { inicializa cores }
  Self.InicializarCores;
  { inicializa as classes de listas }
  Self.InicializarListas;
end;

procedure TPrincipal.InicializarCores;
const
  LC_BACKGROUND_COLOR: TConsoleColor = ccBlueDark;
var
  LDefaultColor: TDefaultColor;

  procedure LAddColor(AName: string; ABackgroundColor: TConsoleColor;
    AForegroundColor: TConsoleColor);
  begin
    LDefaultColor := TDefaultColor.Create;
    FCores.Add(LDefaultColor);
    LDefaultColor.Name := AName;
    LDefaultColor.ForegroundColor := AForegroundColor;
    LDefaultColor.BackgroundColor := ABackgroundColor;
  end;

begin
  { adiciona cores }
  LAddColor(TConsoleUtils.C_GERAL, LC_BACKGROUND_COLOR, ccBlue);
  LAddColor(TConsoleUtils.C_GERAL_TEXTO, LC_BACKGROUND_COLOR, ccGray);
  LAddColor(TConsoleUtils.C_CABECALHO_TEXTO, LC_BACKGROUND_COLOR, ccGreen);
  LAddColor(TConsoleUtils.C_TEXTO, LC_BACKGROUND_COLOR, ccWhite);
  LAddColor(TConsoleUtils.C_TEXTO_ENFASE, LC_BACKGROUND_COLOR, ccYellow);
  LAddColor(TConsoleUtils.C_TITULO_TABELA, LC_BACKGROUND_COLOR, ccYellow);
  LAddColor(TConsoleUtils.C_MENSAGEM_ERRO, ccYellow, ccRed);
end;

procedure TPrincipal.InicializarListas;
begin
  { inicializa a página de clientes }
  FPaginaListaClientes := TPaginaListaClientes.Create(FClientClasses);
  { inicializa a página de tipos de cliente }
  FPaginaListaTiposCliente := TPaginaListaTiposCliente.Create(FClientClasses);
end;

procedure TPrincipal.Show;
var
  LSair: Boolean;
begin
  LSair := False;
  while not(LSair) do
  begin
    { limpa a tela }
    TConsoleUtils.ClearScreen;
    { monta o cabeçalho }
    Self.MostrarCabecalho;
    Self.MostrarMenu;
    { exibe os comandos }
    Self.MostrarComandos;
    Self.RecuperarComando(LSair);
  end;
end;

procedure TPrincipal.MostrarCabecalho;
begin
  { monta o cabeçalho }
  Self.ApresentarLinha;
  TConsoleUtils.WriteWithColor('| ', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor('Sistema Console - Aula Multicamadas',
    TConsoleUtils.C_CABECALHO_TEXTO);
  TConsoleUtils.WriteWithColor('                    |', TConsoleUtils.C_GERAL);
  Writeln('');
  Self.ApresentarLinha;
end;

procedure TPrincipal.MostrarComandos;
begin
  { monta o texto dos comandos }
  TConsoleUtils.WriteWithColor('|', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor(' (', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('C', TConsoleUtils.C_TEXTO_ENFASE);
  TConsoleUtils.WriteWithColor(')lientes ou (', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('T', TConsoleUtils.C_TEXTO_ENFASE);
  TConsoleUtils.WriteWithColor(')ipo Clientes...              ', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('         |', TConsoleUtils.C_GERAL);
  Writeln('');
end;

procedure TPrincipal.MostrarMenu;
begin
  { monta o texto do menu }
  TConsoleUtils.WriteWithColor('|', TConsoleUtils.C_GERAL);
  TConsoleUtils.WriteWithColor(' Escreva "', TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('SAIR', TConsoleUtils.C_TEXTO_ENFASE);
  TConsoleUtils.WriteWithColor('" para encerrar o programa ou escolha:    ',
    TConsoleUtils.C_GERAL_TEXTO);
  TConsoleUtils.WriteWithColor('|', TConsoleUtils.C_GERAL);
  Writeln('');
end;

procedure TPrincipal.RecuperarComando(var ASair: Boolean);
var
  LComando: string;
begin
  { prepara o comando }
  LComando := EmptyStr;
  Self.ApresentarLinha;
  TConsoleUtils.WriteWithColor('Escreva: ', TConsoleUtils.C_TEXTO);
  TConsoleUtils.SetConsoleColor(TConsoleUtils.C_TEXTO_ENFASE);
  { recupera o comando }
  Readln(Input, LComando);
  if Trim(UpperCase(LComando)) = 'C' then
  begin
    { exibe lista de clientes }
    Self.MostrarClientes;
  end
  else if Trim(UpperCase(LComando)) = 'T' then
  begin
    { exibe lista de tipos de clientes }
    Self.MostrarTiposCliente;
  end;
  Self.ApresentarLinha;
  ASair := (Trim(UpperCase(LComando)) = 'SAIR');
end;

procedure TPrincipal.MostrarTiposCliente;
begin
  FPaginaListaTiposCliente.Show;
end;

procedure TPrincipal.MostrarClientes;
begin
  FPaginaListaClientes.Show;
end;

end.
