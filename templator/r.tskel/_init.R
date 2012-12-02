
# project.dir <- normalizePath(dirname(parent.frame(2)$ofile))
project.dir <- normalizePath(dirname((function() {attr(body(sys.function()), "srcfile")})()$filename))
source("_variables.R")
source("_functions.R")
source("_db.R")

