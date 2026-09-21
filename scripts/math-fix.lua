-- math-fix.lua
-- Pandoc Lua filter that wraps LaTeX-like content in table cells
-- and inline elements with $...$ math delimiters.

local function looks_like_math(s)
  if s == nil or s == "" then return false end
  -- Already has math delimiters
  if s:find("%$") then return false end
  -- Contains LaTeX command
  if s:find("\\[a-zA-Z]+") then return true end
  -- Contains greek unicode
  if s:find("[α-ωΑ-Ωσ τ π Δ η μ λ θ ω φ ε β α]") then return true end
  -- Contains subscript/superscript pattern
  if s:find("_[%{%w]") or s:find("%^[%{%w]") then return true end
  return false
end

local function strip_outer_parens(s)
  s = s:gsub("^%s*%(%s*", "")
  s = s:gsub("%s*%)%s*$", "")
  return s
end

function Inlines(inlines)
  for i, il in ipairs(inlines) do
    if il.t == "Str" then
      local s = il.text
      if looks_like_math(s) then
        -- Replace Str with Math inline
        local content = strip_outer_parens(s)
        inlines[i] = pandoc.Math("InlineMath", content)
      end
    end
  end
  return inlines
end