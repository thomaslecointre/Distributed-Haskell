module Instr where

data Instr = Max [Int] deriving (Read,Show)

exec (Max xs) = maximum xs
