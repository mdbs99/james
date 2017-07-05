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
unit James.Format.Base64.Clss;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  synacode,
  James.Data,
  James.Data.Clss;

type
  TStreamBase64 = class sealed(TInterfacedObject, IDataStream)
  private
    FOrigin: IDataStream;
    function Base64Stream: IDataStream;
  public
    constructor Create(Origin: IDataStream); reintroduce;
    class function New(Origin: IDataStream): IDataStream;
    function Save(Stream: TStream): IDataStream; overload;
    function Save(const FileName: string): IDataStream; overload;
    function Save(Strings: TStrings): IDataStream; overload;
    function AsString: string;
    function Size: Int64;
  end;

implementation

{ TStreamBase64 }

function TStreamBase64.Base64Stream: IDataStream;
var
  Buf1, Buf2: TStringStream;
begin
  Buf2 := nil;
  Buf1 := TStringStream.Create('');
  try
    FOrigin.Save(Buf1);
    Buf1.Position := soFromBeginning;
    Buf2 := TStringStream.Create(EncodeBase64(Buf1.DataString));
    Result := TDataStream.New(Buf2);
  finally
    Buf1.Free;
    Buf2.Free;
  end;
end;

constructor TStreamBase64.Create(Origin: IDataStream);
begin
  inherited Create;
  FOrigin := Origin;
end;

class function TStreamBase64.New(Origin: IDataStream): IDataStream;
begin
  Result := Create(Origin);
end;

function TStreamBase64.Save(Stream: TStream): IDataStream;
begin
  Result := Base64Stream.Save(Stream);
end;

function TStreamBase64.Save(const FileName: string): IDataStream;
begin
  Result := Base64Stream.Save(FileName);
end;

function TStreamBase64.Save(Strings: TStrings): IDataStream;
begin
  Result := Base64Stream.Save(Strings);
end;

function TStreamBase64.AsString: string;
begin
  Result := Trim(Base64Stream.AsString);
end;

function TStreamBase64.Size: Int64;
begin
  Result := Base64Stream.Size;
end;

end.
