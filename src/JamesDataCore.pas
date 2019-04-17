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
unit JamesDataCore;

{$i James.inc}

interface

uses
  Classes,
  SysUtils,
  DB,
  Variants,
  SynCommons,
  JamesDataBase;

type
  TDataStream = class(TInterfacedObject, IDataStream)
  private
    fStream: TMemoryStream;
  public
    constructor Create(aStream: TStream); reintroduce; overload;
    constructor Create(const aText: RawByteString); overload;
    constructor Create(aStrings: TStrings); overload;
    constructor Create; overload;
    destructor Destroy; override;
    function Ref: IDataStream;
    function Save(aStream: TStream): IDataStream; overload;
    function AsString: RawByteString;
    function Size: Int64;
  end;

  TDataStrings = class(TInterfacedObject, IDataStrings)
  private
    fList: TRawUTF8List;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function Add(const aText: RawUTF8): IDataStrings;
    function Get(aIndex: PtrInt): RawUTF8;
    function Count: Integer;
    function Text: RawUTF8;
  end;

  TDataParam = class(TInterfacedObject, IDataParam)
  private
    fParam: TParam;
  public
    constructor Create(const Name: string; DataType: TFieldType; Value: Variant); reintroduce; overload;
    constructor Create(const Name: string; Value: Variant); overload;
    destructor Destroy; override;
    function Ref: IDataParam;
    function Name: string;
    function DataType: TFieldType;
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

  EDataParams = class(EDataException);

  TDataParams = class(TInterfacedObject, IDataParams)
  private
    fList: TInterfaceList;
  public
    constructor Create; virtual;
    class function New: IDataParams; overload;
    class function New(Origin: TFields): IDataParams; overload;
    destructor Destroy; override;
    function Ref: IDataParams;
    function Exists(const ParamName: string): Boolean;
    function Add(const AParam: IDataParam): IDataParams; overload;
    function Add(const AParams: IDataParams): IDataParams; overload;
    function Get(Index: Integer): IDataParam; overload;
    function Get(const ParamName: string): IDataParam; overload;
    function Count: Integer;
    function AsRawUTF8(const aSeparator: RawUTF8): RawUTF8; overload;
    function AsRawUTF8: RawUTF8; overload;
    function ToParams(aDest: TParams): IDataParams;
  end;

  TDataGuid = class(TInterfacedObject, IDataGuid)
  private
    fGuid: TGuid;
  public
    constructor Create(const aGuid: TGuid); reintroduce; overload;
    constructor Create(const aGuid: RawUTF8); overload;
    constructor Create(aGuid: Variant); overload;
    constructor Create; overload;
    function Ref: IDataGuid;
    function Value: TGuid;
    function AsString: ShortString;
    function AsSmallString: ShortString;
  end;

  TNullGuid = class(TDataGuid, IDataGuid)
  public
    constructor Create; reintroduce;
  end;

  TDataResult = class(TInterfacedObject, IDataResult)
  private
    FSuccess: Boolean;
    FData: IDataParams;
  public
    constructor Create(Success: Boolean; const Data: IDataParams); reintroduce; overload;
    class function New(Success: Boolean; const Data: IDataParams): IDataResult; overload;
    class function New(Success: Boolean; const Data: IDataParam): IDataResult; overload;
    class function New(Success: Boolean): IDataResult; overload;
    function Success: Boolean;
    function Data: IDataParams;
  end;

  TDataConstraints = class(TInterfacedObject, IDataConstraint, IDataConstraints)
  private
    FList: IInterfaceList;
  public
    constructor Create;
    function Ref: IDataConstraints;
    function Add(const AConstraint: IDataConstraint): IDataConstraints;
    function Get(Index: Integer): IDataConstraint;
    function Count: Integer;
    function Evaluate: IDataResult;
  end;

  TDataFile = class(TInterfacedObject, IDataFile)
  private
    fFileName: TFileName;
    fStream: IDataStream;
  public
    constructor Create(const aFileName: TFileName; const aStream: IDataStream); reintroduce; overload;
    constructor Create(const aFileName: TFileName); overload;
    function Ref: IDataFile;
    function Save: Boolean;
    function Delete: Boolean;
    function Path: TFileName;
    function Name: TFileName;
    function PathName: TFileName;
    function Stream: IDataStream;
  end;

  TDataTags = class(TInterfacedObject, IDataTags)
  private
    fTags: RawUTF8;
    fList: TStringList;
    procedure Split(const aTags: RawUTF8; aDest: TStringList);
    function List: TStringList;
  public
    constructor Create(const aTags: RawUTF8);
    destructor Destroy; override;
    function Ref: IDataTags;
    function Add(const aTag: RawUTF8): IDataTags;
    function Get(aIndex: PtrInt): RawUTF8;
    function Exists(const aTags: RawUTF8): Boolean;
    function Count: Integer;
    function AsRawUTF8: RawUTF8;
  end;

