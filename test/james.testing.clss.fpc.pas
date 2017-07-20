unit james.testing.testframework.lazarus;

{$include james.inc}

interface

uses
    fpcunit, testregistry
  , james.testing
  , james.testing.clss
  ;

type
  TTestCase = FPCUnit.TTestCase;
  TTestingSuite = james.testing.clss.TTestingSuite;

  TTesting<T: TTestCase> = class sealed(TInterfacedObject, ITesting)
  public
    class function New: ITesting;
    function RegisterTest(const SuitePath: string): ITesting;
  end;

implementation

{ TTesting }

class function TTesting<T>.New: ITesting;
begin
  Result := Create;
end;

function TTesting<T>.RegisterTest(const SuitePath: string): ITesting;
begin
  TestRegistry.RegisterTest(SuitePath, T);
end;

end.
