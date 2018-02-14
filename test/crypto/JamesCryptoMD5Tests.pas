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
unit JamesCryptoMD5Tests;

{$include james.inc}

interface

uses
  Classes, SysUtils,
  JamesAPI,
  JamesCryptoAPI,
  JamesTestingClss;

type
  TMD5HashTest = class(TTestCase)
  published
    procedure HashByMd5HashGeneratorPage;
  end;

  TMD5StreamTest = class(TTestCase)
  published
    procedure StreamFromMemory;
  end;

implementation

{ TMD5HashTest }

procedure TMD5HashTest.HashByMd5HashGeneratorPage;
const
  VALUE: string = 'http://www.md5hashgenerator.com/';
  VALUE_HASH: string = '93d1d8f5025cefe0fb747a6809a8405a';
begin
  CheckEquals(
    VALUE_HASH,
    TMD5Hash.New(VALUE).AsString
  );
end;

{ TMD5StreamTest }

procedure TMD5StreamTest.StreamFromMemory;
const
  TXT: string = 'ABCABEC~#ABCABEC~#10#13xyz';
begin
  CheckEquals(
    TMD5Hash.New(TXT).AsString,
    TMD5Stream.New(
      TDataStream.New(TXT)
    ).AsString
  );
end;

initialization
  TTestSuite.New('Crypto.MD5')
    .Add(TTest.New(TMD5HashTest))
    .Add(TTest.New(TMD5StreamTest));

end.
