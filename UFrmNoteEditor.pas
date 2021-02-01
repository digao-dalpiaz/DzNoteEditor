{------------------------------------------------------------------------------
DzNoteEditor property editor
Developed by Rodrigo Depine Dalpiaz (digao dalpiaz)
Property Editor to TStrings class integrated in Delphi IDE

https://github.com/digao-dalpiaz/DzNoteEditor

Please, read the documentation at GitHub link.
------------------------------------------------------------------------------}

unit UFrmNoteEditor;

interface

uses Vcl.Forms, System.Classes, System.Actions, Vcl.ActnList,
  SynEditMiscClasses, SynEditSearch, Vcl.Menus, Vcl.ImgList,
  Vcl.Controls, Vcl.ComCtrls, Vcl.ToolWin, SynEdit, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls,
  {$IF CompilerVersion >= 29}System.ImageList, {$ENDIF}
  //
  SynEditHighlighter, SynEditTypes,
  Winapi.Windows, Winapi.Messages,
  System.Win.Registry,
  DesignIntf;

type
  TFrmNoteEditor = class(TForm)
    BoxButtons: TPanel;
    BtnCancel: TBitBtn;
    BtnOK: TBitBtn;
    BtnSave: TBitBtn;
    IL: TImageList;
    MenuSyn: TPopupMenu;
    MenuConfig: TPopupMenu;
    ItemStyleCodeEditor: TMenuItem;
    Search: TSynEditSearch;
    N1: TMenuItem;
    ItemConfig: TMenuItem;
    ItemStyleNormal: TMenuItem;
    ItemColors: TMenuItem;
    ItemWordWrap: TMenuItem;
    N2: TMenuItem;
    ActionList: TActionList;
    Action_FindNext: TAction;
    Action_Find: TAction;
    Box: TPanel;
    LbTitle: TLabel;
    M: TSynEdit;
    StatusBar: TStatusBar;
    IL_Disab: TImageList;
    Panel1: TPanel;
    ToolBar: TToolBar;
    BtnSyn: TToolButton;
    BtnPower: TToolButton;
    ToolButton15: TToolButton;
    BtnCut: TToolButton;
    BtnCopy: TToolButton;
    BtnPaste: TToolButton;
    ToolButton16: TToolButton;
    BtnUndo: TToolButton;
    BtnRedo: TToolButton;
    ToolButton18: TToolButton;
    BtnSelectAll: TToolButton;
    BtnClear: TToolButton;
    BtnCopyAll: TToolButton;
    ToolButton19: TToolButton;
    BtnFind: TToolButton;
    BtnFindNext: TToolButton;
    ToolButton20: TToolButton;
    BtnImport: TToolButton;
    BtnExport: TToolButton;
    ToolButton21: TToolButton;
    BtnConfig: TToolButton;
    ItemSpecialChars: TMenuItem;
    Action_Save: TAction;
    Action_OK: TAction;
    BtnHelp: TToolButton;
    procedure MStatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnCutClick(Sender: TObject);
    procedure BtnCopyClick(Sender: TObject);
    procedure BtnPasteClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure BtnUndoClick(Sender: TObject);
    procedure BtnRedoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnPowerClick(Sender: TObject);
    procedure ItemStyleCodeEditorClick(Sender: TObject);
    procedure BtnFindClick(Sender: TObject);
    procedure ItemConfigClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnImportClick(Sender: TObject);
    procedure BtnSelectAllClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure BtnFindNextClick(Sender: TObject);
    procedure ItemWordWrapClick(Sender: TObject);
    procedure ItemColorsClick(Sender: TObject);
    procedure BtnCopyAllClick(Sender: TObject);
    procedure ItemSpecialCharsClick(Sender: TObject);
    procedure Action_OKExecute(Sender: TObject);
    procedure BtnHelpClick(Sender: TObject);
  private
    type
      TMenuItemSyn = class(TMenuItem)
      public
        SynClass: TSynCustomHighlighterClass;
        LangID, LangDesc, PathReg: string;
      end;
    var LastSynMenuItem: TMenuItemSyn;

    Search_Opt: TSynSearchOptions;
    Search_Find, Search_Replace: string;
    Search_Em: Integer;

    NextClip: HWND;
    procedure ClipChange(var Msg: TWMChangeCBChain); message WM_CHANGECBCHAIN;
    procedure ClipDraw(var Msg: TWMDrawClipboard); message WM_DRAWCLIPBOARD;

    procedure CreateSyns(const SavedName: string);
    procedure OnMenuItemSynClick(Sender: TObject);
  public
    PStr: TStrings;
    Design: IDesigner;
  end;

