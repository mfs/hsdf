## hsdf

A df clone written in [Haskell][1].

Written to gain some experience with Haskell outside of my xmonad.hs. Wanted a
simple application that made use of the [FFI][2]. The code is quite atrocious at
the moment. I plan to clean it up over time as my Haskell skills improve. At the
moment hsdf is not configurable apart from making changes to Main.hs. Hsdf may
fail to correctly display the bar graph if you are not using a 256 color
terminal.

StatVFS.hsc is based on [statvfs.hsc][3] by Vasyl Pasternak

## Building

Building is currently make based. Running make should result in a `hsdf`
executable:
<code>
    $ make
    hsc2hs StatVFS.hsc
    sed -ie '1d' StatVFS.hs
    ghc --make Main.hs -o hsdf
    [1 of 2] Compiling StatVFS          ( StatVFS.hs, StatVFS.o )
    [2 of 2] Compiling Main             ( Main.hs, Main.o )
    Linking hsdf ...
</code>

## Possible Improvements

- <del>Remove all references to Foreign.C.Types types from main.hs</del>
- Clean up color and printf output code. Escape sequences and printf format
  flags don't mix well.
- Add a percentage column.
- Adjust column widths automatically.
- Adjust bar graph width depending on terminal width.
- Make configurable.
- Improve build system. Cabal?
- Clean up Int, Integer, Double, CULong usage. Shouldn't need ratio function.
- Improved error checking.

[1]: http://www.haskell.org/
[2]: http://en.wikibooks.org/wiki/Haskell/FFI
[3]: http://web.archiveorange.com/archive/v/nDNOvdMEB2sZFcCHnltz#cSHZqAzErbQgA73
