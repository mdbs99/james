program JamesTests;

{$i James.inc}

uses
  Interfaces,
  Forms,
  GuiTestRunner,
  JamesDataTests,
  JamesDataAdaptersTests,
  JamesRTLAdaptersTests,
  JamesXMLTests,
  JamesBase64Tests,
  JamesMD5Tests;

{$R *.res}

begin
  Application.Initialize;
  Application.Run;
end.

