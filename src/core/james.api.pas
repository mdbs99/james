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
  James.Log,
  James.Log.Clss;

type

  { Data }

  IDataStream = James.Data.IDataStream;
  IDataParam = James.Data.IDataParam;
  IDataParams = James.Data.IDataParams;
  IDataGuid = James.Data.IDataGuid;
  IDataHash = James.Data.IDataHash;
  IDataInformation = James.Data.IDataInformation;
  IDataInformations = James.Data.IDataInformations;
  IDataResult = James.Data.IDataResult;

  EDataParams = James.Data.Clss.EDataParams;

  TDataStream = James.Data.Clss.TDataStream;
  TDataParam = James.Data.Clss.TDataParam;
  TDataParams = James.Data.Clss.TDataParams;
  TDataGuid = James.Data.Clss.TDataGuid;
  TNullGuid = James.Data.Clss.TNullGuid;
  TDataInformation = James.Data.Clss.TDataInformation;
  TDataInformations = James.Data.Clss.TDataInformations;
  TDataResult = James.Data.Clss.TDataResult;
  TDataConstraints = James.Constraints.Clss.TDataConstraints;

  { Constraints }

  IDataConstraint = James.Constraints.IDataConstraint;
  IDataConstraints = James.Constraints.IDataConstraints;

  { IO }

  IFile = James.IO.IFile;

  TFile = James.IO.Clss.TFile;
  TFileAsStream = James.IO.Clss.TFileAsStream;

{ Log }

  ILog = James.Log.ILog;

  TLogInFile = James.Log.Clss.TLogInFile;

implementation

end.

