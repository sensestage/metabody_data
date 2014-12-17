# OSCGoupClient

* start with:

`OscGroupClient nutzerverwaltung.de 22242 57200 57100 57000 nescivi sillypwd metabody savypwd`

* this forwards data coming in at 57100 to the OscGroup
* this sends data coming into the OSCGroupClient to 57000
* 57200 is the port on the local machine that forwards to the server that listens at `nutzerverwaltung.de:22242`
* `nescivi` is the username (should be unique per machine/user), `sillypwd` is the password
* `metabody` is the group, `savypwd` is the password for the group - everyone wanting to share data should be in the same group

# XOSC

* start with:

`xoscmain 57000`

* this creates an instance of xosc that listens for data at port 57000

# making connections for XOSC

* just labeling the client/host:

`"/XOSC/register/client" "oscgroups" 57100`

`"/XOSC/register/host" "oscgroups" 57100`

* making a connection for a tag:

`"/XOSC/connect/tag" "127.0.0.1" 57100 "/hello"`

* making a connection for a host (all tags from that host), e.g. SuperCollider to OSCGroups:

`"/XOSC/connect/host" "127.0.0.1" 57120 "127.0.0.1" 57100`

* OSCGroups to SuperCollider

`"/XOSC/connect/host" "127.0.0.1" 57100 "127.0.0.1" 57120`
