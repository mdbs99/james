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
  JamesBase,
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
    function ToStream(aStream: TStream): IDataStream;
    function AsRawByteString: RawByteString;
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
    function AsRawUTF8: RawUTF8;
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
    function Exists(const ParamName: RawUTF8): Boolean;
    function Add(const aParam: IDataParam): IDataParams; overload;
    function Add(const aParams: IDataParams): IDataParams; overload;
    function Get(Index: Integer): IDataParam; overload;
    /// will return a parameter if found or a new instance with value NULL
    function Get(const aParamName: RawUTF8): IDataParam; overload;
    function Count: Integer;
    function AsRawUTF8(const aSeparator: RawUTF8 = ','): RawUTF8; overload;
  end;

  /// DataParams copier
  // - copy all parameters from one to another instance
  TDataParamsCopier = class(TInterfacedObject, IProcedure)
  private
    fSrc: IDataParams;
    fDest: IDataParams;
  public
    constructor Create(const aSrc, aDest: IDataParams); reintroduce;
    function Ref: IProcedure;
    /// will copy all params from Src to Dest
    procedure Exec;
  end;

  TDataUUID = class(TInterfacedObject, IDataUUID)
  private
    fUUID: TGuid;
  public
    constructor Create(const aUUID: TGuid); reintroduce; overload;
    /// aUUID should be a valid UUID, otherwise it will be initialize all zeroed
    constructor Create(const aUUID: RawUTF8); overload;
    /// aUUID should be a valid UUID, otherwise it will be initialize all zeroed
    constructor Create(aUUID: Variant); overload;
    constructor Create; overload;
    function Ref: IDataUUID;
    function Value: TGuid;
    function AsString: ShortString;
    function AsSmallString: ShortString;
  end;

  TNullUUID = class(TDataUUID, IDataUUID)
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
    function SplittedList: TStringList;
  public
    constructor Create(const aTags: RawUTF8);
    destructor Destroy; override;
    function Ref: IDataTags;
    /// add the tag on the internal list
    function Add(const aTag: RawUTF8): IDataTags;
    /// return the value from the aIndex
    function Get(aIndex: PtrInt): RawUTF8;
    /// will check if the tag exists on the internal list
    function Exists(const aTag: RawUTF8): Boolean;
    /// return total tags on the internal list
    function Count: Integer;
    /// return tags passed on constructor, without modifications
    function Tags: RawUTF8;
  end;

implementation

{ TDataParamsCopier }

constructor TDataParamsCopier.Create(const aSrc, aDest: IDataParams);
begin
  inherited Create;
  fSrc := aSrc;
  fDest := aDest;
end;

function TDataParamsCopier.Ref: IProcedure;
begin
  result := self;
end;

procedure TDataParamsCopier.Exec;
var
  i: Integer;
  p: IDataParam;
begin
  for i := 0 to fSrc.Count -1 do
  begin
    p := fSrc.Get(i);
    fDest.Get(p.Name).AsParam.Value := p.Value;
  end;
end;

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

function TDataStream.ToStream(aStream: TStream): IDataStream;
begin
  result := self;
  fStream.SaveToStream(aStream);
  aStream.Position := 0;
end;

function TDataStream.AsRawByteString: RawByteString;
begin
  fStream.Position := 0;
  result := StreamToRawByteString(fStream);
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

function TDataStrings.AsRawUTF8: RawUTF8;
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

function TDataParams.Exists(const ParamName: RawUTF8): Boolean;
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

function TDataParams.Add(const aParam: IDataParam): IDataParams;
begin
  result := self;
  fList.Add(aParam);
end;

function TDataParams.Add(const aParams: IDataParams): IDataParams;
var
  I: Integer;
begin
  result := self;
  for I := 0 to aParams.Count-1 do
    Add(aParams.Get(I));
end;

function TDataParams.Get(Index: Integer): IDataParam;
begin
  result := fList.Items[Index] as IDataParam;
end;

function TDataParams.Get(const aParamName: RawUTF8): IDataParam;
var
  i: Integer;
  p: IDataParam;
begin
  result := nil;
  for i := 0 to fList.Count -1 do
  begin
    p := Get(i);
    if CompareText(p.Name, aParamName) = 0 then
    begin
      result := p;
      exit;
    end;
  end;
  if result = nil then
  begin
    result := TDataParam.Create(aParamName, NULL);
    Add(result);
  end;
end;

function TDataParams.Count: Integer;
begin
  result := fList.Count;
end;

function TDataParams.AsRawUTF8(const aSeparator: RawUTF8): RawUTF8;
var
  i: Integer;
begin
  result := '';
  for i := 0 to Count-1 do
  begin
    if i > 0 then
      result := result + aSeparator;
     result := result + Get(i).AsString;
  end;
end;

{ TDataUUID }

constructor TDataUUID.Create(const aUUID: TGuid);
begin
  inherited Create;
  fUUID := aUUID;
end;

constructor TDataUUID.Create(const aUUID: RawUTF8);
var
  s: string;
  g: TGuid;
begin
  s := aUUID;
  if Copy(s, 1, 1) <> '{' then
    s := '{' + s + '}';
  try
    g := StringToGuid(s);
  except
    g := TNullUUID.Create.Ref.Value;
  end;
  Create(g);
end;

constructor TDataUUID.Create(aUUID: Variant);
begin
  if VarIsStr(aUUID) then
    Create(VarToStr(aUUID))
  else
    Create(TNullUUID.Create.Ref.Value);
end;

constructor TDataUUID.Create;
var
  g: TGUID;
  s: string;
begin
  CreateGUID(g);
  s := GUIDToString(g);
  Create(Copy(s, 2, Length(s)-2));
end;

function TDataUUID.Ref: IDataUUID;
begin
  result := self;
end;

function TDataUUID.Value: TGuid;
begin
  result := fUUID;
end;

function TDataUUID.AsString: ShortString;
begin
  result := GuidToString(fUUID);
end;

function TDataUUID.AsSmallString: ShortString;
begin
  result := Copy(AsString, 2, 8);
end;

{ TNullUUID }

constructor TNullUUID.Create;
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
      fStream.ToStream(m);
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
    aDest.Text := Trim(StringReplaceAll(aTags, '#', #13'#'));
end;

function TDataTags.SplittedList: TStringList;
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
  result := SplittedList.Strings[aIndex];
end;

function TDataTags.Exists(const aTag: RawUTF8): Boolean;
var
  i: Integer;
  l: TStringList;
begin
  result := False;
  l := TStringList.Create;
  try
    Split(aTag, l);
    for i := 0 to l.Count-1 do
    begin
      if SplittedList.IndexOf(l.Strings[i]) = -1 then
        exit;
    end;
    result := True;
  finally
    l.Free;
  end;
end;

function TDataTags.Count: Integer;
begin
  result := SplittedList.Count;
end;

function TDataTags.Tags: RawUTF8;
begin
  result := fTags;
end;

end.
