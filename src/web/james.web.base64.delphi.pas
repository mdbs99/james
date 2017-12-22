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
unit James.Web.Base64.Delphi;

{$include james.inc}

interface

uses
  Classes, SysUtils,
  James.Data,
  James.Data.Clss;

type
  TCBase64Hash = class sealed(TInterfacedObject, IDataHash)
  private
    FValue: string;
  public
    constructor Create(const Value: string);
    class function New(const Value: string): IDataHash;
    function AsString: string;
  end;

implementation

{ TCBase64Hash }

constructor TCBase64Hash.Create(const Value: string);
begin
  inherited Create;
  FValue := Value;
end;

class function TCBase64Hash.New(const Value: string): IDataHash;
begin
  Result := Create(Value);
end;

function TCBase64Hash.AsString: string;
begin
  raise Exception.Create('TBase64Hash.AsString was not implemented yet');
end;

end.
