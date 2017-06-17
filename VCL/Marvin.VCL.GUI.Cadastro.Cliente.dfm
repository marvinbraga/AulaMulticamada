inherited MRVFrameCadastroCliente: TMRVFrameCadastroCliente
  Width = 556
  Height = 463
  ExplicitWidth = 556
  ExplicitHeight = 463
  inherited PC_Dados: TPageControl
    Width = 556
    Height = 441
    ActivePage = TS_Cadastro
    inherited TS_Lista: TTabSheet
      inherited TB_BarraBotoes: TToolBar
        Width = 548
      end
      inherited SB_Pesquisa: TSearchBox
        Width = 542
      end
      inherited LV_Lista: TListView
        Width = 542
        Height = 347
        Columns = <
          item
            Caption = 'C'#243'digo'
            Width = 100
          end
          item
            Caption = 'Nome'
            Width = 350
          end>
      end
    end
    inherited TS_Cadastro: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 26
      ExplicitWidth = 548
      ExplicitHeight = 385
      inherited TB_Cadastro: TToolBar
        Width = 548
        ExplicitWidth = 548
      end
      inherited PN_Cadastro: TPanel
        Width = 542
        Height = 376
        ExplicitWidth = 542
        ExplicitHeight = 350
        inherited PN_EstadoCadastro: TPanel
          Width = 542
          Caption = '...'
          ExplicitWidth = 542
        end
        object PN_TituloInformacoesBasicas: TPanel
          Left = 0
          Top = 25
          Width = 542
          Height = 32
          Align = alTop
          BevelOuter = bvLowered
          Caption = 'Informa'#231#245'es do Cliente'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Roboto Bk'
          Font.Style = [fsItalic]
          ParentFont = False
          TabOrder = 1
          ExplicitTop = 31
          ExplicitWidth = 467
        end
        object PN_InformacoesBasicas: TPanel
          Left = 0
          Top = 57
          Width = 542
          Height = 136
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 2
          DesignSize = (
            542
            136)
          object LE_Codigo: TLabeledEdit
            Left = 8
            Top = 30
            Width = 105
            Height = 23
            EditLabel.Width = 39
            EditLabel.Height = 15
            EditLabel.Caption = '&C'#243'digo'
            NumbersOnly = True
            TabOrder = 0
          end
          object LE_Nome: TLabeledEdit
            Left = 8
            Top = 80
            Width = 526
            Height = 23
            Anchors = [akLeft, akTop, akRight]
            EditLabel.Width = 34
            EditLabel.Height = 15
            EditLabel.Caption = '&Nome'
            TabOrder = 1
          end
        end
        object PN_TituloOutrasInformacoes: TPanel
          Left = 0
          Top = 193
          Width = 542
          Height = 32
          Align = alTop
          BevelOuter = bvLowered
          Caption = 'Outras Informa'#231#245'es'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Roboto Bk'
          Font.Style = [fsItalic]
          ParentFont = False
          TabOrder = 3
          ExplicitLeft = -3
          ExplicitTop = 225
        end
        object PN_OutrasInformacoes: TPanel
          Left = 0
          Top = 225
          Width = 542
          Height = 136
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 4
          DesignSize = (
            542
            136)
          object LB_DataHoraCadastro: TLabel
            Left = 6
            Top = 63
            Width = 140
            Height = 15
            Caption = '&Data e Hora do Cadastro'
            FocusControl = DT_DataCadastro
          end
          object LB_TipoCliente: TLabel
            Left = 198
            Top = 11
            Width = 84
            Height = 15
            Caption = '&Tipo de Cliente'
            FocusControl = DT_DataCadastro
          end
          object DT_DataCadastro: TDateTimePicker
            Left = 6
            Top = 84
            Width = 186
            Height = 23
            Date = 42854.000000000000000000
            Time = 42854.000000000000000000
            TabOrder = 2
          end
          object DT_HoraCadastro: TDateTimePicker
            Left = 198
            Top = 84
            Width = 137
            Height = 23
            Date = 42854.000000000000000000
            Time = 42854.000000000000000000
            Kind = dtkTime
            TabOrder = 3
          end
          object LE_NumeroDocumento: TLabeledEdit
            Left = 6
            Top = 30
            Width = 186
            Height = 23
            EditLabel.Width = 115
            EditLabel.Height = 15
            EditLabel.Caption = '&N'#250'mero Documento'
            NumbersOnly = True
            TabOrder = 0
          end
          object CB_TipoCliente: TComboBox
            Left = 198
            Top = 30
            Width = 338
            Height = 23
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 1
            ExplicitWidth = 334
          end
        end
      end
    end
  end
  inherited PN_Titulo: TPanel
    Width = 556
    Caption = 'Clientes'
  end
  inherited AL_Acoes: TActionList
    Left = 492
    Top = 376
  end
end