implementation

{$R *.dfm}

uses
  Vcl.Graphics, System.SysUtils, System.StrUtils,
  Vcl.ExtDlgs, Vcl.Clipbrd, Vcl.Dialogs, Winapi.ShellAPI,
  UFrmNoteEditorFind, UFrmNoteEditorConfig, UFrmNoteEditorColors,
  System.Generics.Defaults, System.Generics.Collections;

const REG_PATH = 'Digao\NoteEditor';

function RegReadString(Reg: TRegistry; const aName, aDefault: string): string;
begin
  if Reg.ValueExists(aName) then
    Result := Reg.ReadString(aName)
  else
    Result := aDefault;
end;

function RegReadInteger(Reg: TRegistry; const aName: string;
  const aDefault: Integer): Integer;
begin
  if Reg.ValueExists(aName) then
    Result := Reg.ReadInteger(aName)
  else
    Result := aDefault;
end;

function RegReadBoolean(Reg: TRegistry; const aName: string;
  const aDefault: Boolean): Boolean;
begin
  if Reg.ValueExists(aName) then
    Result := Reg.ReadBool(aName)
  else
    Result := aDefault;
end;

//

procedure SaveFormPos(Reg: TRegistry; F: TForm);
var WP: TWindowPlacement;
begin
    WP.Length := SizeOf( TWindowPlacement );
    GetWindowPlacement( F.Handle, @WP );

    if Reg.OpenKey('Window', True) then //should return always true !
    begin
      Reg.WriteInteger('X', WP.rcNormalPosition.Left);
      Reg.WriteInteger('Y', WP.rcNormalPosition.Top);
      Reg.WriteInteger('W', WP.rcNormalPosition.Width);
      Reg.WriteInteger('H', WP.rcNormalPosition.Height);

      Reg.WriteBool('Max', (F.WindowState=wsMaximized) );
    end;
end;

procedure LoadFormPos(Reg: TRegistry; F: TForm);
begin
    if Reg.OpenKeyReadOnly('Window') then //only if was saved before
    begin
      F.Left := Reg.ReadInteger('X');
      F.Top := Reg.ReadInteger('Y');
      F.Width := Reg.ReadInteger('W');
      F.Height := Reg.ReadInteger('H');

      if Reg.ReadBool('Max') then
        F.WindowState := wsMaximized;

      F.Position := poDesigned;
    end;
end;

//

type TMyHC = class
  ID, Caption: string;
  &Class: TSynCustomHighlighterClass;
end;
procedure TFrmNoteEditor.CreateSyns(const SavedName: string);
var C: TSynCustomHighlighterClass;
    MI: TMenuItemSyn;
    L: TSynHighlighterList;
    I, Count: Integer;
    MyLst: TList<TMyHC>;
    HC: TMyHC;
