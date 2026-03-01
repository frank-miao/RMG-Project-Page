-- wrap-section.lua
-- Wraps Div elements with class "desktop-section" in the standard Bulma
-- section/container/columns/column scaffold so authors don't need to write
-- raw HTML blocks for every content section.
--
-- Usage in .qmd:
--   ::: {.desktop-section}                              -- default: is-max-desktop
--   ::: {.desktop-section container="is-max-widescreen"}
--   ::: {.desktop-section container="is-fluid"}
--   ## My Heading
--   Content here...
--   :::

local close_html = pandoc.RawBlock("html", [[      </div>
    </div>
  </div>
</section>]])

return {
  Div = function(el)
    if el.classes:includes("desktop-section") then
      local container_class = el.attributes["container"] or "is-max-desktop"
      el.classes = el.classes:filter(function(c) return c ~= "desktop-section" end)
      el.attributes["container"] = nil

      local open_html = pandoc.RawBlock("html",
        '<section class="section">\n  <div class="container ' .. container_class .. '">\n    <div class="columns is-centered">\n      <div class="column is-full-width">')

      local blocks = { open_html }
      for _, b in ipairs(el.content) do
        table.insert(blocks, b)
      end
      table.insert(blocks, close_html)
      return blocks
    end
  end
}
