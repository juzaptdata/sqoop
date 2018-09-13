### Script_name: first_load_fact_table.sh
### Description: Loading of data for the very first time to fact_table
### Created by:  Juan Zapata
### Created date: 18/05/2017
### Version: 3

#/bin/sh

file="./app.properties"

log = $app_log/first_load_fact_table/log.txt

echo "Load 0-level to fact_table start ">>$log

if [ -f "$file" ]
then
  echo "$file found.">>$log
  

  while IFS='=' read -r key value
  do
    key=$(echo $key | tr '.' '_')
    eval ${key}=\${value}
  done < "$file"

  echo "Properties file loaded" 				            >>$log
  echo "Database server         = " ${DBSERVER}	    >>$log
  echo "Database name 		      =	" ${DBNAME}		    >>$log
  echo "Database user           = " ${DBUSER}		    >>$log
  echo "Database password 	    = " ${DBPASSWORD}	  >>$log
  echo "Database driver 	      = " ${DBDRIVER}	    >>$log	
  echo "Database IP 	  	      = " ${DBIP}		      >>$log
  echo "Database port 	        = " ${DBPORT}		    >>$log
  
  echo "Database load 0 starting ...">>$log
  
  sqoop import-all-tables \
	--connect jdbc:${DBDRIVER}:@//${DBIP}:${DBPORT}/${DBNAME} \ 
	--username ${DBUSER} \
	--password ${DBPASSWORD} \
	--hive-import \
	--hive-database PANAMA_SALES_REPORT  
  
  echo "Database load completed ">>$log
  
else
  echo "$file not found.">>$log
fi
