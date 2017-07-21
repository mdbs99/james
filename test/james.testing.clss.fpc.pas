unit James.Testing.Clss.FPC;

{$include james.inc}

interface

uses
  fpcunit,
  testregistry,
  James.Testing;

type
  TTest<T: TTestCase> = class sealed(TInterfacedObject, ITest)
  public
    class function New: ITest;
    function RegisterOn(const SuitePath: string): ITest;
  end;

implementation

{ TTest }

class function TTest<T>.New: ITest;
begin
  Result := Create;
end;

function TTest<T>.RegisterOn(const SuitePath: string): ITest;
begin
  Result := Self;
  TestRegistry.RegisterTest(SuitePath, T);
end;

end.
