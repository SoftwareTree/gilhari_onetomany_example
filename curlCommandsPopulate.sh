#!/bin/bash

# A script to invoke some sample curl commands on a Linux/Unix/Mac machine
# against a running container image of the Gilhari microservice
# gilhari_onetomany_example:1.0.

# The responses are recorded in a log file (curl.log).

# Please make the script executable first:
#     chmod +x curlCommandsPopulate.sh

# Default port is 80 unless specified as the first command-line argument.
port=${1:-80}

# Begin logging
echo "** BEGIN OUTPUT **" > curl.log
echo "" >> curl.log
echo "" >> curl.log

echo "Using PORT number $port" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Health check
echo "** Check the health of the Gilhari microservice" >> curl.log
curl -X GET "http://localhost:$port/gilhari/v1/health/check" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Cleanup
echo "** Delete all Employee objects to start fresh" >> curl.log
curl -X DELETE "http://localhost:$port/gilhari/v1/Employee" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

echo "** Delete all Department objects to start fresh" >> curl.log
curl -X DELETE "http://localhost:$port/gilhari/v1/Department" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Insert HR department
echo "** Insert one HR Department (deptId = 101) object" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/Department" \
  -H "Content-Type: application/json" \
  -d '{"entity":{"deptId":101,"name":"HR","location":"New York","budget":500000.00}}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Insert one HR employee
echo "** Insert one (1) Employee object for HR Department (deptId = 101)" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/Employee" \
  -H "Content-Type: application/json" \
  -d '{"entity":{"empId":201,"firstName":"John","lastName":"Doe","salary":70000.00,"deptId":101}}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Insert three more HR employees
echo "** Insert multiple (3) Employee objects for HR Department (deptId = 101)" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/Employee" \
  -H "Content-Type: application/json" \
  -d '{"entity":[{"empId":202,"firstName":"Jane","lastName":"Smith","salary":75000.00,"deptId":101},{"empId":203,"firstName":"Michael","lastName":"Johnson","salary":80000.00,"deptId":101},{"empId":204,"firstName":"Sarah","lastName":"Brown","salary":72000.00,"deptId":101}]}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Insert IT department
echo "** Insert one IT Department(deptId = 102) object" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/Department" \
  -H "Content-Type: application/json" \
  -d '{"entity":{"deptId":102,"name":"IT","location":"San Francisco","budget":750000.00}}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Insert 2 IT employees
echo "** Insert multiple (2) Employee objects for IT Department(deptId = 102)" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/Employee" \
  -H "Content-Type: application/json" \
  -d '{"entity":[{"empId":301,"firstName":"Alice","lastName":"Williams","salary":80000.00,"deptId":102},{"empId":302,"firstName":"Bob","lastName":"Miller","salary":85000.00,"deptId":102}]}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Insert 6 more IT employees
echo "** Insert multiple (6) more Employee objects for IT Department(deptId = 102)" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/Employee" \
  -H "Content-Type: application/json" \
  -d '{"entity":[{"empId":303,"firstName":"Charlie","lastName":"Davis","salary":95000.00,"deptId":102},{"empId":304,"firstName":"David","lastName":"Garcia","salary":90000.00,"deptId":102},{"empId":305,"firstName":"Eve","lastName":"Martinez","salary":92000.00,"deptId":102},{"empId":306,"firstName":"Grace","lastName":"Hernandez","salary":96000.00,"deptId":102},{"empId":307,"firstName":"Henry","lastName":"Lopez","salary":88000.00,"deptId":102},{"empId":308,"firstName":"Isabella","lastName":"Gonzalez","salary":87000.00,"deptId":102}]}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Insert Marketing department
echo "** Insert one Marketing Department (deptId = 103) object" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/Department" \
  -H "Content-Type: application/json" \
  -d '{"entity":{"deptId":103,"name":"Marketing","location":"Los Angeles","budget":600000.00}}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Insert 5 Marketing employees
echo "** Insert multiple (5) Employee objects for Marketing Department (deptId = 103)" >> curl.log
curl -X POST "http://localhost:$port/gilhari/v1/Employee" \
  -H "Content-Type: application/json" \
  -d '{"entity":[{"empId":401,"firstName":"Nina","lastName":"Wilson","salary":85000.00,"deptId":103},{"empId":402,"firstName":"Liam","lastName":"Moore","salary":90000.00,"deptId":103},{"empId":403,"firstName":"Olivia","lastName":"Taylor","salary":95000.00,"deptId":103},{"empId":404,"firstName":"Sophia","lastName":"Anderson","salary":88000.00,"deptId":103},{"empId":405,"firstName":"Mason","lastName":"Thomas","salary":91000.00,"deptId":103}]}' >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Query shallow departments
echo "** Shallow Query all Department objects" >> curl.log
curl -X GET "http://localhost:$port/gilhari/v1/Department?deep=false" \
  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Query employees with salary > 80000
echo "** Query all Employee objects with salary greater than 80000" >> curl.log
curl -X GET "http://localhost:$port/gilhari/v1/Employee?filter=salary>80000" \
  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Count employees
echo "** Query the count of all Employee objects" >> curl.log
curl -X GET "http://localhost:$port/gilhari/v1/Employee/getAggregate?attribute=empId&aggregateType=COUNT" \
  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# Average salary in Marketing
echo "** Query the average salary of all Employee objects in Marketing Department (deptId = 103)" >> curl.log
curl -X GET "http://localhost:$port/gilhari/v1/Employee/getAggregate?attribute=salary&filter=deptId=103&aggregateType=AVG" \
  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log
echo "" >> curl.log

# End
echo "** END OUTPUT **" >> curl.log
echo "" >> curl.log

# Display log
cat curl.log
