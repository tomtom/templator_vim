
# project.dir <- normalizePath(dirname(parent.frame(2)$ofile))
project.dir <- normalizePath(dirname((function() {attr(body(sys.function()), "srcfile")})()$filename))
source(paste(project.dir, "lib/variables.R", sep = "/"))
source(paste(project.dir, "lib/functions.R", sep = "/"))
source(paste(project.dir, "lib/db.R", sep = "/"))

