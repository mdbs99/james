unit james.testing.clss;

{$include james.inc}

interface

uses
    james.testing,
  {$IFDEF FPC}
    fpcunit, james.testing.clss.fpc
  {$ELSE}
    TestFramework, james.testing.clss.delphi
  {$ENDIF}
  ;

type
  {$IFDEF FPC}
    TTestCase = FPCUnit.TTestCase;
  {$ELSE}
    TTestCase = TestFramework.TTestCase;
  {$ENDIF}

  TTestSuite = class sealed(TInterfacedObject, james.testing.ITestSuite)
  private
    FPath: string;
  public
    constructor Create(const Path: string);
    class function New(const Path: string): james.testing.ITestSuite;
    function Add(const Test: james.testing.ITest): james.testing.ITestSuite;
  end;

implementation

{ TTestingSuite }

function TTestSuite.Add(const Test: james.testing.ITest): james.testing.ITestSuite;
begin
  Result := Self;
  Test.RegisterTest(FPath);
end;

constructor TTestSuite.Create(const Path: string);
begin
  FPath := Path;
end;

class function TTestSuite.New(const Path: string): james.testing.ITestSuite;
begin
  Result := Create(Path);
end;


end.
