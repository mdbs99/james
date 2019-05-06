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
unit JamesDataBase;

{$i James.inc}

interface

uses
  Classes,
  SysUtils,
  Variants,
  DB,
  SynCommons,
  JamesBase;

type
  EDataException = class(EJamesException);

  IDataStream = interface
  ['{698868A5-9C57-4F1F-9E84-4AA7580CB01A}']
    function ToStream(aStream: TStream): IDataStream;
    function AsRawByteString: RawByteString;
    function Size: Int64;
  end;

  IDataStreamOf = interface
    function Value: IDataStream;
  end;

  IDataStrings = interface
  ['{CC6CBD96-D204-4D32-81B5-DBEDF90D73F9}']
    function Add(const aText: RawUTF8): IDataStrings;
    function Get(aIndex: PtrInt): RawUTF8;
    function Count: Integer;
    function AsRawUTF8: RawUTF8;
  end;

  IDataValue = interface
  ['{4D31F652-B7C1-428D-89D5-292D11301E41}']
    function Name: string;
    function DataType: TFieldType;
    function Value: Variant;
    function IsNull: Boolean;
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

  IDataValueOf = interface
  ['{95B46B49-3B55-44BA-ADD9-EAC7C91B68C5}']
    function Value: IDataValue;
  end;

  IDataParam = interface(IDataValue)
  ['{2C6B41D7-CB75-488A-85D4-59CE4D5388E5}']
    function AsParam: TParam;
  end;

  IDataParamOf = interface
  ['{58CDF012-C58C-4AC2-9A95-6E1CC1745237}']
    function Value: IDataParam;
  end;

  IDataParams = interface
  ['{650DE166-6452-4F22-80F8-F364B9BF4C50}']
    function Exists(const ParamName: RawUTF8): Boolean;
    function Add(const aParam: IDataParam): IDataParams; overload;
    function Add(const aParams: IDataParams): IDataParams; overload;
    function Get(Index: Integer): IDataParam; overload;
    function Get(const ParamName: RawUTF8): IDataParam; overload;
    function Count: Integer;
    function AsRawUTF8(const aSeparator: RawUTF8 = ','): RawUTF8; overload;
  end;

  IDataParamsOf = interface
  ['{D4471122-05CA-46D1-A3E7-95BCB7245406}']
    function Values: IDataParams;
  end;

  IDataGuid = interface
  ['{F7269A91-B5E7-4067-BB8E-8712BC99EE08}']
    function Value: TGuid;
    function AsString: ShortString;
    function AsSmallString: ShortString;
  end;

  IDataResult = interface
  ['{9E1AB274-707A-4770-94B9-659945547A19}']
    function Success: Boolean;
    function Data: IDataParams;
  end;

  IDataResultOf = interface
  ['{312900FF-997C-45D2-9FF1-5C1454CEB937}']
    function Value: IDataResult;
  end;

  IDataConstraint = interface
  ['{C580D0F6-B724-468F-9B74-40F7D49DA5DA}']
    function Evaluate: IDataResult;
  end;

  IDataConstraints = interface(IDataConstraint)
  ['{31FA938E-93C9-4450-B34F-DDC4B2935899}']
    function Add(const AConstraint: IDataConstraint): IDataConstraints;
    function Get(Index: Integer): IDataConstraint;
    function Count: Integer;
  end;

  IDataFile = interface
  ['{E700F3AE-3DD6-4146-A256-E516B692BC0A}']
    function Save: Boolean;
    function Delete: Boolean;
    function Path: TFileName;
    function Name: TFileName;
    function PathName: TFileName;
    function Stream: IDataStream;
  end;

  IDataTags = interface
  ['{100F328D-5E1E-46EC-83BD-EA9177396518}']
    function Add(const aTag: RawUTF8): IDataTags;
    function Get(aIndex: PtrInt): RawUTF8;
    function Exists(const aTags: RawUTF8): Boolean;
    function Count: Integer;
    function AsRawUTF8: RawUTF8;
  end;

  IDataTagsOf = interface
  ['{83990CC0-27A9-446D-9053-95AB851F7D4A}']
    function Value: IDataTags;
  end;

implementation

end.

