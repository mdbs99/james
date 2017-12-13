{
  MIT License

  Copyright (c) 2017 Marcos Douglas B. Santos

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
}
unit James.API;

{$include james.inc}

interface

uses
  James.Data,
  James.Data.Clss,
  James.Constraints,
  James.Constraints.Clss,
  James.IO,
  James.IO.Clss,
  James.Format.Base64.Clss,
  James.Crypto.MD5.Clss,
  James.Log,
  James.Log.Clss;

type

  { Data }

  IDataStream = IDataStreamAlias;
  IDataParam  = IDataParamAlias;
  IDataParams = IDataParamsAlias;
  IDataGuid   = IDataGuidAlias;
  IDataHash   = IDataHashAlias;

  EDataParams = EDataParamsAlias;

  TDataStream = TDataStreamAlias;
  TDataParam  = TDataParamAlias;
  TDataParams = TDataParamsAlias;
  TDataGuid   = TDataGuidAlias;
  TNullGuid   = TNullGuidAlias;

  { Constraints }

  IDataInformation  = IDataInformationAlias;
  IDataInformations = IDataInformationsAlias;
  IDataResult       = IDataResultAlias;
  IDataConstraint   = IDataConstraintAlias;
  IDataConstraints  = IDataConstraintsAlias;

  TDataInformation  = TDataInformationAlias;
  TDataInformations = TDataInformationsAlias;
  TDataResult       = TDataResultAlias;
  TDataConstraints  = TDataConstraintsAlias;

  { IO }

  IFile = IFileAlias;

  TFile = TFileAlias;
  TFileAsStream = TFileAsStreamAlias;

 { Format Base64 }

  TBase64Hash = TBase64HashAlias;
  TBase64Stream = TBase64StreamAlias;

{ Crypto MD5 }

  TMD5Hash = TMD5HashAlias;
  TMD5Stream = TMD5StreamAlias;

{ Log }

  ILog = ILogAlias;

  TLogInFile = TLogInFileAlias;

implementation

end.

