module W2 where

-- Week 2:
--
--  * lists
--  * strings
--  * library functions for them
--  * higher order functions
--  * polymorphism
--
-- Functions you will need:
--  * head, tail
--  * take, drop
--  * length
--  * null
--  * map
--  * filter
--
-- You can ask ghci for the types of these functions with the :t
-- command:
--
--  Prelude> :t length
--  length :: [a] -> Int

import Data.List
import Data.Char

-- Ex 1: Define the constant years, that is a list of the values 1982,
-- 2004 and 2012 in this order.

years = [1982, 2004, 2012]

-- Ex 2: define the function measure that for an empty list returns -1
-- and for other lists returns the length of the list.

measure :: [String] -> Int
measure [] = -1
measure x = length x

-- Ex 3: define the function takeFinal, which returns the n last
-- elements of the given list.

takeFinal :: Int -> [Int] -> [Int]
takeFinal 0 xs = []
takeFinal _ [] = []
takeFinal n xs = drop (length xs - n) xs

-- Ex 4: remove the nth element of the given list. More precisely,
-- return a list that is identical to the given list except the nth
-- element is missing.
--
-- Note! indexing starts from 0
--
-- Examples:
-- remove 0 [1,2,3]    ==>  [2,3]
-- remove 2 [4,5,6,7]  ==>  [4,5,7]
--
-- The [a] in the type signature means "a list of any type"

remove :: Int -> [a] -> [a]
remove i xs = take i xs ++ drop (i+1) xs

-- Ex 5: substring i n s should return the length n substring of s
-- starting at index i.
--
-- Remember that strings are lists!

substring :: Int -> Int -> String -> String
substring i n s = take n (drop i s) 

-- Ex 6: implement the function mymax that takes as argument a
-- measuring function (of type a -> Int) and two values (of type a).
--
-- mymax should apply the measuring function to both arguments and
-- return the argument for which the measuring function returns a
-- higher value.
--
-- Examples:
--
--  mymax (*2)   3       5      ==>  5
--  mymax length [1,2,3] [4,5]  ==>  [1,2,3]
--  mymax head   [1,2,3] [4,5]  ==>  [4,5]

mymax :: (a -> Int) -> a -> a -> a
mymax measure a b = if measure a > measure b then a else b

-- Ex 7: countSorted receives a list of strings and returns a count of
-- how many of the strings are in alphabetical order (i.e. how many of
-- the strings have their letters in alphabetical order)
--
-- Remember the functions length, filter and sort

countSorted :: [String] -> Int
countSorted ss = length $ filter sorted ss
  where sorted s = sort s == s

-- Ex 8: Implement a function funny, that
--  - takes in a list of strings
--  - returns a string
--    - that contains all input words of length over 5
--    - ... combined into one string
--    - ... separated with spaces
--    - ... and converted to upper case!
--
-- These functions will help:
--  - toUpper :: Char -> Char   from the module Data.Char
--  - intercalate               from the module Data.List

funny :: [String] -> String
funny strings = map toUpper . intercalate " " . filter (\x -> length x > 5) $ strings

-- Ex 9: implement quicksort. 

quicksort :: [Int] -> [Int]
quicksort [] = []  
quicksort (x:xs) =   
    let smallerSorted = quicksort [a | a <- xs, a <= x]  
        biggerSorted = quicksort [a | a <- xs, a > x]  
    in  smallerSorted ++ [x] ++ biggerSorted  

-- Ex 10: powers k max should return all the powers of k that are less
-- than or equal to max. For example:
--
-- powers 2 5 ==> [1,2,4]
-- powers 3 30 ==> [1,3,9,27]
-- powers 2 2 ==> [1,2]
--
-- Hints:
--   * n^max > max
--   * the function takeWhile

powers :: Int -> Int -> [Int]
powers n max = takeWhile (<=max) $ map (n^) [0..max]

-- Ex 11: implement a search function that takes an updating function,
-- a checking function and an initial value. Search should repeatedly
-- apply the updating function to the initial value until a value is
-- produced that passes the checking function. This value is then
-- returned.
--
-- Examples:
--
--   search (+1) even 0   ==>   0
--
--   search (+1) (>4) 0   ==>   5
--
--   let check [] = True
--       check ('A':xs) = True
--       check _ = False
--   in search tail check "xyzAvvt"
--     ==> Avvt

search :: (a->a) -> (a->Bool) -> a -> a
search update check initial = if check initial then initial else search update check (update initial)

