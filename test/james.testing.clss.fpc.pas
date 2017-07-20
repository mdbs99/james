unit james.testing.clss.fpc;

{$include james.inc}

interface

uses
    fpcunit,
    testregistry,
    james.testing;

type
  TTest<T: TTestCase> = class sealed(TInterfacedObject, ITest)
  public
    class function New: ITest;
    function RegisterTest(const SuitePath: string): ITest;
  end;

implementation

{ TTesting }

class function TTest<T>.New: ITest;
begin
  Result := Create;
end;

function TTest<T>.RegisterTest(const SuitePath: string): ITest;
begin
  TestRegistry.RegisterTest(SuitePath, T);
end;

end.
