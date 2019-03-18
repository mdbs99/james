program TestAll;

{$i James.inc}

uses
  Interfaces,
  Forms,
  GuiTestRunner,
  JamesDataTests,
  JamesRTLTests,
  JamesXMLTests,
  JamesMD5Tests;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

