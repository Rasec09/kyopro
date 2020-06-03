--- frederick99, 6/2020
--- https://codeforces.com/contest/1360/problem/H

{-# LANGUAGE TupleSections #-}
import           Control.Monad ( replicateM_ )
import           Data.List     ( foldl' )
import qualified Data.Set as Set


type Bit   = Char
type Byte  = [Bit]
type Width = Int    -- width of byte


binaryMedian :: Width -> [Byte] -> Byte
binaryMedian width _remove = toByte width median'
    where
        median = 2^(width-1) - 1
        remove = fromByte width `map` _remove
        (_, median', _) = foldl' go (False, median, Set.empty) remove

        go (isOdd, med, seen) rem = (isOdd', med', seen') where
                isOdd'= not isOdd
                seen' = Set.insert rem seen
                get f = head $ dropWhile (`Set.member` seen') (iterate f med)
                med' =
                    if  not isOdd && rem <= med then get succ
                    else if isOdd && rem >= med then get pred
                    else med


fromBit :: Bit -> Int
fromBit '0' = 0
fromBit '1' = 1


toBit :: Int -> Bit
toBit 0 = '0'
toBit 1 = '1'


fromByte :: Width -> Byte -> Int
fromByte m = foldl' go 0
    where go num bit = 2*num + fromBit bit


toByte :: Width -> Int -> Byte
toByte m = foldl' go "" . take m . iterate (`div` 2)
    where go bits k = toBit (k `mod` 2) : bits


readInput :: IO (Width, [Byte])
readInput = do
    [n, m] <- map read . words <$> getLine
    (m, ) <$> (sequence $ replicate n getLine)


main :: IO ()
main = do
    t <- read <$> getLine
    replicateM_ t (uncurry binaryMedian <$> readInput >>= putStrLn)
