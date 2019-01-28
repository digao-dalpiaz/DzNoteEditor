{------------------------------------------------------------------------------
TNotepad component
Developed by Rodrigo Depiné Dalpiaz (digão dalpiaz)
Non visual component to store TStrings at DFM file

https://github.com/digao-dalpiaz/NoteEditor

Please, read the documentation at GitHub link.
------------------------------------------------------------------------------}

unit Notepad;

interface

uses System.Classes;

type TNotepad = class(TComponent)
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

constructor TNotepad.Create(AOwner: TComponent);
begin
    inherited;

    FAbout := 'Digão Dalpiaz / Version 1.0';

    S := TStringList.Create;
end;

destructor TNotepad.Destroy;
begin
    S.Free;
    inherited;
end;

procedure TNotepad.SetLines(const Value: TStrings);
begin
    S.Assign(Value);
end;

function TNotepad.GetCount: Integer;
begin
    Result := S.Count;
end;

procedure TNotepad.Sort;
begin
    TStringList(S).Sort;
end;

procedure TNotepad.Add(const A: String);
begin
    S.Add(A);
end;

function TNotepad.GetText: String;
begin
    Result := S.Text;
end;

procedure TNotepad.Clear;
begin
    S.Clear;
end;

function TNotepad.Has(const A: String): Boolean;
begin
    Result := ( S.IndexOf(A) <> (-1) );
end;

function TNotepad.AddIfNotEx(const A: String): Boolean;
begin
    Result := not Has(A);
    if Result then Add(A);
end;

end.
