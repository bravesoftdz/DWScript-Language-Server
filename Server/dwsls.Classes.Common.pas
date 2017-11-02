unit dwsls.Classes.Common;

interface

uses
  Classes, dwsJSON, dwsUtils, dwsls.Classes.JSON;

type
  TDiagnosticSeverity = (
    dsUnknown = 0,
    dsError = 1,
    dsWarning = 2,
    dsInformation = 3,
    dsHint = 4
  );

  TMessageType = (
    msError = 1,
    msWarning = 2,
    msInfo = 3,
    msLog = 4
  );

  TTextDocumentSyncKind = (
    dsNone = 0,
    dsFull = 1,
    dsIncremental = 2
  );

  TErrorCodes = (
    ecParseError = -32700,
    ecInvalidRequest = -32600,
	  ecMethodNotFound = -32601,
	  ecInvalidParams = -32602,
	  ecInternalError = -32603,
	  ecserverErrorStart = -32099,
	  ecserverErrorEnd = -32000,
	  ecServerNotInitialized = -32002,
	  ecUnknownErrorCode = -32001,
	  ecRequestCancelled = -32800
  );

  TPosition = class(TJsonClass)
  private
    FLine: Integer;
    FCharacter: Integer;
  public
    constructor Create; overload;
    constructor Create(Line, Character: Integer); overload;

    procedure ReadFromJson(Value: TdwsJSONValue); override;
    procedure WriteToJson(Value: TdwsJSONObject); override;

    property Line: Integer read FLine write FLine;
    property Character: Integer read FCharacter write FCharacter;
  end;

  TRange = class(TJsonClass)
  private
    FStart: TPosition;
    FEnd: TPosition;
  public
    constructor Create;

    procedure ReadFromJson(Value: TdwsJSONValue); override;
    procedure WriteToJson(Value: TdwsJSONObject); override;

    property Start: TPosition read FStart;
    property &End: TPosition read FEnd;
  end;

  TLocation = class(TJsonClass)
  private
    FUri: string;
    FRange: TRange;
  public
    constructor Create;

    procedure ReadFromJson(Value: TdwsJSONValue); override;
    procedure WriteToJson(Value: TdwsJSONObject); override;

    property Uri: string read FUri write FUri;
    property Range: TRange read FRange write FRange;
  end;

  TDiagnostic = class(TJsonClass)
  type
    TCodeType = (ctNone, ctString, ctNumber);
  private
    FRange: TRange;
    FSeverity: TDiagnosticSeverity;
    FCodeString: string;
    FCodeValue: Integer;
    FCodeType: TCodeType;
    FSource: string;
    FMessage: string;
    procedure SetCodeString(const Value: string);
    procedure SetCodeValue(const Value: Integer);
  public
    constructor Create;

    procedure ReadFromJson(Value: TdwsJSONValue); override;
    procedure WriteToJson(Value: TdwsJSONObject); override;

    property Range: TRange read FRange write FRange;
    property Severity: TDiagnosticSeverity read FSeverity write FSeverity;
    property CodeAsString: string read FCodeString write SetCodeString;
    property CodeAsInteger: Integer read FCodeValue write SetCodeValue;
    property CodeType: TCodeType read FCodeType write FCodeType;
    property Source: string read FSource write FSource;
    property Message: string read FMessage write FMessage;
  end;

  TCommand = class(TJsonClass)
  private
    FTitle: string;
    FCommand: string;
    FArguments: TStringList;
  public
    constructor Create;

    procedure ReadFromJson(Value: TdwsJSONValue); override;
    procedure WriteToJson(Value: TdwsJSONObject); override;

    property Title: string read FTitle write FTitle;
    property Command: string read FCommand write FCommand;
    property Arguments: TStringList read FArguments;
  end;

  TTextEdit = class(TJsonClass)
  private
    FRange: TRange;
    FNewText: string;
  public
    constructor Create;

    procedure ReadFromJson(Value: TdwsJSONValue); override;
    procedure WriteToJson(Value: TdwsJSONObject); override;

    property Range: TRange read FRange;
    property NewText: string read FNewText write FNewText;
  end;

  TTextDocumentIdentifier = class(TJsonClass)
  private
    FUri: string;
  public
    procedure ReadFromJson(Value: TdwsJSONValue); override;
    procedure WriteToJson(Value: TdwsJSONObject); override;

    property Uri: string read FUri write FUri;
  end;

  TTextDocumentItem = class(TJsonClass)
  private
    FUri: string;
    FVersion: Integer;
    FLanguageId: string;
    FText: string;
  public
    procedure ReadFromJson(Value: TdwsJSONValue); override;
    procedure WriteToJson(Value: TdwsJSONObject); override;

    property Uri: string read FUri write FUri;
    property LanguageId: string read FLanguageId write FLanguageId;
    property Version: Integer read FVersion write FVersion;
    property Text: string read FText write FText;
  end;

  TVersionedTextDocumentIdentifier = class(TTextDocumentIdentifier)
  private
    FVersion: Integer;
  public
    procedure ReadFromJson(Value: TdwsJSONValue); override;
    procedure WriteToJson(Value: TdwsJSONObject); override;

    property Version: Integer read FVersion;
  end;

  TTextDocumentEdit = class(TJsonClass)
  type
    TTextEdits = TObjectList<TTextEdit>;
  private
    FTextDocument: TVersionedTextDocumentIdentifier;
    FEdits: TTextEdits;
  public
    constructor Create;

    procedure ReadFromJson(Value: TdwsJSONValue); override;
    procedure WriteToJson(Value: TdwsJSONObject); override;

    property TextDocument: TVersionedTextDocumentIdentifier read FTextDocument;
    property Edits: TTextEdits read FEdits write FEdits;
  end;

  TWorkspaceEdit = class(TJsonClass)
  type
    TTextDocumentEdits = TObjectList<TTextDocumentEdit>;
