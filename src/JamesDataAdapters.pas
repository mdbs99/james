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
  Classes,
  SysUtils,
  COMObj,
  Variants,
  DB,
  DateUtils,
  SynCommons,
  JamesDataBase;

type
  /// object to adapt a DataStream into other types
  TDataStreamAdapter = {$ifdef UNICODE}record{$else}object{$endif}
  private
    fOrigin: IDataStream;
  public
    /// initialize the instance
    procedure Init(const aOrigin: IDataStream);
    /// return as OleVariant
    function AsOleVariant: OleVariant;
    /// adapt to TParam
    // - aDest should exist
    procedure ToParam(const aDest: TParam);
    /// adapt to TStrings
    // - aDest should exist
    procedure ToStrings(const aDest: TStrings);
  end;

  TDataParamsAdapter = {$ifdef UNICODE}record{$else}object{$endif}
  private
    fOrigin: IDataParams;
  public
    /// initialize the instance
    procedure Init(const aOrigin: IDataParams);
    /// adapt to TParams
    // - aDest should exist
    procedure ToParams(const aDest: TParams);
  end;

implementation

{ TDataStreamAdapter }

procedure TDataStreamAdapter.Init(const aOrigin: IDataStream);
begin
  fOrigin := aOrigin;
end;

function TDataStreamAdapter.AsOleVariant: OleVariant;
var
  data: PByteArray;
  m: TMemoryStream;
begin
  m := TMemoryStream.Create;
  try
    fOrigin.Save(m);
    result := VarArrayCreate([0, m.Size-1], varByte);
    data := VarArrayLock(Result);
    try
      m.Position := 0;
      m.ReadBuffer(data^, m.Size);
    finally
      VarArrayUnlock(Result);
    end;
  finally
    m.Free;
  end;
end;

procedure TDataStreamAdapter.ToParam(const aDest: TParam);
var
  m: TMemoryStream;
begin
  if not assigned(aDest) then
    exit;
  m := TMemoryStream.Create;
  try
    fOrigin.Save(m);
    aDest.LoadFromStream(m, ftBlob);
  finally
    m.Free;
  end;
end;

procedure TDataStreamAdapter.ToStrings(const aDest: TStrings);
var
  m: TMemoryStream;
begin
  if not assigned(aDest) then
    exit;
  m := TMemoryStream.Create;
  try
   fOrigin.Save(m);
   aDest.LoadFromStream(m);
  finally
    m.Free;
  end;
end;

{ TDataParamsAdapter }

procedure TDataParamsAdapter.Init(const aOrigin: IDataParams);
begin
  fOrigin := aOrigin;
end;

procedure TDataParamsAdapter.ToParams(const aDest: TParams);
var
  i: Integer;
  p: TParam;
begin
  if not assigned(aDest) then
    exit;
  for i := 0 to fOrigin.Count -1 do
  begin
    p := TParam.Create(aDest);
    with fOrigin.Get(i).AsParam do
    begin
      p.Name := Name;
      p.ParamType := ParamType;
      p.DataType := DataType;
      p.Value := Value;
    end;
  end;
end;

end.
