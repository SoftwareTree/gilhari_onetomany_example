package com.softwaretree.onetomany.model;

import org.json.JSONException;
import org.json.JSONObject;

import com.softwaretree.jdx.JDX_JSONObject;

/**
 * A shell (container) class parallel to a domain model object class for objects of type A 
 * based on the class JSONObject.  This class needs to define just two constructors.
 * Most of the processing is handled by the superclass JDX_JSONObject.
 * <p> 
 * @author Damodar Periwal
 *
 */
public class Department extends JDX_JSONObject {

    public Department () {
        super();
    }

    public Department (JSONObject jsonObject) throws JSONException {
        super(jsonObject);
    }
    
    // The following attribute (employees) is defined to mimic the underlying 
    // JSON object structure (one to many relationship) and is used for 
    // defining the JDX ORM specification.
    // There is no need to define their setters/getters.
    
    public Employee[] employees;

}
