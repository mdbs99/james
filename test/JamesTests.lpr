program JamesTests;

{$i James.inc}

uses
  Interfaces, Forms, GuiTestRunner;

{$R *.res}

begin
  Application.Title := 'JamesTests';
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

