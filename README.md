# check_postman.sh

  a nagios wrapper for postmans newman cli client.
  script will abort on failed test cases.

  to avoid errors be sure to run the latest version of newman:
   * ~# npm install -g newman
   * ~# npm update  -g newman

  to aquire postman cloud API UIDs go here:
   * https://github.com/postmanlabs/newman#using-newman-with-the-postman-cloud-api

  to aquire postman cloud API tokens go here:
   * https://app.getpostman.com/dashboard/integrations/pm_pro_api/list
 
   
## Commandline Options
```
check_postman.sh
  mandatory options:
  -a  postman API token
  -c  collection API UID
  -e  environment API UID
  -f  collection folder

  non-mandatory options:
  -p  print full test report instead of nagios parsable check result
  -h  print help
```
