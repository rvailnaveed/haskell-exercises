module W6 where

import Control.Monad
import Control.Monad.Trans.State
import Data.Char

-- Week 6: Monads
--
-- Monads are a famously hard topic in learning Haskell. My advise is
-- to try different approaches to understanding monads while writing
-- as much code as possible. Merely contemplating various metaphors
-- for monads will not lead to understanding.
--
-- I recommend starting at these exercises only once you've read a bit
-- about monads. The two standard monads the exercises will use are
-- Maybe and State. Maybe is simple enough, but State requires some
-- looking at.
--
-- If you've yet to find a monad guide to your liking, try Learn You A
-- Haskell For Great Good. The monad chapter is here:
--
-- http://learnyouahaskell.com/a-fistful-of-monads
--
-- But you should probably browse through the previous chapter about
-- Functors too. The State monad is introduced a bit later:
--
-- http://learnyouahaskell.com/for-a-few-monads-more#state


-- Ex 1: let's use the Maybe type to talk about computations that can
-- fail. A value of type "a -> Maybe b" takes an argument of type a
-- and can either succesfully return a value of type b, or fail and
-- return Nothing.
--
-- Here is the operator ?> that defines the natural way of chaining
-- computations like this. We get the result of the previous
-- computation (Maybe a) and the next computation (a -> Maybe b) and
-- return the new result (Maybe b):

(?>) :: Maybe a -> (a -> Maybe b) -> Maybe b
Nothing ?> _ = Nothing   -- In case of failure, propagate failure
Just x  ?> f = f x       -- In case of sucess, run the next computation

-- Your task is to help implement the function readName that given a
-- string like "Forename Surname" produces the pair ("Forname",
-- "Surname"). readName should fail (return Nothing) in the following
-- cases:
--
--   1. the input string doesn't contain a space
--   2. one of the names contains numbers
--   3. one of the names doesn't start with a capital letter
--
-- The function readNames has already been implemented using ?>. You
-- need to define the functions split, checkNumber and checkCapitals
-- so that readNames works correctly.

-- DO NOT touch this definition!
readNames :: String -> Maybe (String,String)
readNames s =
  split s
  ?>
  checkNumber
  ?>
  checkCapitals

