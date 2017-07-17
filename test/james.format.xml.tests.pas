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
unit James.Format.XML.Tests;

{$include james.inc}

interface

uses
  Classes, SysUtils,
  James.Format.XML.Clss,
  {$IFDEF FPC}
    fpcunit, testregistry
  {$ELSE}
    TestFramework, XmlDoc, XmlIntf
  {$ENDIF};

type
  TXMLComponentTest = class(TTestCase)
  published
    procedure Document;
  end;

implementation

procedure TXMLComponentTest.Document;
const
  XML = '<?xml version="1.0"?> '#13
      + '<Foo> '#13
      + '  <X>1</X> '#13
      + '  <Y>ABC</Y> '#13
      + '  <Z>10.00</Z> '#13
      + '</Foo> ';
var
  Fmt: TFormatSettings absolute DefaultFormatSettings;
begin
  Fmt.DecimalSeparator := '.';
  with TXMLComponent.Create(XML) do
  try
    with Document.FindNode('Foo') do
    begin
      CheckNotNull(FindNode('X'), 'Find X');
      CheckEquals(1, FindNode('X').TextContent.ToInteger, 'Value X');
      CheckNotNull(FindNode('Y'), 'Find Y');
      CheckEquals('ABC', FindNode('Y').TextContent, 'Value Y');
      CheckNotNull(FindNode('Z'), 'Find Z');
      CheckEquals(10.00, StrToFloat(FindNode('Z').TextContent, Fmt), 'Value Z');
    end;
  finally
    Free;
  end;
end;

initialization
  RegisterTest('Format', TXMLComponentTest{$IFNDEF FPC}.Suite{$ENDIF});

end.

