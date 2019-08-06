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
  SynCommons,
  JamesBase,
  JamesDataBase,
  JamesDataCore,
  JamesDataAdapters,
  JamesTestCore,
  JamesTestPlatform;

type
  /// all tests for core
  TDataCoreTests = class(TTestCase)
  published
    procedure TestStream;
    procedure TestStrings;
    procedure TestParam;
    procedure TestParams;
    procedure TestParamsCopier;
    procedure TestUUID;
    procedure TestConstraints;
    procedure TestFile;
    procedure TestTags;
  end;

  /// all tests for adapters
  TDataAdaptersTests = class(TTestCase)
  published
    procedure TestStreamAboutOleVariant;
    procedure TestStreamForStrings;
    procedure TestStreamForParam;
    procedure TestParamsForParams;
    procedure TestTagsAsRawUTF8Array;
  end;

implementation

type
  TFakeConstraint = class(TInterfacedObject, IDataConstraint)
  private
    fValue: Boolean;
    fId: RawUTF8;
    fText: RawUTF8;
  public
    constructor Create(aValue: Boolean; const aId, aText: RawUTF8);
    function Evaluate: IDataResult;
  end;

{ TFakeConstraint }

constructor TFakeConstraint.Create(aValue: Boolean; const aId, aText: RawUTF8);
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

{ TDataCoreTests }

procedure TDataCoreTests.TestStream;
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
    check(a.AsRawByteString = BUFFER, 'stream');
    a := TDataStream.Create(ss);
    check(a.AsRawByteString = ss.Text, 'strings');
    a := TDataStream.Create(BUFFER);
    check(a.AsRawByteString = BUFFER, 'text');
    a := TDataStream.Create(m1);
    a.ToStream(m2);
    check(m1.Size = m2.Size, 'mem size');
    check(a.Size = m2.Size, 'a size');
  finally
    m1.Free;
    m2.Free;
    ss.Free;
  end;
end;

procedure TDataCoreTests.TestStrings;
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
    check(ds.AsRawUTF8 = Trim(ss.Text), 'text'); // TStrings needs to call Trim
  finally
    ss.Free;
  end;
end;

procedure TDataCoreTests.TestParam;
begin
  check(TDataParam.Create('p1', 'str').Ref.DataType = ftString, 'p1');
  check(TDataParam.Create('p2', 10).Ref.DataType = ftSmallint, 'p2');
  check(TDataParam.Create('p3', 20.50).Ref.DataType in [ftFloat, ftCurrency, ftBCD], 'p3');
end;

procedure TDataCoreTests.TestParams;
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
  check(ps.AsRawUTF8(';') = '1;2;3', 'separator');
end;

procedure TDataCoreTests.TestUUID;
var
  g1, g2: IDataUUID;
begin
  g1 := TDataUUID.Create('INVALID');
  g2 := TNullUUID.Create;
  check(g1.AsString = g2.AsString, 'zeroed');
  g1 := TDataUUID.Create(NULL);
  g2 := TNullUUID.Create;
  check(g1.AsString = g2.AsString, 'NULL');
  g1 := TDataUUID.Create('FCCE420A-8C4F-4E54-84D1-39001AE344BA');
  g2 := TDataUUID.Create(g1.AsString);
  check(g1.AsString = g2.AsString, 'guid');
  check(g1.AsSmallString = g2.AsSmallString, 'AsSmallString');
end;

procedure TDataCoreTests.TestConstraints;
var
  cs: IDataConstraints;
begin
  cs := TDataConstraints.Create;
  cs.Add(TFakeConstraint.Create(True, 'a', ''));
  check(cs.Evaluate.Success, 'true');
  cs.Add(TFakeConstraint.Create(True, 'b', ''));
  check(cs.Evaluate.Success, 'true 2');
  cs.Add(TFakeConstraint.Create(False, 'b', ''));
  check(not cs.Evaluate.Success, 'true 2, fase 1');
  cs := TDataConstraints.Create; // new instance
  cs.Add(TFakeConstraint.Create(False, 'a', ''));
  cs.Add(TFakeConstraint.Create(False, 'b', ''));
  check(not cs.Evaluate.Success, 'false 2');
  cs := TDataConstraints.Create; // new instance
  cs.Add(TFakeConstraint.Create(False, 'a', 'foo'));
  check(cs.Evaluate.Data.AsRawUTF8 = 'foo');
  cs.Add(TFakeConstraint.Create(False, 'b', 'bar'));
  check(cs.Evaluate.Data.AsRawUTF8 = 'foo,bar', cs.Evaluate.Data.AsRawUTF8);
