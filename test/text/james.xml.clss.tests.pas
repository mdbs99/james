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
unit James.XML.Clss.Tests;

{$i James.inc}

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
    procedure TestNew;
    procedure TestLoad;
    procedure TestNode;
    procedure TestNodes;
  end;

  TXMLNodeTest = class(TTestCase)
  published
    procedure TestName;
    procedure TestGetValue;
    procedure TestSetValue;
    procedure TestAttrsNotNull;
    procedure TestAdd;
    procedure TestAddTwoLevels;
    procedure TestChildsNotNull;
    procedure TestParent;
    procedure TestDefault;
  end;

  TXMLNodesTest = class(TTestCase)
  published
    procedure TestItemByIndex;
    procedure TestItemByName;
    procedure TestCount;
    procedure TestEmpty;
  end;

  TXMLChildsTest = class(TTestCase)
  published
    procedure TestItemByIndex;
    procedure TestItemByName;
    procedure TestCount;
  end;

  TXMLAttributeTest = class(TTestCase)
  published
    procedure TestName;
    procedure TestGetValue;
    procedure TestSetValue;
    procedure TestNode;
  end;

  TXMLAttributesTest = class(TTestCase)
  published
    procedure TestAdd;
    procedure TestItemByIndex;
    procedure TestItemByName;
    procedure TestCount;
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

procedure TXMLPackTest.TestNew;
var
  N: TXMLString;
begin
  N := 'root';
  CheckEquals(
    N,
    TXMLPack.New(N).Node('/' + N).Name
  );
end;

procedure TXMLPackTest.TestLoad;
begin
  CheckNotNull(
    TXMLPack.New(TXMLFileForTest.New.Stream).Stream
  );
end;

procedure TXMLPackTest.TestNode;
begin
  CheckNotNull(
    TXMLPack.New(TXMLFileForTest.New.Stream).Node(
      '/CONFIG/Package/CompilerOptions'
    )
  );
end;

procedure TXMLPackTest.TestNodes;
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

procedure TXMLNodeTest.TestName;
begin
  CheckEquals(
    TXMLString('CompilerOptions'),
    TXMLPack.New(TXMLFileForTest.New.Stream).Node(
      '/CONFIG/Package/CompilerOptions'
    )
    .Name
  );
end;

procedure TXMLNodeTest.TestGetValue;
begin
  CheckEquals(
    TXMLString('foo'),
    TXMLPack.New(TXMLStreamForTest.New).Node(
      '/root/group/item/name'
    )
    .Text
  );
end;

procedure TXMLNodeTest.TestSetValue;
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

procedure TXMLNodeTest.TestAttrsNotNull;
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

procedure TXMLNodeTest.TestAdd;
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

procedure TXMLNodeTest.TestAddTwoLevels;
var
  P: IXMLPack;
begin
  P := TXMLPack.New('root');
  P.Node('/root')
    .Add('level-1')
    .Add('level-2');
  CheckNotNull(P.Node('/root/level-1/level-2'));
end;

procedure TXMLNodeTest.TestChildsNotNull;
begin
  CheckNotNull(
    TXMLPack.New(TXMLStreamForTest.New).Node(
      '/root/group'
    )
    .Childs
  );
end;

procedure TXMLNodeTest.TestParent;
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

procedure TXMLNodeTest.TestDefault;
begin
  CheckEquals(
    'foo',
    TXMLPack.New(TXMLStreamForTest.New).Node(
      '/root/group/xpto',
      TXMLNodeAsDefault.New('foo', '')
    )
    .Name
  );
end;

{ TXMLNodesTest }

procedure TXMLNodesTest.TestItemByIndex;
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

procedure TXMLNodesTest.TestItemByName;
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

procedure TXMLNodesTest.TestCount;
begin
  CheckEquals(
    2,
    TXMLPack.New(TXMLStreamForTest.New).Nodes(
      '/root/group/item[@a=''1'']'
    )
    .Count
  );
end;

procedure TXMLNodesTest.TestEmpty;
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

procedure TXMLChildsTest.TestItemByIndex;
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

procedure TXMLChildsTest.TestItemByName;
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

procedure TXMLChildsTest.TestCount;
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

procedure TXMLAttributeTest.TestName;
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

procedure TXMLAttributeTest.TestGetValue;
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

procedure TXMLAttributeTest.TestSetValue;
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

procedure TXMLAttributeTest.TestNode;
begin
  CheckEquals(
    TXMLString('Name'),
    TXMLPack.New(TXMLFileForTest.New.Stream).Node(
      '/CONFIG/Package/Name'
    )
    .Attrs
    .Item(0) // goto item
    .Node    // and return to owner TestNode
    .Name
  );
end;

{ TXMLAttributesTest }

procedure TXMLAttributesTest.TestAdd;
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

procedure TXMLAttributesTest.TestItemByIndex;
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

procedure TXMLAttributesTest.TestItemByName;
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

procedure TXMLAttributesTest.TestCount;
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
  TTestSuite.New('Text')
    .Add(TTest.New(TXMLPackTest))
    .Add(TTest.New(TXMLNodeTest))
    .Add(TTest.New(TXMLNodesTest))
    .Add(TTest.New(TXMLChildsTest))
    .Add(TTest.New(TXMLAttributeTest))
    .Add(TTest.New(TXMLAttributesTest))

end.

