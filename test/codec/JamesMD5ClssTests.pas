{
  MIT License

  Copyright (c) 2017-2019 Marcos Douglas B. Santos

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
unit JamesMD5ClssTests;

{$i James.inc}

interface

uses
  Classes, SysUtils,
  JamesDataClss,
  JamesMD5Clss,
  JamesTestingClss;

type
  TMD5HashTest = class(TTestCase)
  published
    procedure TestHashByMd5HashGeneratorPage;
  end;

  TMD5StreamTest = class(TTestCase)
  published
    procedure TestStreamFromMemory;
  end;

implementation

{ TMD5HashTest }

procedure TMD5HashTest.TestHashByMd5HashGeneratorPage;
const
  VALUE: string = 'http://www.md5hashgenerator.com/';
  VALUE_HASH: string = '93d1d8f5025cefe0fb747a6809a8405a';
begin
  CheckEquals(
    VALUE_HASH,
    TMD5Encoder.New(VALUE).Adapted
  );
end;

{ TMD5StreamTest }

procedure TMD5StreamTest.TestStreamFromMemory;
const
  TXT: string = 'ABCABEC~#ABCABEC~#10#13xyz';
begin
  CheckEquals(
    TMD5Encoder.New(TXT).Adapted,
    TMD5EncodedStream.New(
      TDataStream.New(TXT)
    ).AsString
  );
end;

initialization
  TTestSuite.New('Codec.MD5')
    .Add(TTest.New(TMD5HashTest))
    .Add(TTest.New(TMD5StreamTest));

end.
