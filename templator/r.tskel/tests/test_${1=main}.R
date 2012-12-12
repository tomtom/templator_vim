<+if(get(b:templator_args, "runit", 0))+>
test.<+call:get(b:templator_args, "1", "main")+> <- function() {
    <+CURSOR+>
}
<+else+>
test_that("<+call:get(b:templator_args, "1", "main")+>", {
    # expect_that(observed, expected)

    <+CURSOR+>

})
<+endif+>

