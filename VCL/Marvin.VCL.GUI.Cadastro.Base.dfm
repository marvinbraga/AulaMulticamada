object MRVFrameCadastroBase: TMRVFrameCadastroBase
  Left = 0
  Top = 0
  Width = 370
  Height = 280
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Roboto'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object PC_Dados: TPageControl
    Left = 0
    Top = 22
    Width = 370
    Height = 258
    ActivePage = TS_Lista
    Align = alClient
    MultiLine = True
    ScrollOpposite = True
    TabOrder = 0
    object TS_Lista: TTabSheet
      Caption = 'TS_Lista'
      object TB_BarraBotoes: TToolBar
        Left = 0
        Top = 0
        Width = 362
        Height = 29
        Caption = 'TB_Lista'
        TabOrder = 0
        object BT_AtualizarLista: TSpeedButton
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 75
          Height = 22
          Hint = 'Voltar para a listagem'
          Align = alLeft
          Caption = 'Atualizar'
          Flat = True
          OnClick = BT_AtualizarListaClick
        end
        object BT_Novo: TSpeedButton
          AlignWithMargins = True
          Left = 75
          Top = 0
          Width = 75
          Height = 22
          Align = alLeft
          Caption = 'Novo'
          Flat = True
          OnClick = BT_NovoClick
        end
      end
      object SB_Pesquisa: TSearchBox
        AlignWithMargins = True
        Left = 3
        Top = 32
        Width = 356
        Height = 23
        Align = alTop
        TabOrder = 1
        TextHint = 'Fa'#231'a aqui seu filtro'
      end
      object LV_Lista: TListView
        AlignWithMargins = True
        Left = 3
        Top = 61
        Width = 356
        Height = 164
        Align = alClient
        Columns = <>
        FlatScrollBars = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 2
        ViewStyle = vsReport
        OnDblClick = LV_ListaDblClick
      end
    end
    object TS_Cadastro: TTabSheet
      Caption = 'TS_Cadastro'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 225
      object TB_Cadastro: TToolBar
        Left = 0
        Top = 0
        Width = 362
        Height = 29
        Caption = 'TB_Cadastro'
        TabOrder = 0
        object BT_Voltar: TSpeedButton
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 75
          Height = 22
          Action = AT_Lista
          Align = alLeft
          Flat = True
        end
        object BT_Excluir: TSpeedButton
          AlignWithMargins = True
          Left = 75
          Top = 0
          Width = 75
          Height = 22
          Align = alLeft
          Caption = '&Excluir'
          Flat = True
          OnClick = BT_ExcluirClick
        end
        object BT_Salvar: TSpeedButton
          AlignWithMargins = True
          Left = 150
          Top = 0
          Width = 75
          Height = 22
          Align = alLeft
          Caption = '&Salvar'
          Flat = True
          OnClick = BT_SalvarClick
        end
      end
      object PN_Cadastro: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 32
        Width = 356
        Height = 193
        Align = alClient
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 1
        ExplicitHeight = 190
        object PN_EstadoCadastro: TPanel
          Left = 0
          Top = 0
          Width = 356
          Height = 25
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Estado do Cadastro'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Roboto'
          Font.Style = [fsBold, fsUnderline]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
  end
  object PN_Titulo: TPanel
    Left = 0
    Top = 0
    Width = 370
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Cadastro'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Roboto'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object AL_Acoes: TActionList
    Left = 300
    Top = 216
    object AT_Lista: TPreviousTab
      Category = 'Tab'
      TabControl = PC_Dados
      Caption = '< Voltar'
      Hint = 'Previous|Go back to the previous tab'
      ShortCut = 16421
      SkipHiddenTabs = False
    end
    object AT_Cadastro: TNextTab
      Category = 'Tab'
      TabControl = PC_Dados
      Caption = 'Cadastro'
      Hint = 'Voltar para a listagem'
      SkipHiddenTabs = False
    end
  end
end
