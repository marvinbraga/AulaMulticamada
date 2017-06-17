unit Marvin.Desktop.GUI.Lista.Clientes;

interface

uses
  { embarcadero }
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Generics.Collections,
  { marvin }
  Marvin.Components.Rect,
  Marvin.Desktop.Repositorio.AulaMulticamada,
  Marvin.AulaMulticamada.Classes.Cliente,
  Marvin.AulaMulticamada.Listas.Cliente,
  { firemonkey }
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Controls.Presentation;

type
  TMRVEstadoControle = (ecNone, ecConsulta, ecExclusao);
  TfraListaClientes = class(TFrame)
    scbListaClientes: TVertScrollBox;
    tlbBotoes: TToolBar;
    btnRefresh: TSpeedButton;
    procedure scbListaClientesResize(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    FOffset: TPointF;
    FListaClientes: TMRVListaCliente;
    FListaRetangulos: TObjectList<TRectangleMessage>;
    FTag: Integer;
    FEstadoControle: TMRVEstadoControle;
    FClientModule: IMRVRepositorioAulaMulticamada;
    { métodos }
    procedure ConfigScrollBox;
    procedure CriarRetangulo(const ACliente: TMRVCliente);
    procedure InternalOnDeleteItem(Sender: TObject);
    procedure ApargarTodosRetangulos;
    procedure CarregarListaClientes;
    procedure ExibirListaClientes;
    procedure DoRemoverCliente(const ARect: TRectangleMessage);
    procedure DoRefreshListaClientes;
    procedure DoCriarFrameItemCliente(const ARect: TRectangleMessage;
      const ACliente: TMRVCliente);
  protected
    procedure DoInit; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(AClientModule: IMRVRepositorioAulaMulticamada);
    property ClientModule: IMRVRepositorioAulaMulticamada read FClientModule;
  end;

implementation

{$R *.fmx}

uses
  FMX.Ani,
  FMX.InertialMovement,
  Marvin.Desktop.GUI.Item.Cliente;

const
  FC_POSICAO_PADRAO_X: Integer = 20;
  FC_ALTURA_PADRAO: Integer = 70;
  FC_ESPACO_PADRAO: Integer = 15;
  FC_LARGURA_DISTANCIA_PADRAO: Integer = 50;

{ TFrame1 }

procedure TfraListaClientes.ApargarTodosRetangulos;
var
  LRect: TRectangleMessage;
begin
  { libera todos os retângulos }
  while not(FListaRetangulos.Count = 0) do
  begin
    LRect := FListaRetangulos.Items[0];
    LRect.Remover;
  end;
  { coloca na posição inicial }
  FOffset.Y := FC_ESPACO_PADRAO;
end;

procedure TfraListaClientes.btnRefreshClick(Sender: TObject);
begin
  { executa o método para carregar os dados dos clientes }
  Self.DoRefreshListaClientes;
end;

procedure TfraListaClientes.CarregarListaClientes;
var
  LCliente: TMRVCliente;
begin
  if Assigned(FListaClientes) then
  begin
    FreeAndNil(FListaClientes);
  end;
  LCliente := TMRVCliente.Create;
  try
    { carrega a lista de clientes }
    FListaClientes := FClientModule.ClientesProcurarItens(LCliente) as TMRVListaCliente;
  finally
    LCliente.DisposeOf;
  end;
end;

procedure TfraListaClientes.ConfigScrollBox;
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
    scbListaClientes.AniCalculations.Assign(LCalculations);
  finally
    LCalculations.DisposeOf;
  end;
end;

constructor TfraListaClientes.Create(AOwner: TComponent);
begin
  inherited;
  { inicializa o classificador }
  FTag := 1;
  { cria a lista de objetos }
  FListaRetangulos := TObjectList<TRectangleMessage>.Create(True);
  FListaClientes := TMRVListaCliente.Create;
  { define a altura inicial }
  FOffset.Y := FC_ESPACO_PADRAO;
  { configura o scroll box }
  Self.ConfigScrollBox;
end;

procedure TfraListaClientes.CriarRetangulo(const ACliente: TMRVCliente);
var
  LRect: TRectangleMessage;
begin
  { cria retângulo }
  LRect := TRectangleMessage.Create(scbListaClientes, erShadow);
  FListaRetangulos.Add(LRect);
  { identificação }
  LRect.Tag := FTag;
  Inc(FTag);
  { eventos }
  LRect.OnDeleteItem := InternalOnDeleteItem;
  { parent }
  LRect.Parent := scbListaClientes;
  { informa a posição }
  LRect.Position.Y := FOffset.Y + 100;
  LRect.Position.X := FC_POSICAO_PADRAO_X;
  { tamanho }
  LRect.Width := scbListaClientes.Width - FC_LARGURA_DISTANCIA_PADRAO;
  LRect.Height := FC_ALTURA_PADRAO;
  { cria o frame que irá conter as informações do cliente }
  Self.DoCriarFrameItemCliente(LRect, ACliente);
  { torna visível }
  LRect.Visible := True;
  { executa a animação }
  TAnimator.AnimateFloat(LRect, 'Position.Y', FOffset.Y, 1.5, TAnimationType.InOut,
    TInterpolationType.Back);
  { ajusta a próxima altura inicial }
  FOffset.Y := FOffset.Y + LRect.Height + FC_ESPACO_PADRAO;
end;

destructor TfraListaClientes.Destroy;
begin
  FreeAndNil(FListaClientes);
  FreeAndNil(FListaRetangulos);
  inherited;
end;

procedure TfraListaClientes.DoInit;
begin
  inherited;
  FEstadoControle := ecNone;
  Self.DoRefreshListaClientes;
end;

procedure TfraListaClientes.DoRefreshListaClientes;
begin
  Self.CarregarListaClientes;
  Self.ExibirListaClientes;
end;

procedure TfraListaClientes.DoRemoverCliente(const ARect: TRectangleMessage);
var
  LFrame: TfraItemListaCliente;
  LCliente: TMRVCliente;
  LIndex: Integer;
  LObjeto: TFmxObject;
begin
  if FEstadoControle = ecConsulta then
  begin
    { sai se estiver limpando para consulta }
    Exit;
  end;

  LFrame := nil;
  for LIndex := 0 to ARect.ChildrenCount - 1 do
  begin
    { recupera os objetos }
    LObjeto := ARect.Children.Items[LIndex];
    { verificase é o frame }
    if LObjeto is TfraItemListaCliente then
    begin
     { recupera o frame }
      LFrame := LObjeto as TfraItemListaCliente;
      Break;
    end;
  end;
  { se recuperou o frame }
  if Assigned(LFrame) then
  begin
    { recupera o cliente }
    LCliente := TMRVCliente.Create;
    try
      LCliente.Assign(LFrame.Cliente);
      Self.ClientModule.ClientesExcluir(LCliente);
    finally
      LCliente.DisposeOf;
    end;
  end;
end;

procedure TfraListaClientes.ExibirListaClientes;
var
  LIndex: Integer;
  LCliente: TMRVCliente;
begin
  { limpa os retângulos }
  FEstadoControle := ecConsulta;
  Self.ApargarTodosRetangulos;
  FEstadoControle := ecNone;
  { percorre a lista de clientes }
  for LIndex := 0 to FListaClientes.Count - 1 do
  begin
    { recupera o cliente }
    FListaClientes.ProcurarPorIndice(LIndex, LCliente);
    { cria o retângulo }
    Self.CriarRetangulo(LCliente);
  end;
end;

procedure TfraListaClientes.Init(AClientModule: IMRVRepositorioAulaMulticamada);
begin
  FClientModule := AClientModule;
  Self.DoInit;
end;

procedure TfraListaClientes.DoCriarFrameItemCliente(const ARect: TRectangleMessage;
  const ACliente: TMRVCliente);
var
  LFrameCliente: TfraItemListaCliente;
begin
  { cria o frame de cliente }
  LFrameCliente := TfraItemListaCliente.Create(ARect);
  LFrameCliente.Parent := ARect;
  ARect.Height := LFrameCliente.Height;
  { informa a cor do retângulo interno }
  LFrameCliente.retFundo.Fill.Color := ARect.Fill.Color;
  ARect.AddObject(LFrameCliente);
  LFrameCliente.Align := TAlignLayout.Client;
  { passa os dados }
  LFrameCliente.Cliente := ACliente;
end;

procedure TfraListaClientes.InternalOnDeleteItem(Sender: TObject);
var
  LTag: Integer;
  LRect: TRectangleMessage;
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
      { manda excluir o registro do cliente no BD }
      Self.DoRemoverCliente(LRect);
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

procedure TfraListaClientes.scbListaClientesResize(Sender: TObject);
var
  LRect: TRectangleMessage;
begin
  if Assigned(FListaRetangulos) then
  begin
    { ajusta o tamanho de todos os retângulos }
    for LRect in FListaRetangulos do
    begin
      LRect.Width := scbListaClientes.Width - FC_LARGURA_DISTANCIA_PADRAO;
    end;
  end;
end;

end.


