{
  MIT License

  Copyright (c) 2017-2019 Marcos Douglas B. Santos

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
}
unit JamesDataCore;

{$i James.inc}

interface

uses
  Classes,
  SysUtils,
  DB,
  Variants,
  JamesDataBase;

type
  TDataStream = class(TInterfacedObject, IDataStream)
  private
    fStream: TMemoryStream;
  public
    constructor Create(aStream: TStream); reintroduce; overload;
    constructor Create(const aText: RawByteString); overload;
    constructor Create(aStrings: TStrings); overload;
    constructor Create; overload;
    destructor Destroy; override;
    function Ref: IDataStream;
    function Save(Stream: TStream): IDataStream; overload;
    function AsString: RawByteString;
    function Size: Int64;
  end;

  TDataStrings = class(TInterfacedObject, IDataStrings)
  private
    FStrings: TStrings;
  public
    constructor Create(const Stream: TStream);
    class function New(const Stream: IDataStream): IDataStrings; overload;
    class function New(const S: string): IDataStrings; overload;
    class function New: IDataStrings; overload;
    destructor Destroy; override;
    function Add(const Value: string): IDataStrings;
    function Get(Index: Integer): string;
    function Count: Integer;
    function Text: string;
  end;

  TDataParam = class(TInterfacedObject, IDataParam)
  private
    FParam: TParam;
  public
    constructor Create(const Name: string; DataType: TFieldType; Value: Variant); reintroduce;
    class function New(const Name: string; DataType: TFieldType; Value: Variant): IDataParam; overload;
    class function New(const Name: string; Value: Variant): IDataParam; overload;
    destructor Destroy; override;
    function Name: string;
    function DataType: TFieldType;
    function Value: Variant;
    function IsNull: Boolean;
    function AsParam: TParam;
    function AsBCD: Currency;
    function AsBlob: TBlobData;
    function AsBoolean: Boolean;
    function AsCurrency: Currency;
    function AsDate: TDateTime;
    function AsDateTime: TDateTime;
    function AsFloat: Double;
    function AsInteger: LongInt;
    function AsSmallInt: LongInt;
    function AsMemo: string;
    function AsString: string;
    function AsWideString: WideString;
    function AsTime: TDateTime;
    function AsWord: LongInt;
  end;

  EDataParams = class(EDataException);

  TDataParams = class(TInterfacedObject, IDataParams)
  private
    FList: TInterfaceList;
  public
    constructor Create; virtual;
    class function New: IDataParams; overload;
    class function New(Origin: TFields): IDataParams; overload;
    destructor Destroy; override;
    function Exists(const ParamName: string): Boolean;
    function Add(const AParam: IDataParam): IDataParams; overload;
    function Add(const AParams: IDataParams): IDataParams; overload;
    function Get(Index: Integer): IDataParam; overload;
    function Get(const ParamName: string): IDataParam; overload;
    function Count: Integer;
    function SaveAs(aDest: TParams): IDataParams;
    function AsString(const SeparatorChar: string): string; overload;
    function AsString: string; overload;
  public type
    TAggregate = class(TAggregatedObject, IDataParams)
    private
      FOrigin: IDataParams;
    public
      constructor Create(const AController: IInterface; Origin: IDataParams); reintroduce;
      function Exists(const ParamName: string): Boolean;
      function Add(const AParam: IDataParam): IDataParams; overload;
      function Add(const AParams: IDataParams): IDataParams; overload;
      function Get(Index: Integer): IDataParam; overload;
      function Get(const ParamName: string): IDataParam; overload;
      function Count: Integer;
      function SaveAs(aDest: TParams): IDataParams;
      function AsString(const SeparatorChar: string): string; overload;
      function AsString: string; overload;
    end;
  end;

  TDataGuid = class(TInterfacedObject, IDataGuid)
  private
    FGuid: TGuid;
  public
    constructor Create(Guid: TGuid); reintroduce;
    class function New(Guid: TGuid): IDataGuid; overload;
    class function New(const Guid: string): IDataGuid; overload;
    class function New(Guid: Variant): IDataGuid; overload;
    class function New: IDataGuid; overload;
    function Value: TGuid;
    function AsString: string;
    function AsSmallString: string;
  end;

  TNullGuid = class(TInterfacedObject, IDataGuid)
  private
    FGuid: IDataGuid;
  public
    constructor Create; reintroduce;
    class function New: IDataGuid;
    function Value: TGuid;
    function AsString: string;
    function AsSmallString: string;
  end;

  TDataResult = class sealed(TInterfacedObject, IDataResult)
  private
    FSuccess: Boolean;
    FData: IDataParams;
  public
    constructor Create(Success: Boolean; const Data: IDataParams); reintroduce; overload;
    class function New(Success: Boolean; const Data: IDataParams): IDataResult; overload;
    class function New(Success: Boolean; const Data: IDataParam): IDataResult; overload;
    class function New(Success: Boolean): IDataResult; overload;
    function Success: Boolean;
    function Data: IDataParams;
  end;

  TDataConstraints = class(TInterfacedObject, IDataConstraint, IDataConstraints)
  private
    FList: IInterfaceList;
  public
    constructor Create;
    class function New: IDataConstraints;
    function Add(const AConstraint: IDataConstraint): IDataConstraints;
    function Get(Index: Integer): IDataConstraint;
    function Count: Integer;
    function Evaluate: IDataResult;
  end;

  TDataFile = class(TInterfacedObject, IDataFile)
  private
    FFileName: string;
    FStream: IDataStream;
  public
    constructor Create(const FileName: string; const Stream: IDataStream); reintroduce; overload;
    constructor Create(const FileName: string); overload;
    function Ref: IDataFile;
    function Path: string;
    function Name: string;
    function FileName: string;
    function Stream: IDataStream;
  end;

