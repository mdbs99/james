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
unit James.Files.Tests;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry,
  James.Files.Clss;

type
  TFileTest = class(TTestCase)
  published
    procedure Path;
    procedure Name;
    procedure Stream;
  end;

  TFileMergedTest = class(TTestCase)
  published
    //procedure
  end;

implementation

{ TFileTest }

procedure TFileTest.Path;
begin
  AssertEquals('c:\path\', TFile.New('c:\path\filename.txt').Path);
end;

procedure TFileTest.Name;
begin
  AssertEquals('filename.txt', TFile.New('c:\path\filename.txt').Name);
end;

procedure TFileTest.Stream;
const
  TXT = 'ABCC~#';
  FILE_NAME = 'file.txt';
var
  M: TMemoryStream;
begin
  M := TMemoryStream.Create;
  try
    M.WriteBuffer(TXT[1], Length(TXT) * SizeOf(Char));
    M.SaveToFile(FILE_NAME);
    AssertEquals(TXT, TFile.New(FILE_NAME).Stream.AsString);
  finally
    DeleteFile(FILE_NAME);
    M.Free;
  end;
end;

initialization
  RegisterTest('Files', TFileTest);

end.

