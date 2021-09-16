#!/bin/bash

# source .env file
. .env

# vars
base_url="https://api.hosting.ionos.com/"
curl_param="X-API-KEY:"
dns_zone="dns/v1/zones"
dns_records_start="dns/v1/"
dns_records_end="/records/"
output_type="accept: application/json"

function checkIfZoneIdExists {
	if [ -z ${zone_id+x} ]; 
	then  
		# get zone ID
		zone_id=$(curl -X GET "$base_url$dns_zone" -H "$curl_param $api_key" | jq '.[] | .id?');
		echo "zone_id=$zone_id" >> .env
		. .env
	fi
}

function checkIfRecordIdExists {
	if [ -z ${record_id+x} ]; 
	then
		echo "URL"
		echo "$base_url$dns_zone/$zone_id?recordName=$domain&recordType=$dns_type"
		# get record ID
		record_id=$(curl -X GET "$base_url$dns_zone/$zone_id?recordName=$domain&recordType=$dns_type" -H $output_type -H "$curl_param $api_key" | jq '.records? | .[] | .id?')
		echo "record_id=$record_id" >> .env
		. .env
	fi
}

checkIfZoneIdExists
checkIfRecordIdExists

# curl -X GET "$base_url$dns_records_start/$zone_id/$dns_records_end/$record_id" -H $output_type -H "$curl_param $api_key" -v | jq 
