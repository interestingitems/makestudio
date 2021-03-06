        ��  ��                    H   ��
 J V C S M A K P L U G I N S R C _ D P R         0         {$IFDEF BLOCKHEADER}
(*-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: jvcsmakplugintemplate.dpr

The Initial Developer of the original code (JEDI VCS) is:
  Burkhard Schranz (burkhard@additive-net.de)

Componentes and used code which is used in this code are explictly stated to
be copyright of the respective author(s).

Last Modified: see History

Known Issues:
-----------------------------------------------------------------------------

Unit history:

2005/01/08  BSchranz  - Plugin template created
2005/02/15  USchuster - preparations for check in and modified for Wizard
2011/09/25  BSchranz  - preparations for external code wizard

-----------------------------------------------------------------------------*)
{$ENDIF BLOCKHEADER}
library %MODULEIDENT%;

uses
  SysUtils,
  Classes,
  jvcsmak_TLB,
  ComServ,
  Forms,
  {$IFDEF BLOCKEXTERNALWIZARD}
  %USEVARS%,
  %USEMODULE%,
  %USEEDIT%,
  {$IFDEF BLOCKMENUACTION}
  %USEACTIONS%,
  %USEACTIONTEST%,
  {$ENDIF BLOCKMENUACTION}
  {$ENDIF BLOCKEXTERNALWIZARD}
  ActiveX;

{$E jpl}
{$R *.res}

//:Called after all plugins are loaded and registered
//could be used for initialization purpose
procedure AfterAllPluginsLoaded;
begin
end;

//:Indentifies this DLL-Version
procedure JVCSMAKPlugin; stdcall;
begin
end;

//:Get name of Plugin
procedure GetName(AName: PChar); stdcall;
begin
  StrCopy(AName, PChar(struPluginName));
end;

//:Get author of Plugin
procedure GetAuthor(AName: PChar); stdcall;
begin
  StrCopy(AName, PChar(struPluginAuthor));
end;

//:Get description of Plugin
procedure GetDescription(AName: PChar); stdcall;
begin
  StrCopy(AName, PChar(struPluginHint));
end;

//:List of Required plugins separated by ";"
procedure GetRequiredPlugins(AName: PChar); stdcall;
begin
  StrCopy(AName, '');
end;

//:Register an initialize Plugin
function RegisterPlugin(AJVCSMAKApp: IJApplication): Integer; stdcall;
var
 P: Picture;
begin
  Result := 0;
  jvcsmak := AJVCSMAKApp;
  with jvcsmak do
  begin
    try
      {$IFDEF BLOCKMENUACTION}
      //Create form with actions
      FormActions := TFormActions.Create(nil);

      //--- add actions --------------------------------------------------------
      GetPictureFromImageList(FormActions.ImageList1, FormActions.acTestaction1.ImageIndex, P);
      //if the Caption has "\" - the action is assigned to this main menu path!
      //e.g. 'Testmenu\test\'+FormActions.acTestaction1.Caption...
      //if not, the action is assigned to the "extras" menu item
      jvcsmak.AddMenuAction(FormActions.acTestaction1.Name,
                             '%MENUACTIONPATH%' + FormActions.acTestaction1.Caption,
                             FormActions.acTestaction1.Hint,
                             P,
                             IActionCallback(FormActions));
      {$ENDIF BLOCKMENUACTION}

      //--- add modules --------------------------------------------------------
      GetPictureFromImageList(FormActions.ImageList1, 0, P);
      //Name=%COMMANDNAME%; Hint, Category
      //Extension=txt (could be more than one extension - separated by ;)
      //no compatibility - module did not exist before
      //Callback for the Moduletype
      jvcsmak.LogMessage(Application.Exename);
      Plugin%COMMANDIDENTIFIER%Callback := TPlugin%COMMANDIDENTIFIER%Callback.Create(nil);
      jvcsmak.AddCommandType('%COMMANDNAME%', '', stCategory, P, 'txt', -1,
        ICommandCallback(Plugin%COMMANDIDENTIFIER%Callback));

      //Credits
      jvcsmak.AddCreditInfo(struPluginName + ' by ' + struPluginAuthor);

      //Additional Info
      jvcsmak.AddAdditionalInfo(struPluginHint);
    except
    end;
  end;
end;

