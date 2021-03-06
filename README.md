# lts-lti-reserves

The Library Reserves Tool as seen/used via Canvas

# This repository is deprecated and archived

*This functionality has been replaced at Harvard with the Leganto application from Ex-Libris*

## Mission
To enable Faculty, Reserves Librarians, and Students to manage Course Reserves Lists via Harvard's Canvas implementation

## Overview

This is a course-level external LTI tool that allows Faculty and Reserves Librarians to create, edit, view, and delete items that should be reserved for that course.

It includes:
  * A Responsive design
  * The ability to quickly insert metadata information about items that are found either in Harvard Library's [HOLLIS+](http://hollis.harvard.edu) discovery system, PUBMED, or that have a Document Object ID that can be found in the [Crossref](http://www.crossref.org) Metadata Services
  
It's built to work with Harvard's instantiation of the [canvas
lms](https://github.com/instructure/canvas-lms), Harvard Library's Reserves Tool API, the [iCommons REST API v2] (https://icommons.harvard.edu/api/course/v2/) and Harvard Library's [PRESTO Data Lookup API](https://wiki.harvard.edu/confluence/display/LibraryStaffDoc/PRESTO+Data+Lookup).

It takes advantage of the [dce-lti](https://github.com/harvard-dce/dce_lti) gem for managing the interactions between it and Canvas.

Some implementation details can be found [here] (https://github.com/harvard-library/lts-lti-reserves/blob/master/IMPL_NOTES.md)

## System Requirements

### General
* Ruby 2.x 
* Bundler
* A webserver capable of interfacing with Rails applications.  Ideally, Apache or Nginx with mod_passenger
* Linux/OSX.  Windows will probably work fine, but we don't test on Windows as of now.

## Application Set-up Steps

1. Get code from: https://github.com/harvard-library/lts-lti-reserves
2. Run bundle install. You will probably have to install OS-vendor supplied libraries to satisfy some gem install requirements.
3. Create a .env file for your environment.  Currently, the following variables are needed:

   ```
   DEV_DB_PW="passwordforyourdatabase"  # need one for TEST, QA, PROD, too!
   LTI_PROVIDER_TITLE="Library Reserves"
   LTI_PROVIDER_DESCRIPTION="This Tool allows Faculty to request Reserves from the  Library, and displays the resulting Reserves to students in the course"
   LTI_CONSUMER_SECRET="yourconsumersecret"  # needed for the LTI oauth
   LTI_CONSUMER_KEY="yourconsumerkey" # needed for the LTI oauth
   RLIST_URL= #url to the Library Reserves Tool REST API
   LIB_SERVICES_URL= #url to the PRESTO REST API "cite" endopoint
   ICOMMONS_URL= # url to the iCommons course information REST API; used to fetch previous term course instances
   ICOMMONS_AUTH= # the Authorization token generated by iCommons
   DEV_KEY_BASE= # secret generated by bundle exec rake secret (obviously need one for [TEST|QA|PROD]_KEY_BASE
   ```

4. Using dce-lti  (per the [Getting Started] (https://github.com/harvard-dce/dce_lti#getting-started ) )
  1.Create a database to support dce-lti
  2. modify `config/database.yml` to suit your environment (see the [database.yml.example]  (https://github.com/harvard-library/lts-lti-reserves/blob/master/config/database.yml.example) file )
  3. feel free to modify `config/initializers/session_store.rb` with your own unique app_session_key
  4. Bundle, install and then run migrations
  ```
    bundle
    rake dce_lti:install
    rake db:migrate
  ```
5. Set up cron jobs to run the rake jobs needed for dce-lti support:
  * dce_lti:clean_sessions (once a day)
  * dce_lti:clean_nonces  (once an hour)

## Capistrano

Deployment is beyond the scope of this README, and generally site-specific.  There are example capistrano deployment files that reflect deployment practice at Harvard.

Some basic notes:
* The example files are written with this environment in mind:
  * Capistrano 3+
  * A user install of RVM for ruby management


## Contributors

* Bobbi Fox - [bobbi-SMR](http://github.com/bobbi-SMR)
*  - [ives1227](https://github.com/ives1227)
*  

## License and Copyright
 This application is licensed with the MIT License

Copyright(c) 2015 President and Fellows of Harvard University



  
