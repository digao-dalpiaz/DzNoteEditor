unit UFrmNoteEditorConfig;

interface

uses Vcl.Forms, Vcl.Dialogs, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, System.Classes;

type
  TFrmNoteEditorConfig = class(TForm)
    BtnOK: TButton;
    BtnCancel: TButton;
    FD: TFontDialog;
    RzLabel1: TLabel;
    AlteraFonte: TSpeedButton;
    BoxPreview: TPanel;
    EdBgColor: TColorBox;
    Label1: TLabel;
    Bevel1: TBevel;
    Lb: TLabel;
    procedure AlteraFonteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EdBgColorChange(Sender: TObject);
  private
    procedure FillCaptionFonte;
  end;

implementation

{$R *.dfm}

uses System.SysUtils;

procedure TFrmNoteEditorConfig.FormShow(Sender: TObject);
begin
    FillCaptionFonte;
    EdBgColorChange(nil);
end;

procedure TFrmNoteEditorConfig.FillCaptionFonte;
begin
    Lb.Caption :=
      Format('%s, %d', [Lb.Font.Name, Lb.Font.Size]);
end;

procedure TFrmNoteEditorConfig.AlteraFonteClick(Sender: TObject);
begin
    FD.Font.Assign(Lb.Font);
    if FD.Execute then
    begin
        Lb.Font.Assign(FD.Font);
        FillCaptionFonte;
    end;
end;

procedure TFrmNoteEditorConfig.EdBgColorChange(Sender: TObject);
begin
    Lb.Color := EdBgColor.Selected;
end;

end.
