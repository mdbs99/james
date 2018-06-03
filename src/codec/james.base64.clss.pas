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
unit James.Base64.Clss;

{$i James.inc}

interface

uses
  Classes, SysUtils,
  {$ifdef FPC}
    James.Base64.FPC,
  {$else}
    James.Base64.Delphi,
  {$endif}
  James.Data.Base,
  James.Data.Clss;

type
  TBase64Encoder = TCBase64Encoder;

  TBase64Decoder = TCBase64Decoder;

  TBase64EncodedStream = class sealed(TInterfacedObject, IDataStream)
  private
    FOrigin: IDataStream;
    function Encode: IDataStream;
  public
    constructor Create(const Origin: IDataStream); reintroduce;
    class function New(const Origin: IDataStream): IDataStream;
    function Save(Stream: TStream): IDataStream; overload;
    function AsString: string;
    function Size: Int64;
  end;

  TBase64DecodedStream = class sealed(TInterfacedObject, IDataStream)
  private
    FOrigin: IDataStream;
    function Decode: IDataStream;
  public
    constructor Create(const Origin: IDataStream); reintroduce;
    class function New(const Origin: IDataStream): IDataStream;
    function Save(Stream: TStream): IDataStream; overload;
    function AsString: string;
    function Size: Int64;
  end;

implementation

{ TBase64EncodedStream }

function TBase64EncodedStream.Encode: IDataStream;
var
  Buf1, Buf2: TStringStream;
begin
  Buf2 := nil;
  Buf1 := TStringStream.Create('');
  try
    FOrigin.Save(Buf1);
    Buf1.Position := soFromBeginning;
    Buf2 := TStringStream.Create(
      TBase64Encoder.New(Buf1.DataString).Value
    );
    Result := TDataStream.New(Buf2);
  finally
    Buf1.Free;
    Buf2.Free;
  end;
end;

constructor TBase64EncodedStream.Create(const Origin: IDataStream);
begin
  inherited Create;
  FOrigin := Origin;
end;

class function TBase64EncodedStream.New(const Origin: IDataStream): IDataStream;
begin
  Result := Create(Origin);
end;

function TBase64EncodedStream.Save(Stream: TStream): IDataStream;
begin
  Result := Encode.Save(Stream);
end;

function TBase64EncodedStream.AsString: string;
begin
  Result := Trim(Encode.AsString);
end;

function TBase64EncodedStream.Size: Int64;
begin
  Result := Encode.Size;
end;

{ TBase64DecodedStream }

function TBase64DecodedStream.Decode: IDataStream;
var
  Buf1, Buf2: TStringStream;
begin
  Buf2 := nil;
  Buf1 := TStringStream.Create('');
  try
    FOrigin.Save(Buf1);
    Buf1.Position := soFromBeginning;
    Buf2 := TStringStream.Create(
      TBase64Decoder.New(Buf1.DataString).Value
    );
    Result := TDataStream.New(Buf2);
  finally
    Buf1.Free;
    Buf2.Free;
  end;
end;

constructor TBase64DecodedStream.Create(const Origin: IDataStream);
begin
  inherited Create;
  FOrigin := Origin;
end;

class function TBase64DecodedStream.New(const Origin: IDataStream): IDataStream;
begin
  Result := Create(Origin);
end;

function TBase64DecodedStream.Save(Stream: TStream): IDataStream;
begin
  Result := Decode.Save(Stream);
end;

function TBase64DecodedStream.AsString: string;
begin
  Result := Trim(Decode.AsString);
end;

function TBase64DecodedStream.Size: Int64;
begin
  Result := Decode.Size;
end;

end.
