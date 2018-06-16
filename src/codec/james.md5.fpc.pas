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
unit James.MD5.FPC;

{$include James.inc}

interface

uses
  Classes, SysUtils,
  md5,
  James.Data.Base;

type
  TCMD5Encoder = class(TInterfacedObject, IDataHash)
  private
    FValue: string;
  public
    constructor Create(const Value: string);
    class function New(const Value: string): IDataHash;
    function Adapted: string;
  end;

implementation

{ TCMD5Encoder }

constructor TCMD5Encoder.Create(const Value: string);
begin
  inherited Create;
  FValue := Value;
end;

class function TCMD5Encoder.New(const Value: string): IDataHash;
begin
  Result := Create(Value);
end;

function TCMD5Encoder.Adapted: string;
begin
  Result := MD5Print(
    MD5String(
      FValue
    )
  );
end;

end.
