import Megaparsec.Stream
import Megaparsec.MonadParsec

import YatimaStdLib

/-!
# Common token combinators

Simple combinators that are agnostic to the stream they're applied to.
-/

namespace Common

def string [m : Monad M] [a : Alternative M]
           [strm : Stream.Stream S] [mâ : @MonadParsec.MonadParsec M E S m a strm]:
           strm.Tokens â M (strm.Tokens) :=
  fun expected =>
    mâ.tokens E S (fun x y => @BEq.beq (strm.Tokens) (@NEList.BEqOfOrd strm.Tokens strm.ordTokens) x y) expected

-- TODO: Case-insensitive string

end Common
