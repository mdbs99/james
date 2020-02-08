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
unit JamesBase64Adapters;

{$i James.inc}

interface

uses
  Classes,
  SysUtils,
  SynCommons,
  JamesBase;

type
  /// BASE64 adapter for a decoded RawByteString
  TBase64AsRawByteString = class(TInterfacedObject, IRawByteStringOf)
  private
    fOrigin: RawByteString;
  public
    constructor Create(const aOrigin: RawByteString); reintroduce;
    function Ref: IRawByteStringOf;
    function Value: RawByteString;
  end;

  /// BASE64 adapter for a encoded RawByteString
  TBase64OfRawByteString = class(TInterfacedObject, IRawByteStringOf)
  private
    fOrigin: RawByteString;
  public
    constructor Create(const aOrigin: RawByteString); reintroduce;
    function Ref: IRawByteStringOf;
    function Value: RawByteString;
  end;

implementation

{ TBase64AsRawByteString }

constructor TBase64AsRawByteString.Create(const aOrigin: RawByteString);
begin
  inherited Create;
  fOrigin := aOrigin;
end;

function TBase64AsRawByteString.Ref: IRawByteStringOf;
begin
  result := self;
end;

function TBase64AsRawByteString.Value: RawByteString;
begin
  result := Base64ToBin(fOrigin);
end;

{ TBase64OfRawByteString }

constructor TBase64OfRawByteString.Create(const aOrigin: RawByteString);
begin
  inherited Create;
  fOrigin := aOrigin;
end;

function TBase64OfRawByteString.Ref: IRawByteStringOf;
begin
  result := self;
end;

function TBase64OfRawByteString.Value: RawByteString;
begin
  result := BinToBase64(fOrigin);
end;

end.
