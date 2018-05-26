program James.Tests;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner,
  James.Data.Tests,
  James.XML.Tests,
  James.Base64.Tests,
  James.MD5.Tests;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