begin
    L := GetPlaceableHighlighters;

    MyLst := TList<TMyHC>.Create;
    try
      for I := 0 to L.Count-1 do
      begin
        C := L[I];

        HC := TMyHC.Create;
        MyLst.Add(HC);

        HC.&Class := C;
        HC.ID := C.GetLanguageName;
        HC.Caption := C.GetFriendlyLanguageName;
      end;

      MyLst.Sort(TComparer<TMyHC>.Construct(
        function(const Item1, Item2: TMyHC): Integer
        begin
          Result := CompareText(Item1.Caption, Item2.Caption);
        end)
      );

      Count := 0;

      for HC in MyLst do
      begin
        MI := TMenuItemSyn.Create(Self);
        MI.SynClass := HC.&Class;
        MI.LangID := HC.ID;
        MI.LangDesc := HC.Caption;
        MI.PathReg := REG_PATH+'\Languages\'+MI.LangID;

        MenuSyn.Items.Add(MI);
        MI.Caption := MI.LangDesc;
        MI.OnClick := OnMenuItemSynClick;
        MI.RadioItem := True; //set bullet graphic and auto-uncheck when set any other on same group

        if MI.LangID = SavedName then LastSynMenuItem := MI;

        if Count>20 then
        begin
          MI.Break := mbBarBreak;
          Count := 0;
        end;
        Inc(Count);
      end;
    finally
      MyLst.Free;
    end;
end;

procedure TFrmNoteEditor.OnMenuItemSynClick(Sender: TObject);
var MI: TMenuItemSyn;
begin
    if Assigned(M.Highlighter) then M.Highlighter.Free; //previous syn

    if Sender=nil then
    begin
        M.Highlighter := nil;
        StatusBar.Panels[4].Text := 'Plain Text';
    end else
    begin
        MI := TMenuItemSyn(Sender);
        MI.Checked := True;

        M.Highlighter := MI.SynClass.Create(Self);
        M.Highlighter.LoadFromRegistry(HKEY_CURRENT_USER, MI.PathReg);
        StatusBar.Panels[4].Text := MI.LangDesc;

        LastSynMenuItem := MI;
    end;
end;

procedure TFrmNoteEditor.BtnPowerClick(Sender: TObject);
begin
    if BtnPower.Down then
    begin
        BtnSyn.Enabled := True;
        //BtnSyn.ImageIndex := 0;

        BtnPower.ImageIndex := 3;

        OnMenuItemSynClick(LastSynMenuItem);
    end else
    begin
        BtnSyn.Enabled := False;
        //BtnSyn.ImageIndex := 1;

        BtnPower.ImageIndex := 2;
        OnMenuItemSynClick(nil);
    end;
end;

//

procedure TFrmNoteEditor.ClipChange(var Msg: TWMChangeCBChain);
begin
    inherited;
    Msg.Result := 0;
    if Msg.Remove = NextClip then
      NextClip := Msg.Next else
      SendMessage(NextClip, WM_CHANGECBCHAIN, Msg.Remove, Msg.Next);
end;

procedure TFrmNoteEditor.ClipDraw(var Msg: TWMDrawClipboard);
begin
    inherited;
    //
    BtnPaste.Enabled := M.CanPaste;
    //
    SendMessage(NextClip, WM_DRAWCLIPBOARD, 0, 0);
end;

//

procedure TFrmNoteEditor.FormCreate(Sender: TObject);
var Reg: TRegistry;
begin
    Box.Anchors := [akLeft,akRight,akTop,akBottom];
    BoxButtons.Anchors := [akBottom];
    //
    NextClip := SetClipboardViewer(Handle);
    //
    M.WantTabs := True; //allow insert tab in the text instead of jump focus control
    M.Gutter.ShowLineNumbers := True; //show line numbers at gutter
    M.Gutter.ShowModification := True; //show line modification mark at gutter
    M.Options := M.Options + [eoAltSetsColumnMode]; //allow alt to column select mode

    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.OpenKey(REG_PATH, True);

      CreateSyns( RegReadString(Reg, 'Language', 'SQL') );

      M.Color := RegReadInteger(Reg, 'BgColor', clWindow);
      M.Font.Color := RegReadInteger(Reg, 'FontColor', clWindowText);
      M.Font.Name := RegReadString(Reg, 'Font', 'Courier New');
      M.Font.Size := RegReadInteger(Reg, 'Size', 10);
      M.Font.Style := TFontStyles(Byte(RegReadInteger(Reg, 'Style', 0)));

      if RegReadBoolean(Reg, 'Code', True) then
        ItemStyleCodeEditor.Click
      else
        ItemStyleNormal.Click;

      ItemWordWrap.Checked := RegReadBoolean(Reg, 'WordWrap', False);
      ItemWordWrapClick(nil);

      ItemSpecialChars.Checked := RegReadBoolean(Reg, 'SpecialChars', False);
      ItemSpecialCharsClick(nil);

      BtnPower.Down := RegReadBoolean(Reg, 'SynEnabled', False);
      BtnPowerClick(nil);

      LoadFormPos(Reg, Self); //this should be the last thing because changes the registry path
    finally
      Reg.Free;
    end;
