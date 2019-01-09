#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo -e "
    ROOT PRIVILEDGES NEEDED!
    You have to run this script as root.
    Aborting...
    "
    exit 1
else
    echo -e "
    ###################################
      Office 2011 for Mac uninstaller
    ###################################
           Unofficial unistaller
        Brought to you by Frank Pira
                (fpira.com)
    This software comes with absolutely
                NO WARRANTY
          Use it at your own risk.
    "

    sleep 4

    echo -e "
    ------------- WARNING -------------
      Your Outlook data will be wiped.
     Press CTRL+C in 5 seconds to ABORT
        or just sit back and relax!
    -----------------------------------
    "

    sleep 6

    echo "    Removing Office 2011 apps..."
    rm -rf "/Applications/Microsoft Messenger.app"
    rm -rf "/Applications/Microsoft Office 2011"
    rm -rf "/Applications/Remote Desktop Connection.app"

    echo "    Cleaning ~/Library..."
    rm -rf $(whoami)/Library/Preferences/com.microsoft.Excel.plist
    rm -rf $(whoami)/Library/Preferences/com.microsoft.office.plist
    rm -rf $(whoami)/Library/Preferences/com.microsoft.office.setupassistant.plist
    rm -rf $(whoami)/Library/Preferences/com.microsoft.outlook.databasedaemon.plist
    rm -rf $(whoami)/Library/Preferences/com.microsoft.outlook.office_reminders.plist
    rm -rf $(whoami)/Library/Preferences/com.microsoft.Outlook.plist
    rm -rf $(whoami)/Library/Preferences/com.microsoft.PowerPoint.plist
    rm -rf $(whoami)/Library/Preferences/com.microsoft.Word.plist
    rm -rf $(whoami)/Library/Preferences/com.microsoft.autoupdate2.plist
    rm -rf $(whoami)/Library/Preferences/ByHost/com.microsoft*
    rm -rf "$(whoami)/Library/Application Support/Microsoft/Office"

    echo "    Cleaning system folders..."
    rm /Library/LaunchDaemons/com.microsoft.office.licensing.helper.plist
    rm /Library/Preferences/com.microsoft.office.licensing.plist
    rm /Library/PrivilegedHelperTools/com.microsoft.office.licensing.helper

    rm -rf /Library/Application Support/Microsoft
    rm -rf /Library/Fonts/Microsoft
    rm -rf /Library/Receipts/Office2011_*

    echo "    Making your Mac forget about Office 2011 and its updates..."
    pkgutil --pkgs=.\+microsoft\.office.\+ | while read -r package ; do
        pkgutil --forget $package
    done
    pkgutil --pkgs=.\+microsoft\.rdc.\+ | while read -r package ; do
        pkgutil --forget $package
    done
    pkgutil --pkgs=.\+microsoft\.mau.\+ | while read -r package ; do
        pkgutil --forget $package
    done
    pkgutil --pkgs=.\+microsoft\.merp.\+ | while read -r package ; do
        pkgutil --forget $package
    done
    pkgutil --pkgs=.\+microsoft\.msgr.\+ | while read -r package ; do
        pkgutil --forget $package
    done
    pkgutil --forget com.microsoft.package.Frameworks
    pkgutil --forget com.microsoft.pkg.licensing

    echo -e "
    All done!
    You may need to reinstall Microsoft Silverlight.
    You can now remove icons from Dock (if any!).
    "
fi
