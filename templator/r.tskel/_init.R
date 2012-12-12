
# project.dir <- normalizePath(dirname(parent.frame(2)$ofile))
project.dir <- normalizePath(dirname((function() {attr(body(sys.function()), "srcfile")})()$filename))
source(file.path(project.dir, "lib", "variables.R"))
source(file.path(project.dir, "lib", "functions.R"))
source(file.path(project.dir, "lib", "db.R"))

