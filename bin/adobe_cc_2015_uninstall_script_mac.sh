#!/bin/sh

# To undo what the Adobe CC installer does:

rm -Rf /Applications/Adobe*
rm -Rf /Applications/Utilities/Adobe*
rm -Rf /Library/Application\ Support/Adobe*
rm -Rf /Library/Application\ Support/Mozilla/Extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
rm -Rf /Library/Application\ Support/regid.1986-12.com.adobe

rm -Rf /Library/Automator/Save\ as\ Adobe\ PDF.action

rm -Rf /Library/Internet\ Plug-Ins/AdobePDFViewer.plugin
rm -Rf /Library/Internet\ Plug-Ins/AdobePDFViewerNPAPI.plugin

# Remove LaunchAgents that were installed

launchctl remove /Library/LaunchAgents/com.adobe.AAM.Updater-1.0.plist
launchctl remove com.adobe.ARMDCHelper*

# Delete those plists so they don't load again

rm -Rf /Library/LaunchAgents/com.adobe.AAM.Updater-1.0.plist
rm -Rf /Library/LaunchAgents/com.adobe.ARMDCHelper*

# Remove LaunchDaemons that were installed

launchctl remove /Library/LaunchDaemons/com.adobe.adobeupdatedaemon.plist
launchctl remove /Library/LaunchDaemons/com.adobe.adobeupdatedaemon.plist
launchctl remove /Library/LaunchDaemons/com.adobe.ARMDC.Communicator.plist
launchctl remove /Library/LaunchDaemons/com.adobe.ARMDC.SMJobBlessHelper.plist

# Delete those plists so they don't load again on reboot

rm -Rf /Library/LaunchDaemons/com.adobe.adobeupdatedaemon.plist
rm -Rf /Library/LaunchDaemons/com.adobe.adobeupdatedaemon.plist
rm -Rf /Library/LaunchDaemons/com.adobe.ARMDC.Communicator.plist
rm -Rf /Library/LaunchDaemons/com.adobe.ARMDC.SMJobBlessHelper.plist

rm -Rf /Library/Logs/Adobe*
rm -Rf /Library/Logs/CreativeCloud*

rm -Rf /Library/PDF\ Services

rm -Rf /Library/Preferences/com.adobe*
rm -Rf /Library/Preferences/com.Adobe*

rm -Rf /Library/PriviledgedHelperTools/com.adobe*

rm -Rf /Library/ScriptingAdditions/Adobe*

rm -Rf /private/var/root/Library/Application\ Support/Adobe*
rm -Rf /private/var/root/Library/Logs/Adobe*
rm -Rf /private/var/root/Library/Logs/CreativeCloud*
rm -Rf /private/var/root/Library/Preferences/Adobe*

# Remove RUM

rm -Rf /usr/local/bin/RemoteUpdateManager

# Remove crud saved in Users
# Probably need to loop through users here instead of brute force

rm -Rf /Users/admin/Library/Application\ Support/Adobe
rm -Rf /Users/admin/Library/Logs/CreativeCloud
rm -Rf /Users/admin/Library/Logs/PDApp.log

rm -Rf /Users/admin/Library/Preferences/Adobe*
rm -Rf /Users/admin/Library/Preferences/com.adobe*
rm -Rf /Users/admin/Library/Preferences/Macromedia*

# Remove crud from /Users/Shared

rm -Rf /Users/Shared/Adobe*

exit 0
