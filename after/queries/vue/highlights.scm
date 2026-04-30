;; extends

((tag_name) @tag.builtin
  (#set! priority 110)
  (#match? @tag.builtin "^[a-z][a-zA-Z0-9]*$")
  (#not-match? @tag.builtin "^(component|transition|teleport|suspense)$"))
