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
unit James.Constraints.Tests;

{$include james.inc}

interface

uses
  Classes, SysUtils,
  James.API,
  James.Testing.Clss;

type
  TFakeConstraint = class(TInterfacedObject, IDataConstraint)
  private
    FValue: Boolean;
    FId: string;
    FText: string;
  public
    constructor Create(Value: Boolean; const Id, Text: string);
    class function New(Value: Boolean; const Id, Text: string): IDataConstraint;
    function Checked: IDataResult;
  end;

  TConstraintsTest = class(TTestCase)
  published
    procedure ReceiveConstraint;
    procedure GetConstraint;
    procedure CheckedTrue;
    procedure CheckedFalse;
    procedure CheckedTrueAndFalse;
  end;

implementation

{ TFakeConstraint }

constructor TFakeConstraint.Create(Value: Boolean; const Id, Text: string);
begin
  inherited Create;
  FValue := Value;
  FId := Id;
  FText := Text;
end;

class function TFakeConstraint.New(Value: Boolean; const Id, Text: string
  ): IDataConstraint;
begin
  Result := Create(Value, Id, Text);
end;

function TFakeConstraint.Checked: IDataResult;
begin
  Result := TDataResult.New(FValue, TDataInformation.New(FId, FText));
end;

{ TConstraintsTest }

procedure TConstraintsTest.ReceiveConstraint;
begin
  CheckTrue(
    TDataConstraints.New
      .Add(TFakeConstraint.New(True, 'id', 'foo'))
      .Checked
      .OK
  );
end;

procedure TConstraintsTest.GetConstraint;
begin
  CheckEquals(
    'id: foo',
    TDataConstraints.New
      .Add(TFakeConstraint.New(True, 'id', 'foo'))
      .Get(0)
      .Checked
      .Informations
      .Text
  );
end;

procedure TConstraintsTest.CheckedTrue;
begin
  CheckTrue(
    TDataConstraints.New
      .Add(TFakeConstraint.New(True, 'id', 'foo'))
      .Add(TFakeConstraint.New(True, 'id', 'foo'))
      .Checked
      .OK
  );
end;

procedure TConstraintsTest.CheckedFalse;
begin
  CheckFalse(
    TDataConstraints.New
      .Add(TFakeConstraint.New(False, 'id', 'foo'))
      .Add(TFakeConstraint.New(False, 'id', 'foo'))
      .Checked
      .OK
  );
end;

procedure TConstraintsTest.CheckedTrueAndFalse;
begin
  CheckFalse(
    TDataConstraints.New
      .Add(TFakeConstraint.New(True, 'id', 'foo'))
      .Add(TFakeConstraint.New(False, 'id', 'foo'))
      .Checked
      .OK
  );
end;

initialization
  TTestSuite.New('Core.Data')
    .Add(TTest.New(TConstraintsTest))
    ;

end.
