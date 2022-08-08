### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 90d20dcf-c07d-40df-9acd-cb11cf5fc83b
using OnlineStats

# ╔═╡ 251bea71-7aee-4a65-b668-b87946d3bf1e
using CSV

# ╔═╡ cacfbea3-1c2f-4723-84af-a92463fbed12
begin
	using PlutoUI
	
	function highlight(text)
		HTML("""<div class='highlight' style="border-radius:6px;background:#15803d;color:#dcfce7;padding: 10px;">$(repr("text/html", text))</div>""")
	end
	
	
	# Use San-serif fonts
	setup = HTML("""
	$(repr("text/html", PlutoUI.TableOfContents(depth=2)))
	<style>
	pluto-output {
		font-family: Arial, Helvetica, sans-serif;
	}
	pluto-output h1 {
	    background:#7e22ce;
	    color:#e9d5ff;
	    border-radius: 4px;
	    padding: 4px;
	    padding-left: 10px;
	}
	pluto-output h2 {
	    background:#1e40af;
	    color:#bfdbfe;
	    border-radius: 4px;
	    padding: 4px;
	    padding-left: 10px;
	}
	.highlight h1, .highlight h2, .highlight h3, .highlight h4, .highlight h5 {
		color:#dcfce7 !important; 
	}
	.highlight code {
		color: #15803d;
		margin: 1px;
	}
	code, blockquote, pre {
		border-radius: 2px !important;
	}
	</style>
	<hr />
	<span>Notebook setup</span>
	""")
end

# ╔═╡ 5122bbd6-0e20-11ed-3679-ef57e274ae96
md"""
# Big Data

"""

# ╔═╡ dbd52e17-daba-4a90-8f85-328512881512
highlight(md"""
- **Big data** is an overloaded term.
- Here we mean any dataset that requires you to change how you analyze it due to its size.
""")

# ╔═╡ 1c7e5d60-b1db-4c7f-b937-b2d9461fcb46
md"# OnlineStats.jl"

# ╔═╡ e0137602-cfc6-4cd2-a285-398efbca423a
md"""
**OnlineStats** does statistics and data visualization for big/streaming data via *online algorithms*. Each algorithm:

1. processes data one observation at a time.
2. uses O(1) memory.
"""

# ╔═╡ d85317cc-8757-4063-9d17-52022e33c1c3
md"""
- Here, our usage of *online* predates the internet.  
- It refers to an algorithm that operates on its input piece by piece instead of all at once.
"""

# ╔═╡ 3aaaab7d-8a60-4fe7-8e96-3ba137e33a20
md"""
### Example

- Offline:

```math
\bar x_n = \frac{1}{n}\sum_{i=1}^nx_i
```

- Online:

```math
\bar x_n = \left(1-\frac 1 n \right) x_n + \frac 1 n \bar x_{n-1}
```
"""

# ╔═╡ 28bec841-eff6-4625-8708-272da0b0546a
highlight(md"""
- The above example is trivial, but many methods are not!
- Some things (e.g. logistic regression) are *impossible* to calculate exactly.
""")

# ╔═╡ 31aa5807-3b6a-44e7-b424-3323cd2fe007
md"""
## OnlineStats Features

- **Online updating** for a wide variety of statistics, models, and data visualizations.
- **Parallel computing** primitives.
- **Customizable weighting** to give newer observations higher influence over the value.
- **Extendable** interface.

"""

# ╔═╡ fbd78b01-2224-47ba-b0f9-104d0fd1fbb0
md"## Online Updating with `fit!`"

# ╔═╡ b1e1be75-a556-4a39-bd04-30c886d44b45
highlight(md"""
- Stats are parameterized by the *type of a single observation*.
""")

# ╔═╡ 125863fa-b9cd-4d28-a085-b0e910f4f3ed
supertype(Mean)

# ╔═╡ e9fad45c-8f04-42f3-b13c-b040f150aebc
highlight(md"""
- Calling `fit!(stat::OnlineStat{T}, data::T)` will update the stat with your single observation of `data`.
""")

# ╔═╡ d81285d8-fb7e-4d07-a1c0-446be18581b0
fit!(Mean(), 1)

# ╔═╡ 63fed35f-ad07-4c27-ad94-23a921e57d77
highlight(md"""
- If `!(data <: T)`, then OnlineStats will iterate through `data` and `fit!` each item.
""")

# ╔═╡ 9d60fe20-6a28-42e7-b21a-f9ed134b9662
# Provided data was not a `Number`, so OnlineStats `fit!`s each element
fit!(Mean(), 1:10)

# ╔═╡ 61f22cf5-d04b-46b3-9bfc-e0112297a1d8
md"## Big CSVs"

# ╔═╡ 394d8a99-4ed1-4049-ab87-73096a928c82
md"""
- In a previous notebook, we used `CSV.File` to load a CSV file.
- Here we will use `CSV.Rows` to *iterate* over the rows in a CSV file one row at a time.
"""

# ╔═╡ e7075d1a-bbf7-4f06-b7d2-834b69a35ba8
md"## Parallel Computation with `merge!`"

# ╔═╡ 274a8c69-74cd-400e-9b99-aaf4fbcbfaa0
md"- *Most* stats can be `merge!`-ed together."

# ╔═╡ 308a3198-1f08-4f1f-8ec4-d9ed95c9e588
let
	a, b = Mean(), Mean()
	
	fit!(a, 1:3)
	fit!(b, 3:5)
	
	merge!(a, b)
end

# ╔═╡ 24b7ab7e-c7d2-40b0-8022-31a06b32680e
html"<img src='https://user-images.githubusercontent.com/8075494/57345083-95079780-7117-11e9-81bf-71b0469f04c7.png' style='height:400px; background: lightgray; border-radius: 4px;'/>"

