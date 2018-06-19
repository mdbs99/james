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
unit James.XML.Clss;

{$i James.inc}

interface

uses
  Classes, SysUtils,
  James.Data.Base,
  James.Data.Clss,
  James.XML.Base,
  {$ifdef FPC}
    James.XML.FPC
  {$else}
    James.XML.Delphi
  {$endif}
  ;

type
  TXMLAttribute = TCAttribute;
  TXMLAttributes = TCAttributes;
  TXMLNode = TCNode;
  TXMLNodes = TCNodes;
  TXMLChilds = TCChilds;

  TXMLPack = class(TCPack)
  public
    class function New(const AStream: IDataStream): IXMLPack; overload;
    class function New(const ARootName: TXMLString): IXMLPack; overload;
  end;

  TXMLNodeAsDefault = class(TInterfacedObject, IXMLNode)
  private
    FName: TXMLString;
    FText: TXMLString;
  public
    constructor Create(const Name, Text: TXMLString);
    class function New(const Name, Text: TXMLString): IXMLNode;
    function Name: TXMLString;
    function Text: TXMLString; overload;
    function Text(const AText: TXMLString): IXMLNode; overload;
    function Text(const AText: string): IXMLNode; overload;
    function Attrs: IXMLAttributes;
    function Add(const {%H-}AName: TXMLString): IXMLNode;
    function Childs: IXMLNodes;
    function Parent: IXMLNode;
  end;

implementation

{ TXMLNodeAsDefault }

constructor TXMLNodeAsDefault.Create(const Name, Text: TXMLString);
begin
  inherited Create;
  FName := Name;
  FText := Text;
end;

class function TXMLNodeAsDefault.New(const Name, Text: TXMLString): IXMLNode;
begin
  Result := Create(Name, Text);
end;

function TXMLNodeAsDefault.Name: TXMLString;
begin
  Result := FName;
end;

function TXMLNodeAsDefault.Text: TXMLString;
begin
  Result := FText;
end;

function TXMLNodeAsDefault.Text(const AText: TXMLString): IXMLNode;
begin
  Result := Self;
  FText := AText;
end;

function TXMLNodeAsDefault.Text(const AText: string): IXMLNode;
begin
  Result := Self;
  Text(TXMLString(AText));
end;

{$warnings off}
function TXMLNodeAsDefault.Attrs: IXMLAttributes;
begin
  raise EXMLError.Create('Attributes not allowed.');
end;

function TXMLNodeAsDefault.Add(const AName: TXMLString): IXMLNode;
begin
  raise EXMLError.Create('Add not allowed.');
end;

function TXMLNodeAsDefault.Childs: IXMLNodes;
begin
  raise EXMLError.Create('Childs not allowed.');
end;
{$warnings on}

function TXMLNodeAsDefault.Parent: IXMLNode;
begin
  Result := Self;
end;

{ TXMLPack }

class function TXMLPack.New(const AStream: IDataStream): IXMLPack;
var
  Buf: TMemoryStream;
begin
  Buf := TMemoryStream.Create;
  try
    AStream.Save(Buf);
    Result := Create(Buf);
  finally
    Buf.Free;
  end;
end;

class function TXMLPack.New(const ARootName: TXMLString): IXMLPack;
begin
  Result := New(
    TDataStream.New(
      Format(
        '<?xml version="1.0" encoding="UTF-8"?><%s />', [ARootName]
      )
    )
  );
end;

end.
