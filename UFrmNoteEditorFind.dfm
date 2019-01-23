object FrmNoteEditorFind: TFrmNoteEditorFind
  Left = 287
  Top = 128
  BorderStyle = bsDialog
  Caption = 'Find'
  ClientHeight = 215
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object BtnOK: TButton
    Left = 96
    Top = 184
    Width = 73
    Height = 25
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object BtnCancel: TButton
    Left = 176
    Top = 184
    Width = 73
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 329
    Height = 169
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 0
    object LbLocalizar: TLabel
      Left = 8
      Top = 8
      Width = 47
      Height = 13
      Caption = 'Find text:'
    end
    object EdFind: TEdit
      Left = 8
      Top = 24
      Width = 193
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnChange = EdFindChange
    end
    object CkReplaceAll: TCheckBox
      Left = 8
      Top = 144
      Width = 131
      Height = 15
      Caption = 'Replace all occurrences'
      Enabled = False
      TabOrder = 5
    end
    object Em: TRadioGroup
      Left = 216
      Top = 56
      Width = 105
      Height = 105
      Caption = 'Find method'
      ItemIndex = 0
      Items.Strings = (
        'All text'
        'Selected'
        'Above'
        'Below')
      TabOrder = 6
    end
    object CkWholeWord: TCheckBox
      Left = 8
      Top = 124
      Width = 99
      Height = 15
      Caption = 'Whole word only'
      TabOrder = 4
    end
    object CkSensitive: TCheckBox
      Left = 8
      Top = 104
      Width = 88
      Height = 15
      Caption = 'Case sensitive'
      TabOrder = 3
    end
    object CkReplace: TCheckBox
      Left = 8
      Top = 54
      Width = 84
      Height = 15
      Caption = 'Replace with:'
      TabOrder = 1
      OnClick = CkReplaceClick
    end
    object EdReplace: TEdit
      Left = 8
      Top = 72
      Width = 193
      Height = 21
      Enabled = False
      TabOrder = 2
    end
  end
end
