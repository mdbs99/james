program James.Tests;

{$i James.inc}

uses
  Interfaces, Forms, james.core.tests, James.Data.Tests, James.Base64.Tests,
  James.MD5.Tests, James.XML.Tests, GuiTestRunner;

{$R *.res}

begin
  Application.Title := 'James.Tests';
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

