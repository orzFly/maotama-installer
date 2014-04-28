!include LogicLib.nsh
!include WinMessages.nsh
!include FileFunc.nsh

!define PRODUCT_NAME "${GAME_NAME}"
!ifdef GAME_ICON
  Icon "${GAME_ICON}"
!else
  Icon "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!endif
Name "${PRODUCT_NAME}"
OutFile MaotamaBootstrap_${GAME_ID}.exe
SetCompressor lzma
RequestExecutionLevel user
SilentInstall silent

!macro ShellExecWait verb app param workdir show exitoutvar
  System::Store S
  System::Call '*(&i60)i.r0'
  System::Call '*$0(i 60,i 0x40,i $hwndparent,t "${verb}",t $\'${app}$\',t $\'${param}$\',t "${workdir}",i ${show})i.r0'
  System::Call 'shell32::ShellExecuteEx(ir0)i.r1 ?e'
  ${If} $1 <> 0
  	System::Call '*$0(is,i,i,i,i,i,i,i,i,i,i,i,i,i,i.r1)' ;stack value not really used, just a fancy pop ;)
  	System::Call 'kernel32::WaitForSingleObject(ir1,i-1)'
  	System::Call 'kernel32::GetExitCodeProcess(ir1,*i.s)'
  	System::Call 'kernel32::CloseHandle(ir1)'
  ${EndIf}
  System::Free $0
  !if "${exitoutvar}" == ""
  	pop $0
  !endif
  System::Store L
  !if "${exitoutvar}" != ""
  	pop ${exitoutvar}
  !endif
!macroend

Var TEMPDIR
Section
  Call CheckMaotama
  Pop $0
  StrCmp $0 1 Installed

  SetOutPath $TEMPDIR
  File MaotamaWebInstaller.exe
  !insertmacro ShellExecWait "" '"$TEMPDIR\MaotamaWebInstaller.exe"' '' '$TEMPDIR' '' ''
  
  Call CheckMaotama
  Pop $0
  StrCmp $0 0 Failed
  
Installed:
  ExecShell open "maotama://install/${GAME_ID}"

Failed:
SectionEnd

Var MaotamaDir
Var MaotamaName
Function CheckMaotama
  ReadRegStr $0 HKCR maotama\shell\open\command ""
  ${GetParent} "$0" $MaotamaDir

  StrCpy $2 $0 1
  StrCmp $2 '"' 0 +2
    StrCpy $MaotamaDir $MaotamaDir "" 1
    
  StrCpy $MaotamaName "$MaotamaDir\maotama.exe"
  
  IfFileExists $MaotamaName 0 +3
    Push 1
    Return
    
  Push 0
FunctionEnd

Function .onInit
  GetTempFileName $TEMPDIR
  Delete $TEMPDIR
  CreateDirectory $TEMPDIR
FunctionEnd

Function .onInstSuccess
  RMDir /r $TEMPDIR
FunctionEnd

Function .onInstFailed
  RMDir /r $TEMPDIR
FunctionEnd