-- split should split a string into two words. If the input doesn't
-- contain a space, Nothing should be returned
--
-- (NB! There are obviously other corner cases like the inputs " " and
-- "a b c", but you don't need to worry about those here)
split :: String -> Maybe (String,String)
split s = undefined

-- checkNumber should take a pair of two strings and return then
-- unchanged if they don't contain numbers. Otherwise Nothing is
-- returned.
checkNumber :: (String, String) -> Maybe (String, String)
checkNumber (for,sur) = undefined

-- checkCapitals should take a pair of two strings and return them
-- unchanged if both start with a capital letter. Otherwise Nothing is
-- returned.
checkCapitals :: (String, String) -> Maybe (String, String)
checkCapitals (for,sur) = undefined

-- Ex 2: implement a function myTake that works just like take, but
--   1. the arguments are of types Maybe Int and Maybe [a]
--   2. if either of the arguments is Nothing, Nothing is returned
--   3. if the Int is larger than the length of the list, Nothing is returned
--
-- Use the Maybe monad, i.e. the >>= operator or do-notation.
--
-- DO NOT use pattern matching for Maybe.
--
-- Examples:
--  myTake (Just 2) (Just [5,6,7])
--    ==> Just [5,6]
--  myTake Nothing (Just [5,6,7])
--    ==> Nothing
--  myTake (Just 2) Nothing
--    ==> Nothing
--  myTake (Just 4) (Just [5,6,7])
--    ==> Nothing

myTake :: Maybe Int -> Maybe [a] -> Maybe [a]
myTake mi ml = undefined

-- Ex 3: given a list of indices and a list of values, return the sum
-- of the values in the given indices. You should fail if any of the
-- indices is too large or too small.
--
-- Use the Maybe monad, i.e. the >>= operator or do-notation.
--
-- DO NOT use pattern matching for Maybe.
--
-- Hint! implementa a function safeIndex :: [a] -> Int -> Maybe a
--
-- Examples:
--  selectSum [0..10] [4,6,9]
--    Just 19
--  selectSum [0..10] [4,6,9,20]
--    Nothing

selectSum :: Num a => [a] -> [Int] -> Maybe a
selectSum xs is = undefined

-- Ex 4: below you'll find the implementation of a Logger monad and
-- some examples of its use.
--
-- Your task is to implement a function binom that computes binomial
-- coefficients recursively with the following formulae:
--
--   B(n,0) = 1
--   B(0,k) = 0, when k>0
--   B(n,k) = B(n-1,k-1) + B(n-1,k)
--
-- Every call to the function should be logged as "B(n,k)".
-- Invocations should be logged in execution order.
--
-- Examples:
--   binom 0 0 ==> Logger ["B(0,0)"] 1
--   binom 0 7 ==> Logger ["B(0,7)"] 0
--   binom 1 1 ==> Logger ["B(0,0)","B(0,1)","B(1,1)"] 1
--   binom 2 2 ==> Logger ["B(0,0)","B(0,1)","B(1,1)","B(0,1)","B(0,2)","B(1,2)","B(2,2)"] 1

data Logger a = Logger [String] a
  deriving Show

instance Functor Logger where
  fmap f (Logger l a) = Logger l (f a)

instance Monad Logger where
  return x = Logger [] x
  Logger la a >>= f = Logger (la++lb) b
    where Logger lb b = f a

-- disregard this. in recent versions of the Haskell standard library,
-- all Monads must also be Applicative. These exercises don't really
-- cover Applicative.
instance Applicative Logger where
  pure = return
  (<*>) = ap


msg :: String -> Logger ()
msg s = Logger [s] ()

-- An example
multiplyLog :: Int -> Int -> Logger Int
multiplyLog a b = do
  msg ("first arg is " ++ show a)
  msg ("second arg is " ++ show b)
  let ret = a * b
  msg ("returning product " ++ show ret)
  return ret

productLog :: [Int] -> Logger Int
productLog [] = do
  msg "recursion base case"
  return 1

productLog (x:xs) = do
  msg ("head "++show x)
  msg ("recurse on "++show xs)
  productXs <- productLog xs
  multiplyLog x productXs

-- Try running e.g. productLog [1,2,3] in GHCi!

-- Implement this:
binom :: Integer -> Integer -> Logger Integer
binom n k = undefined

-- Ex 5: using the State monad, write the operation update that first
-- multiplies the state by 2 and then adds one to it. The state has
-- type Int.
--
-- Example:
--  runState update 3
--    ==> ((),7)

update :: State Int ()
update = undefined

-- Ex 6: using the State monad, walk through a list and increment the
-- state by one each time a given element is encountered. Additionally
-- you should return the length of the list.
--
-- Do this by implementing a recursive State operation lengthAndCount.
-- Do not use the functions length or filter.
--
-- Example:
--  runState (lengthAndCount True [False,True,False,True,False]) 0
--    ==> (5,2)

lengthAndCount :: Eq a => a -> [a] -> State Int Int
lengthAndCount x ys = undefined

-- Ex 7: using a state of type [(a,Int)] we can keep track of the
-- numbers of occurrences of elements of type a. For instance
-- [('a',1),('x',3)] means that we've seen one 'a' and three 'x's.
--
-- Implement a State monad operation count that registers the
-- occurrence of the given value.
--
-- Examples:
--  runState (count True) []
--    ==> ((),[(True,1)])
--  runState (count 7) []
--    ==> ((),[(7,1)])
--  runState (count 'a') [('a',1),('b',3)]
--    ==> ((),[('a',2),('b',3)])
--
-- PS. Order of the list of pairs doesn't matter

count :: Eq a => a -> State [(a,Int)] ()
count x = return ()

-- Ex 8: given a list of values, replace each value by a number saying
-- which occurrence of the value this was in the list.
--
-- Do this in the State monad, using the operation count you just
-- defined.
--
-- Hint: the function lookup will help
--
-- Examples:
--  runState (occurrences [True,True,True,False,False]) []
--    ==> ([1,2,3,1,2],[(True,3),(False,2)])
--  runState (occurrences [5,5,6,6,5,6,7]) []
--    ==> ([1,2,1,2,3,3,1],[(5,3),(6,3),(7,1)])

occurrences :: (Eq a) => [a] -> State [(a,Int)] [Int]
occurrences xs = undefined

-- Ex 9: implement the function ifM, that takes three monadic
-- operations. If the first of the operations returns True, the second
-- operation should be run. Otherwise the third operation should be
-- run.
--
-- Examples (test is defined below):
--  runState (put 11 >> ifM test (return 'a') (return 'b')) 0
--    ==> ('b',11)
--  runState (put 9 >> ifM test (return 'a') (return 'b')) 0
--    ==> ('a',9)

test :: State Int Bool
test = do
  x <- get
  return (x<10)

ifM :: Monad m => m Bool -> m a -> m a -> m a
ifM opBool opThen opElse = undefined

-- Ex 10: the standard library function Control.Monad.mapM defines a
-- monadic map operation. Some examples of using it (safeDiv is define
-- below):
--
-- mapM (safeDiv 10.0) [1.0,5.0,2.0]  =>  Just [10.0,2.0,5.0]
-- mapM (safeDiv 10.0) [1.0,0.0,2.0]  =>  Nothing
--
-- Your task is to implement the function mapM2 that works like mapM,
-- but there are two lists and the operation takes two arguments. If
-- the lists are of different lists, you can stop processing them once
-- the shorter one ends.
--
-- Examples:
--  mapM2 (\x y -> Just (x+y)) [1,2,3] [6,7]
--    ==> Just [7,9]
--  runState (mapM2 (\x y -> if x then modify (+y) else return () ) [True,False,True] [1,2,4]) 0
--    ==> ([(),(),()],5)

safeDiv :: Double -> Double -> Maybe Double
safeDiv x 0.0 = Nothing
safeDiv x y = Just (x/y)

mapM2 :: Monad m => (a -> b -> m c) -> [a] -> [b] -> m [c]
mapM2 op xs ys = undefined

-- Ex 11: Funnykiztan has cities that are named with by 0..n-1. Some
-- cities are connected by roads. Your task is to find out if you can
-- can get from city A to city B by following the roads.
--
-- The road network is given as an adjacency list, which means a list
-- of lists [[Int]] where the i'th list gives the cities to which city
-- i has a road to.
--
-- For example the road network:
--
-- 0--1
-- |\ |
-- | \|
-- 2--3
--
-- would be represented as:
--  [[1,2,3]
--  ,[0,3]
--  ,[0,3]
--  ,[0,1,2]]
--
-- Below you'll find the function routeExists that solves the task.
-- However a very important piece of the function, the helper function
-- dfs is still unimplemented.
--
-- The function dfs is intended to run a Depth-First Search. If you
-- don't know what this means, have a look in wikipedia.
--
-- Simply put, dfs uses roads to travel from city to city using roads,
-- using a state of type [Int] to keep track of which cities have been
-- visited. This is important because the road network will have
-- cycles.
--
-- Examples:
--   routeExists example1 0 2  ==> True
--   routeExists example2 0 2  ==> True
--   routeExists example2 3 5  ==> False
--   runState (dfs example2 0) []  ==> ((),[2,3,1,0])
-- When 1 and 2 have already been visited, dfs won't proceed to city 3:
--   runState (dfs example1 0) [1,2] ==> ((),[0,1,2])
--
-- A word on tests. The tests first test the function dfs in a couple
-- of simple situations. After this they test the function routeExists
-- more extensively. The tests look at the state produced by dfs but
-- do not care in which order it is.

-- Three cities, each connected to the two others
example1 :: [[Int]]
example1 = [[1,2]
           ,[0,2]
           ,[0,1]]

-- A more two-part network:
--
-- 0 -- 1
-- |    |   4 -- 5
-- |    |
-- 2 -- 3
example2 :: [[Int]]
example2 = [[1,2]
           ,[0,3]
           ,[0,3]
           ,[1,2]
           ,[5]
           ,[4]]

routeExists :: [[Int]] -> Int -> Int -> Bool
routeExists cities i j = j `elem` execState (dfs cities i) []

dfs :: [[Int]] -> Int -> State [Int] ()
dfs cities i = undefined

-- Ex 12: define the function orderedPairs that returns all pairs
-- (i,j) such that i<j and i occurs in the given list before j.
--
-- Use the list monad!
--
-- Examples:
--  orderedPairs [1,3,2,4]
--    ==> [(1,3),(1,2),(1,4),(3,4),(2,4)]
--
-- PS. once again the tests don't care about the order of results

orderedPairs :: [Int] -> [(Int,Int)]
orderedPairs xs = undefined

-- Ex 13: compute all possible sums of elements from the given
-- list. Use the list monad.
--
-- Hint! think about what [True,False] means in the list monad...
--
-- NB! the order of the returned list does not matter and it may
-- contain duplicates.
--
-- Examples:
--   sums []
--     ==> [0]
--   sums [1]
--     ==> [1,0]
--   sums [1,2,4]
--     ==> [7,3,5,1,6,2,4,0]

sums :: [Int] -> [Int]
sums xs = undefined

-- Ex 14: the standard library defines the function
--
--   foldM :: (Monad m) => (a -> b -> m a) -> a -> [b] -> m a
--
-- This function behaves like foldr, but the operation used is
-- monadic. foldM f acc xs works by running f for each element in xs,
-- giving it also the result of the previous invocation of f.
--
-- Your task is to implement the functions f1 and f2 so that the
-- functions sumBounded and sumNotTwice work.

-- sumBounded computes the sum of a list. However if some prefix of
-- the list has a sum of over k, Nothing is returned.
--
-- Examples:
--  sumBounded 5 [1,2,1,-2,3]
--    ==> Just 5
--  sumBounded 5 [1,2,3,1,-2]
--    ==> Nothing
sumBounded :: Int -> [Int] -> Maybe Int
sumBounded k xs = foldM (f1 k) 0 xs

f1 :: Int -> Int -> Int -> Maybe Int
f1 k acc x = undefined

-- sumNotTwice computes the sum of a list, but ignores duplicated
-- elements.
--
-- Examples:
--  sumNotTwice [3,-2,3]
--    ==> 1
--  sumNotTwice [1,2,-2,3]
--    ==> 4
sumNotTwice :: [Int] -> Int
sumNotTwice xs = fst $ runState (foldM f2 0 xs) []

f2 :: Int -> Int -> State [Int] Int
f2 acc x = undefined

-- Ex 15: here is the Result type from last week. Implement a Monad
-- Result instance that behaves roughly like the Monad Maybe instance.
--
-- That is,
--   1. MkResults behave like Just
--   2. If part of computation produces NoResult, the whole computation
--      produces NoResult (just like Nothing)
--   3. Similarly, if we get a Failure "reason" value, the whole
--      computation produces Failure "reason"
--
-- Additionally, the method "fail" of the Monad type class should
-- produce a Failure.
--
-- Examples:
--   MkResult 1 >> Failure "boom" >> MkResult 2
--     ==> Failure "boom"
--   MkResult 1 >> NoResult >> Failure "not reached"
--     ==> NoResult
