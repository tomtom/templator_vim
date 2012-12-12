source("_init.R")

<+if(get(b:templator_args, "runit", 0))+>
library("RUnit")

test.<+call:get(b:templator_args, "1", "main")+>.suite <- defineTestSuite("<+call:get(b:templator_args, "1", "main")+>",
                              dirs = file.path("tests"),
                              testFileRegexp = '^test_<+call:get(b:templator_args, "1", "main")+>(_.*?)?\\.R$')
 
test.<+call:get(b:templator_args, "1", "main")+>.result <- runTestSuite(test.<+call:get(b:templator_args, "1", "main")+>.suite)
 
printTextProtocol(test.<+call:get(b:templator_args, "1", "main")+>.result)
<+else+>
library("testthat")

test_dir("tests", reporter = "Summary")
<+endif+>

