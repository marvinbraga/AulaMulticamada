{  Arquivo criado automaticamente Gerador Multicamadas
   (Multitiers Generator VERSÃO 0.01)
   Data e Hora: 11/10/2016 - 23:04:17
}

unit Marvin.AulaMulticamada.Repositorio.Cliente;

interface

uses
  { marvin }
  uMRVClassesServidor;

type
  IMRVRepositorioCliente = interface(IMRVRepositorioConstraint)
    ['{56584F9D-56DB-4040-A2D3-F11A20D79911}']
    function GetNextId: Integer;
  end;

implementation

end.


