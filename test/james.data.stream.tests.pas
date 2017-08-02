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

{$include james.inc}

interface

uses
  Classes, SysUtils,
  {$ifdef FPC}
    Laz2_DOM,
  {$else}
    XmlIntf,
  {$endif}
  James.Data,
  James.Data.Clss,
  James.Format.XML.Clss,
  James.Data.Stream.Clss,
  James.IO.Clss,
  James.Testing.Clss,
  James.Tests.Template.Clss;

type
  TDataDividedStreamTest = class(TTestCase)
  published
    procedure StreamFromMemory;
    procedure StreamFromFile;
  end;

  TDataPartialFromTextStreamTest = class(TTestCase)
  published
    procedure StreamFromMemory;
    procedure StreamFromFile;
  end;

implementation

{ TDataDividedStreamTest }

procedure TDataDividedStreamTest.StreamFromMemory;
const
  TXT = 'ABCABEC~ABCABEC~ABCABEC~ABCABEC~ABCABEC';
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
      with TDataDividedStream.New(TDataStream.New(M1), I, PART) do
        M2.WriteBuffer(AsString[1], Size);
    end;
    CheckEquals(M1.Size, M2.Size, 'Compare Size');
    CheckEquals(TDataStream.New(M1).AsString, TDataStream.New(M2).AsString, 'Compare Content');
  finally
    M1.Free;
    M2.Free;
  end;
end;

procedure TDataDividedStreamTest.StreamFromFile;
var
  I: Integer;
  Part: Integer;
  Template: TXMLComponent;
  M1: TMemoryStream;
  M2: TMemoryStream;
  Node: TDOMNode;
begin
  Template := TXMLComponent.Create(TTemplateFile.New.Stream);
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
          with TDataDividedStream.New(TDataStream.New(M1), I, Part) do
            M2.WriteBuffer(AsString[1], Size);
        end;
        CheckEquals(
          M1.Size, M2.Size, 'Compare Size');
        CheckEquals(
          TDataStream.New(M1).AsString,
          TDataStream.New(M2).AsString,
          'Compare Content'
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

{ TDataPartialFromTextStreamTest }

procedure TDataPartialFromTextStreamTest.StreamFromMemory;
const
  STR_PART = 'C~#ABCD#10#13ABCD#58';
  TXT = 'ABCD~ABCD~#ABCD~#ABCD%%EOF' + STR_PART;
var
  M1: TMemoryStream;
  M2: TMemoryStream;
begin
  M1 := TMemoryStream.Create;
  M2 := TMemoryStream.Create;
  try
    M1.WriteBuffer(TXT[1], Length(TXT) * SizeOf(Char));
    with TDataPartialFromTextStream.New(TDataStream.New(M1), STR_PART) do
      M2.WriteBuffer(AsString[1], Size);
    CheckEquals(Length(STR_PART) * SizeOf(Char), M2.Size, 'Compare Size');
    CheckEquals(TDataStream.New(STR_PART).AsString, TDataStream.New(M2).AsString, 'Compare Content');
  finally
    M1.Free;
    M2.Free;
  end;
end;

procedure TDataPartialFromTextStreamTest.StreamFromFile;
var
  M1: TMemoryStream;
  Template: TXMLComponent;
  Node: TDOMNode;
  TextAttr: string;
begin
  Template := TXMLComponent.Create(TTemplateFile.New.Stream);
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
        with TDataPartialFromTextStream.New(TDataStream.New(M1), TextAttr) do
        begin
          CheckEquals(
            TextAttr,
            Copy(AsString, 1, Length(TextAttr) * SizeOf(Char)),
            'Compare Content'
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

initialization
  TTestSuite.New('Data')
    .Add(TTest.New(TDataDividedStreamTest))
    .Add(TTest.New(TDataPartialFromTextStreamTest));

end.
