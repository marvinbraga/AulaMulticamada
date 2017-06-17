program VCLAulaMulticamada;

uses
  Vcl.Forms,
  Marvin.VCL.GUI.Principal in 'Marvin.VCL.GUI.Principal.pas' {frmVCLPrincipal},
  Vcl.Themes,
  Vcl.Styles,
  Marvin.VCL.StyleManager in 'Marvin.VCL.StyleManager.pas',
  Marvin.VCL.GUI.Cadastro.Base in 'Marvin.VCL.GUI.Cadastro.Base.pas' {MRVFrameCadastroBase: TFrame},
  Marvin.VCL.GUI.Cadastro.TipoCliente in 'Marvin.VCL.GUI.Cadastro.TipoCliente.pas' {MRVFrameCadastroTipoCliente: TFrame},
  Marvin.VCL.GUI.Cadastro.Cliente in 'Marvin.VCL.GUI.Cadastro.Cliente.pas' {MRVFrameCadastroCliente: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'VCL Aula Multicamada - Marvinbraga YouTube Channel';
  Application.CreateForm(TfrmVCLPrincipal, frmVCLPrincipal);
  Application.Run;
end.
