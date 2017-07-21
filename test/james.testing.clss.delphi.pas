unit James.Testing.Delphi;

{$include james.inc}

interface

uses
  TestFramework,
  James.Testing;

type
  TTest<T: TTestCase> = class sealed(TInterfacedObject, ITest)
  public
    function RegisterOn(const SuitePath: string): ITest;
    class function New: ITest;
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
  TestFramework.RegisterTest(SuitePath, T.Suite);
end;

end.
