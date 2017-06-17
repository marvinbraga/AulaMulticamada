unit Marvin.VCL.GUI.Principal;

interface

uses
  { marvin }
  Marvin.VCL.StyleManager,
  { interface comunicação }
  Marvin.Desktop.Repositorio.AulaMulticamada,
  { client module }
  Marvin.Desktop.ClientClasses.AulaMulticamada,
  { frames }
  Marvin.VCL.GUI.Cadastro.Base,
  Marvin.VCL.GUI.Cadastro.TipoCliente,
  Marvin.VCL.GUI.Cadastro.Cliente,
  { embarcadero }
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  VCL.Graphics,
  VCL.Controls,
  VCL.Forms,
  VCL.Dialogs,
  VCL.Menus,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.WinXCtrls;

type
  TfrmVCLPrincipal = class(TForm)
    mnuEstilos: TPopupMenu;
    mniEstilos: TMenuItem;
    SV_Comandos: TSplitView;
    PC_Cadastros: TPageControl;
    BT_TiposCliente: TButton;
    BT_Clientes: TButton;
    TS_Clientes: TTabSheet;
    TS_TiposCliente: TTabSheet;
    FME_TiposCliente: TMRVFrameCadastroTipoCliente;
    FME_Clientes: TMRVFrameCadastroCliente;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BT_ClientesClick(Sender: TObject);
    procedure BT_TiposClienteClick(Sender: TObject);
  private
    { campos }
    FClientClasses: IMRVRepositorioAulaMulticamada;
    FStyleManager: IVCLStyleManager;
    procedure InicializarFrames;
  public
    procedure AfterConstruction; override;
  end;

var
  frmVCLPrincipal: TfrmVCLPrincipal;

implementation

{$R *.dfm}

uses
  StrUtils,
  IniFiles,
  VCL.Themes;

procedure TfrmVCLPrincipal.FormCreate(Sender: TObject);
begin
  TS_Clientes.TabVisible := False;
  TS_TiposCliente.TabVisible := False;
  { inicializa o ClientModule }
  FClientClasses := coAulaMulticamadasClientJSON.Create;
  { carrega os estilos VCL }
  FStyleManager := coVCLStyleManager.Create(mniEstilos);
  { inicializa os frames }
  Self.InicializarFrames;
end;

procedure TfrmVCLPrincipal.FormDestroy(Sender: TObject);
begin
  FStyleManager := nil;
  FClientClasses := nil;
end;

procedure TfrmVCLPrincipal.AfterConstruction;
begin
  inherited;
  { inicializa na página de clientes }
  BT_Clientes.Click;
end;

procedure TfrmVCLPrincipal.BT_TiposClienteClick(Sender: TObject);
begin
  PC_Cadastros.ActivePage := TS_TiposCliente;
end;

procedure TfrmVCLPrincipal.BT_ClientesClick(Sender: TObject);
begin
  PC_Cadastros.ActivePage := TS_Clientes;
end;

procedure TfrmVCLPrincipal.InicializarFrames;
begin
  { inicializa }
  FME_TiposCliente.Init(FClientClasses);
  FME_Clientes.Init(FClientClasses);
end;

end.

