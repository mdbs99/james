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
unit JamesRTLAdapters;

{$i James.inc}

interface

uses
  Classes,
  SysUtils,
  COMObj,
  Variants,
  SynCommons,
  JamesDataBase,
  JamesDataCore;

type
  /// object to adapt an OleVariant into other types
  TOleVariantAdapter = {$ifdef UNICODE}record{$else}object{$endif}
  private
    fOrigin: OleVariant;
  public
    /// initialize the instance
    function Init(const aOrigin: OleVariant): TOleVariantAdapter;
    /// return as DataStream
    function AsDataStream: IDataStream;
  end;

implementation

{ TOleVariantAdapter }

function TOleVariantAdapter.Init(const aOrigin: OleVariant): TOleVariantAdapter;
begin
  result := self;
  fOrigin := aOrigin;
end;

function TOleVariantAdapter.AsDataStream: IDataStream;
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

end.
