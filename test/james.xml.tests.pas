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
unit James.XML.Tests;

{$include James.inc}

interface

uses
  Classes, SysUtils,
  James.Data.Base,
  James.Data.Clss,
  James.Testing.Clss,
  James.XML.Base,
  James.XML.Clss;
  
type
  TXMLFileForTest = class(TDataFile)
  public
    class function New: IDataFile; reintroduce;
  end;

  TXMLStreamForTest = class(TDataStream)
  public
    class function New: IDataStream; reintroduce;
  end;

  TXMLPackTest = class(TTestCase)
  published
    procedure New;
    procedure Load;
    procedure Node;
    procedure Nodes;
  end;

  TXMLNodeTest = class(TTestCase)
  published
    procedure Name;
    procedure GetValue;
    procedure SetValue;
    procedure AttrsNotNull;
    procedure Add;
    procedure AddTwoLevels;
    procedure ChildsNotNull;
    procedure Parent;
  end;

  TXMLNodesTest = class(TTestCase)
  published
    procedure ItemByIndex;
    procedure ItemByName;
    procedure Count;
    procedure Empty;
  end;

  TXMLChildsTest = class(TTestCase)
  published
    procedure ItemByIndex;
    procedure ItemByName;
    procedure Count;
  end;

  TXMLAttributeTest = class(TTestCase)
  published
    procedure Name;
    procedure GetValue;
    procedure SetValue;
    procedure Node;
  end;

  TXMLAttributesTest = class(TTestCase)
  published
    procedure Add;
    procedure ItemByIndex;
    procedure ItemByName;
    procedure Count;
  end;

implementation

{ TXMLFileForTest }

class function TXMLFileForTest.New: IDataFile;
begin
  Result := inherited New('..\pkg\James.Pack.lpk');
end;

{ TXMLStreamForTest }

class function TXMLStreamForTest.New: IDataStream;
begin
  Result := TDataStream.New(
      '<?xml version="1.0" encoding="UTF-8"?>'
    + '<root>'
    + '  <group>'
    + '    <item id="1" a="1" b="2">'
    + '      <name>foo</name>'
    + '      <value>bar</value>'
    + '    </item>'
    + '    <item id="2" a="1" b="2">'
    + '      <name>foo2</name>'
    + '      <value>bar2</value>'
    + '    </item>'
    + '  </group>'
    + '  <footer>'
    + '    <name>foo</name>'
    + '  </footer>'
    + '</root>'
  );
end;

{ TXMLPackTest }

procedure TXMLPackTest.New;
var
  N: TXMLString;
begin
  N := 'root';
  CheckEquals(
    N,
    TXMLPack.New(N).Node('/' + N).Name
  );
end;

procedure TXMLPackTest.Load;
begin
  CheckNotNull(
    TXMLPack.New(TXMLFileForTest.New.Stream).Stream
  );
end;

procedure TXMLPackTest.Node;
begin
  CheckNotNull(
    TXMLPack.New(TXMLFileForTest.New.Stream).Node(
      '/CONFIG/Package/CompilerOptions'
    )
  );
end;

procedure TXMLPackTest.Nodes;
begin
  CheckEquals(
    4,
    TXMLPack.New(TXMLFileForTest.New.Stream).Nodes(
      '/CONFIG/Package/CompilerOptions/*'
    )
    .Count
  );
end;

{ TXMLNodeTest }

procedure TXMLNodeTest.Name;
begin
  CheckEquals(
    TXMLString('CompilerOptions'),
    TXMLPack.New(TXMLFileForTest.New.Stream).Node(
      '/CONFIG/Package/CompilerOptions'
    )
    .Name
  );
end;

procedure TXMLNodeTest.GetValue;
begin
  CheckEquals(
    TXMLString('foo'),
    TXMLPack.New(TXMLStreamForTest.New).Node(
      '/root/group/item/name'
    )
    .Text
  );
end;

procedure TXMLNodeTest.SetValue;
var
  S: TXMLString;
begin
  S := 'xavier';
  CheckEquals(
    S,
    TXMLPack.New(TXMLStreamForTest.New).Node(
      '/root/group/item/name'
    )
    .Text(S)
    .Text
  );
end;

procedure TXMLNodeTest.AttrsNotNull;
begin
  CheckEquals(
    0,
    TXMLPack.New(TXMLStreamForTest.New).Node(
      '/root/footer'
    )
    .Attrs
    .Count
  );
end;

procedure TXMLNodeTest.Add;
var
  N: IXMLNode;
  C: Integer;
begin
  N := TXMLPack.New(TXMLStreamForTest.New).Node('/root/group/item');
  C := N.Childs.Count;
  CheckEquals(
    C + 2,
    N.Add('item').Parent
      .Add('item').Parent
      .Childs
      .Count
  );
end;

procedure TXMLNodeTest.AddTwoLevels;
var
  P: IXMLPack;
begin
  P := TXMLPack.New('root');
  P.Node('/root')
    .Add('level-1')
    .Add('level-2');
  CheckNotNull(P.Node('/root/level-1/level-2'));
end;

