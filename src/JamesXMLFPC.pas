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
unit JamesXMLFPC;

{$include James.inc}

interface

uses
  Classes, SysUtils,
  DOM, XPath, XMLRead, XMLWrite,
  JamesData,
  JamesDataClss,
  JamesXML;

type
  TCAttribute = class(TInterfacedObject, IXMLAttribute)
  private
    FParent: TDOMNode;
    FAttr: TDOMNode;
  public
    constructor Create(AParent, AAttr: TDOMNode);
    class function New(AParent, AAttr: TDOMNode): IXMLAttribute;
    function Name: TXMLString;
    function Text: TXMLString; overload;
    function Text(const AText: TXMLString): IXMLAttribute; overload;
    function Node: IXMLNode;
  end;

  TCAttributes = class(TInterfacedObject, IXMLAttributes)
  private
    FNode: TDOMNode;
  public
    constructor Create(ANode: TDOMNode);
    class function New(ANode: TDOMNode): IXMLAttributes;
    function Add(const AName, AText: TXMLString): IXMLAttribute;
    function Item(AIndex: Integer): IXMLAttribute; overload;
    function Item(const AName: TXMLString): IXMLAttribute; overload;
    function Count: Integer;
  end;

  TCNode = class(TInterfacedObject, IXMLNode)
  private
    FNode: TDOMNode;
  public
    constructor Create(ANode: TDOMNode);
    class function New(ANode: TDOMNode): IXMLNode;
    function Name: TXMLString;
    function Text: TXMLString; overload;
    function Text(const AText: TXMLString): IXMLNode; overload;
    function Text(const AText: string): IXMLNode; overload;
    function Attrs: IXMLAttributes;
    function Add(const AName: TXMLString): IXMLNode;
    function Childs: IXMLNodes;
    function Parent: IXMLNode;
  end;

  TCNodes = class(TInterfacedObject, IXMLNodes)
  private
    FList: IInterfaceList;
  public
    constructor Create(const AList: IInterfaceList);
    class function New(const AList: IInterfaceList): IXMLNodes;
    function Item(AIndex: Integer): IXMLNode; overload;
    function Item(const AName: TXMLString): IXMLNode; overload;
    function Count: Integer;
  end;

  TCChilds = class(TInterfacedObject, IXMLNodes)
  private
    FNode: TDOMNode;
  public
    constructor Create(ANode: TDOMNode);
    class function New(ANode: TDOMNode): IXMLNodes;
    function Item(AIndex: Integer): IXMLNode; overload;
    function Item(const AName: TXMLString): IXMLNode; overload;
    function Count: Integer;
  end;

  TCPack = class(TInterfacedObject, IXMLPack)
  private
    FDocument: TXMLDocument;
  public
    constructor Create(AStream: TStream); reintroduce;
    destructor Destroy; override;
    function Nodes(const AXPath: TXMLString): IXMLNodes;
    function Node(const AXPath: TXMLString): IXMLNode;
    function Stream: IDataStream;
  end;

implementation

{ TCAttribute }

constructor TCAttribute.Create(AParent, AAttr: TDOMNode);
begin
  inherited Create;
  { I need to keep the ParentNode and the Attribute itself.
    I do not know why, but using Attr.ParentNode does not work. }
  FParent := AParent;
  FAttr := AAttr;
end;

class function TCAttribute.New(AParent, AAttr: TDOMNode): IXMLAttribute;
begin
  Result := Create(AParent, AAttr);
end;

function TCAttribute.Name: TXMLString;
begin
  Result := FAttr.NodeName;
end;

function TCAttribute.Text: TXMLString;
begin
  Result := FAttr.NodeValue;
end;

function TCAttribute.Text(const AText: TXMLString): IXMLAttribute;
begin
  Result := Self;
  FAttr.NodeValue := AText;
end;

function TCAttribute.Node: IXMLNode;
begin
  Result := TCNode.New(FParent);
end;

{ TCAttributes }

constructor TCAttributes.Create(ANode: TDOMNode);
begin
  inherited Create;
  FNode := ANode;
end;

class function TCAttributes.New(ANode: TDOMNode): IXMLAttributes;
begin
  Result := Create(ANode);
end;

function TCAttributes.Add(const AName, AText: TXMLString): IXMLAttribute;
begin
  TDOMElement(FNode).SetAttribute(AName, AText);
  Result := Item(AName);
end;

function TCAttributes.Item(AIndex: Integer): IXMLAttribute;
var
  A: TDOMNode;
begin
  A := FNode.Attributes.Item[AIndex];
  if not Assigned(A) then
    raise EXMLError.CreateFmt('Node not found on index %d.', [AIndex]);
  Result := TCAttribute.New(FNode, A);
end;

function TCAttributes.Item(const AName: TXMLString): IXMLAttribute;
var
  A: TDOMNode;
