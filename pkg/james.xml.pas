{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit James.XML;

{$warn 5023 off : no warning about unused units}
interface

uses
  James.XML.Core.Clss, James.XML.Core, James.XML.Core.FPC, James.XML.API, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('James.XML', @Register);
end.
