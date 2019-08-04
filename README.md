# James

[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/mdbs99/james/blob/master/README.md)
[![Hits-of-Code](https://hitsofcode.com/github/mdbs99/james)](https://hitsofcode.com/view/github.com/mdbs99/james)

James is a collection of object-oriented Pascal primitives.

**ATTENTION:** We're still in a very early alpha version, the API may and will change frequently. Please, use it at your own risk, until we release version 1.0.

# Table of Contents

- [Overview](#overview)
- [Dependencies](#dependencies)
- [Installing](#installing)
  - [On Lazarus](#on-lazarus)
  - [On Delphi](#on-delphi)
- [Testing](#testing)
- [License](#license)

# Overview

This API is being written in [Free Pascal](https://freepascal.org/) and [Lazarus](http://www.lazarus-ide.org/). However, it is also compatible with [Delphi](https://www.embarcadero.com/products/delphi).

The main goal is to replace common procedural code, which has so many conditionals and "controllers", to a declarative and object-oriented code.

We want to write elegant, clean, organized, interface-based, and maintainable code using OOP.

The code follows a restrict rules about naming and style, as prefixes and suffixes, to help programmers to find the correct class or method to do the job quickly.

# Installing

Clone the repository in some directory in your computer.

This library needs:
- [mORMot](https://github.com/synopse/mORMot) — client-server ORM SOA MVC framework for Delphi 6 up to latest Delphi and FPC
  - see [the corresponding documentation](https://github.com/synopse/mORMot/blob/master/Packages/README.md) to install.

## On Lazarus

This library was tested using these versions: 
- FPC 3.1.1 revision 40491
- Lazarus 2.1.0 revision 59757

To install on Lazarus:
- Make sure that you have `mormot_base.lpk` installed
- Open the package in `/pkg/JamesLib.lpk`
- Compile it

The IDE will be aware about *JamesLib* Package to use on any project.

## On Delphi

There is no package for Delphi users yet.

Considering `<james>` as the path where you have saved the sources, you must include these paths in your project:
- Search Path `<james>\src;<james>\src\delphi`

If you are using an old Delphi version as Delphi 7, you might need to download:
- [FastMM4](https://github.com/pleriche/FastMM4) — A memory manager for Delphi and C++ Builder with powerful debugging facilities
  - you should set *FastMM4* in Delphi Library Path

# Testing

Make sure that everything is working in your environment opening the `/test/TestAll` project, compiling and running.

*Lazarus* has all requirements to compile this library.

If you are using an old Delphi version as Delphi 7, you might need to download:
- [DUnit](http://dunit.sourceforge.net/) — An Xtreme testing framework for Delphi programs

You might need to include *DUnit*, *FastMM4* and *mORMot* paths into the search path of `TestAll`.
Besides that, you should include Test sources:
- Search Path `<james>\test\src;<james>\test\src\delphi`

# License

This project is released under MIT license. See [LICENSE](LICENSE).