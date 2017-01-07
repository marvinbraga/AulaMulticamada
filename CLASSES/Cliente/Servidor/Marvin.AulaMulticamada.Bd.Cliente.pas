{  Arquivo criado automaticamente Gerador Multicamadas
   (Multitiers Generator VERSÃO 0.01)
   Data e Hora: 11/10/2016 - 23:04:17
}

unit Marvin.AulaMulticamada.Bd.Cliente;

interface

uses
  Classes,
   { marvin }
  uMRVClasses,
  uMRVPersistenciaBase,
  uMRVClassesServidor,
  uMRVDAO,
  Marvin.AulaMulticamada.Classes.Cliente,
  Marvin.AulaMulticamada.Repositorio.Cliente;

type
  CoMRVBdCliente = class(TObject)
  public
    class function Create(const ADataBase: IMRVDatabase): IMRVRepositorioCliente;
  end;

implementation

uses
  SysUtils,
  uMRVConsts,
  Marvin.AulaMulticamada.Excecoes.Cliente;

type
  TMRVBdCliente = class(TMRVPersistenciaBase, IMRVRepositorioCliente)
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

{ CoMRVBdCliente }

class function CoMRVBdCliente.Create(const ADataBase: IMRVDatabase):
  IMRVRepositorioCliente;
begin
  Result := TMRVBdCliente.Create(ADataBase);
end;

{ TMRVBdCliente }

procedure TMRVBdCliente.DoAlterar(const AItem: TMRVDadosBase);
var
  LCliente: TMRVCliente;
begin
  Assert(AItem <> nil, 'O parâmetro AItem não pode ser nil.');
   { Realiza um único typecast seguro inicial, para ser usado por todo o método }
  LCliente := AItem as TMRVCliente;
   { Informa qual o comando SQL a ser usado }
  Query.SetSQL(CommandUpdate);
   { Informa os parâmetros }
  Query.ParamByName('PAR_ClienteId').AsInteger := LCliente.Clienteid;
  Query.ParamByName('PAR_TipoCliente_TipoClienteId').AsInteger := LCliente.TipoClienteId;
  Query.ParamByName('PAR_Nome').AsString := LCliente.Nome;
  Query.ParamByName('PAR_NumeroDocumento').AsString := LCliente.Numerodocumento;
  Query.ParamByName('PAR_DataHoraCadastro').AsDateTime := LCliente.Datahoracadastro;
   { Executa o comando SQL }
  Query.ExecSQL;
end;

procedure TMRVBdCliente.DoExcluir(const AItem: TMRVDadosBase);
var
  LCliente: TMRVCliente;
begin
  Assert(AItem <> nil, 'O parâmetro AItem não pode ser nil.');
   { Realiza um único typecast seguro inicial, para ser usado por todo o método }
  LCliente := AItem as TMRVCliente;
   { Informa qual o comando SQL a ser usado }
  Query.SetSQL(CommandDelete);
   { Informa os parâmetros }
  Query.ParamByName('PAR_ClienteId').AsInteger := LCliente.Clienteid;
   { Executa o comando SQL }
  Query.ExecSQL;
end;

procedure TMRVBdCliente.DoInserir(const AItem: TMRVDadosBase);
var
  LCliente: TMRVCliente;
begin
  Assert(AItem <> nil, 'Parâmetro AItem não pode ser nil.');
  LCliente := AItem as TMRVCliente;
   { Informa qual o comando SQL a ser usado }
  Query.SetSQL(CommandInsert);
   { Informa os parâmetros }
  Query.ParamByName('PAR_ClienteId').AsInteger := LCliente.Clienteid;
  Query.ParamByName('PAR_TipoCliente_TipoClienteId').AsInteger := LCliente.TipoClienteId;
  Query.ParamByName('PAR_Nome').AsString := LCliente.Nome;
  Query.ParamByName('PAR_NumeroDocumento').AsString := LCliente.Numerodocumento;
  Query.ParamByName('PAR_DataHoraCadastro').AsDateTime := LCliente.Datahoracadastro;
   { Executa o comando SQL }
  Query.ExecSQL;
end;

function TMRVBdCliente.DoProcurarItem(const ACriterio: TMRVDadosBase; const
  AResultado: TMRVDadosBase = nil): Boolean;
var
  LCliente: TMRVCliente;
begin
  Assert(ACriterio <> nil, 'O parâmetro ACriterio não pode ser nil.');
   { Realiza um único typecast seguro inicial, para ser usado por todo o método }
  LCliente := ACriterio as TMRVCliente;
   { Informa qual o comando SQL a ser usado }
  Query.SetSQL(CommandSelectItem);
   { Informa os parâmetros }
  Query.ParamByName('PAR_ClienteId').AsInteger := LCliente.Clienteid;
   { Abre a consulta }
  Query.Open;
  Result := not Query.IsEmpty;
  if Result and Assigned(AResultado) then
  begin
    Self.RecordsetToObjeto(Query, AResultado);
  end;
end;

function TMRVBdCliente.DoProcurarItems(const ACriterio: TMRVDadosBase; const
  AListaResultado: TMRVListaBase; const ASearchOption: TMRVSearchOption): Boolean;
var
  LCliente: TMRVCliente;
  LCondicao: string;
