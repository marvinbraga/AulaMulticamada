unit Marvin.Desktop.ExceptionsModule.AulaMulticamada;

interface

uses
  { marvin }
  uMRVExcecoesFramework,
  Marvin.AulaMulticamada.Excecoes.TipoCliente,
  Marvin.AulaMulticamada.Excecoes.Cliente;

type
  { exceção base }
  EMRVExceptionClientModule = class(EMRVException)
  private
    FExceptClassName: string;
  public
    constructor Create(AExceptClassName: string; AMessage: string); reintroduce; overload; virtual;
    property ExceptClassName: string read FExceptClassName write FExceptClassName;
  end;

  TMRVAulaMultiCamadaExceptionsModule = class
  public
    class function GetException(const AExceptionClassName: string;
      const AMessage: string = ''): EMRVException;
  end;

implementation

uses
  System.SysUtils;

{ TMRVAulaMultiCamadaClientExceptions }

class function TMRVAulaMultiCamadaExceptionsModule.GetException(
  const AExceptionClassName: string; const AMessage: string): EMRVException;
var
  LResult: EMRVException;
begin
  { verifica nas exceções de TipoCliente }
  LResult := TMRVTipoClienteExceptionFactory.GetException(AExceptionClassName,
    AMessage);
  { verifica nas exceções de Cliente }
  if not Assigned(LResult) then
  begin
    LResult := TMRVClienteExceptionFactory.GetException(AExceptionClassName,
      AMessage);
  end;
  if not Assigned(LResult) then
  begin
    { cria exceção padrão }
    LResult := EMRVExceptionClientModule.Create(AExceptionClassName, AMessage);
  end;
  Result := LResult;
end;

{ EMRVExceptionClientModule }

constructor EMRVExceptionClientModule.Create(AExceptClassName,
  AMessage: string);
begin
  FExceptClassName := AExceptClassName;
  Self.Message := Format('[%S] %S', [AExceptClassName, AMessage])
end;

end.