# ╔═╡ 220cbf25-d8b5-430d-87c1-68abe057b444
md"# FileTrees.jl"

# ╔═╡ 26eb35c0-d6a5-4930-99d7-e4fa3f22429d
highlight(md"""
- Spiritual successor of **JuliaDB**.
""")

# ╔═╡ 9e5369f5-123b-4556-bb47-1d3d4d946614
md"# Types of Parallelism"

# ╔═╡ aeb08674-edb8-4bd1-8755-1b7468022842
md"""
- A great resource: ["A quick introduction to data parallelism in Julia" by Takafumi Arakaki (`@tkf` on GitHub)](https://juliafolds.github.io/data-parallelism/tutorials/quick-introduction/)
"""

# ╔═╡ e1de37c6-c65c-41fa-9f1e-5b118cbca8a4
md"""
## Multi-threading
"""

# ╔═╡ 0c9f9663-cf9b-4b57-ae4a-2fa76f8cf7a7
Threads.nthreads()

# ╔═╡ 978c42dd-7986-4886-a97b-efe639aae0f8
md"## Distributed Computing"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
OnlineStats = "a15396b6-48d5-5d58-9928-6d29437db91e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CSV = "~0.10.4"
OnlineStats = "~1.5.13"
PlutoUI = "~0.7.39"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.3"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.AbstractTrees]]
git-tree-sha1 = "03e0550477d86222521d254b741d470ba17ea0b5"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.3.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings"]
git-tree-sha1 = "873fb188a4b9d76549b81465b1f75c82aaf59238"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.4"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "80ca332f6dcb2508adba68f22f551adb2d00a624"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.3"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "924cdca592bc16f14d2f7006754a621735280b74"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.1.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "5158c2b41018c5f7eb1470d558127ac274eca0c9"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.1"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FilePathsBase]]
deps = ["Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "618835ab81e4a40acf215c98768978d82abc5d97"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.16"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "d19f9edd8c34760dca2de2b503f969d8700ed288"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.1.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "b3364212fb5d870f724876ffcd34dd8ec6d98918"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.7"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "361c2b088575b07946508f135ac556751240091c"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.17"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OnlineStats]]
deps = ["AbstractTrees", "Dates", "LinearAlgebra", "OnlineStatsBase", "OrderedCollections", "Random", "RecipesBase", "Statistics", "StatsBase"]
git-tree-sha1 = "78feae582915781a235912de43280f98e6962a78"
uuid = "a15396b6-48d5-5d58-9928-6d29437db91e"
version = "1.5.13"

[[deps.OnlineStatsBase]]
deps = ["AbstractTrees", "Dates", "LinearAlgebra", "OrderedCollections", "Statistics", "StatsBase"]
git-tree-sha1 = "287bd0f7ee1cc2a73f08057a7a6fcfe0c23fe4b0"
uuid = "925886fa-5bf2-5e8e-b522-a9147a512338"
version = "1.4.9"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "0044b23da09b5608b4ecacb4e5e6c6332f833a7e"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "db8481cf5d6278a121184809e9eb1628943c7704"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.13"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─5122bbd6-0e20-11ed-3679-ef57e274ae96
# ╟─dbd52e17-daba-4a90-8f85-328512881512
# ╟─1c7e5d60-b1db-4c7f-b937-b2d9461fcb46
# ╠═90d20dcf-c07d-40df-9acd-cb11cf5fc83b
# ╟─e0137602-cfc6-4cd2-a285-398efbca423a
# ╟─d85317cc-8757-4063-9d17-52022e33c1c3
# ╟─3aaaab7d-8a60-4fe7-8e96-3ba137e33a20
# ╟─28bec841-eff6-4625-8708-272da0b0546a
# ╟─31aa5807-3b6a-44e7-b424-3323cd2fe007
# ╟─fbd78b01-2224-47ba-b0f9-104d0fd1fbb0
# ╟─b1e1be75-a556-4a39-bd04-30c886d44b45
# ╠═125863fa-b9cd-4d28-a085-b0e910f4f3ed
# ╟─e9fad45c-8f04-42f3-b13c-b040f150aebc
# ╠═d81285d8-fb7e-4d07-a1c0-446be18581b0
# ╟─63fed35f-ad07-4c27-ad94-23a921e57d77
# ╠═9d60fe20-6a28-42e7-b21a-f9ed134b9662
# ╟─61f22cf5-d04b-46b3-9bfc-e0112297a1d8
# ╠═251bea71-7aee-4a65-b668-b87946d3bf1e
# ╟─394d8a99-4ed1-4049-ab87-73096a928c82
# ╟─e7075d1a-bbf7-4f06-b7d2-834b69a35ba8
# ╟─274a8c69-74cd-400e-9b99-aaf4fbcbfaa0
# ╠═308a3198-1f08-4f1f-8ec4-d9ed95c9e588
# ╟─24b7ab7e-c7d2-40b0-8022-31a06b32680e
# ╟─220cbf25-d8b5-430d-87c1-68abe057b444
# ╟─26eb35c0-d6a5-4930-99d7-e4fa3f22429d
# ╟─9e5369f5-123b-4556-bb47-1d3d4d946614
# ╟─aeb08674-edb8-4bd1-8755-1b7468022842
# ╟─e1de37c6-c65c-41fa-9f1e-5b118cbca8a4
# ╠═0c9f9663-cf9b-4b57-ae4a-2fa76f8cf7a7
# ╟─978c42dd-7986-4886-a97b-efe639aae0f8
# ╟─cacfbea3-1c2f-4723-84af-a92463fbed12
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
