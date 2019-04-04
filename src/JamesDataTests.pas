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
    procedure DataStreamAdapterOleVariant;
    procedure DataStreamAdapterParam;
    procedure DataStreamAdapterStrings;
    procedure DataStrings;
    procedure DataParam;
    procedure DataParams;
    procedure DataGuid;
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

implementation

type
  TFakeConstraint = class(TInterfacedObject, IDataConstraint)
  private
    fValue: Boolean;
    fId: string;
    fText: string;
  public
    constructor Create(aValue: Boolean; const aId, aText: string);
    function Evaluate: IDataResult;
  end;

{ TFakeConstraint }

constructor TFakeConstraint.Create(aValue: Boolean; const aId, aText: string);
begin
  inherited Create;
  fValue := aValue;
  fId := aId;
  fText := aText;
end;

function TFakeConstraint.Evaluate: IDataResult;
begin
  Result := TDataResult.New(
    fValue,
    TDataParam.Create(fId, ftString, fText)
  );
end;

{ TDataTests }

procedure TDataTests.DataStream;
const
  BUFFER = 'foo-bar';
var
  a: IDataStream;
  m1, m2: TMemoryStream;
  ss: TStrings;
begin
  m1 := TMemoryStream.Create;
  m2 := TMemoryStream.Create;
  ss := TStringList.Create;
  try
    m1.WriteBuffer(BUFFER[1], Length(BUFFER) * SizeOf(Char));
    ss.Text := BUFFER;
    a := TDataStream.Create(m1);
    check(a.AsString = BUFFER, 'stream');
    a := TDataStream.Create(ss);
    check(a.AsString = ss.Text, 'strings');
    a := TDataStream.Create(BUFFER);
    check(a.AsString = BUFFER, 'text');
    a := TDataStream.Create(m1);
    a.Save(m2);
    check(m1.Size = m2.Size, 'mem size');
    check(a.Size = m2.Size, 'a size');
  finally
    m1.Free;
    m2.Free;
    ss.Free;
  end;
end;

procedure TDataTests.DataStreamAdapterOleVariant;
var
  v: OleVariant;
  sa: TDataStreamAdapter;
  va: TOleVariantAdapter;
begin
  sa.Init(TDataStream.Create('foo'));
  v := sa.AsOleVariant;
  va.Init(v);
  check('foo' = va.AsDataStream.AsString, 'va');
end;

procedure TDataTests.DataStreamAdapterParam;
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
    check(VarToStr(p.Value)= s.AsString);
  finally
    p.Free;
  end;
end;

procedure TDataTests.DataStreamAdapterStrings;
var
  s: IDataStream;
  ss: TStrings;
  sa: TDataStreamAdapter;
begin
  s := TDataStream.Create('strings');
  ss := TStringList.Create;
  try
    sa.Init(s);
    sa.ForStrings(ss);
    check(Trim(ss.Text) = s.AsString); // TStrings needs to call Trim
  finally
    ss.Free;
  end;
end;

procedure TDataTests.DataStrings;
var
  ds: IDataStrings;
  i: Integer;
  ss: TStrings;
begin
  ss := TStringList.Create;
  try
    ds := TDataStrings.Create;
    for i := 0 to 10 do
    begin
      ds.Add(IntToStr(i));
      ss.Add(IntToStr(i));
    end;
    check(ds.Count = ss.Count, 'count');
    check(ds.Text = Trim(ss.Text), 'text'); // TStrings needs to call Trim
  finally
    ss.Free;
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

procedure TDataTests.DataGuid;
var
  g1, g2: IDataGuid;
begin
  g1 := TDataGuid.Create('NONE');
  g2 := TNullGuid.Create;
  check(g1.AsString = g2.AsString, 'none');
  g1 := TDataGuid.Create(NULL);
  g2 := TNullGuid.Create;
  check(g1.AsString = g2.AsString, 'NULL');
  g1 := TDataGuid.Create('FCCE420A-8C4F-4E54-84D1-39001AE344BA');
  g2 := TDataGuid.Create(g1.AsString);
  check(g1.AsString = g2.AsString, 'guid');
  check(g1.AsSmallString = g2.AsSmallString, 'AsSmallString');
end;

{ TDataConstraintsTest }

procedure TDataConstraintsTest.TestReceiveConstraint;
begin
  CheckTrue(
    TDataConstraints.Create
      .Ref
      .Add(TFakeConstraint.Create(True, 'id', 'foo'))
      .Evaluate
      .Success
  );
end;

procedure TDataConstraintsTest.TestGetConstraint;
begin
  CheckEquals(
    'foo',
    TDataConstraints.Create
      .Ref
      .Add(TFakeConstraint.Create(True, 'id', 'foo'))
      .Evaluate
      .Data
      .AsString
  );
end;

procedure TDataConstraintsTest.TestEvaluateTrue;
begin
  CheckTrue(
    TDataConstraints.Create
      .Ref
      .Add(TFakeConstraint.Create(True, 'id', 'foo'))
      .Add(TFakeConstraint.Create(True, 'id', 'foo'))
      .Evaluate
      .Success
  );
end;

procedure TDataConstraintsTest.TestEvaluateFalse;
begin
  CheckFalse(
    TDataConstraints.Create
      .Ref
      .Add(TFakeConstraint.Create(False, 'id', 'foo'))
      .Add(TFakeConstraint.Create(False, 'id', 'foo'))
      .Evaluate
      .Success
  );
end;

procedure TDataConstraintsTest.TestEvaluateTrueAndFalse;
begin
  CheckFalse(
    TDataConstraints.Create
      .Ref
      .Add(TFakeConstraint.Create(True, 'id', 'foo'))
      .Add(TFakeConstraint.Create(False, 'id', 'foo'))
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
  m1: TMemoryStream;
begin
  m1 := TMemoryStream.Create;
  try
    m1.WriteBuffer(TXT[1], Length(TXT) * SizeOf(Char));
    m1.SaveToFile(FILE_NAME);
    CheckEquals(TXT, TDataFile.Create(FILE_NAME).Ref.Stream.AsString);
  finally
    DeleteFile(FILE_NAME);
    m1.Free;
  end;
end;

initialization
  TTestSuite.Create('Data')
    .Ref
    .Add(TTest.Create(TDataTests))
    .Add(TTest.Create(TDataConstraintsTest))
    .Add(TTest.Create(TDataFileTest))
    ;

end.
