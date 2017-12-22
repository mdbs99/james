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
  TDataConstraints = class(TInterfacedObject, IDataConstraint, IDataConstraints)
  private
    FList: IInterfaceList;
  public
    constructor Create;
    class function New: IDataConstraints;
    function Add(const C: IDataConstraint): IDataConstraints;
    function Get(Index: Integer): IDataConstraint;
    function Count: Integer;
    function Checked: IDataResult;
  end;

implementation

{ TDataConstraints }

constructor TDataConstraints.Create;
begin
  inherited Create;
  FList := TInterfaceList.Create
end;

class function TDataConstraints.New: IDataConstraints;
begin
  Result := Create;
end;

function TDataConstraints.Add(const C: IDataConstraint): IDataConstraints;
begin
  Result := Self;
  FList.Add(C);
end;

function TDataConstraints.Get(Index: Integer): IDataConstraint;
begin
  Result := FList.Items[Index] as IDataConstraint;
end;

function TDataConstraints.Count: Integer;
begin
  Result := FList.Count;
end;

function TDataConstraints.Checked: IDataResult;
var
  I: Integer;
  OK: Boolean;
  R: IDataResult;
  Infos: IDataInformations;
begin
  OK := True;
  Infos := TDataInformations.New;
  for I := 0 to Count-1 do
  begin
    R := Get(I).Checked;
    if not R.OK then
      OK := False;
    Infos.Add(R.Informations);
  end;
  Result := TDataResult.New(OK, Infos);
end;

end.