procedure TXMLNodeTest.ChildsNotNull;
begin
  CheckNotNull(
    TXMLPack.New(TXMLStreamForTest.New).Node(
      '/root/group'
    )
    .Childs
  );
end;

procedure TXMLNodeTest.Parent;
begin
  CheckEquals(
    TXMLString('Package'),
    TXMLPack.New(TXMLFileForTest.New.Stream).Node(
      '/CONFIG/Package/CompilerOptions'
    )
    .Parent
    .Name
  );
end;

{ TXMLNodesTest }

procedure TXMLNodesTest.ItemByIndex;
begin
  CheckEquals(
    3,
    TXMLPack.New(TXMLStreamForTest.New).Nodes(
      '/root/group/item[@id=''1'']'
    )
    .Item(0)
    .Attrs
    .Count
  );
end;

procedure TXMLNodesTest.ItemByName;
begin
  CheckEquals(
    TXMLString('item'),
    TXMLPack.New(TXMLStreamForTest.New).Nodes(
      '/root/group/item[@id=''1'']'
    )
    .Item('item')
    .Name
  );
end;

procedure TXMLNodesTest.Count;
begin
  CheckEquals(
    2,
    TXMLPack.New(TXMLStreamForTest.New).Nodes(
      '/root/group/item[@a=''1'']'
    )
    .Count
  );
end;

procedure TXMLNodesTest.Empty;
begin
  CheckEquals(
    0,
    TXMLPack.New(TXMLStreamForTest.New).Nodes(
      '/root/group/item[@xpto=''otpx'']'
    )
    .Count
  );
end;

{ TXMLChildsTest }

procedure TXMLChildsTest.ItemByIndex;
begin
  CheckEquals(
    TXMLString('foo2'),
    TXMLPack.New(TXMLStreamForTest.New).Node(
      '/root/group'
    )
    .Childs
      .Item(1)
      .Childs
        .Item(0)
        .Text
  );
end;

procedure TXMLChildsTest.ItemByName;
begin
  CheckEquals(
    TXMLString('item'),
    TXMLPack.New(TXMLStreamForTest.New).Node(
      '/root/group'
    )
    .Childs
    .Item('item')
    .Name
  );
end;

procedure TXMLChildsTest.Count;
begin
  CheckEquals(
    2,
    TXMLPack.New(TXMLStreamForTest.New).Node(
      '/root/group'
    )
    .Childs
    .Count
  );
end;

{ TXMLAttributeTest }

procedure TXMLAttributeTest.Name;
begin
  CheckEquals(
    TXMLString('Value'),
    TXMLPack.New(TXMLFileForTest.New.Stream).Node(
      '/CONFIG/Package/Name'
    )
    .Attrs
    .Item(0)
    .Name
  );
end;

procedure TXMLAttributeTest.GetValue;
begin
  CheckEquals(
    TXMLString('James.Pack'),
    TXMLPack.New(TXMLFileForTest.New.Stream).Node(
      '/CONFIG/Package/Name'
    )
    .Attrs
    .Item(0)
    .Text
  );
end;

procedure TXMLAttributeTest.SetValue;
var
  S: TXMLString;
begin
  S := 'cyclop';
  CheckEquals(
    S,
    TXMLPack.New(TXMLFileForTest.New.Stream).Node(
      '/CONFIG/Package/Name'
    )
    .Attrs
    .Item(0)
    .Text(S)
    .Text
  );
end;

procedure TXMLAttributeTest.Node;
begin
  CheckEquals(
    TXMLString('Name'),
    TXMLPack.New(TXMLFileForTest.New.Stream).Node(
      '/CONFIG/Package/Name'
    )
    .Attrs
    .Item(0) // goto item
    .Node    // and return to owner node
    .Name
  );
end;

{ TXMLAttributesTest }

procedure TXMLAttributesTest.Add;
begin
  CheckEquals(
    TXMLString('1'),
    TXMLPack.New(TXMLStreamForTest.New).Node(
      '/root/group/item'
    )
    .Attrs
    .Add('foo', '1')
    .Text
  );
end;

procedure TXMLAttributesTest.ItemByIndex;
begin
  CheckEquals(
    TXMLString('1'),
    TXMLPack.New(TXMLStreamForTest.New).Node(
      '/root/group/item'
    )
    .Attrs
    .Item(0)
    .Text
  );
end;

procedure TXMLAttributesTest.ItemByName;
begin
  CheckEquals(
    TXMLString('1'),
    TXMLPack.New(TXMLStreamForTest.New).Node(
      '/root/group/item'
    )
    .Attrs
    .Item('id')
    .Text
  );
end;

procedure TXMLAttributesTest.Count;
begin
  CheckEquals(
    3,
    TXMLPack.New(TXMLStreamForTest.New).Node(
      '/root/group/item'
    )
    .Attrs
    .Count
  );
end;

initialization
  TTestSuite.New('XML')
    .Add(TTest.New(TXMLPackTest))
    .Add(TTest.New(TXMLNodeTest))
    .Add(TTest.New(TXMLNodesTest))
    .Add(TTest.New(TXMLChildsTest))
    .Add(TTest.New(TXMLAttributeTest))
    .Add(TTest.New(TXMLAttributesTest))

end.

