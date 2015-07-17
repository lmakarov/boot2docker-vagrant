Set objShell = CreateObject("Shell.Application")
Set objWshShell = WScript.CreateObject("WScript.Shell")
Set objWshProcessEnv = objWshShell.Environment("PROCESS")

strCommandLine = "/c presetup-win.cmd & pause"
strApplication = "cmd.exe"

objShell.ShellExecute strApplication, strCommandLine, "", "runas"