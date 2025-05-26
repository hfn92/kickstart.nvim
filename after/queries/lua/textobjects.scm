; extends

((string_content) @_start @_end
     (#make-range! "range" @_start @_end)) @c_string.inner

((string) @_start @_end
     (#make-range! "range" @_start @_end)) @c_string.outer

((unary_expression) @_start @_end
     (#make-range! "range" @_start @_end)) @c_expression
