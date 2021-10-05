module ProjectEulerTasks

import HTTP

function taskmetas()
    map(s -> split(s, "##"),
        split(HTTP.get("https://projecteuler.net/minimal=problems").body |> String, "\r\n")
    )[2:end-1] .|> s -> TaskMeta(parse(Int, s[1]), s[2], s[3], s[4], parse(Int, s[5]))
end

struct TaskMeta
    index::Int
    title::String
    created
    updated
    solved::Int
end

link(t::TaskMeta) = "https://projecteuler.net/problem=$(t.index)"
link(i::Integer) = "https://projecteuler.net/problem=$i"

description(t::TaskMeta) = HTTP.get("https://projecteuler.net/minimal=$(t.index)").body |> String |> HTML
description(i::Integer) = HTTP.get("https://projecteuler.net/minimal=$i").body |> String |> HTML

function Base.show(io::IO, ::MIME"text/html", t::TaskMeta)
    print(io, """<h5>Task $(t.index): $(t.title)</h5>
    $(description(t).content)
    <a href='$(link(t))'>link</a>""")
end

function Base.show(io::IO, ::MIME"text/plain", t::TaskMeta)
    print(io, """Task $(t.index): $(t.title)
    $(description(t).content)
    link at: $(link(t))""")
end

export taskmetas, TaskMeta, link, description

end
