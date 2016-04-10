{-
Created       : 2015 Aug 05 (Thu) 20:18:19 by Harold Carr.
Last Modified : 2016 Apr 09 (Sat) 18:17:31 by Harold Carr.
-}

module Lib
(
  Connection(..)
, ContactInfo(..)
, Delegate(..)
, Encoder(..)
, MsgDispatcher(..)
, MsgInfo(..)
, createDelegate
, testConnection
, testDispatcher
, testEncoder
)
where

data Delegate = Delegate {
    contactInfoList :: [ContactInfo]
  , sendD           :: MsgInfo -> IO ()
}

data MsgInfo = MsgInfo {
    body :: String
}

data ContactInfo = ContactInfo {
    address       :: String
  , msgDispatcher :: MsgDispatcher
  , connection    :: Connection
  , encoder       :: Encoder
}

data MsgDispatcher = MsgDispatcher {
    sendMD :: ContactInfo -> MsgInfo -> IO ()
}

data Encoder = Encoder {
    encodeAndSend :: MsgInfo -> Connection -> IO ()
}

data Connection = Connection {
    sendC :: MsgInfo -> IO ()
}

createDelegate :: [ContactInfo] -> Delegate
createDelegate contactInfo =
  Delegate { contactInfoList = contactInfo
           , sendD           = delegateSend contactInfo
           }

delegateSend :: [ContactInfo] -> MsgInfo -> IO ()
delegateSend cInfoList msgInfo = do
    -- 5: pick ContactInfo
    let ci = head cInfoList
        -- 6: use dispatcher that knows protocol
        md = msgDispatcher ci
    sendMD md ci msgInfo

------------------------------------------------------------------------------

testDispatcher :: MsgDispatcher
testDispatcher  = MsgDispatcher {
    sendMD = \ci mi ->
        let enco = encoder ci
            conn = connection ci
        in encodeAndSend enco mi conn
}

testEncoder    :: Encoder
testEncoder     = Encoder       { encodeAndSend = flip sendC }

testConnection :: Connection
testConnection  = Connection    { sendC  = putStrLn . body }

-- End of file.
