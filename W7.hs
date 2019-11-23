module W7 where

import Data.List
import Control.Monad.State

-- Week 7: recap

-- Ex 1: implement the function pyramid that draws a pyramid like this:
--
--      *
--     ***
--    *****
--   *******
--  *********
-- ***********
--
-- The function is given the height of the pyramid as its argument.
--
-- Examples:
--   pyramidi 1 ==> "*\n"
--   pyramidi 2 ==> " *\n***\n"
--   pyramidi 3 ==> "  *\n ***\n*****\n"
--
-- PS. you can test the the function like this in ghci: putStr (pyramidi 5)

pyramid :: Int -> String
pyramid n = undefined

-- Ex 2: collect every second element from the given list.
--
-- DO NOT use list functions, only pattern matching and recursion.
--
-- Examples:
--  everySecond [1,2,3,4,5]
--    ==> [1,3,5]
--  everySecond [0,7,8,1,4,2]
--    ==> [0,8,4]
--  everySecond []
--    ==> []

everySecond :: [a] -> [a]
everySecond xs = undefined

-- Ex 3: given a list, return a pair of functions (get,wrap) such that
--   * get i -- returns element i of the list
--   * query x -- returns True if x is contained in the list
--
-- Example:
--  let (get,query) = wrap [5,6,7] in (get 0, query 6, get 2, query 2)
--    ==> (5,True,7,False)

wrap :: Eq a => [a] -> (Int -> a, a -> Bool)
wrap xs = undefined

-- Tehtävä 4: Toteuta funktio nousevat, joka pilkkoo lukulistan
-- (aidosti) nouseviin pätkiin.
--
-- Saat käyttää kaikkia standardikirjaston listafunktioita.
--
-- Esimerkkejä:

-- Ex 4: split the given list into (monotonically) increasing pieces.
--
-- Feel free to use any list functions.
--
-- Examples:
--  increasings [1,2,3] ==> [[1,2,3]]
--  increasings [1,1] ==> [[1],[1]]
--  increasings [4,7,9,3,6,1,2,2,5,8,0]
--    ==> [[4,7,9],[3,6],[1,2],[2,5,8],[0]]

increasings :: [Int] -> [[Int]]
increasings xs = undefined

-- Ex 5: define a datatype Student that holds three pieces of
-- information about a student: a name (a String), a student number (a
-- String) and points (Int).
--
-- Also define the functions:
--   * newStudent name number -- returns a student with the given name
--                               and number and 0 points
--   * getName s -- returns the name of s
--   * getNumber s -- returns the student number of s
--   * getPoints s -- returns the points of s
--   * addPoints i s -- adds i points to s. If i is negative, does nothing.
--
-- Examples:
--  getName $ newStudent "frank" "0123"
--    ==> "frank"
--  getNumber $ newStudent "frank" "0123"
--    ==> "0123"
--  getPoints $ newStudent "frank" "0123"
--    ==> 0
--  getPoints $ addPoints 100 $ addPoints 100 $ newStudent "frank" "0123"
--    ==> 200
--  getPoints $ addPoints (-1000) $ newStudent "x" "0"
--    ==> 0

data Student = StudentUndefined

newStudent :: String -> String -> Student
newStudent nam num = undefined

getName :: Student -> String
getName s = undefined

getNumber :: Student -> String
getNumber s = undefined

getPoints :: Student -> Int
getPoints s = undefined

addPoints :: Int -> Student -> Student
addPoints x s = undefined

-- Ex 6: define a type Tree23 that represents a tree where each
-- (internal) node has 2 or 3 children.
--
-- The nodes don't need to contain any additional fields
--
-- Define the functions treeHeight and treeSize that compute the
-- height and size of a Tree23.
--
-- To facilitate testing, also define the functions node2 and node3
-- that create 2- and 3- child nodes, and the value leaf that
-- represents a leaf.
--
-- PS. Leave the "deriving Show" line intact because the tests want to
-- print out trees

data Tree23 = Undefined
  deriving Show