begin
  A := FNode.Attributes.GetNamedItem(AName);
  if not Assigned(A) then
    raise EXMLError.CreateFmt('Node "%s" not found.', [AName]);
  Result := TCAttribute.New(FNode, A);
end;

function TCAttributes.Count: Integer;
begin
  Result := FNode.Attributes.Length;
end;

{ TCNode }

constructor TCNode.Create(ANode: TDOMNode);
begin
  inherited Create;
  FNode := ANode;
end;

class function TCNode.New(ANode: TDOMNode): IXMLNode;
begin
  Result := Create(ANode);
end;

function TCNode.Name: TXMLString;
begin
  Result := FNode.NodeName;
end;

function TCNode.Text: TXMLString;
begin
  Result := FNode.TextContent;
end;

function TCNode.Text(const AText: TXMLString): IXMLNode;
begin
  Result := Self;
  FNode.TextContent := AText;
end;

function TCNode.Text(const AText: string): IXMLNode;
begin
  Result := Self;
  Text(TXMLString(AText));
end;

function TCNode.Attrs: IXMLAttributes;
begin
  Result := TCAttributes.New(FNode);
end;

function TCNode.Add(const AName: TXMLString): IXMLNode;
begin
  Result := TCNode.New(
    FNode.AppendChild(
      FNode.OwnerDocument.CreateElement(TXMLString(AName))
    )
  );
end;

function TCNode.Childs: IXMLNodes;
begin
  Result := TCChilds.New(FNode);
end;

function TCNode.Parent: IXMLNode;
begin
  Result := TCNode.New(FNode.ParentNode);
end;

{ TCNodes }

constructor TCNodes.Create(const AList: IInterfaceList);
begin
  inherited Create;
  FList := AList;
end;

class function TCNodes.New(const AList: IInterfaceList): IXMLNodes;
begin
  Result := Create(AList);
end;

function TCNodes.Item(AIndex: Integer): IXMLNode;
begin
  Result := FList.Items[AIndex] as IXMLNode;
end;

function TCNodes.Item(const AName: TXMLString): IXMLNode;
var
  I: Integer;
  N: IXMLNode;
begin
  for I := 0 to FList.Count -1 do
  begin
    N := Item(I);
    if N.Name = AName then
    begin
      Result := N;
      Exit;
    end;
  end;
  raise EXMLError.CreateFmt('Node "%s" not found.', [AName]);
end;

function TCNodes.Count: Integer;
begin
  Result := FList.Count;
end;

{ TCChilds }

constructor TCChilds.Create(ANode: TDOMNode);
begin
  inherited Create;
  FNode := ANode;
end;

class function TCChilds.New(ANode: TDOMNode): IXMLNodes;
begin
  Result := Create(ANode);
end;

function TCChilds.Item(AIndex: Integer): IXMLNode;
begin
  Result := TCNode.New(FNode.ChildNodes.Item[AIndex]);
end;

function TCChilds.Item(const AName: TXMLString): IXMLNode;
var
  N: TDOMNode;
begin
  N := FNode.FindNode(AName);
  if not Assigned(N) then
    raise EXMLError.CreateFmt('Node "%s" not found.', [AName]);
  Result := TCNode.New(N);
end;

function TCChilds.Count: Integer;
begin
  Result := FNode.ChildNodes.Count;
end;

{ TCPack }

constructor TCPack.Create(AStream: TStream);
begin
  inherited Create;
  AStream.Position := 0;
  ReadXMLFile(FDocument, AStream);
end;

destructor TCPack.Destroy;
begin
  FDocument.Free;
  inherited Destroy;
end;

function TCPack.Nodes(const AXPath: TXMLString): IXMLNodes;
var
  V: TXPathVariable;
  L: IInterfaceList;
  I: Integer;
begin
  L := TInterfaceList.Create;
  V := EvaluateXPathExpression(AXPath, FDocument.DocumentElement);
  try
    if Assigned(V) then
    begin
      for I := 0 to V.AsNodeSet.Count -1 do
        L.Add(TCNode.New(TDOMNode(V.AsNodeSet[I])));
    end;
    Result := TCNodes.New(L);
  finally
    V.Free;
  end;
end;

function TCPack.Node(const AXPath: TXMLString): IXMLNode;
var
  L: IXMLNodes;
begin
  L := Nodes(AXPath);
  if L.Count = 0 then
    raise EXMLError.Create('Node not found.');
  Result := L.Item(0);
end;

function TCPack.Stream: IDataStream;
var
  Stream: TStream;
begin
  Stream := TMemoryStream.Create;
  try
    WriteXMLFile(FDocument, Stream);
    Result := TDataStream.New(Stream);
  finally
    Stream.Free;
  end;
end;

end.

