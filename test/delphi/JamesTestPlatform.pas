{
  MIT License

  Copyright (c) 2017-2020 Marcos Douglas B. Santos

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
unit JamesTestPlatform;

{$i James.inc}

interface

uses
  SynCommons,
  TestFramework,
  GuiTestRunner,
  JamesTestBase;

type
  TTestCase = TestFramework.TTestCase;

  TTest = class(TInterfacedObject, ITest)
  private
    fClass: TTestCaseClass;
  public
    constructor Create(aClass: TTestCaseClass);
    function RegisterOn(const aSuitePath: string): ITest;
  end;

  TTestRunner = {$ifdef UNICODE}record{$else}object{$endif}
  public
    procedure RunRegisteredTests;
  end;

implementation

{ TTest }

constructor TTest.Create(aClass: TTestCaseClass);
begin
  inherited Create;
  fClass := aClass;
end;

function TTest.RegisterOn(const aSuitePath: string): ITest;
begin
  result := self;
  TestFramework.RegisterTest(aSuitePath, fClass.Suite);
end;

{ TTestRunner }

procedure TTestRunner.RunRegisteredTests;
begin
  GUITestRunner.RunRegisteredTests;
end;

end.
