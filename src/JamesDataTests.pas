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
unit JamesDataTests;

{$i James.inc}

interface

uses
  Classes,
  SysUtils,
  Variants,
  DB,
  TypInfo,
  COMObj,
  JamesDataBase,
  JamesDataCore,
  JamesDataAdapters,
  JamesRTLAdapters,
  JamesTestCore,
  JamesTestPlatform;

type
  TDataTests = class(TTestCase)
  published
    procedure DataStream;
    procedure DataStrings;
    procedure DataParam;
    procedure DataParams;
  end;

  TDataGuidTest = class(TTestCase)
  published
    procedure TestNewGuid;
    procedure TestNullGuid;
    procedure TestValueAsVariant;
    procedure TestValueWithoutBrackets;
    procedure TestSmallString;
  end;

  TFakeConstraint = class(TInterfacedObject, IDataConstraint)
  private
    FValue: Boolean;
    FId: string;
    FText: string;
  public
    constructor Create(Value: Boolean; const Id, Text: string);
    class function New(Value: Boolean; const Id, Text: string): IDataConstraint;
    function Evaluate: IDataResult;
  end;

  TDataConstraintsTest = class(TTestCase)
  published
    procedure TestReceiveConstraint;
    procedure TestGetConstraint;
    procedure TestEvaluateTrue;
    procedure TestEvaluateFalse;
    procedure TestEvaluateTrueAndFalse;
  end;

  TDataFileTest = class(TTestCase)
  published
    procedure TestPath;
    procedure TestName;
    procedure TestStream;
  end;

  TDataStreamAdapterTest = class(TTestCase)
  published
    procedure TestOleVariant;
    procedure TestParam;
    procedure TestStrings;
  end;

implementation

{ TDataTests }

procedure TDataTests.DataStream;
const
  BUFFER = 'foo-bar';
var
  a: IDataStream;
  m1, m2: TMemoryStream;
  ss1: TStrings;
begin
  m1 := TMemoryStream.Create;
  m2 := TMemoryStream.Create;
  ss1 := TStringList.Create;
  try
    m1.WriteBuffer(BUFFER[1], Length(BUFFER) * SizeOf(Char));
    ss1.Text := BUFFER;
    a := TDataStream.Create(m1);
    check(a.AsString = BUFFER, 'stream');
    a := TDataStream.Create(ss1);
    check(a.AsString = ss1.Text, 'strings'); // strings have #13#10 at the end
    a := TDataStream.Create(BUFFER);
    check(a.AsString = BUFFER, 'text');
    a := TDataStream.Create(m1);
    a.Save(m2);
    check(m1.Size = m2.Size, 'mem size');
    check(a.Size = m2.Size, 'a size');
  finally
    m1.Free;
    m2.Free;
    ss1.Free;
  end;
end;

procedure TDataTests.DataStrings;
var
  a: IDataStrings;
  i: Integer;
  ss1: TStrings;
begin
  ss1 := TStringList.Create;
  try
    a := TDataStrings.Create;
    for i := 0 to 10 do
    begin
      a.Add(IntToStr(i));
      ss1.Add(IntToStr(i));
    end;
    check(a.Count = ss1.Count, 'count');
    check(a.Text = Trim(ss1.Text), 'text'); // TStrings needs to call Trim
  finally
    ss1.Free;
  end;
end;

procedure TDataTests.DataParam;
begin
  check(TDataParam.Create('p1', 'str').Ref.DataType = ftString, 'p1');
  check(TDataParam.Create('p2', 10).Ref.DataType = ftSmallint, 'p2');
  check(TDataParam.Create('p3', 20.50).Ref.DataType = ftFloat, 'p3');
end;

procedure TDataTests.DataParams;
var
  ps: IDataParams;
begin
  ps := TDataParams.Create;
  ps.Add(TDataParam.Create('foo', ftSmallint, 10));
  check(ps.Count = 1, 'count 1');
  check(ps.Get(0).AsInteger = 10, '=10');
  ps.Add(TDataParam.Create('1', 1))
    .Add(TDataParam.Create('2', 2))
    .Add(
      TDataParams.New
        .Add(TDataParam.Create('3', 3))
        .Add(TDataParam.Create('4', 4))
        .Add(TDataParam.Create('5', 4))
    );
  check(ps.Count = 6, 'count 6');
  check(assigned(ps.Get('3')), 'assigned 3');
  check(ps.Get('3').AsInteger = 3, 'get 3');
  ps := TDataParams.Create // new instance
    .Ref
    .Add(TDataParam.Create('1', 1))
    .Add(TDataParam.Create('2', 2))
    .Add(TDataParam.Create('3', 3));
  check(ps.AsString(';') = '1;2;3', 'separator');
end;

{ TDataGuidTest }

procedure TDataGuidTest.TestNewGuid;
begin
  StringToGUID(TDataGuid.New.AsString);
end;

procedure TDataGuidTest.TestNullGuid;
begin
  CheckEquals(
    TNullGuid.New.AsString,
    TDataGuid.New('foo').AsString
  );
