### A Pluto.jl notebook ###
# v0.17.0

using Markdown
using InteractiveUtils

# ╔═╡ dc9d1ef7-23e2-4bc3-ab47-e9ca80af5811
begin
	using PrettyTables
	using PlutoUI
end

# ╔═╡ bd0378cb-ca70-4803-b5fc-7bd08ad1b9f3
md"""
#### Practice Problem: Multiple Chemical Reactions in a Single CSTR

Component $A$ is converted to $B$ (desired product) and $C$ (undesired product) in single well-mixed continuous stirred tank reactor (CSTR) with a single input and output and the following reaction chemistry: 

$$\begin{eqnarray}
\hat{r}_{1}: A &\rightleftharpoons& B\\
\hat{r}_{2}: A &\rightleftharpoons& C\\
\end{eqnarray}$$

The substrate $A$ (component 1) is supplied to the reactor at 10 mol/hr, where the input stream has a volumetric flow rate of $\dot{F}_{1}$ = 2 L/hr. The fractional conversion of $A$ was measured and found to be equal to 70%. Lastly, the extent of the desired reaction was estimated to $\dot{\epsilon}_{1}$ = 1.5 mol/hr. 

__Assumptions__:
* The CSTR is well-mixed, operating at steady-state, and has a constant volume V = 14L
* The CSTR has a single input stream and a single output stream
* Neither of the chemical reactions occur in the streams
* There is no $B$ or $C$ in the input stream

__Compute__:
* The chemical reaction rate(s) $\hat{r}_{1}$ and $\hat{r}_{2}$
* The mol flow rates of all components in the CSTR exit stream
* If $\hat{r}_{1}$ and $\hat{r}_{2}$ are irreversible, and first-order in $A$, compute the forward rate constants $k_{1}$ and $k_{2}$ for reaction 1 and 2, respectively. 

"""

# ╔═╡ 6b07d7ae-8b5d-4c41-8184-9329cdaa94a6
begin

	# Setup problem parameters -
	F_dot = 2.0 	# units: L/hr
	f1 = 0.70 		# units: dimensionless
	ϵ₁_dot = 1.5 	# units: mol/hr
	n11_dot = 10.0 	# units: mol/hr
	V = 14.0 		# units: L

	# setup stoichiometric matrix for "easy" computation -
	S = [

		# ϵ₁_dot ϵ₂_dot
		-1.0 -1.0 	; # 1 A
		1.0 0.0 	; # 2 B
		0.0 1.0 	; # 3 C
	];

	# setup input flow rate -
	n_dot_in = [
		n11_dot ; 	# 1 A
		0.0 	; 	# 2 B
		0.0 	; 	# 3 C
	];

	# show -
	nothing
end

# ╔═╡ 7e8aaae7-555f-4b70-bae7-4adc1d1c9923
md"""
#### Compute: the chemical reaction rate(s) $\hat{r}_{1}$ and $\hat{r}_{2}$

To compute the reaction rates $\hat{r}_{1}$ and $\hat{r}_{2}$, we first must estimate the open extent for the second reaction $\dot{\epsilon}_{2}$
by relating the $\dot{\epsilon}_{2}$ to the fractional conversion of A. To start, we know that for component $i$ the species mole balance is given by:

$$\dot{n}_{i1} - \dot{n}_{i2} + \sum_{j=1}^{\mathcal{R}}\sigma_{ij}\dot{\epsilon}_{j} = 0$$

where $\epsilon_{j} = \hat{r}_{j}V$. Rearranging the species mole balance for $\dot{n}_{i2}$:

$$\dot{n}_{i2} = \dot{n}_{i1} + \sum_{j=1}^{\mathcal{R}}\sigma_{ij}\dot{\epsilon}_{j}$$

However, the fractional conversion is given by:

$$\dot{n}_{i2} = \dot{n}_{i1} - f_{i}\dot{n}_{i1}$$

Thus, we can eliminate $\dot{n}_{i2}$ from the species mol balance ans solve for the fractional conversion $f_{i}$:

$$f_{i} = -\frac{1}{\dot{n_{i,1}}}\left(\sum_{j=1}^{\mathcal{R}}\sigma_{ij}\dot{\epsilon}_{j}\right)\qquad{i=1}$$

For the currenr problem, we know the fractional concersion of A (i=1), and we have two reactions where $\dot{\epsilon}_{2}$ is known, thus
we can solve for $\dot{\epsilon}_{2}$:

$$\dot{\epsilon}_{2} = \dot{n}_{11}f_{1} - \dot{\epsilon}_{1}$$

Once we have $\dot{\epsilon}_{1}$ and $\dot{\epsilon}_{2}$, we can compute the rates: $\hat{r}_{j}=\dot{\epsilon}_{j}V^{-1}$.

"""

# ╔═╡ fddd2b82-8eba-4517-bdfd-0953bd10c259
begin

	# compute -
	ϵ₂_dot = n11_dot*f1  - ϵ₁_dot;

	# display -
	with_terminal() do
		# compute ϵ₂_dot:
		println("ϵ₂_dot = $(ϵ₂_dot) mol/hr")
	end
end

