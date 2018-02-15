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
unit JamesWebBase64Clss;

{$include james.inc}

interface

uses
  Classes, SysUtils,
  {$ifdef FPC}
    JamesWebBase64FPC,
  {$else}
    JamesWebBase64Delphi,
  {$endif}
  JamesData,
  JamesDataClss;

type
  TBase64Hash = TCBase64Hash;

  TBase64Stream = class sealed(TInterfacedObject, IDataStream)
  private
    FOrigin: IDataStream;
    function OriginAsBase64: IDataStream;
  public
    constructor Create(const Origin: IDataStream); reintroduce;
    class function New(const Origin: IDataStream): IDataStream;
    function Save(Stream: TStream): IDataStream; overload;
    function Save(const FileName: string): IDataStream; overload;
    function Save(Strings: TStrings): IDataStream; overload;
    function AsString: string;
    function Size: Int64;
  end;

implementation

{ TBase64Stream }

function TBase64Stream.OriginAsBase64: IDataStream;
var
  Buf1, Buf2: TStringStream;
begin
  Buf2 := nil;
  Buf1 := TStringStream.Create('');
  try
    FOrigin.Save(Buf1);
    Buf1.Position := soFromBeginning;
    Buf2 := TStringStream.Create(
      TBase64Hash.New(Buf1.DataString).AsString
    );
    Result := TDataStream.New(Buf2);
  finally
    Buf1.Free;
    Buf2.Free;
  end;
end;

constructor TBase64Stream.Create(const Origin: IDataStream);
begin
  inherited Create;
  FOrigin := Origin;
end;

class function TBase64Stream.New(const Origin: IDataStream): IDataStream;
begin
  Result := Create(Origin);
end;

function TBase64Stream.Save(Stream: TStream): IDataStream;
begin
  Result := OriginAsBase64.Save(Stream);
end;

function TBase64Stream.Save(const FileName: string): IDataStream;
begin
  Result := OriginAsBase64.Save(FileName);
end;

function TBase64Stream.Save(Strings: TStrings): IDataStream;
begin
  Result := OriginAsBase64.Save(Strings);
end;

function TBase64Stream.AsString: string;
begin
  Result := Trim(OriginAsBase64.AsString);
end;

function TBase64Stream.Size: Int64;
begin
  Result := OriginAsBase64.Size;
end;

end.
