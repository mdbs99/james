{
  MIT License

  Copyright (c) 2017-2018 Marcos Douglas B. Santos

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
unit JamesAPI;

{$include james.inc}

interface

uses
  JamesData,
  JamesDataClss,
  JamesScalar,
  JamesConstraints,
  JamesConstraintsClss,
  JamesIO,
  JamesIOClss,
  JamesLog,
  JamesLogClss;

type

  { Data }

  IDataStream = JamesData.IDataStream;
  IDataParam = JamesData.IDataParam;
  IDataParams = JamesData.IDataParams;
  IDataGuid = JamesData.IDataGuid;
  IDataHash = JamesData.IDataHash;
  IDataResult = JamesData.IDataResult;

  EDataParams = JamesDataClss.EDataParams;

  TDataStream = JamesDataClss.TDataStream;
  TDataParam = JamesDataClss.TDataParam;
  TDataParams = JamesDataClss.TDataParams;
  TDataGuid = JamesDataClss.TDataGuid;
  TNullGuid = JamesDataClss.TNullGuid;
  TDataResult = JamesDataClss.TDataResult;

  { Constraints }

  IConstraint = JamesConstraints.IConstraint;
  IConstraints = JamesConstraints.IConstraints;

  TConstraints = JamesConstraintsClss.TConstraints;

  { IO }

  IFile = JamesIO.IFile;

  TFile = JamesIOClss.TFile;
  TFileAsStream = JamesIOClss.TFileAsStream;

{ Log }

  ILog = JamesLog.ILog;

  TLogInFile = JamesLogClss.TLogInFile;

implementation

end.

