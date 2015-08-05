module Lib
(
  Connection(..)
, ContactInfo(..)
, Delegate(..)
, Encoder(..)
, MsgDispatcher(..)
, MsgInfo(..)
, createDelegate
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
    sendMD :: MsgInfo -> IO ()
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
    let ci = head contactInfoList
        md = msgDispatcher ci
    putStrLn (address ci)
    putStrLn (body msgInfo)