-- Ex 12: given numbers n and k, build the list of numbers n,n+1..k.
-- Use recursion and the : operator to build the list.

fromTo :: Int -> Int -> [Int]
fromTo n k = if n>k then [] else n : fromTo (n+1) k

-- Ex 13: given i, build the list of sums [1, 1+2, 1+2+3, .., 1+2+..+i]
--
-- Ps. you'll probably need a recursive helper function

sums :: Int -> [Int]
sums i = go 1 2
 where go acc n = if n>i then [acc] else acc : go (acc+n) (n+1)

-- Ex 14: using list pattern matching and recursion, define a function
-- mylast that returns the last value of the given list. For an empty
-- list, a provided default value is returned.
--
-- Examples:
--   mylast 0 [] ==> 0
--   mylast 0 [1,2,3] ==> 3

mylast :: a -> [a] -> a
mylast def [] = def
mylast def [x] = x
mylast def xs = mylast def (drop 1 xs)

-- Ex 15: define a function that checks if the given list is in
-- increasing order. Use recursion and pattern matching. Don't use any
-- library list functions.

sorted :: [Int] -> Bool
sorted [] = True
sorted [_] = True
sorted (x:y:xs) = if x > y then False else sorted (y:xs)

-- Ex 16: compute the partial sums of the given list like this:
--
--   sumsOf [a,b,c]  ==>  [a,a+b,a+b+c]
--   sumsOf [a,b]    ==>  [a,a+b]
--   sumsOf []       ==>  []

sumsOf :: [Int] -> [Int]
sumsOf xs = go 0 xs
  where go acc (x:xs) = (acc+x) : go (acc+x) xs
        go _   [] = []

-- -- Ex 17: define the function mymaximum that takes a list and a
-- -- comparing function of type a -> a -> Ordering and returns the
-- -- maximum value of the list, according to the comparing function.
-- --
-- -- For an empty list the given default value is returned.
-- --
-- -- Examples:
-- --   mymaximum compare (-1) [] ==> -1
-- --   mymaximum compare (-1) [1,3,2] ==> 3
-- --   let comp 0 0 = EQ
-- --       comp _ 0 = LT
-- --       comp 0 _ = GT
-- --       comp x y = compare x y
-- --   in mymaximum comp 1 [1,4,6,100,0,3]
-- --     ==> 0

-- mymaximum :: (a -> a -> Ordering) -> a -> [a] -> a
-- mymaxiumum _ def [] = def
-- mymaximum cmp def xs = undefined

-- Ex 18: define a version of map that takes a two-argument function
-- and two lists. Example:
--   map2 f [x,y,z,w] [a,b,c]  ==> [f x a, f y b, f z c]
--
-- Use recursion and pattern matching.
--
-- Ps. this function is in the Haskell Prelude but under a different
-- name.

map2 :: (a -> b -> c) -> [a] -> [b] -> [c]
map2 f (a:as) (b:bs) = f a b : map2 f as bs
map2 f _ _ = []

-- Ex 19: in this exercise you get to implement an interpreter for a
-- simple language. The language controls two counters, A and B, and
-- has the following commands:
--
-- incA -- increment counter A by one
-- incB -- likewise for B
-- decA -- decrement counter A by one
-- decB -- likewise for B
-- printA -- print value in counter A
-- printB -- print value in counter B
--
-- The interpreter will be a function of type [String] -> [String].
-- Its input is a list of commands, and its output is a list of the
-- results of the print commands in the input.
--
-- Both counters should start at 0.
--
-- Examples:
--
-- interpreter ["incA","incA","incA","printA","decA","printA"] ==> ["3","2"]
-- interpreter ["incA","incB","incB","printA","printB"] ==> ["1","2"]
--
-- Surprise! after you've implemented the function, try running this in GHCi:
--     interact (unlines . interpreter . lines)
-- after this you can enter commands on separate lines and see the
-- responses to them
--
-- Unfortunately the surprise might not work if you've implemented
-- your interpreter correctly but weirdly :(

interpreter :: [String] -> [String]
interpreter commands = undefined

-- Ex 20: write a function that finds the n first squares (numbers of
-- the form x*x) that start and end with the same digit.
--
-- Example: squares 9 ==> [1,4,9,121,484,676,1521,1681,4624]
--
-- Remember, the function show transforms a number to a string.

squares :: Int -> [Integer]
squares n = take n . filter (\x -> head (show x) == last (show x)) $ map (\x -> x*x) [1..]
