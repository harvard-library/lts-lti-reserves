# Implementation Notes

**lts-lti-reserves** is intended to be a faculty- and student-facing application in support of creating, maintaining, and viewing the Library reserves associated with a course. It is designed to work within the [Learning Tools Interoperability](http://www.imsglobal.org/activity/learning-tools-interoperability) (LTI) Framework.

**lts-lti-reserves** serves as the "front end" to LTS's sophisticated library Reserves Tool that supports the  workflow of requesting items to be placed on the Reserves list, from initial request through a possibly complex series of steps to making the item available to students.  
## API use

Unlike many conventional Rails applications, **lts-lti-reserves** does not maintain reserves data in a local database, instead communicating via a RESTful API with LTS's Reserves Tool, where the data is processed and stored. Two other APIs are used to make composing the Library Reserve list as easy as possible.


Direct communication with the APIs is handled by modules in the **app/services/** subdirectory.  

* [rlist.rb] (https://github.com/harvard-library/lts-lti-reserves/blob/master/app/services/rlist.rb) interacts with LTS's Reserves Tool API
* [icommons.rb] (https://github.com/harvard-library/lts-lti-reserves/blob/master/app/services/icommons.rb) gets information from the [iCommons REST API v2] (https://icommons.harvard.edu/api/course/v2/). The information is used to identify instances of the course in previous terms (to enable the "reuse reserves from previous term"
* [lib_services.rb] (https://github.com/harvard-library/lts-lti-reserves/blob/master/app/services/lib_services.rb) gets bibligraphic data from Harvard Library's [PRESTO Data Lookup API](https://wiki.harvard.edu/confluence/display/LibraryStaffDoc/PRESTO+Data+Lookup), given the HOLLIS (Aleph) number, DOI (Document Object Identifier), or PUBMED number.
* [ecru_services.rb] (https://github.com/harvard-library/lts-lti-reserves/blob/master/app/services/ecru_services.rb) is not yet fully implemented.  The intention is to eventually interact with Harvard Library's [Electronic Course Reserves Unleashed!] (https://github.com/harvard-library/ecru) (**ecru**) to provide the information for the Student-facing display of Reserves, in order to lighten the burden on the Reserves Tool API server.

All of the above modules include [rest_handler.rb] (https://github.com/harvard-library/lts-lti-reserves/blob/master/app/services/rest_handler.rb), which correctly handles unsuccessful http transactions.

## Logging

Harvard Library runs its Rails applications under Apache, using Passenger.  However, since the Apache-combined log is not detailed enough to provide meaningful analytics of POST operations, **lts-lti-reserves* creates a special, comma-separator-delimited file,
`*log/post_log.csv*`.


This file is created with the following header line:
```shell
Date,Time,IP Address, Course Instance ID, Reserve ID, Action
```

The intent of this file is to track the creation, update, and deletion of individual reserves, plus any reordering of the Library Reserves List for a particular course. We do not record the canvas user id of the requestor;  the IP address is sufficiently unique for our purposes, since we are not interested in the real identity of **who** is doing **what**.