//:UnRegister an finalize Plugin
function UnregisterPlugin:Integer; stdcall;
begin
  Result := 0;
  try
    FormActions.Free;
    //Remember to Destroy your Callbacks here!
    Plugin%COMMANDIDENTIFIER%Callback.Free;
  except
  end;
end;

//:Version of plugin
function GetMinorVersion: Integer; stdcall;
begin
  Result := 0;
end;

//:Version of plugin
function GetMajorVersion: Integer; stdcall;
begin
  Result := 1;
end;

//:Return the GUID of the Plugins Options-DLG
function GetOptionsPageGUID: TGUID; stdcall;
begin
  //not used yet
  Result := GUID_NULL;
end;

exports
  GetName,
  GetAuthor,
  GetDescription,
  GetRequiredPlugins,
  RegisterPlugin,
  UnregisterPlugin,
  GetMinorVersion,
  GetMajorVersion,
  AfterAllPluginsLoaded,
  GetOptionsPageGUID,
  JVCSMAKPlugin;

begin
end.

  X   ��
 J V C S M A K P L U G I N U N I T S R C _ A C T I O N S         0         {$IFDEF BLOCKHEADER}
(*-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: jvcsplugintemplate_Actions.pas

The Initial Developer of the original code (JEDI VCS) is:
  Burkhard Schranz (burkhard@additive-net.de)

Componentes and used code which is used in this code are explictly stated to
be copyright of the respective author(s).

Last Modified: see History

Known Issues:
-----------------------------------------------------------------------------

Unit history:

2005/01/08  BSchranz  - Plugin template created
2005/02/15  USchuster - preparations for check in and modified for Wizard

-----------------------------------------------------------------------------*)
{$ENDIF BLOCKHEADER}
unit %MODULEIDENT%;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, jvcsmak_TLB, ActiveX, AxCtrls;

type
  TFormActions = class(TForm, IActionCallback)
    ActionList1: TActionList;
    ImageList1: TImageList;
    acTestaction1: TAction;
    procedure acTestaction1Execute(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    procedure Execute(const Action: WideString); safecall;
  end;

var
  FormActions: TFormActions;

procedure GetPictureFromImageList(AImages: TImageList; AIndex: Integer; out APic: Picture);

implementation

{$R *.dfm}

uses
  %FILESPREFIX%Actiontest;

procedure GetPictureFromImageList(AImages: TImageList; AIndex: Integer; out APic: Picture);
var
  pic: TPicture;
begin
  APic := nil;
  pic := TPicture.Create;
  try
    AImages.GetBitmap(AIndex, pic.Bitmap);
    GetOlePicture(pic, APic);
  finally
    pic.Free;
  end;
end;                 

procedure TFormActions.Execute(const Action: WideString);
var
  I: Integer;
begin
  for I := 0 to ActionList1.ActionCount - 1 do
    if CompareText(Action, ActionList1.Actions[I].Name) = 0 then
    begin
      ActionList1.Actions[I].Execute;
    end;
end;

procedure TFormActions.acTestaction1Execute(Sender: TObject);
begin
  with TFormActionTest.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

end.
 C)  X   ��
 J V C S M A K P L U G I N F O R M S R C _ A C T I O N S         0         object FormActions: TFormActions
  Left = 700
  Top = 181
  Width = 246
  Height = 201
  Caption = 'FormActions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ActionList1: TActionList
    Images = ImageList1
    Left = 48
    Top = 24
    object acTestaction1: TAction
      Caption = 'Action aus dem Testplugin'
      ImageIndex = 1
      OnExecute = acTestaction1Execute
    end
  end
  object ImageList1: TImageList
    Left = 88
    Top = 24
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF000268D0000268D000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF000A70D800FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000267CF00056BD2000369
      D100076DD4002A8FF1003A9FF8000268D000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00076DD400197EE400076DD400076DD4000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF000B71D7000E74D9002A8FF1003A9F
      F8003A9FF800258BED000268D000FF00FF00FF00FF00FF00FF0018CEF60019CB
      F700FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00076D
      D4002A94F3002BACF900076DD400FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF000268D0003A9FF8002287E9003A9F
      F8003A9FF800369BF7000268D000FF00FF00FF00FF00FF00FF00FF00FF0018CE
      F60019CBF700FF00FF00FF00FF00076DD400076DD400076DD400076DD4002790
      F0002CA4F900076DD400FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000268D0003A9FF800197E
      E2002086E8003398F6000268D000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF000A70D8000E73DB002790F0004FCBF3004FCBF300238B
      EE00076DD400FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000268D000369B
      F7001177DC001C81E5000268D000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0010635D001176DE002CA4F9001F86E9002E9EF8002BACF9002E9E
      F800076DD400FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00898D8C0055555600FF00FF00FF00FF00FF00FF000268
      D0003398F6000E74D9000268D000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF000B8813001A9A2A0010635D002790F0004FCBF300197EE4001F86E9002D98
      F600076DD400FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF000C85
      1300016D0100898D8C0055555600FF00FF00898D8C00898D8C00FF00FF00FF00
      FF000268D0000268D000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000674
      080012911E004EB47A002EBB520010635D001F86E9002E9EF8001176DE001C82
      E700076DD400FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF0006730900178A
      2300629F6F00016D0100FF00FF00898D8C0055555600FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000A79
      0D0033C25D001FA3340037C2660012911E0011635C00197EE4002D98F6000E73
      DB00076DD400FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF000B740F003E9E
      4C002C9239004E9E5C00016D010055555600FF00FF00898D8C0055555600FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000A79
      0D0033C25D001C9D2E000B881300057F08000279030011635C001176DE00076D
      D400FF00FF00FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF000B740F003E9E
      4C001E8E2B000C85130005820600016D0100898D8C0055555600FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000A79
      0D002AB749001C9D2E0006810B00037B0500027903000279030011635C00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF000B740F003E9E
      4C001E8E2B0007800900027B0300037F0400016D0100FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF001291
      1E000E8B170009851000037B0500037B0500016E0100016C0100FF00FF0018CE
      F60019CBF700FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF00FF00FF00178A23000D86
      16000A830F00037F0400027B0300016F0200016D0100FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF001C9D2E0033C2
      5D000674080001690200016902000169020001690200FF00FF00FF00FF00FF00
      FF0018CEF60019CBF700FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF00FF001E8E2B003E9E4C000571
      0700016D0100016D0100016D0100016D0100FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00137C160033C25D000985
      100001690200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000012871B003E9E4C0009820D00016D
      0100FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00026B0300036F0500027702000169
      0200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000470060002770300016D0100FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF0015952200026B0300FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
 e  \   ��
 J V C S M A K P L U G I N U N I T S R C _ A C T I O N T E S T       0         {$IFDEF BLOCKHEADER}
