# Setup
###
target=build
source=src

pypath=PYTHONPATH=./$(target):./maxcdn:$(PYTHONPATH)

nose=./$(source)/nose/bin/nosetests

tests=./test/test.py
int=./test/int.py
test_opts=-v
cov_opts= --with-coverage --cover-package=maxcdn


# Tasks
###
init: clean setup test

setup: distribute
	pip install -r requirements.txt -t $(target) -b $(source)

clean:
	rm -rf $(source) $(target) .ropeproject .coverage junit-report.xml
	find . -type f -name "*.pyc" -exec rm -v {} \;

coverage: build/coverage
	$(pypath) python $(nose) $(cov_opts) $(tests)

test:
	$(pypath) python $(nose) $(test_opts) $(tests)

int:
	$(pypath) python $(nose) $(test_opts) $(int)

test/help:
	$(nose) --help | less

# TODO: support 3.x
#test/32:
	#$(pypath) python3.2 $(nose) $(test_opts) $(tests)

#test/33:
	#$(pypath) python3.3 $(nose) $(test_opts) $(tests)

travis: setup test

distribute:
	pip install distribute

build/coverage:
	pip install coverage -t $(target) -b $(source)

.PHONY: init clean test coverage test/help test/32 test/33

