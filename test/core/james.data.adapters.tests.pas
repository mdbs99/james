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
unit James.Data.Adapters.Tests;

{$i James.inc}

interface

uses
  Classes, SysUtils, COMObj, Variants, DB,
  James.Data.Base,
  James.Data.Clss,
  James.Data.Adapters,
  James.RTL.Adapters,
  James.Testing.Clss;

type
  TDataStreamAsOleVariantTest = class(TTestCase)
  published
    procedure TestAdapted;
  end;

  TDataStreamAsParamTest = class(TTestCase)
  published
    procedure TestAdapted;
  end;

  TDataStreamAsStringsTest = class(TTestCase)
  published
    procedure TestAdapted;
  end;

implementation

{ TDataStreamAsOleVariantTest }

procedure TDataStreamAsOleVariantTest.TestAdapted;
var
  S: IDataStream;
begin
  S := TDataStream.New('foo');
  CheckEquals(
    'foo',
    TOleVariantAsDataStream.New(
      TDataStreamAsOleVariant.New(S).Adapted
    ).Adapted.AsString
  );
end;

{ TDataStreamAsParamTest }

procedure TDataStreamAsParamTest.TestAdapted;
var
  S: IDataStream;
  P: TParam;
begin
  S := TDataStream.New('bar');
  P := TParam.Create(nil);
  try
    CheckEquals(
      'bar',
      TDataStreamAsParam.New(S, P).Adapted.AsString
    );
  finally
    P.Free;
  end;
end;

{ TDataStreamAsStringsTest }

procedure TDataStreamAsStringsTest.TestAdapted;
var
  S: IDataStream;
  SL: TStrings;
begin
  S := TDataStream.New('strings');
  SL := TStringList.Create;
  try
    CheckEquals(
      'strings',
      TDataStreamAsStrings.New(S, SL)
        .Adapted
        .Text
        .TrimRight
    );
  finally
    sl.Free;
  end;
end;

initialization
  TTestSuite.New('Core.Data')
    .Add(TTest.New(TDataStreamAsOleVariantTest))
    .Add(TTest.New(TDataStreamAsParamTest))
    .Add(TTest.New(TDataStreamAsStringsTest))

end.