implementation

{ TDataStream }

constructor TDataStream.Create(aStream: TStream);
begin
  inherited Create;
  fStream := TMemoryStream.Create;
  if Assigned(aStream) then
    fStream.LoadFromStream(aStream);
end;

constructor TDataStream.Create(const aText: RawByteString);
var
  m: TStringStream;
begin
  m := TStringStream.Create(aText);
  try
    Create(m);
  finally
    m.Free;
  end;
end;

constructor TDataStream.Create(aStrings: TStrings);
var
  m: TMemoryStream;
begin
  m := TMemoryStream.Create;
  try
    aStrings.SaveToStream(m);
    Create(m);
  finally
    m.Free;
  end;
end;

constructor TDataStream.Create;
begin
  Create('');
end;

destructor TDataStream.Destroy;
begin
  fStream.Free;
  inherited Destroy;
end;

function TDataStream.Ref: IDataStream;
begin
  result := self;
end;

function TDataStream.Save(Stream: TStream): IDataStream;
begin
  Result := Self;
  fStream.SaveToStream(Stream);
  Stream.Position := 0;
end;

function TDataStream.AsString: RawByteString;
begin
  with fStream do
  begin
    Result := '';
    SetLength(Result, Size);
    Position := 0;
    ReadBuffer(Pointer(Result)^, Size);
  end;
end;

function TDataStream.Size: Int64;
begin
  Result := fStream.Size;
end;

{ TDataStrings }

constructor TDataStrings.Create(const Stream: TStream);
begin
  inherited Create;
  FStrings := TStringList.Create;
  FStrings.LoadFromStream(Stream);
end;

class function TDataStrings.New(const Stream: IDataStream): IDataStrings;
var
  M: TMemoryStream;
begin
  M := TMemoryStream.Create;
  try
    Stream.Save(M);
    Result := Create(M);
  finally
    M.Free;
  end;
end;

class function TDataStrings.New(const S: string): IDataStrings;
begin
  Result := New(TDataStream.Create(S));
end;

class function TDataStrings.New: IDataStrings;
begin
  Result := New('');
