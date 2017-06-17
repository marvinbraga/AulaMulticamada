inherited MRVFrameCadastroTipoCliente: TMRVFrameCadastroTipoCliente
  Width = 481
  Height = 309
  ExplicitWidth = 481
  ExplicitHeight = 309
  inherited PC_Dados: TPageControl
    Width = 481
    Height = 287
    ActivePage = TS_Cadastro
    ExplicitWidth = 481
    inherited TS_Lista: TTabSheet
      ExplicitWidth = 473
      inherited TB_BarraBotoes: TToolBar
        Width = 473
        ExplicitWidth = 473
      end
      inherited SB_Pesquisa: TSearchBox
        Width = 467
        ExplicitWidth = 467
      end
      inherited LV_Lista: TListView
        Width = 467
        Height = 193
        Columns = <
          item
            Caption = 'C'#243'digo'
            Width = 100
          end
          item
            Caption = 'Descri'#231#227'o'
            Width = 300
          end>
        ColumnClick = False
        ExplicitWidth = 467
      end
    end
    inherited TS_Cadastro: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 26
      ExplicitWidth = 473
      ExplicitHeight = 228
      inherited TB_Cadastro: TToolBar
        Width = 473
        ExplicitWidth = 473
      end
      inherited PN_Cadastro: TPanel
        Width = 467
        Height = 222
        ExplicitWidth = 467
        ExplicitHeight = 193
        DesignSize = (
          467
          222)
        inherited PN_EstadoCadastro: TPanel
          Width = 467
          Caption = '...'
          ExplicitWidth = 467
        end
        object PN_InfoTipoCliente: TPanel
          Left = 0
          Top = 25
          Width = 467
          Height = 32
          Align = alTop
          BevelOuter = bvLowered
          Caption = 'Informa'#231#245'es do Tipo de Cliente'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Roboto Bk'
          Font.Style = [fsItalic]
          ParentFont = False
          TabOrder = 1
          ExplicitTop = 31
        end
        object LE_Codigo: TLabeledEdit
          Left = 8
          Top = 86
          Width = 105
          Height = 23
          EditLabel.Width = 39
          EditLabel.Height = 15
          EditLabel.Caption = '&C'#243'digo'
          NumbersOnly = True
          TabOrder = 2
        end
        object LE_Descricao: TLabeledEdit
          Left = 8
          Top = 136
          Width = 450
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 59
          EditLabel.Height = 15
          EditLabel.Caption = '&Descri'#231#227'o'
          TabOrder = 3
        end
      end
    end
  end
  inherited PN_Titulo: TPanel
    Width = 481
    Caption = 'Tipos de Cliente'
    ExplicitWidth = 481
  end
end
