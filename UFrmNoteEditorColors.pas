unit UFrmNoteEditorColors;

interface

uses Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Controls, SynEdit, Vcl.Buttons,
  System.Classes,
  //
  System.Types, SynEditHighlighter, Vcl.Graphics;

type
  TFrmNoteEditorColors = class(TForm)
    LbLang: TLabel;
    LbSel: TLabel;
    Preview: TSynEdit;
    L: TListBox;
    EdColorText: TColorBox;
    EdColorBg: TColorBox;
    Bevel1: TBevel;
    BtnBold: TSpeedButton;
    BtnItalic: TSpeedButton;
    BtnUnderline: TSpeedButton;
    BtnRestoreDefaults: TSpeedButton;
    BtnOK: TButton;
    BtnCancel: TButton;
    procedure LClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure OnAttributeChange(Sender: TObject);
    procedure BtnRestoreDefaultsClick(Sender: TObject);
  private
    H: TSynCustomHighlighter;
    ColorBgOriginal: TColor;
    procedure CheckCorSpace(A: TSynHighlighterAttributes);
    procedure CreateCopyOfSyn(CopiarFormatacao: Boolean);
  public
    SynEdit: TSynEdit;
    function Run: Boolean;
  end;

implementation

{$R *.dfm}

uses Vcl.Dialogs;

function TFrmNoteEditorColors.Run: Boolean;
begin
    L.Font.Assign(SynEdit.Font);
    L.Color := SynEdit.Color;

    Preview.Font.Assign(SynEdit.Font);
    Preview.Color := SynEdit.Color;

    ColorBgOriginal := SynEdit.Color;

    CreateCopyOfSyn(True); //create H as copy of Highlighter of SynEdit
    Preview.Text := H.SampleSource;

    Result := ShowModal = mrOk;
    if Result then
      SynEdit.Highlighter.Assign(H); //save syntax format
end;

procedure TFrmNoteEditorColors.CreateCopyOfSyn(CopiarFormatacao: Boolean);
var SynClass: TSynCustomHighlighterClass;
    I: Integer;
    A: TSynHighlighterAttributes;
begin
    SynClass := TSynCustomHighlighterClass(SynEdit.Highlighter.ClassType);
    H := SynClass.Create(Self); //create new class to use on this form
    if CopiarFormatacao then H.Assign(SynEdit.Highlighter);

    Preview.Highlighter := H;

    for I := 0 to H.AttrCount-1 do
    begin
        A := H.Attribute[I];

        L.Items.AddObject(A.FriendlyName, A);
        CheckCorSpace(A);
    end;
end;

procedure TFrmNoteEditorColors.FormShow(Sender: TObject);
begin
    L.Canvas.Font.Assign(L.Font);
    L.ItemHeight := L.Canvas.TextHeight('A') + 3;

    L.ItemIndex := 0;
    LClick(nil);
end;

procedure TFrmNoteEditorColors.LDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var A: TSynHighlighterAttributes;
begin
    L.Canvas.FillRect(Rect);

    A := TSynHighlighterAttributes( L.Items.Objects[Index] );

    if A.Background<>clNone then
      L.Canvas.Brush.Color := A.Background;

    if A.Foreground<>clNone then
      L.Canvas.Font.Color := A.Foreground;

    L.Canvas.Font.Style := A.Style;

    L.Canvas.TextOut(3, Rect.Top+1, L.Items[Index]);
end;

procedure TFrmNoteEditorColors.LClick(Sender: TObject);
var A: TSynHighlighterAttributes;
begin
    A := TSynHighlighterAttributes( L.Items.Objects[L.ItemIndex] );

    LbSel.Caption := A.FriendlyName;

    EdColorText.Selected := A.Foreground;
    EdColorBg.Selected := A.Background;

    BtnBold.Down := (fsBold in A.Style);
    BtnItalic.Down := (fsItalic in A.Style);
    BtnUnderline.Down := (fsUnderline in A.Style);
end;

procedure TFrmNoteEditorColors.OnAttributeChange(Sender: TObject);
var A: TSynHighlighterAttributes;
    Estilo: TFontStyles;
begin
    A := TSynHighlighterAttributes( L.Items.Objects[L.ItemIndex] );

    A.Foreground := EdColorText.Selected;
    A.Background := EdColorBg.Selected;

    Estilo := [];
    if BtnBold.Down then Include(Estilo, fsBold);
    if BtnItalic.Down then Include(Estilo, fsItalic);
    if BtnUnderline.Down then Include(Estilo, fsUnderline);
    A.Style := Estilo;

    CheckCorSpace(A);
    L.Invalidate;
end;

procedure TFrmNoteEditorColors.BtnRestoreDefaultsClick(Sender: TObject);
var Index: Integer;
begin
    if MessageDlg('Do you want to restore defaults?', mtConfirmation, mbYesNo, 0) = mrYes then
    begin
      Index := L.ItemIndex;

      L.Clear; //limpar atributos

      H.Free;
      CreateCopyOfSyn(False);

      L.ItemIndex := Index;
      LClick(nil);
    end;
end;

procedure TFrmNoteEditorColors.CheckCorSpace(A: TSynHighlighterAttributes);
begin
    if (A.Name = 'Space') or (A.Name = 'Whitespace') then
    begin
        if A.Background<>clNone then
          L.Color := A.Background
        else
          L.Color := ColorBgOriginal;
    end;
end;

end.
