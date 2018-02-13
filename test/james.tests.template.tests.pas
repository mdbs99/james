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
unit James.Tests.Template.Tests;

{$include james.inc}

interface

uses
  Xavier.API,
  James.Testing.Clss,
  James.Tests.Template.Clss;

type
  TTemplateFileTest = class(TTestCase)
  published
    procedure DataDividedStreamTest;
    procedure DataPartialFromTextStreamTest;
  end;

implementation

{ TTemplateFileTest }

procedure TTemplateFileTest.DataDividedStreamTest;
var
  ClssName: string;
  XML: IXMLPack;
begin
  ClssName := TDataDividedStreamTest.ClassName;
  XML := TXMLPack.New(TTemplateFile.New.Stream);
  CheckNotNull(
    XML.Node(UnicodeString('/Tests/' + ClssName)),
    ClssName + ' node not exists'
  );
  CheckNotNull(
    XML.Node(UnicodeString('/Tests/' + ClssName + '/files')),
    'Files node not exists'
  );
  CheckNotNull(
    XML.Node(UnicodeString('/Tests/' + ClssName + '/files/file')),
    'File node not exists'
  );
end;

procedure TTemplateFileTest.DataPartialFromTextStreamTest;
var
  ClssName: string;
  XML: IXMLPack;
begin
  ClssName := TDataPartialFromTextStreamTest.ClassName;
  XML := TXMLPack.New(TTemplateFile.New.Stream);
  CheckNotNull(
    XML.Node(UnicodeString('/Tests/' + ClssName)),
    ClssName + ' node not exists'
  );
  CheckNotNull(
    XML.Node(UnicodeString('/Tests/' + ClssName + '/files')),
    'Files node not exists'
  );
  CheckNotNull(
    XML.Node(UnicodeString('/Tests/' + ClssName + '/files/file')),
    'File node not exists'
  );
end;

initialization
  TTestSuite.New('Tests')
    .Add(TTest.New(TTemplateFileTest));

end.