(*-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: jvcsplugintemplate_Actiontest.pas

The Initial Developer of the original code (JEDI VCS) is:
  Burkhard Schranz (burkhard@additive-net.de)

Componentes and used code which is used in this code are explictly stated to
be copyright of the respective author(s).

Last Modified: see History

Known Issues:
-----------------------------------------------------------------------------

Unit history:

2005/01/08  BSchranz  - Plugin template created
2005/02/15  USchuster - preparations for check in and modified for Wizard

-----------------------------------------------------------------------------*)
{$ENDIF BLOCKHEADER}
unit %MODULEIDENT%;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormActionTest = class(TForm)
    Label1: TLabel;
    Button1: TButton;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormActionTest: TFormActionTest;

implementation

{$R *.dfm}

end.
   H  \   ��
 J V C S M A K P L U G I N F O R M S R C _ A C T I O N T E S T       0         object FormActionTest: TFormActionTest
  Left = 300
  Top = 113
  Width = 360
  Height = 340
  Caption = 'FormActionTest'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 64
    Width = 159
    Height = 37
    Caption = 'Testaction'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 112
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
end
�  P   ��
 J V C S M A K P L U G I N U N I T S R C _ E D I T       0         {$IFDEF BLOCKHEADER}
(*-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: jvcsplugintemplate_Edit.pas

The Initial Developer of the original code (JEDI VCS) is:
  Burkhard Schranz (burkhard@additive-net.de)

Componentes and used code which is used in this code are explictly stated to
be copyright of the respective author(s).

Last Modified: see History

Known Issues:
-----------------------------------------------------------------------------

Unit history:

2005/01/08  BSchranz  - Plugin template created
2005/02/15  USchuster - preparations for check in and modified for Wizard

-----------------------------------------------------------------------------*)
{$ENDIF BLOCKHEADER}
unit %MODULEIDENT%;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormEdit%COMMANDCOMPONENTNAME% = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormEdit%COMMANDCOMPONENTNAME%: TFormEdit%COMMANDCOMPONENTNAME%;

