#!/bin/bash

MINUTES=0
SECONDS=0

WORK_TIME=25
BREAK_TIME=5
PAUSE_TIME=15

WORK=1
BREAK=0

EXECUTION=( 4 3 1 )
LOOP=1
SUM=`expr ${EXECUTION[0]} + ${EXECUTION[1]} + ${EXECUTION[2]}`

RED='\033[0;31m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
GREEN='\033[01;32m'
NC='\033[0m'
BOLD='\033[1m'

WAV=alert.wav

header(){

	clear 
	echo "========= POMODORO SHELL ========="
	echo "#    Working time: $WORK_TIME minutes    #" 
	echo "#    Breaking time: $BREAK_TIME minutes    #"
	echo "#   Big pause time: $PAUSE_TIME minutes   #"
	echo "==================================="
	echo ""
	echo -e "        It's Time to: $STATE"
	echo ""
	echo "             TEMPO"
}

while true
do

	if [ $LOOP -eq $SUM ]; then	
		STATE="${BLUE}${BOLD}PAUSE${NC}"
		ACTIVITY="PAUSE"
		CONTROL=$PAUSE_TIME
		LOOP=0
	elif [ $WORK -eq 1 ]; then	
		STATE="${RED}${BOLD}WORK${NC}"
		ACTIVITY="WORK"
		CONTROL=$WORK_TIME		
	elif [ $BREAK -eq 1 ]; then	
		STATE="${ORANGE}${BOLD}BREAK${NC}${NC}"
		ACTIVITY="BREAK"
		CONTROL=$BREAK_TIME
	fi
	
	notify-send "It's Time to: $ACTIVITY" "Do this for the next $CONTROL minutes!"
	aplay $WAV aplay $WAV > /dev/null 2>&1

	while [ $MINUTES -lt $CONTROL ]
	do
		
		while [ $SECONDS -lt 59 ]
		do
			sleep 1
			clear
			if [ $MINUTES -lt 10 ]; then
				if [ $SECONDS -lt 10 ]; then				
					header
					echo -e "             ${GREEN}${BOLD}0$MINUTES:0$SECONDS${NC}${NC}"
				else				
					header
					echo -e "             ${GREEN}${BOLD}0$MINUTES:$SECONDS${NC}${NC}"
				fi
			else				
				header
				echo -e "             ${GREEN}${BOLD}$MINUTES:$SECONDS${NC}${NC}"
			fi	

		done

		MINUTES=`expr $MINUTES + 1`
		SECONDS=0
	done
	
	MINUTES=0
	LOOP=`expr $LOOP + 1`
	
	if [ $WORK -eq 1 ]; then	
		WORK=0
		BREAK=1
	elif [ $BREAK -eq 1 ]; then	
		WORK=1
		BREAK=0
	fi
	
done