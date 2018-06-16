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
unit James.MD5.Clss;

{$i James.inc}

interface

uses
  Classes, SysUtils,
  James.Data.Base,
  James.Data.Clss,
  {$ifdef FPC}
    James.MD5.FPC
  {$else}
    James.MD5.Delphi
  {$endif}
  ;

type
  TMD5Encoder = class(TCMD5Encoder, IDataHash);

  TMD5EncodedStream = class sealed(TInterfacedObject, IDataStream)
  private
    FOrigin: IDataStream;
    function GetStream: IDataStream;
  public
    constructor Create(const Origin: IDataStream); reintroduce;
    class function New(const Origin: IDataStream): IDataStream;
    function Save(Stream: TStream): IDataStream; overload;
    function AsString: string;
    function Size: Int64;
  end;

implementation

{ TMD5EncodedStream }

function TMD5EncodedStream.GetStream: IDataStream;
begin
  Result := TDataStream.New(
    TMD5Encoder.New(FOrigin.AsString).Adapted
  );
end;

constructor TMD5EncodedStream.Create(const Origin: IDataStream);
begin
  inherited Create;
  FOrigin := Origin;
end;

class function TMD5EncodedStream.New(const Origin: IDataStream): IDataStream;
begin
  Result := Create(Origin);
end;

function TMD5EncodedStream.Save(Stream: TStream): IDataStream;
begin
  Result := GetStream.Save(Stream);
end;

function TMD5EncodedStream.AsString: string;
begin
  Result := GetStream.AsString;
end;

function TMD5EncodedStream.Size: Int64;
begin
  Result := GetStream.Size;
end;

end.
