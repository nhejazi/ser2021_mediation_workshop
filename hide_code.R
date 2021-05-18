# R script to make an HTML header file that will be inserted in every page
# of a bookdown document (using includes: in_header: hide_code.html).
# It adds a hide/show all code button on the Gitbook toolbar and smaller ones
# before each R chunk.

# https://stackoverflow.com/questions/45360998/code-folding-in-bookdown
library(readr)

codejs       = readr::read_lines("js_extras/codefolding.js")
collapsejs   = readr::read_lines("js_extras/collapse.js")
transitionjs = readr::read_lines("js_extras/transition.js")
dropdownjs   = readr::read_lines("js_extras/dropdown.js")
buttonjs     = readr::read_lines("js_extras/codehideall-button.js")
my.css       = readr::read_lines("css/united_button_theme.css")

htmlhead = c(
  paste('
<script>',
paste(transitionjs, collapse = "\n"),
'</script>
<script>',
paste(collapsejs, collapse = "\n"),
'</script>
<script>',
paste(codejs, collapse = "\n"),
'</script>
<script>',
paste(dropdownjs, collapse = "\n"),
'</script>
<style type="text/css">',
paste(my.css, collapse = "\n"),
'</style>
<script>',
paste(buttonjs, collapse = "\n"),
'</script>
<script>
$(document).ready(function () {
  // show code by default. Use "show" === "hide" to hide
  window.initializeCodeFolding("show" === "show");
});
</script>', sep = "\n")
)

readr::write_lines(htmlhead, file = "html_extras/hide_code.html")
