#!/bin/sh
# file: slac/pib-dump.sh

#
#   dump all SLAC relevant settings of a QCA7000 PIB file
#

if [ $# -ne 1 ]; then
	cat << EOF
usage: pib-dump.sh PIBFILE

This script dump all SLAC relevant settings of a QCA7000 PIB file

EOF
	exit 1
fi

# ====================================================================
# MAC address;
# --------------------------------------------------------------------

echo -n "MAC address: "

../pib/getpib ${1} C mac -n

# ====================================================================
# Manufacturer HFID; 
# --------------------------------------------------------------------

echo -n "Manufacturer HFID: "

../pib/getpib ${1} 24 hfid -n

# ====================================================================
# User HFID; 
# --------------------------------------------------------------------

echo -n "User HFID: "

../pib/getpib ${1} 74 hfid -n

# ====================================================================
# CCo Selection; 0=Auto, 1=Never, 2=Always, 3=UserAssigned
# --------------------------------------------------------------------

CCO=`../pib/getpib ${1} F4 byte`

echo -n "CCo Selection: "

if [ "$CCO" = "0" ]; then
	echo "Auto"
elif [ "$CCO" = "1" ]; then
	echo "Never"
elif [ "$CCO" = "2" ]; then
	echo "Always"
elif [ "$CCO" = "3" ]; then
	echo "UserAssigned"
else
	echo "Unknown"
fi

# ====================================================================
# AVLN Membership; 0=No, 1=Yes
# --------------------------------------------------------------------

echo -n "AVLN Membership: "

../pib/getpib ${1} FF byte -n

# ====================================================================
# Communications Media; 0=Powerline, 1=Coax Only
# --------------------------------------------------------------------

MEDIA=`../pib/getpib ${1} 109 byte`

echo -n "Communications Media: "

if [ "$MEDIA" = "0" ]; then
	echo "Powerline"
elif [ "$MEDIA" = "1" ]; then
	echo "Coax Only"
else
	echo "Unknown"
fi

# ====================================================================
# SLAC Enable; 0=disable, 1=PEV, 2=EVSE
# --------------------------------------------------------------------

SLAC=`../pib/getpib ${1} 1653 byte`

echo -n "SLAC mode: "

if [ "$SLAC" = "0" ]; then
	echo "Disable"
elif [ "$SLAC" = "1" ]; then
	echo "PEV"
elif [ "$SLAC" = "2" ]; then
	echo "EVSE"
else
	echo "Unknown"
fi

# ====================================================================
# Low Speed Link, High Speed Link
# --------------------------------------------------------------------

echo -n "Low Speed Link: "

../pib/getpib ${1} 1C98 long -n

echo -n "High Speed Link: "

../pib/getpib ${1} 1C9C long -n

# ====================================================================
# DBC Enable; 0=Disable, 1=Enable 
# --------------------------------------------------------------------

echo -n "DBC Enable: "

../pib/getpib ${1} 1F80 byte -n

# ====================================================================
# Simple QoS; 0=disable, 1=enable
# --------------------------------------------------------------------

echo -n "Simple QoS: "

../pib/getpib ${1} 2030 byte -n

# ====================================================================
# Background PIB HAR; 0=disable, 1=enable
# --------------------------------------------------------------------

echo -n "Background PIB HAR: "

../pib/getpib ${1} 16D2 byte -n

# ====================================================================
# Fast AVLN Associate; 0=disable, 1=enable
# --------------------------------------------------------------------

echo -n "Fast AVLN Associate: "

../pib/getpib ${1} 16D3 byte -n

