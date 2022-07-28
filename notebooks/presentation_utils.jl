function highlight(text)
	HTML("""<div style="border-radius:10px;background:#15803d;color:#dcfce7;padding: 10px;">$(repr("text/html", text))</div>""")
end


function section(text)
    HTML("""<div style="border-radius:10px;background:#7e22ce;color:#e9d5ff;padding: 10px;">$(repr("text/html", text))</div>""")
end


# Use San-serif fonts
HTML("""
<style>
pluto-output {
	font-family: Arial, Helvetica, sans-serif !important;
}
pluto-output h1 {
    background:#7e22ce;
    color:#e9d5ff;
    border-radius: 4px;
    padding: 4px;
    padding-left: 10px;
}
</style>
""")
