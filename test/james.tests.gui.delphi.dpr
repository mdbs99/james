program james.tests.gui.delphi;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  james.crypto.md5.tests in 'james.crypto.md5.tests.pas',
  james.crypto.md5.clss in '..\src\james.crypto.md5.clss.pas',
  james.data in '..\src\james.data.pas',
  james.data.clss in '..\src\james.data.clss.pas',
  james.crypto.md5.delphi in '..\src\james.crypto.md5.delphi.pas',
  james.data.constraints.tests in 'james.data.constraints.tests.pas',
  james.data.constraints.clss in '..\src\james.data.constraints.clss.pas',
  james.data.constraints in '..\src\james.data.constraints.pas',
  james.data.stream.tests in 'james.data.stream.tests.pas',
  james.data.stream.clss in '..\src\james.data.stream.clss.pas',
  james.format.xml.clss in '..\src\james.format.xml.clss.pas',
  james.io.clss in '..\src\james.io.clss.pas',
  james.io in '..\src\james.io.pas',
  james.tests.clss in 'james.tests.clss.pas',
  james.data.tests in 'james.data.tests.pas',
  james.format.base64.tests in 'james.format.base64.tests.pas',
  james.format.base64.clss in '..\src\james.format.base64.clss.pas',
  james.format.xml.tests in 'james.format.xml.tests.pas',
  james.functions.tests in 'james.functions.tests.pas',
  james.functions.clss in '..\src\james.functions.clss.pas',
  james.functions in '..\src\james.functions.pas',
  james.io.tests in 'james.io.tests.pas';

{$R *.RES}

begin
  ReportMemoryLeaksOnShutdown := True;
  DUnitTestRunner.RunRegisteredTests;
end.