implementation

{$R *.dfm}

end.
   �  P   ��
 J V C S M A K P L U G I N F O R M S R C _ E D I T       0         object FormEdit%COMMANDCOMPONENTNAME%: TFormEdit%COMMANDCOMPONENTNAME%
  Left = 440
  Top = 305
  Width = 346
  Height = 136
  Caption = 'FormEdit%COMMANDCOMPONENTNAME%'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Edit1: TEdit
    Left = 16
    Top = 24
    Width = 305
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 64
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 144
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
   �&  L   ��
 J V C S M A K P L U G I N S R C _ M O D U L E       0         {$IFDEF BLOCKHEADER}
(------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: jvcsplugintemplate_Module.pas

The Initial Developer of the original code (JEDI VCS) is:
  Burkhard Schranz (burkhard@additive-net.de)

Componentes and used code which is used in this code are explictly stated to
be copyright of the respective author(s).

Last Modified: see History

Known Issues:
-----------------------------------------------------------------------------

Unit history:

2005/01/08  BSchranz  - Plugin template created
2005/02/15  USchuster - preparations for check in and modified for Wizard

------------------------------------------------------------------------------)
{$ENDIF BLOCKHEADER}
unit %MODULEIDENT%;

{$I jedi.inc}

{$IFDEF DELPHI6_UP}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF DELPHI6_UP}

interface

uses
  ComObj, ActiveX, StdVCL, Graphics, jvcsmak_TLB,
  Classes, Windows, Dialogs, Controls, SysUtils;

type
  TPlugin%COMMANDIDENTIFIER% = class(TComponent, ICommand2)
  private
    FCaption: string;
    {$IFDEF BLOCKSAMPLEVAR}
    FTestValue: string;
    {$ENDIF BLOCKSAMPLEVAR}
  protected
    //ICommand Interface
    function MeasureItem(Handle: Integer; BriefView: WordBool): Integer; safecall;
    function EditItem: WordBool; safecall;
    function ExecuteItem: WordBool; safecall;
    function DrawItem(Handle: Integer; Left: Integer; Top: Integer; Right: Integer;
      Bottom: Integer; Selected: WordBool; BriefView: WordBool; BkColor: OLE_COLOR): WordBool; safecall;
    procedure SetFilename(const Filename: WideString); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_ParamValues(const ParamName: WideString): WideString; safecall;
    procedure Set_ParamValues(const ParamName: WideString; const Value: WideString); safecall;
    function Get_ParamNames(Index: Integer): WideString; safecall;
    function Get_ParamCount: Integer; safecall;
    property Caption: WideString read Get_Caption write Set_Caption;
    property ParamValues[const ParamName: WideString]: WideString read Get_ParamValues write Set_ParamValues;
    property ParamNames[Index: Integer]: WideString read Get_ParamNames;
    property ParamCount: Integer read Get_ParamCount;

    //ICommand2 Interface
    function Get_OwnerDraw: WordBool; safecall;
    function Get_PreviewText: WideString; safecall;
    function Notify(const Notification: WideString; Parameter: OleVariant): OleVariant; safecall;
    function Get_Properties: IDispatch; safecall;
    property OwnerDraw: WordBool read Get_OwnerDraw;
    property PreviewText: WideString read Get_PreviewText;
    property Properties: IDispatch read Get_Properties;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  //Callback to create an instance of the ICommand
  TPlugin%COMMANDIDENTIFIER%Callback = class(TComponent, ICommandCallback)
    function CreateCommand: IDispatch; safecall;
    procedure SetCanceled(aCanceled: WordBool); safecall;
    function GetIdentifier: WideString; safecall;
  end;

var
  Plugin%COMMANDIDENTIFIER%Callback: TPlugin%COMMANDIDENTIFIER%Callback;

const
  IDPlugin%COMMANDIDENTIFIER% = '%PLUGINIDENTIFIER%.%COMMANDIDENTIFIER%';

