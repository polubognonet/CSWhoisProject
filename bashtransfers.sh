#!/usr/bin/env bash

##
# Color  Variables
##
green='\e[32m'
blue='\e[94m'
red='\e[31m'
clear='\e[0m'

##
# Color Functions
##

ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}
ColorRed(){
	echo -ne $red$1$clear
}

##
# Default variables
##

defvalue="..."

##
# Functions
##

function setValues() {
  for i in $1 $2 $3
  do
    dot="\."
    dotandslash="\.\-"
    if [[ $i =~ $dot ]] || [[ $i =~ $dotandslash ]]; then
        domain=${i:-$defvalue}
        break;
      else domain=$defvalue
     fi
  done
  for i in $1 $2 $3
  do
    slash="\-"
    dot="\."
    if [[ $i =~ $dot ]]; then
       chat=$defvalue
       elif [[ $i =~ $slash ]]; then
       chat=${i:-$defvalue}
       break
       else
         chat=$defvalue
     fi
  done
  for i in $1 $2 $3
    do
      if [[ $i =~ ^[a-zA-Z]+$ ]]; then
         username=${i:-$defvalue}
         break;
       else username=$defvalue
       fi
    done

}

function syncTheDNS() {
  echo -ne "
$(ColorRed 'Please do not forget to mention the responsible person in the Flock room.')

---------------------------------------------------

@ Hello there Hosting RR! Please synchronize the DNS zone for the domain name.

# Chat ID: $chat
# Domain: $domain
# Username: $username ver
# Required server:

Thank you in advance!

---------------------------------------------------

$(ColorBlue 'Enter 0 to go back:')"
read b
if [[ $b == "0" ]]; then
  domains_hosting_menu "$chat" "$domain";
fi
}

function backupCheck() {
  echo -ne "
 $(ColorRed 'Please do not forget to mention the responsible person in the Flock room.')

 ---------------------------------------------------

 @ Hello there Hosting RR! Could you check if we have a backup?

 # Chat ID: $chat
 # Domain: $domain
 # Username: $username
 # Hosting: Shared/EasyWP

 Thank you in advance!

 ---------------------------------------------------
 $(ColorBlue 'Enter 0 to go back:')"
 read b
 if [[ $b == "0" ]]; then
  domains_hosting_menu "$chat" "$domain";
 fi
}

function askFu() {
  echo -ne "
 $(ColorRed 'Please do not forget to mention the responsible person in the Flock room.')

 ---------------------------------------------------

 @ Hello there Hosting RR! Please submit a FU for the client.

 # Chat ID: $chat
 # Description:

 Thank you in advance!

 ---------------------------------------------------

 $(ColorBlue 'Enter 0 to go back:')"
 read b
 if [[ $b == "0" ]]; then
  domains_hosting_menu "$chat" "$domain";
 fi
}

setValues "$1" "$2" "$3" "$defvalue"

menu(){
echo -ne "
# Hello $(ColorGreen "Domain's CS")
# This script is created in order to make the communication in Flock rooms easier and faster.
# author: Mikhail Kost
# version: 0.1

$(ColorBlue 'Chat ID'): $chat , $(ColorBlue 'Domain'): $domain , $(ColorBlue 'Username'): $username
------------------------------------------

    $(ColorGreen 'Flock rooms:')

$(ColorGreen '1)') CS: Domains-Hosting
$(ColorGreen '2)') CS: Billing
$(ColorGreen '3)') CS: Risk Management
$(ColorGreen '4)') Private Email CS team
$(ColorGreen '5)') CS: Domains & General
$(ColorGreen '6)') CS: Domain Shifts Swap
$(ColorGreen '0)') Exit

$(ColorBlue 'Choose an option(0-6):')"
        read a
        case $a in
	        1) domains_hosting_menu "$chat" "$domain" ;;
	        2) cpu_check ; menu ;;
	        3) tcp_check ; menu ;;
	        4) kernel_check ; menu ;;
	        5) all_checks ; menu ;;
		    	0) exit 0 ;;
			*) echo -e $red"Wrong option. Exit."$clear; exit 0;;
        esac
}

function domains_hosting_menu() {
    echo -ne "
    $(ColorGreen 'CS: Domains-Hosting')

$(ColorGreen '1)') Synchronize the DNS zone for $domain
$(ColorGreen '2)') Ask for the FU.
$(ColorGreen '3)') Backup check for Shared/EasyWP.
$(ColorGreen '4)') Re-send the Hosting Welcome email.
$(ColorGreen '5)') Create all necessary PE records.
$(ColorGreen '6)') Create Google Workspace MX records.
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option(0-6):')"
    read a
    case $a in
      1) syncTheDNS "$chat" "$domain" ;;
      2) askFu "$chat" ;;
      3) backupCheck ; "$chat" "$domain" ;;
      4) resendHostingEmail ; "$chat" "$domain" ;;
      5) all_checks ; menu ;;
      0) exit 0 ;;
      *) echo -e $red"Wrong option. Exit."$clear; exit 0;;
    esac
}

menu "$chat" "$domain"
