> **Note:** This file is written in Markdown and is best viewed with a Markdown viewer (e.g., GitHub, GitLab, VS Code, or a dedicated Markdown reader). Viewing it in a plain text editor may not render the formatting as intended.

Copyright (c) 2025 Software Tree

# Gilhari One-to-Many Example

> **Demonstrates one-to-many relationships between JSON objects with Gilhari ORM**

Gilhari is a Docker-compatible microservice framework that provides RESTful Object-Relational Mapping (ORM) functionality for JSON objects with any relational database.

Remarkably, Gilhari automates REST APIs (POST, GET, PUT, DELETE, etc.) handling, JSON CRUD operations, and database schema setup — **no manual coding required**.

## About This Example

This repository contains a standalone example showing how to configure Gilhari to handle one-to-many relationships between JSON objects using the BYREFERENCE pattern.

The example uses the base Gilhari docker image (softwaretree/gilhari) to easily create a new docker image (gilhari_onetomany_example) that can run as a RESTful microservice (server) to persist app specific JSON objects with relational mappings.

This example can be used **standalone as a RESTful microservice** or optionally with the ORMCP Server.

**Related:**
- Main ORMCP Server: [https://github.com/SoftwareTree/ormcp-server](https://github.com/SoftwareTree/ormcp-server)

**Note:** This example is also included in the Gilhari SDK distribution. If you have the SDK installed, you can use it directly from the `examples/gilhari_onetomany_example` directory without cloning.

## Example Overview

The example showcases a JSON object model with two types of objects: **Department** and **Employee**

**Object Model Overview:**
- **Department**: Department object with id, name, location, budget, and employees array
- **Employee**: Employee object with id, first name, last name, salary, and department reference
- **Attributes**: 
  - Department: deptId (int), name (string), location (string), budget (double), employees (array of Employee objects)
  - Employee: empId (int), firstName (string), lastName (string), salary (double), deptId (int)
- **Database Tables**: DEPT, EMP

### What Makes This Example Different?

This example demonstrates a **one-to-many relationship** with **BYREFERENCE** semantics:

**One-to-Many Relationship:**
- A **Department object** can contain an array of **Employee objects** (one-to-many relationship)
- Each **Employee** belongs to one **Department** (referenced via deptId)
- The relationship is unidirectional - you navigate from Department to Employees

**BYREFERENCE Semantics:**
- Employees and Departments can be created separately and associated later
- An Employee is **not deleted** if its Department is deleted
- Objects maintain their independence while supporting relational navigation

**Configuration:**
See `config/gilhari_onetomany_example.jdx` for how to configure one-to-many BYREFERENCE relationships.

### Department Object Structure
```json
{
  "deptId": 101,
  "name": "HR",
  "location": "New York",
  "budget": 500000.00,
  "employees": [
    {
      "empId": 201,
      "firstName": "John",
      "lastName": "Doe",
      "salary": 70000.00,
      "deptId": 101
    },
    {
      "empId": 202,
      "firstName": "Jane",
      "lastName": "Smith",
      "salary": 75000.00,
      "deptId": 101
    }
  ]
}
```

### Employee Object Structure
```json
{
  "empId": 201,
  "firstName": "John",
  "lastName": "Doe",
  "salary": 70000.00,
  "deptId": 101
}
```

## Project Structure

```
gilhari_onetomany_example/
├── src/                           # Container domain model classes
│   └── com/softwaretree/...      # Department.java, Employee.java
├── config/                        # Configuration files
│   ├── gilhari_onetomany_example.jdx  # ORM specification with one-to-many relationships
│   └── classnames_map_example.js
├── bin/                           # Compiled .class files
├── Dockerfile                     # Docker image definition
├── gilhari_service.config         # Service configuration
├── compile.cmd / .sh              # Compilation scripts
├── build.cmd / .sh                # Docker build scripts
├── run_docker_app.cmd / .sh       # Docker run scripts
├── curlCommands.cmd / .sh         # API testing scripts
└── curlCommandsPopulate.cmd / .sh # Sample data population scripts
```

## Source Code
The `src` directory contains the declarations of the underlying shell (container) classes (e.g., Department, Employee) that are used to define the object-relational mapping (ORM) specification for the corresponding conceptual domain-specific JSON object model classes:

- **Department and Employee classes**: Simple shell (container) classes (.java files) corresponding to the domain-specific JSON object model classes of related entities (Container domain model classes)
- **JDX_JSONObject**: Base class of the container domain model classes for handling persistence of domain-specific JSON objects
- **Container domain model classes**: Only need to define two constructors, with most processing handled by the JDX_JSONObject superclass

**Note:** Gilhari does not require any explicit programmatic definitions (e.g., ES6 style JavaScript classes) for domain-specific JSON object model classes. It handles the data of domain-specific JSON objects using instances of the container domain model classes and the ORM specification.

## Configurations

A declarative ORM specification for the domain-specific JSON object model classes and their attributes is defined in `config/gilhari_onetomany_example.jdx` using the container domain model classes. This file defines the mappings between JSON objects and database tables, **including the one-to-many relationship configuration**.

**Key points:**
- Update the database URL and JDBC driver in this file according to your setup
- See `JDX_DATABASE_JDBC_DRIVER_Specification_Guide` (.md or .html) for guides on configuring different databases
- The container domain model classes (like Department, Employee) corresponding to the conceptual domain-specific JSON object model classes are defined as subclasses of the JDX_JSONObject class
- Appropriate mappings for the domain-specific JSON object model classes are defined in the ORM specification file using the corresponding container domain model classes
- **One-to-many BYREFERENCE relationship configuration** allows independent object lifecycle management

For comprehensive details on defining and using container classes and the ORM specification for JSON object models, refer to the **"Persisting JSON Objects"** section in the JDX User Manual.

### One-to-Many Relationship Configuration

The key to this example is in the ORM specification file (`config/gilhari_onetomany_example.jdx`), where the one-to-many relationship is configured using BYREFERENCE semantics.

**Collection Class Definition:**
```
COLLECTION_CLASS ArrayEmployees COLLECTION_TYPE ARRAY ELEMENT_CLASS .Employee
    PRIMARY_KEY deptId 
;
```

**Department Class with Relationship:**
```
CLASS .Department TABLE DEPT
    VIRTUAL_ATTRIB deptId ATTRIB_TYPE int
    VIRTUAL_ATTRIB name ATTRIB_TYPE java.lang.String
    VIRTUAL_ATTRIB location ATTRIB_TYPE java.lang.String
    VIRTUAL_ATTRIB budget ATTRIB_TYPE double
    PRIMARY_KEY deptId 
    RELATIONSHIP employees REFERENCES ArrayEmployees WITH deptId
;
```

**Employee Class:**
```
CLASS .Employee TABLE EMP
    VIRTUAL_ATTRIB empId ATTRIB_TYPE int
    VIRTUAL_ATTRIB firstName ATTRIB_TYPE java.lang.String
    VIRTUAL_ATTRIB lastName ATTRIB_TYPE java.lang.String
    VIRTUAL_ATTRIB salary ATTRIB_TYPE double
    VIRTUAL_ATTRIB deptId ATTRIB_TYPE int 
    PRIMARY_KEY empId 
;
```

**Note:** The OBJECT_MODEL_OVERVIEW in the .jdx file states: *"This object model describes a one-to-many relationship between Department and Employee. It is a BYREFERENCE relationship - Employees and Departments can be added separately; an Employee is not deleted if its Department is deleted."*

### Docker Configuration

The `Dockerfile` builds a RESTful Gilhari microservice using:
- Base Gilhari image (softwaretree/gilhari)
- Compiled domain model (.class) files
- Configuration files including the ORM specification and a JDBC driver

### Service Configuration

The `gilhari_service.config` file specifies runtime parameters for the RESTful Gilhari microservice:

```json
{
  "gilhari_microservice_name": "gilhari_onetomany_example",
  "jdx_orm_spec_file": "./config/gilhari_onetomany_example.jdx",
  "jdbc_driver_path": "/node/node_modules/jdxnode/external_libs/sqlite-jdbc-3.50.3.0.jar",
  "jdx_debug_level": 3,
  "jdx_force_create_schema": "true",
  "jdx_persistent_classes_location": "./bin",
  "classnames_map_file": "config/classnames_map_example.js",
  "gilhari_rest_server_port": 8081
}
```

#### Service Configuration Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `gilhari_microservice_name` | Optional name to identify this Gilhari microservice. The name is logged on console during start up | - |
| `jdx_orm_spec_file` | Location of the ORM specification file containing mapping for persistent classes | - |
| `jdbc_driver_path` | Path to the JDBC driver (.jar) file. SQLite driver included by default | - |
| `jdx_debug_level` | Debug output level (0-5). 0 = most verbose, 5 = minimal. Level 3 outputs all SQL statements | 5 |
| `jdx_force_create_schema` | Whether to recreate database schema on each run. `true` = useful for development, `false` = create only once | false |
| `jdx_persistent_classes_location` | Root location for compiled persistent (Container domain model) classes. Can be a directory (e.g., ./bin) or a JAR file path. Used as a Java CLASSPATH  | - |
| `classnames_map_file` | Optional JSON file that can map names of container domain model classes to (simpler) object class (type) names (e.g., by omitting a package name) to simplify REST URL| - |
| `gilhari_rest_server_port` | Port number for the RESTful service. This port number may be mapped to different port number (e.g., 80) by a docker run command. | 8081 |


## Build Files
- `compile.cmd` / `compile.sh`: Compiles the container domain model classes
- `sources.txt`: Lists the names of the container domain model class source (.java) files for compilation
- `build.cmd` / `build.sh`: Creates the Gilhari Docker image (gilhari_onetomany_example) using the local Dockerfile

**Note**: Compilation targets JDK version 1.8, which is compatible with the current Gilhari version.

## Quick Start

### For Quick Evaluation (No SDK Required)
If you just want to see this example in action without modifications:

1. **Clone this repository** (pre-compiled classes included)
2. **Install Docker**
3. **Build and run** (skip compilation step)

### For Development and Customization
If you want to modify the object model or create your own Gilhari microservices:

1. **Gilhari SDK**: Download and install from [https://softwaretree.com](https://softwaretree.com)
2. **JX_HOME environment variable**: Set to the root directory of your Gilhari SDK installation
3. **Java Development Kit (JDK 1.8+)** for compilation
4. **Docker** installed on your system

**Note:** The Gilhari SDK contains necessary libraries (JARs) and base classes required for compiling container domain model classes. While pre-compiled `.class` files are included in this repository for immediate use, you'll need the SDK to make any modifications to the object model or to create your own Gilhari microservices.

## Build and Run

### Option 1: Quick Run (Using Pre-compiled Classes)

**Skip compilation** and go straight to Docker:

```bash
# Windows
build.cmd
run_docker_app.cmd

# Linux/Mac
./build.sh
./run_docker_app.sh
```

### Option 2: Compile and Run (For Modifications)

**If you've made changes to the source code:**

1. **Ensure JX_HOME is set** to your Gilhari SDK installation directory

2. **Compile the classes**:
   ```bash
   # Windows
   compile.cmd
   
   # Linux/Mac
   ./compile.sh
   ```

3. **Build and run the Docker container**:
   ```bash
   # Windows
   build.cmd
   run_docker_app.cmd
   
   # Linux/Mac
   ./build.sh
   ./run_docker_app.sh
   ```

## REST API Usage

Once running, access the Gilhari microservice at:

```
http://localhost:<port>/gilhari/v1/:className
```

**Example endpoints:**
```
http://localhost:80/gilhari/v1/Department
http://localhost:80/gilhari/v1/Employee
http://localhost:80/gilhari/v1/health/check
```

### Supported HTTP Methods

| Method | Purpose | Example |
|--------|---------|---------|
| GET | Retrieve objects | `GET /gilhari/v1/Department` |
| POST | Create objects | `POST /gilhari/v1/Department` |
| PUT | Update objects | `PUT /gilhari/v1/Department` |
| PATCH | Partial update | `PATCH /gilhari/v1/Department` |
| DELETE | Delete objects | `DELETE /gilhari/v1/Department` |

### Example: Creating Departments and Employees

**Create a Department:**
```bash
curl -X POST http://localhost:80/gilhari/v1/Department \
  -H "Content-Type: application/json" \
  -d '{
    "entity": {
      "deptId": 101,
      "name": "HR",
      "location": "New York",
      "budget": 500000.00
    }
  }'
```

**Create Employees for a Department:**
```bash
curl -X POST http://localhost:80/gilhari/v1/Employee \
  -H "Content-Type: application/json" \
  -d '{
    "entity": [
      {
        "empId": 201,
        "firstName": "John",
        "lastName": "Doe",
        "salary": 70000.00,
        "deptId": 101
      },
      {
        "empId": 202,
        "firstName": "Jane",
        "lastName": "Smith",
        "salary": 75000.00,
        "deptId": 101
      }
    ]
  }'
```

**Get Department with all Employees:**
```bash
curl -X GET "http://localhost:80/gilhari/v1/Department?filter=deptId=101" \
  -H "Content-Type: application/json"
```

**Query Employees with filter:**
```bash
curl -X GET "http://localhost:80/gilhari/v1/Employee?filter=salary>75000" \
  -H "Content-Type: application/json"
```

**Aggregate query (average salary):**
```bash
curl -X GET "http://localhost:80/gilhari/v1/Employee/getAggregate?attribute=salary&filter=deptId=101&aggregateType=AVG" \
  -H "Content-Type: application/json"
```

**Check microservice health:**
```bash
curl -X GET "http://localhost:80/gilhari/v1/health/check"
```

### Testing the API

**Comprehensive test scripts:**

1. **curlCommands.cmd / .sh** - Basic REST API test calls demonstrating one-to-many relationships

   Demonstrates:
   - Health check endpoint
   - Creating departments and employees
   - Querying with filters
   - Aggregate operations (COUNT, AVG)

2. **curlCommandsPopulate.cmd / .sh** - Comprehensive data population script

   Populates sample data with:
   - Multiple departments (HR, IT, Marketing)
   - Multiple employees per department
   - Demonstrates shallow queries (`deep=false`)
   - Advanced filtering and aggregate queries

Run the scripts to generate a `curl.log` file with all responses:
```bash
# Windows
curlCommands.cmd
curlCommandsPopulate.cmd

# Linux/Mac
chmod +x curlCommands.sh curlCommandsPopulate.sh
./curlCommands.sh
./curlCommandsPopulate.sh

# Custom port
curlCommands.cmd 8899
curlCommandsPopulate.sh 8899
```

**Other options:**
- **Postman**: Import the endpoints for interactive testing
- **Browser**: Access GET endpoints directly
- **Any REST Client**: Standard HTTP methods work with any REST client
- **ORMCP Server** (optional): Use ORMCP Server tools for AI-powered interactions

## Using with ORMCP Server (Optional)

This Gilhari microservice can be used with the ORMCP Server for AI-powered database interactions:

1. **Start this Gilhari microservice** (as shown in Quick Start)
2. **Configure ORMCP Server** to connect to this microservice endpoint
3. **Use ORMCP tools** to query and manipulate Department and Employee objects through natural language

The ORMCP Server will automatically handle the one-to-many relationship navigation.

## Development Tools

### Docker Container Access
Shell into a running container:
```bash
# Find container ID
docker ps

# Access container
docker exec -it <container-id> bash
```

### View Logs
```bash
docker logs <container-id>
```

### Stop Container
```bash
docker stop <container-id>
```

## Additional Resources

- **JDX User Manual**: "Persisting JSON Objects" section for detailed ORM specification documentation
- **Gilhari SDK Documentation**: The SDK available for download at [https://softwaretree.com](https://softwaretree.com)
- **ORMCP Server**: Main repository at [https://github.com/SoftwareTree/ormcp-server](https://github.com/SoftwareTree/ormcp-server)
- **Database Configuration Guide**: See `JDX_DATABASE_JDBC_DRIVER_Specification_Guide.md`

## Platform Notes

Script files are provided for both Windows (`.cmd`) and Linux/Mac (`.sh`). 

**Linux/Mac users**: Make scripts executable before running:
```bash
chmod +x *.sh
```

## Troubleshooting

### Common Issues

**Problem**: Docker image build fails
- **Solution**: Ensure the base Gilhari image is pulled: `docker pull softwaretree/gilhari`

**Problem**: Compilation errors
- **Solution**: Verify JDK 1.8+ is installed and JX_HOME environment variable is set correctly

**Problem**: Port 80 already in use
- **Solution**: Modify `run_docker_app` script to use a different port (e.g., `-p 8080:8081`)

**Problem**: Database connection errors
- **Solution**: Check `config/gilhari_onetomany_example.jdx` for correct database URL and JDBC driver path

**Problem**: Employees not appearing in Department query
- **Solution**: Ensure employees have the correct `deptId` matching the department. Verify the RELATIONSHIP configuration in the ORM specification

**Problem**: Deleting a department also deletes employees
- **Solution**: This example uses BYREFERENCE semantics, so employees should NOT be deleted. If they are, verify the ORM specification doesn't have BYVALUE configured

## Support

For issues or questions:
- **ORMCP Server issues**: [https://github.com/SoftwareTree/ormcp-server/issues](https://github.com/SoftwareTree/ormcp-server/issues)
- **This example**: [https://github.com/SoftwareTree/gilhari_onetomany_example/issues](https://github.com/SoftwareTree/gilhari_onetomany_example/issues)
- **Gilhari SDK**: Contact support at [gilhari_support@softwaretree.com](mailto:gilhari_support@softwaretree.com)

## License

This example code is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Important:** This license applies ONLY to the example code in this repository. The Gilhari software (including the softwaretree/gilhari Docker image and Gilhari SDK) and the embedded JDX ORM software are proprietary products owned by Software Tree.

The Gilhari Docker image includes an evaluation license for testing purposes. For production use or licensing beyond the evaluation period, please visit [https://www.softwaretree.com](https://www.softwaretree.com) or contact [gilhari_support@softwaretree.com](mailto:gilhari_support@softwaretree.com).

---

**Ready to try it?** Start with the [Quick Start](#quick-start) section above!