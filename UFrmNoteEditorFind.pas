unit UFrmNoteEditorFind;

interface

uses Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, System.Classes;

type
  TFrmNoteEditorFind = class(TForm)
    BtnOK: TButton;
    BtnCancel: TButton;
    Panel1: TPanel;
    EdFind: TEdit;
    CkReplaceAll: TCheckBox;
    Em: TRadioGroup;
    CkWholeWord: TCheckBox;
    CkSensitive: TCheckBox;
    CkReplace: TCheckBox;
    EdReplace: TEdit;
    LbLocalizar: TLabel;
    procedure CkReplaceClick(Sender: TObject);
    procedure EdFindChange(Sender: TObject);
  end;

implementation

{$R *.dfm}

procedure TFrmNoteEditorFind.CkReplaceClick(Sender: TObject);
begin
    EdReplace.Enabled := CkReplace.Checked;
    CkReplaceAll.Enabled := CkReplace.Checked;
end;

procedure TFrmNoteEditorFind.EdFindChange(Sender: TObject);
begin
    BtnOK.Enabled := (EdFind.Text<>'');
end;

end.