//    TChanges = TObjectList<TBlub>;
  private
//    FChanges: TChanges;
    FDocumentChanges: TTextDocumentEdits;
  public
    constructor Create;

    procedure ReadFromJson(Value: TdwsJSONValue); override;
    procedure WriteToJson(Value: TdwsJSONObject); override;

    property DocumentChanges: TTextDocumentEdits read FDocumentChanges;
  end;

  TDocumentFilter = class(TJsonClass)
  private
    FLanguage: string;
    FScheme: string;
    FPattern: string;
  public
    procedure ReadFromJson(Value: TdwsJSONValue); override;
    procedure WriteToJson(Value: TdwsJSONObject); override;

    property Language: string read FLanguage write FLanguage;
    property Scheme: string read FScheme write FScheme;
    property Pattern: string read FPattern write FPattern;
  end;

  TFileEvent = class(TJsonClass)
  type
    TFileChangeType = (fcCreated, fcChanged, fcDeleted);
  private
    FType: TFileChangeType;
    FUri: string;
  public
    procedure ReadFromJson(Value: TdwsJSONValue); override;
    procedure WriteToJson(Value: TdwsJSONObject); override;

    property Uri: string read FUri write FUri;
    property &Type: TFileChangeType read FType write FType;
  end;

implementation

uses
  dwsWebUtils;

{ TPosition }

constructor TPosition.Create;
begin
  // do nothing by default
end;

constructor TPosition.Create(Line, Character: Integer);
begin
  Create;
  FLine := Line;
  FCharacter := Character;
end;

procedure TPosition.ReadFromJson(Value: TdwsJSONValue);
begin
  FCharacter := Value['character'].AsInteger;
  FLine := Value['line'].AsInteger;
end;

procedure TPosition.WriteToJson(Value: TdwsJSONObject);
begin
  Value.AddValue('character', FCharacter);
  Value.AddValue('line', FLine);
end;


{ TRange }

constructor TRange.Create;
begin
  FStart := TPosition.Create;
  FEnd := TPosition.Create;
end;

