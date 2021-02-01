{------------------------------------------------------------------------------
TDzNotepad component
Developed by Rodrigo Depine Dalpiaz (digao dalpiaz)
Non visual component to store TStrings at DFM file

https://github.com/digao-dalpiaz/DzNoteEditor

Please, read the documentation at GitHub link.
------------------------------------------------------------------------------}

unit DzNotepad;

interface

uses System.Classes;

type TDzNotepad = class(TComponent)
  private
    FAbout: string;

    S: TStrings;
    procedure SetLines(const Value: TStrings);

    function GetCount: Integer;
    function GetText: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Text: string read GetText;
    property Count: Integer read GetCount;

    procedure Add(const A: string);
    procedure Sort;
    procedure Clear;
    function Has(const A: string): Boolean;
    function AddIfNotEx(const A: string): Boolean;
  published
    property About: string read FAbout;
    property Lines: TStrings read S write SetLines;
  end;

implementation

const STR_VERSION = '1.5';

constructor TDzNotepad.Create(AOwner: TComponent);
begin
    inherited;

    FAbout := 'Digao Dalpiaz / Version '+STR_VERSION;

    S := TStringList.Create;
end;

destructor TDzNotepad.Destroy;
begin
    S.Free;
    inherited;
end;

procedure TDzNotepad.SetLines(const Value: TStrings);
begin
    S.Assign(Value);
end;

function TDzNotepad.GetCount: Integer;
begin
    Result := S.Count;
end;

procedure TDzNotepad.Sort;
begin
    TStringList(S).Sort;
end;

procedure TDzNotepad.Add(const A: string);
begin
    S.Add(A);
end;

function TDzNotepad.GetText: string;
begin
    Result := S.Text;
end;

procedure TDzNotepad.Clear;
begin
    S.Clear;
end;

function TDzNotepad.Has(const A: string): Boolean;
begin
    Result := ( S.IndexOf(A) <> (-1) );
end;

function TDzNotepad.AddIfNotEx(const A: string): Boolean;
begin
    Result := not Has(A);
    if Result then Add(A);
end;

end.
