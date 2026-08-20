# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
# See README for copyright and licensing details.

PYTHON=python
SOURCES=$(shell find testtools -name "*.py")

check:
	PYTHONPATH=$(PWD) $(PYTHON) -m testtools.run testtools.tests.test_suite

TAGS: ${SOURCES}
	ctags -e -R testtools/

tags: ${SOURCES}
	ctags -R testtools/

clean:
	rm -f TAGS tags
	find testtools -name "*.pyc" -exec rm '{}' \;

prerelease:
	# An existing MANIFEST breaks distutils sometimes. Avoid that.
	-rm MANIFEST

release:
	./setup.py sdist upload --sign

snapshot: prerelease
	./setup.py sdist

apidocs:
	pydoctor --make-html --add-package testtools \
		--docformat=restructuredtext --project-name=testtools \
		--project-url=https://launchpad.net/testtools


.PHONY: check clean prerelease release apidocs
