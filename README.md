
Backend support for polyglot CRUD examples/experiments. (That currently is only elm 
[crud-ex-frontend-elm](https://github.com/rpeszek/crud-ex-frontend-elm.git)).   

See also my umbrella project: [typesafe-web-polyglot](https://github.com/rpeszek/typesafe-web-polyglot.git).

__GOALS:__
* Uses standard (i.e. scaffolded) Yesod project structure.  
* This is NOT an attempt to integrate Yesod/Julius templates with Elm, not like 
[elm-yesod](https://hackage.haskell.org/package/elm-yesod) 

__TODO List:__  

* Integrate wai-cors middleware instead of hardcoded cors logic
* Improve JSON code
* Improve error messages (duplicate key errors)
* Login/Authorization security
* Support for todo-s listed on the elm project page

__To build:__  
This assumes you have [stack](https://docs.haskellstack.org/en/stable/README/) installed.
```
stack build yesod-bin cabal-install --install-ghc
stack build
```

__To run:__  
Environment variable YESOD_APP_ENV is used to configure simple CORS. That is only needed only when running un-deployed elm in elm-ractor.
```
export YESOD_APP_ENV=DEV
stack exec -- yesod devel
```
