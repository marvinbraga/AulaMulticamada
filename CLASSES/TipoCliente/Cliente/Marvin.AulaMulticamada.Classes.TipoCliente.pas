{  Arquivo criado automaticamente Gerador Multicamadas
   (Multitiers Generator VERSÃO 0.01)
   Data e Hora: 11/10/2016 - 23:02:06
}

unit Marvin.AulaMulticamada.Classes.TipoCliente;

interface

uses
  Classes,
  { Marvin }
  uMRVClasses;

type
  TMRVTipoCliente = class(TMRVDadosBase)
  private
    FTipoClienteId: Integer;
    FDescricao: string;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure Assign(Source: TMRVDadosBase); override;
    function GetKey: string; override;
  published
    [MarvinAttribute]
    property TipoClienteId: Integer read FTipoClienteId write FTipoClienteId;
    [MarvinAttribute]
    property Descricao: string read FDescricao write FDescricao;
  end;

implementation

uses
  { Marvin }
  uMRVConsts,
  System.SysUtils;

{ TMRVTipoCliente }

constructor TMRVTipoCliente.Create;
begin
  inherited;
end;

destructor TMRVTipoCliente.Destroy;
begin
  inherited;
end;

procedure TMRVTipoCliente.Assign(Source: TMRVDadosBase);
begin
  inherited;
  FTipoClienteId := (Source as TMRVTipoCliente).TipoClienteId;
  FDescricao := (Source as TMRVTipoCliente).Descricao;
end;

procedure TMRVTipoCliente.Clear;
begin
  inherited;
  FTipoClienteId := C_INTEGER_NULL;
  FDescricao := C_STRING_NULL;
end;

function TMRVTipoCliente.GetKey: string;
begin
  {Result := IntToStr(TipoClienteId); -> alterado para...}
  Result := FDescricao;
end;

initialization
  RegisterClass(TMRVTipoCliente);

finalization
  UnRegisterClass(TMRVTipoCliente);

end.


