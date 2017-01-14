unit Marvin.Components.Rect;

interface

uses
  System.Types,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Ani,
  FMX.Effects,
  FMX.Filter.Effects;

type
  TEffectRectangle = (erShadow, erPaper);

  TRectagleMessage = class(TRectangle)
  private
    FEstaMovendo: Boolean;
    FOffset: TPointF;
    FOnDeleteItem: TNotifyEvent;
  strict protected
    procedure AdicionarEfeitoSombra;
    procedure AdicionarEfeitoPapel;
  protected
    procedure AdicionarComponente(AClassName: TComponentClass);
    procedure InternalOnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure InternalOnMouseUp(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Single);
    procedure InternalOnMouseDown(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Single);
    procedure InternalOnDblClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; AEffect: TEffectRectangle);
      reintroduce; overload; virtual;
    procedure Remover;
  published
    property EstaMovendo: Boolean read FEstaMovendo write FEstaMovendo;
    property Offset: TPointF read FOffset write FOffset;
    { evento para exclusão do item }
    property OnDeleteItem: TNotifyEvent read FOnDeleteItem write FOnDeleteItem;
  end;

implementation

uses
  System.SysUtils;

const
  FC_POSICAO_PADRAO_X: Integer = 20;
  FC_POSICAO_LIBERAR: Double = 0.35;

{ TRectagleMessage }

constructor TRectagleMessage.Create(AOwner: TComponent; AEffect: TEffectRectangle);
begin
  inherited Create(AOwner);
  FEstaMovendo := False;
  { cor }
  Self.Stroke.Color := TAlphaColors.Null;
  Self.Fill.Color := TAlphaColor((Random(MaxInt) or TAlphaColors.Alpha));
  { âncora }
  Self.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop];
  { bordas }
  Self.XRadius := 7;
  Self.YRadius := 7;
  { transparência }
  Self.Opacity := 1;
  { informa os eventos }
  Self.OnMouseMove := InternalOnMouseMove;
  Self.OnMouseUp := InternalOnMouseUp;
  Self.OnMouseDown := InternalOnMouseDown;
  Self.OnDblClick := InternalOnDblClick;
  { cria efeito informado }
  case AEffect of
    erShadow:
      Self.AdicionarEfeitoSombra;
    erPaper:
      Self.AdicionarEfeitoPapel;
  end;
end;

procedure TRectagleMessage.AdicionarComponente(AClassName: TComponentClass);
var
  LObjeto: TComponent;
begin
  LObjeto := AClassName.Create(Self);
  { associa ao objeto }
  TControl(LObjeto).Parent := Self;
  Self.AddObject(TFmxObject(LObjeto));
end;

procedure TRectagleMessage.AdicionarEfeitoPapel;
begin
  { cria o efeito de papel }
  Self.AdicionarComponente(TPaperSketchEffect);
end;

procedure TRectagleMessage.AdicionarEfeitoSombra;
begin
  { cria sombra }
  Self.AdicionarComponente(TShadowEffect);
end;

procedure TRectagleMessage.Remover;
begin
  { executa a animação de saída }
  TAnimator.AnimateFloat(Self, 'Opacity', 0, 1.5, TAnimationType.InOut,
    TInterpolationType.Circular);
  { chama o evento para exclusão da lista }
  if Assigned(FOnDeleteItem) then
  begin
    FOnDeleteItem(Self);
  end;
end;

procedure TRectagleMessage.InternalOnMouseDown(Sender: TObject; Button:
  TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  { informa que vai mover o retângulo }
  FEstaMovendo := True;
  { marca a posição onde clicou com o mouse }
  FOffset.Y := Y;
  FOffset.X := X;
end;

procedure TRectagleMessage.InternalOnMouseMove(Sender: TObject; Shift:
  TShiftState; X, Y: Single);
const
  LC_INICIO_OPACIDADE: Double = 0.70;
var
  LNovaPosicao: Single;
  LMetade: Double;
begin
  { se está movimentando com o botão esquerdo do mouse }
  if ((FEstaMovendo) and (ssLeft in Shift)) then
  begin
    { recupera a nova posição }
    LNovaPosicao := Self.Position.X + (X - FOffset.X);
    { se a nova posição do retângulo for maior do que o tamanho reservado }
    if LNovaPosicao > (TControl(Self.Parent).Width - 1) then
    begin
      { devolve o valor do limite }
      LNovaPosicao := (TControl(Self.Parent).Width - 1);
    end
    { se a nova posição do retângulo for menor do que o tamanho reservado }
    else if LNovaPosicao < (TControl(Self.Parent).Position.X + 1) then
    begin
      { devolve o valor do limite }
      LNovaPosicao := (TControl(Self.Parent).Position.X + 1);
    end;

    { ajusta a opacidade }
    if LNovaPosicao > (TControl(Self.Parent).Width - (TControl(Self.Parent).Width
      * LC_INICIO_OPACIDADE)) then
    begin
      LMetade := (TControl(Self.Parent).Width - (TControl(Self.Parent).Width
        * LC_INICIO_OPACIDADE));
      Self.Opacity := (LMetade / LNovaPosicao) - 0.40;
    end;

    { informa a nova posição }
    Self.Position.X := LNovaPosicao;
  end;
end;

procedure TRectagleMessage.InternalOnMouseUp(Sender: TObject; Button:
  TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  FEstaMovendo := False;
  { se soltar o retângulo em uma posição perto do limite do tamanho }
  if (Self.Position.X > (TControl(Self.Parent).Width - (TControl(Self.Parent).Width
    * FC_POSICAO_LIBERAR))) then
  begin
    { manda para fora do tamanho do controle parent }
    TAnimator.AnimateFloat(Self, 'Position.X', TControl(Self.Parent).Width
      + 250, 0.75);
    { remove da lista }
    Self.Remover;
  end
  else
  begin
    { retorna para a posição inicial }
    TAnimator.AnimateFloat(Self, 'Position.X', TControl(Self.Parent).Position.X
      + FC_POSICAO_PADRAO_X, 0.25);
    Self.Opacity := 1;
  end;
end;

procedure TRectagleMessage.InternalOnDblClick(Sender: TObject);
begin
  Self.Remover;
end;

end.