procedure TRange.ReadFromJson(Value: TdwsJSONValue);
begin
  FStart.ReadFromJson(Value['start']);
  FEnd.ReadFromJson(Value['end']);
end;

procedure TRange.WriteToJson(Value: TdwsJSONObject);
begin
  FEnd.WriteToJson(Value.AddObject('end'));
  FStart.WriteToJson(Value.AddObject('start'));
end;


{ TLocation }

constructor TLocation.Create;
begin
  FRange := TRange.Create;
end;

procedure TLocation.ReadFromJson(Value: TdwsJSONValue);
begin
  FRange.ReadFromJson(Value['range']);
  FUri := WebUtils.DecodeURLEncoded(Value['uri'].AsString, 1);
end;

procedure TLocation.WriteToJson(Value: TdwsJSONObject);
begin
  FRange.WriteToJson(Value.AddObject('range'));
  Value['uri'].AsString := WebUtils.EncodeURLEncoded(FUri);
end;


{ TDiagnostic }

constructor TDiagnostic.Create;
begin
  FRange := TRange.Create;
end;

procedure TDiagnostic.ReadFromJson(Value: TdwsJSONValue);
begin
  FRange.ReadFromJson(Value['range']);
  FSource := Value['source'].AsString;
  if not Value['severity'].IsNull then
    FSeverity := TDiagnosticSeverity(Value['severity'].AsInteger);
  FMessage := Value['message'].AsString;
end;

procedure TDiagnostic.SetCodeString(const Value: string);
begin
  if FCodeString <> Value then
  begin
    FCodeString := Value;
    FCodeType := ctString;
  end;
end;

procedure TDiagnostic.SetCodeValue(const Value: Integer);
begin
  if FCodeValue <> Value then
  begin
    FCodeValue := Value;
    FCodeType := ctNumber;
  end;
end;

procedure TDiagnostic.WriteToJson(Value: TdwsJSONObject);
begin
  FRange.WriteToJson(Value.AddObject('range'));
  if FSeverity <> dsUnknown then
    Value.AddValue('severity', Integer(FSeverity));
  if FSource <> '' then
    Value.AddValue('source', FSource);
  Value.AddValue('message', FMessage);
end;


{ TCommand }

constructor TCommand.Create;
begin
  FArguments := TStringList.Create;
end;

procedure TCommand.ReadFromJson(Value: TdwsJSONValue);
var
  ArgumentArray: TdwsJSONArray;
  Index: Integer;
begin
  FTitle := Value['title'].AsString;
  FCommand := Value['command'].AsString;

  FArguments.Clear;

  // read arguments
  ArgumentArray := TdwsJSONArray(Value['arguments']);
  for Index := 0 to ArgumentArray.ElementCount - 1 do
    FArguments.Add(ArgumentArray.Elements[Index].AsString);
end;

procedure TCommand.WriteToJson(Value: TdwsJSONObject);
var
  ArgumentArray: TdwsJSONArray;
  Index: Integer;
begin
  Value['title'].AsString := FTitle;
  Value['command'].AsString := FCommand;
  ArgumentArray := TdwsJSONObject(Value).AddArray('arguments');
  for Index := 0 to FArguments.Count - 1 do
    ArgumentArray.AddValue.AsString := FArguments[Index];
end;


{ TTextEdits }

constructor TTextEdit.Create;
begin
  FRange := TRange.Create;
end;

procedure TTextEdit.ReadFromJson(Value: TdwsJSONValue);
begin
  FRange.ReadFromJson(Value['range']);
  FNewText := Value['newText'].AsString;
end;

procedure TTextEdit.WriteToJson(Value: TdwsJSONObject);
begin
  FRange.WriteToJson(Value.AddObject('range'));
  Value['newText'].AsString := FNewText;
end;


{ TTextDocumentIdentifier }

procedure TTextDocumentIdentifier.ReadFromJson(Value: TdwsJSONValue);
begin
  FUri := WebUtils.DecodeURLEncoded(Value['uri'].AsString, 1);
end;

