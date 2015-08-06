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
delegateSend contactInfoList msgInfo = do
    -- 5: pick ContactInfo
    let ci = head contactInfoList
        -- 6: uses dispatcher that knows protocol
        md = msgDispatcher ci
    sendMD md ci msgInfo

------------------------------------------------------------------------------

testDispatcher :: MsgDispatcher
testDispatcher  = MsgDispatcher { sendMD = \ci mi -> sendC (connection ci) mi }

testConnection :: Connection
testConnection  = Connection    { sendC  = \mi -> putStrLn (body mi) }

testEncoder    :: Encoder
testEncoder     = Encoder       { encodeAndSend = \mi conn -> (sendC conn) mi }

-- End of file.

