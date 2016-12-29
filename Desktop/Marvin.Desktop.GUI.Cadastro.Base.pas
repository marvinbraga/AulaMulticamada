unit Marvin.Desktop.GUI.Cadastro.Base;

interface

uses
  { marvin }
  Marvin.Desktop.Repositorio.AulaMulticamada,
  Marvin.Desktop.ClientClasses.AulaMulticamada,
  { embarcadero }
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Actions,
  { firemonkey }
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ListView,
  FMX.TabControl,
  FMX.ActnList,
  FMX.Controls.Presentation,
  FMX.Effects,
  FMX.Objects, FMX.Layouts;

type
  { estados do cadastro }
  TEstadoCadastro = (ecEspera, ecNovo, ecAlterar);

  TfraCadastroBase = class(TFrame)
    tbcCadastro: TTabControl;
    tbiListagem: TTabItem;
    tbiDados: TTabItem;
    lvLista: TListView;
    tlbLista: TToolBar;
    btnNovo: TSpeedButton;
    tlbDados: TToolBar;
    btnSalvar: TSpeedButton;
    btnVoltar: TSpeedButton;
    actlstAcoes: TActionList;
    ChangeTabActionListagem: TChangeTabAction;
    ChangeTabActionDetalhe: TChangeTabAction;
    ShadowEffect1: TShadowEffect;
    ShadowEffect2: TShadowEffect;
    rectInfoCadastro: TRectangle;
    lblInfoCadastro: TLabel;
    GlowEffect1: TGlowEffect;
    btnRefresh: TSpeedButton;
    lblTituloAcao: TLabel;
    btnExcluir: TSpeedButton;
    scbDados: TVertScrollBox;
    procedure lvListaItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
  private
    { repositório ClientModule }
    FClientModule: IMRVRepositorioAulaMulticamada;
    FEstadoCadastro: TEstadoCadastro;
    FTituloCadastro: string;
    FTituloAcao: string;
    procedure SetTituloCadastro(const Value: string);
    procedure SetTituloAcao(const Value: string);
    procedure SetEstadoCadastro(const Value: TEstadoCadastro);
  strict protected
    procedure DoNovoCadastro; virtual;
    procedure DoAlterarCadastro(const AItem: TListViewItem); virtual;
    procedure DoExcluir; virtual;
  protected
    procedure DoRefresh; virtual;
    procedure DoSalvar; virtual;
    procedure DoInterfaceToObject(const AItem: TListViewItem); virtual;
    procedure DoInitInterface; virtual;
    procedure DoInit; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(AClientModule: IMRVRepositorioAulaMulticamada); overload;
    { repositório ClientModule }
    property ClientModule: IMRVRepositorioAulaMulticamada read FClientModule;
    { propriedades do cadastro }
    property EstadoCadastro: TEstadoCadastro read FEstadoCadastro write SetEstadoCadastro;
    property TituloCadastro: string read FTituloCadastro write SetTituloCadastro;
    property TituloAcao: string read FTituloAcao write SetTituloAcao;
  end;

implementation

{$R *.fmx}

{ TfraCadastroBase }

procedure TfraCadastroBase.Init(AClientModule: IMRVRepositorioAulaMulticamada);
begin
  { inicializa o ClientModule }
  FClientModule := AClientModule;
  { inicializa com a tab da listagem }
  tbcCadastro.ActiveTab := tbiListagem;
  { esconde as abas }
  tbcCadastro.TabPosition := TTabPosition.None;
  { atualiza o título do cadastro }
  FTituloCadastro := lblInfoCadastro.Text;
  { continua a inicialização }
  Self.DoInit;
end;

procedure TfraCadastroBase.btnExcluirClick(Sender: TObject);
begin
  Self.DoExcluir;
end;

procedure TfraCadastroBase.btnNovoClick(Sender: TObject);
begin
  Self.DoNovoCadastro;
end;

procedure TfraCadastroBase.btnRefreshClick(Sender: TObject);
begin
  Self.DoRefresh;
end;

procedure TfraCadastroBase.btnSalvarClick(Sender: TObject);
begin
  Self.DoSalvar;
end;

constructor TfraCadastroBase.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TfraCadastroBase.lvListaItemClick(const Sender: TObject; const AItem:
  TListViewItem);
begin
  Self.DoAlterarCadastro(AItem);
end;

procedure TfraCadastroBase.SetEstadoCadastro(const Value: TEstadoCadastro);
begin
  FEstadoCadastro := Value;
  case FEstadoCadastro of
    ecNovo:
      begin
        Self.TituloAcao := 'Novo';
        btnExcluir.Enabled := False;
      end;
    ecAlterar:
      begin
        Self.TituloAcao := 'Alteração';
        btnExcluir.Enabled := True;
      end;
  end;
end;

procedure TfraCadastroBase.SetTituloAcao(const Value: string);
begin
  FTituloAcao := Value;
  lblTituloAcao.Text := Format('[%S]', [FTituloAcao]);
end;

procedure TfraCadastroBase.SetTituloCadastro(const Value: string);
begin
  FTituloCadastro := Value;
  lblInfoCadastro.Text := FTituloCadastro;
end;

procedure TfraCadastroBase.DoNovoCadastro;
begin
  { muda para a aba de detalhe }
  ChangeTabActionDetalhe.ExecuteTarget(lvLista);
  { passa o estado para alteração }
  Self.EstadoCadastro := ecNovo;
  { inicializa a tela de detalhe }
  Self.DoInitInterface;
end;

destructor TfraCadastroBase.Destroy;
begin
  FClientModule := nil;
  inherited;
end;

procedure TfraCadastroBase.DoAlterarCadastro(const AItem: TListViewItem);
begin
  { muda para a aba de detalhe }
  ChangeTabActionDetalhe.ExecuteTarget(lvLista);
  { passa o estado para alteração }
  Self.EstadoCadastro := ecAlterar;
  { recupera os dados do item seleciondado }
  Self.DoInterfaceToObject(AItem);
end;

procedure TfraCadastroBase.DoExcluir;
begin
  { excluir item }
end;

procedure TfraCadastroBase.DoRefresh;
begin
  { implementar a recuperação de dados para o listview }
end;

procedure TfraCadastroBase.DoInit;
begin
  { após a inicialização }
end;

procedure TfraCadastroBase.DoInitInterface;
begin
  { implementar a limpesa de controles da interface }
end;

procedure TfraCadastroBase.DoInterfaceToObject(const AItem: TListViewItem);
begin
  { implementar a recuperação de dados da lista para o objeto e a interface }
end;

procedure TfraCadastroBase.DoSalvar;
begin
  { implementar o método para salvar }
end;

end.


