program JamesTests;

{$i James.inc}

uses
  Interfaces,
  Forms,
  GuiTestRunner,
  JamesDataClssTests,
  JamesDataAdaptersTests,
  JamesRTLAdaptersTests,
  JamesMD5ClssTests,
  JamesBase64ClssTests;

{$R *.res}

begin
  Application.Initialize;
  Application.Run;
end.

