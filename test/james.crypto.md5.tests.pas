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
unit James.Crypto.MD5.Tests;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, md5,
  James.Data,
  James.Data.Clss,
  James.Crypto.MD5.Clss;

type
  TMD5StreamTest = class(TTestCase)
  published
    procedure StreamFromMemory;
  end;

implementation

{ TMD5StreamTest }

procedure TMD5StreamTest.StreamFromMemory;
const
  TXT = 'ABCABEC~#ABCABEC~#10#13xyz';
begin
  AssertEquals(MD5Print(MD5String(TXT)), TMD5Stream.New(TDataStream.New(TXT)).AsString);
end;

initialization
  RegisterTest('Data.Stream', TMD5StreamTest);

end.
