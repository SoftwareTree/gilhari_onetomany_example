#!/bin/bash

# A script to invoke some sample curl commands on a Linux/Unix/Mac machine
# against a running container image of the app-specific Gilhari microservice
# gilhari_onetomany_example:1.0.

# The responses are recorded in a log file (curl.log).
# Note that these curl commands use a default mapped port number of 80
# even though the port number exposed by the app-specific microservice may be different (e.g., 8081) inside the container shell.

# Please make the script executable first:
#     chmod +x curlCommands.sh

# You may optionally specify a non-default port number as the first command line argument to this script.
# For example, to specify a port number of 8899, use the following command:
#    ./curlCommands.sh 8899

# Default port is 80
port=80

# Check if the user has provided a port as the first argument
if [ ! -z "$1" ]; then
    port=$1
fi

# Log file setup
echo "** BEGIN OUTPUT **" > curl.log
echo "" >> curl.log
echo "" >> curl.log

echo "Using PORT number $port" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Check the health of the Gilhari microservice
echo "** Check the health of the Gilhari microservice" >> curl.log
curl -X GET "http://localhost:$port/gilhari/v1/health/check" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Delete all Employee objects to start fresh
echo "** Delete all Employee objects to start fresh" >> curl.log
curl -X DELETE "http://localhost:$port/gilhari/v1/Employee" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Delete all Department objects to start fresh
echo "** Delete all Department objects to start fresh" >> curl.log
curl -X DELETE "http://localhost:$port/gilhari/v1/Department" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Insert one HR Department (deptId = 101) object
echo "** Insert one HR Department (deptId = 101) object" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/Department" -H "Content-Type: application/json" -d '{"entity":{"deptId":101,"name":"HR","location":"New York","budget":500000.00}}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Insert multiple (5) Employee objects for HR Department (deptId = 101)
echo "** Insert multiple (5) Employee objects for HR Department (deptId = 101)" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/Employee" -H "Content-Type: application/json" -d '{"entity":[{"empId":201,"firstName":"John","lastName":"Doe","salary":70000.00,"deptId":101},{"empId":202,"firstName":"Jane","lastName":"Smith","salary":75000.00,"deptId":101},{"empId":203,"firstName":"Michael","lastName":"Johnson","salary":80000.00,"deptId":101},{"empId":204,"firstName":"Sarah","lastName":"Brown","salary":72000.00,"deptId":101}]}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Query all Employee objects with salary greater than 75000
echo "** Query all Employee objects with salary greater than 75000" >> curl.log
curl -X GET "http://localhost:$port/gilhari/v1/Employee?filter=salary>75000" -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Query the count of all Employee objects
echo "** Query the count of all Employee objects" >> curl.log
curl -X GET "http://localhost:$port/gilhari/v1/Employee/getAggregate?attribute=empId&aggregateType=COUNT" -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Query the average salary of all Employee objects in Marketing Department (deptId = 103)
echo "** Query the average salary of all Employee objects in Marketing Department (deptId = 103)" >> curl.log
curl -X GET "http://localhost:$port/gilhari/v1/Employee/getAggregate?attribute=salary&filter=deptId=103&aggregateType=AVG" -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Delete all Employee objects to start fresh
echo "** Delete all Employee objects to start fresh" >> curl.log
curl -X DELETE "http://localhost:$port/gilhari/v1/Employee" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Delete all Department objects to start fresh
echo "** Delete all Department objects to start fresh" >> curl.log
curl -X DELETE "http://localhost:$port/gilhari/v1/Department" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# End of output
echo "** END OUTPUT **" >> curl.log
echo "" >> curl.log

# Display the log
cat curl.log