begin
  Assert(ACriterio <> nil, 'O parâmetro ACriterio não pode ser nil.');
  Assert(AListaResultado <> nil, 'O parâmetro AListaResultado não pode ser nil.');
   { Informa qual o comando SQL a ser usado }
  Assert(ASearchOption <> nil, 'O parâmetro ASearchOption não pode ser nil.');

   { realiza o typecast}
  LCliente := ACriterio as TMRVCliente;
   { Inicializa a variável de condição }
  LCondicao := EmptyStr;

   { Montagem das condições de pesquisa }
  if (LCliente.Nome <> EmptyStr) then
  begin
    if ASearchOption.ExistPropertyName('Nome') then
    begin
      LCondicao := LCondicao + TMRVSQLDefs.AddCondition('Nome', 'PAR_Nome');
    end;
  end;
  if (LCliente.Numerodocumento <> EmptyStr) then
  begin
    if ASearchOption.ExistPropertyName('Numerodocumento') then
    begin
      LCondicao := LCondicao + TMRVSQLDefs.AddCondition('NumeroDocumento',
        'PAR_NumeroDocumento');
    end;
  end;
  if (LCliente.TipoClienteId <> C_INTEGER_NULL) then
  begin
    if ASearchOption.ExistPropertyName('TipoClienteId') then
    begin
      LCondicao := LCondicao + TMRVSQLDefs.AddCondition(
        'TipoCliente_TipoClienteId', 'PAR_TipoClienteId');
    end;
  end;

   { Informa a SQL a ser executada }
  Query.SetSQL(TMRVSQLDefs.AddWhere(CommandSelectItems, LCondicao));

   { realiza a passagem de parâmetros }
  if (LCliente.Nome <> EmptyStr) then
  begin
    if ASearchOption.ExistPropertyName('Nome') then
    begin
      Query.ParamByName('PAR_Nome').AsString := LCliente.Nome;
    end;
  end;
  if (LCliente.Numerodocumento <> EmptyStr) then
  begin
    if ASearchOption.ExistPropertyName('Numerodocumento') then
    begin
      Query.ParamByName('PAR_NumeroDocumento').AsString := LCliente.Numerodocumento;
    end;
  end;
  if (LCliente.TipoClienteId <> C_INTEGER_NULL) then
  begin
    if ASearchOption.ExistPropertyName('TipoClienteId') then
    begin
      Query.ParamByName('PAR_TipoClienteId').AsInteger := LCliente.TipoClienteId;
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
    RecordsetToLista(Query, AListaResultado, TMRVCliente);
  end;
end;

function TMRVBdCliente.GetNextId: Integer;
begin
  { Informa qual o comando SQL a ser usado }
  Query.SetSQL(CommandNextId);
  { informa id inicial }
  Result := 1;
  { Abre a consulta }
  Query.Open;
  if not Query.IsEmpty then
  begin
    Result := Query.FieldByName('ClienteId').AsInteger + 1;
  end;
end;

procedure TMRVBdCliente.MontarStringsDeComando;
begin
  CommandNextId := 'select top 1 ClienteId from Cliente order by ClienteId desc';

  CommandInsert := 'INSERT INTO Cliente (ClienteId, ' +
    'TipoCliente_TipoClienteId, ' + 'Nome, ' + 'NumeroDocumento, ' +
    'DataHoraCadastro) VALUES (:PAR_ClienteId, ' +
    ':PAR_TipoCliente_TipoClienteId, ' + ':PAR_Nome, ' +
    ':PAR_NumeroDocumento, ' + ':PAR_DataHoraCadastro)';

  CommandUpdate :=
    'UPDATE Cliente SET TipoCliente_TipoClienteId = :PAR_TipoCliente_TipoClienteId, ' +
    'Nome = :PAR_Nome, ' + 'NumeroDocumento = :PAR_NumeroDocumento, ' +
    'DataHoraCadastro = :PAR_DataHoraCadastro WHERE ClienteId = :PAR_ClienteId';

  CommandDelete := 'DELETE FROM Cliente WHERE ClienteId = :PAR_ClienteId';

  CommandSelectItem := 'SELECT ClienteId, ' + 'TipoCliente_TipoClienteId, ' +
    'Nome, ' + 'NumeroDocumento, ' +
    'DataHoraCadastro FROM Cliente WHERE ClienteId = :PAR_ClienteId';

  CommandSelectItems := 'SELECT ClienteId, ' + 'TipoCliente_TipoClienteId, ' +
    'Nome, ' + 'NumeroDocumento, ' + 'DataHoraCadastro FROM Cliente';
end;

procedure TMRVBdCliente.RecordsetToObjeto(const RS: IMRVQuery; const Objeto:
  TMRVDadosBase);
var
  LObjeto: TMRVCliente;
begin
  Assert(RS <> nil, 'O parâmetro RS não pode ser nil.');
  Assert(Objeto <> nil, 'O parâmetro Objeto não pode ser nil.');
   { recupera os dados da propriedade FADORecordset }
  LObjeto := Objeto as TMRVCliente;
   { recupera os dados do banco para o objeto }
  LObjeto.Clienteid := RS.FieldByName('ClienteId').AsInteger;
  LObjeto.TipoClienteId := RS.FieldByName('TipoCliente_TipoClienteId').AsInteger;
  LObjeto.Nome := RS.FieldByName('Nome').AsString;
  LObjeto.Numerodocumento := RS.FieldByName('NumeroDocumento').AsString;
  LObjeto.Datahoracadastro := RS.FieldByName('DataHoraCadastro').AsDateTime;
end;

end.


