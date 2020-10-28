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
    FAbout: String;

    S: TStrings;
    procedure SetLines(const Value: TStrings);

    function GetCount: Integer;
    function GetText: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Text: String read GetText;
    property Count: Integer read GetCount;

    procedure Add(const A: String);
    procedure Sort;
    procedure Clear;
    function Has(const A: String): Boolean;
    function AddIfNotEx(const A: String): Boolean;
  published
    property About: String read FAbout;
    property Lines: TStrings read S write SetLines;
  end;

implementation

constructor TDzNotepad.Create(AOwner: TComponent);
begin
    inherited;

    FAbout := 'Digao Dalpiaz / Version 1.2';

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

procedure TDzNotepad.Add(const A: String);
begin
    S.Add(A);
end;

function TDzNotepad.GetText: String;
begin
    Result := S.Text;
end;

procedure TDzNotepad.Clear;
begin
    S.Clear;
end;

function TDzNotepad.Has(const A: String): Boolean;
begin
    Result := ( S.IndexOf(A) <> (-1) );
end;

function TDzNotepad.AddIfNotEx(const A: String): Boolean;
begin
    Result := not Has(A);
    if Result then Add(A);
end;

end.
