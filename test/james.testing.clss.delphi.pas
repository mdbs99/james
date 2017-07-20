unit james.testing.clss.delphi;

{$include james.inc}

interface

uses
    TestFramework
  , james.testing
  ;

type
  TTest<T: TTestCase> = class sealed(TInterfacedObject, ITest)
  public
    function RegisterTest(const SuitePath: string): ITest;
    class function New: ITest;
  end;

implementation

{ TTesting }

class function TTest<T>.New: ITest;
begin
  Result := Create;
end;

function TTest<T>.RegisterTest(const SuitePath: string): ITest;
begin
  TestFramework.RegisterTest(SuitePath, T.Suite);
end;

end.
