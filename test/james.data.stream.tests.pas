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
unit James.Data.Stream.Tests;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Laz2_DOM, fpcunit, testregistry, md5,
  James.Data,
  James.Data.Clss,
  James.Data.XML.Clss,
  James.Data.Stream.Clss,
  James.Files.Clss,
  James.Tests.Clss;

type
  TStreamBase64Test = class(TTestCase)
  published
    procedure AsString;
    procedure SaveStream;
    procedure SaveStrings;
  end;

  TStreamDividedTest = class(TTestCase)
  published
    procedure StreamFromMemory;
    procedure StreamFromFile;
  end;

  TStreamPartialFromTextTest = class(TTestCase)
  published
    procedure StreamFromMemory;
    procedure StreamFromFile;
  end;

  TStreamMD5Test = class(TTestCase)
  published
    procedure StreamFromMemory;
  end;

implementation

uses synacode;

{ TStreamBase64Test }

procedure TStreamBase64Test.AsString;
const
  TXT = 'AÉIOÚ123456qwert';
var
  Buf: TMemoryStream;
  Ss: TStrings;
begin
  Buf := TMemoryStream.Create;
  Ss := TStringList.Create;
  try
    Buf.WriteBuffer(TXT[1], Length(TXT) * SizeOf(Char));
    Ss.Text := TXT;
    AssertEquals(
      'Test Stream',
      EncodeBase64(TXT),
      TStreamBase64.New(TDataStream.New(Buf)).AsString
    );
    AssertEquals(
      'Test String',
      EncodeBase64(TXT),
      TStreamBase64.New(TDataStream.New(TXT)).AsString
    );
    AssertEquals(
      'Test Strings',
      EncodeBase64(TXT+#13#10),
      TStreamBase64.New(TDataStream.New(Ss)).AsString
    );
  finally
    Buf.Free;
    Ss.Free;
  end;
end;

procedure TStreamBase64Test.SaveStream;
const
  TXT = 'ÁBCDÉFG#13#10IJL';
var
  Buf: TMemoryStream;
  S: string;
begin
  Buf := TMemoryStream.Create;
  try
    TStreamBase64.New(TDataStream.New(TXT)).Save(Buf);
    SetLength(S, Buf.Size);
    Buf.Position := 0;
    Buf.ReadBuffer(S[1], Buf.Size);
    AssertEquals(EncodeBase64(TXT), S);
  finally
    Buf.Free;
  end;
end;

procedure TStreamBase64Test.SaveStrings;
const
  TXT = 'ÁBCDÉFG#13#10IJLMNO-PQRS';
var
  Ss: TStrings;
begin
  Ss := TStringList.Create;
  try
    TStreamBase64.New(TDataStream.New(TXT)).Save(Ss);
    AssertEquals(EncodeBase64(TXT), Trim(Ss.Text));
  finally
    Ss.Free;
  end;
end;

{ TStreamDividedTest }

procedure TStreamDividedTest.StreamFromMemory;
const
  TXT = 'ABCÁBCÉÇÇ~#ABCÁBCÉÇÇ~#ABCÁBCÉÇÇ~#ABCÁBCÉÇÇ~#ABCÁBCÉÇÇ#58';
  PART = 11;
var
  I: Integer;
  M1: TMemoryStream;
  M2: TMemoryStream;
begin
  M1 := TMemoryStream.Create;
  M2 := TMemoryStream.Create;
  try
    M1.WriteBuffer(TXT[1], Length(TXT) * SizeOf(Char));
    for I := 1 to PART do
    begin
      with TStreamDivided.New(TDataStream.New(M1), I, PART) do
        M2.WriteBuffer(AsString[1], Size);
    end;
    AssertEquals('Compare Size: ', M1.Size, M2.Size);
    AssertEquals('Compare Content: ', TDataStream.New(M1).AsString, TDataStream.New(M2).AsString);
  finally
    M1.Free;
    M2.Free;
  end;
end;

procedure TStreamDividedTest.StreamFromFile;
var
  I: Integer;
  Part: Integer;
  Template: TXMLComponent;
  M1: TMemoryStream;
  M2: TMemoryStream;
  Node: TDOMNode;
begin
  Template := TXMLComponent.Create(TJamesTestsTemplateFile.New.Stream);
  try
    Node :=
      Template
        .Document
        .DocumentElement
        .FindNode(Self.ClassName)
        .FindNode('files')
        .ChildNodes
        .Item[0];
    while Assigned(Node) do
    begin
      M1 := TMemoryStream.Create;
      M2 := TMemoryStream.Create;
      try
        TFile.New(
          Node.Attributes.GetNamedItem('filename').TextContent
        )
        .Stream
        .Save(M1);
        Part := StrToInt(Node.Attributes.GetNamedItem('part').TextContent);
        for I := 1 to Part do
        begin
          with TStreamDivided.New(TDataStream.New(M1), I, Part) do
            M2.WriteBuffer(AsString[1], Size);
        end;
        AssertEquals(
          'Compare Size: ', M1.Size, M2.Size);
        AssertEquals(
          'Compare Content: ',
          TDataStream.New(M1).AsString,
          TDataStream.New(M2).AsString
        );
        Node := Node.NextSibling;
      finally
        M1.Free;
        M2.Free;
      end;
    end;
  finally
    Template.Free;
  end;
end;

{ TStreamPartialFromTextTest }

procedure TStreamPartialFromTextTest.StreamFromMemory;
const
  STR_PART = 'Ç~#ABCÁ#10#13BCÉÇÇ#58';
  TXT = 'ABCÁBCÉÇÇ~#ABCÁBCÉÇÇ~#ABCÁBCÉÇÇ~#ABCÁBCÉÇ%%EOF' + STR_PART;
var
  M1: TMemoryStream;
  M2: TMemoryStream;
begin
  M1 := TMemoryStream.Create;
  M2 := TMemoryStream.Create;
  try
    M1.WriteBuffer(TXT[1], Length(TXT) * SizeOf(Char));
    with TStreamPartialFromText.New(TDataStream.New(M1), STR_PART) do
      M2.WriteBuffer(AsString[1], Size);
    AssertEquals('Compare Size: ', Length(STR_PART) * SizeOf(Char), M2.Size);
    AssertEquals('Compare Content: ', TDataStream.New(STR_PART).AsString, TDataStream.New(M2).AsString);
  finally
    M1.Free;
    M2.Free;
  end;
end;

procedure TStreamPartialFromTextTest.StreamFromFile;
var
  M1: TMemoryStream;
  Template: TXMLComponent;
  Node: TDOMNode;
  TextAttr: string;
begin
  Template := TXMLComponent.Create(TJamesTestsTemplateFile.New.Stream);
  try
    Node :=
      Template
        .Document
        .DocumentElement
        .FindNode(Self.ClassName)
        .FindNode('files')
        .ChildNodes
        .Item[0];
    while Assigned(Node) do
    begin
      M1 := TMemoryStream.Create;
      TextAttr := Node.Attributes.GetNamedItem('text').TextContent;
      try
        TFile.New(
          Node.Attributes.GetNamedItem('filename').TextContent
        )
        .Stream
        .Save(M1);
        with TStreamPartialFromText.New(TDataStream.New(M1), TextAttr) do
        begin
          AssertEquals(
            'Compare Content: ',
            Copy(AsString, 1, Length(TextAttr) * SizeOf(Char)),
            TextAttr
          );
        end;
        Node := Node.NextSibling;
      finally
        M1.Free;
      end;
    end;
  finally
    Template.Free;
  end;
end;

{ TStreamMD5Test }

procedure TStreamMD5Test.StreamFromMemory;
const
  TXT = 'ABCÁBCÉÇÇ~#ABCÁBCÉÇÇ~#10#13xyz';
begin
  AssertEquals(MD5Print(MD5String(TXT)), TStreamMD5.New(TDataStream.New(TXT)).AsString);
end;

initialization
  RegisterTest('Data.Stream', TStreamBase64Test);
  RegisterTest('Data.Stream', TStreamDividedTest);
  RegisterTest('Data.Stream', TStreamPartialFromTextTest);
  RegisterTest('Data.Stream', TStreamMD5Test);

end.
