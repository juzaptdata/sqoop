### Script_name: create_job_load_fact_table.sh
### Description: Creates job to load fact table products_tx 
### Created by:  Juan Zapata
### Created date: 18/05/2017
### Version: 1

#/bin/sh

file="./app.properties"

log = $app_log/first_load_fact_table/log.txt

if [ -f "$file" ]
then
  echo "$file found."

  while IFS='=' read -r key value
  do
    key=$(echo $key | tr '.' '_')
    eval ${key}=\${value}
  done < "$file"

  echo "Properties file loaded"
  echo "Database server       = " ${DBSERVER}
  echo "Database name 		  =	" ${DBNAME}
  echo "Database user         = " ${DBUSER}
  echo "Database password 	  = " ${DBPASSWORD}
  echo "Database driver 	  = " ${DBDRIVER}
  echo "Database IP 	  	  = " ${DBIP}
  echo "Database port 	      = " ${DBPORT}


	sqoop job --create job_load_inc_products_tx \
	--import \
	--connect jdbc:${DBDRIVER}:@//${DBIP}:${DBPORT}/${DBNAME} \ 
	--username ${DBUSER} \
	--password ${DBPASSWORD} \
	--table PRODUCTS_TX \
	--target-dir ${TARGET_DIR} \
	--check-column tx_date \
	--incremental append \
	--last-value 0;
	
  echo "Job created "
  
else
  echo "$file not found."
fi	
