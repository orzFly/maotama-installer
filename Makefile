nsis=makensis.exe
nulfile=nul
nul=>$(nulfile) 2>$(nulfile)
rm=del
rmpost=$(nul)||echo.$(nul)
!if "$(target)" == ""
target=thd
!endif

.SUFFIXES: .nsi
.nsi.exe:
	$(nsis) $<

all: MaotamaBootstrap_$(target).exe
clean:
	$(rm) MaotamaBootstrap_$(target).exe
rebuild: clean all

MaotamaBootstrap.nsh: MaotamaWebInstaller.exe
MaotamaBootstrap_$(target).nsi: MaotamaBootstrap.nsh