end;

procedure TFrmNoteEditor.FormDestroy(Sender: TObject);
var Reg: TRegistry;
begin
    if NextClip <> 0 then
      ChangeClipboardChain(Handle, NextClip);
    //
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.OpenKey(REG_PATH, True);

      if Assigned(LastSynMenuItem) then
        Reg.WriteString('Language', LastSynMenuItem.LangID);
      Reg.WriteBool('SynEnabled', BtnPower.Down);

      Reg.WriteInteger('BgColor', M.Color);
      Reg.WriteInteger('FontColor', M.Font.Color);
      Reg.WriteString('Font', M.Font.Name);
      Reg.WriteInteger('Size', M.Font.Size);
      Reg.WriteInteger('Style', Byte(M.Font.Style));

      Reg.WriteBool('Code', ItemStyleCodeEditor.Checked);
      Reg.WriteBool('WordWrap', ItemWordWrap.Checked);
      Reg.WriteBool('SpecialChars', ItemSpecialChars.Checked);

      SaveFormPos(Reg, Self); //this should be the last thing because changes the registry path
    finally
      Reg.Free;
    end;
end;

procedure TFrmNoteEditor.FormShow(Sender: TObject);
begin
    M.Lines.Assign(PStr);

    MStatusChange(nil, [scCaretX, scCaretY, scSelection, scInsertMode]);
end;

procedure TFrmNoteEditor.MStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);

var aCount: string;
begin
    if (scCaretX in Changes) or
       (scCaretY in Changes) then
    begin
       StatusBar.Panels[0].Text := Format('%u: %u', [M.CaretY, M.CaretX]);
    end;

    if (scSelection in Changes) then
    begin
        if (M.Text = '') then aCount := 'Empty' else
        if (M.Lines.Count = 1) then aCount := '1 line' else
          aCount := IntToStr(M.Lines.Count) + ' lines';

        StatusBar.Panels[1].Text := aCount;

        BtnCut.Enabled := M.SelAvail;
        BtnCopy.Enabled := M.SelAvail;

        BtnSelectAll.Enabled := (M.Text<>'');
        BtnClear.Enabled := BtnSelectAll.Enabled;
        BtnCopyAll.Enabled := BtnSelectAll.Enabled;
        BtnExport.Enabled := BtnSelectAll.Enabled;
        BtnFind.Enabled := BtnSelectAll.Enabled;
        BtnFindNext.Enabled := BtnSelectAll.Enabled;

        BtnUndo.Enabled := M.CanUndo;
        BtnRedo.Enabled := M.CanRedo;
    end;

    if (scModified in Changes) then
    begin
        StatusBar.Panels[2].Text := IfThen(M.Modified, 'Modified');
        BtnSave.Enabled := M.Modified;
    end;

    if (scInsertMode in Changes) then
    begin
       StatusBar.Panels[3].Text := IfThen(M.InsertMode, 'Inserting', '* Overwriting *');
    end;
end;

procedure TFrmNoteEditor.BtnSaveClick(Sender: TObject);
begin
    if not BtnSave.Enabled then Exit;

    if (M.Text = '') then
      PStr.Clear
    else
      PStr.Assign(M.Lines);

    M.Modified := False;
    Design.Modified;
