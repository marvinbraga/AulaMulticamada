unit Marvin.VCL.GUI.Cadastro.Base;

interface

uses
  { interface comunicação }
  Marvin.Desktop.Repositorio.AulaMulticamada,
  { client module }
  Marvin.Desktop.ClientClasses.AulaMulticamada,
  { embarcadero }
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Actions,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.ToolWin,
  Vcl.Buttons,
  Vcl.StdCtrls,
  Vcl.WinXCtrls,
  Vcl.ActnList,
  Vcl.ExtActns,
  Vcl.StdActns,
  Vcl.ExtCtrls;

type
  { estados do cadastro }
  TEstadoCadastro = (ecEspera, ecNovo, ecAlterar);

  TMRVFrameCadastroBase = class(TFrame)
    PC_Dados: TPageControl;
    TS_Lista: TTabSheet;
    TS_Cadastro: TTabSheet;
    TB_BarraBotoes: TToolBar;
    BT_AtualizarLista: TSpeedButton;
    BT_Novo: TSpeedButton;
    SB_Pesquisa: TSearchBox;
    LV_Lista: TListView;
    AL_Acoes: TActionList;
    AT_Lista: TPreviousTab;
    AT_Cadastro: TNextTab;
    PN_Titulo: TPanel;
    TB_Cadastro: TToolBar;
    BT_Voltar: TSpeedButton;
    BT_Excluir: TSpeedButton;
    BT_Salvar: TSpeedButton;
    PN_Cadastro: TPanel;
    PN_EstadoCadastro: TPanel;
    procedure BT_NovoClick(Sender: TObject);
    procedure BT_AtualizarListaClick(Sender: TObject);
    procedure BT_ExcluirClick(Sender: TObject);
    procedure BT_SalvarClick(Sender: TObject);
    procedure LV_ListaDblClick(Sender: TObject);
  private
    FTituloAcao: string;
    FClientClasses: IMRVRepositorioAulaMulticamada;
    FEstadoCadastro: TEstadoCadastro;
    FTituloCadastro: string;
    procedure SetEstadoCadastro(const Value: TEstadoCadastro);
    procedure SetTituloAcao(const Value: string);
    procedure SetTituloCadastro(const Value: string);
  strict protected
    procedure DoNovoCadastro; virtual;
    procedure DoAlterarCadastro(const AItem: TListItem); virtual;
    procedure DoExcluir; virtual;
  protected
    procedure DoRefresh; virtual;
    procedure DoSalvar; virtual;
    procedure DoInterfaceToObject(const AItem: TListItem); virtual;
    procedure DoInitInterface; virtual;
    procedure DoInit; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(AClientClasses: IMRVRepositorioAulaMulticamada); overload;
    procedure ShowMessageBox(AMessage: string);
    { repositório ClientModule }
    property ClientClasses: IMRVRepositorioAulaMulticamada read FClientClasses;
    { propriedades do cadastro }
    property EstadoCadastro: TEstadoCadastro read FEstadoCadastro write SetEstadoCadastro;
    property TituloCadastro: string read FTituloCadastro write SetTituloCadastro;
    property TituloAcao: string read FTituloAcao write SetTituloAcao;
  end;

implementation

{$R *.dfm}

{ TMRVFrameCadastroBase }

procedure TMRVFrameCadastroBase.BT_AtualizarListaClick(Sender: TObject);
begin
  Self.DoRefresh;
end;

procedure TMRVFrameCadastroBase.BT_ExcluirClick(Sender: TObject);
begin
  Self.DoExcluir;
end;

procedure TMRVFrameCadastroBase.BT_NovoClick(Sender: TObject);
begin
  Self.DoNovoCadastro;
end;

procedure TMRVFrameCadastroBase.BT_SalvarClick(Sender: TObject);
begin
  Self.DoSalvar;
end;

constructor TMRVFrameCadastroBase.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TMRVFrameCadastroBase.Destroy;
begin
  FClientClasses := nil;
  inherited;
end;

procedure TMRVFrameCadastroBase.DoAlterarCadastro(const AItem: TListItem);
begin
  { muda para a aba de detalhe }
  AT_Cadastro.ExecuteTarget(TS_Cadastro);
  { passa o estado para alteração }
  Self.EstadoCadastro := ecAlterar;
  { recupera os dados do item seleciondado }
  Self.DoInterfaceToObject(AItem);
end;

procedure TMRVFrameCadastroBase.DoExcluir;
begin
  { excluir item }
end;

procedure TMRVFrameCadastroBase.DoInit;
begin
  { após a inicialização }
end;

procedure TMRVFrameCadastroBase.DoInitInterface;
begin
  { implementar a limpesa de controles da interface }
end;

procedure TMRVFrameCadastroBase.DoInterfaceToObject(const AItem: TListItem);
begin
  { implementar a recuperação de dados da lista para o objeto e a interface }
end;

procedure TMRVFrameCadastroBase.DoNovoCadastro;
begin
  { muda para a aba de detalhe }
  AT_Cadastro.ExecuteTarget(TS_Cadastro);
  { passa o estado para alteração }
  Self.EstadoCadastro := ecNovo;
  { inicializa a tela de detalhe }
  Self.DoInitInterface;
end;

procedure TMRVFrameCadastroBase.DoRefresh;
begin
  { implementar a recuperação de dados para o listview }
end;

procedure TMRVFrameCadastroBase.DoSalvar;
begin
  { implementar o método para salvar }
end;

procedure TMRVFrameCadastroBase.Init(AClientClasses: IMRVRepositorioAulaMulticamada);
begin
  { inicializa o ClientModule }
  FClientClasses := AClientClasses;
  { inicializa com a tab da listagem }
  PC_Dados.ActivePage := TS_Lista;
  { esconde as abas }
  TS_Lista.TabVisible := False;
  TS_Cadastro.TabVisible := False;
  { inicializa com a tab da listagem }
  PC_Dados.ActivePage := TS_Lista;
  { atualiza o título do cadastro }
  FTituloCadastro := PN_Titulo.Caption;
  { continua a inicialização }
  Self.DoInit;
end;

procedure TMRVFrameCadastroBase.LV_ListaDblClick(Sender: TObject);
var
  LItem: TListItem;
begin
  LItem := LV_Lista.Selected;
  if Assigned(LItem) then
  begin
    Self.DoAlterarCadastro(LItem);
  end;
end;

procedure TMRVFrameCadastroBase.SetEstadoCadastro(const Value: TEstadoCadastro);
begin
  FEstadoCadastro := Value;
  case FEstadoCadastro of
    ecNovo:
      begin
        Self.TituloAcao := 'Novo';
        BT_Excluir.Enabled := False;
      end;
    ecAlterar:
      begin
        Self.TituloAcao := 'Alteração';
        BT_Excluir.Enabled := True;
      end;
  end;
end;

procedure TMRVFrameCadastroBase.SetTituloAcao(const Value: string);
begin
  FTituloAcao := Value;
  PN_EstadoCadastro.Caption := Format('[%S]', [FTituloAcao]);
end;

procedure TMRVFrameCadastroBase.SetTituloCadastro(const Value: string);
begin
  FTituloCadastro := Value;
  PN_Titulo.Caption := FTituloCadastro;
end;

procedure TMRVFrameCadastroBase.ShowMessageBox(AMessage: string);
begin
  ShowMessage(AMessage);
end;

end.