end;

procedure TDataGuidTest.TestValueAsVariant;
begin
  CheckEquals(
    TNullGuid.New.AsString,
    TDataGuid.New(NULL).AsString
  );
end;

procedure TDataGuidTest.TestValueWithoutBrackets;
const
  G: string = 'FCCE420A-8C4F-4E54-84D1-39001AE344BA';
begin
  CheckEquals(
    '{' + G + '}',
    TDataGuid.New(G).AsString
  );
end;

procedure TDataGuidTest.TestSmallString;
const
  V = '89000BC9';
  G = '{'+V+'-5700-43A3-B340-E34A1656F683}';
begin
  CheckEquals(
    V, TDataGuid.New(G).AsSmallString
  );
end;

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

function TFakeConstraint.Evaluate: IDataResult;
begin
  Result := TDataResult.New(
    FValue,
    TDataParam.Create(FId, ftString, FText)
  );
end;

{ TDataConstraintsTest }

procedure TDataConstraintsTest.TestReceiveConstraint;
begin
  CheckTrue(
    TDataConstraints.New
      .Add(TFakeConstraint.New(True, 'id', 'foo'))
      .Evaluate
      .Success
  );
end;

procedure TDataConstraintsTest.TestGetConstraint;
begin
  CheckEquals(
    'foo',
    TDataConstraints.New
      .Add(TFakeConstraint.New(True, 'id', 'foo'))
      .Evaluate
      .Data
      .AsString
  );
end;

procedure TDataConstraintsTest.TestEvaluateTrue;
begin
  CheckTrue(
    TDataConstraints.New
      .Add(TFakeConstraint.New(True, 'id', 'foo'))
      .Add(TFakeConstraint.New(True, 'id', 'foo'))
      .Evaluate
      .Success
  );
end;

procedure TDataConstraintsTest.TestEvaluateFalse;
begin
  CheckFalse(
    TDataConstraints.New
      .Add(TFakeConstraint.New(False, 'id', 'foo'))
      .Add(TFakeConstraint.New(False, 'id', 'foo'))
      .Evaluate
      .Success
  );
end;

procedure TDataConstraintsTest.TestEvaluateTrueAndFalse;
begin
  CheckFalse(
    TDataConstraints.New
      .Add(TFakeConstraint.New(True, 'id', 'foo'))
      .Add(TFakeConstraint.New(False, 'id', 'foo'))
      .Evaluate
      .Success
  );
end;

{ TDataFileTest }

procedure TDataFileTest.TestPath;
begin
  CheckEquals('c:\path\', TDataFile.Create('c:\path\filename.txt').Ref.Path);
end;

procedure TDataFileTest.TestName;
begin
  CheckEquals('filename.txt', TDataFile.Create('c:\path\filename.txt').Ref.Name);
end;

procedure TDataFileTest.TestStream;
const
  TXT: string = 'ABCC~#';
  FILE_NAME: string = 'file.txt';
var
  M: TMemoryStream;
begin
  M := TMemoryStream.Create;
  try
    M.WriteBuffer(TXT[1], Length(TXT) * SizeOf(Char));
    M.SaveToFile(FILE_NAME);
    CheckEquals(TXT, TDataFile.Create(FILE_NAME).Ref.Stream.AsString);
  finally
    DeleteFile(FILE_NAME);
    M.Free;
  end;
end;

{ TDataStreamAdapterTest }

procedure TDataStreamAdapterTest.TestOleVariant;
var
  v: OleVariant;
  a: TDataStreamAdapter;
  b: TOleVariantAdapter;
begin
  a.Init(TDataStream.Create('foo'));
  v := a.AsOleVariant;
  b.Init(v);
  CheckEquals('foo', b.AsDataStream.AsString);
end;

procedure TDataStreamAdapterTest.TestParam;
var
  s: IDataStream;
  p: TParam;
  a: TDataStreamAdapter;
begin
  s := TDataStream.Create('bar');
  p := TParam.Create(nil);
  try
    a.Init(s);
    a.ForParam(p);
    CheckEquals(VarToStr(p.Value), s.AsString);
  finally
    p.Free;
  end;
end;

procedure TDataStreamAdapterTest.TestStrings;
var
  s: IDataStream;
  ss: TStrings;
  a: TDataStreamAdapter;
begin
  s := TDataStream.Create('strings');
  ss := TStringList.Create;
  try
    a.Init(s);
    a.ForStrings(ss);
    CheckEquals(ss.Text.TrimRight, s.AsString);
  finally
    ss.Free;
  end;
end;

initialization
  TTestSuite.Create('Data')
    .Ref
    .Add(TTest.Create(TDataTests))
    .Add(TTest.Create(TDataGuidTest))
    .Add(TTest.Create(TDataConstraintsTest))
    .Add(TTest.Create(TDataFileTest))
    .Add(TTest.Create(TDataStreamAdapterTest))
    ;

end.
