#!/bin/ksh 

######################## 
## 
## File name: all_lsnr_check.sh 
## author: Jesus Alejandro Sanchez - jsanchez.consultant@gmail.com
## 
## This script allows you to scan the /etc/oratab file and look for all Oracle Homes defined 
## there to access the listener.ora file and scan it for all listener names. Once that is done, 
## The script will show you the status of each listener and wait for your input to START or STOP 
## the listener or just continue to the next one. 
## 
## Pre-requisites: Set the Oracle environment 
## 
## 05/26/2014 Version 1.0 Jesus Alejandro Sanchez First version of the working script 
## 
############################## 

# Look for all oracle homes in /etc/oratab 
for CURRENT_HOME in `cat /etc/oratab | grep :/ | grep -v agent | cut -d":" -f2 | sort | uniq` 
do 
	echo " " 
	echo " " 
	echo "USING $CURRENT_HOME as the current oracle home" 
	echo "===========================================================================" 
	ORACLE_HOME=$CURRENT_HOME 
	for CURRENT_LSNR in $(cat $ORACLE_HOME/network/admin/listener.ora | grep LISTENER |grep -v SID | grep -v ADR |grep -v "#" |cut -d"=" -f1 | sort | uniq)
	do 
		echo " " 
		echo "CHECKING $CURRENT_LSNR" 
		echo "-------------------------------------------" 
		$ORACLE_HOME/bin/lsnrctl status $CURRENT_LSNR 
		ACTION="read it"; 
		while [[ ! -z $ACTION ]]
		do 
			echo " " 
			echo "********************************************" 
			echo "Type START to start the current listener" 
			echo "type STOP to stop the current listener" 
			echo "or press &lt;ENTER&gt; to continue" 
			read ACTION 
			case $ACTION in 
				START|start) 
					$ORACLE_HOME/bin/lsnrctl start $CURRENT_LSNR 
					$ORACLE_HOME/bin/lsnrctl status $CURRENT_LSNR 
					;; 
				STOP|stop) 
					$ORACLE_HOME/bin/lsnrctl stop $CURRENT_LSNR 
					$ORACLE_HOME/bin/lsnrctl status $CURRENT_LSNR 
					;; 
				*) 
					ACTION= 
					;; 
			esac 
		done 
	done 
done
