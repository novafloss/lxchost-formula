SALT_CALL=salt-call -l debug --local --retcode-passthrough \
	--pillar-root=test/pillar \
	--file-root=$(shell pwd)

.PHONY: all
all:

.PHONY: setup
setup:
	apt-get -qy update
	apt-get install -y curl
	curl -qL http://bootstrap.saltstack.org | sh -s -- -P stable

.PHONY: test
test:
	$(SALT_CALL) state.show_sls lxchost
	$(SALT_CALL) state.sls lxchost
	$(SALT_CALL) state.sls lxchost test=True | tee /tmp/second
	! grep -q "^Not Run:" /tmp/second

.PHONY: test-ci
test-ci:
	$(SALT_CALL) state.show_sls lxchost
