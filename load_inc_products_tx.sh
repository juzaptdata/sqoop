### Script_name: load_inc_products_tx.sh
### Description: Load fact table products_tx in a incremental fashion
### Created by:  Juan Zapata
### Created date: 18/05/2017
### Version: 2


#/bin/sh

file="./app.properties"

log = $app_log/load_inc_products_tx/log.txt

echo "Incremental load to fact_table start ">>$log

if [ -f "$file" ]
then
  echo "$file found.">>$log

  while IFS='=' read -r key value
  do
    key=$(echo $key | tr '.' '_')
    eval ${key}=\${value}
  done < "$file"

  echo "Properties file loaded"					>>$log
  echo "Database server       = " ${DBSERVER}	>>$log	
  echo "Database name 		  =	" ${DBNAME}		>>$log
  echo "Database user         = " ${DBUSER}		>>$log
  echo "Database password 	  = " ${DBPASSWORD}	>>$log
  echo "Database driver 	  = " ${DBDRIVER}	>>$log	
  echo "Database IP 	  	  = " ${DBIP}		>>$log
  echo "Database port 	      = " ${DBPORT}		>>$log
  
  echo "Incremental load starting ...">>$log
  
  sqoop job --exec job_load_inc_products_tx
  
  echo "Incremental load completed ">>$log
  
else
  echo "$file not found.">>$log
fi
