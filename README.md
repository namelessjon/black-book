Black Book
==========

BlackBook is a simple addressbook (phone, email, postal addresses) application written in [sinatra](http://sinatrarb.com "Classy web developement") and backed by [MongoDB](http://mongodb.com "{name: 'mongo', type:'DB'}").  (I say mongo and not anything else, as I'm using the ruby driver at this time, with no ODM, ORM or whatever.)

As if simple wasn't enough of a clue, the app itself has almost no validation, and no authentication.  All it really does is display a list of names, and then an address page when you click on the name.  It does check that parameters passed are sane, and only persists a white-listed set of properties.

TODO
----

* Add some javascript (to expand the current edit/add interface, and maybe allow inline editing).
* Add some tests, I guess.
* Improve property white-listing.
* Add faculty for storing correspondence, e.g. scans of letters in GridFS, and transcripts.
* Re-write using [Express](http://expressjs.com/ "High performance, high class web development for Node.js")

