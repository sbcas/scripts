#!/usr/bin/env sh

# portupdate - a script to ease updating ports on FreeBSD

# define locations
CSUP=/usr/bin/csup
CSUPFILE=/etc/cvsup/ports-supfile
#PORTSNAP=/usr/sbin/portsnap
PORTMASTER=/usr/local/sbin/portmaster
SVN=/usr/local/bin/svn
XORG_DIR=$HOME/xorg-dev
XORGMERGE=/usr/local/bin/xorgmerge

echo -n "Do you want to update the ports tree? ([y]/n) "
read YESNO
case "$YESNO" in
        ''|y*|Y*)
                PORTS_UPDATED=true
                echo -e "\n>>> UPDATING PORTS TREE\n"
                $CSUP $CSUPFILE
                ;;
esac

case "$PORTS_UPDATED" in
        true)
                PAGER=${PAGER:-less}
                echo -n "View /usr/ports/UPDATING in $PAGER? ([y]/n) "
                read YESNO
                case "$YESNO" in
                        ''|y*|Y*)
                                $PAGER /usr/ports/UPDATING
                                ;;
                esac
                ;;
esac

case "$PORTS_UPDATED" in
		true)
				echo -n "Sync the latest xorg-dev? ([y]/n) "
				read YESNO
				case "$YESNO" in
						''|y*|Y*)
								$SVN up $XORG_DIR
								$XORGMERGE
								;;
				esac
				;;
esac

# This will delete your old distfiles without warning.
# If disk space is not an issue, change -ad to -aD
if [ -x $PORTMASTER ]; then
        echo -n "Upgrade outdated ports with portmaster? ([y]/n) "
        read YESNO
        case "$YESNO" in
                ''|y*|Y*)
                        echo -e "\n>>> RUNNING PORTMASTER\n"
                        $PORTMASTER -ad
                        ;;
        esac
fi
