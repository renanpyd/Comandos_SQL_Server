sql = """
        INSERT INTO YOUR_TABLE_NAME_HERE
        (
            your_column_name_1
            ,your_column_name_2
            ,your_column_name_3)
        VALUES(
            :your_param_1_name
            ,:your_param_2_name)
            ,:your_param_3_name
        """

param1 = {'name':'your_param_1_name', 'value':{'longValue': 5}}
param2 = {'name':'your_param_2_name', 'value':{'longValue': 63}}
param3 = {'name':'your_param_3_name', 'value':{'stringValue': 'para bailar la bamba'}}

param_set = [param1, param2, param3]

db_clust_arn = 'your_db_cluster_arn_here'

db_secret_arn = 'your_db_secret_arn_here'

rds_data = boto3.client('rds-data')

response = rds_data.execute_statement(
    resourceArn = db_clust_arn, 
    secretArn = db_secret_arn, 
    database = 'your_database_name_here', 
    sql = sql,
    parameters = param_set)

print(str(response))
READ example:

import boto3

rds_data = boto3.client('rds-data')

db_clust_arn = 'your_db_cluster_arn_here'

db_secret_arn = 'your_db_secret_arn_here'


employee_id = 35853

get_vacation_days_sql = f"""
    select vacation_days_remaining
    from employees_tbl
    where employee_id = {employee_id}    
        """


response1 = rds_data.execute_statement(
        resourceArn = db_clust_arn, 
        secretArn = db_secret_arn, 
        database = 'your_database_name_here', 
        sql = get_vacation_days_sql)

#recs is a list (of rows returned from Db)
recs = response1['records']

print(f"recs === {recs}")
#recs === [[{'longValue': 57}]]

#single_row is a list of dictionaries, where each dictionary represents a 
#column from that single row
for single_row in recs:
    print(f"single_row === {single_row}")
    #single_row === [{'longValue': 57}]
    
    #one_dict is a dictionary with one key value pair
    #where the key is the data type of the column and the 
    #value is the value of the column
    #each additional column is another dictionary
    for single_column_dict in single_row:
        print(f"one_dict === {single_column_dict}")
        # one_dict === {'longValue': 57}

        vacation_days_remaining = single_column_dict['longValue']
        
        print(f'vacation days remaining === {vacation_days_remaining}')