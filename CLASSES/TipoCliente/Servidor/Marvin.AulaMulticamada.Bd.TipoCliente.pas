{  Arquivo criado automaticamente Gerador Multicamadas
   (Multitiers Generator VERSÃO 0.01)
   Data e Hora: 11/10/2016 - 23:02:06
}

unit Marvin.AulaMulticamada.Bd.TipoCliente;

interface

uses
  Classes,
   { marvin }
  uMRVClasses,
  uMRVPersistenciaBase,
  uMRVClassesServidor,
  uMRVDAO,
  Marvin.AulaMulticamada.Classes.TipoCliente,
  Marvin.AulaMulticamada.Repositorio.TipoCliente;

type
  CoMRVBdTipoCliente = class(TObject)
  public
    class function Create(const ADataBase: IMRVDatabase): IMRVRepositorioTipoCliente;
  end;

implementation

uses
  SysUtils,
  uMRVConsts,
  Marvin.AulaMulticamada.Excecoes.TipoCliente;

type
  TMRVBdTipoCliente = class(TMRVPersistenciaBase, IMRVRepositorioTipoCliente)
  private
    FCommandNextId: string;
  protected
    procedure DoAlterar(const AItem: TMRVDadosBase); override;
    procedure DoExcluir(const AItem: TMRVDadosBase); override;
    procedure DoInserir(const AItem: TMRVDadosBase); override;
    function DoProcurarItem(const ACriterio: TMRVDadosBase; const AResultado:
      TMRVDadosBase = nil): Boolean; override;
    function DoProcurarItems(const ACriterio: TMRVDadosBase; const
      AListaResultado: TMRVListaBase; const ASearchOption: TMRVSearchOption):
      Boolean; override;
    procedure MontarStringsDeComando; override;
    procedure RecordsetToObjeto(const RS: IMRVQuery; const Objeto: TMRVDadosBase);
      override;
      { id }
    function GetNextId: Integer;
    property CommandNextId: string read FCommandNextId write FCommandNextId;
  end;

{ CoMRVBdTipoCliente }

class function CoMRVBdTipoCliente.Create(const ADataBase: IMRVDatabase):
  IMRVRepositorioTipoCliente;
begin
  Result := TMRVBdTipoCliente.Create(ADataBase);
end;

{ TMRVBdTipoCliente }

procedure TMRVBdTipoCliente.DoAlterar(const AItem: TMRVDadosBase);
var
  LTipoCliente: TMRVTipoCliente;
begin
  Assert(AItem <> nil, 'O parâmetro AItem não pode ser nil.');
   { Realiza um único typecast seguro inicial, para ser usado por todo o método }
  LTipoCliente := AItem as TMRVTipoCliente;
   { Informa qual o comando SQL a ser usado }
  Query.SetSQL(CommandUpdate);
   { Informa os parâmetros }
  Query.ParamByName('PAR_TipoClienteId').AsInteger := LTipoCliente.TipoClienteId;
  Query.ParamByName('PAR_Descricao').AsString := LTipoCliente.Descricao;
   { Executa o comando SQL }
  Query.ExecSQL;
end;

procedure TMRVBdTipoCliente.DoExcluir(const AItem: TMRVDadosBase);
var
  LTipoCliente: TMRVTipoCliente;
begin
  Assert(AItem <> nil, 'O parâmetro AItem não pode ser nil.');
   { Realiza um único typecast seguro inicial, para ser usado por todo o método }
  LTipoCliente := AItem as TMRVTipoCliente;
   { Informa qual o comando SQL a ser usado }
  Query.SetSQL(CommandDelete);
   { Informa os parâmetros }
  Query.ParamByName('PAR_TipoClienteId').AsInteger := LTipoCliente.TipoClienteId;
   { Executa o comando SQL }
  Query.ExecSQL;
end;

procedure TMRVBdTipoCliente.DoInserir(const AItem: TMRVDadosBase);
var
  LTipoCliente: TMRVTipoCliente;
begin
  Assert(AItem <> nil, 'Parâmetro AItem não pode ser nil.');
  LTipoCliente := AItem as TMRVTipoCliente;
   { Informa qual o comando SQL a ser usado }
  Query.SetSQL(CommandInsert);
   { Informa os parâmetros }
  Query.ParamByName('PAR_TipoClienteId').AsInteger := LTipoCliente.TipoClienteId;
  Query.ParamByName('PAR_Descricao').AsString := LTipoCliente.Descricao;
   { Executa o comando SQL }
  Query.ExecSQL;
end;

function TMRVBdTipoCliente.DoProcurarItem(const ACriterio: TMRVDadosBase; const
  AResultado: TMRVDadosBase = nil): Boolean;
var
  LTipoCliente: TMRVTipoCliente;
