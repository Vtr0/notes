# Rescue USB drive

| Tool | Description |
|------|------------|
| [Hiren’s BootCD](https://www.hirensbootcd.org/) | **Bootable diagnostic and repair toolkit** used to troubleshoot and fix computers, especially Windows PCs. [Screenshot](https://www.hirensbootcd.org/screenshots/) |
| [Ventoy](https://www.ventoy.net/en/index.html) | Open-source tool that lets you create a multi-boot USB drive by simply copying ISO (or other bootable image) files onto it — no need to reformat the USB each time. [Screenshot](https://www.ventoy.net/en/screenshot.html) |

See [Multi Boot Pendrive](https://howtofixmypc.com/howtofixmypc-com-multi-boot-pendrive/) for step-by-step guide to create an USB drive that can boot multiple operating systems or tools from a single device.

# Comprehensive Windows Command Prompt (CMD) Master Reference
Sources:
- [70+ Essential Windows CMD Commands](https://www.ninjaone.com/blog/windows-cmd-commands/)
- [20 Essential commands](https://www.windowscentral.com/software-apps/windows-11/20-essential-commands-every-user-should-know-for-command-prompt-on-windows-11)
- [CMD Commands for MSP](https://superops.com/blog/windows-cmd-commands)

This summarizes every command identified in the sources, including tools for file management, networking, system diagnostics, and automation.

## 1. File and Directory Management
Commands used for navigating, organizing, and manipulating the file system.

| Command | Explanation | Example |
| :--- | :--- | :--- |
| **cd** | Short for "change directory," used to move between folders or switch drives. | `cd C:\Users\YourName` |
| **cd ..** | Moves one level "up" in the directory tree to the parent folder. | `cd ..` |
| **cd \** | Takes you to the root directory of the current drive. | `cd \` |
| **dir** | Lists the contents (files and subdirectories) of the current or specified directory. | `dir /P` (pauses after each screenful) |
| **mkdir (md)** | Creates a new directory at a specific location. | `mkdir "My_Projects"` |
| **rmdir (rd)** | Deletes an empty directory. Use `/s /q` to remove a folder and all its content without confirmation. | `rd /s /q "OldFiles"` |
| **type** | Displays the text content of a file directly in the console. | `type readme.txt` |
| **copy** | Copies one or more files from one location to another. | `copy file1.txt C:\Backup` |
| **copy con** | Creates a new file directly from the command line. | `copy con notes.txt` (type content then Ctrl+Z) |
| **del** | Permanently deletes files. Use `/f` to force deletion of read-only files. | `del *.jpg /f` |
| **ren (rename)** | Renames a file or folder. | `ren old.txt new.txt` |
| **move** | Moves a file to a new location or renames it. | `move budget.xlsx D:\Reports\` |
| **attrib** | Displays or changes file attributes (e.g., hidden, read-only, system). | `attrib -h -s -r C:\file.txt` |
| **edit** | Opens a simple text editor (if installed) within the prompt. | `edit config.txt` |

**Advanced commands**
| Command | Explanation | Example |
| :--- | :--- | :--- |
| **xcopy** | Copies files and directories, including trees and hidden/system files. | `xcopy C:\Projects D:\Backup /E /H /C /I` |
| **robocopy** | A robust tool for syncing directories, ideal for backups and large transfers. | `robocopy C:\Data D:\Backup /MIR` |
| **find** | Searches for a specific text string within a file or files. | `find "error" log.txt` |
| **subst** | Maps a local folder to a virtual drive letter. | `subst X: C:\Projects` |
| **cipher** | Encrypts/decrypts files or securely wipes free space (using `/w`) to make data unrecoverable. | `cipher /w:C:\` - wipes free space, making previously deleted files unrecoverable. <br>`cipher /e /s:C:\confidential` - Encrypt folder contents using EFS. <br>`cipher /d /s:C:\confidential` - Decrypt EFS-encrypted folders.|
| **fc** | Compares two files line by line to show differences. | `fc config_old.txt config_new.txt` |
| **replace** | Replaces files in a destination folder with files from a source. | `replace draft.docx D:\Projects\` |
| **tree** | Graphically displays the folder structure of a drive or path. | `tree C:\Projects /F` |
| **compact** | Manages NTFS file system compression for files and directories. | `compact /c /s:C:\folder` (compresses folder) <br>`compact /u /s:C:\folder` - Decompress previously compressed files. <br>`compact /q` - Query compression status without making changes.|
| **pushd** | Saves the current directory and switches to a new one. | `pushd D:\Work` |
| **popd** | Returns to the directory previously stored by the pushd command. | `popd` |
| **cls** | Clears all text from the screen for better readability. | `cls` |

---

## 2. Network Configuration and Troubleshooting
Essential tools for diagnosing connection issues and managing network adapters.

| Command | Explanation | Example |
| :--- | :--- | :--- |
| **ipconfig** | Displays current network configurations; used to release, renew, or flush DNS cache. | `ipconfig /flushdns` (clears DNS cache) |
| **ping** | Tests network connectivity to a host. Use `-t` to monitor connectivity continuously. | `ping google.com -t` |
| **tracert** | Traces the route packets take to a destination. Use `-d` to skip DNS resolution for speed. | `tracert 8.8.8.8` |
| **netstat** | Displays active connections, listening ports, and Ethernet statistics. | `netstat -ano` |
| **nslookup** | Queries DNS to resolve domain names to IP addresses. | `nslookup openai.com` |
| **netsh** | Configures network settings like firewalls, WLAN, and interface IP configurations. | `netsh advfirewall show allprofiles` |
| **arp -a** | Displays current Address Resolution Protocol (ARP) entries. | `arp -a` |
| **hostname** | Instantly displays the computer's network name. | `hostname` |
| **pathping** | Combines ping and tracert to provide detailed latency and route info. | `pathping google.com` |
| **getmac** | Displays the MAC address of the network adapters. Use `/v` for details. | `getmac /v` |
| **nbtstat** | Helps diagnose NetBIOS over TCP/IP connection issues. | `nbtstat -n` |
| **net use** | Connects to, removes, or displays shared network resources. | `net use Z: \\Server\Share` |
| **telnet** | Connects to a remote host using the Telnet protocol (if installed). | `telnet mail.example.com 25` |
| **ftp** | Used to transfer files between computers on a network. | `ftp` |

---

## 3. System Information and Process Management
Commands for monitoring hardware specifications and controlling running apps.

| Command | Explanation | Example |
| :--- | :--- | :--- |
| **systeminfo** | Provides a detailed overview of OS, hardware, and network configuration. | `systeminfo` |
| **winver** | Displays a dialog showing the current Windows version and build number. | `winver` |
| **tasklist** | Lists all running processes with PIDs and memory usage. Use `/V` for verbose details. | `tasklist /svc` (shows hosted services) <br>`tasklist \| findstr [process_name]` - Filter process list to find specific applications.|
| **taskkill** | Forcefully terminates processes by name or PID. | `taskkill /F /IM notepad.exe` |
| **wmic** | Accesses Windows Management Instrumentation info (Deprecated; requires installation on Win 10+). | `wmic product get name` |
| **set** | Displays or sets system environment variables. | `set PATH` |
| **ver** | Displays the current Windows version in text format. | `ver` |
| **whoami** | Shows the current logged-in user. Use `/groups` for group memberships. | `whoami /groups` |
| **query user** | Displays all currently logged-in users and their session status. | `query user` |
| **path** | Displays or sets the search path for executable files. | `path` |
| **title** | Sets the title for the Command Prompt window. | `title Admin Console` |
| **powercfg** | Analyzes power issues or generates battery health reports. | `powercfg /batteryreport` |
| **driverquery** | Displays a list of installed drivers. | `driverquery` |

---

## 4. System Maintenance and Repair
Tools used for fixing errors, corrupted files, and system imaging.

| Command | Explanation | Example |
| :--- | :--- | :--- |
| **chkdsk** | Scans and repairs file system errors and bad sectors. Use `/f /r` for deep repair. | `chkdsk C: /f /r` |
| **sfc /scannow** | Scans and repairs corrupted system files using a local image. | `sfc /scannow` |
| **DISM** | Repairs the Windows system image when SFC fails. | `DISM /Online /Cleanup-Image /RestoreHealth` |
| **cleanmgr** | Launches the Disk Cleanup utility for automated cleaning. | `cleanmgr /sagerun:1` |
| **shutdown** | Controls shutdown, restart, and logoff. Use `/m` for remote machines. | `shutdown /r /t 60` (restart in 60s) |

Shutdown Usage examples:

```cmd
shutdown /s              :: Shut down the computer immediately
shutdown /s /t 60        :: Shut down the computer after 60 seconds
shutdown /r              :: Restart the computer immediately
shutdown /r /t 30        :: Restart the computer after 30 seconds
shutdown /l              :: Log off the current user
shutdown /a              :: Cancel a pending shutdown or restart
```
Common parameters:

- `/s` → Shutdown  
- `/r` → Restart  
- `/l` → Log off  
- `/t <seconds>` → Set delay time  
- `/a` → Abort pending shutdown/restart  

---

## 5. Disk Management
Commands for managing partitions and storage resources.

| Command | Explanation | Example |
| :--- | :--- | :--- |
| **diskpart** | Opens the powerful command-line disk partitioning utility. | `diskpart` |
| **list disk** | Displays all physical disks connected to the machine (within Diskpart). | `list disk` |
| **select disk** | Selects a specific disk to perform management operations. | `select disk 1` |
| **clean** | Removes all partitions and data from the selected disk. | `clean` |
| **format** | Formats a disk or partition with a specified file system. | `format D: /FS:NTFS` |
| **label** | Creates or changes the volume label (name) of a disk. | `label E: BackupDrive` |
| **vol** | Displays the volume label and serial number of a disk. | `vol C:` |

---

## 6. Security, Ownership, and Access Control
Commands to manage permissions, accounts, and elevated privileges.

| Command | Explanation | Example |
| :--- | :--- | :--- |
| **net user** | Manages local user accounts, including passwords and new users. | `net user John SecurePass123` |
| **takeown** | Takes ownership of a file or folder when access is denied. | `takeown /F C:\SecureFolder /R` |
| **icacls** | Displays or modifies Access Control Lists (ACLs) for permissions. | `icacls C:\Folder /grant John:F` |
| **cacls** | A legacy command used to display or change file permissions. | `cacls report.doc /G John:F` |
| **runas** | Runs a specific program as another user (e.g., Administrator). | `runas /user:Admin cmd` |
| **sudo** | Runs elevated commands inline. <br>This is a feature that comes disabled by default on Windows 11. If you want to enable it, you have to open `Settings > System > For developers`, turn on the `Enable sudo` toggle switch and choose the `Inline` option to run elevated commands within the same window as on Linux and macOS. | `sudo del file.txt` |
| **auditpol** | Displays or sets the current audit policy configurations. | `auditpol /get /category:*` |
| **gpresult** | Displays the Resultant Set of Policy (RSoP) for a user/computer. | `gpresult /r` |
| **secedit** | Analyzes and configures system security by comparing settings to templates. | `secedit /analyze /db analysis.sdb` |

---

## 7. Remote Management, Logs, and Automation
Tools for remote execution, scheduling tasks, and scripting.

| Command | Explanation | Example |
| :--- | :--- | :--- |
| **psexec** | Executes commands on remote systems (requires Sysinternals). | `psexec \\ComputerName cmd` |
| **mstsc** | Launches the Remote Desktop Connection utility. Use `/admin` for console. | `mstsc /v:servername` |
| **wevtutil** | Retrieves info about event logs, exports logs, and clears them. | `wevtutil qe System /c:50 /f:text` |
| **eventcreate** | Creates custom entries in the event logs. | `eventcreate /t information /id 1001 /d "Done"` |
| **eventvwr.msc** | Launches the Event Viewer graphical interface. | `eventvwr.msc` |
| **schtasks** | Schedules commands or programs to run periodically. | `schtasks /query /tn "TaskName"` |
| **at** | A legacy command for scheduling tasks (deprecated in newer versions). | `at 14:30 "shutdown /r"` |
| **timeout** | Pauses script execution for a specified number of seconds. | `timeout /t 30` |
| **call** | Runs one batch file from another and then returns control. | `call backup.bat` |
| **start** | Starts a separate window to run a specified program or command. | `start notepad.exe` |
| **pause** | Stops batch file execution and waits for user input. | `pause` |
| **echo** | Displays messages or turns command echoing on/off in scripts. | `echo Backup completed!` |
| **winget** | Windows Package Manager used to install, update, and manage apps. | `winget install "Mozilla Firefox"` |
| **help** | Provides information about other CMD commands. | `help dir` |
| **exit** | Closes the Command Prompt window or ends a batch script. | `exit` |

# Advanced Command Prompt Tricks
## 1. Piping and Redirection

Using the pipe (`|`) and redirection (`>`, `>>`) operators, you can chain commands together or direct their output to files or other programs. For example, you can pipe the output of a `dir` command into `findstr` to search for specific files or redirect the output of a command to create a text file.

### Why it’s useful

- Piping allows you to filter, transform, or pass the output of one command directly into another.  
- Redirection lets you save command results for later review, logging, or automation.  

### Syntax

#### Piping
```cmd
command1 | command2
```

#### Redirect to a file (overwrite)
```cmd
command > filename.txt
```

#### Redirect to a file (append)
```cmd
command >> filename.txt
```

### Examples

#### Search for “report” in a directory listing
```cmd
dir | find "report"
```

#### Save a process list to a file
```cmd
tasklist > processes.txt
```

#### Append error messages to an existing log
```cmd
ping 8.8.8.8 >> networklog.txt
```

### 💡 Tip: Difference between `>` and `>>`

- `>` will overwrite the file if it exists.  
- `>>` will append to the file, preserving its contents.  

---

## 2. Environment Variables

Understanding and using environment variables can help you quickly access system paths and user settings and modify command behaviors. For instance, using `%USERPROFILE%` to access the current user’s home directory simplifies navigation and file management tasks.

### Why it’s useful

- Allows scripts to adapt to different systems and users without hardcoding paths.  
- Speeds up navigation to commonly used locations.  

### Syntax
```cmd
%VARIABLE_NAME%
```

### Common environment variables

- `%USERPROFILE%` — Current user’s home directory  
- `%TEMP%` — Temporary files folder  
- `%PATH%` — Directories where executables are searched  
- `%HOMEDRIVE%` — The drive letter associated with your home directory  

### Examples

#### Go to the user’s Documents folder
```cmd
cd %USERPROFILE%\Documents
```

#### Open the temporary files directory
```cmd
cd %TEMP%
```

### 💡 Tip: Viewing all environment variables

Run the following command:

```cmd
set
```

This displays all currently defined environment variables in your system.

## 3. `winget` (Windows Package Manager)

The `winget` command, in a nutshell, is a tool that streamlines the process of installing, updating, and managing apps.

The Windows Package Manager is a tool with a lot of options, but there are a few that every user should know to perform basic operations.

### Usage

#### Search for an app
```cmd
winget search APP-NAME
```

**Example:**
```cmd
winget search firefox
```
Searches the Microsoft repositories and outputs the information of all the apps that match the query.

---

#### Install an app
```cmd
winget install APP-NAME
```

**Example:**
```cmd
winget install "Mozilla Firefox"
```
Installs the Mozilla Firefox browser on your computer.

---

#### Upgrade an installed app
```cmd
winget upgrade APP-NAME
```

**Example:**
```cmd
winget upgrade "Mozilla Firefox"
```
Updates the Mozilla Firefox browser to the latest version.

---

#### Uninstall an app
```cmd
winget uninstall APP-NAME
```

**Example:**
```cmd
winget uninstall "Mozilla Firefox"
```
Removes the Mozilla Firefox browser from your computer.

# Windows CMD Pipeline Commands

In Windows CMD, pipelines pass **stdout** from one command to another:

```cmd
command1 | command2 | command3
```

---

## 🔎 Filtering & Searching

### find
Search for text in input.

```cmd
dir | find "txt"
```

Options:
- `/i` → case insensitive  
- `/v` → invert match  
- `/c` → count matches  
- `/n` → show line numbers  

---

Exampless:  
List directory contents.

```cmd
dir /b | find ".log"
```

Directory tree.

```cmd
tree | find "src"
```
Counts total lines.
```cmd
dir | find /c /v ""
```
Remove blank lines

```cmd
type file.txt | find /v ""
```

---
### findstr (More powerful than find)
Supports regex-like patterns.

```cmd
dir | findstr "\.txt"
```

Options:
- `/i` → ignore case  
- `/r` → regex (default)  
- `/v` → not matching  
- `/c:"text here"` → exact phrase  
- `/n` → line numbers  

---

### sort
Sort input alphabetically.

```cmd
dir | sort
```

Options:
- `/r` → reverse order  
- `/+n` → sort starting from column n  

---

### 📋 Clipboard
Copies output to clipboard.

```cmd
dir | clip
```

## 📄 Display & Formatting

### more
Paginate output.

```cmd
dir | more
```
---

### type
Display file contents (can pipe it).

```cmd
type file.txt | find "error"
```

---

## 🧮 Redirection Operators (Often Used with Pipes)
Redirection controls **where command input/output goes**.

In CMD, everything is based on **streams**:

- `0` → Standard Input (stdin)
- `1` → Standard Output (stdout)
- `2` → Standard Error (stderr)
- `NUL` → Discard (Windows null device)

---
| Operator | Stream | Meaning | Example | Explanation |
|-----------|--------|----------|----------|-------------|
| `\|` | stdout → next cmd | Pipe output | `dir \| find "txt"` | Send output to another command |
| `>` | 1 | Overwrite stdout to file | `dir > out.txt` | Save output to file (overwrite) |
| `>>` | 1 | Append stdout | `echo hi >> log.txt` | Add output to end of file |
| `2>` | 2 | Overwrite stderr | `dir bad 2> err.txt` | Save errors only |
| `2>>` | 2 | Append stderr | `dir bad 2>> err.txt` | Append errors |
| `2>&1` | 2 → 1 | Merge stderr into stdout. Redirect error stream (`2`) to wherever output stream (`1`) is currently going. | `dir > all.txt 2>&1` | Save output + errors together |
| `<` | 0 | Redirect input | `sort < names.txt` | Read input from file |
| `> NUL` | 1 | Discard stdout | `dir > NUL` | Hide output |
| `2> NUL` | 2 | Discard stderr | `dir bad 2> NUL` | Hide errors |
| `> NUL 2>&1` | 1+2 | Discard everything | `cmd > NUL 2>&1` | Silent execution |

**Example 1 — Filter Errors**

```cmd
dir /s 2>&1 | find "File Not Found"
```

Explanation:
- Merge errors with output
- Pipe everything to `find`
- Show only matching lines

---
**Example 2 — Save Only Errors**

```cmd
dir /s > NUL 2> errors.txt
```

- Ignore normal output
- Save errors only

---

**Example 3 — Count Errors**

```cmd
dir badfolder 2>&1 | find /c "cannot"
```

Counts number of error lines.

---
**Example 4 — Merge stdout & stderr**
```cmd
dir goodfolder badfolder > all.txt 2>&1
```

Explanation:
1. `>` sends normal output to `all.txt`
2. `2>&1` sends errors to the same place

Result:
✔ Both output and errors go into `all.txt`

---
**Order Matters**

These are NOT the same:

```cmd
dir > all.txt 2>&1   ✔ correct
```

vs

```cmd
dir 2>&1 > all.txt   ❌ different behavior
```

Why?

CMD processes left to right. In the second case:
- `2>&1` sends errors to screen (current stdout)
- Then `>` redirects stdout to file
- Errors stay on screen
---

## 🧪 Advanced Examples

### Find large files

```cmd
dir /s | find "File(s)"
```

---

### Search recursively for text in files

```cmd
findstr /s /i "error" *.log
```

---

### List processes and filter

```cmd
tasklist | find "chrome"
```

---

### Network connections filter

```cmd
netstat -ano | find "LISTEN"
```