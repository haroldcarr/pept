module Main where

import Lib

main :: IO ()
main =
    let c = ContactInfo { address       = "localhost"
                        , msgDispatcher = MsgDispatcher { sendMD = \x -> putStrLn (body x) }
                        , connection    = Connection    { sendC  = \x -> putStrLn (body x) }
                        , encoder       = Encoder { encodeAndSend = \mi conn -> (sendC conn) mi }
                        }
        d = createDelegate [c]
        m = MsgInfo { body = "my message body" }
    in (sendD d) m
