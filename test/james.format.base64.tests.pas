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
unit James.Format.Base64.Tests;

{$include james.inc}

interface

uses
  Classes, SysUtils,
  James.Data,
  James.Data.Clss,
  James.Format.Base64.Clss,
  {$IFDEF FPC}
    fpcunit, testregistry, Laz2_DOM
  {$ELSE}
    TestFramework, XmlDoc, XmlIntf
  {$ENDIF};

type
  TBase64StreamTest = class(TTestCase)
  published
    procedure AsString;
    procedure SaveStream;
    procedure SaveStrings;
  end;

implementation

uses synacode;

{ TBase64StreamTest }

procedure TBase64StreamTest.AsString;
const
  TXT = 'AEIOU123456qwert';
var
  Buf: TMemoryStream;
  Ss: TStrings;
begin
  Buf := TMemoryStream.Create;
  Ss := TStringList.Create;
  try
    Buf.WriteBuffer(AnsiString(TXT)[1], Length(TXT));
    Ss.Text := TXT;
    CheckEquals(
      EncodeBase64(TXT),
      TBase64Stream.New(TDataStream.New(Buf)).AsString,
      'Test Stream'
    );
    CheckEquals(
      EncodeBase64(TXT),
      TBase64Stream.New(TDataStream.New(TXT)).AsString,
      'Test String'
    );
    CheckEquals(
      EncodeBase64(TXT+#13#10),
      TBase64Stream.New(TDataStream.New(Ss)).AsString,
      'Test Strings'
    );
  finally
    Buf.Free;
    Ss.Free;
  end;
end;

procedure TBase64StreamTest.SaveStream;
const
  TXT = 'ABCDEFG#13#10IJL';
var
  Buf: TMemoryStream;
  S: AnsiString;
begin
  Buf := TMemoryStream.Create;
  try
    TBase64Stream.New(TDataStream.New(TXT)).Save(Buf);
    SetLength(S, Buf.Size);
    Buf.Position := 0;
    Buf.ReadBuffer(S[1], Buf.Size);
    CheckEquals(EncodeBase64(TXT), S);
  finally
    Buf.Free;
  end;
end;

procedure TBase64StreamTest.SaveStrings;
const
  TXT = 'ABCDEFG#13#10IJLMNO-PQRS';
var
  Ss: TStrings;
begin
  Ss := TStringList.Create;
  try
    TBase64Stream.New(TDataStream.New(TXT)).Save(Ss);
    CheckEquals(EncodeBase64(TXT), Trim(Ss.Text));
  finally
    Ss.Free;
  end;
end;

initialization
  RegisterTest('Format', TBase64StreamTest{$IFNDEF FPC}.Suite{$ENDIF});

end.