end;

destructor TDataStrings.Destroy;
begin
  FStrings.Free;
  inherited Destroy;
end;

function TDataStrings.Add(const Value: string): IDataStrings;
begin
  Result := Self;
  FStrings.Add(Value);
end;

function TDataStrings.Get(Index: Integer): string;
begin
  Result := FStrings.Strings[Index];
end;

function TDataStrings.Count: Integer;
begin
  Result := FStrings.Count;
end;

function TDataStrings.Text: string;
begin
  Result := FStrings.Text;
end;

{ TDataParam }

constructor TDataParam.Create(const Name: string; DataType: TFieldType; Value: Variant);
begin
  inherited Create;
  FParam := TParam.Create(nil);
  FParam.Name := Name;
  FParam.DataType := DataType;
  FParam.Value := Value;
end;

class function TDataParam.New(const Name: string; DataType: TFieldType; Value: Variant): IDataParam;
begin
  Result := Create(Name, DataType, Value);
end;

class function TDataParam.New(const Name: string; Value: Variant): IDataParam;
begin
  Result := New(Name, ftUnknown, Value);
end;

destructor TDataParam.Destroy;
begin
  FParam.Free;
  inherited;
end;

function TDataParam.Name: string;
begin
  Result := FParam.Name;
end;

function TDataParam.DataType: TFieldType;
begin
  Result := FParam.DataType;
end;

function TDataParam.Value: Variant;
begin
  Result := FParam.Value;
end;

function TDataParam.IsNull: Boolean;
begin
  Result := FParam.IsNull;
end;

function TDataParam.AsParam: TParam;
begin
  Result := FParam;
end;

function TDataParam.AsBCD: Currency;
begin
  Result := FParam.AsBCD;
end;

function TDataParam.AsBlob: TBlobData;
begin
  Result := FParam.AsBlob;
end;

function TDataParam.AsBoolean: Boolean;
begin
  Result := FParam.AsBoolean;
end;

function TDataParam.AsCurrency: Currency;
begin
  Result := FParam.AsCurrency;
end;

function TDataParam.AsDate: TDateTime;
begin
  Result := FParam.AsDate;
end;

function TDataParam.AsDateTime: TDateTime;
begin
  Result := FParam.AsDateTime;
end;

function TDataParam.AsFloat: Double;
begin
  Result := FParam.AsFloat;
end;

function TDataParam.AsInteger: LongInt;
begin
  Result := FParam.AsInteger;
end;

function TDataParam.AsSmallInt: LongInt;
begin
  Result := FParam.AsSmallInt;
end;

function TDataParam.AsMemo: string;
begin
  Result := FParam.AsMemo;
end;

function TDataParam.AsString: string;
begin
  Result := FParam.AsString;
end;

function TDataParam.AsWideString: WideString;
begin
  Result := FParam.AsWideString;
end;

function TDataParam.AsTime: TDateTime;
begin
  Result := FParam.AsTime;
end;

function TDataParam.AsWord: LongInt;
begin
  Result := FParam.AsWord;
end;

{ TDataParams }

constructor TDataParams.Create;
begin
  inherited Create;
  FList := TInterfaceList.Create;
end;

class function TDataParams.New: IDataParams;
begin
  Result := Create;
end;

class function TDataParams.New(Origin: TFields): IDataParams;
var
  I: Integer;
begin
  Result := Self.New;
  for I := 0 to Origin.Count -1 do
    with Origin[I] do
      Result.Add(TDataParam.New(FieldName, DataType, Value));
end;

destructor TDataParams.Destroy;
begin
  FList.Free;
  inherited;
end;

