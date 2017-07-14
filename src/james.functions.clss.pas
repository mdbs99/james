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
unit James.Functions.clss;

{$include james.inc}

interface

uses
  James.Functions;

type
  TIf<T> = class(TInterfacedObject, IIf<T>)
  private
    FCondition: Boolean;
    FValueIfTrue: T;
    FValueIfFalse: T;
  public
    constructor Create(const Condition: Boolean; const ValueIfTrue, ValueIfFalse: T);
    class function New(const Condition: Boolean; const ValueIfTrue, ValueIfFalse: T): IIf<T>;
    function Value: T;
  End;

implementation

{ TIf<T> }

constructor TIf<T>.Create(const Condition: Boolean; const ValueIfTrue,
  ValueIfFalse: T);
begin
  FCondition    := Condition;
  FValueIfTrue  := ValueIfTrue;
  FValueIfFalse := ValueIfFalse;
end;

class function TIf<T>.New(const Condition: Boolean; const ValueIfTrue,
  ValueIfFalse: T): IIf<T>;
begin
  Result := Create(Condition, ValueIfTrue, ValueIfFalse);
end;

function TIf<T>.Value: T;
begin
  if FCondition
    then Result := FValueIfTrue
    else Result := FValueIfFalse;
end;

end.
