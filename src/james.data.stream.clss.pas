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
unit James.Data.Stream.Clss;

{$include james.inc}

interface

uses
  Classes, SysUtils,
  James.Data,
  James.Data.Clss;

type
  TDataDividedStream = class sealed(TInterfacedObject, IDataStream)
  private
    FOrigin: IDataStream;
    FFromPos: Integer;
    FTotalPos: Integer;
    function GetStream: IDataStream;
  public
    constructor Create(Origin: IDataStream; FromPos, TotalPos: Integer); reintroduce;
    class function New(Origin: IDataStream; FromPos, TotalPos: Integer): IDataStream;
    function Save(Stream: TStream): IDataStream; overload;
    function Save(const FileName: string): IDataStream; overload;
    function Save(Strings: TStrings): IDataStream; overload;
    function AsString: string;
    function Size: Int64;
  end;

  TDataPartialFromTextStream = class sealed(TInterfacedObject, IDataStream)
  private
    FOrigin: IDataStream;
    FFromText: string;
    function GetStream: IDataStream;
  public
    constructor Create(Origin: IDataStream; const FromText: string); reintroduce;
    class function New(Origin: IDataStream; const FromText: string): IDataStream;
    function Save(Stream: TStream): IDataStream; overload;
    function Save(const FileName: string): IDataStream; overload;
    function Save(Strings: TStrings): IDataStream; overload;
    function AsString: string;
    function Size: Int64;
  end;

implementation

{ TDataDividedStream }

function TDataDividedStream.GetStream: IDataStream;
var
  M: TMemoryStream;
  B: TBytes;
  ParcelaBytes: Int64;
  Offset: Int64;
begin
  Offset := 0;
  M := TMemoryStream.Create;
  try
    FOrigin.Save(M);
    ParcelaBytes := M.Size div FTotalPos;
    Offset := ParcelaBytes * (Int64(FFromPos)-1);
    M.Seek(Offset, soFromBeginning);
    if (FFromPos = 1) and (FTotalPos = 1) then
      SetLength(B, M.Size)
    else if FFromPos < FTotalPos then
      SetLength(B, ParcelaBytes)
    else if FFromPos = FTotalPos then
      SetLength(B, M.Size - Offset);
    M.ReadBuffer(Pointer(B)^, Length(B));
    M.Clear;
    M.WriteBuffer(Pointer(B)^, Length(B));
    Result := TDataStream.New(M);
  finally
    M.Free;
  end;
end;

constructor TDataDividedStream.Create(Origin: IDataStream;
  FromPos, TotalPos: Integer);
begin
  inherited Create;
  FOrigin := Origin;
  FFromPos := FromPos;
  FTotalPos := TotalPos;
end;

class function TDataDividedStream.New(Origin: IDataStream;
  FromPos, TotalPos: Integer): IDataStream;
begin
  Result := Create(Origin, FromPos, TotalPos);
end;

function TDataDividedStream.Save(Stream: TStream): IDataStream;
begin
  Result := GetStream.Save(Stream);
end;

function TDataDividedStream.Save(const FileName: string): IDataStream;
begin
  Result := GetStream.Save(FileName);
end;

function TDataDividedStream.Save(Strings: TStrings): IDataStream;
begin
  Result := GetStream.Save(Strings);
end;

function TDataDividedStream.AsString: string;
begin
  Result := GetStream.AsString;
end;

function TDataDividedStream.Size: Int64;
begin
  Result := GetStream.Size;
end;

{ TDataPartialFromTextStream }

function TDataPartialFromTextStream.GetStream: IDataStream;
var
  M: TMemoryStream;
  S: AnsiString;
  P: {$ifdef FPC}SizeInt{$else}NativeInt{$endif};
begin
  S := '';
  M := TMemoryStream.Create;
  try
    FOrigin.Save(M);
    SetLength(S, M.Size);
    M.ReadBuffer(S[1], M.Size);
    P := Pos(FFromText, S);
    if P = -1 then
      Exit;
    S := Trim(Copy(S, P, Length(S)));
  finally
    Result := TDataStream.New(S);
    M.Free;
  end;
end;

constructor TDataPartialFromTextStream.Create(Origin: IDataStream;
  const FromText: string);
begin
  inherited Create;
  FOrigin := Origin;
  FFromText := FromText;
end;

class function TDataPartialFromTextStream.New(Origin: IDataStream;
  const FromText: string): IDataStream;
begin
  Result := Create(Origin, FromText);
end;

function TDataPartialFromTextStream.Save(Stream: TStream): IDataStream;
begin
  Result := GetStream.Save(Stream);
end;

function TDataPartialFromTextStream.Save(const FileName: string): IDataStream;
begin
  Result := GetStream.Save(FileName);
end;

function TDataPartialFromTextStream.Save(Strings: TStrings): IDataStream;
begin
  Result := GetStream.Save(Strings);
end;

function TDataPartialFromTextStream.AsString: string;
begin
  Result := GetStream.AsString;
end;

function TDataPartialFromTextStream.Size: Int64;
begin
  Result := GetStream.Size;
end;

end.
