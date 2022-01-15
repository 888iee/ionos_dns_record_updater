#!/bin/bash

###################################
########## Help ###################
###################################
Help() {
	# Show Help
	echo "If you need further help than the below, read the readme file \n
	or create an issue on github"
    echo "Syntax update.sh [-a|-i|-v]."
    echo "options:"
    echo "-a	change dns entry to given ip adress"
	echo "-i	start interactive mode"
    echo "-v	give verbose output"
    echo
}

# Get Flags
while getopts "hia:" opt; do
        case $opt in
                h) # display help
                        Help;;

				a) # ip adress
					IP=$OPTARGS;;

                i) # interactive mode 
				;;

                \?) # invalid options
                        echo "Error: Invalid options"
                        exit 0;;
        esac
done




# source .env file
SCRIPTPATH=$(dirname $(readlink -f "$0"))
. "$SCRIPTPATH/.env"

# vars
base_url="https://api.hosting.ionos.com/"
curl_param="X-API-KEY:"
dns_zone="dns/v1/zones"
dns_records_start="dns/v1/"
dns_records_end="/records/"
zone="zones/"
output_type="accept: application/json"

function checkIfZoneIdExists {

	if [ -z ${zone_id+x} ]; 
	then  
		# get zone ID
		zone_id=$(curl -X GET "$base_url$dns_zone" -H "$curl_param $api_key" -s | jq '.[] | .id?');
		echo "zone_id=$zone_id" >> "$SCRIPTPATH/.env"
		. "$SCRIPTPATH/.env"
	fi
}

function checkIfRecordIdExists {

	if [ -z ${record_id+x} ]; 
	then
		# get record ID
		record_id=$(curl -X GET "$base_url$dns_zone/$zone_id?recordName=$domain&recordType=$dns_type" -H $output_type -H "$curl_param $api_key" -s | jq '.records? | .[] | .id?')
		echo "record_id=$record_id" >> "$SCRIPTPATH/.env"
		. "$SCRIPTPATH/.env"
	fi
}

function GetDNSRecord {

	record_url="$base_url$dns_records_start$zone$zone_id$dns_records_end$record_id"

	curl -X GET "$record_url" -H "$output_type" -H "$curl_param $api_key" -s | jq '.content'
}

function UpdateDNSRecord {

	updater_url="$base_url$dns_records_start$zone$zone_id$dns_records_end$record_id"
	req_body="{\"content\":\"$1\"}"

	curl -X PUT "$updater_url" -H "Content-Type: application/json" -H "$curl_param $api_key" -d "$req_body"
}

checkIfZoneIdExists
checkIfRecordIdExists

# get current ip in dns record
current_ip=$(GetDNSRecord)

# update ip if they don't match
if [[ "$1" != "$current_ip" ]];
then
	UpdateDNSRecord "$1"
fi
