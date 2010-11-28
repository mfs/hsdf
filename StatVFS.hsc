{- Licence {{{

Copyright 2010 Mike Sampson

This file is part of hsdf.

Hsdf is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Hsdf is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with hsdf.  If not, see <http://www.gnu.org/licenses/>.

}}} -}

{-# OPTIONS -XForeignFunctionInterface #-}

module StatVFS
     where

import Foreign
import Foreign.C.Types
import Foreign.C.String

#include <sys/statvfs.h>

data StatVFS = StatVFS {
    bsize :: CULong,
    frsize :: CULong,
    blocks :: CULong,
    bfree :: CULong
} deriving (Show)

instance Storable StatVFS where
    sizeOf _ = (#size struct statvfs)
    alignment _ = alignment (undefined :: CInt)
    peek ptr = do
        bsize' <- (#peek struct statvfs, f_bsize) ptr
        frsize' <- (#peek struct statvfs, f_frsize) ptr
        blocks' <- (#peek struct statvfs, f_blocks) ptr
        bfree' <- (#peek struct statvfs, f_bfree) ptr
        return StatVFS { bsize=bsize', frsize=frsize',
                         blocks=blocks', bfree=bfree' }
    poke _ _ = do
        return ()

foreign import ccall unsafe "static sys/statvfs.h statvfs"
    c_statvfs :: CString -> Ptr StatVFS -> IO CInt

statvfs :: String -> IO StatVFS
statvfs path = alloca $ \p ->
    withCString path $ \s ->
        do c_statvfs s p
           peek p

{- vim: set syntax=haskell foldmethod=marker: -}
