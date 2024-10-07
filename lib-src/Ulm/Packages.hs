module Ulm.Packages
  ( readListJson,
    Scope (..),
  )
where

import Elm.Package qualified
import Elm.Version qualified
import Json.Encode ((==>))
import Json.Encode qualified
import Json.String qualified
import Ulm.Deps.Registry qualified
import Ulm.Paths qualified

data Scope = AllKnownVersions | NewestKnownVersion

readListJson :: Scope -> IO Json.Encode.Value
readListJson scope = do
  cache <- Ulm.Paths.getPackageCache
  maybeRegistry <- Ulm.Deps.Registry.read cache
  pure $ case maybeRegistry of
    Just (Ulm.Deps.Registry.Registry _ versions) ->
      Json.Encode.dict
        Elm.Package.toJsonString
        (encodeKnownVersions scope)
        versions
    Nothing ->
      Json.Encode.null

encodeKnownVersions :: Scope -> Ulm.Deps.Registry.KnownVersions -> Json.Encode.Value
encodeKnownVersions scope (Ulm.Deps.Registry.KnownVersions newest others) =
  case scope of
    AllKnownVersions ->
      Json.Encode.object
        [ "newest" ==> Elm.Version.encode newest,
          "others" ==> Json.Encode.list Elm.Version.encode others
        ]
    NewestKnownVersion ->
      Elm.Version.encode newest