implementation

{ TDataStream }

constructor TDataStream.Create(aStream: TStream);
begin
  inherited Create;
  fStream := TMemoryStream.Create;
  if Assigned(aStream) then
    fStream.LoadFromStream(aStream);
end;

constructor TDataStream.Create(const aText: RawByteString);
var
  m: TStringStream;
begin
  m := TStringStream.Create(aText);
  try
    Create(m);
  finally
    m.Free;
  end;
end;

constructor TDataStream.Create(aStrings: TStrings);
var
  m: TMemoryStream;
begin
  m := TMemoryStream.Create;
  try
    aStrings.SaveToStream(m);
    Create(m);
  finally
    m.Free;
  end;
end;

constructor TDataStream.Create;
begin
  Create('');
end;

destructor TDataStream.Destroy;
begin
  fStream.Free;
  inherited Destroy;
end;

function TDataStream.Ref: IDataStream;
begin
  result := self;
end;

function TDataStream.Save(aStream: TStream): IDataStream;
begin
  result := self;
  fStream.SaveToStream(aStream);
  aStream.Position := 0;
end;

function TDataStream.AsString: RawByteString;
begin
  with fStream do
  begin
    result := '';
    SetLength(result, Size);
    Position := 0;
    ReadBuffer(Pointer(result)^, Size);
  end;
end;

function TDataStream.Size: Int64;
begin
  result := fStream.Size;
end;

{ TDataStrings }

constructor TDataStrings.Create;
begin
  inherited Create;
  fList := TRawUTF8List.Create;
end;

destructor TDataStrings.Destroy;
begin
  fList.Free;
  inherited Destroy;
end;

function TDataStrings.Add(const aText: RawUTF8): IDataStrings;
begin
  result := self;
  fList.Add(aText);
end;

function TDataStrings.Get(aIndex: PtrInt): RawUTF8;
begin
  result := fList.Get(aIndex);
end;

function TDataStrings.Count: Integer;
begin
  result := fList.Count;
end;

function TDataStrings.Text: RawUTF8;
begin
  result := fList.Text;
end;

{ TDataParam }

constructor TDataParam.Create(const Name: string; DataType: TFieldType; Value: Variant);
begin
  inherited Create;
  fParam := TParam.Create(nil);
  fParam.Name := Name;
  fParam.DataType := DataType;
  fParam.Value := Value;
end;

constructor TDataParam.Create(const Name: string; Value: Variant);
begin
  Create(Name, ftUnknown, Value);
end;

destructor TDataParam.Destroy;
begin
  fParam.Free;
  inherited;
end;

function TDataParam.Ref: IDataParam;
begin
  result := self;
end;

function TDataParam.Name: string;
begin
  result := fParam.Name;
end;

function TDataParam.DataType: TFieldType;
begin
  result := fParam.DataType;
end;

function TDataParam.Value: Variant;
begin
  result := fParam.Value;
end;

function TDataParam.IsNull: Boolean;
begin
  result := fParam.IsNull;
end;

function TDataParam.AsParam: TParam;
begin
  result := fParam;
end;

function TDataParam.AsBCD: Currency;
begin
  result := fParam.AsBCD;
end;

function TDataParam.AsBlob: TBlobData;
begin
  result := fParam.AsBlob;
end;

function TDataParam.AsBoolean: Boolean;
begin
  result := fParam.AsBoolean;
end;

function TDataParam.AsCurrency: Currency;
begin
  result := fParam.AsCurrency;
end;

function TDataParam.AsDate: TDateTime;
begin
  result := fParam.AsDate;
end;

function TDataParam.AsDateTime: TDateTime;
begin
  result := fParam.AsDateTime;
end;

function TDataParam.AsFloat: Double;
begin
  result := fParam.AsFloat;
end;

function TDataParam.AsInteger: LongInt;
begin
  result := fParam.AsInteger;
end;

function TDataParam.AsSmallInt: LongInt;
begin
  result := fParam.AsSmallInt;
end;

function TDataParam.AsMemo: string;
begin
  result := fParam.AsMemo;
end;

function TDataParam.AsString: string;
begin
  result := fParam.AsString;
end;

function TDataParam.AsTime: TDateTime;
begin
  result := fParam.AsTime;
end;

function TDataParam.AsWord: LongInt;
begin
  result := fParam.AsWord;
end;

{ TDataParams }

