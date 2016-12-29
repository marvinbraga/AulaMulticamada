unit Marvin.Desktop.GUI.Item.Cliente;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  Marvin.AulaMulticamada.Classes.Cliente,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Effects, FMX.Objects;

type
  TfraItemListaCliente = class(TFrame)
    lblCliente: TLabel;
    lblTipoCliente: TLabel;
    sdw1: TShadowEffect;
    retFundo: TRectangle;
    sdw2: TShadowEffect;
    crcImagem: TCircle;
  private
    FNomeCliente: string;
    FTipoCliente: string;
    FCliente: TMRVCliente;
    procedure SetNomeCliente(const Value: string);
    procedure SetTipoCliente(const Value: string);
    procedure SetCliente(const Value: TMRVCliente);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init;
    { Public declarations }
    property NomeCliente: string read FNomeCliente write SetNomeCliente;
    property TipoCliente: string read FTipoCliente write SetTipoCliente;
    property Cliente: TMRVCliente read FCliente write SetCliente;
  end;

implementation

{$R *.fmx}

{ TfraItemListaCliente }

constructor TfraItemListaCliente.Create(AOwner: TComponent);
begin
  inherited;
  FCliente := TMRVCliente.Create;
end;

destructor TfraItemListaCliente.Destroy;
begin
  FCliente.DisposeOf;
  FCliente := nil;
  inherited;
end;

procedure TfraItemListaCliente.Init;
begin

end;

procedure TfraItemListaCliente.SetCliente(const Value: TMRVCliente);
begin
  FCliente.Assign(Value);
  Self.NomeCliente := FCliente.Nome;
  Self.TipoCliente := FCliente.TipoClienteId.ToString;
end;

procedure TfraItemListaCliente.SetNomeCliente(const Value: string);
begin
  FNomeCliente := Value;
  lblCliente.Text := FNomeCliente;
end;

procedure TfraItemListaCliente.SetTipoCliente(const Value: string);
begin
  FTipoCliente := Value;
  lblTipoCliente.Text := FTipoCliente;
end;

end.


