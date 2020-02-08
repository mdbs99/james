{
  MIT License

  Copyright (c) 2017-2020 Marcos Douglas B. Santos

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
  Classes,
  SysUtils,
  COMObj,
  Variants,
  DB,
  DateUtils,
  SynCommons,
  JamesBase,
  JamesDataBase,
  JamesDataCore;

type
  /// DataStream adapter for Strings
  TDataStreamForStrings = class(TInterfacedObject, IDataAdapterFor)
  private
    fOrigin: IDataStream;
    fDest: TStrings;
  public
    constructor Create(const aOrigin: IDataStream; aDest: TStrings); reintroduce;
    function Ref: IDataAdapterFor;
    /// adapt for fDest reference
    procedure Adapt;
  end;

  /// DataStream adapter as an OleVariant
  TDataStreamAsOleVariant = class(TInterfacedObject, IVariantOf)
  private
    fOrigin: IDataStream;
  public
    constructor Create(const aOrigin: IDataStream); reintroduce;
    function Ref: IVariantOf;
    /// return as OleVariant
    function Value: Variant;
  end;

  /// DataStream adapter from an OleVariant
  TDataStreamOfOleVariant = class(TInterfacedObject, IDataStreamOf)
  private
    fOrigin: OleVariant;
  public
    constructor Create(const aOrigin: OleVariant); reintroduce;
    function Ref: IDataStreamOf;
    /// return as OleVariant
    function Value: IDataStream;
  end;

  /// DataParams adapter for a TParam
  TDataStreamForParam = class(TInterfacedObject, IDataAdapterFor)
  private
    fOrigin: IDataStream;
    fDest: TParam;
  public
    /// initialize the instance
    constructor Create(const aOrigin: IDataStream; const aDest: TParam); reintroduce;
    function Ref: IDataAdapterFor;
    /// adapt for fDest reference
    procedure Adapt;
  end;

  /// DataParams adapter for a TParams
  TDataParamsForParams = class(TInterfacedObject, IDataAdapterFor)
  private
    fOrigin: IDataParams;
    fDest: TParams;
  public
    /// initialize the instance
    constructor Create(const aOrigin: IDataParams; const aDest: TParams); reintroduce;
    function Ref: IDataAdapterFor;
    /// adapt for fDest reference
    procedure Adapt;
  end;

  /// DataTags adapter for an IRawUTF8ArrayOf
  TDataTagsAsRawUTF8Array = class(TInterfacedObject, IRawUTF8ArrayOf)
  private
    fOrigin: IDataTags;
  public
    constructor Create(const aOrigin: IDataTags); reintroduce;
    function Ref: IRawUTF8ArrayOf;
    /// return as TRawUTF8DynArray
    function Value: TRawUTF8DynArray;
  end;

implementation

{ TDataStreamForStrings }

constructor TDataStreamForStrings.Create(const aOrigin: IDataStream;
  aDest: TStrings);
begin
  inherited Create;
  fOrigin := aOrigin;
  fDest := aDest;
end;

function TDataStreamForStrings.Ref: IDataAdapterFor;
begin
  result := self;
end;

procedure TDataStreamForStrings.Adapt;
var
  m: TMemoryStream;
begin
  if not assigned(fDest) then
    exit;
  m := TMemoryStream.Create;
  try
   fOrigin.ToStream(m);
   fDest.LoadFromStream(m);
  finally
    m.Free;
  end;
end;

{ TDataStreamAsOleVariant }

constructor TDataStreamAsOleVariant.Create(const aOrigin: IDataStream);
begin
  inherited Create;
  fOrigin := aOrigin;
end;

function TDataStreamAsOleVariant.Ref: IVariantOf;
begin
  result := self;
end;

function TDataStreamAsOleVariant.Value: Variant;
var
  data: PByteArray;
  m: TMemoryStream;
begin
  m := TMemoryStream.Create;
  try
    fOrigin.ToStream(m);
    result := VarArrayCreate([0, m.Size-1], varByte);
    data := VarArrayLock(result);
    try
      m.Position := 0;
      m.ReadBuffer(data^, m.Size);
    finally
      VarArrayUnlock(result);
    end;
  finally
    m.Free;
  end;
end;

{ TDataStreamOfOleVariant }

constructor TDataStreamOfOleVariant.Create(const aOrigin: OleVariant);
begin
  inherited Create;
  fOrigin := aOrigin;
end;

function TDataStreamOfOleVariant.Ref: IDataStreamOf;
begin
  result := self;
end;

function TDataStreamOfOleVariant.Value: IDataStream;
var
  i: Integer;
  p: Pointer;
  s: TStream;
begin
  Assert(VarType(fOrigin) = varByte or varArray);
  Assert(VarArrayDimCount(fOrigin) = 1);
  s := TMemoryStream.Create;
  try
    i := VarArrayHighBound(fOrigin, 1) - VarArrayLowBound(fOrigin, 1) + 1;
    s.Size := i;
    s.Position := 0;
    p := VarArrayLock(fOrigin);
    try
      s.Write(p^, s.Size);
      result := TDataStream.Create(s);
    finally
      VarArrayUnlock(fOrigin);
    end;
  finally
    s.Free;
  end;
end;

{ TDataStreamForParam }

constructor TDataStreamForParam.Create(const aOrigin: IDataStream;
  const aDest: TParam);
begin
  inherited Create;
  fOrigin := aOrigin;
  fDest := aDest;
end;

function TDataStreamForParam.Ref: IDataAdapterFor;
begin
  result := self;
end;

procedure TDataStreamForParam.Adapt;
var
  m: TMemoryStream;
begin
  if not assigned(fDest) then
    exit;
  m := TMemoryStream.Create;
  try
    fOrigin.ToStream(m);
    fDest.LoadFromStream(m, ftBlob);
  finally
    m.Free;
  end;
end;

{ TDataParamsForParams }

constructor TDataParamsForParams.Create(const aOrigin: IDataParams;
  const aDest: TParams);
begin
  inherited Create;
  fOrigin := aOrigin;
  fDest := aDest;
end;

function TDataParamsForParams.Ref: IDataAdapterFor;
begin
  result := self;
end;

procedure TDataParamsForParams.Adapt;
var
  i: Integer;
  p: TParam;
begin
  if not assigned(fDest) then
    exit;
  for i := 0 to fOrigin.Count -1 do
  begin
    p := TParam.Create(fDest);
    with fOrigin.Get(i).AsParam do
    begin
      p.Name := Name;
      p.ParamType := ParamType;
      p.DataType := DataType;
      p.Value := Value;
    end;
  end;
end;

{ TDataTagsAsRawUTF8Array }

constructor TDataTagsAsRawUTF8Array.Create(const aOrigin: IDataTags);
begin
  inherited Create;
  fOrigin := aOrigin;
end;

function TDataTagsAsRawUTF8Array.Ref: IRawUTF8ArrayOf;
begin
  result := self;
end;

function TDataTagsAsRawUTF8Array.Value: TRawUTF8DynArray;
var
  i: Integer;
begin
  SetLength(result, fOrigin.Count);
  for i := 0 to fOrigin.Count -1 do
    result[i] := fOrigin.Get(i);
end;

end.
