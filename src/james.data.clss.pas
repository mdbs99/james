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

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Variants,
  James.Data;

type
  TDataStream = class sealed(TInterfacedObject, IDataStream)
  private
    FStream: TMemoryStream;
  public
    constructor Create(Stream: TStream);
    constructor Create(const S: string);
    class function New(Stream: TStream): IDataStream;
    class function New(const S: string): IDataStream;
    class function New(Strings: TStrings): IDataStream;
    class function New: IDataStream; overload;
    destructor Destroy; override;
    function Save(Stream: TStream): IDataStream;
    function Save(Strings: TStrings): IDataStream;
    function Save(const FileName: string): IDataStream;
    function AsString: string;
    function Size: Int64;
  end;

  TDataStreamAsAggregated = class sealed(TAggregatedObject, IDataStream)
  private
    FOrigin: IDataStream;
  public
    constructor Create(const aController: IUnknown; Origin: IDataStream);
    function Save(Stream: TStream): IDataStream;
    function Save(Strings: TStrings): IDataStream;
    function Save(const FileName: string): IDataStream;
    function AsString: string;
    function Size: Int64;
  end;

  TDataResult = class sealed(TInterfacedObject, IDataResult)
  private
    FValue: Variant;
    FMessage: string;
  public
    constructor Create(Value: Variant; const Message: string);
    class function New(Value: Variant; const Message: string): IDataResult;
    function Value: Variant;
    function AsBoolean: Boolean;
    function Message: string;
  end;

  TDataParams = class(TInterfacedObject, IDataParams)
  private
    FParams: TParams;
  public
    constructor Create;
    class function New: IDataParams; overload;
    class function New(Origin: TFields): IDataParams; overload;
    destructor Destroy; override;
    function Add(Param: TParam): IDataParams; overload;
    function Add(const ParamName: string; DataType: TFieldType; Value: Variant): IDataParams; overload;
    function Param(Index: Integer): TParam; overload;
    function Param(const ParamName: string): TParam; overload;
    function Count: Integer;
    function AsString(const SeparatorChar: string): string; overload;
    function AsString: string; overload;
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

{ TDataResult }

constructor TDataResult.Create(Value: Variant; const Message: string);
begin
  inherited Create;
  FValue := Value;
  FMessage := Message;
end;

class function TDataResult.New(Value: Variant; const Message: string
  ): IDataResult;
begin
  Result := Create(Value, Message);
end;

function TDataResult.Value: Variant;
begin
  Result := FValue;
end;

function TDataResult.AsBoolean: Boolean;
begin
  if VarIsNull(FValue) then
    Result := False
  else
    Result := FValue;
end;

function TDataResult.Message: string;
begin
  Result := FMessage;
end;

{ TDataParams }

constructor TDataParams.Create;
begin
  inherited Create;
  FParams := TParams.Create;
end;

class function TDataParams.New: IDataParams;
begin
  Result := Create;
end;

class function TDataParams.New(Origin: TFields): IDataParams;
var
  I: Integer;
begin
  Result := Create;
  for I := 0 to Origin.Count -1 do
    with Origin[I] do
      Result.Add(FieldName, DataType, Value);
end;

destructor TDataParams.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

function TDataParams.Add(Param: TParam): IDataParams;
begin
  Result := Self;
  FParams.AddParam(Param);
end;

function TDataParams.Add(const ParamName: string; DataType: TFieldType;
  Value: Variant): IDataParams;
var
  P: TParam;
begin
  Result := Self;
  P := TParam.Create(nil);
  P.Name := ParamName;
  P.DataType := DataType;
  P.Value := Value;
  Add(P);
end;

function TDataParams.Param(Index: Integer): TParam;
begin
  Result := FParams.Items[Index];
end;

function TDataParams.Param(const ParamName: string): TParam;
begin
  Result := FParams.FindParam(ParamName);
  if not Assigned(Result) then
    raise Exception.CreateFmt('Param "%s" not found.', [ParamName]);
end;

function TDataParams.Count: Integer;
begin
  Result := FParams.Count;
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

end.

