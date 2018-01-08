# import ExMetra.Macros

# defprotocol ExMetra.Query do
#   def where(structs, fun)
# end

# defimpl ExMetra.Query, for: List do
#   # def where(structs, fun) when is_ex_metra(structs) and is_function(fun) do
#   #   Enum.filter(structs, fn s -> fun.(s) end)
#   # end
# end