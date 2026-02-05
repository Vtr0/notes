# Turn off screen

As the name, this batch file is used to temporarily turn off all screen without having to wait for the screen timeout.

Download [Turn off Screen.bat](https://raw.githubusercontent.com/Vtr0/notes/refs/heads/main/System/Turn%20off%20Screen.bat) file or paste following `batch` code to a batch file:
```batch
powershell (Add-Type '[DllImport(\"user32.dll\")]^public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);' -Name a -Pas)::SendMessage(-1,0x0112,0xF170,2)
```

# Enable `Photo Viewer`

Before `Windows 10`, Windows has a built-in app for viewing photo named `Photo Viewer`, it is very small utility but yet very elegant and light app for quick viewing local images. Unfortunately, on `Windows 10` and `Windows 11`, this app still there but being hidden for user to use.

Download [enable_photoviewer.reg](https://raw.githubusercontent.com/Vtr0/notes/refs/heads/main/System/enable_photoviewer.reg) and run `as adminitrator` to enable `Photo Viewer` to quick view images.

# Keep app windows location for multiple monitors

There is a bug in `Windows 10, 11` when using multiple monitors that when monitors turned off, all app windows being moved back to main monitor. To fix it, I highly recommnend small utility [PersistentWindows](https://www.majorgeeks.com/files/details/persistentwindows.html) to avoid this frustration.

There also some other utilities might do the similar job such as:

| Tool                        | Auto Restore?        | Save Layouts  | Free/Open‑Source |
|-----------------------------|----------------------|---------------|------------------|
| [**PersistentWindows**](https://www.majorgeeks.com/files/details/persistentwindows.html)        | Yes                  | ✔️             | ✔️               |
| [**WindowResizer**](https://github.com/caoyue/WindowResizer?utm_source=chatgpt.com)            | Manual via hotkeys   | ✔️            | ✔️               |
| [**WindowsLayoutSnapshot**](https://github.com/adamsmith/WindowsLayoutSnapshot?utm_source=chatgpt.com)    | Semi‑automatic       | ✔️            | ✔️               |
| [**RestoreWindowPos**](https://www.softpedia.com/get/Tweak/System-Tweak/RestoreWindowPos.shtml?utm_source=chatgpt.com)         | Yes                  | —             | ✔️               |
| [**DesktopOK**](https://sugggest.com/software/desktopok?utm_source=chatgpt.com)                | Manual restore       | ✔️            | ✔️               |
| **[PowerToys](https://learn.microsoft.com/th-th/windows/powertoys/fancyzones?utm_source=chatgpt.com) (FancyZones)**   | No (layout helper)   | Yes           | ✔️               |
