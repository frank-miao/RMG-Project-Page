-- inject-title.lua
-- Replaces {{< paper-title >}} and {{< paper-subtitle >}} in raw HTML blocks
-- with the document's `title` and `description` respectively.
-- Uses a return table so Meta runs before RawBlock.

local title = ""
local subtitle = ""

return {
  {
    Meta = function(meta)
      if meta.title then
        title = pandoc.utils.stringify(meta.title)
      end
      if meta.description then
        subtitle = pandoc.utils.stringify(meta.description)
      end
    end
  },
  {
    RawBlock = function(el)
      if el.format == "html" then
        local new_text = el.text
        if title ~= "" then
          new_text = new_text:gsub("{%{< paper%-title >}}", title)
        end
        if subtitle ~= "" then
          new_text = new_text:gsub("{%{< paper%-subtitle >}}", subtitle)
        end
        if new_text ~= el.text then
          return pandoc.RawBlock("html", new_text)
        end
      end
    end
  }
}
