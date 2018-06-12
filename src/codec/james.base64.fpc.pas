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
unit James.Base64.FPC;

{$include James.inc}

interface

uses
  Classes, SysUtils,
  synacode,
  James.Data.Base;

type
  TCBase64Encoder = class(TInterfacedObject, IDataHash)
  private
    FText: string;
  public
    constructor Create(const Text: string);
    class function New(const Text: string): IDataHash;
    function Adapted: string;
  end;

  TCBase64Decoder = class(TInterfacedObject, IDataHash)
  private
    FHash: string;
  public
    constructor Create(const Hash: string);
    class function New(const Hash: string): IDataHash;
    function Adapted: string;
  end;

implementation

{ TCBase64Encoder }

constructor TCBase64Encoder.Create(const Text: string);
begin
  inherited Create;
  FText := Text;
end;

class function TCBase64Encoder.New(const Text: string): IDataHash;
begin
  Result := Create(Text);
end;

function TCBase64Encoder.Adapted: string;
begin
  Result := synacode.EncodeBase64(FText);
end;

{ TCBase64Decoder }

constructor TCBase64Decoder.Create(const Hash: string);
begin
  inherited Create;
  FHash := Hash;
end;

class function TCBase64Decoder.New(const Hash: string): IDataHash;
begin
  Result := Create(Hash);
end;

function TCBase64Decoder.Adapted: string;
begin
  Result := synacode.DecodeBase64(FHash);
end;

end.
