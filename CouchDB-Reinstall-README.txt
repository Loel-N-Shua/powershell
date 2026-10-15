CouchDB 1.6.1 reinstall script

Use an elevated Windows PowerShell 5.1 session during kiosk maintenance.
Close the kiosk application and any watchdog/launcher that starts CouchDB.
Place your trusted CouchDB 1.6.1 EXE installer outside its install directory.
The default installer path is C:\setup-couchdb-1.6.1_R16B02.exe
(Windows Explorer may hide the .exe extension).
Keep the existing installation path; this script does not migrate installations.
The default installation/uninstaller directory is:
  C:\Program Files (x86)\Apache Software Foundation\CouchDB
The script discovers unins*.exe there and reinstalls to that same directory.

Preview:

  .\Reinstall-CouchDB161.ps1 -WhatIf

Run:

  .\Reinstall-CouchDB161.ps1

Optional parameters:
  -BackupRoot "D:\CouchDB-Backups"
  -InstallerSha256 "<64-character SHA256 from your approved installer inventory>"
  -HealthUri "http://127.0.0.1:5984/"
  -Credential (Get-Credential)     # Optional authenticated HTTP/version verification

Behavior:
  1. Checks installation, data paths, installer hash when supplied, and service.
  2. Stops the existing service and refuses to continue if CouchDB still runs.
  3. Backs up the entire installation plus external database/index directories.
     Robocopy failure stops the script before uninstall. Allow enough disk space.
  4. Runs the existing Inno Setup uninstaller silently.
  5. Runs the supplied installer silently with /TASKS="service".
  6. Restores etc, var, and external data before starting CouchDB.
  7. Sets startup to Automatic and starts the service.
  8. Uses the discovered service name to create/update DelayedAutoStart as
     REG_DWORD 2 under HKLM\SYSTEM\CurrentControlSet\Services\<service name>,
     then verifies the registry value and type.
  9. Checks HTTP version 1.6.1. If HTTP returns 401 and no credentials were
     supplied, reports completion with a warning that the endpoint requires
     authentication and that HTTP version/database access were not verified.
     This does not change CouchDB authentication. Supplied credentials that
     receive 401 still fail verification, as do other HTTP/connection failures.

Backups and logs default to C:\ProgramData\CouchDB-Reinstall\<unique-run>.
The run directory is restricted to local Administrators and SYSTEM.
Backups include sensitive configuration; retain and dispose of them accordingly.
The service uses the stock installer account, LocalSystem. Existing custom
service accounts are rejected before uninstall. Custom Erlang arguments,
environment-based config chains, relocated configuration, or differently named
services require adapting this script first. Do not run it against other
Erlang applications sharing the CouchDB installation or runtime.

Data paths are read from [couchdb] database_dir and view_index_dir in default.ini,
default.d/*.ini, local.ini, and local.d/*.ini. Relative data paths are resolved
against the installation's bin directory, matching the stock 1.6.1 service's
working directory, independently of Pulseway's working directory. For example,
../var/lib/couchdb resolves to <installation directory>\var\lib\couchdb.
Paths must contain ordinary directories; junctions and symbolic links are rejected. The supplied
health URL must match the restored HTTP configuration. For HTTPS, use a trusted
certificate; the script does not bypass certificate validation.

Failure recovery:
  The script throws on failure; it does not automatically roll back or restart
  after a failed backup. Inspect reinstall.log, copy.log, install.log, and
  uninstall.log in the printed backup directory. Do not delete the backup.
  If setup requires a reboot, perform it during maintenance and inspect state
  before rerunning. The installation backup includes binaries for reference,
  but recovery should use the approved installer followed by data/config restore
  while CouchDB is stopped. A later rerun creates a separate backup.

Validation:
  PowerShell syntax was checked. Installation was not run on a kiosk or against
  the actual installer package. Pilot on one kiosk with a recoverable backup
  before deploying across the fleet. Afterward, check kiosk operation and
  replication, then reboot the pilot kiosk to verify automatic service startup.

Version-specific reference (Apache CouchDB tag 1.6.1):
  https://github.com/apache/couchdb/blob/1.6.1/etc/windows/couchdb.iss.tpl
  This declares the service and service\start tasks and uses erlsrv.exe.
