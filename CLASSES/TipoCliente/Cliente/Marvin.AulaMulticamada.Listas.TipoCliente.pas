{  Arquivo criado automaticamente Gerador Multicamadas
   (Multitiers Generator VERSÃO 0.01)
   Data e Hora: 11/10/2016 - 23:02:06
}

unit Marvin.AulaMulticamada.Listas.TipoCliente;

interface

uses
  Classes,
  { Marvin }
  uMRVClasses,
  Marvin.AulaMulticamada.Classes.TipoCliente;

type
  TMRVListaTipoCliente = class(TMRVListaBase)
  public
    function ProcurarItem(const AItem: TMRVTipoCliente): TMRVTipoCliente; overload;
    function ProcurarPorIndice(const AIndex: Integer; var AResultado:
      TMRVTipoCliente): Boolean; overload;
    function ProcurarPorChave(const AChave: string; var AResultado:
      TMRVTipoCliente): Boolean; overload;
  end;

implementation

{ TMRVListaTipoCliente }

function TMRVListaTipoCliente.ProcurarPorChave(const AChave: string; var
  AResultado: TMRVTipoCliente): Boolean;
begin
  AResultado := inherited ProcurarPorChave(AChave) as TMRVTipoCliente;
  Result := AResultado <> nil;
end;

function TMRVListaTipoCliente.ProcurarItem(const AItem: TMRVTipoCliente): TMRVTipoCliente;
begin
  Result := inherited ProcurarItem(AItem) as TMRVTipoCliente;
end;

function TMRVListaTipoCliente.ProcurarPorIndice(const AIndex: Integer; var
  AResultado: TMRVTipoCliente): Boolean;
begin
  AResultado := inherited ProcurarPorIndice(AIndex) as TMRVTipoCliente;
  Result := AResultado <> nil;
end;

initialization
  RegisterClass(TMRVListaTipoCliente);

finalization
  UnRegisterClass(TMRVListaTipoCliente);

end.


