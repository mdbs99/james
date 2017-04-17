{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit james;

{$warn 5023 off : no warning about unused units}
interface

uses
  James.Data.Clss, James.Data, James.Data.Stream.Clss, James.Data.XML.Clss, 
  James.Files.Clss, James.Files, James.Log.Clss, James.Log, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('james', @Register);
end.