leaf :: Tree23
leaf = undefined
node2 :: Tree23 -> Tree23 -> Tree23
node2 = undefined
node3 :: Tree23 -> Tree23 -> Tree23 -> Tree23
node3 = undefined

treeHeight :: Tree23 -> Int
treeHeight t = undefined

treeSize :: Tree23 -> Int
treeSize t = undefined

-- Ex 7: define a type MyString that represents a string and Eq and
-- Ord instances for it.
--
-- Also define the functions fromString and toString that convert
-- from/to String.
--
-- The Ord MyString instance should order the strings in
-- _lexicographic_ order. This means shorter strings come before
-- longer strings, and strings of the same length come in alphabetic
-- order.
--
-- You're free to choose the implmenetation of MyString as you wish.
--
-- Examples:
--
-- fromString "xyz" == fromString "xyz"          ==> True
-- fromString "xyz" == fromString "xyw"          ==> False
--
-- compare (fromString "abc") (fromString "ab")  ==> GT
-- compare (fromString "abc") (fromString "abd") ==> LT

data MyString = MyStringUndefined

fromString :: String -> MyString
fromString s = undefined
toString :: MyString -> String
toString ms = undefined

instance Eq MyString where
  (==) = error "implement me"

instance Ord MyString where
  compare = error "implement me"

-- Ex 8: below you'll find a type Expr that represents arithmetic
-- expressions. For instance (1+2)/3+4 would be represented as
--   Plus (Div (Plus (Constant 1) (Constant 2)) (Constant 3)) (Constant 4)
--
-- Implement the function safeEval :: Expr -> Maybe Int that computes
-- the value of the given arithmetic expression. safeEval should
-- return Nothing if a division by zero occurs somewhere along the
-- way.
--
-- Hint: the Maybe-monad
--
-- Examples:
--   safeEval (Plus (Constant 1) (Constant 1))
--     ==> Just 2
--   safeEval (Div (Constant 6) (Constant 2))
--     ==> Just 3
--   safeEval (Div (Constant 6) (Constant 0))
--     ==> Nothing
--   safeEval (Plus (Constant 1) (Div (Constant 8) (Plus (Constant 2) (Constant (-2)))))
--     ==> Nothing

data Expr = Constant Int | Plus Expr Expr | Div Expr Expr
  deriving Show

safeEval :: Expr -> Maybe Int
safeEval e = undefined

-- Ex 9: implement the function test that gets a list of monadic
-- predicates (of type Monad m => a -> m Bool) and a value (of type
-- a). The predicates should be run on the value until a predicate
-- that returns False is found.
--
-- test should return False if one of the predicates returns False, or
-- True if all of the predicates passed.
--
-- Examples:
--
-- Simple Maybe-tests:
--  test [test1 2, test1 3, test1 5] 7
--   ==> Just True
--  test [test1 2, test1 3, test1 5] 4
--   ==> Just False
--  test [test1 2, test1 3, failTest] 4
--   ==> Nothing
--  test [test1 2, test1 3, failTest] 1
--   ==> Just False
--
-- Keeping track of tests run using State:
--  runState (test [test2 4, test2 8, test2 10] 11) []
--   ==> (True,[10,8,4])
--  runState (test [test2 4, test2 8, test2 10] 5) []
--   ==> (False,[8,4])
--  runState (test [test2 4, test2 8, test2 10] 0) []
--   ==> (False,[4])

test1 :: Int -> Int -> Maybe Bool
test1 k x = Just (x>k)

failTest :: Int -> Maybe Bool
failTest x = Nothing

test2 :: Int -> Int -> State [Int] Bool
test2 k x = do modify (k:)
               return (x>k)

test :: Monad m => [a -> m Bool] -> a -> m Bool
test ts x = undefined

-- Ex 10: using the State monad, create a state with the elements that
-- occur in the given list an _odd_ number of times.
--
-- The order of the list doesn't matter.
--
-- Examples:
--  runState (odds [1,2,3,1,2,1]) []
--    ==> ((),[1,3])
--  runState (odds [1,2,3,1,2,3,1,2,3]) []
--    ==> ((),[3,2,1])

odds :: Eq a => [a] -> State [a] ()
odds xs = undefined
