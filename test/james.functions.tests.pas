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
unit James.Functions.Tests;

{$include james.inc}

interface

uses
  James.Functions.Clss,
  james.testing.clss,
  {$IFDEF FPC}
    James.Testing.FPC
  {$ELSE}
    James.Testing.Delphi
  {$ENDIF};

type
  TIfTest = class(TTestCase)
  published
    procedure TestTrue;
    procedure TestFalse;
  end;

implementation

{ TIfTest }

procedure TIfTest.TestTrue;
begin
  CheckEquals(1, TIf<Integer>.New(True, 1, 0).Value);
end;

procedure TIfTest.TestFalse;
begin
  CheckEquals(0, TIf<Integer>.New(False, 1, 0).Value);
end;

initialization
  TTestSuite.New('Functions')
    .Add(TTest.New(TIfTest));

end.

