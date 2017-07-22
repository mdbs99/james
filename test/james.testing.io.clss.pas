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
unit James.Testing.IO.Clss;

{$include james.inc}

interface

uses
  Classes, SysUtils,
  James.Data,
  James.IO,
  James.IO.Clss;

type
  TTestTemplateFile = class sealed(TInterfacedObject, IFile)
  private
    FFile: IFile;
  public
    constructor Create(const FileName: string);
    class function New(const FileName: string): IFile; overload;
    class function New: IFile; overload;
    function Path: string;
    function Name: string;
    function FileName: string;
    function Stream: IDataStream;
  end;

implementation

{ TTestTemplateFile }

constructor TTestTemplateFile.Create(const FileName: string);
begin
  inherited Create;
  FFile := TFile.New(FileName);
end;

class function TTestTemplateFile.New(const FileName: string): IFile;
begin
  Result := Create(FileName);
end;

class function TTestTemplateFile.New: IFile;
begin
  Result := Create('james.tests.template.xml');
end;

function TTestTemplateFile.Path: string;
begin
  Result := FFile.Path;
end;

function TTestTemplateFile.Name: string;
begin
  Result := FFile.Name;
end;

function TTestTemplateFile.FileName: string;
begin
  Result := FFile.FileName;
end;

function TTestTemplateFile.Stream: IDataStream;
begin
  Result := FFile.Stream;
end;

end.

