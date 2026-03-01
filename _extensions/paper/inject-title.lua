-- inject-title.lua
-- Replaces {{< paper-title >}} in raw HTML blocks with the document's `title`.
-- Uses a return table so Meta runs before RawBlock.

local title = ""

return {
  {
    Meta = function(meta)
      if meta.title then
        title = pandoc.utils.stringify(meta.title)
      end
    end
  },
  {
    RawBlock = function(el)
      if el.format == "html" and title ~= "" then
        local new_text = el.text:gsub("{%{< paper%-title >}}", title)
        if new_text ~= el.text then
          return pandoc.RawBlock("html", new_text)
        end
      end
    end
  }
}
