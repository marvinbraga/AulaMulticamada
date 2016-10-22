{  Arquivo criado automaticamente Gerador Multicamadas
   (Multitiers Generator VERSÃO 0.01)
   Data e Hora: 11/10/2016 - 23:02:06
}

unit Marvin.AulaMulticamada.Repositorio.TipoCliente;

interface

uses
  { marvin }
  uMRVClassesServidor;

type
  IMRVRepositorioTipoCliente = interface(IMRVRepositorioConstraint)
    ['{DD895361-943F-4896-B30A-AF613B88D37A}']
    function GetNextId: Integer;
  end;

implementation

end.


