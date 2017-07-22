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
unit James.Format.XML.Clss;

{$include james.inc}

interface

uses
  Classes, SysUtils,
  James.Data,
  {$ifdef FPC}
    Laz2_DOM, laz2_XMLRead, laz2_XMLWrite
  {$else}
    xmlDoc, xmlIntf
  {$endif}
  ;

type
  {$ifdef FPC}
  TXMLDocument = Laz2_DOM.TXMLDocument;
  TDOMNode = Laz2_DOM.TDOMNode;
  {$endif}

  TXMLComponent = class
  private
    FDocument: TXMLDocument;
  public
    constructor Create(Stream: TStream); overload;
    constructor Create(Stream: IDataStream); overload;
    constructor Create(Strings: TStrings); overload;
    constructor Create(const S: string); overload;
    destructor Destroy; override;
    function Document: TXMLDocument;
    function SaveTo(Stream: TStream): TXMLComponent; overload;
    function SaveTo(Strings: TStrings): TXMLComponent; overload;
    function SaveTo(const FileName: string): TXMLComponent; overload;
    function AsString: string;
  end;

implementation

{ TXMLComponent }

constructor TXMLComponent.Create(Stream: TStream);
begin
  inherited Create;
  Stream.Position := 0;
  {$ifdef FPC}
    ReadXMLFile(FDocument, Stream);
  {$else}
    FDocument.LoadFromStream(Stream);
  {$endif}
end;

constructor TXMLComponent.Create(Stream: IDataStream);
var
  Buf: TMemoryStream;
begin
  Buf := TMemoryStream.Create;
  try
    Stream.Save(Buf);
    Create(Buf);
  finally
    Buf.Free;
  end;
end;

constructor TXMLComponent.Create(Strings: TStrings);
var
  Buf: TMemoryStream;
begin
  Buf := TMemoryStream.Create;
  try
    Strings.SaveToStream(Buf);
    Create(Buf);
  finally
    Buf.Free;
  end;
end;

constructor TXMLComponent.Create(const S: string);
var
  Buf: TStringStream;
begin
  Buf := TStringStream.Create(S);
  try
    Create(Buf);
  finally
    Buf.Free;
  end;
end;

destructor TXMLComponent.Destroy;
begin
  FDocument.Free;
  inherited Destroy;
end;

function TXMLComponent.Document: TXMLDocument;
begin
  Result := FDocument;
end;

function TXMLComponent.SaveTo(Stream: TStream): TXMLComponent;
begin
  Result := Self;
  {$ifdef FPC}
    WriteXMLFile(FDocument, Stream);
  {$else}
    FDocument.SaveToStream(Stream);
  {$endif}
  Stream.Position := 0;
end;

function TXMLComponent.SaveTo(Strings: TStrings): TXMLComponent;
var
  Buf: TMemoryStream;
begin
  Result := Self;
  Buf := TMemoryStream.Create;
  try
    SaveTo(Buf);
    Strings.LoadFromStream(Buf);
  finally
    Buf.Free;
  end;
end;

function TXMLComponent.SaveTo(const FileName: string): TXMLComponent;
var
  Buf: TMemoryStream;
begin
  Result := Self;
  Buf := TMemoryStream.Create;
  try
    SaveTo(Buf);
    Buf.SaveToFile(FileName);
  finally
    Buf.Free;
  end;
end;

function TXMLComponent.AsString: string;
var
  Buf: TStrings;
begin
  Buf := TStringList.Create;
  try
    SaveTo(Buf);
    Result := Buf.Text;
  finally
    Buf.Free;
  end;
end;

end.

