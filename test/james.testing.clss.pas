unit James.Testing.Clss;

{$include james.inc}

interface

uses
  James.Testing,
  {$IFDEF FPC}
    fpcunit,
    James.Testing.Clss.FPC
  {$ELSE}
    TestFramework,
    James.Testing.Clss.Delphi
  {$ENDIF}
  ;

type
  {$IFDEF FPC}
    TTestCase = FPCUnit.TTestCase;
  {$ELSE}
    TTestCase = TestFramework.TTestCase;
  {$ENDIF}

  TTestSuite = class sealed(TInterfacedObject, ITestSuite)
  private
    FPath: string;
  public
    constructor Create(const Path: string);
    class function New(const Path: string): ITestSuite;
    function Add(const Test: ITest): ITestSuite;
  end;

implementation

{ TTestSuite }

function TTestSuite.Add(const Test: ITest): ITestSuite;
begin
  Result := Self;
  Test.RegisterOn(FPath);
end;

constructor TTestSuite.Create(const Path: string);
begin
  FPath := Path;
end;

class function TTestSuite.New(const Path: string): ITestSuite;
begin
  Result := Create(Path);
end;


end.
