unit DzNoteEditorReg;

interface

uses DesignEditors, DesignIntf;

type
  TDzNoteEditorStringsEdit = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
  end;

  TDzNotepadPropDbClick = class(TDefaultEditor)
  public
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
  end;

procedure Register;

implementation

uses System.Classes, Data.DB, Vcl.Forms, System.SysUtils,
 UFrmNoteEditor, DzNotepad;

procedure Register;
begin
  RegisterComponents('Digao', [TDzNotepad]);

  RegisterPropertyEditor(TypeInfo(TStrings), nil, '', TDzNoteEditorStringsEdit);
  RegisterPropertyEditor(TypeInfo(TStrings), TDataSet, 'SQL', TDzNoteEditorStringsEdit);
  RegisterPropertyEditor(TypeInfo(TStrings), TDzNotepad, 'Lines', TDzNoteEditorStringsEdit);

  RegisterComponentEditor(TDzNotepad, TDzNotepadPropDbClick);
end;

//

procedure TDzNoteEditorStringsEdit.Edit;
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

function TDzNoteEditorStringsEdit.GetAttributes: TPropertyAttributes;
begin
    Result := [paDialog, paReadOnly];
end;

function TDzNoteEditorStringsEdit.GetValue: string;
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

//

procedure TDzNotepadPropDbClick.EditProperty(const Prop: IProperty; var Continue: Boolean);
begin
    if Prop.GetName = 'Lines' then
    begin
        Prop.Edit;
        Continue := False;
    end;
end;

end.
