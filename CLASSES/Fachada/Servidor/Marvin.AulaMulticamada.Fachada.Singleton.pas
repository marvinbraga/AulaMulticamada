unit Marvin.AulaMulticamada.Fachada.Singleton;

interface

uses
  Marvin.AulaMulticamada.Fachada;

type
  TMRVAulaMulticamadasFacadeSingletonSealed = class sealed
  private
    class var
      FInstancia: TMRVFachadaAulaMulticamada;
  strict private
    class function GetInstancia: TMRVFachadaAulaMulticamada; static;
  protected
    constructor Create;
    destructor Destroy; reintroduce; virtual;
  public
    class property Instancia: TMRVFachadaAulaMulticamada read GetInstancia;
  end;

implementation

uses
  System.SysUtils;

{ TMRVNeapolisFacadeSingletonSealed }

constructor TMRVAulaMulticamadasFacadeSingletonSealed.Create;
begin
  { se tiver que inicializar algum objeto para utilizar na instância }
end;

destructor TMRVAulaMulticamadasFacadeSingletonSealed.Destroy;
begin
  { se tiver que finalizar algum objeto utilizado com a instância }
  inherited Destroy;
end;

class function TMRVAulaMulticamadasFacadeSingletonSealed.GetInstancia:
  TMRVFachadaAulaMulticamada;
begin
  if not (Assigned(FInstancia)) then
  begin
    FInstancia := TMRVFachadaAulaMulticamada.Create;
  end;
  Result := FInstancia;
end;

initialization

finalization
  if Assigned(TMRVAulaMulticamadasFacadeSingletonSealed.FInstancia) then
  begin
    FreeAndNil(TMRVAulaMulticamadasFacadeSingletonSealed.FInstancia);
  end;

end.


