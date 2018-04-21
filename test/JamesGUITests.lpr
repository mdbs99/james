program JamesGUITests;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner,
  JamesBase64Tests, JamesConstraintsTests, JamesDataTests,
  JamesMD5Tests, JamesXMLTests;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

