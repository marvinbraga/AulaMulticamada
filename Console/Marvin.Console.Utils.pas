unit Marvin.Console.Utils;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.Generics.Defaults;

type
  { controle de cores }
  TConsoleColor = (ccBlack = 0, ccBlueDark = 1, ccGreenDark = 2, ccCyanDark = 3,
    ccRedDark = 4, ccMagentaDark = 5, ccYellowDark = 6, ccGray = 7,
    ccGrayDark = 8, ccBlue = 9, ccGreen = 10, ccCyan = 11, ccRed = 12,
    ccMagenta = 13, ccYellow = 14, ccWhite = 15);

  { controle de cor }
  TDefaultColor = class(TPersistent)
  strict private
    FName: string;
    FForegroundColor: TConsoleColor;
    FBackgroundColor: TConsoleColor;
  public
    procedure Assign(ASource: TPersistent); override;
    procedure Clear;
    property Name: string read FName write FName;
    property ForegroundColor: TConsoleColor read FForegroundColor write FForegroundColor;
    property BackgroundColor: TConsoleColor read FBackgroundColor write FBackgroundColor;
  end;

  { busca na ObjectList }
  TDefaultColorComparer = class(TComparer<TDefaultColor>)
  public
    function Compare(const Left, Right: TDefaultColor): Integer; override;
  end;

  { funções de ajuda }
  TConsoleUtils = class(TObject)
  public
    const C_GERAL: string = 'geral';
    const C_GERAL_TEXTO: string = 'geral_texto';
    const C_CABECALHO_TEXTO: string = 'cabecalho_texto';
    const C_TEXTO: string = 'texto';
    const C_TEXTO_ENFASE: string = 'texto_enfase';
    const C_TITULO_TABELA: string = 'titulo_tabela';
    const C_MENSAGEM_ERRO: string = 'mensagem_erro';
  public
    class var FCores: TObjectList<TDefaultColor>;
    class procedure ClearScreen;
    class procedure SetConsoleColor(ABackgroundColor: TConsoleColor;
      AForegroundColor: TConsoleColor); overload;
    class procedure SetConsoleColor(ADefaultColorName: string); overload;
    class procedure WriteWithColor(AText: string; ABackgroundColor: TConsoleColor;
      AForegroundColor: TConsoleColor); overload;
    class procedure WritelnWithColor(AText: string; ABackgroundColor: TConsoleColor;
      AForegroundColor: TConsoleColor); overload;
    class procedure WriteWithColor(AText: string; ADefaultColorName: string); overload;
    class procedure WritelnWithColor(AText: string; ADefaultColorName: string); overload;
    class procedure SetDefaultColor(ADefaultColorName: string);
  end;

  { tipo para configurar o estado da página }
  TPaginaStatus = (psNone, psNovo, psAlterar);

implementation

uses
  Winapi.Windows,
  System.SysUtils;

{ TConsoleUtils }

class procedure TConsoleUtils.ClearScreen;
var
  LSdtOut: THandle;
  LConsoleBuffer: TConsoleScreenBufferInfo;
  LConsoleSize: DWORD;
  LNumWritten: DWORD;
  LOrigin: TCoord;
begin
  { informa a cor padrão }
  Self.SetConsoleColor(TConsoleUtils.C_GERAL);
  {$WARNINGS OFF}
  LSdtOut := GetStdHandle(STD_OUTPUT_HANDLE);
  Win32Check(LSdtOut <> INVALID_HANDLE_VALUE);
  Win32Check(GetConsoleScreenBufferInfo(LSdtOut, LConsoleBuffer));
  LConsoleSize := LConsoleBuffer.dwSize.X * LConsoleBuffer.dwSize.Y;
  LOrigin.X := 0;
  LOrigin.Y := 0;
  Win32Check(FillConsoleOutputCharacter(LSdtOut, ' ', LConsoleSize, LOrigin, LNumWritten));
  Win32Check(FillConsoleOutputAttribute(LSdtOut, LConsoleBuffer.wAttributes, LConsoleSize,
    LOrigin, LNumWritten));
  Win32Check(SetConsoleCursorPosition(LSdtOut, LOrigin));
  {$WARNINGS ON}
end;

class procedure TConsoleUtils.SetConsoleColor(ABackgroundColor, AForegroundColor:
  TConsoleColor);
var
  LColor: Word;
begin
  { calcula a cor }
  LColor := 16 * Word(ABackgroundColor) + Word(AForegroundColor);
  { configura a cor }
  SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), LColor);
end;

class procedure TConsoleUtils.SetConsoleColor(ADefaultColorName: string);
begin
  { configura a cor }
  Self.SetDefaultColor(ADefaultColorName);
end;

class procedure TConsoleUtils.SetDefaultColor(ADefaultColorName: string);
var
  LSearchDefaultColor, LDefaultColor: TDefaultColor;
  LPosition: Integer;
begin
  LSearchDefaultColor := TDefaultColor.Create;
  try
    LSearchDefaultColor.Name := ADefaultColorName;
    LPosition := FCores.IndexOf(LSearchDefaultColor);
    { ajusta a cor padrão }
    TConsoleUtils.SetConsoleColor(ccBlack, ccGray);
    if LPosition > -1 then
    begin
      LDefaultColor := FCores.Items[LPosition];
      { ajusta a cor }
      TConsoleUtils.SetConsoleColor(LDefaultColor.BackgroundColor,
        LDefaultColor.ForegroundColor);
    end;
  finally
    LSearchDefaultColor.Free;
  end;
end;

class procedure TConsoleUtils.WritelnWithColor(AText: string; ABackgroundColor,
  AForegroundColor: TConsoleColor);
begin
  { ajusta a cor }
  TConsoleUtils.SetConsoleColor(ABackgroundColor, AForegroundColor);
  { imprime }
  Writeln(AText);
end;

class procedure TConsoleUtils.WriteWithColor(AText: string; ABackgroundColor,
  AForegroundColor: TConsoleColor);
begin
  { ajusta a cor }
  TConsoleUtils.SetConsoleColor(ABackgroundColor, AForegroundColor);
  { imprime }
  Write(AText);
end;

class procedure TConsoleUtils.WritelnWithColor(AText,
  ADefaultColorName: string);
begin
  { configura a cor }
  Self.SetDefaultColor(ADefaultColorName);
  { imprime }
  Writeln(AText);
end;

class procedure TConsoleUtils.WriteWithColor(AText, ADefaultColorName: string);
begin
  { configura a cor }
  Self.SetDefaultColor(ADefaultColorName);
  { imprime }
  Write(AText);
end;

{ TDefaultColor }

procedure TDefaultColor.Assign(ASource: TPersistent);
var
  LDefaultColor: TDefaultColor;
begin
  inherited;
  LDefaultColor := ASource as TDefaultColor;
  { recupera os dados }
  FName := LDefaultColor.Name;
  FForegroundColor := LDefaultColor.ForegroundColor;
  FBackgroundColor := LDefaultColor.BackgroundColor;
end;

procedure TDefaultColor.Clear;
begin
  FName := EmptyStr;
  FForegroundColor := ccWhite;
  FBackgroundColor := ccBlack;
end;

{ TDefaultColorComparer }

function TDefaultColorComparer.Compare(const Left,
  Right: TDefaultColor): Integer;
begin
  Result := -1;
  { verifica se os métodos são os mesmos }
  if (TDefaultColor(Left).Name = TDefaultColor(Right).Name) then
  begin
    Result := 0;
  end;
end;

end.