end;

procedure TFrmNoteEditor.BtnOKClick(Sender: TObject);
begin
    BtnSaveClick(nil);
end;

procedure TFrmNoteEditor.BtnCutClick(Sender: TObject);
begin
    M.CutToClipboard;
end;

procedure TFrmNoteEditor.BtnCopyClick(Sender: TObject);
begin
    M.CopyToClipboard;
end;

procedure TFrmNoteEditor.BtnPasteClick(Sender: TObject);
begin
    M.PasteFromClipboard;
end;

procedure TFrmNoteEditor.BtnSelectAllClick(Sender: TObject);
begin
    M.SelectAll;
end;

procedure TFrmNoteEditor.BtnClearClick(Sender: TObject);
begin
    M.SelectAll;
    M.ClearSelection;
end;

procedure TFrmNoteEditor.BtnCopyAllClick(Sender: TObject);
begin
    Clipboard.AsText := M.Text;
end;

procedure TFrmNoteEditor.BtnUndoClick(Sender: TObject);
begin
    M.Undo;
end;

procedure TFrmNoteEditor.BtnRedoClick(Sender: TObject);
begin
    M.Redo;
end;

procedure TFrmNoteEditor.BtnFindClick(Sender: TObject);
var B: TFrmNoteEditorFind;
begin
    if not BtnFind.Enabled then Exit;

    B := TFrmNoteEditorFind.Create(Application);
  try
    B.EdFind.Text := Search_Find;
    B.EdReplace.Text := Search_Replace;
    B.CkReplace.Checked := ssoReplace in Search_Opt;
    B.CkSensitive.Checked := ssoMatchCase in Search_Opt;
    B.CkWholeWord.Checked := ssoWholeWord in Search_Opt;
    B.CkReplaceAll.Checked := ssoReplaceAll in Search_Opt;
    B.Em.ItemIndex := Search_Em;

    if M.SelAvail then //has text selected
    begin
       if M.SelTabBlock then //multiple lines selected
         B.Em.ItemIndex := 1 //set selection find option by default
       else
         B.EdFind.Text := M.SelText; //fill search text with selected text
    end;

    if B.ShowModal = mrOk then
    begin
        Search_Opt := [];
        if B.CkSensitive.Checked then Include(Search_Opt, ssoMatchCase);
        if B.CkWholeWord.Checked then Include(Search_Opt, ssoWholeWord);
        if B.CkReplace.Checked then Include(Search_Opt, ssoReplace);
        if B.CkReplaceAll.Checked then Include(Search_Opt, ssoReplaceAll);

        case B.Em.ItemIndex of
          0: Include(Search_Opt, ssoEntireScope);
          1: Include(Search_Opt, ssoSelectedOnly);
          2: Include(Search_Opt, ssoBackwards);
          3: {abaixo};
        end;

        Search_Find := B.EdFind.Text;
        Search_Replace := B.EdReplace.Text;
        Search_Em := B.Em.ItemIndex;

        if M.SearchReplace(Search_Find, Search_Replace, Search_Opt) = 0 then
          ShowMessage('Text not found')
        else
          if (ssoReplaceAll in Search_Opt) then
            ShowMessage('Replacements: ' + IntToStr(Search.Count));
    end;

  finally
    B.Free;
  end;
end;

procedure TFrmNoteEditor.BtnFindNextClick(Sender: TObject);
begin
    if not BtnFindNext.Enabled then Exit;

    if (Search_Find<>'') and not (ssoReplace in Search_Opt) then
    begin
        Exclude(Search_Opt, ssoEntireScope);
        Exclude(Search_Opt, ssoSelectedOnly);

        if M.SearchReplace(Search_Find, '', Search_Opt) = 0 then
          ShowMessage('Text not found');
    end
      else BtnFindClick(nil);
end;

