{  Arquivo criado automaticamente Gerador Multicamadas
   (Multitiers Generator VERSÃO 0.01)
   Data e Hora: 11/10/2016 - 23:04:17
}

unit Marvin.AulaMulticamada.Classes.Cliente;

interface

uses
  Classes,
  { Marvin }
  uMRVClasses;

type
  TMRVCliente = class(TMRVDadosBase)
  private
    FClienteid: Integer;
    FTipoClienteId: Integer;
    FNome: string;
    FNumerodocumento: string;
    FDatahoracadastro: TDateTime;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure Assign(Source: TMRVDadosBase); override;
    function GetKey: string; override;
  published
    [MarvinAttribute]
    property Clienteid: Integer read FClienteid write FClienteid;
    [MarvinAttribute]
    property TipoClienteId: Integer read FTipoClienteId write FTipoClienteId;
    [MarvinAttribute]
    property Nome: string read FNome write FNome;
    [MarvinAttribute]
    property Numerodocumento: string read FNumerodocumento write FNumerodocumento;
    [MarvinAttribute]
    property Datahoracadastro: TDateTime read FDatahoracadastro write FDatahoracadastro;
  end;

implementation

uses
  { Marvin }
  uMRVConsts,
  System.SysUtils;

{ TMRVCliente }

constructor TMRVCliente.Create;
begin
  inherited;
end;

destructor TMRVCliente.Destroy;
begin
  inherited;
end;

procedure TMRVCliente.Assign(Source: TMRVDadosBase);
begin
  inherited;
  FClienteid := (Source as TMRVCliente).Clienteid;
  FTipoClienteId := (Source as TMRVCliente).TipoClienteId;
  FNome := (Source as TMRVCliente).Nome;
  FNumerodocumento := (Source as TMRVCliente).Numerodocumento;
  FDatahoracadastro := (Source as TMRVCliente).Datahoracadastro;
end;

procedure TMRVCliente.Clear;
begin
  inherited;
  FClienteid := C_INTEGER_NULL;
  FTipoClienteId := C_INTEGER_NULL;
  FNome := C_STRING_NULL;
  FNumerodocumento := C_STRING_NULL;
  FDatahoracadastro := C_DATE_TIME_NULL;
end;

function TMRVCliente.GetKey: string;
begin
  { retorna o ID do cliente }
  Result := IntToStr(Self.Clienteid);
end;

initialization
  RegisterClass(TMRVCliente);

finalization
  UnRegisterClass(TMRVCliente);

end.


