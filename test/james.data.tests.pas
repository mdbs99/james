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
  Classes, SysUtils,
  James.Data,
  James.Data.Clss,
  {$IFDEF FPC}
    fpcunit, testregistry
  {$ELSE}
    TestFramework
  {$ENDIF};

type
  TDataStreamTest = class(TTestCase)
  published
    procedure AsString;
    procedure SaveStream;
    procedure SaveStrings;
  end;

implementation

{ TDataStreamTest }

procedure TDataStreamTest.AsString;
const
  TXT = 'Line1-'#13#10'Line2-'#13#10'Line3';
var
  Buf: TMemoryStream;
  Ss: TStrings;
begin
  Buf := TMemoryStream.Create;
  Ss := TStringList.Create;
  try
    Buf.WriteBuffer(AnsiString(TXT)[1], Length(TXT));
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
  TXT = 'ABCDEFG#13#10IJL';
var
  Buf: TMemoryStream;
  S: AnsiString;
begin
  Buf := TMemoryStream.Create;
  try
    TDataStream.New(TXT).Save(Buf);
    SetLength(S, Buf.Size);
    Buf.Position := 0;
    Buf.ReadBuffer(S[1], Buf.Size);
    CheckEquals(TXT, S);
  finally
    Buf.Free;
  end;
end;

procedure TDataStreamTest.SaveStrings;
const
  TXT = 'ABCDEFG#13#10IJLMNO-PQRS';
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

initialization
  RegisterTests(
    'Data', [
      TDataStreamTest{$IFNDEF FPC}.Suite{$ENDIF}
    ]
  );

end.
