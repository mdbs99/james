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
unit James.Core.Data.Adapters;

{$i James.inc}

interface

uses
  Classes, SysUtils, COMObj, Variants,
  James.Core.Base,
  James.Data.Base,
  James.Data.Clss;

type
  TOleVariantToStream = class(TInterfacedObject, IAdapter<IDataStream>)
  private
    FValue: OleVariant;
  public
    constructor Create(const Value: OleVariant);
    class function New(const Value: OleVariant): IAdapter<IDataStream>;
    function Value: IDataStream;
  end;

  TOleVariantFromStream = class(TInterfacedObject, IAdapter<OleVariant>)
  private
    FValue: IDataStream;
  public
    constructor Create(const Value: IDataStream);
    class function New(const Value: IDataStream): IAdapter<OleVariant>;
    function Value: OleVariant;
  end;

implementation

{ TOleVariantToStream }

constructor TOleVariantToStream.Create(const Value: OleVariant);
begin
  inherited Create;
  FValue := Value;
end;

class function TOleVariantToStream.New(const Value: OleVariant): IAdapter<IDataStream>;
begin
  Result := Create(Value);
end;

function TOleVariantToStream.Value: IDataStream;
var
  I: Integer;
  P: Pointer;
  S: TStream;
begin
  Assert(VarType(FValue) = varByte or varArray);
  Assert(VarArrayDimCount(FValue) = 1);
  S := TMemoryStream.Create;
  try
    I := VarArrayHighBound(FValue, 1) - VarArrayLowBound(FValue, 1) + 1;
    S.Size := I;
    S.Position := 0;
    P := VarArrayLock(FValue);
    try
      S.Write(P^, S.Size);
      Result := TDataStream.New(S);
    finally
      VarArrayUnlock(FValue);
    end;
  finally
    S.Free;
  end;
end;

{ TOleVariantFromStream }

constructor TOleVariantFromStream.Create(const Value: IDataStream);
begin
  inherited Create;
  FValue := Value;
end;

class function TOleVariantFromStream.New(const Value: IDataStream): IAdapter<OleVariant>;
begin
  Result := Create(Value);
end;

function TOleVariantFromStream.Value: OleVariant;
var
  Data: PByteArray;
  M: TMemoryStream;
begin
  M := TMemoryStream.Create;
  try
    FValue.Save(M);
    Result := VarArrayCreate([0, M.Size-1], varByte);
    Data := VarArrayLock(Result);
    try
      M.Position := 0;
      M.ReadBuffer(Data^, M.Size);
    finally
      VarArrayUnlock(Result);
    end;
  finally
    M.Free;
  end;
end;

end.