# ╔═╡ 86964693-9968-4524-a2bc-8c3a8f202cc1
begin

	# compute the rates -
	r1_hat = (1/V)*ϵ₁_dot
	r2_hat = (1/V)*ϵ₂_dot

	# display -
	with_terminal() do
		println("r1_hat = $(r1_hat) mol/L-hr and r2_hat = $(r2_hat) mol/L-hr")
	end
end

# ╔═╡ 34ddef24-462a-4a1d-8a61-9c760f278883
md"""

#### Compute: the mole flow rates of all components in the CSTR exit stream

We know have both $\dot{\epsilon}_{1}$ and $\dot{\epsilon}_{2}$, so we can use the steady-state species mole balance for component $i=1,2,3$

$$\dot{n}_{i1} - \dot{n}_{i2} + \sum_{j=1}^{\mathcal{R}}\sigma_{ij}\dot{\epsilon}_{j} = 0\qquad{i=1,2,3}$$

to compute the composition of the exit stream.

"""

# ╔═╡ fff53850-a627-4349-bef2-c5aaf8828c3d
begin

	# setup extent vector -
	ϵ_vector = [ϵ₁_dot ; ϵ₂_dot];

	# compute n_dot coming out of reactor -
	n_dot_out = n_dot_in + S*ϵ_vector

	# setup data array =
	state_table_array = Array{Any,2}(undef, 3,3)

	# A -
	state_table_array[1,1] = "A"
	state_table_array[1,2] = n_dot_in[1]
	state_table_array[1,3] = n_dot_out[1]

	# B -
	state_table_array[2,1] = "B"
	state_table_array[2,2] = n_dot_in[2]
	state_table_array[2,3] = n_dot_out[2]

	# C -
	state_table_array[3,1] = "C"
	state_table_array[3,2] = n_dot_in[3]
	state_table_array[3,3] = n_dot_out[3]
	
	
	# setup a pretty table =
	# header row -
	state_table_header_row = (["Species","n_dot_in","n_dot_out"],["","mol/hr","mol/hr"]);

	with_terminal() do
		# write the table -
		pretty_table(state_table_array; header=state_table_header_row)
	end
end

# ╔═╡ 8b5a451f-5d31-49f5-91fb-3e24a00b87ac
md"""
#### Compute the forward rate constants $k^{+}_{1}$ and $k^{+}_{2}$

To compute the rate constants, we can solve the rate expression $\hat{r}_{j} = k^{+}_{j}\left[A\right]$ once we have the concentration of A. 
To compute concentration, we know that in stream $s$

$$\left[C_{i,s}\right] = \dot{n}_{i,s}\left(\dot{F}_{s}\right)^{-1}$$

where $\left[C_{i,s}\right]$ denotes the concentration of component $i$ in stream $s$, and $\dot{F}_{s}$ denotes the volumetric flow rate of stream $s$. Because the reactor is well-mixed, and is constant volume, the concentration of $A$ (denoted in index notation as $C_{12}$) is given by:

$$C_{12} = \dot{n}_{12}\left(\dot{F}\right)^{-1}$$

This, the rate constant(s) are given by:

$$k_{j}^{+} = \left(\frac{\dot{F}}{\dot{n}_{12}}\right)\hat{r}_{j}\qquad{j=1,2}$$

"""

# ╔═╡ 86b16793-3647-4bd6-870e-3ca2be3035ae
begin

	# concetration -
	A_concentration = (n_dot_out[1]/F_dot)

	# compute -
	k1f = r1_hat*(1/A_concentration)
	k2f = r2_hat*(1/A_concentration)

	# display -
	with_terminal() do
		println("k1f = $(k1f) 1/hr and k2f = $(k2f) 1/hr")
	end
end

# ╔═╡ 4bab103c-3d4b-11ec-1ceb-9566ca26ce6b
html"""
<style>
main {
    max-width: 1200px;
    width: 85%;
    margin: auto;
    font-family: "Roboto, monospace";
}

a {
    color: blue;
    text-decoration: none;
}

.H1 {
    padding: 0px 30px;
}
</style>"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PrettyTables = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"

[compat]
PlutoUI = "~0.7.19"
PrettyTables = "~1.2.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0bc60e3006ad95b4bb7497698dd7c6d649b9bc06"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "e071adf21e165ea0d904b595544a8e514c8bb42c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.19"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "d940010be611ee9d67064fe559edbb305f8cc0eb"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─bd0378cb-ca70-4803-b5fc-7bd08ad1b9f3
# ╠═6b07d7ae-8b5d-4c41-8184-9329cdaa94a6
# ╟─7e8aaae7-555f-4b70-bae7-4adc1d1c9923
# ╠═fddd2b82-8eba-4517-bdfd-0953bd10c259
# ╠═86964693-9968-4524-a2bc-8c3a8f202cc1
# ╟─34ddef24-462a-4a1d-8a61-9c760f278883
# ╟─fff53850-a627-4349-bef2-c5aaf8828c3d
# ╟─8b5a451f-5d31-49f5-91fb-3e24a00b87ac
# ╠═86b16793-3647-4bd6-870e-3ca2be3035ae
# ╠═dc9d1ef7-23e2-4bc3-ab47-e9ca80af5811
# ╟─4bab103c-3d4b-11ec-1ceb-9566ca26ce6b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
