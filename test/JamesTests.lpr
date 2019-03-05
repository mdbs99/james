program JamesTests;

{$i James.inc}

uses
  Interfaces, Forms, GuiTestRunner;

{$R *.res}

begin
  Application.Title := 'James.Tests';
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

