program TesteApresentacaoRetangulos;

uses
  System.StartUpCopy,
  FMX.Forms,
  Marvin.TesteApresentacaoRetangulos.GUI.Principal in 'Marvin.TesteApresentacaoRetangulos.GUI.Principal.pas' {frmPrincipal},
  Marvin.Components.Rect in 'Marvin.Components.Rect.pas';

{$R *.res}

begin
  {$WARN SYMBOL_PLATFORM OFF}
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  {$WARN SYMBOL_PLATFORM ON}
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
