APIEndpoint
ec2-18-213-101-22.compute-1.amazonaws.com
This is the Endpoint of the API service
-
PostgresEndpoint
de-c4w4a1-rds.cluk4kcsa898.us-east-1.rds.amazonaws.com
RDS endpoint for Postgres DB instance
-
PostgresJDBCConnectionString
jdbc:mysql://de-c4w4a1-rds.cluk4kcsa898.us-east-1.rds.amazonaws.com:5432
JDBC connection string for Postgres database
-
RedshiftClusterEndpoint
de-c4w4a1-redshift-cluster.c7vhjr0vkz1x.us-east-1.redshift.amazonaws.com
Redshift Cluster endpoint
-
RedshiftClusterName
de-c4w4a1-redshift-cluster
Name of Redshift cluster
-
ScriptsBucket
de-c4w4a1-437877167932-us-east-1-scripts
Bucket for Glue job scripts




APIEndpoint
ec2-18-213-101-22.compute-1.amazonaws.com
This is the Endpoint of the API service
-
PostgresEndpoint
de-c4w4a1-rds.cluk4kcsa898.us-east-1.rds.amazonaws.com
RDS endpoint for Postgres DB instance
-
PostgresJDBCConnectionString
jdbc:mysql://de-c4w4a1-rds.cluk4kcsa898.us-east-1.rds.amazonaws.com:5432
JDBC connection string for Postgres database
-
RedshiftClusterEndpoint
de-c4w4a1-redshift-cluster.c7vhjr0vkz1x.us-east-1.redshift.amazonaws.com
Redshift Cluster endpoint
-
RedshiftClusterName
de-c4w4a1-redshift-cluster
Name of Redshift cluster
-
ScriptsBucket
de-c4w4a1-437877167932-us-east-1-scripts
Bucket for Glue job scripts
-




source scripts/setup.sh

Outputs:

glue_api_users_extract_job = "de-c4w4a1-api-users-extract-job"
glue_rds_extract_job = "de-c4w4a1-rds-extract-job"
glue_role_arn = "arn:aws:iam::437877167932:role/de-c4w4a1-glue-role"
glue_sessions_users_extract_job = "de-c4w4a1-api-sessions-extract-job"
project = "de-c4w4a1"


glue_api_users_extract_job = "de-c4w4a1-api-users-extract-job"
glue_catalog_db = <sensitive>
glue_json_transformation_job = "de-c4w4a1-json-transform-job"
glue_rds_extract_job = "de-c4w4a1-rds-extract-job"
glue_role_arn = "arn:aws:iam::437877167932:role/de-c4w4a1-glue-role"
glue_sessions_users_extract_job = "de-c4w4a1-api-sessions-extract-job"
glue_songs_transformation_job = "de-c4w4a1-songs-transform-job"
project = "de-c4w4a1"
serving_schema = "deftunes_serving"
transform_schema = "deftunes_transform"

glue_api_users_extract_job = "de-c4w4a1-api-users-extract-job"
glue_catalog_db = <sensitive>
glue_json_transformation_job = "de-c4w4a1-json-transform-job"
glue_rds_extract_job = "de-c4w4a1-rds-extract-job"
glue_role_arn = "arn:aws:iam::437877167932:role/de-c4w4a1-glue-role"
glue_sessions_users_extract_job = "de-c4w4a1-api-sessions-extract-job"
glue_songs_transformation_job = "de-c4w4a1-songs-transform-job"
project = "de-c4w4a1"
serving_schema = "deftunes_serving"
transform_schema = "deftunes_transform"