procedure TTextDocumentIdentifier.WriteToJson(Value: TdwsJSONObject);
begin
  Value['uri'].AsString := WebUtils.EncodeURLEncoded(FUri);
end;


{ TTextDocumentItem }

procedure TTextDocumentItem.ReadFromJson(Value: TdwsJSONValue);
begin
  FUri := WebUtils.DecodeURLEncoded(Value['uri'].AsString, 1);
  FLanguageId := Value['languageId'].AsString;
  FVersion := Value['version'].AsInteger;
  FText := Value['text'].AsString;
end;

procedure TTextDocumentItem.WriteToJson(Value: TdwsJSONObject);
begin
  Value['uri'].AsString := WebUtils.EncodeURLEncoded(FUri);
  Value['languageId'].AsString := FLanguageId;
  Value['version'].AsInteger := FVersion;
  Value['text'].AsString := FText;
end;


{ TVersionedTextDocumentIdentifier }

procedure TVersionedTextDocumentIdentifier.ReadFromJson(Value: TdwsJSONValue);
begin
  inherited;
  FVersion := Value['version'].AsInteger;
end;

procedure TVersionedTextDocumentIdentifier.WriteToJson(Value: TdwsJSONObject);
begin
  inherited;
  Value['version'].AsInteger := FVersion;
end;


{ TTextDocumentEdit }

constructor TTextDocumentEdit.Create;
begin
  FTextDocument := TVersionedTextDocumentIdentifier.Create;
  FEdits := TTextEdits.Create;
end;

procedure TTextDocumentEdit.ReadFromJson(Value: TdwsJSONValue);
var
  TextEdit: TTextEdit;
  EditsArray: TdwsJSONArray;
  Index: Integer;
begin
  FTextDocument.ReadFromJson(Value['textDocument']);
  EditsArray := TdwsJSONArray(Value['edits']);
  for Index := 0 to EditsArray.ElementCount - 1 do
  begin
    TextEdit := TTextEdit.Create;
    TextEdit.ReadFromJson(EditsArray.Elements[Index]);
    FEdits.Add(TextEdit);
  end;
end;

procedure TTextDocumentEdit.WriteToJson(Value: TdwsJSONObject);
var
  EditsArray: TdwsJSONArray;
  EditItem: TdwsJSONObject;
  Index: Integer;
begin
  FTextDocument.WriteToJson(Value.AddObject('textDocument'));
  EditsArray :=  TdwsJSONObject(Value).AddArray('edits');
  for Index := 0 to FEdits.Count - 1 do
  begin
    EditItem := EditsArray.AddObject;
    FEdits[Index].WriteToJson(EditItem);
  end;
end;


{ TWorkspaceEdit }

constructor TWorkspaceEdit.Create;
begin
  inherited;

  FDocumentChanges := TTextDocumentEdits.Create;
end;

procedure TWorkspaceEdit.ReadFromJson(Value: TdwsJSONValue);
begin

end;

procedure TWorkspaceEdit.WriteToJson(Value: TdwsJSONObject);
begin

end;


{ TDocumentFilter }

procedure TDocumentFilter.ReadFromJson(Value: TdwsJSONValue);
begin
  FLanguage := Value['language'].AsString;
  FScheme := Value['scheme'].AsString;
  FPattern := Value['pattern'].AsString;
end;

procedure TDocumentFilter.WriteToJson(Value: TdwsJSONObject);
begin
  Value['language'].AsString := FLanguage;
  Value['scheme'].AsString := FScheme;
  Value['pattern'].AsString := FPattern;
end;


{ TFileEvent }

procedure TFileEvent.ReadFromJson(Value: TdwsJSONValue);
begin
  FUri := WebUtils.DecodeURLEncoded(Value['uri'].AsString, 1);
  FType := TFileChangeType(Value['type'].AsInteger);
end;

procedure TFileEvent.WriteToJson(Value: TdwsJSONObject);
begin
  Value['uri'].AsString := WebUtils.EncodeURLEncoded(FUri);
  Value['type'].AsInteger := Integer(FType);
end;


end.