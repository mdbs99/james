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
  TDataStreamTest = class(TTestCase)
  published
    procedure TestAsString;
    procedure TestSaveStream;
    procedure TestSaveStrings;
  end;

  TDataParamTest = class(TTestCase)
  published
    procedure TestAutoDataType;
  end;

  TDataParamsTest = class(TTestCase)
  published
    procedure TestAdd;
    procedure TestAddParam;
    procedure TestAddParams;
    procedure TestGetByIndex;
    procedure TestGetByName;
    procedure TestCount;
    procedure TestAsStringWithSeparator;
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

{ TDataParamsTest }

procedure TDataParamsTest.TestAdd;
begin
  CheckEquals(
    10,
    TDataParams.New
      .Add(TDataParam.New('foo', ftSmallint, 10))
      .Get(0)
      .AsInteger
  );
end;

procedure TDataParamsTest.TestAddParam;
var
  P: IDataParam;
begin
  P := TDataParam.New('foo', 20);
  CheckEquals(
    P.AsInteger,
    TDataParams.New
      .Add(P)
      .Get(0)
      .AsInteger
  );
end;

procedure TDataParamsTest.TestAddParams;
begin
  CheckEquals(
    5,
    TDataParams.New
      .Add(TDataParam.New('1', 1))
      .Add(TDataParam.New('2', 2))
      .Add(
        TDataParams.New
          .Add(TDataParam.New('3', 3))
          .Add(TDataParam.New('4', 4))
          .Add(TDataParam.New('5', 4))
      )
      .Count
  );
end;

procedure TDataParamsTest.TestGetByIndex;
begin
  CheckEquals(
    2,
    TDataParams.New
      .Add(TDataParam.New('1', 1))
      .Add(TDataParam.New('2', 2))
      .Get(1)
      .AsInteger
  );
end;

procedure TDataParamsTest.TestGetByName;
begin
  CheckEquals(
    33,
    TDataParams.New
      .Add(TDataParam.New('foo', 22))
      .Add(TDataParam.New('bar', 33))
      .Get('bar')
      .AsInteger
  );
end;

procedure TDataParamsTest.TestCount;
begin
  CheckEquals(
    5,
    TDataParams.New
      .Add(TDataParam.New('1', 1))
      .Add(TDataParam.New('2', 2))
      .Add(TDataParam.New('3', 3))
      .Add(TDataParam.New('4', 4))
      .Add(TDataParam.New('5', 4))
      .Count
  );
end;

procedure TDataParamsTest.TestAsStringWithSeparator;
begin
  CheckEquals(
    '1;2;3',
    TDataParams.New
      .Add(TDataParam.New('1', 1))
      .Add(TDataParam.New('2', 2))
      .Add(TDataParam.New('3', 3))
      .AsString(';')
  );
end;

{ TDataStreamTest }

procedure TDataStreamTest.TestAsString;
const
  TXT: string = 'Line1-'#13#10'Line2-'#13#10'Line3';
var
  Buf: TMemoryStream;
  Ss: TStrings;
begin
  Buf := TMemoryStream.Create;
  Ss := TStringList.Create;
  try
    Buf.WriteBuffer(TXT[1], Length(TXT) * SizeOf(Char));
    Ss.Text := TXT;
    CheckEquals(TXT, TDataStream.New(Buf).AsString, 'Test Stream');
    CheckEquals(TXT, TDataStream.New(TXT).AsString, 'Test String');
    CheckEquals(TXT+#13#10, TDataStream.New(Ss).AsString, 'Test Strings');
  finally
    Buf.Free;
    Ss.Free;
  end;
end;

procedure TDataStreamTest.TestSaveStream;
const
  TXT: string = 'ABCDEFG#13#10IJL';
var
  Buf: TMemoryStream;
  S: string;
begin
  Buf := TMemoryStream.Create;
  try
    TDataStream.New(TXT).Save(Buf);
    SetLength(S, Buf.Size * SizeOf(Char));
    Buf.Position := 0;
    Buf.ReadBuffer(S[1], Buf.Size);
    CheckEquals(TXT, S);
  finally
    Buf.Free;
  end;
end;

procedure TDataStreamTest.TestSaveStrings;
const
  TXT: string = 'ABCDEFG#13#10IJLMNO-PQRS';
var
  S: TStrings;
  M: TMemoryStream;
begin
  M := TMemoryStream.Create;
  S := TStringList.Create;
  try
    TDataStream.New(TXT).Save(M);
    S.LoadFromStream(M);
    CheckEquals(TXT+#13#10, S.Text);
  finally
    M.Free;
    S.Free;
  end;
end;

{ TDataParamTest }

procedure TDataParamTest.TestAutoDataType;
var
  Params: IDataParams;
begin
  Params := TDataParams.New
    .Add(TDataParam.New('p1', 'str'))
    .Add(TDataParam.New('p2', 10))
    .Add(TDataParam.New('p3', 20.50))
    ;
  CheckEquals(
    GetEnumName(TypeInfo(TFieldType), Integer(ftString)),
    GetEnumName(TypeInfo(TFieldType), Integer(Params.Get(0).DataType))
  );
  CheckEquals(
    GetEnumName(TypeInfo(TFieldType), Integer(ftSmallint)),
    GetEnumName(TypeInfo(TFieldType), Integer(Params.Get(1).DataType))
  );
  CheckEquals(
    GetEnumName(TypeInfo(TFieldType), Integer(ftFloat)),
    GetEnumName(TypeInfo(TFieldType), Integer(Params.Get(2).DataType))
  );
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
    TDataParam.New(FId, ftString, FText)
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
  CheckEquals('c:\path\', TDataFile.New('c:\path\filename.txt').Path);
end;

procedure TDataFileTest.TestName;
begin
  CheckEquals('filename.txt', TDataFile.New('c:\path\filename.txt').Name);
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
    CheckEquals(TXT, TDataFile.New(FILE_NAME).Stream.AsString);
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
  a.Init(TDataStream.New('foo'));
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
  s := TDataStream.New('bar');
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
  s := TDataStream.New('strings');
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
    .Add(TTest.Create(TDataStreamTest))
    .Add(TTest.Create(TDataParamTest))
    .Add(TTest.Create(TDataParamsTest))
    .Add(TTest.Create(TDataGuidTest))
    .Add(TTest.Create(TDataConstraintsTest))
    .Add(TTest.Create(TDataFileTest))
    .Add(TTest.Create(TDataStreamAdapterTest))
    ;

end.
