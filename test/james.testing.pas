unit James.Testing;

{$include james.inc}

interface

type
  ITest = interface
  ['{CF6EE529-CC09-461F-B6FB-526982D37C3B}']
    function RegisterOn(const SuitePath: string): ITest;
  end;

  ITestSuite = interface
  ['{08E6BA19-7082-4BC0-AA14-8E7A92633D5B}']
    function Add(const Test: ITest): ITestSuite;
  end;

implementation

end.
