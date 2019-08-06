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
  JamesBase,
  JamesBase64Adapters,
  JamesTestCore,
  JamesTestPlatform;

type
  /// all tests for adapters
  TBase64AdapterTests = class(TTestCase)
  published
    procedure TestAllRawByteString;
  end;

implementation

{ TBase64AdapterTests }

const
  ENCODED_TEXT = 'SmFtZXMgTGli';
  DECODED_TEXT = 'James Lib';

procedure TBase64AdapterTests.TestAllRawByteString;
var
  adp: IRawByteStringOf;
begin
  adp := TBase64AsRawByteString.Create(ENCODED_TEXT);
  check(adp.Value = DECODED_TEXT, 'decoded');
  adp := TBase64OfRawByteString.Create(DECODED_TEXT);
  check(adp.Value = ENCODED_TEXT, 'encoded');
end;

initialization
  TTestSuite.Create('Base64').Ref
    .Add(TTest.Create(TBase64AdapterTests))

end.
