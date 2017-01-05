#!/bin/bash

# nagios wrapper for postman/newman collections
# b2c@dest-unreachable.net
# 2017-01-04

# license: GNU GENERAL PUBLIC LICENSE v2 (GPLv2)
# get a full copy here:
# https://opensource.org/licenses/GPL-2.0


# uncomment to debug:
#set -x

if ! [ "${BASH_VERSION:-}" ]; then
  echo "Script need bash, exiting."
fi

if ! [[ -x $(which newman 2>/dev/null) ]]; then
  echo "no newman binary found in path, exiting."
  exit 1
else
  NEWMAN="$(which newman)"
fi

COLLECTION_URL="https://api.getpostman.com/collections/"
ENVIRONMENT_URL="https://api.getpostman.com/environments/"
PRINT="0"
CHECKSTATUS="UNKNOWN"

help(){
echo "
 check_postman.sh
  a nagios wrapper for postmans newman cli client.
  script will abort on failed test cases.

  to avoid errors be sure to run the latest version of newman:
   * ~# npm install -g newman
   * ~# npm update  -g newman

  to aquire postman cloud API UIDs go here:
   * https://github.com/postmanlabs/newman#using-newman-with-the-postman-cloud-api

  to aquire postman cloud API tokens go here:
   * https://app.getpostman.com/dashboard/integrations/pm_pro_api/list

  mandatory options:
  -a  postman API token
  -c  collection API UID
  -e  environment API UID
  -f  collection folder

  non-mandatory options:
  -p  print full test report instead of nagios parsable check result
  -h  print help
  "
}

while getopts "a:c:e:f:hp" opt; do
  case $opt in
    a)
      APIKEY="?apikey=$OPTARG"
      ;;
    c)
      COLLECTION="$OPTARG"
      ;;
    e)
      ENVIRONMENT="$OPTARG"
      ;;
    f)
      FOLDER="$OPTARG"
      ;;
    h)
      help
      ;;
    p)
      PRINT="1"
      ;;
    *)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

if [[ -z ${APIKEY} ]] || [[ -z ${COLLECTION} ]] || [[ -z ${ENVIRONMENT} ]] || [[ -z ${FOLDER} ]] ;then
  echo "missing arguments, exiting. -h to display help"
  exit 1
fi

STARTTIME=$(date +%s.%N)
RESULT=$(
export HTTP_PROXY=""
export http_proxy=""
export HTTPS_PROXY=""
export https_proxy=""
${NEWMAN} run \
  --bail \
  --no-color \
  --disable-unicode \
  --folder "${FOLDER}" \
  --environment "${ENVIRONMENT_URL}${ENVIRONMENT}${APIKEY}" \
  "${COLLECTION_URL}${COLLECTION}${APIKEY}")
EXIT="$?"
ENDTIME=$(date +%s.%N)

TIME=$(echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."substr($2,1,3)}')

if [[ ${EXIT} -eq 0 ]]; then
  CHECKSTATUS="OK - Test of collection ${FOLDER} succeeded"
  RC="0"
else
  CHECKSTATUS="CRITICAL - Test of collection ${FOLDER} failed"
  RC="2"
  TIME="0.001"  # set time to zero so outages are easily spottable on a graph
fi

if [[ ${PRINT} -eq 0 ]]; then
  echo "${CHECKSTATUS} | time=${TIME}"
  exit ${RC}
else
  echo "${RESULT}"
  echo "Exit Status: ${EXIT}"
fi
