unit Marvin.TesteApresentacaoRetangulos.GUI.Principal;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Generics.Collections,
  Marvin.Components.Rect,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Layouts,
  FMX.Objects,
  FMX.Ani,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.MultiView,
  FMX.Effects,
  FMX.Filter.Effects;

type
  TfrmPrincipal = class(TForm)
    vsbPostagem: TFramedVertScrollBox;
    tlbBotoesPrincipal: TToolBar;
    btnMenu: TButton;
    rectToolBar: TRectangle;
    mvwMenu: TMultiView;
    rectMenu: TRectangle;
    vsbMenu: TFramedVertScrollBox;
    rectMenu1: TRectangle;
    lblMenu1: TLabel;
    rectMenu2: TRectangle;
    lblMenu2: TLabel;
    CircleUser: TCircle;
    ShadowEffect1: TShadowEffect;
    lblUser: TLabel;
    lblEmail: TLabel;
    SharpenEffect1: TSharpenEffect;
    SharpenEffect2: TSharpenEffect;
    CircleButton: TCircle;
    Layout1: TLayout;
    ShadowEffect2: TShadowEffect;
    lblAdd: TLabel;
    procedure lblAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lblMenu1Click(Sender: TObject);
    procedure vsbPostagemResize(Sender: TObject);
  private
    FOffset: TPointF;
    FListaRetangulos: TObjectList<TRectagleMessage>;
    FTag: Integer;
    { Private declarations }
    procedure ConfigScrollBox;
    procedure CriarRetangulo;
    procedure InternalOnDeleteItem(Sender: TObject);
    procedure ApargarTodosRetangulos;
  protected
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

uses
  FMX.InertialMovement;

const
  FC_POSICAO_PADRAO_X: Integer = 20;
  FC_ALTURA_PADRAO: Integer = 70;
  FC_ESPACO_PADRAO: Integer = 15;
  FC_LARGURA_DISTANCIA_PADRAO: Integer = 50;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  { inicializa o classificador }
  FTag := 1;
  { cria a lista de objetos }
  FListaRetangulos := TObjectList<TRectagleMessage>.Create(True);
  { define a altura inicial }
  FOffset.Y := FC_ESPACO_PADRAO;
  { configura o scroll box }
  Self.ConfigScrollBox;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FListaRetangulos);
end;

procedure TfrmPrincipal.ConfigScrollBox;
var
  LCalculations: TAniCalculations;
begin
  { scroll layout }
  LCalculations := TAniCalculations.Create(nil);
  try
    LCalculations.Animation := True;
    LCalculations.BoundsAnimation := True;
    //LCalculations.Averaging := True;
    LCalculations.AutoShowing := True;
    LCalculations.DecelerationRate := 0.5;
    LCalculations.Elasticity := 50;
    LCalculations.TouchTracking := [ttVertical];
    { passa as configurações para o scrollbox }
    vsbPostagem.AniCalculations.Assign(LCalculations);
  finally
    LCalculations.Free;
  end;
end;

procedure TfrmPrincipal.lblAddClick(Sender: TObject);
begin
  Self.CriarRetangulo;
end;

procedure TfrmPrincipal.CriarRetangulo;
var
  LThread: TThread;
begin
  LThread := TThread.CreateAnonymousThread(
    procedure
    var
      LRect: TRectagleMessage;
    begin
      { cria retângulo }
      LRect := TRectagleMessage.Create(vsbPostagem, erShadow);
      FListaRetangulos.Add(LRect);
      { identificação }
      LRect.Tag := FTag;
      Inc(FTag);
      { eventos }
      LRect.OnDeleteItem := InternalOnDeleteItem;
      { método para sincronização visual }
      TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          { parent }
          LRect.Parent := vsbPostagem;
          { informa a posição }
          LRect.Position.Y := FOffset.Y + 100;
          LRect.Position.X := FC_POSICAO_PADRAO_X;
          { tamanho }
          LRect.Width := vsbPostagem.Width - FC_LARGURA_DISTANCIA_PADRAO;
          LRect.Height := FC_ALTURA_PADRAO;
          { torna visível }
          LRect.Visible := True;
          { executa a animação }
          TAnimator.AnimateFloat(LRect, 'Position.Y', FOffset.Y, 1.5,
            TAnimationType.InOut, TInterpolationType.Back);
        end);
      { ajusta a próxima altura inicial }
      FOffset.Y := FOffset.Y + FC_ALTURA_PADRAO + FC_ESPACO_PADRAO;
    end);
  LThread.Start;
end;

procedure TfrmPrincipal.lblMenu1Click(Sender: TObject);
begin
  Self.ApargarTodosRetangulos;
end;

procedure TfrmPrincipal.ApargarTodosRetangulos;
begin
  { libera todos os retângulos }
  FListaRetangulos.Clear;
  { coloca na posição inicial }
  FOffset.Y := FC_ESPACO_PADRAO;
end;

procedure TfrmPrincipal.InternalOnDeleteItem(Sender: TObject);
var
  LTag: Integer;
  LRect: TRectagleMessage;
  LRemoveu: Boolean;
  LPosicao: TPointF;
  LIndex: Integer;
begin
  LIndex := 0;
  LRemoveu := False;
  { recupera o identificador }
  LTag := TControl(Sender).Tag;
  { percorre por todos }
  while LIndex < FListaRetangulos.Count do
  begin
    { recupera o retângulo }
    LRect := FListaRetangulos.Items[LIndex];
    Inc(LIndex);
    { se removeu }
    if LRemoveu then
    begin
      TAnimator.AnimateFloat(LRect, 'Position.Y', LPosicao.Y, 1,
        TAnimationType.InOut, TInterpolationType.Back);
      { atualiza a posição }
      LPosicao.Y := LRect.Position.Y;
    end;
    { procura pelo indicador }
    if LRect.Tag = LTag then
    begin
      { recupera a posição }
      LPosicao.Y := LRect.Position.Y;
      { remove }
      FListaRetangulos.Remove(LRect);
      { informa que removeu }
      LRemoveu := True;
      { ajusta o contador }
      Dec(LIndex);
    end;
  end;
  FOffset.Y := LPosicao.Y;
end;

procedure TfrmPrincipal.vsbPostagemResize(Sender: TObject);
var
  LRect: TRectagleMessage;
begin
  if Assigned(FListaRetangulos) then
  begin
    { ajusta o tamanho de todos os retângulos }
    for LRect in FListaRetangulos do
    begin
      LRect.Width := vsbPostagem.Width - FC_LARGURA_DISTANCIA_PADRAO;
    end;
  end;
end;

end.


