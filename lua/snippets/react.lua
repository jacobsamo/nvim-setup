local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
  -- useState hook
  s("us", {
    t("const ["),
    i(1, "state"),
    t(", set"),
    f(function(args)
      local state = args[1][1]
      return state:sub(1, 1):upper() .. state:sub(2)
    end, { 1 }),
    t("] = useState("),
    i(2, "initialState"),
    t(");"),
    t({ "", "" }),
    i(0),
  }, {
    description = "Creates a useState hook with an initial state.",
  }),

  -- useState hook false
  s("usf", {
    t("const ["),
    i(1, "state"),
    t(", set"),
    i(2, "State"),
    t("] = useState(false);"),
    t({ "", "" }),
    i(0),
  }, {
    description = "Creates a useState hook with false as the initial state.",
  }),

  -- useState hook true
  s("ust", {
    t("const ["),
    i(1, "state"),
    t(", set"),
    i(2, "State"),
    t("] = useState(true);"),
    t({ "", "" }),
    i(0),
  }, {
    description = "Creates a useState hook with true as the initial state.",
  }),

  -- useEffect hook
  s("uf", {
    t("useEffect(() => {"),
    t({ "", "  " }),
    i(1),
    t({ "", "}, [" }),
    i(2),
    t("]);"),
    t({ "", "" }),
    i(0),
  }, {
    description = "Creates a useEffect hook.",
  }),

  -- console log
  s("cl", {
    t("console.log('"),
    i(1),
    t("');"),
    i(0),
  }),

  -- console log var
  s("cls", {
    t("console.log('"),
    i(1, "message"),
    t("', "),
    i(2, "variable"),
    t(");"),
    i(0),
  }),

  -- console.log template literal var
  s("cl,", {
    t("console.log(`"),
    i(1, "title/message"),
    t(" ${"),
    i(2, "variable"),
    t("}`);"),
    i(0),
  }),
}
