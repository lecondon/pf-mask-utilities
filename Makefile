SHELL := /bin/bash

TESTS=mask-test-1.pfsol \
	mask-test-2.pfsol \
	mask-test-3.pfsol \
	mask-test-4.pfsol \
	mask-test-6.pfsol \
	mask-test-7.pfsol

all : ascmask-to-pfsol pfsol-to-vtk maskdownsize

test: ascmask-to-pfsol pfsol-to-vtk maskdownsize
	rm -f $(TESTS)
	make $(TESTS)

%.pfsol: %.asc ascmask-to-pfsol
	./ascmask-to-pfsol $< $(patsubst %.pfsol,%.vtk,$@) $@ 
	cmp $@ regression-test/$@
	cmp $(patsubst %.pfsol,%.vtk,$@) regression-test/$(patsubst %.pfsol,%.vtk,$@)

clean:
	rm -f *.vtk *.pfsol
	rm -f ascmask-to-pfsol
	rm -f pfsol-to-vtk
	rm -f maskdownsize

ascmask-to-pfsol: ascmask-to-pfsol.cpp simplify.h
	g++ -O3 -std=c++11 ascmask-to-pfsol.cpp -o ascmask-to-pfsol

maskdownsize: maskdownsize.cpp
	g++ -O3 -std=c++11 maskdownsize.cpp -o maskdownsize

pfsol-to-vtk: pfsol-to-vtk.c
	gcc -O3  pfsol-to-vtk.c -o pfsol-to-vtk
