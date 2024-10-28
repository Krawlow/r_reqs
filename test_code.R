library(lib1) # nono library(error1)
require(lib2) # this is for something else # or this or """\n"""
lib3::something; library(lib4); require(lib5)
# this is commented library(error2)

"""
hello # this is a comment inside a commented multi line library(error3)
this is a comment inside a commented multi line library(error4)
library(error5)
"""

library(lib6) # nono library(error6)
require(lib7);require(lib8) # this is for
lib9::something_really_weird
# this is commented library(error7)

library(lib10);library(lib11); lib12::function(); # library(error8)