function TDataParams.Exists(const ParamName: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FList.Count -1 do
  begin
    if Get(I).Name = ParamName then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TDataParams.Add(const AParam: IDataParam): IDataParams;
begin
  Result := Self;
  FList.Add(AParam);
end;

function TDataParams.Add(const AParams: IDataParams): IDataParams;
var
  I: Integer;
begin
  Result := Self;
  for I := 0 to AParams.Count-1 do
    Add(AParams.Get(I));
end;

function TDataParams.Get(Index: Integer): IDataParam;
begin
  Result := FList.Items[Index] as IDataParam;
end;

function TDataParams.Get(const ParamName: string): IDataParam;
var
  I: Integer;
  P: IDataParam;
begin
  P := nil;
  Result := nil;
  for I := 0 to FList.Count -1 do
  begin
    P := Get(I);
    if CompareText(P.Name, ParamName) = 0 then
    begin
      Result := P;
      Exit;
    end;
  end;
  if not Assigned(P) then
    raise EDataParams.CreateFmt('Param "%s" not found.', [ParamName]);
end;

function TDataParams.Count: Integer;
begin
  Result := FList.Count;
end;

function TDataParams.SaveAs(aDest: TParams): IDataParams;
var
  i: Integer;
  p: TParam;
begin
  Result := Self;
  if not assigned(aDest) then
    exit;
  for i := 0 to Count -1 do
  begin
    p := TParam.Create(aDest);
    with Get(i).AsParam do
    begin
      p.Name := Name;
      p.ParamType := ParamType;
      p.DataType := DataType;
      p.Value := Value;
    end;
  end;
end;

function TDataParams.AsString(const SeparatorChar: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Count-1 do
  begin
    if I > 0 then
      Result := Result + SeparatorChar;
     Result := Result + Get(I).AsString;
  end;
end;

function TDataParams.AsString: string;
begin
  Result := AsString(',');
end;

{ TDataParams.TAggregate }

constructor TDataParams.TAggregate.Create(const AController: IInterface;
  Origin: IDataParams);
begin
  inherited Create(AController);
  FOrigin := Origin;
end;

function TDataParams.TAggregate.Exists(const ParamName: string): Boolean;
begin
  Result := FOrigin.Exists(ParamName);
end;

function TDataParams.TAggregate.Add(const AParam: IDataParam): IDataParams;
begin
  Result := FOrigin.Add(AParam);
end;

function TDataParams.TAggregate.Add(const AParams: IDataParams): IDataParams;
begin
  Result := FOrigin.Add(AParams);
end;

function TDataParams.TAggregate.Get(Index: Integer): IDataParam;
begin
  Result := FOrigin.Get(Index);
end;

function TDataParams.TAggregate.Get(const ParamName: string): IDataParam;
begin
  Result := FOrigin.Get(ParamName);
end;

function TDataParams.TAggregate.Count: Integer;
begin
  Result := FOrigin.Count;
end;

function TDataParams.TAggregate.SaveAs(aDest: TParams): IDataParams;
begin
  Result := FOrigin.SaveAs(aDest);
end;

function TDataParams.TAggregate.AsString(const SeparatorChar: string): string;
begin
  Result := FOrigin.AsString(SeparatorChar);
end;

function TDataParams.TAggregate.AsString: string;
begin
  Result := FOrigin.AsString;
end;

{ TDataGuid }

constructor TDataGuid.Create(Guid: TGuid);
begin
  inherited Create;
  FGuid := Guid;
end;

class function TDataGuid.New(Guid: TGuid): IDataGuid;
begin
  Result := Create(Guid);
end;

class function TDataGuid.New(const Guid: string): IDataGuid;
var
  S: string;
begin
  S := Guid;
  if Copy(S, 1, 1) <> '{' then
    S := '{' + S + '}';
  try
    Result := New(StringToGuid(S));
  except
    Result := TNullGuid.New;
  end;
end;

class function TDataGuid.New(Guid: Variant): IDataGuid;
begin
  if VarIsStr(Guid) then
    Result := New(VarToStr(Guid))
  else
    Result := TNullGuid.New;
end;

class function TDataGuid.New: IDataGuid;
var
  G: TGUID;
  S: string;
begin
  CreateGUID(G);
  S := GUIDToString(G);
  Result := New(Copy(S, 2, Length(S)-2));
end;

function TDataGuid.Value: TGuid;
begin
  Result := FGuid;
end;

function TDataGuid.AsString: string;
begin
  Result := GuidToString(FGuid);
end;

function TDataGuid.AsSmallString: string;
begin
  Result := Copy(AsString, 2, 8);
end;

{ TNullGuid }

constructor TNullGuid.Create;
begin
  inherited Create;
  FGuid := TDataGuid.New('{00000000-0000-0000-0000-000000000000}');
end;

class function TNullGuid.New: IDataGuid;
begin
  Result := Create;
end;

function TNullGuid.Value: TGuid;
begin
  Result := FGuid.Value;
end;

function TNullGuid.AsString: string;
begin
  Result := FGuid.AsString;
end;

function TNullGuid.AsSmallString: string;
begin
  Result := FGuid.AsString;
end;

{ TDataResult }

constructor TDataResult.Create(Success: Boolean; const Data: IDataParams);
begin
  inherited Create;
  FSuccess := Success;
  FData := Data;
end;

class function TDataResult.New(Success: Boolean; const Data: IDataParams
  ): IDataResult;
begin
  Result := Create(Success, Data);
end;

class function TDataResult.New(Success: Boolean; const Data: IDataParam
  ): IDataResult;
begin
  Result := New(Success, TDataParams.New.Add(Data))
end;

class function TDataResult.New(Success: Boolean): IDataResult;
begin
  Result := New(Success, TDataParams.New);
end;

function TDataResult.Success: Boolean;
begin
  Result := FSuccess;
end;

function TDataResult.Data: IDataParams;
begin
  Result := FData;
end;

{ TDataConstraints }

constructor TDataConstraints.Create;
begin
  inherited Create;
  FList := TInterfaceList.Create;
end;

class function TDataConstraints.New: IDataConstraints;
begin
  Result := Create;
end;

function TDataConstraints.Add(const AConstraint: IDataConstraint
  ): IDataConstraints;
begin
  Result := Self;
  FList.Add(AConstraint);
end;

function TDataConstraints.Get(Index: Integer): IDataConstraint;
begin
  Result := FList.Items[Index] as IDataConstraint;
end;

function TDataConstraints.Count: Integer;
begin
  Result := FList.Count;
end;

function TDataConstraints.Evaluate: IDataResult;
var
  I: Integer;
  Ok: Boolean;
  R: IDataResult;
  Params: IDataParams;
begin
  Ok := True;
  Params := TDataParams.New;
  for I := 0 to Count-1 do
  begin
    R := Get(I).Evaluate;
    if not R.Success then
      Ok := False;
    Params.Add(R.Data);
  end;
  Result := TDataResult.New(Ok, Params);
end;

{ TDataFile }

constructor TDataFile.Create(const FileName: string; const Stream: IDataStream);
begin
  inherited Create;
  FFileName := FileName;
  FStream := Stream;
end;

constructor TDataFile.Create(const FileName: string);
begin
  Create(FileName, TDataStream.Create);
end;

function TDataFile.Ref: IDataFile;
begin
  result := self;
end;

function TDataFile.Path: string;
begin
  Result := SysUtils.ExtractFilePath(FFileName);
end;

function TDataFile.Name: string;
begin
  Result := SysUtils.ExtractFileName(FFileName);
end;

function TDataFile.FileName: string;
begin
  Result := FFileName;
end;

function TDataFile.Stream: IDataStream;
var
  Buf: TFileStream;
begin
  if FStream.Size > 0 then
  begin
    Result := FStream;
    Exit;
  end;
  if not FileExists(FFileName) then
    raise EFileNotFoundException.CreateFmt('File "%s" not found', [FFileName]);
  Buf := TFileStream.Create(FFileName, fmOpenRead);
  try
    Result := TDataStream.Create(Buf);
  finally
    Buf.Free;
  end;
end;

end.
