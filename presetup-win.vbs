Set objShell = CreateObject("Shell.Application")
Set objWshShell = WScript.CreateObject("WScript.Shell")
Set objWshProcessEnv = objWshShell.Environment("PROCESS")

strPath = objWshShell.ExpandEnvironmentStrings( "%WINDIR%" )
strCommandLine = "/c " & strPath & "\Temp\presetup-win.cmd & pause"
strApplication = "cmd.exe"

objShell.ShellExecute strApplication, strCommandLine, "", "runas"
