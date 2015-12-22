# Implementation Notes

**lts-lti-reserves** is intended to be a faculty- and student-facing application in support of creating, maintaining, and viewing the Library reserves associated with a course. It is designed to work within the [Learning Tools Interoperability](http://www.imsglobal.org/activity/learning-tools-interoperability) (LTI) Framework.

**lts-lti-reserves** serves as the "front end" to LTS's sophisticated library Reserves Tool that supports the  workflow of requesting items to be placed on the Reserves list, from initial request through a possibly complex series of steps to making the item available to students.  

This application communicates with that Reserves Tool via a RESTful API, rather than maintaining reserves data in a local database. In addition, two other APIs are used: 

* the [iCommons REST API v2] (https://icommons.harvard.edu/api/course/v2/), which is used to identify instances of the course in previous terms (to enable the "reuse reserves from previous term"; and 
* Harvard Library's [PRESTO Data Lookup API](https://wiki.harvard.edu/confluence/display/LibraryStaffDoc/PRESTO+Data+Lookup), which is used to get bibliographic information for the reserve request, given the HOLLIS (Aleph) number, DOI (Document Object Identifier), or PUBMED number.

