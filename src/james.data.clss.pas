{
  MIT License

  Copyright (c) 2017 Marcos Douglas B. Santos

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
unit James.Data.Clss;

{$include james.inc}

interface

uses
  Classes, SysUtils, DB, Variants,
  James.Data;

type
  TDataStream = class sealed(TInterfacedObject, IDataStream)
  private
    FStream: TMemoryStream;
  public
    constructor Create(Stream: TStream); overload;
    constructor Create(const S: string); overload;
    class function New(Stream: TStream): IDataStream; overload;
    class function New(const S: string): IDataStream; overload;
    class function New(Strings: TStrings): IDataStream; overload;
    class function New: IDataStream; overload;
    destructor Destroy; override;
    function Save(Stream: TStream): IDataStream; overload;
    function Save(Strings: TStrings): IDataStream; overload;
    function Save(const FileName: string): IDataStream; overload;
    function AsString: string;
    function Size: Int64;
  end;

  TDataStreamAsAggregated = class sealed(TAggregatedObject, IDataStream)
  private
    FOrigin: IDataStream;
  public
    constructor Create(const aController: IUnknown; Origin: IDataStream);
    function Save(Stream: TStream): IDataStream; overload;
    function Save(Strings: TStrings): IDataStream; overload;
    function Save(const FileName: string): IDataStream; overload;
    function AsString: string;
    function Size: Int64;
  end;

  TDataParam = class(TInterfacedObject, IDataParam)
  private
    FParam: TParam;
  public
    constructor Create(const Name: string; DataType: TFieldType; Value: Variant); reintroduce;
    class function New(const Name: string; DataType: TFieldType; Value: Variant): IDataParam;
    destructor Destroy; override;
    function Name: string;
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
    function AsTime: TDateTime;
    function AsWord: LongInt;
  end;

  EDataParams = class(Exception);

  TDataParams = class(TInterfacedObject, IDataParams)
  private
    FList: TInterfaceList;
  public
    constructor Create;
    class function New: IDataParams; overload;
    class function New(Origin: TFields): IDataParams; overload;
    destructor Destroy; override;
    function Add(Param: IDataParam): IDataParams; overload;
    function Add(const ParamName: string; DataType: TFieldType; Value: Variant): IDataParams; overload;
    function Param(Index: Integer): IDataParam; overload;
    function Param(const ParamName: string): IDataParam; overload;
    function Count: Integer;
    function AsString(const SeparatorChar: string): string; overload;
    function AsString: string; overload;
  end;

  TDataParamsAsAggregate = class(TAggregatedObject, IDataParams)
  private
    FOrigin: IDataParams;
  public
    constructor Create(const AController: IInterface; Origin: IDataParams); reintroduce;
    function Add(Param: IDataParam): IDataParams; overload;
    function Add(const ParamName: string; DataType: TFieldType; Value: Variant): IDataParams; overload;
    function Param(Index: Integer): IDataParam; overload;
    function Param(const ParamName: string): IDataParam; overload;
    function Count: Integer;
    function AsString(const SeparatorChar: string): string; overload;
    function AsString: string; overload;
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

implementation

{ TDataStream }

constructor TDataStream.Create(Stream: TStream);
begin
  inherited Create;
  FStream := TMemoryStream.Create;
  if Assigned(Stream) then
    FStream.LoadFromStream(Stream);
end;

constructor TDataStream.Create(const S: string);
var
  F: TStringStream;
begin
  F := TStringStream.Create(S);
  try
    Create(F);
  finally
    F.Free;
  end;
end;

class function TDataStream.New(Stream: TStream): IDataStream;
begin
  Result := Create(Stream);
end;

class function TDataStream.New(const S: string): IDataStream;
begin
  Result := Create(S);
end;

class function TDataStream.New(Strings: TStrings): IDataStream;
var
  Buf: TMemoryStream;
begin
  Buf := TMemoryStream.Create;
  try
    Strings.SaveToStream(Buf);
    Result := New(Buf);
  finally
    Buf.Free;
  end;
end;

class function TDataStream.New: IDataStream;
begin
  Result := New('');
end;

destructor TDataStream.Destroy;
begin
  FStream.Free;
  inherited Destroy;
end;

function TDataStream.Save(Stream: TStream): IDataStream;
begin
  Result := Self;
  FStream.SaveToStream(Stream);
  Stream.Position := 0;
end;

function TDataStream.Save(Strings: TStrings): IDataStream;
var
  Buf: TStream;
begin
  Result := Self;
  Buf := TMemoryStream.Create;
  try
    Save(Buf);
    Strings.LoadFromStream(Buf);
  finally
    Buf.Free;
  end;
end;

function TDataStream.Save(const FileName: string): IDataStream;
begin
  Result := Self;
  FStream.SaveToFile(FileName);
end;

function TDataStream.AsString: string;
begin
  with FStream do
  begin
    SetLength(Result, Size);
    Position := 0;
    ReadBuffer(Pointer(Result)^, Size);
  end;
end;

function TDataStream.Size: Int64;
begin
  Result := FStream.Size;
end;

{ TDataStreamAsAggregated }

constructor TDataStreamAsAggregated.Create(const aController: IUnknown;
  Origin: IDataStream);
begin
  inherited Create(aController);
  FOrigin := Origin;
end;

function TDataStreamAsAggregated.Save(Stream: TStream): IDataStream;
begin
  Result := FOrigin.Save(Stream);
end;

function TDataStreamAsAggregated.Save(Strings: TStrings): IDataStream;
begin
  Result := FOrigin.Save(Strings);
end;

function TDataStreamAsAggregated.Save(const FileName: string): IDataStream;
begin
  Result := FOrigin.Save(FileName);
end;

function TDataStreamAsAggregated.AsString: string;
begin
  Result := FOrigin.AsString;
end;

function TDataStreamAsAggregated.Size: Int64;
begin
  Result := FOrigin.Size;
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

destructor TDataParam.Destroy;
begin
  FParam.Free;
  inherited;
end;

function TDataParam.Name: string;
begin
  Result := FParam.Name;
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
      Result.Add(FieldName, DataType, Value);
end;

destructor TDataParams.Destroy;
begin
  FList.Free;
  inherited;
end;

function TDataParams.Add(Param: IDataParam): IDataParams;
begin
  Result := Self;
  FList.Add(Param);
end;

function TDataParams.Add(const ParamName: string; DataType: TFieldType;
  Value: Variant): IDataParams;
begin
  Result := Self;
  FList.Add(TDataParam.New(ParamName, DataType, Value));
end;

function TDataParams.Param(Index: Integer): IDataParam;
begin
  Result := FList.Items[Index] as IDataParam;
end;

function TDataParams.Param(const ParamName: string): IDataParam;
var
  I: Integer;
  P: IDataParam;
begin
  P := nil;
  Result := nil;
  for I := 0 to FList.Count -1 do
  begin
    P := Param(I);
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

function TDataParams.AsString(const SeparatorChar: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Count -1 do
  begin
    if I > 0 then
      Result := Result + SeparatorChar;
     Result := Result + Param(IntToStr(I)).AsString;
  end;
end;

function TDataParams.AsString: string;
begin
  Result := AsString(',');
end;

{ TDataParamsAsAggregate }

constructor TDataParamsAsAggregate.Create(const AController: IInterface;
  Origin: IDataParams);
begin
  inherited Create(AController);
  FOrigin := Origin;
end;

function TDataParamsAsAggregate.Add(Param: IDataParam): IDataParams;
begin
  Result := FOrigin.Add(Param);
end;

function TDataParamsAsAggregate.Add(const ParamName: string; DataType: TFieldType;
  Value: Variant): IDataParams;
begin
  Result := FOrigin.Add(ParamName, DataType, Value);
end;

function TDataParamsAsAggregate.Param(Index: Integer): IDataParam;
begin
  Result := FOrigin.Param(Index);
end;

function TDataParamsAsAggregate.Param(const ParamName: string): IDataParam;
begin
  Result := FOrigin.Param(ParamName);
end;

function TDataParamsAsAggregate.Count: Integer;
begin
  Result := FOrigin.Count;
end;

function TDataParamsAsAggregate.AsString(const SeparatorChar: string): string;
begin
  Result := FOrigin.AsString(SeparatorChar);
end;

function TDataParamsAsAggregate.AsString: string;
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

end.
