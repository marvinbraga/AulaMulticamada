object frmVCLPrincipal: TfrmVCLPrincipal
  Left = 0
  Top = 0
  ActiveControl = BT_Clientes
  Caption = 'Aula Multicadas - VCL Application - Marvinbraga YouTube Channel'
  ClientHeight = 534
  ClientWidth = 767
  Color = clBtnFace
  DockSite = True
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Roboto'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = mnuEstilos
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object PC_Cadastros: TPageControl
    Left = 200
    Top = 0
    Width = 567
    Height = 534
    ActivePage = TS_TiposCliente
    Align = alClient
    TabOrder = 1
    object TS_Clientes: TTabSheet
      Caption = 'Clientes'
      inline FME_Clientes: TMRVFrameCadastroCliente
        Left = 0
        Top = 0
        Width = 559
        Height = 504
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Roboto'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitWidth = 559
        ExplicitHeight = 504
        inherited PC_Dados: TPageControl
          Width = 559
          Height = 482
          ExplicitWidth = 559
          ExplicitHeight = 482
          inherited TS_Lista: TTabSheet
            ExplicitLeft = 4
            ExplicitTop = 26
            ExplicitWidth = 548
            ExplicitHeight = 411
          end
          inherited TS_Cadastro: TTabSheet
            ExplicitWidth = 551
            ExplicitHeight = 452
            inherited TB_Cadastro: TToolBar
              Width = 551
              ExplicitWidth = 551
            end
            inherited PN_Cadastro: TPanel
              Width = 545
              Height = 417
              ExplicitWidth = 545
              ExplicitHeight = 417
              inherited PN_EstadoCadastro: TPanel
                Width = 545
                ExplicitWidth = 545
              end
              inherited PN_TituloInformacoesBasicas: TPanel
                Width = 545
                ExplicitTop = 25
                ExplicitWidth = 545
              end
              inherited PN_InformacoesBasicas: TPanel
                Width = 545
                ExplicitWidth = 545
                inherited LE_Nome: TLabeledEdit
                  Width = 529
                  ExplicitWidth = 529
                end
              end
              inherited PN_TituloOutrasInformacoes: TPanel
                Width = 545
                ExplicitLeft = 0
                ExplicitTop = 193
                ExplicitWidth = 545
              end
              inherited PN_OutrasInformacoes: TPanel
                Width = 545
                ExplicitWidth = 545
                DesignSize = (
                  545
                  136)
              end
            end
          end
        end
        inherited PN_Titulo: TPanel
          Width = 559
          ExplicitWidth = 559
        end
      end
    end
    object TS_TiposCliente: TTabSheet
      Caption = 'Tipos de Clientes'
      ImageIndex = 1
      inline FME_TiposCliente: TMRVFrameCadastroTipoCliente
        Left = 0
        Top = 0
        Width = 559
        Height = 504
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Roboto'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitWidth = 559
        ExplicitHeight = 504
        inherited PC_Dados: TPageControl
          Width = 559
          Height = 482
          ExplicitWidth = 559
          ExplicitHeight = 482
          inherited TS_Lista: TTabSheet
            ExplicitLeft = 4
            ExplicitTop = 26
            ExplicitHeight = 257
          end
          inherited TS_Cadastro: TTabSheet
            ExplicitWidth = 551
            ExplicitHeight = 452
            inherited TB_Cadastro: TToolBar
              Width = 551
              ExplicitWidth = 551
            end
            inherited PN_Cadastro: TPanel
              Width = 545
              Height = 417
              ExplicitWidth = 545
              ExplicitHeight = 417
              inherited PN_EstadoCadastro: TPanel
                Width = 545
                ExplicitWidth = 545
              end
              inherited PN_InfoTipoCliente: TPanel
                Width = 545
                ExplicitTop = 25
                ExplicitWidth = 545
              end
            end
          end
        end
        inherited PN_Titulo: TPanel
          Width = 559
          ExplicitWidth = 559
        end
        inherited AL_Acoes: TActionList
          Left = 476
          Top = 424
        end
      end
    end
  end
  object SV_Comandos: TSplitView
    Left = 0
    Top = 0
    Width = 200
    Height = 534
    OpenedWidth = 200
    Placement = svpLeft
    TabOrder = 0
    object BT_TiposCliente: TButton
      AlignWithMargins = True
      Left = 10
      Top = 53
      Width = 180
      Height = 41
      Margins.Left = 10
      Margins.Right = 10
      Align = alTop
      Caption = 'Cadastro de &Tipos de Cliente'
      TabOrder = 0
      OnClick = BT_TiposClienteClick
    end
    object BT_Clientes: TButton
      AlignWithMargins = True
      Left = 10
      Top = 6
      Width = 180
      Height = 41
      Margins.Left = 10
      Margins.Top = 6
      Margins.Right = 10
      Align = alTop
      Caption = 'Cadastro de &Clientes'
      TabOrder = 1
      OnClick = BT_ClientesClick
    end
  end
  object mnuEstilos: TPopupMenu
    MenuAnimation = [maLeftToRight]
    Left = 80
    Top = 376
    object mniEstilos: TMenuItem
      Caption = 'Estilos'
    end
  end
end
