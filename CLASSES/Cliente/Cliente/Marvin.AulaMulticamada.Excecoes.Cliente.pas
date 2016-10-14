{  Arquivo criado automaticamente Gerador Multicamadas
   (Multitiers Generator VERSÃO 0.01)
   Data e Hora: 11/10/2016 - 23:04:17
}

unit Marvin.AulaMulticamada.Excecoes.Cliente;

interface

uses
  SysUtils,
   { marvin }
  uMRVExcecoesFramework;

type
  EMRVExcecoesCliente = class(EMRVException)
  end;

  EMRVClienteNaoInformado = class(EMRVExcecoesCliente)
  public
    constructor Create; override;
  end;

  EMRVClienteNaoCadastrado = class(EMRVExcecoesCliente)
  public
    constructor Create; override;
  end;

  EMRVClienteJaCadastrado = class(EMRVExcecoesCliente)
  public
    constructor Create; override;
  end;

  EMRVClienteFereIntegridadeReferencial = class(EMRVExcecoesCliente)
  public
    constructor Create; override;
  end;

  EMRVClienteClienteidInvalido = class(EMRVExcecoesCliente)
  public
    constructor Create; override;
  end;

  EMRVClienteClienteidTamanhoInvalido = class(EMRVExcecoesCliente)
  public
    constructor Create(ATamanho: Integer); reintroduce; overload; virtual;
  end;

  EMRVClienteTipoClienteIdInvalido = class(EMRVExcecoesCliente)
  public
    constructor Create; override;
  end;

  EMRVClienteTipoClienteIdTamanhoInvalido = class(EMRVExcecoesCliente)
  public
    constructor Create(ATamanho: Integer); reintroduce; overload; virtual;
  end;

  EMRVClienteNomeInvalido = class(EMRVExcecoesCliente)
  public
    constructor Create; override;
  end;

  EMRVClienteNomeTamanhoInvalido = class(EMRVExcecoesCliente)
  public
    constructor Create(ATamanho: Integer); reintroduce; overload; virtual;
  end;

  EMRVClienteNumerodocumentoInvalido = class(EMRVExcecoesCliente)
  public
    constructor Create; override;
  end;

  EMRVClienteNumerodocumentoTamanhoInvalido = class(EMRVExcecoesCliente)
  public
    constructor Create(ATamanho: Integer); reintroduce; overload; virtual;
  end;

  EMRVClienteDatahoracadastroInvalida = class(EMRVExcecoesCliente)
  public
    constructor Create; override;
  end;

  EMRVClienteDatahoracadastroTamanhoInvalido = class(EMRVExcecoesCliente)
  public
    constructor Create(ATamanho: Integer); reintroduce; overload; virtual;
  end;

implementation

{ EMRVClienteNaoInformado }

constructor EMRVClienteNaoInformado.Create;
begin
  inherited;
  Message := 'Cliente não informado.';
end;

{ EMRVClienteNaoCadastrado }

constructor EMRVClienteNaoCadastrado.Create;
begin
  inherited;
  Message := 'Cliente não cadastrado.';
end;

{ EMRVClienteJaCadastrado }

constructor EMRVClienteJaCadastrado.Create;
begin
  inherited;
  Message := 'Cliente já cadastrado.';
end;

{ EMRVClienteFereIntegridadeReferencial }

constructor EMRVClienteFereIntegridadeReferencial.Create;
begin
  inherited;
  Message := 'A exclusão não pode ser feita.'#$D#$A +
    'Ainda existem dependências no banco de dados.';
end;
{ EMRVClienteClienteidInvalido }

constructor EMRVClienteClienteidInvalido.Create;
begin
  inherited;
  Message := 'Id do Cliente inválido.';
end;

{ EMRVClienteClienteidTamanhoInvalido }

constructor EMRVClienteClienteidTamanhoInvalido.Create(ATamanho: Integer);
begin
  inherited Create;
  Message := Format('O tamanho do campo %S excede o valor permitido que é de %d caractere(s).',
    ['Id do Cliente', ATamanho]);
end;

{ EMRVClienteTipoClienteIdInvalido }

constructor EMRVClienteTipoClienteIdInvalido.Create;
begin
  inherited;
  Message := 'Id do TipoCliente inválido.';
end;

{ EMRVClienteTipoClienteIdTamanhoInvalido }

constructor EMRVClienteTipoClienteIdTamanhoInvalido.Create(ATamanho: Integer);
begin
  inherited Create;
  Message := Format('O tamanho do campo %S excede o valor permitido que é de %d caractere(s).',
    ['Id do TipoCliente', ATamanho]);
end;

{ EMRVClienteNomeInvalido }

constructor EMRVClienteNomeInvalido.Create;
begin
  inherited;
  Message := 'Nome inválido.';
end;

{ EMRVClienteNomeTamanhoInvalido }

constructor EMRVClienteNomeTamanhoInvalido.Create(ATamanho: Integer);
begin
  inherited Create;
  Message := Format('O tamanho do campo %S excede o valor permitido que é de %d caractere(s).',
    ['Nome', ATamanho]);
end;

{ EMRVClienteNumerodocumentoInvalido }

constructor EMRVClienteNumerodocumentoInvalido.Create;
begin
  inherited;
  Message := 'Número do Documento inválido.';
end;

{ EMRVClienteNumerodocumentoTamanhoInvalido }

constructor EMRVClienteNumerodocumentoTamanhoInvalido.Create(ATamanho: Integer);
begin
  inherited Create;
  Message := Format('O tamanho do campo %S excede o valor permitido que é de %d caractere(s).',
    ['Número do Documento', ATamanho]);
end;

{ EMRVClienteDatahoracadastroInvalida }

constructor EMRVClienteDatahoracadastroInvalida.Create;
begin
  inherited;
  Message := 'Data e Hora inválida.';
end;

{ EMRVClienteDatahoracadastroTamanhoInvalido }

constructor EMRVClienteDatahoracadastroTamanhoInvalido.Create(ATamanho: Integer);
begin
  inherited Create;
  Message := Format('O tamanho do campo %S excede o valor permitido que é de %d caractere(s).',
    ['Data e Hora', ATamanho]);
end;

end.