end;

procedure TDataCoreTests.TestFile;
var
  f: IDataFile;
  fn: TFileName;
begin
  f := TDataFile.Create('c:\path\filename.txt');
  check(f.Path = 'c:\path\', 'path'); // including PathDelim at the end
  check(f.Name = 'filename.txt', 'filename');
  fn := SynCommons.TemporaryFileName;
  f := TDataFile.Create(fn, TDataStream.Create('foo'));
  try
    check(f.Save, 'saving');
    check(f.Stream.AsRawByteString = 'foo', 'check data');
  finally
    check(f.Delete, FormatUTF8('forbidden to delete %', [fn]));
  end;
end;

procedure TDataCoreTests.TestTags;
var
  tags: IDataTags;
begin
  tags := TDataTags.Create('#foo');
  check(tags.Tags = '#foo', 'foo');
  tags.Add('#bar');
  check(tags.Tags = '#foo#bar', 'bar');
  check(tags.Count = 2, 'count');
  check(tags.Get(0) = '#foo', 'Get(0)');
  check(tags.Get(1) = '#bar', 'Get(1)');
  check(tags.Exists('#foo'), 'exists foo');
  check(tags.Exists('#bar'), 'exists bar');
end;

procedure TDataCoreTests.TestParamsCopier;
var
  cp: IProcedure;
  src, dest: IDataParams;
  i: Integer;
begin
  src := TDataParams.Create
    .Ref
    .Add(TDataParam.Create('foo', 1))
    .Add(TDataParam.Create('bar', 'bar'));
  dest := TDataParams.Create;
  cp := TDataParamsCopier.Create(src, dest);
  cp.Exec;
  check(src.Count = dest.Count, 'count');
  for i := 0 to src.Count -1 do
  begin
    check(src.Get(i).Name = dest.Get(i).Name, 'name');
    check(src.Get(i).Value = dest.Get(i).Value, 'value');
    check(src.Get(i).DataType = dest.Get(i).DataType, 'datatype');
  end;
end;

{ TDataAdaptersTests }

procedure TDataAdaptersTests.TestStreamAboutOleVariant;
var
  src: IDataStream;
  dest: OleVariant;
  s1, s2: RawByteString;
begin
  src := TDataStream.Create('foo');
  dest := TDataStreamAsOleVariant.Create(src).Ref.Value;
  s1 := TDataStreamOfOleVariant.Create(dest).Ref.Value.AsRawByteString;
  s2 := src.AsRawByteString;
  check(s1 = s2);
end;

procedure TDataAdaptersTests.TestStreamForStrings;
var
  src: IDataStream;
  dest: TStrings;
begin
  src := TDataStream.Create('strings');
  dest := TStringList.Create;
  try
    TDataStreamForStrings.Create(src, dest).Ref.Adapt;
    check(src.AsRawByteString = Trim(dest.Text)); // TStrings needs to call Trim
  finally
    dest.Free;
  end;
end;

procedure TDataAdaptersTests.TestStreamForParam;
var
  src: IDataStream;
  dest: TParam;
  adp: IDataAdapterFor;
begin
  src := TDataStream.Create('bar');
  dest := TParam.Create(nil);
  try
    adp := TDataStreamForParam.Create(src, dest);
    adp.Adapt;
    check(src.AsRawByteString = dest.AsString);
  finally
    dest.Free;
  end;
end;

procedure TDataAdaptersTests.TestParamsForParams;
var
  src: IDataParams;
  dest: TParams;
  p: TParam;
begin
  src := TDataParams.Create;
  src.Add(TDataParam.Create('foo', 1));
  src.Add(TDataParam.Create('bar', 1));
  dest := TParams.Create;
  try
    TDataParamsForParams.Create(src, dest).Ref.Adapt;
    check(src.Count = dest.Count, 'count');
    p := dest.FindParam('foo');
    check(assigned(p), 'p assigned');
    check(src.Get('foo').AsString = p.AsString, 'string');
  finally
    dest.Free;
  end;
end;

procedure TDataAdaptersTests.TestTagsAsRawUTF8Array;
var
  a: TRawUTF8DynArray;
begin
  a := TDataTagsAsRawUTF8Array.Create(
    TDataTags.Create('#foo#bar')).Ref.Value;
  check(Length(a) = 2, 'length');
  check(a[0] = '#foo', 'pos 0');
  check(a[1] = '#bar', 'pos 1');
end;

initialization
  TTestSuite.Create('Data').Ref
    .Add(TTest.Create(TDataCoreTests))
    .Add(TTest.Create(TDataAdaptersTests))

end.
