REM  A script to invoke some sample curl commands on a Windows machine
REM  against a running container image of the app-specific Gilhari microservice 
REM  gilhari_onetomany_example:1.0.
REM
REM  The responses are recorded in a log file (curl.log).
REM
REM  Note that these curl commands use a default mapped port number of 80
REM  even though the port number exposed by the app-specific
REM  microservice may be different (e.g., 8081) inside the container shell.
REM
REM  You may optionally specify a non-default port number as the first 
REM  command line argument to this script. For example, to spcify a 
REM  port number of 8899, use the following command:
REM     curlCommands 8899

IF %1.==. GOTO DefaultPort
SET port=%1
GOTO Proceed

:DefaultPort
SET port=80
GOTO Proceed

:Proceed

echo ** BEGIN OUTPUT ** > curl.log
echo. >> curl.log
echo. >> curl.log

echo Using PORT number %port% >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Check the health of the Gilhari microservice >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/health/check" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Delete all Employee objects to start fresh >> curl.log
curl -X DELETE "http://localhost:%port%/gilhari/v1/Employee" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Delete all Department objects to start fresh >> curl.log
curl -X DELETE "http://localhost:%port%/gilhari/v1/Department" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Insert one HR Department (deptId = 101) object >> curl.log
curl -X POST "http://localhost:%port%/gilhari/v1/Department"  -H "Content-Type: application/json"  -d "{""entity"":{""deptId"":101,""name"":""HR"",""location"":""New York"",""budget"":500000.00}}"
echo. >> curl.log
echo. >> curl.log

echo ** Insert multiple (5) Employee objects for HR Department (deptId = 101) >> curl.log
curl -X POST "http://localhost:%port%/gilhari/v1/Employee"  -H "Content-Type: application/json"  -d "{""entity"":[{""empId"":201,""firstName"":""John"",""lastName"":""Doe"",""salary"":70000.00,""deptId"":101},{""empId"":202,""firstName"":""Jane"",""lastName"":""Smith"",""salary"":75000.00,""deptId"":101},{""empId"":203,""firstName"":""Michael"",""lastName"":""Johnson"",""salary"":80000.00,""deptId"":101},{""empId"":204,""firstName"":""Sarah"",""lastName"":""Brown"",""salary"":72000.00,""deptId"":101}]}"
echo. >> curl.log
echo. >> curl.log

echo ** Query all Employee objects with salary greater than 75000>> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/Employee?filter=salary>75000"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query the count of all Employee objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/Employee/getAggregate?attribute=empId&aggregateType=COUNT"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query the average salary of all Employee objects in Marketing Department (deptId = 103) >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/Employee/getAggregate?attribute=salary&filter=deptId=103&aggregateType=AVG"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Delete all Employee objects to start fresh >> curl.log
curl -X DELETE "http://localhost:%port%/gilhari/v1/Employee" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Delete all Department objects to start fresh >> curl.log
curl -X DELETE "http://localhost:%port%/gilhari/v1/Department" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** END OUTPUT ** >> curl.log
echo. >> curl.log

type curl.log

