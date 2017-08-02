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
unit James.Testing.Delphi;

{$include james.inc}

interface

uses
  TestFramework,
  James.Testing;

type
  TTest = class sealed(TInterfacedObject, ITest)
  private
    FClss: TTestCaseClass;
  public
    constructor Create(Clss: TTestCaseClass);
    class function New(Clss: TTestCaseClass): ITest;
    function RegisterOn(const SuitePath: string): ITest;
  end;

implementation

{ TTest }

constructor TTest.Create(Clss: TTestCaseClass);
begin
  inherited Create;
  FClss := Clss;
end;

class function TTest.New(Clss: TTestCaseClass): ITest;
begin
  Result := Create(Clss);
end;

function TTest.RegisterOn(const SuitePath: string): ITest;
begin
  Result := Self;
  TestFramework.RegisterTest(SuitePath, FClss.Suite);
end;

end.
