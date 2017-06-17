program ConsoleAulaMulticamada;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Marvin.Console.GUI.Principal in 'Marvin.Console.GUI.Principal.pas',
  Marvin.Console.GUI.Lista.Clientes in 'Marvin.Console.GUI.Lista.Clientes.pas',
  Marvin.Console.GUI.Lista.TiposCliente in 'Marvin.Console.GUI.Lista.TiposCliente.pas',
  Marvin.Console.GUI.Cadastro.Cliente in 'Marvin.Console.GUI.Cadastro.Cliente.pas',
  Marvin.Console.GUI.Cadastro.TipoCliente in 'Marvin.Console.GUI.Cadastro.TipoCliente.pas',
  Marvin.Console.Utils in 'Marvin.Console.Utils.pas';

var
  LPrincipal: TPrincipal;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    LPrincipal := TPrincipal.Create;
    try
      LPrincipal.Show;
    finally
      LPrincipal.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
