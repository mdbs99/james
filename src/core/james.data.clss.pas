{
  MIT License

  Copyright (c) 2017-2018 Marcos Douglas B. Santos

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
  TDataStream = class(TInterfacedObject, IDataStream)
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
  public type
    TAggregated = class sealed(TAggregatedObject, IDataStream)
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
    function Add(const ParamName: string; DataType: TFieldType; Value: Variant): IDataParams; overload;
    function Add(const AParam: IDataParam): IDataParams; overload;
    function Add(const AParams: IDataParams): IDataParams; overload;
    function Get(Index: Integer): IDataParam; overload;
    function Get(const ParamName: string): IDataParam; overload;
    function Count: Integer;
    function AsString(const SeparatorChar: string): string; overload;
    function AsString: string; overload;
  public type
    TAggregate = class(TAggregatedObject, IDataParams)
    private
      FOrigin: IDataParams;
    public
      constructor Create(const AController: IInterface; Origin: IDataParams); reintroduce;
      function Add(const ParamName: string; DataType: TFieldType; Value: Variant): IDataParams; overload;
      function Add(const AParam: IDataParam): IDataParams; overload;
      function Add(const AParams: IDataParams): IDataParams; overload;
      function Get(Index: Integer): IDataParam; overload;
      function Get(const ParamName: string): IDataParam; overload;
      function Count: Integer;
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

{ TDataStream.TAggregated }

constructor TDataStream.TAggregated.Create(const aController: IUnknown;
  Origin: IDataStream);
begin
  inherited Create(aController);
  FOrigin := Origin;
end;

function TDataStream.TAggregated.Save(Stream: TStream): IDataStream;
begin
  Result := FOrigin.Save(Stream);
end;

function TDataStream.TAggregated.Save(Strings: TStrings): IDataStream;
begin
  Result := FOrigin.Save(Strings);
end;

function TDataStream.TAggregated.Save(const FileName: string): IDataStream;
begin
  Result := FOrigin.Save(FileName);
end;

function TDataStream.TAggregated.AsString: string;
begin
  Result := FOrigin.AsString;
end;

function TDataStream.TAggregated.Size: Int64;
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

function TDataParams.Add(const AParam: IDataParam): IDataParams;
begin
  Result := Self;
  FList.Add(AParam);
end;

function TDataParams.Add(const ParamName: string; DataType: TFieldType;
  Value: Variant): IDataParams;
begin
  Result := Self;
  FList.Add(TDataParam.New(ParamName, DataType, Value));
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

function TDataParams.TAggregate.Add(const ParamName: string; DataType: TFieldType;
  Value: Variant): IDataParams;
begin
  Result := FOrigin.Add(ParamName, DataType, Value);
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

end.