constructor TDataParams.Create;
begin
  inherited Create;
  fList := TInterfaceList.Create;
end;

class function TDataParams.New: IDataParams;
begin
  result := Create;
end;

class function TDataParams.New(Origin: TFields): IDataParams;
var
  I: Integer;
begin
  result := self.New;
  for I := 0 to Origin.Count -1 do
    with Origin[I] do
      result.Add(TDataParam.Create(FieldName, DataType, Value));
end;

destructor TDataParams.Destroy;
begin
  fList.Free;
  inherited;
end;

function TDataParams.Ref: IDataParams;
begin
  result := self;
end;

function TDataParams.Exists(const ParamName: string): Boolean;
var
  I: Integer;
begin
  result := False;
  for I := 0 to fList.Count -1 do
  begin
    if Get(I).Name = ParamName then
    begin
      result := True;
      Break;
    end;
  end;
end;

function TDataParams.Add(const AParam: IDataParam): IDataParams;
begin
  result := self;
  fList.Add(AParam);
end;

function TDataParams.Add(const AParams: IDataParams): IDataParams;
var
  I: Integer;
begin
  result := self;
  for I := 0 to AParams.Count-1 do
    Add(AParams.Get(I));
end;

function TDataParams.Get(Index: Integer): IDataParam;
begin
  result := fList.Items[Index] as IDataParam;
end;

function TDataParams.Get(const ParamName: string): IDataParam;
var
  I: Integer;
  P: IDataParam;
begin
  P := nil;
  result := nil;
  for I := 0 to fList.Count -1 do
  begin
    P := Get(I);
    if CompareText(P.Name, ParamName) = 0 then
    begin
      result := P;
      exit;
    end;
  end;
  if not Assigned(P) then
    raise EDataParams.CreateFmt('Param "%s" not found.', [ParamName]);
end;

function TDataParams.Count: Integer;
begin
  result := fList.Count;
end;

function TDataParams.AsRawUTF8(const aSeparator: RawUTF8): RawUTF8;
var
  I: Integer;
begin
  result := '';
  for I := 0 to Count-1 do
  begin
    if I > 0 then
      result := result + aSeparator;
     result := result + Get(I).AsString;
  end;
end;

function TDataParams.AsRawUTF8: RawUTF8;
begin
  result := AsRawUTF8(',');
end;

function TDataParams.ToParams(aDest: TParams): IDataParams;
var
  i: Integer;
  p: TParam;
begin
  result := self;
  if not assigned(aDest) then
    exit;
  for i := 0 to Count -1 do
  begin
    p := TParam.Create(aDest);
    with Get(i).AsParam do
    begin
      p.Name := Name;
      p.ParamType := ParamType;
      p.DataType := DataType;
      p.Value := Value;
    end;
  end;
end;

{ TDataGuid }

constructor TDataGuid.Create(const aGuid: TGuid);
begin
  inherited Create;
  fGuid := aGuid;
end;

constructor TDataGuid.Create(const aGuid: RawUTF8);
var
  s: string;
  g: TGuid;
begin
  s := aGuid;
  if Copy(s, 1, 1) <> '{' then
    s := '{' + s + '}';
  try
    g := StringToGuid(s);
  except
    g := TNullGuid.Create.Ref.Value;
  end;
  Create(g);
end;

constructor TDataGuid.Create(aGuid: Variant);
begin
  if VarIsStr(aGuid) then
    Create(VarToStr(aGuid))
  else
    Create(TNullGuid.Create.Ref.Value);
end;

constructor TDataGuid.Create;
var
  g: TGUID;
  s: string;
begin
  CreateGUID(g);
  s := GUIDToString(g);
  Create(Copy(s, 2, Length(s)-2));
end;

function TDataGuid.Ref: IDataGuid;
begin
  result := self;
end;

function TDataGuid.Value: TGuid;
begin
  result := fGuid;
end;

function TDataGuid.AsString: ShortString;
begin
  result := GuidToString(fGuid);
end;

function TDataGuid.AsSmallString: ShortString;
begin
  result := Copy(AsString, 2, 8);
end;

{ TNullGuid }

constructor TNullGuid.Create;
begin
  inherited Create('{00000000-0000-0000-0000-000000000000}');
end;

{ TDataResult }

constructor TDataResult.Create(Success: Boolean; const Data: IDataParams);
begin
  inherited Create;
  FSuccess := Success;
  FData := Data;
end;

class function TDataResult.New(Success: Boolean; const Data: IDataParams
  ): IDataResult;
begin
  result := Create(Success, Data);
end;

class function TDataResult.New(Success: Boolean; const Data: IDataParam
  ): IDataResult;
