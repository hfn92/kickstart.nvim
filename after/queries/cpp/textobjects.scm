; extends

((string_content) @_start @_end
     (#make-range! "range" @_start @_end)) @c_string.inner

((raw_string_content) @_start @_end
     (#make-range! "range" @_start @_end)) @c_string.inner

((string_literal) @_start @_end
     (#make-range! "range" @_start @_end)) @c.string.outer

((raw_string_literal) @_start @_end
     (#make-range! "range" @_start @_end)) @c.string.outer

((unary_expression) @_start @_end
     (#make-range! "range" @_start @_end)) @c_expression

((call_expression) @_start @_end
     (#make-range! "range" @_start @_end)) @c_expression

((binary_expression) @_start @_end
     (#make-range! "range" @_start @_end)) @c_expression
