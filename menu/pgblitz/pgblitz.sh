#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################
source /opt/plexguide/menu/functions/functions.sh

defaultvars () {
  touch /var/plexguide/rclone.gdrive
  touch /var/plexguide/rclone.gcrypt
}

badmenu () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Welcome to PG Blitz                  📓 Reference: pgblitz.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂 Basic Information

Utilizes Team Drives and the deployment is semi-complicated. If uploading
less than 750GB per day, utilize PG Move! Good luck!

NOTE: GDrive Must Be Configured (to allow backups of your apps)

1 - Configure RClone
Z - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

goodmenu () {
  if [[ "$gdstatus" == "good" && "$gcstatus" == "bad" ]]; then message="3 - Deploy PG Blitz: TDrive" && message2="Z - Exit" dstatus="1";
  elif [[ "$gdstatus" == "good" && "$gcstatus" == "good" ]]; then message="4 - Deploy PG Blitz: TDrive /w Encryption" && message2="Z - Exit" && dstatus="2";
  else message="Z - Exit" message2="" && dstatus="0"; fi

  # Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Welcome to PG Blitz                  📓 Reference: pgblitz.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂 Basic Information

Utilizes Team Drives and the deployment is semi-complicated. If uploading
less than 750GB per day, utilize PG Move! Good luck!

1 - Configure RClone
2 - Key Management [$keys Keys Exist]
3 - EMail Share Generator
$message
$message2

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

bwpassed () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASSED: Bandwidth Limit Set!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
bwrecall && question1
}

question1 () {
bwrecall
readrcloneconfig

if [ "$gdstatus" == "bad" ]; then badmenu; else goodmenu; fi

# Standby
read -p '🌍 Type Number | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then echo && readrcloneconfig && rcloneconfig && question1;
elif [ "$typed" == "2" ]; then bandwidth && question1;
elif [ "$typed" == "3" ]; then removemounts;
    if [ "$dstatus" == "1" ]; then
    echo "gdrive" > /var/plexguide/rclone/deploy.version
    ansible-playbook /opt/plexguide/menu/pgmove/gdrive.yml
    ansible-playbook /opt/plexguide/menu/pgmove/unionfs.yml
    ansible-playbook /opt/plexguide/menu/pgmove/move.yml
    question1
  elif [ "$dstatus" == "2" ]; then
    echo "gcrypt" > /var/plexguide/rclone/deploy.version
    ansible-playbook /opt/plexguide/menu/pgmove/gdrive.yml
    ansible-playbook /opt/plexguide/menu/pgmove/gcrypt.yml
    ansible-playbook /opt/plexguide/menu/pgmove/unionfs.yml
    ansible-playbook /opt/plexguide/menu/pgmove/move.yml
    question1
  else question1; fi
elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then exit;
else
  badinput
  question1
fi
}

question1
