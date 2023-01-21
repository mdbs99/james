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
unit JamesAdapters;

{$i James.inc}

interface

uses
  Classes,
  SysUtils,
  COMObj,
  Variants,
  SynCommons;

type
 
  TEnumAdapter = {$ifdef UNICODE}record{$else}object{$endif}
  private
    fTypeInfo: pointer;
    fIndex: Integer;
    fTrimLowerCase: Boolean;
  public
    /// initialize the instance
    procedure Init(aTypeInfo: pointer; aIndex: Integer);
    /// return as Text
    function AsShortString: ShortString;
    /// access to original aIndex on Init()
    property Index: Integer read fIndex write fIndex;
    // will trim the lowercase 'a'..'z' chars on left side
    property TrimLowerCase: Boolean read fTrimLowerCase write fTrimLowerCase;
  end;

  /// object to adapt a Set of Enum type into other types
  TEnumSetAdapter = {$ifdef UNICODE}record{$else}object{$endif}
  private
    fTypeInfo: pointer;
    fArray: PPShortString;
    fArrayLen: Integer;
    fTrimLowerCase: Boolean;
  public
    /// initialize the instance
    // - aArray should be a pointer to `array[EnumType] of PShortString`
    // - aLen should be the length of aArray
    procedure Init(aTypeInfo: pointer; aArray: PPShortString; aLen: Integer);
    /// adapt to TStrings
    // - aDest should exist
    procedure ToStrings(aDest: TStrings);
    // will trim the lowercase 'a'..'z' chars on left side
    property TrimLowerCase: Boolean read fTrimLowerCase write fTrimLowerCase;
  end;

implementation

{ TEnumAdapter }

procedure TEnumAdapter.Init(aTypeInfo: pointer; aIndex: Integer);
begin
  fTypeInfo := aTypeInfo;
  fIndex := aIndex;
  fTrimLowerCase := False;
end;

function TEnumAdapter.AsShortString: ShortString;
begin
  result := GetEnumName(fTypeInfo, fIndex)^;
  if TrimLowerCase then
    result := TrimLeftLowerCaseShort(@result);
end;

{ TEnumSetAdapter }

procedure TEnumSetAdapter.Init(aTypeInfo: pointer; aArray: PPShortString;
  aLen: Integer);
begin
  fTypeInfo := aTypeInfo;
  fArray := aArray;
  fArrayLen := aLen;
  fTrimLowerCase := False;
  GetEnumNames(fTypeInfo, aArray);
end;

procedure TEnumSetAdapter.ToStrings(aDest: TStrings);
var
  i: Integer;
  a: TEnumAdapter;
begin
  if aDest = nil then
    exit;
  aDest.Clear;
  i := 0;
  a.Init(fTypeInfo, i);
  while i < fArrayLen do
  begin
    a.TrimLowerCase := TrimLowerCase;
    aDest.Append(a.AsShortString);
    inc(i);
    inc(fArray);
    a.Index := i;
  end;
end;

end.