{
  Example code to register the command. 
  To be used in the "RegisterPlugin" funktion of the project file.
  
      //--- add then command: %COMMANDNAME%
	  // 1. Get the image from an image list
      GetPictureFromImageList(FormActions.ImageList1, 0, P);
	  
	  // 2. Create the global command callback
      Plugin%COMMANDIDENTIFIER%Callback := TPlugin%COMMANDIDENTIFIER%Callback.Create(nil);

	  // 3. Register the command itsel
      //Name=%COMMANDNAME%; Hint, Category
      //Extension=txt (could be more than one extension - separated by ;)
      //no compatibility - module did not exist before
      jvcsmak.AddCommandType('%COMMANDNAME%', 'Your Hint here!', stCategory, P, 'txt', -1,
        ICommandCallback(Plugin%COMMANDIDENTIFIER%Callback));
  
}  
implementation

uses
  ComServ, %PLUGINIDENTIFIER%Vars, %EDITUNIT%;

function TPlugin%COMMANDIDENTIFIER%Callback.CreateCommand: IDispatch;
begin
  Result := ICommand(TPlugin%COMMANDIDENTIFIER%.Create(nil));
end;

procedure TPlugin%COMMANDIDENTIFIER%Callback.SetCanceled(aCanceled: WordBool);
begin
  Canceled := aCanceled; //set by the server if the user press "Cancel" oder "Stop"
end;

constructor TPlugin%COMMANDIDENTIFIER%.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaption := '%COMMANDNAME%';
  {$IFDEF BLOCKSAMPLEVAR}
  FTestValue := '%SAMPLEVARVALUE%';
  {$ENDIF BLOCKSAMPLEVAR}
end;

function TPlugin%COMMANDIDENTIFIER%.EditItem: WordBool;
begin
  Result := False;
  with TFormEdit%COMMANDCOMPONENTNAME%.Create(nil) do
  try
    {$IFDEF BLOCKSAMPLEVAR}
    Edit1.Text := FTestValue;
    {$ENDIF BLOCKSAMPLEVAR}
    if ShowModal = mrOk then
    begin
      {$IFDEF BLOCKSAMPLEVAR}
      FTestValue := Edit1.Text;
      {$ENDIF BLOCKSAMPLEVAR}
      Result := True;
    end;
  finally
    Free;
  end;
end;

function TPlugin%COMMANDIDENTIFIER%.ExecuteItem: WordBool;
begin
  FCanceled := False;
  {$IFDEF BLOCKSAMPLEVAR}
  jvcsmak.LogMessage(FCaption + ' ' + FTestValue);
  {$ENDIF BLOCKSAMPLEVAR}
  jvcsmak.LogMessage('Executing %COMMANDNAME%...');
  Result := True;
end;

function TPlugin%COMMANDIDENTIFIER%.MeasureItem(Handle: Integer; BriefView: WordBool): Integer;
{$IFDEF BLOCKSAMPLEPAINTCODE}
var
  Canvas: TCanvas;
{$ENDIF BLOCKSAMPLEPAINTCODE}
begin
  {$IFNDEF BLOCKSAMPLEPAINTCODE}
  Result := -1; //auto
  {$ELSE}
  //----------------------------- Example ------------------------
  Canvas := TCanvas.Create;
  try
    Canvas.Handle := Handle;
    Result := 2;
    Canvas.Font.Style := [fsBold];
    Result := Result + Canvas.TextHeight(FCaption) + 2;
    if not BriefView then
    begin
      Canvas.Font.Style := [];
      Result := Result + Canvas.TextHeight(FCaption) + 2;
    end;
  finally
    Canvas.Free;
  end;
  {$ENDIF ~BLOCKSAMPLEPAINTCODE}
end;

function TPlugin%COMMANDIDENTIFIER%.DrawItem(Handle: Integer; Left: Integer; Top: Integer; Right: Integer;
  Bottom: Integer; Selected: WordBool; BriefView: WordBool; BkColor: OLE_COLOR): WordBool;
{$IFDEF BLOCKSAMPLEPAINTCODE}
var
  Offset: Integer;
  Canvas: TCanvas;
  aRect: TRect;
{$ENDIF BLOCKSAMPLEPAINTCODE}  
begin
  {$IFNDEF BLOCKSAMPLEPAINTCODE}
  Result := True; //auto
  {$ELSE}
  //----------------------------- Example ------------------------
  Canvas := TCanvas.Create;
  try
    Canvas.Handle := Handle;
    aRect := Rect(Left, Top, Right, Bottom);
    if Selected then
    begin
      Canvas.Brush.Color := clHighlight;
      Canvas.FillRect(aRect);
    end
    else
    begin
      Canvas.Brush.Color := clWindow;
      Canvas.FillRect(aRect);
    end;
    Offset := 2;
    Canvas.Font.Style := [fsBold];
    {$IFDEF BLOCKSAMPLEVAR}
    Canvas.TextOut(aRect.Left + 2, aRect.Top + Offset, FCaption + ' ' + FTestValue);
    {$ENDIF BLOCKSAMPLEVAR}    
    if not BriefView then
    begin
      Offset := Canvas.TextHeight(FCaption) + 2;
      Canvas.Font.Style := [];
      Canvas.Font.Color := clBlue;
      Canvas.TextOut(aRect.Left + 10, aRect.Top + Offset, 'only for testing');
    end;
  finally
    Canvas.Free;
  end;
  {$ENDIF ~BLOCKSAMPLEPAINTCODE}
