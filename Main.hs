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

module Main
    where

import Foreign.C.Types
import Data.List
import Text.Printf
import StatVFS

main = do
    b <- readFile "/etc/mtab"
    let d = filter (\a -> "/dev/" `isPrefixOf` (a !! 0))  [words x | x <- lines b]
    let s = map (take 3) (sortBy (\a b -> compare (a !! 1) (b !! 1)) d)
    printf "%-25s %-18s %18s %18s %18s %s\n"
           (color "Mount" 0 33)
           (color "Type" 0 33)
           (color "Size" 0 33)
           (color "Used" 0 33)
           (color "Avail" 0 33)
           (color "Space" 0 33)
    mapM_ printRow s

printRow :: [[Char]] -> IO ()
printRow x = do
    s <- statvfs (x !! 1)
    let size = bsize s * blocks s
    let avail = bsize s * bfree s
    let used = size - avail
    printf "%-25s %-18s %s %s %s %s\n"
           (color (x !! 1) 0 34)
           (color (x !! 2) 0 36)
           (color (abrev size) 0 32)
           (color (abrev used) 0 32)
           (color (abrev avail) 0 32)
           (makeBar 40 (ratio used size))

abrev :: CULong -> [Char]
abrev x | a > 1024^3 = printf "%6.1fG" (a / 1024^3)
        | a > 1024^2 = printf "%6.1fM" (a / 1024^2)
        | a > 1024^1 = printf "%6.1fk" (a / 1024^1)
        where a = fromIntegral x :: Double

makeBar :: Int -> Double -> [Char]
makeBar width percent = s1 ++ s2
    where x = round $ fromIntegral width * percent
          y = width - x
          s1 = color256 (replicate x '\x2585') 38 25
          s2 = color256 (replicate y '\x2585') 38 233

color :: [Char] -> Int -> Int -> [Char]
color str a b = printf "\ESC[%d;%dm%s\ESC[0m" a b str

color256 :: [Char] -> Int -> Int -> [Char]
color256 str a b = printf "\ESC[%d;5;%dm%s\ESC[0m" a b str

ratio :: CULong -> CULong -> Double
ratio a b = (fromIntegral a) / (fromIntegral b)

{- vim: set syntax=haskell foldmethod=marker: -}
