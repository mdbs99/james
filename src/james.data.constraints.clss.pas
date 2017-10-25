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
unit James.Data.Constraints.Clss;

{$include james.inc}

interface

uses
  Classes, SysUtils, Variants,
  James.Data,
  James.Data.Clss,
  James.Data.Constraints;

type
  { TODO -omdbs99 : This class is just a data bag and should be refactored, in the future }
  TDataInformation = class(TInterfacedObject, IDataInformation)
  private
    FId: string;
    FText: string;
    FMetadata: string;
  public
    constructor Create(const Id, Text, Metadata: string); reintroduce;
    class function New(const Id, Text, Metadata: string): IDataInformation; overload;
    class function New(const Id, Text: string): IDataInformation; overload;
    class function New(const Id: string): IDataInformation; overload;
    function Id: string;
    function Text: string;
    function Metadata: string;
  end;
  TDataInformationAlias = TDataInformation;

  TDataInformations = class(TInterfacedObject, IDataInformations)
  private
    FList: IInterfaceList;
  public
    constructor Create; reintroduce;
    class function New: IDataInformations;
    function Add(Info: IDataInformation): IDataInformations; overload;
    function Add(Infos: IDataInformations): IDataInformations; overload;
    function Get(Index: Integer): IDataInformation;
    function Count: Integer;
    function Text: string;
  end;
  TDataInformationsAlias = TDataInformations;

  TDataResult = class sealed(TInterfacedObject, IDataResult)
  private
    FOK: Boolean;
    FData: IDataParams;
    FInfos: IDataInformations;
  public
    constructor Create(OK: Boolean; Infos: IDataInformations; Data: IDataParams); reintroduce; overload;
    class function New(OK: Boolean; Infos: IDataInformations; Data: IDataParams): IDataResult; overload;
    class function New(OK: Boolean; Infos: IDataInformations): IDataResult; overload;
    class function New(OK: Boolean; Info: IDataInformation): IDataResult; overload;
    class function New(OK: Boolean): IDataResult; overload;
    function OK: Boolean;
    function Data: IDataParams;
    function Informations: IDataInformations;
  end;
  TDataResultAlias = TDataResult;

  TDataConstraints = class(TInterfacedObject, IDataConstraint, IDataConstraints)
  private
    FList: IInterfaceList;
  public
    constructor Create;
    class function New: IDataConstraints;
    function Add(C: IDataConstraint): IDataConstraints;
    function Get(Index: Integer): IDataConstraint;
    function Count: Integer;
    function Checked: IDataResult;
  end;
  TDataConstraintsAlias = TDataConstraints;
  
implementation

{ TDataInformation }

constructor TDataInformation.Create(const Id, Text, Metadata: string);
begin
  inherited Create;
  FId := Id;
  FText := Text;
  FMetadata := Metadata;
end;

class function TDataInformation.New(const Id, Text, Metadata: string): IDataInformation;
begin
  Result := Create(Id, Text, Metadata);
end;

class function TDataInformation.New(const Id, Text: string): IDataInformation;
begin
  Result := Create(Id, Text, Text);
end;

class function TDataInformation.New(const Id: string): IDataInformation;
begin
  Result := New(Id, '');
end;

function TDataInformation.Id: string;
begin
  Result := FId;
end;

function TDataInformation.Text: string;
begin
  Result := FText;
end;

function TDataInformation.Metadata: string;
begin
  Result := FMetadata;
end;

{ TDataInformations }

constructor TDataInformations.Create;
begin
  inherited Create;
  FList := TInterfaceList.Create;
end;

class function TDataInformations.New: IDataInformations;
begin
  Result := Create;
end;

function TDataInformations.Add(Info: IDataInformation): IDataInformations;
begin
  Result := Self;
  FList.Add(Info);
end;

function TDataInformations.Add(Infos: IDataInformations): IDataInformations;
var
  I: Integer;
begin
  Result := Self;
  for I := 0 to Infos.Count -1 do
    Add(Infos.Get(I));
end;

function TDataInformations.Get(Index: Integer): IDataInformation;
begin
  Result := FList.Items[Index] as IDataInformation;
end;

function TDataInformations.Count: Integer;
begin
  Result := FList.Count;
end;

function TDataInformations.Text: string;
var
  I: Integer;
  Info: IDataInformation;
begin
  Result := '';
  for I := 0 to Count -1 do
  begin
    Info := Get(I);
    Result := Result + Info.Id + ': ' + Info.Text + #13;
  end;
  Result := Trim(Result);
end;

{ TDataResult }

constructor TDataResult.Create(OK: Boolean; Infos: IDataInformations; Data: IDataParams);
begin
  inherited Create;
  FOK := OK;
  FData := Data;
  FInfos := Infos;
end;

class function TDataResult.New(OK: Boolean; Infos: IDataInformations;
  Data: IDataParams): IDataResult;
begin
  Result := Create(OK, Infos, Data);
end;

class function TDataResult.New(OK: Boolean; Infos: IDataInformations): IDataResult;
begin
  Result := Create(OK, Infos, TDataParams.New);
end;

class function TDataResult.New(OK: Boolean; Info: IDataInformation): IDataResult;
begin
  Result := New(OK, TDataInformations.New.Add(Info));
end;

class function TDataResult.New(OK: Boolean): IDataResult;
begin
  Result := New(OK, TDataInformation.New('RESULT'));
end;

function TDataResult.OK: Boolean;
begin
  Result := FOK;
end;

function TDataResult.Data: IDataParams;
begin
  Result := FData;
end;

function TDataResult.Informations: IDataInformations;
begin
  Result := FInfos;
end;

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

function TDataConstraints.Add(C: IDataConstraint): IDataConstraints;
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

