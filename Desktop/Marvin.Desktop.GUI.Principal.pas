unit Marvin.Desktop.GUI.Principal;

interface

uses
  { embarcadero }
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Actions,
  { firemonkey }
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.MultiView,
  FMX.StdCtrls,
  FMX.TabControl,
  FMX.ActnList,
  FMX.Edit,
  FMX.Effects,
  FMX.Objects,
  FMX.Layouts,
  { frames }
  Marvin.Desktop.GUI.Lista.Clientes,
  Marvin.Desktop.GUI.Cadastro.Base,
  Marvin.Desktop.GUI.Cadastro.TipoCliente,
  Marvin.Desktop.GUI.Cadastro.Cliente,
  { interface }
  Marvin.Desktop.Repositorio.AulaMulticamada,
  { client module }
  Marvin.Desktop.ClientClasses.AulaMulticamada;

type
  TfrmPrincipal = class(TForm)
    MultiViewMenu: TMultiView;
    btnMain: TSpeedButton;
    btnPreferencias: TSpeedButton;
    btnCadastroTiposCliente: TSpeedButton;
    btnCadstroClientes: TSpeedButton;
    btnListaClientes: TSpeedButton;
    btnEscolherEstilo: TCornerButton;
    tbcPrincipal: TTabControl;
    tbiListaClientes: TTabItem;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    actlstFuncoes: TActionList;
    ChangeTabAction1: TChangeTabAction;
    ChangeTabAction2: TChangeTabAction;
    ChangeTabAction3: TChangeTabAction;
    ChangeTabAction4: TChangeTabAction;
    dlgOpenStyle: TOpenDialog;
    fraCadastroTipoClienteObj: TfraCadastroTipoCliente;
    fraListaClientesObj: TfraListaClientes;
    stbStyle: TStyleBook;
    fraCadastroClientesObj: TfraCadastroClientes;
    procedure btnEscolherEstiloClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { campos }
    FClientClasses: IMRVRepositorioAulaMulticamada;
    procedure InicializarFrames;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

uses
  FMX.Styles;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  { inicializa o ClientModule }
  FClientClasses := coAulaMulticamadasClientJSON.Create;
  { página inicial }
  tbcPrincipal.ActiveTab := tbiListaClientes;
  { inicializa os frames }
  Self.InicializarFrames;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  { aterra o ClientModule }
  FClientClasses := nil;
end;

procedure TfrmPrincipal.InicializarFrames;
begin
  { inicializa }
  fraListaClientesObj.Init(FClientClasses);
  fraCadastroTipoClienteObj.Init(FClientClasses);
  fraCadastroClientesObj.Init(FClientClasses);
end;

procedure TfrmPrincipal.FormActivate(Sender: TObject);
begin
  { recupera as margens }
  tbcPrincipal.Margins.Left := MultiViewMenu.Width;
end;

procedure TfrmPrincipal.btnEscolherEstiloClick(Sender: TObject);
begin
  if dlgOpenStyle.Execute then
  begin
    { libera o estilo padrão inicial }
    Self.StyleBook := nil;
    { carrega o estilo selecionado }
    TStyleManager.SetStyle(TStyleStreaming.LoadFromFile(dlgOpenStyle.FileName));
  end;
end;

end.


