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

getpib ${1} C mac -n

# ====================================================================
# Manufacturer HFID; 
# --------------------------------------------------------------------

echo -n "Manufacturer HFID: "

getpib ${1} 24 hfid -n

# ====================================================================
# User HFID; 
# --------------------------------------------------------------------

echo -n "User HFID: "

getpib ${1} 74 hfid -n

# ====================================================================
# CCo Selection; 0=Auto, 1=Never, 2=Always, 3=UserAssigned
# --------------------------------------------------------------------

CCO=`getpib ${1} F4 byte`

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
# Mains frequency; 0=Auto, 1=50Hz, 2=60Hz
# --------------------------------------------------------------------

FREQ=`getpib ${1} F6 byte`

echo -n "Mains frequency: "

if [ "$FREQ" = "0" ]; then
	echo "Auto"
elif [ "$FREQ" = "1" ]; then
	echo "50 Hz fixed"
elif [ "$FREQ" = "2" ]; then
	echo "60 Hz fixed"
else
	echo "Unknown"
fi

# ====================================================================
# AVLN Membership; 0=No, 1=Yes
# --------------------------------------------------------------------

echo -n "AVLN Membership: "

getpib ${1} FF byte -n

# ====================================================================
# Communications Media; 0=Powerline, 1=Coax Only
# --------------------------------------------------------------------

MEDIA=`getpib ${1} 109 byte`

echo -n "Communications Media: "

if [ "$MEDIA" = "0" ]; then
	echo "Powerline"
elif [ "$MEDIA" = "1" ]; then
	echo "Coax Only"
else
	echo "Unknown"
fi

# ====================================================================
# Host interface; 256=UART, 1=SPI
# --------------------------------------------------------------------

IFACE=`getpib ${1} 3CA word`

echo -n "Interface: "

if [ "$IFACE" = "256" ]; then
	echo "UART"
elif [ "$IFACE" = "1" ]; then
	echo "SPI"
else
	echo "Unknown"
fi

BAUDRATE=`getpib ${1} 3AA word`
DATABITS=`getpib ${1} 3AD byte`
STOPBITS=`getpib ${1} 3AE byte`
PARITY=`getpib ${1} 3AF byte`

if [ "$IFACE" = "256" ]; then
	echo "Baudrate: $((BAUDRATE * 256))"

	echo "Databits: $DATABITS"

	echo -n "Stopbits: "
	if [ "$STOPBITS" = "0" ]; then
		echo "1"
	elif [ "$STOPBITS" = "1" ]; then
		echo "1,5"
	elif [ "$STOPBITS" = "2" ]; then
		echo "2"
	else
		echo "Unknown"
	fi

	echo -n "Parity: "
	if [ "$PARITY" = "0" ]; then
		echo "None"
	elif [ "$PARITY" = "1" ]; then
		echo "Odd"
	elif [ "$PARITY" = "2" ]; then
		echo "Even"
	else
		echo "Unknown"
	fi
fi

# ====================================================================
# SLAC Enable; 0=disable, 1=PEV, 2=EVSE
# --------------------------------------------------------------------

SLAC=`getpib ${1} 1653 byte`

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

getpib ${1} 1C98 long -n

echo -n "High Speed Link: "

getpib ${1} 1C9C long -n

# ====================================================================
# DBC Enable; 0=Disable, 1=Enable 
# --------------------------------------------------------------------

echo -n "DBC Enable: "

getpib ${1} 1F80 byte -n

# ====================================================================
# Simple QoS; 0=disable, 1=enable
# --------------------------------------------------------------------

echo -n "Simple QoS: "

getpib ${1} 2030 byte -n

# ====================================================================
# Background PIB HAR; 0=disable, 1=enable
# --------------------------------------------------------------------

echo -n "Background PIB HAR: "

getpib ${1} 16D2 byte -n

# ====================================================================
# Fast AVLN Associate; 0=disable, 1=enable
# --------------------------------------------------------------------

echo -n "Fast AVLN Associate: "

getpib ${1} 16D3 byte -n

