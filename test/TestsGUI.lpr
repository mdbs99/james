program TestsGUI;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner,
  TestsBase64Clss, TestsConstraintsClss, TestsDataClss,
  TestsIOClss, TestsMD5Clss, TestsXMLClss;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

