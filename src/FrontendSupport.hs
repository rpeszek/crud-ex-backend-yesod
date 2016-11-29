module FrontendSupport (EmbeddedElm (..)) where 

import ClassyPrelude.Yesod


data EmbeddedElm = EmbeddedElm {
    programName :: Text
  , elmDivId :: Text
 } deriving (Show)
