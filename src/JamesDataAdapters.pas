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
  TDataStreamAdapter = {$ifdef UNICODE}record{$else}object{$endif}
  private
    fOrigin: IDataStream;
  public
    procedure Init(const aOrigin: IDataStream);
    function AsOleVariant: OleVariant;
    function AsBase64Encoded: RawByteString;
    function AsBase64Decoded: RawByteString;
    procedure ToParam(const aDest: TParam);
    procedure ToStrings(const aDest: TStrings);
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

function TDataStreamAdapter.AsBase64Encoded: RawByteString;
var
  m: TMemoryStream;
begin
  m := TMemoryStream.Create;
  try
    fOrigin.Save(m);
    result := BinToBase64(StreamToRawByteString(m));
  finally
    m.Free;
  end;
end;

function TDataStreamAdapter.AsBase64Decoded: RawByteString;
var
  m: TMemoryStream;
begin
  m := TMemoryStream.Create;
  try
    fOrigin.Save(m);
    result := Base64ToBin(StreamToRawByteString(m));
  finally
    m.Free;
  end;
end;

procedure TDataStreamAdapter.ToParam(const aDest: TParam);
var
  m: TMemoryStream;
begin
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
  m := TMemoryStream.Create;
  try
   fOrigin.Save(m);
   aDest.LoadFromStream(m);
  finally
    m.Free;
  end;
end;

end.
