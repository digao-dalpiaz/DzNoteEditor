# NoteEditor

## Delphi Property Editor for TStrings supporting formatted languages with syntax highlight

![Delphi Supported Versions](https://img.shields.io/badge/Delphi%20Supported%20Versions-XE2..10.3%20Rio-blue.svg)
![Platforms](https://img.shields.io/badge/Platforms-Win32%20and%20Win64-red.svg)

- [What's New](#whats-new)
- [Component Description](#component-description)
- [How to install](#how-to-install)
- [Hidden Shortcuts](#hidden-shortcuts)
- [TNotepad Component](#tnotepad-component)
- [Syntax Supported Formats](#syntax-supported-formats)

## What's New

- 02/07/2019

   - Add Win64 support (library folders changed!) :warning:

## Component Description

This property editor allows you to type texts in Delphi IDE when editing TStrings properties, overwriting the default TStrings editor form.

The NoteEditor supports syntax highlight using SynEdit component (this component depends on SynEdit - you can get here at GitHub too).

![Example Image](images/noteeditor_print.png)

![Example Colors](images/noteeditor_colors.png)

All the configurations and customizations are saved at system Registry: HKEY_CURRENT_USER\Digao\NoteEditor

## How to install

**You need to get the SynEdit before this. Please, download it here: https://github.com/SynEdit/SynEdit. Do not use TurboPack SynEdit, because it has some diferences.**

After SynEdit already installed, do the following:

1. Open **NoteEditor.groupproj** in the Delphi.

2. Ensure **Win32** Platform and **Release** config are selected at both packages.

3. Right-click at root item in the tree and choose **Build All**.

4. If you want to use 64 bit platform, select this platform at NotepadPackage and do a new Build in this package.

5. Right-click at **NoteEditorPackage** and choose **Install**.

6. Add "Win32\Release" sub folder to Delphi Library Path (Tools\Options), on 32-bit option. If you will use 64 bit platform, add "Win64\Release" sub folder on 64-bit option.

Supports Delphi XE2..Delphi 10.3 Rio

## Hidden Shortcuts

`CTRL+S` = Save Button

`CTRL+ENTER` = OK Button

> Others shortcuts are described on each hint of toolbar buttons

## TNotepad Component

In this package there is a bonus non-visual component called TNotepad. This is a simple component having a TStrings published property. So you can store at DFM any text you want. This is very useful to store text data in Forms and DataModules.

And, of course, you can simply double-click the component and will open the NoteEditor!

![Notepad Usage](images/notepad_usage.png)

## Syntax Supported Formats

- 68HC11 Assembler
- ADSP21xx
- AWK
- Baan 4GL
- Borland Forms
- C#
- C/C++
- Cache Object Script
- CA-Clipper
- Cascading Style Sheet
- COAS Product Manager Report
- COBOL
- CORBA IDL
- DOT Graph Drawing Description language
- Eiffel
- Fortran
- Foxpro
- Galaxy
- Gembase
- General
- Go
- GW-TEL
- Haskell
- HP48
- HTML
- INI
- Inno Setup Script
- Java
- JavaScript
- JSON
- KiXtart
- LEGO LDraw
- Modelica
- Modula 3
- MS VBScript
- MS-DOS Batch
- Object Pascal
- Perl
- PHP
- Progress
- Python
- Resource
- Ruby
- Semanta Data Dictionary
- SQL
- Standard ML
- Structured Text
- SynGen Msg
- Tcl/Tk
- TeX
- UNIX Shell Script
- Unreal
- URI
- Visual Basic
- Vrml97
- x86 Assembly

Note: This list is based on last version of SynEdit (date: 01/23/2019). You may have a different list if you install another version. The list is automatically created based on installed syntax highlighters of SynEdit (auto-detected).
