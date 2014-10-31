module Data.Bimonad

import Data.Biapplicative

infixl 4 >>==

||| Bimonads
||| @p the action of the first bifunctor component on pairs of objects
||| @q the action of the second bifunctor component on pairs of objects
class (Biapplicative p, Biapplicative q) =>
      Bimonad (p : Type -> Type -> Type) (q : Type -> Type -> Type) where

  ||| The equivalent of join for standard monads
  bijoin : (p (p a b) (q a b), q (p a b) (q a b)) -> (p a b, q a b)
  bijoin = flip (>>==) (id, id)

  ||| Like the standard monadic bind operator
  (>>==) : (p a b, q a b) -> ((a -> p c d), (b -> q c d)) -> (p c d, q c d)
  (pab, qab) >>== (p, q) = bijoin ((bimap p q, bimap p q) <<*>> (pab, qab))

||| The equivalent of unit for standard monads
biunit : Bimonad p q => a -> b -> (p a b, q a b)
biunit a b = (bipure a b, bipure a b)

instance Bimonad Pair Pair where
  bijoin = bimap fst snd