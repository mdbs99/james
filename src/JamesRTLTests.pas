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
unit JamesRTLTests;

{$i James.inc}

interface

uses
  Classes,
  SysUtils,
  COMObj,
  Variants,
  JamesDataBase,
  JamesDataCore,
  JamesDataAdapters,
  JamesRTLAdapters,
  JamesTestCore,
  JamesTestPlatform;

type
  /// all tests for TOleVariantAdapter
  TOleVariantAdapterTests = class(TTestCase)
  published
    procedure TestDataStream;
  end;

  TEnumAdapterTests = class(TTestCase)
  published
    procedure TestEnum;
    procedure TestEnumSet;
  end;

implementation

{ TOleVariantAdapterTests }

procedure TOleVariantAdapterTests.TestDataStream;
var
  v: OleVariant;
  sa: TDataStreamAdapter;
  va: TOleVariantAdapter;
begin
  sa.Init(TDataStream.Create('foo'));
  v := sa.AsOleVariant;
  va.Init(v);
  CheckEquals('foo', va.AsDataStream.AsRawByteString);
end;

{ TEnumAdapterTests }

type
  TFruit = (ftApple, ftOrange, ftBanana);

procedure TEnumAdapterTests.TestEnum;
var
  a: TEnumAdapter;
begin
  a.Init(TypeInfo(TFruit), ord(ftApple));
  check(a.AsShortString = 'ftApple', 'apple');
  a.TrimLowerCase := True;
  check(a.AsShortString = 'Apple', 'apple caption');
  a.Index := ord(ftOrange);
  a.TrimLowerCase := False;
  check(a.AsShortString = 'ftOrange', 'orange');
  a.TrimLowerCase := True;
  check(a.AsShortString = 'Orange', 'orange caption');
  a.Index := ord(ftBanana);
  check(a.AsShortString = 'Banana', 'banana caption');
end;

procedure TEnumAdapterTests.TestEnumSet;
var
  a: TEnumSetAdapter;
  arr: array[TFruit] of PShortString;
  ss: TStrings;
begin
  a.Init(TypeInfo(TFruit), @arr, Length(arr));
  check(arr[ftApple]^ = 'ftApple', 'apple');
  check(arr[ftOrange]^ = 'ftOrange', 'orange');
  check(arr[ftBanana]^ = 'ftBanana', 'banana');
  ss := TStringList.Create;
  try
    a.ToStrings(ss);
    check(ss[0] = 'ftApple', 'apple');
    check(ss[1] = 'ftOrange', 'orange');
    check(ss[2] = 'ftBanana', 'banana');
    a.TrimLowerCase := True;
    a.ToStrings(ss);
    check(ss[0] = 'Apple', 'Apple');
    check(ss[1] = 'Orange', 'Orange');
    check(ss[2] = 'Banana', 'Banana');
  finally
    ss.Free;
  end;
end;

initialization
  TTestSuite.Create('RTL')
    .Ref
    .Add(TTest.Create(TOleVariantAdapterTests))
    .Add(TTest.Create(TEnumAdapterTests))

end.
