{-# LANGUAGE OverloadedStrings #-}
module Generate.JavaScript.Functions
  ( functions
  )
  where


import qualified Data.ByteString.Builder as B

-- import Text.RawString.QQ (r)

-- FUNCTIONS

-- JS backend does not support TemplateHaskell and QuasiQuotes, need to write it is a multiline string

functions :: B.Builder
functions =
  "\n\n\
  \function F(arity, fun, wrapper) {\n\
  \  wrapper.a = arity;\n\
  \  wrapper.f = fun;\n\
  \  return wrapper;\n\
  \}\n\
  \\n\
  \function F2(fun) {\n\
  \  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })\n\
  \}\n\
  \function F3(fun) {\n\
  \  return F(3, fun, function(a) {\n\
  \    return function(b) { return function(c) { return fun(a, b, c); }; };\n\
  \  });\n\
  \}\n\
  \function F4(fun) {\n\
  \  return F(4, fun, function(a) { return function(b) { return function(c) {\n\
  \    return function(d) { return fun(a, b, c, d); }; }; };\n\
  \  });\n\
  \}\n\
  \function F5(fun) {\n\
  \  return F(5, fun, function(a) { return function(b) { return function(c) {\n\
  \    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };\n\
  \  });\n\
  \}\n\
  \function F6(fun) {\n\
  \  return F(6, fun, function(a) { return function(b) { return function(c) {\n\
  \    return function(d) { return function(e) { return function(f) {\n\
  \    return fun(a, b, c, d, e, f); }; }; }; }; };\n\
  \  });\n\
  \}\n\
  \function F7(fun) {\n\
  \  return F(7, fun, function(a) { return function(b) { return function(c) {\n\
  \    return function(d) { return function(e) { return function(f) {\n\
  \    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };\n\
  \  });\n\
  \}\n\
  \function F8(fun) {\n\
  \  return F(8, fun, function(a) { return function(b) { return function(c) {\n\
  \    return function(d) { return function(e) { return function(f) {\n\
  \    return function(g) { return function(h) {\n\
  \    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };\n\
  \  });\n\
  \}\n\
  \function F9(fun) {\n\
  \  return F(9, fun, function(a) { return function(b) { return function(c) {\n\
  \    return function(d) { return function(e) { return function(f) {\n\
  \    return function(g) { return function(h) { return function(i) {\n\
  \    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };\n\
  \  });\n\
  \}\n\
  \\n\
  \function A2(fun, a, b) {\n\
  \  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);\n\
  \}\n\
  \function A3(fun, a, b, c) {\n\
  \  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);\n\
  \}\n\
  \function A4(fun, a, b, c, d) {\n\
  \  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);\n\
  \}\n\
  \function A5(fun, a, b, c, d, e) {\n\
  \  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);\n\
  \}\n\
  \function A6(fun, a, b, c, d, e, f) {\n\
  \  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);\n\
  \}\n\
  \function A7(fun, a, b, c, d, e, f, g) {\n\
  \  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);\n\
  \}\n\
  \function A8(fun, a, b, c, d, e, f, g, h) {\n\
  \  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);\n\
  \}\n\
  \function A9(fun, a, b, c, d, e, f, g, h, i) {\n\
  \  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);\n\
  \}\n\n"
