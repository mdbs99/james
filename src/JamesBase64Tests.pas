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
unit JamesBase64Tests;

{$i James.inc}

interface

uses
  Classes,
  SysUtils,
  SynCommons,
  JamesDataBase,
  JamesDataCore,
  JamesBase64Adapters,
  JamesTestCore,
  JamesTestPlatform;

type
  /// all tests for TBase64Adapter
  TBase64AdapterTests = class(TTestCase)
  published
    procedure TestRawByteString;
    procedure TestDataStream;
  end;

implementation

{ TBase64AdapterTests }

const
  ENCODED_TEXT = 'SmFtZXMgTGli';
  DECODED_TEXT = 'James Lib';

procedure TBase64AdapterTests.TestRawByteString;
var
  a: TBase64Adapter;
begin
  a.Init(baDecode, ENCODED_TEXT);
  check(a.AsRawByteString = DECODED_TEXT, 'decoded');
  a.Init(baEncode, DECODED_TEXT);
  check(a.AsRawByteString = ENCODED_TEXT, 'encoded');
end;

procedure TBase64AdapterTests.TestDataStream;
var
  a: TBase64Adapter;
  s: IDataStream;
begin
  a.Init(baDecode, ENCODED_TEXT);
  s := TDataStream.Create(DECODED_TEXT);
  check(a.AsDataStream.AsRawByteString = s.AsRawByteString, 'decoded');
  a.Init(baEncode, DECODED_TEXT);
  s := TDataStream.Create(ENCODED_TEXT);
  check(a.AsDataStream.AsRawByteString = s.AsRawByteString, 'encoded');
end;

initialization
  TTestSuite.Create('Base64').Ref
    .Add(TTest.Create(TBase64AdapterTests))

end.
