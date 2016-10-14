{  Arquivo criado automaticamente Gerador Multicamadas
   (Multitiers Generator VERSÃO 0.01)
   Data e Hora: 11/10/2016 - 23:04:17
}

unit Marvin.AulaMulticamada.Listas.Cliente;

interface

uses
  Classes,
  { Marvin }
  uMRVClasses,
  Marvin.AulaMulticamada.Classes.Cliente;

type
  TMRVListaCliente = class(TMRVListaBase)
  public
    function ProcurarItem(const AItem: TMRVCliente): TMRVCliente; overload;
    function ProcurarPorIndice(const AIndex: Integer; var AResultado:
      TMRVCliente): Boolean; overload;
    function ProcurarPorChave(const AChave: string; var AResultado: TMRVCliente):
      Boolean; overload;
  end;

implementation

{ TMRVListaCliente }

function TMRVListaCliente.ProcurarPorChave(const AChave: string; var AResultado:
  TMRVCliente): Boolean;
begin
  AResultado := inherited ProcurarPorChave(AChave) as TMRVCliente;
  Result := AResultado <> nil;
end;

function TMRVListaCliente.ProcurarItem(const AItem: TMRVCliente): TMRVCliente;
begin
  Result := inherited ProcurarItem(AItem) as TMRVCliente;
end;

function TMRVListaCliente.ProcurarPorIndice(const AIndex: Integer; var
  AResultado: TMRVCliente): Boolean;
begin
  AResultado := inherited ProcurarPorIndice(AIndex) as TMRVCliente;
  Result := AResultado <> nil;
end;

initialization
  RegisterClass(TMRVListaCliente);

finalization
  UnRegisterClass(TMRVListaCliente);

end.


