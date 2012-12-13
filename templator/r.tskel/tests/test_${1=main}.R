<+if(get(b:templator_args, "runit", 0))+>
test.<+call:get(b:templator_args, "1", "main")+> <- function() {
    <+CURSOR+>
}
<+else+>
context("<+call:get(b:templator_args, "1", "main")+>")

test_that("<+call:get(b:templator_args, "1", "main")+>", {
    # expect_that(observed, expected)

    <+CURSOR+>

})
<+endif+>

