!include "MUI2.nsh"

!define PRODUCT_VERSION "0.1"
!define PRODUCT_NAME "ë��"

Name "${PRODUCT_NAME}"
OutFile MaotamaWebInstaller.exe
SetCompressor lzma
RequestExecutionLevel admin
ShowInstDetails show
AutoCloseWindow true
BrandingText "Maotama WebInstaller ${PRODUCT_VERSION}"

!define MUI_PAGE_HEADER_TEXT "��������"
!define MUI_PAGE_HEADER_SUBTEXT "��������ë��װ������Ⱥ�..."
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "SimpChinese"

Var TEMPDIR
Section
  GetTempFileName $TEMPDIR
  Delete $TEMPDIR
  CreateDirectory $TEMPDIR
  
  #NSISdl::download http://www.domain.com/file $0.exe
  Pop $R0
  StrCmp $R0 "success" Success
  StrCmp $R0 "cancel" Cancel
  
Failed:
  HideWindow
  MessageBox MB_OK "Download failed: $R0"
  Goto Exit

Cancel:
  Goto Exit
      
Success:
  Goto Exit
  
Exit:
  RMDir /r $TEMPDIR
SectionEnd

