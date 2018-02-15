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
unit JamesTestingClss;

{$include james.inc}

interface

uses
  {$ifdef FPC}
    fpcunit,
    JamesTestingFPC,
  {$else}
    TestFramework,
    JamesTestingDelphi,
  {$endif}
  JamesTesting;

type
  {$ifdef FPC}
    TTest = JamesTestingFPC.TTest;
    TTestCase = FPCUnit.TTestCase;
  {$else}
    TTest = JamesTestingDelphi.TTest;
    TTestCase = TestFramework.TTestCase;
  {$endif}

  TTestSuite = class sealed(TInterfacedObject, ITestSuite)
  private
    FPath: string;
  public
    constructor Create(const Path: string);
    class function New(const Path: string): ITestSuite;
    function Add(const Test: ITest): ITestSuite;
  end;

implementation

{ TTestSuite }

function TTestSuite.Add(const Test: ITest): ITestSuite;
begin
  Result := Self;
  Test.RegisterOn(FPath);
end;

constructor TTestSuite.Create(const Path: string);
begin
  FPath := Path;
end;

class function TTestSuite.New(const Path: string): ITestSuite;
begin
  Result := Create(Path);
end;


end.
