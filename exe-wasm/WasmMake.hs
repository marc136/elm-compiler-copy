module WasmMake where

import Data.ByteString.Builder qualified
import Data.ByteString.Lazy qualified
import Data.ByteString.Lazy.UTF8 qualified -- from utf8-string
import Data.ByteString.UTF8 qualified as BSU -- from utf8-string
import Debug.Trace
-- See https://gitlab.haskell.org/ghc/ghc/-/commit/317a915bc46fee2c824d595b0d618057bf7fbbf1#82b5a034883a3ede9540d6423738da627660f860
import GHC.Wasm.Prim qualified as Wasm
import Json.Encode ((==>))
import Json.Encode qualified
import Ulm.Install qualified
import Ulm.Make qualified
import Ulm.Packages qualified

main :: IO ()
main = mempty

foreign export javascript "wip"
  -- current work-in-progress helper to avoid changing `./ulm.cabal` for every export
  wipJs :: Wasm.JSString -> IO Wasm.JSString

wipJs :: Wasm.JSString -> IO Wasm.JSString
wipJs jsString =
  let -- str = "elm/html"
      -- source = BSU.fromString $ trace "wipJs" $ traceShowId str
      str = Wasm.fromJSString jsString
   in do
        -- TODO
        fmap encodeJson $ Ulm.Packages.readListJson Ulm.Packages.NewestKnownVersion

foreign export javascript "buildArtifacts" buildArtifacts :: IO ()

buildArtifacts = putStrLn "TODO buildArtifacts"

foreign export javascript "getPackages" getPackages :: Wasm.JSString -> IO Wasm.JSString

getPackages :: Wasm.JSString -> IO Wasm.JSString
getPackages scope = do
  case Wasm.fromJSString scope of
    "all" ->
      fmap encodeOk $ Ulm.Packages.readListJson Ulm.Packages.AllKnownVersions
    "newest" ->
      fmap encodeOk $ Ulm.Packages.readListJson Ulm.Packages.NewestKnownVersion
    other ->
      pure $ encodeErrString ("Option '" ++ other ++ "' is not supported.")

foreign export javascript "addPackage" addPackage :: Wasm.JSString -> IO Wasm.JSString

addPackage :: Wasm.JSString -> IO Wasm.JSString
addPackage jsString = do
  let pkg = Wasm.fromJSString jsString
  result <- Ulm.Install.installJson pkg
  pure $ encodeJson result

foreign export javascript "make"
  makeWasm :: Wasm.JSString -> IO Wasm.JSString

makeWasm :: Wasm.JSString -> IO Wasm.JSString
makeWasm filepath = do
  let path = Wasm.fromJSString filepath
  outcome <- Ulm.Make.makeFile path
  pure $ encodeJson $ Ulm.Make.outcomeToJson (BSU.fromString path) outcome

foreign export javascript "compile"
  compileWasm :: Wasm.JSString -> IO Wasm.JSString

compileWasm :: Wasm.JSString -> IO Wasm.JSString
compileWasm jsString =
  let str = Wasm.fromJSString jsString
      source = BSU.fromString $ trace "parsing" $ traceShowId str
   in do
        trace "wrote sample file" $ Data.ByteString.Builder.writeFile "/wasm-can-write" (Data.ByteString.Builder.stringUtf8 "horst")
        outcome <- Ulm.Make.compileThis source
        pure $ encodeJson $ Ulm.Make.outcomeToJson source outcome

-- RESULT HELPERS

encodeOk :: Json.Encode.Value -> Wasm.JSString
encodeOk ok =
  encodeJson $ toOk ok

toOk :: Json.Encode.Value -> Json.Encode.Value
toOk ok =
  Json.Encode.object
    [ "result" ==> Json.Encode.chars "ok",
      "data" ==> ok
    ]

encodeErrString :: [Char] -> Wasm.JSString
encodeErrString chars =
  encodeJson $
    Json.Encode.object
      [ "result" ==> Json.Encode.chars "error",
        "error" ==> Json.Encode.chars chars,
        "data" ==> Json.Encode.null
      ]

encodeJson :: Json.Encode.Value -> Wasm.JSString
encodeJson value =
  builderToJsString $ Json.Encode.encode value

builderToJsString :: Data.ByteString.Builder.Builder -> Wasm.JSString
builderToJsString builder =
  let lazyStr :: Data.ByteString.Lazy.LazyByteString
      lazyStr = Data.ByteString.Builder.toLazyByteString builder
      str :: String
      str = Data.ByteString.Lazy.UTF8.toString lazyStr
   in Wasm.toJSString str
