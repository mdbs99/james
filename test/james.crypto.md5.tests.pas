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

{$include james.inc}

interface

uses
  Classes, SysUtils, fpcunit, testregistry,
  James.Data,
  James.Data.Clss,
  James.Crypto.MD5.Clss;

type
  TMD5HashTest = class(TTestCase)
  published
    procedure HashComparison;
  end;

  TMD5StreamTest = class(TTestCase)
  published
    procedure StreamFromMemory;
  end;

implementation

{ TMD5HashTest }

procedure TMD5HashTest.HashComparison;
const
  VALUE = 'http://www.md5hashgenerator.com/';
  VALUE_HASH = '93d1d8f5025cefe0fb747a6809a8405a';
begin
  AssertEquals(
    VALUE_HASH,
    TMD5Hash.New(VALUE).AsString
  );
end;

{ TMD5StreamTest }

procedure TMD5StreamTest.StreamFromMemory;
const
  TXT = 'ABCABEC~#ABCABEC~#10#13xyz';
begin
  AssertEquals(
    TMD5Hash.New(TXT).AsString,
    TMD5Stream.New(
      TDataStream.New(TXT)
    ).AsString
  );
end;

initialization
  RegisterTestS(
    'Crypto', [
      TMD5HashTest,
      TMD5StreamTest
    ]
  );

end.
