CREATE TABLE TipoCliente (
  TipoClienteId INTEGER NOT NULL,
  Descricao VARCHAR(100) NULL,
  PRIMARY KEY(TipoClienteId)
);

CREATE TABLE Cliente (
  ClienteId INTEGER NOT NULL,
  TipoCliente_TipoClienteId INTEGER NOT NULL,
  Nome VARCHAR(100) NULL,
  NumeroDocumento VARCHAR(50) NULL,
  DataHoraCadastro DATETIME NULL,
  PRIMARY KEY(ClienteId),
  INDEX Cliente_FKIndex1(TipoCliente_TipoClienteId),
  FOREIGN KEY(TipoCliente_TipoClienteId)
    REFERENCES TipoCliente(TipoClienteId)
      ON DELETE NO ACTION
      ON UPDATE NO ACTION
);

