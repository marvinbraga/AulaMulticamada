unit Marvin.AulaMulticamada.REST.Server;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, IdHTTPWebBrokerBridge, Web.HTTPApp, FMX.Controls.Presentation;

type
  TfrmAulaMulticamadasRESTServer = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    Label1: TLabel;
    ButtonOpenBrowser: TButton;
    stbStyle: TStyleBook;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAulaMulticamadasRESTServer: TfrmAulaMulticamadasRESTServer;

implementation

{$R *.fmx}

uses
  WinApi.Windows, Winapi.ShellApi, Datasnap.DSSession;

procedure TfrmAulaMulticamadasRESTServer.ApplicationIdle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  EditPort.Enabled := not FServer.Active;
end;

procedure TfrmAulaMulticamadasRESTServer.ButtonOpenBrowserClick(Sender: TObject);
var
  LURL: string;
begin
  StartServer;
  LURL := Format('http://localhost:%s', [EditPort.Text]);
  ShellExecute(0,
        nil,
        PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TfrmAulaMulticamadasRESTServer.ButtonStartClick(Sender: TObject);
begin
  StartServer;
end;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

procedure TfrmAulaMulticamadasRESTServer.ButtonStopClick(Sender: TObject);
begin
  TerminateThreads;
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

procedure TfrmAulaMulticamadasRESTServer.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
  Application.OnIdle := ApplicationIdle;
end;

procedure TfrmAulaMulticamadasRESTServer.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;
  end;
end;

end.
