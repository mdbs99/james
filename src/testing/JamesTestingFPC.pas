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
unit JamesTestingFPC;

{$include James.inc}

interface

uses
  fpcunit,
  testregistry,
  JamesTestingBase;

type
  TTest = class sealed(TInterfacedObject, ITest)
  private
    FCore: TTestCaseClass;
  public
    constructor Create(Core: TTestCaseClass);
    class function New(Core: TTestCaseClass): ITest;
    function RegisterOn(const SuitePath: string): ITest;
  end;

implementation

{ TTest }

constructor TTest.Create(Core: TTestCaseClass);
begin
  inherited Create;
  FCore := Core;
end;

class function TTest.New(Core: TTestCaseClass): ITest;
begin
  Result := Create(Core);
end;

function TTest.RegisterOn(const SuitePath: string): ITest;
begin
  Result := Self;
  TestRegistry.RegisterTest(SuitePath, FCore);
end;

end.
