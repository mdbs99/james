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
unit James.Data.Tests;

{$include james.inc}

interface

uses
  Classes, SysUtils, Variants,
  James.API,
  James.Testing.Clss;

type
  TDataStreamTest = class(TTestCase)
  published
    procedure AsString;
    procedure SaveStream;
    procedure SaveStrings;
  end;

  TDataGuidTest = class(TTestCase)
  published
    procedure NewGuid;
    procedure NullGuid;
    procedure ValueAsVariant;
    procedure ValueWithoutBrackets;
    procedure SmallString;
  end;

  TDataInformationsTest = class(TTestCase)
  published
    procedure ReceiveInformation;
    procedure ReceiveInformations;
    procedure Counter;
  end;

implementation

{ TDataGuidTest }

procedure TDataGuidTest.NewGuid;
begin
  StringToGUID(TDataGuid.New.AsString);
end;

procedure TDataGuidTest.NullGuid;
begin
  CheckEquals(
    TNullGuid.New.AsString,
    TDataGuid.New('foo').AsString
  );
end;

procedure TDataGuidTest.ValueAsVariant;
begin
  CheckEquals(
    TNullGuid.New.AsString,
    TDataGuid.New(NULL).AsString
  );
end;

procedure TDataGuidTest.ValueWithoutBrackets;
const
  G: string = 'FCCE420A-8C4F-4E54-84D1-39001AE344BA';
begin
  CheckEquals(
    '{' + G + '}',
    TDataGuid.New(G).AsString
  );
end;

procedure TDataGuidTest.SmallString;
const
  V = '89000BC9';
  G = '{'+V+'-5700-43A3-B340-E34A1656F683}';
begin
  CheckEquals(
    V, TDataGuid.New(G).AsSmallString
  );
end;

{ TDataStreamTest }

procedure TDataStreamTest.AsString;
const
  TXT: string = 'Line1-'#13#10'Line2-'#13#10'Line3';
var
  Buf: TMemoryStream;
  Ss: TStrings;
begin
  Buf := TMemoryStream.Create;
  Ss := TStringList.Create;
  try
    Buf.WriteBuffer(TXT[1], Length(TXT) * SizeOf(Char));
    Ss.Text := TXT;
    CheckEquals(TXT, TDataStream.New(Buf).AsString, 'Test Stream');
    CheckEquals(TXT, TDataStream.New(TXT).AsString, 'Test String');
    CheckEquals(TXT+#13#10, TDataStream.New(Ss).AsString, 'Test Strings');
  finally
    Buf.Free;
    Ss.Free;
  end;
end;

procedure TDataStreamTest.SaveStream;
const
  TXT: string = 'ABCDEFG#13#10IJL';
var
  Buf: TMemoryStream;
  S: string;
begin
  Buf := TMemoryStream.Create;
  try
    TDataStream.New(TXT).Save(Buf);
    SetLength(S, Buf.Size * SizeOf(Char));
    Buf.Position := 0;
    Buf.ReadBuffer(S[1], Buf.Size);
    CheckEquals(TXT, S);
  finally
    Buf.Free;
  end;
end;

procedure TDataStreamTest.SaveStrings;
const
  TXT: string = 'ABCDEFG#13#10IJLMNO-PQRS';
var
  Ss: TStrings;
begin
  Ss := TStringList.Create;
  try
    TDataStream.New(TXT).Save(Ss);
    CheckEquals(TXT+#13#10, Ss.Text);
  finally
    Ss.Free;
  end;
end;

{ TDataInformationsTest }

procedure TDataInformationsTest.ReceiveInformation;
begin
  CheckEquals(
    'foo: data',
    TDataInformations.New
      .Add(TDataInformation.New('foo', 'data'))
      .Text
  );
end;

procedure TDataInformationsTest.ReceiveInformations;
begin
  CheckEquals(
    'foo: data 1'#13'foo: data 2'#13'foo: data 3',
    TDataInformations.New
      .Add(TDataInformation.New('foo', 'data 1'))
      .Add(TDataInformation.New('foo', 'data 2'))
      .Add(TDataInformation.New('foo', 'data 3'))
      .Text
  );
end;

procedure TDataInformationsTest.Counter;
begin
  CheckEquals(
    3,
    TDataInformations.New
      .Add(TDataInformation.New('foo'))
      .Add(TDataInformation.New('foo'))
      .Add(TDataInformation.New('foo'))
      .Count
  );
end;

initialization
  TTestSuite.New('Core.Data')
    .Add(TTest.New(TDataStreamTest))
    .Add(TTest.New(TDataGuidTest))
    .Add(TTest.New(TDataInformationsTest))
    ;

end.
