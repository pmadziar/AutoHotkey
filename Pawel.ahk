#Requires AutoHotkey v2.0

;#SETUP START
#SingleInstance force
ListLines 0
SendMode "Input"
SetWorkingDir A_ScriptDir
KeyHistory 0
#WinActivateForce

ProcessSetPriority "H"

SetWinDelay -1
SetControlDelay -1
;include the library
; VHD - virtual desktop manager
; https://github.com/FuPeiJiang/VD.ahk/tree/v2_port#readme
#Include VD.ahk

;#SETUP END

CoordMode "ToolTip", "Screen"

localappdata := EnvGet("LOCALAPPDATA")

^#c:: Run ('"' localappdata "\Programs\Microsoft VS Code\Code.exe" '"')
^#v:: Run ("C:\Program Files\Microsoft Visual Studio\18\Insiders\Common7\IDE\devenv.exe")
; ^#p:: Run ("C:\Program Files\PowerShell\7\pwsh.exe -ExecutionPolicy Bypass -WindowStyle Maximized -WorkingDirectory ~ -NoExit -NoProfile -Command " '"' ". '\\domgen.corp\global\Users\Brighton\madziap\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1'" '"')
^#b:: Run ('"' localappdata "\Google\Chrome\Application\chrome.exe" '"')

;C:\Users\pawel\AppData\Local\Google\Chrome\Application\chrome.exe


goToDesktopNumCreateIfNotExists(num) {
    count := VD.getCount()
    if (count >= num) {
        VD.goToDesktopNum(num)
    } else {
        loopsize := num - count
        loop loopsize {
            VD.createDesktop()
        }
        VD.goToDesktopNum(num)
    }
    displayDesktopInfo()
}

displayDesktopInfo() {
    if (A_ComputerName = "AMSWUATSHP011") {
		displayDesktopInfoAlways()		
    }
}

displayDesktopInfoAlways() {
	count := VD.getCount()
	current := VD.getCurrentDesktopNum()
	msg := "Desktop: " current " / " count
	ToolTip msg, A_ScreenWidth / 2 - 50, A_ScreenHeight - 150
	SetTimer () => ToolTip(), -2300
}


closeDesktopsToTheRight() {
    count := VD.getCount()
    current := VD.getCurrentDesktopNum()
    last := count
    if (count > 1 && current < count) {
        while (last > current) {
            VD.removeDesktop(last)
            last--
        }
    }
}

^#t::
{
    if (A_ComputerName = "AMSWUATSHP011") {
        Run (
            "C:\Program Files\PowerShell\7\pwsh.exe -ExecutionPolicy Bypass -WindowStyle Maximized -WorkingDirectory ~ -NoExit -NoProfile -Command " '"' ". '\\domgen.corp\global\Users\Brighton\madziap\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1'" '"'
        )
    } else {
        termpath := '"' . localappdata . "\Microsoft\WindowsApps\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\wt.exe" .
            '"'
        Run termpath, , "Max"
    }
}

;#useful stuff
^#1:: goToDesktopNumCreateIfNotExists(1)
^#2:: goToDesktopNumCreateIfNotExists(2)
^#3:: goToDesktopNumCreateIfNotExists(3)
^#4:: goToDesktopNumCreateIfNotExists(4)
^#5:: goToDesktopNumCreateIfNotExists(5)
^#6:: goToDesktopNumCreateIfNotExists(6)
^#7:: goToDesktopNumCreateIfNotExists(7)
^#8:: goToDesktopNumCreateIfNotExists(8)
^#9:: goToDesktopNumCreateIfNotExists(9)

; close desktops to the right of the current one
^#0:: closeDesktopsToTheRight()

; display desktop info
^#i:: displayDesktopInfoAlways()


; wrapping / cycle back to first desktop when at the last
^#left:: {
    VD.goToRelativeDesktopNum(-1)
    displayDesktopInfo()
}
^#right:: {
    VD.goToRelativeDesktopNum(+1)
    displayDesktopInfo()
}

+#left:: VD.MoveWindowToRelativeDesktopNum("A", -1).follow()
+#right:: VD.MoveWindowToRelativeDesktopNum("A", 1).follow()