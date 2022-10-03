In the federated timesheets projects, three projects were succesfully
integrated to federate timesheet information to each other:

- prejournal (https://github.com/pondersource/prejournal/)
- timeld (https://github.com/m-ld/timeld/)
- tikiwiki (https://gitlab.com/tikiwiki/tiki)

The idea is to create a set of docker containers of these systems within a
testnet.

Each system would then enter some timesheet information which is then
federated to the other systems. The other systems are queried to validate
that the timesheet data is indeed available there.

What we need:
- [ ] docker image for prejournal
- [ ] docker image for timeld
- [ ] docker image for tikiwiki
- [ ] docker image that will run the tests
- [ ] docker compose with a testnet to glue everything together

As we don't have a mechanism to federate user accounts on the other systems,
we will have to pre-populate the systems with accounts for the other
systems.

Each system will be prepopulated with a '<system>-timetracker' account, as
well as accounts for the other systems to use.  These will use a naming
scheme like '<source>-on-<target> All in all we need to create 9 accounts in
our docker containers:

- [ ] prejournal:
	- [ ] prejournal-timetracker
	- [ ] timeld-on-prejournal
	- [ ] tikiwiki-on-prejournal
- [ ] timeld:
	- [ ] timeld-timetracker
	- [ ] prejournal-on-timeld
	- [ ] tikiwiki-on-prejournal
- [ ] tikiwiki
	- [ ] tikiwiki-timetracker
	- [ ] prejournal-on-tikiwiki
	- [ ] timeld-on-tikiwiki

We will need a mechanism for each system to fetch a timesheet entry, which
is then used to validate that an entry has made it into the system.
- [ ] prejournal
- [ ] timeld
- [ ] tikiwiki

After that, we will have several tests that follow the same format:
- [ ] a timesheet entry is entered into a system A.
- [ ] timesheet data in system A is checked to validate the entry is there.
- [ ] federation to/from system B is triggered
- [ ] timesheet data in the system B checked to validate that the entry from
system A has been federated.

Tests need to be written for every to/from combination:
- [ ] prejournal -> timeld
- [ ] prejournal -> tikiwiki
- [ ] timeld -> prejournal
- [ ] timeld -> tikiwiki
- [ ] tikiwiki -> prejournal
- [ ] tikiwiki -> timeld
