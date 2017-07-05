{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit james;

{$warn 5023 off : no warning about unused units}
interface

uses
  James.Data.Clss, James.Data, James.Data.Stream.Clss, James.Log.Clss, 
  James.Log, James.Format.Base64.Clss, James.Format.XML.Clss, James.IO.Clss, 
  James.IO, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('james', @Register);
end.
