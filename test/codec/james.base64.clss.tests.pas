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
unit James.Base64.Clss.Tests;

{$i James.inc}

interface

uses
  Classes, SysUtils,
  James.Data.Base,
  James.Data.Clss,
  James.Base64.Clss,
  James.Testing.Clss;

type
  TBase64EncoderTest = class(TTestCase)
  published
    procedure TestValue;
  end;

  TBase64DecoderTest = class(TTestCase)
  published
    procedure TestValue;
  end;

  TBase64EncodedStreamTest = class(TTestCase)
  published
    procedure TestValue;
    procedure TestSaveStream;
    procedure TestSaveStrings;
  end;

  TBase64DecodedStreamTest = class(TTestCase)
  published
    procedure TestValue;
  end;

implementation

{ TBase64EncoderTest }

procedure TBase64EncoderTest.TestValue;
begin
  CheckEquals(
    'aHR0cHM6Ly93d3cuYmFzZTY0ZW5jb2RlLm9yZy8=',
    TBase64Encoder.New('https://www.base64encode.org/').AsString
  );
end;

{ TBase64DecoderTest }

procedure TBase64DecoderTest.TestValue;
begin
  CheckEquals(
    'https://www.base64encode.org/',
    TBase64Decoder.New('aHR0cHM6Ly93d3cuYmFzZTY0ZW5jb2RlLm9yZy8=').AsString
  );
end;

{ TBase64EncodedStreamTest }

procedure TBase64EncodedStreamTest.TestValue;
const
  TXT: string = 'AEIOU123456qwert';
var
  Buf: TMemoryStream;
  Ss: TStrings;
begin
  Buf := TMemoryStream.Create;
  Ss := TStringList.Create;
  try
    Buf.WriteBuffer(TXT[1], Length(TXT) * SizeOf(Char));
    Ss.Text := TXT;
    CheckEquals(
      TBase64Encoder.New(TXT).AsString,
      TBase64EncodedStream.New(TDataStream.New(Buf)).AsString,
      'Test Stream'
    );
    CheckEquals(
      TBase64Encoder.New(TXT).AsString,
      TBase64EncodedStream.New(TDataStream.New(TXT)).AsString,
      'Test String'
    );
    CheckEquals(
      TBase64Encoder.New(TXT+#13#10).AsString,
      TBase64EncodedStream.New(TDataStream.New(Ss)).AsString,
      'Test Strings'
    );
  finally
    Buf.Free;
    Ss.Free;
  end;
end;

procedure TBase64EncodedStreamTest.TestSaveStream;
const
  TXT: string = 'ABCDEFG#13#10IJL';
var
  Buf: TMemoryStream;
  S: string;
begin
  Buf := TMemoryStream.Create;
  try
    TBase64EncodedStream.New(TDataStream.New(TXT)).Save(Buf);
    SetLength(S, Buf.Size);
    Buf.Position := 0;
    Buf.ReadBuffer(S[1], Buf.Size);
    CheckEquals(TBase64Encoder.New(TXT).AsString, S);
  finally
    Buf.Free;
  end;
end;

procedure TBase64EncodedStreamTest.TestSaveStrings;
const
  TXT: string = 'ABCDEFG#13#10IJLMNO-PQRS';
var
  S: TStrings;
  M: TMemoryStream;
begin
  M := TMemoryStream.Create;
  S := TStringList.Create;
  try
    TBase64EncodedStream.New(TDataStream.New(TXT)).Save(M);
    S.LoadFromStream(M);
    CheckEquals(TBase64Encoder.New(TXT).AsString, Trim(S.Text));
  finally
    M.Free;
    S.Free;
  end;
end;

{ TBase64DecodedStreamTest }

procedure TBase64DecodedStreamTest.TestValue;
const
  VALUE = 'foo bar 123';
begin
  CheckEquals(
    TBase64Decoder.New(
      TBase64Encoder.New(
        VALUE
      ).AsString
    ).AsString,
    TBase64DecodedStream.New(
      TDataStream.New(
        TBase64Encoder.New(
          VALUE
        ).AsString
      )
    ).AsString
  );
end;

initialization
  TTestSuite.New('Codec.Base64')
    .Add(TTest.New(TBase64EncoderTest))
    .Add(TTest.New(TBase64DecoderTest))
    .Add(TTest.New(TBase64EncodedStreamTest))
    .Add(TTest.New(TBase64DecodedStreamTest))
    ;

end.
