program AulaMulticamadaRESTServer;
{$APPTYPE GUI}

{$R *.dres}

uses
  FMX.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  Marvin.AulaMulticamada.REST.Server in 'Marvin.AulaMulticamada.REST.Server.pas' {frmAulaMulticamadasRESTServer},
  Marvin.AulaMulticamada.REST.Server.Metodos in 'Marvin.AulaMulticamada.REST.Server.Metodos.pas',
  WebModuleAulaMulticamada in 'WebModuleAulaMulticamada.pas' {WebModuleAulaMulicamadas: TWebModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TfrmAulaMulticamadasRESTServer, frmAulaMulticamadasRESTServer);
  Application.Run;
end.
