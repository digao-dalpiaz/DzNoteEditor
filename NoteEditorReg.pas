unit NoteEditorReg;

interface

uses DesignEditors, DesignIntf;

type
  TNoteEditorStringsEdit = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: String; override;
  end;

procedure Register;

implementation

uses System.Classes, Data.DB, Vcl.Forms, System.SysUtils,
 UFrmNoteEditor;

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TStrings), nil, '', TNoteEditorStringsEdit);
  RegisterPropertyEditor(TypeInfo(TStrings), TDataSet, 'SQL', TNoteEditorStringsEdit);
end;

//

procedure TNoteEditorStringsEdit.Edit;
var Form: TFrmNoteEditor;
    C: TPersistent;
begin
    C := GetComponent(0);

    Form := TFrmNoteEditor.Create(Application);
    try
      Form.Design := Designer;
      Form.PStr := TStrings(GetOrdValue);
      Form.LbTitle.Caption := Format('%s.%s (%s)', [C.GetNamePath, GetName, C.ClassName]);
      Form.ShowModal;
    finally
      Form.Free;
    end;
end;

function TNoteEditorStringsEdit.GetAttributes: TPropertyAttributes;
begin
    Result := [paDialog, paReadOnly];
end;

function TNoteEditorStringsEdit.GetValue: String;
var S: TStrings;
    X: Integer;
begin
    S := TStrings(GetOrdValue);
    X := S.Count;

    if X = 0 then
      Result := '(Empty)' else
    if X = 1 then
      Result := '(1 line)' else
      Result := Format('(%d lines)', [X]);
end;

end.