end;

procedure TPlugin%COMMANDIDENTIFIER%.SetFilename(const Filename: WideString);
begin
  //Setting the Filename - used by the host at drag&drop
  //enter your code here
end;

function TPlugin%COMMANDIDENTIFIER%.Get_Caption: WideString;
begin
  Result := FCaption;
end;

procedure TPlugin%COMMANDIDENTIFIER%.Set_Caption(const Value: WideString);
begin
  FCaption := Value;
end;

function TPlugin%COMMANDIDENTIFIER%.Get_ParamValues(const ParamName: WideString): WideString;
begin
  Result := '';
  {$IFDEF BLOCKSAMPLEVAR}
  if SameText(ParamName, '%SAMPLEVARNAME%') then
    Result := FTestValue;
  {$ENDIF BLOCKSAMPLEVAR}
end;

procedure TPlugin%COMMANDIDENTIFIER%.Set_ParamValues(const ParamName: WideString; const Value: WideString);
begin
  {$IFDEF BLOCKSAMPLEVAR}
  if SameText(ParamName, '%SAMPLEVARNAME%') then
    FTestValue := Value;
  {$ENDIF BLOCKSAMPLEVAR}
end;

function TPlugin%COMMANDIDENTIFIER%.Get_ParamNames(Index: Integer): WideString;
begin
  {$IFDEF BLOCKSAMPLEVAR}
  Result := '%SAMPLEVARNAME%';
  {$ENDIF BLOCKSAMPLEVAR}
end;

function TPlugin%COMMANDIDENTIFIER%.Get_ParamCount: Integer;
begin
  {$IFDEF BLOCKSAMPLEVAR}
  Result := 1;
  {$ELSE}
  Result := 0;
  {$ENDIF BLOCKSAMPLEVAR}
end;

function TPlugin%COMMANDIDENTIFIER%.Get_OwnerDraw: WordBool;
begin
  Result := false;
end;

function TPlugin%COMMANDIDENTIFIER%.Get_PreviewText: WideString;
begin
  Result := '';
end;

function TPlugin%COMMANDIDENTIFIER%.Notify(const Notification: WideString;
  Parameter: OleVariant): OleVariant;
begin
  Result := varEmpty;
end;

function TPluginSelectDelphiPlatform.Get_Properties: IDispatch;
begin
  Result := nil;
end;


function TPlugin%COMMANDIDENTIFIER%Callback.GetIdentifier: WideString;
begin
  Result := IDPlugin%COMMANDIDENTIFIER%;
end;





end.
  H   ��
 J V C S M A K P L U G I N S R C _ V A R S       0         {$IFDEF BLOCKHEADER}
(*-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: jvcsplugintemplate_Vars.pas

The Initial Developer of the original code (JEDI VCS) is:
  Burkhard Schranz (burkhard@additive-net.de)

Componentes and used code which is used in this code are explictly stated to
be copyright of the respective author(s).

Last Modified: see History

Known Issues:
-----------------------------------------------------------------------------

Unit history:

2005/01/08  BSchranz  - Plugin template created
2005/02/15  USchuster - preparations for check in and modified for Wizard

-----------------------------------------------------------------------------*)
{$ENDIF BLOCKHEADER}
unit %MODULEIDENT%;

interface

uses
  jvcsmak_TLB;

var
  jvcsmak: IJApplication;
  FCanceled: Boolean = False;

resourcestring
  struPluginName = '%PLUGINNAME%';
  struPluginAuthor = '%PLUGINAUTHOR%';
  struPluginHint = '%PLUGINHINT%';
  stCategory = '%PLUGINCATEGORY%';

implementation

end.
 