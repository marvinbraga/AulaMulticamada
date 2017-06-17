unit Marvin.VCL.StyleManager;

interface

uses
  Vcl.Menus;

type
  { interface para VCL Style Manager }
  IVclStyleManager = interface(IInterface)
    ['{2B441724-C0C1-47D2-80E6-B0D5A7DD69DF}']
  end;

  { Fábrica }
  coVCLStyleManager = class
  public
    class function Create(AMenuItem: TMenuItem): IVclStyleManager;
  end;

implementation

uses
  Winapi.Windows,
  VCL.Graphics,
  VCL.Controls,
  VCL.Forms,
  VCL.Themes,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
  System.Generics.Defaults,
  StrUtils,
  IniFiles;

resourcestring
  RS_STYLES_MENU_ITEM = 'Estilos';

type
  { Classe para gerenciar os estilos VCL do formulário. }
  TMRVVclStyleManager = class(TInterfacedObject, IVclStyleManager)
  strict private
    FMenuItem: TMenuItem;
  protected
    { métodos }
    procedure LoadVCLStyles;
    procedure InternalStyleMenuClick(ASender: TObject);
    procedure AdjustCheckedItem(const AStyleName: string);
    function GetActiveStyle(AIniFile: string;
      var AActiveStyle: string): Boolean;
    procedure StoreActiveStyle(AIniFile: string; const AActiveStyle: string);
    procedure SetMenuItemCaption(const AStyleName: string);
  public
    constructor Create(AMenuItem: TMenuItem); virtual;
    destructor Destroy; override;
  end;

{ coVCLStyleManager }

class function coVCLStyleManager.Create(AMenuItem: TMenuItem): IVclStyleManager;
begin
  Result := TMRVVclStyleManager.Create(AMenuItem);
end;

{ TMRVVclStyleManager }

constructor TMRVVclStyleManager.Create(AMenuItem: TMenuItem);
begin
  FMenuItem := AMenuItem;
  { carrega os estilos }
  Self.LoadVCLStyles;
end;

destructor TMRVVclStyleManager.Destroy;
begin
  FMenuItem := nil;
  inherited;
end;

function TMRVVclStyleManager.GetActiveStyle(AIniFile: string;
  var AActiveStyle: string): Boolean;
var
  LIniFile: TIniFile;
begin
  { cria o arquivo INI }
  LIniFile := TIniFile.Create(AIniFile);
  try
    { verifica se encontrou o estilo }
    Result := LIniFile.ValueExists('Appearances', 'ActiveStyle');
    if Result then
      { recupera o nome do estilo }
      AActiveStyle := LIniFile.ReadString('Appearances', 'ActiveStyle', '');
  finally
    LIniFile.Free;
  end;
end;

procedure TMRVVclStyleManager.LoadVCLStyles;
var
  LStyleNames: TArray<string>;
  LStylesMenuItem: TMenuItem;
  LActiveStyle, LStyleName: string;
begin
  { recupera o estilo do arquivo INI e existe um estilo informado }
  if (Self.GetActiveStyle(ChangeFileExt(ParamStr(0), '.ini'), LActiveStyle) and
    (LActiveStyle <> EmptyStr)) then
  begin
    { atualiza o estilo com o nome recuperado }
    TStyleManager.TrySetStyle(LActiveStyle, False);
    Self.SetMenuItemCaption(LActiveStyle);
  end;

  { recupera os estilos disponíveis }
  LStyleNames := TStyleManager.StyleNames;
  { ordena os nomes dos estilos }
  TArray.Sort<string>(LStyleNames, TStringComparer.Ordinal);
  { percorre os estilos recuperados }
  for LStyleName in LStyleNames do
  begin
    { cria e configura os menus }
    LStylesMenuItem := TMenuItem.Create(FMenuItem);
    LStylesMenuItem.Caption := LStyleName;
    LStylesMenuItem.OnClick := InternalStyleMenuClick;
    FMenuItem.Add(LStylesMenuItem);
  end;
  Self.AdjustCheckedItem(LActiveStyle);
end;

procedure TMRVVclStyleManager.AdjustCheckedItem(const AStyleName: string);
var
  LMenuItem: TMenuItem;
  LStyleName: string;
begin
  { percorre todos os itens do menu }
  for LMenuItem in FMenuItem do
  begin
    LStyleName := ReplaceStr(LMenuItem.Caption, '&', '');
    { ajusta o check para o estilo selecionado }
    LMenuItem.Checked := (LStyleName = AStyleName);
  end;
end;

procedure TMRVVclStyleManager.SetMenuItemCaption(const AStyleName: string);
begin
  { ajusta o item do menu com o nome do estilo selecionado }
  FMenuItem.Caption := Format('[%S] ' + RS_STYLES_MENU_ITEM, [AStyleName]);
end;

procedure TMRVVclStyleManager.StoreActiveStyle(AIniFile: string;
  const AActiveStyle: string);
var
  LIniFile: TIniFile;
begin
  LIniFile := TIniFile.Create(AIniFile);
  try
    { guarda no arquivo INI o nome do estilo selecionado }
    LIniFile.WriteString('Appearances', 'ActiveStyle', AActiveStyle);
  finally
    LIniFile.Free;
  end;
end;

procedure TMRVVclStyleManager.InternalStyleMenuClick(ASender: TObject);
var
  LMenuItem: TMenuItem;
  LStyleName: string;
begin
  if (ASender is TMenuItem) then
  begin
    LMenuItem := (ASender as TMenuItem);
    { seleciona um novo estilo }
    LStyleName := ReplaceStr(LMenuItem.Caption, '&', '');
    { altera o estilo }
    TStyleManager.TrySetStyle(LStyleName);
    { ajusta o item principal }
    Self.SetMenuItemCaption(LStyleName);
    { seleciona o item do menu }
    Self.AdjustCheckedItem(LStyleName);
    { salva o estilo atual no arquivo INI }
    Self.StoreActiveStyle(ChangeFileExt(ParamStr(0), '.ini'),
      TStyleManager.ActiveStyle.Name);
  end;
end;

end.
