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
unit James.Data;

{$include james.inc}

interface

uses
  Classes, SysUtils, Variants, DB;

type
  IDataStream = interface
    function Save(Stream: TStream): IDataStream; overload;
    function Save(Strings: TStrings): IDataStream; overload;
    function Save(const FileName: string): IDataStream; overload;
    function AsString: string;
    function Size: Int64;
  end;

  IDataInformation = interface
  ['{4E1B718C-D76E-4D3B-9781-866E767CD5EA}']
    function Id: string;
    function Text: string;
    function Metadata: string;
  end;

  IDataInformations = interface
  ['{4402481A-49D9-4722-B0CB-952C728932B6}']
    function Add(Info: IDataInformation): IDataInformations; overload;
    function Add(Infos: IDataInformations): IDataInformations; overload;
    function Get(Index: Integer): IDataInformation;
    function Count: Integer;
    function Text: string;
  end;

  IDataParam = interface
  ['{2C6B41D7-CB75-488A-85D4-59CE4D5388E5}']
    function Name: string;
    function Value: Variant;
    function IsNull: Boolean;
    function AsParam: TParam;
    function AsBCD: Currency;
    function AsBlob: TBlobData;
    function AsBoolean: Boolean;
    function AsCurrency: Currency;
    function AsDate: TDateTime;
    function AsDateTime: TDateTime;
    function AsFloat: Double;
    function AsInteger: LongInt;
    function AsSmallInt: LongInt;
    function AsMemo: string;
    function AsString: string;
    function AsTime: TDateTime;
    function AsWord: LongInt;
  end;

  IDataParams = interface
    function Add(Param: IDataParam): IDataParams; overload;
    function Add(const ParamName: string; DataType: TFieldType; Value: Variant): IDataParams; overload;
    function Param(Index: Integer): IDataParam; overload;
    function Param(const ParamName: string): IDataParam; overload;
    function Count: Integer;
    function AsString(const SeparatorChar: string): string; overload;
    function AsString: string; overload;
  end;

  IDataResult = interface
  ['{9E1AB274-707A-4770-94B9-659945547A19}']
    function OK: Boolean;
    function Data: IDataParams;
    function Informations: IDataInformations;
  end;

  IDataConstraint = interface
  ['{C580D0F6-B724-468F-9B74-40F7D49DA5DA}']
    function Checked: IDataResult;
  end;

  IDataConstraints = interface
  ['{31FA938E-93C9-4450-B34F-DDC4B2935899}']
    function Add(C: IDataConstraint): IDataConstraints;
    function Get(Index: Integer): IDataConstraint;
    function Count: Integer;
    function Checked: IDataResult;
  end;

implementation

end.

