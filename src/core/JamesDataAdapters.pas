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
unit JamesDataAdapters;

{$i James.inc}

interface

uses
  Classes, SysUtils, COMObj, Variants, DB,
  JamesCoreBase,
  JamesDataBase;

type
  TDataStreamAsOleVariant = class(TInterfacedObject, IAdapter<OleVariant>)
  private
    FValue: IDataStream;
  public
    constructor Create(const Value: IDataStream);
    class function New(const Value: IDataStream): IAdapter<OleVariant>;
    function Adapted: OleVariant;
  end;

  TDataStreamAsParam = class(TInterfacedObject, IAdapter<TParam>)
  private
    FSrc: IDataStream;
    FDest: TParam;
  public
    constructor Create(const Src: IDataStream; const Dest: TParam);
    class function New(const Src: IDataStream; const Dest: TParam): IAdapter<TParam>;
    function Adapted: TParam;
  end;

  TDataStreamAsStrings = class(TInterfacedObject, IAdapter<TStrings>)
  private
    FSrc: IDataStream;
    FDest: TStrings;
  public
    constructor Create(const Src: IDataStream; const Dest: TStrings);
    class function New(const Src: IDataStream; const Dest: TStrings): IAdapter<TStrings>;
    function Adapted: TStrings;
  end;

implementation

{ TDataStreamAsOleVariant }

constructor TDataStreamAsOleVariant.Create(const Value: IDataStream);
begin
  inherited Create;
  FValue := Value;
end;

class function TDataStreamAsOleVariant.New(const Value: IDataStream): IAdapter<OleVariant>;
begin
  Result := Create(Value);
end;

function TDataStreamAsOleVariant.Adapted: OleVariant;
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

{ TDataStreamAsParam }

constructor TDataStreamAsParam.Create(const Src: IDataStream;
  const Dest: TParam);
begin
  inherited Create;
  FSrc := Src;
  FDest := Dest;
end;

class function TDataStreamAsParam.New(const Src: IDataStream;
  const Dest: TParam): IAdapter<TParam>;
begin
  Result := Create(Src, Dest);
end;

function TDataStreamAsParam.Adapted: TParam;
var
  M: TMemoryStream;
begin
  Result := FDest;
  M := TMemoryStream.Create;
  try
   FSrc.Save(M);
   FDest.LoadFromStream(M, ftBlob);
  finally
    M.Free;
  end;
end;

{ TDataStreamAsStrings }

constructor TDataStreamAsStrings.Create(const Src: IDataStream;
  const Dest: TStrings);
begin
  inherited Create;
  FSrc := Src;
  FDest := Dest;
end;

class function TDataStreamAsStrings.New(const Src: IDataStream;
  const Dest: TStrings): IAdapter<TStrings>;
begin
  Result := Create(Src, Dest);
end;

function TDataStreamAsStrings.Adapted: TStrings;
var
  M: TMemoryStream;
begin
  Result := FDest;
  M := TMemoryStream.Create;
  try
   FSrc.Save(M);
   FDest.LoadFromStream(M);
  finally
    M.Free;
  end;
end;

end.
