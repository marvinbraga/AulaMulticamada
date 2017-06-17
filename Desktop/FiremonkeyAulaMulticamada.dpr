program FiremonkeyAulaMulticamada;

uses
  System.StartUpCopy,
  FMX.Forms,
  Marvin.Desktop.GUI.Principal in 'Marvin.Desktop.GUI.Principal.pas' {frmPrincipal},
  Marvin.Desktop.GUI.Cadastro.Base in 'Marvin.Desktop.GUI.Cadastro.Base.pas' {fraCadastroBase: TFrame},
  Marvin.Desktop.GUI.Cadastro.TipoCliente in 'Marvin.Desktop.GUI.Cadastro.TipoCliente.pas' {fraCadastroTipoCliente: TFrame},
  Marvin.Desktop.GUI.Cadastro.Cliente in 'Marvin.Desktop.GUI.Cadastro.Cliente.pas' {fraCadastroClientes: TFrame},
  Marvin.Desktop.GUI.Item.Cliente in 'Marvin.Desktop.GUI.Item.Cliente.pas' {fraItemListaCliente: TFrame},
  Marvin.Components.Rect in 'Marvin.Components.Rect.pas',
  Marvin.Desktop.GUI.Lista.Clientes in 'Marvin.Desktop.GUI.Lista.Clientes.pas' {fraListaClientes: TFrame};

{$R *.res}

begin
  {$WARN SYMBOL_PLATFORM OFF}
  //ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  {$WARN SYMBOL_PLATFORM ON}
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