begin
  Assert(ACriterio <> nil, 'O parâmetro ACriterio não pode ser nil.');
   { Realiza um único typecast seguro inicial, para ser usado por todo o método }
  LTipoCliente := ACriterio as TMRVTipoCliente;
   { Informa qual o comando SQL a ser usado }
  Query.SetSQL(CommandSelectItem);
   { Informa os parâmetros }
  Query.ParamByName('PAR_TipoClienteId').AsInteger := LTipoCliente.TipoClienteId;
   { Abre a consulta }
  Query.Open;
  Result := not Query.IsEmpty;
  if Result and Assigned(AResultado) then
  begin
    Self.RecordsetToObjeto(Query, AResultado);
  end;
end;

function TMRVBdTipoCliente.DoProcurarItems(const ACriterio: TMRVDadosBase; const
  AListaResultado: TMRVListaBase; const ASearchOption: TMRVSearchOption): Boolean;
var
  LTipoCliente: TMRVTipoCliente;
  LCondicao: string;
begin
  Assert(ACriterio <> nil, 'O parâmetro ACriterio não pode ser nil.');
  Assert(AListaResultado <> nil, 'O parâmetro AListaResultado não pode ser nil.');
   { Informa qual o comando SQL a ser usado }
  Assert(ASearchOption <> nil, 'O parâmetro ASearchOption não pode ser nil.');

   { realiza o typecast}
  LTipoCliente := ACriterio as TMRVTipoCliente;
   { Inicializa a variável de condição }
  LCondicao := EmptyStr;

   { Montagem das condições de pesquisa }
  if (LTipoCliente.Descricao <> EmptyStr) then
  begin
    if ASearchOption.ExistPropertyName('Descricao') then
    begin
      LCondicao := LCondicao + TMRVSQLDefs.AddCondition('Descricao', 'PAR_Descricao');
    end;
  end;

   { Informa a SQL a ser executada }
  Query.SetSQL(TMRVSQLDefs.AddWhere(CommandSelectItems, LCondicao));

   { realiza a passagem de parâmetros }
  if (LTipoCliente.Descricao <> EmptyStr) then
  begin
    if ASearchOption.ExistPropertyName('Descricao') then
    begin
      Query.ParamByName('PAR_Descricao').AsString := LTipoCliente.Descricao;
    end;
  end;

   { Abre a consulta }
  Query.Open;
   { Verifica o resultado }
  Result := not Query.IsEmpty;
   { Se existirem registros }
  if Result then
  begin
      { Preenche os atributos do objeto com os valores dos campos do registro }
    RecordsetToLista(Query, AListaResultado, TMRVTipoCliente);
  end;
end;

function TMRVBdTipoCliente.GetNextId: Integer;
begin
  { Informa qual o comando SQL a ser usado }
  Query.SetSQL(CommandNextId);
  { informa id inicial }
  Result := 1;
  { Abre a consulta }
  Query.Open;
  if not Query.IsEmpty then
  begin
    Result := Query.FieldByName('TipoClienteId').AsInteger + 1;
  end;
end;

procedure TMRVBdTipoCliente.MontarStringsDeComando;
begin
  CommandNextId :=
    'select top 1 TipoClienteId from TipoCliente order by TipoClienteId desc';

  CommandInsert := 'INSERT INTO TipoCliente (TipoClienteId, ' +
    'Descricao) VALUES (:PAR_TipoClienteId, ' + ':PAR_Descricao)';

  CommandUpdate :=
    'UPDATE TipoCliente SET Descricao = :PAR_Descricao WHERE TipoClienteId = :PAR_TipoClienteId';

  CommandDelete := 'DELETE FROM TipoCliente WHERE TipoClienteId = :PAR_TipoClienteId';

  CommandSelectItem := 'SELECT TipoClienteId, ' +
    'Descricao FROM TipoCliente WHERE TipoClienteId = :PAR_TipoClienteId';

  CommandSelectItems := 'SELECT TipoClienteId, ' + 'Descricao FROM TipoCliente';
end;

procedure TMRVBdTipoCliente.RecordsetToObjeto(const RS: IMRVQuery; const Objeto:
  TMRVDadosBase);
var
  LObjeto: TMRVTipoCliente;
begin
  Assert(RS <> nil, 'O parâmetro RS não pode ser nil.');
  Assert(Objeto <> nil, 'O parâmetro Objeto não pode ser nil.');
   { recupera os dados da propriedade FADORecordset }
  LObjeto := Objeto as TMRVTipoCliente;
   { recupera os dados do banco para o objeto }
  LObjeto.TipoClienteId := RS.FieldByName('TipoClienteId').AsInteger;
  LObjeto.Descricao := RS.FieldByName('Descricao').AsString;
end;

end.