procedure TFrmNoteEditor.ItemStyleCodeEditorClick(Sender: TObject);
var X: TSynEditorOptions;
begin
    TMenuItem(Sender).Checked := True;

    X := [eoScrollPastEol, //allow cursor oversizes text end of line
          eoAutoIndent,
          eoTabsToSpaces, //insert spaces on type tab
          eoTrimTrailingSpaces, //clear white spaces at the end of the line
          eoEnhanceHomeKey, //home key first stops at start of the text and then at the start of the line
          eoEnhanceEndKey, //end key first stops at end of the text and then at the end of the line
          eoTabIndent];

    if ItemStyleCodeEditor.Checked then
      M.Options := M.Options + X
    else
      M.Options := M.Options - X;

    M.Gutter.ZeroStart := ItemStyleNormal.Checked;
end;

procedure TFrmNoteEditor.ItemSpecialCharsClick(Sender: TObject);
begin
    if ItemSpecialChars.Checked then
      M.Options := M.Options + [eoShowSpecialChars]
    else
      M.Options := M.Options - [eoShowSpecialChars];
end;

procedure TFrmNoteEditor.ItemWordWrapClick(Sender: TObject);
begin
    M.WordWrap := ItemWordWrap.Checked;
end;

procedure TFrmNoteEditor.ItemConfigClick(Sender: TObject);
var F: TFrmNoteEditorConfig;
begin
    F := TFrmNoteEditorConfig.Create(Application);
    try
      F.Lb.Font.Assign(M.Font);
      F.EdBgColor.Selected := M.Color;

      if F.ShowModal = mrOk then
      begin
          M.Font.Assign(F.Lb.Font);
          M.Color := F.EdBgColor.Selected;
      end;
    finally
      F.Free;
    end;
end;

procedure TFrmNoteEditor.ItemColorsClick(Sender: TObject);
var MI: TMenuItemSyn;
    F: TFrmNoteEditorColors;
begin
    if not Assigned(M.Highlighter) then
    begin
        ShowMessage('Please, first set an active language.');
        Exit;
    end;

    MI := LastSynMenuItem;

    F := TFrmNoteEditorColors.Create(Application);
    try
      F.LbLang.Caption := MI.LangDesc;
      F.SynEdit := M;
      if F.Run then
        M.Highlighter.SaveToRegistry(HKEY_CURRENT_USER, MI.PathReg);
    finally
      F.Free;
    end;
end;

procedure TFrmNoteEditor.BtnImportClick(Sender: TObject);
var D: TOpenTextFileDialog;
    S: TStringList;
begin
    D := TOpenTextFileDialog.Create(nil);
    try
      D.Title := 'Import from File';
      D.Filter := 'Text File|*.txt|All Files|*';

      if D.Execute then
      begin
          S := TStringList.Create;
          try
            S.LoadFromFile(D.FileName, D.Encodings.Objects[D.EncodingIndex] as TEncoding);

            M.SelText := S.Text;
          finally
            S.Free;
          end;
      end;

    finally
      D.Free;
    end;
end;

procedure TFrmNoteEditor.BtnExportClick(Sender: TObject);
var D: TSaveTextFileDialog;
begin
    D := TSaveTextFileDialog.Create(nil);
    try
      D.Title := 'Exportar to File';
      D.DefaultExt := 'txt';
      D.Filter := 'Text File|*.txt|All Files|*';

      if D.Execute then
        M.Lines.SaveToFile(D.FileName, D.Encodings.Objects[D.EncodingIndex] as TEncoding);

    finally
      D.Free;
    end;
end;

procedure TFrmNoteEditor.Action_OKExecute(Sender: TObject);
begin
    BtnOK.Click;
end;

procedure TFrmNoteEditor.BtnHelpClick(Sender: TObject);
begin
    ShellExecute(0, '', 'https://github.com/digao-dalpiaz/DzNoteEditor', '', '', SW_SHOWNORMAL);
end;

end.
