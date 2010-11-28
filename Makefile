all: hsdf

StatVFS.hs: StatVFS.hsc
	hsc2hs StatVFS.hsc
	sed -ie '1d' StatVFS.hs

hsdf: Main.hs StatVFS.hs
	ghc --make Main.hs -o hsdf

.PHONY: clean
clean:
	rm -f hsdf *.o *.hse *.hi StatVFS.hs
