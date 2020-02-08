{
  MIT License

  Copyright (c) 2017-2020 Marcos Douglas B. Santos

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
unit JamesWebApp;

{$i James.inc}

interface

uses
  SysUtils, fphttpapp,
  {$ifdef WEB_STANDALONE}
    fphttpapp,
  {$endif}
  {$ifdef WEB_CGI}
    fpcgi,
  {$endif}
  {$ifdef WEB_FCGI}
    fpfcgi,
  {$endif}
  HTTPDefs, HTTPRoute;

type
  TWebApplication = THTTPApplication
    {$ifdef WEB_STANDALONE}
      THTTPApplication
    {$endif}
    {$ifdef WEB_FCGI}
      TFCGIApplication
    {$endif}
  ;

var
  WebApplication: TWebApplication = nil;

implementation

{$ifdef WEB_STANDALONE}
procedure TerminateCall(ARequest: TRequest; AResponse: TResponse);
begin
  WebApplication.Terminate;
end;
{$endif}

initialization
  WebApplication := Application;
{$ifdef WEB_STANDALONE}
  WebApplication.Port := 8080;
  HTTPRouter.RegisterRoute('quit', rmAll, @TerminateCall);
{$endif}

end.

