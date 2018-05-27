{
  MIT License

  Copyright (c) 2017-2018 Marcos Douglas B. Santos

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
unit James.Logger.Clss;

{$i James.inc}

interface

uses
  Classes, SysUtils,
  James.Logger.Base;

type
  TLogInFile = class sealed(TInterfacedObject, ILog)
  private
    FBuffer: TStrings;
    FFileName: string;
    procedure FlushBuffer;
  public
    constructor Create(const FileName: string);
    class function New(const FileName: string): ILog;
    destructor Destroy; override;
    function Log(const S: string): ILog; overload;
    function Log(E: Exception): ILog; overload;
  end;

implementation

{ TLogInFile }

constructor TLogInFile.Create(const FileName: string);
begin
  inherited Create;
  FBuffer := TStringList.Create;
  FFileName := FileName;
end;

class function TLogInFile.New(const FileName: string): ILog;
begin
  Result := TLogInFile.Create(FileName);
end;

destructor TLogInFile.Destroy;
begin
  FlushBuffer;
  FBuffer.Free;
  inherited Destroy;
end;

procedure TLogInFile.FlushBuffer;
begin
  ForceDirectories(ExtractFilePath(FFileName));
  with TStringList.Create do
  try
    if FileExists(FFileName) then
      LoadFromFile(FFileName);
    Append(FBuffer.Text);
    SaveToFile(FFileName);
  finally
    Free;
  end;
end;

function TLogInFile.Log(const S: string): ILog;
begin
  Result := Self;
  FBuffer.Add(S);
end;

function TLogInFile.Log(E: Exception): ILog;
begin
  Result := Self;
  Log(Format('%s (%s)', [TimeToStr(Now), E.ClassName]));
  Log(E.Message);
  Log('-------------------------------------------------------------');
end;

end.

