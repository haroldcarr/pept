{-
Created       : 2015 Aug 05 (Thu) 20:18:19 by Harold Carr.
Last Modified : 2015 Aug 06 (Thu) 20:18:37 by Harold Carr.
-}

module Main where

import           Lib

main :: IO ()
main =
    let c = ContactInfo { address       = "localhost"
                        , msgDispatcher = testDispatcher
                        , connection    = testConnection
                        , encoder       = testEncoder
                        }
        -- 1,2,3: getMsgInfo, setData/Metadata
        m = MsgInfo { body = "my message body" }
        d = createDelegate [c]
    -- 4: send on delegate
    in (sendD d) m

-- End of file.
