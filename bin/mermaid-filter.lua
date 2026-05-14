-- mermaid-filter.lua
-- Renders ```mermaid code blocks to PNG via mmdc and replaces them with images.
-- Requires mmdc (mermaid-cli) and /etc/mmdc-puppeteer.json in the container.

local counter = 0

local function render_mermaid(code)
    counter = counter + 1
    local tag     = string.format("%d-%d", os.time(), counter)
    local infile  = string.format("/tmp/mermaid-%s.mmd", tag)
    local outfile = string.format("/tmp/mermaid-%s.png", tag)

    local fh = assert(io.open(infile, "w"), "mermaid-filter: cannot write " .. infile)
    fh:write(code)
    fh:close()

    -- -s 3  → 3× pixel density; good enough for print without being enormous.
    -- -b white → white background so it sits cleanly on the page.
    local cmd = string.format(
        "mmdc -i %q -o %q --puppeteerConfigFile /etc/mmdc-puppeteer.json -b white -s 3 2>/dev/null",
        infile, outfile
    )
    local ok = os.execute(cmd)
    os.remove(infile)

    if ok then
        return outfile
    end
    io.stderr:write("[mermaid-filter] rendering failed — leaving source block intact\n")
    return nil
end

function CodeBlock(el)
    if el.classes[1] == "mermaid" then
        local imgfile = render_mermaid(el.text)
        if imgfile then
            -- Scale to the full text-column width in LaTeX; 100% in other formats.
            local width = (FORMAT == "latex" or FORMAT == "pdf") and "\\linewidth" or "100%"
            return pandoc.Para({ pandoc.Image({}, imgfile, "", { width = width }) })
        end
    end
end
