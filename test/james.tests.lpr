program James.Tests;

{$i James.inc}

uses
  Interfaces, Forms, GuiTestRunner,
  James.Data.Clss.Tests,
  James.Base64.Clss.Tests,
  James.MD5.Clss.Tests,
  James.XML.Clss.Tests,
  James.RTL.Adapters.Tests,
  James.Data.Adapters.Tests;

{$R *.res}

begin
  Application.Title := 'James.Tests';
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

