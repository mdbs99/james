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
unit James.Constraints.Clss;

{$include james.inc}

interface

uses
  Classes, SysUtils, Variants,
  James.Data,
  James.Data.Clss,
  James.Constraints;

type
  TConstraints = class(TInterfacedObject, IConstraint, IConstraints)
  private
    FList: IInterfaceList;
  public
    constructor Create;
    class function New: IConstraints;
    function Add(const AConstraint: IConstraint): IConstraints;
    function Get(Index: Integer): IConstraint;
    function Count: Integer;
    function Evaluate: IDataResult;
  end;

implementation

{ TConstraints }

constructor TConstraints.Create;
begin
  inherited Create;
  FList := TInterfaceList.Create
end;

class function TConstraints.New: IConstraints;
begin
  Result := Create;
end;

function TConstraints.Add(const AConstraint: IConstraint
  ): IConstraints;
begin
  Result := Self;
  FList.Add(AConstraint);
end;

function TConstraints.Get(Index: Integer): IConstraint;
begin
  Result := FList.Items[Index] as IConstraint;
end;

function TConstraints.Count: Integer;
begin
  Result := FList.Count;
end;

function TConstraints.Evaluate: IDataResult;
var
  I: Integer;
  Ok: Boolean;
  R: IDataResult;
  Infos: IDataInformations;
begin
  Ok := True;
  Infos := TDataInformations.New;
  for I := 0 to Count-1 do
  begin
    R := Get(I).Evaluate;
    if not R.Ok then
      Ok := False;
    Infos.Add(R.Informations);
  end;
  Result := TDataResult.New(Ok, Infos);
end;

end.

