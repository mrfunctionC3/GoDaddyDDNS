#!/bin/bash

# This script help to update your GoDaddy DNS server to the IP address of your current internet status.
# https://github.com/MorganFinTW/GoDaddyDDNS
#
# First, go to GoDaddy developer site to create a developer account
# https://developer.godaddy.com/getstarted
#
# Update the first 4 variables with your information

domain="yourdomainname.com"						# your domain
name="www"									    # name of A record to update
key="cjVuQm08dqg49UhRZpxm4J_dKP1Hfwy4iFJ"	    # key for godaddy developer API
secret="Gb6QeTyZcWJ4n87AFWHLmm" 				# secret for godaddy developer API

headers="Authorization: sso-key $key:$secret"

# echo $headers

result=$(curl -s -X GET -H "$headers" \
	"https://api.godaddy.com/v1/domains/$domain/records/A/$name")

dnsIp=$(echo $result | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
echo "dnsIp:" $dnsIp

# Get public ip address there are several websites that can do this.
ret=$(curl -s GET "http://ipinfo.io/json")
currentIp=$(echo $ret | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
echo "currentIp:" $currentIp

if [ "$dnsIp" != "$currentIp" ]; then
   request='[{"data":"'$currentIp'","ttl":3600}]'
   # echo $request
   nresult=$(curl -i -s -X PUT \
   -H "$headers" \
   -H "Content-Type: application/json" \
   -d $request "https://api.godaddy.com/v1/domains/$domain/records/A/$name")
   # echo $nresult
fi