begin
  result := New(Success, TDataParams.New.Add(Data))
end;

class function TDataResult.New(Success: Boolean): IDataResult;
begin
  result := New(Success, TDataParams.New);
end;

function TDataResult.Success: Boolean;
begin
  result := FSuccess;
end;

function TDataResult.Data: IDataParams;
begin
  result := FData;
end;

{ TDataConstraints }

constructor TDataConstraints.Create;
begin
  inherited Create;
  FList := TInterfaceList.Create;
end;

function TDataConstraints.Ref: IDataConstraints;
begin
  result := self;
end;

function TDataConstraints.Add(const AConstraint: IDataConstraint
  ): IDataConstraints;
begin
  result := self;
  FList.Add(AConstraint);
end;

function TDataConstraints.Get(Index: Integer): IDataConstraint;
begin
  result := FList.Items[Index] as IDataConstraint;
end;

function TDataConstraints.Count: Integer;
begin
  result := FList.Count;
end;

function TDataConstraints.Evaluate: IDataResult;
var
  I: Integer;
  Ok: Boolean;
  R: IDataResult;
  Params: IDataParams;
begin
  Ok := True;
  Params := TDataParams.New;
  for I := 0 to Count-1 do
  begin
    R := Get(I).Evaluate;
    if not R.Success then
      Ok := False;
    Params.Add(R.Data);
  end;
  result := TDataResult.New(Ok, Params);
end;

{ TDataFile }

constructor TDataFile.Create(const aFileName: TFileName; const aStream: IDataStream);
begin
  inherited Create;
  fFileName := aFileName;
  fStream := aStream;
end;

constructor TDataFile.Create(const aFileName: TFileName);
begin
  Create(aFileName, TDataStream.Create);
end;

function TDataFile.Ref: IDataFile;
begin
  result := self;
end;

function TDataFile.Save: Boolean;
var
  m: TMemoryStream;
begin
  m := TMemoryStream.Create;
  try
    try
      fStream.Save(m);
      m.SaveToFile(fFileName);
      result := True;
    except
      result := False;
    end;
  finally
    m.Free;
  end;
end;

function TDataFile.Delete: Boolean;
begin
  if not FileExists(fFileName) then
    result := True
  else
    result := DeleteFile(fFileName);
end;

function TDataFile.Path: TFileName;
begin
  result := SysUtils.ExtractFilePath(fFileName);
end;

function TDataFile.Name: TFileName;
begin
  result := SysUtils.ExtractFileName(fFileName);
end;

function TDataFile.PathName: TFileName;
begin
  result := fFileName;
end;

function TDataFile.Stream: IDataStream;
var
  fs: TFileStream;
begin
  if not (Save and FileExists(fFileName)) then
    raise EFCreateError.CreateFmt('Error saving "%s"', [fFileName]);
  fs := TFileStream.Create(fFileName, fmOpenRead or fmShareDenyNone);
  try
    fStream := TDataStream.Create(fs);
    result := fStream;
  finally
    fs.Free;
  end;
end;

{ TDataTags }

procedure TDataTags.Split(const aTags: RawUTF8; aDest: TStringList);
begin
  if aDest.Count = 0 then
  begin
    aDest.Text :=
      Trim(
        StringReplace(
          aTags, '#', #13'#', [rfReplaceAll]
        )
      );
  end;
end;

function TDataTags.List: TStringList;
begin
  result := fList;
  Split(fTags, fList);
end;

constructor TDataTags.Create(const aTags: RawUTF8);
begin
  inherited Create;
  fList := TStringList.Create;
  fTags := aTags;
end;

destructor TDataTags.Destroy;
begin
  fList.Free;
  inherited;
end;

function TDataTags.Ref: IDataTags;
begin
  result := self;
end;

function TDataTags.Add(const aTag: RawUTF8): IDataTags;
begin
  result := self;
  fTags := fTags + aTag;
end;

function TDataTags.Get(aIndex: PtrInt): RawUTF8;
begin
  result := List.Strings[aIndex];
end;

function TDataTags.Exists(const aTags: RawUTF8): Boolean;
var
  i: Integer;
  l: TStringList;
begin
  result := False;
  l := TStringList.Create;
  try
    Split(aTags, l);
    for i := 0 to l.Count-1 do
    begin
      if List.IndexOf(l.Strings[i]) = -1 then
        exit;
    end;
    result := True;
  finally
    l.Free;
  end;
end;

function TDataTags.Count: Integer;
begin
  result := List.Count;
end;

function TDataTags.AsRawUTF8: RawUTF8;
begin
  result := fTags;
end;

end.
