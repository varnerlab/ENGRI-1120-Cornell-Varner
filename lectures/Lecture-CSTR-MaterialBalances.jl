### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ a3ef3e3e-81ce-4645-b5a4-1e816803a7fc
begin
	using PlutoUI
end

# ╔═╡ 6ab6a977-13ec-412f-b80e-09cd9252624c
md"""
## Material Balances for Single and Multiple Continuous Stirred Tank Reactors (CSTR) 
Continuous stirred tank reactors (CSTR) are one of the two most common types of reactors (the other being tubular or plug-flow reactors) used in chemical engineering processes. In this lecture, we'll use our understanding of the material balances (mass and mol) to write down equations that govern the behavior of these reactors.  

__Objectives__: at the end of this week(ish), you should be able to:
* Formulate the species mole balances for a single CSTR in which up to ℛ chemical reactions in the bulk and $\mathcal{T}$ biological reactions are occurring in the reactor 
* Understand the behavior of a CSTR in terms of the _fractional conversion_ _f_ and time-dependent $\dot{\epsilon}$ of reaction(s)
* Formulate models for the _kinetics_ of chemical reactions
* Formulate the species mole balances for multiple CSTRs in which up to ℛ chemical reactions in the bulk and $\mathcal{T}$ biological reactions are occurring in each reactor

__Assumptions__
* All systems that we consider in the lecture are assumed to be at steady-state
* All liquid phases are assumed to be _ideal_
* All gas phases are assumed to be _ideal_
* All systems that we consider in the lecture are assumed to be _well mixed_

"""

# ╔═╡ 7debf40c-5e61-4ac6-a1d5-4b82927d3dbc
md"""
### Objective 1: Total Mass and Species Balance Equations for a Single CSTR
If we consider a single liquid well-mixed CSTR as our system, then we can use the species mols balances that we have already developed to describe the steady-state behavior of the reactor. The steady-state species mole balance for component $i=1,2,\dots\mathcal{M}$ is given by:

$$\sum_{s=1}^{\mathcal{S}}v_{s}\dot{n}_{is} + \left(\sum_{k=1}^{\mathcal{R}}\sigma_{ik}\hat{r}_{k} + \sum_{j=1}^{\mathcal{T}}\tau_{ij}q_{j}X\right)V = 0$$

where $\dot{n}_{is}$ denotes the flow rate of moles of component _i_ in stream _s_, 
$v_{s}$ denotes the direction parameter of stream _s_, and $\mathcal{S}$ denotes the total number of streams. 
The second set of summations denotes the reaction terms for both bulk-liquid and possible biological reactions, respectively. 
The quantity $\hat{r}_{k}$ denotes the rate per unit volume of chemical reaction _k_ occurring in the bulk fluid, $\tau_{ij}$ denotes the stoichiometric coefficient linking species _i_ with biological reaction _j_, $q_{j}$ denotes the rate per unit cellmass of biological rate _j_ (units: mmol/gDW-hr), and $X$ denotes the cellmass in the reactor (units: gDW/L). Lastly, the symbol $V$ denotes the volume of the _reacting_ fluid in the raector.

"""

# ╔═╡ 148be56c-7926-43b7-b120-f39b252a3380


# ╔═╡ bad7bc52-bece-4d40-aa23-dbc6e268a546
md"""
### Objective 2: Relationship between the fractional conversion and extent $\dot{\epsilon}$ for a Single CSTR
The fractional conversion is a relationship between the number of mol of _reactant_ species _i_ that is entering the reactor (or series of reactors) and the number of moles of species _i_ that are leaving the reactor (or series of reactors). Let's consider a single well-mixed liquid phase CSTR are steady-state, that has a single input and a single output. Then, we can write the fractional conversion of _reactant_ species _i_ as (single in and out consecutively numbered):

$$f_{i} = \frac{\dot{n}_{i,j-1} - \dot{n}_{i,j}}{\dot{n}_{i,j-1}}\qquad \dot{n}_{i,j-1}\neq{0}$$

or after some re-arrangement:

$$\dot{n}_{i,j} = \dot{n}_{i,j-1}\left(1-f_{i}\right)$$

where $\dot{n}_{i,j-1}$ denotes the mol flow rate of species _i_ in-stream $j-1$ (inlet), and $\dot{n}_{i,j}$ denotes the mol flow rate of species _i_ in-stream $j$ (outlet). The fractional conversion $f_{i}$ gives additional information about the chemical reactions that are occurring in the reactor. Alternatively, we could also think about the extent of the reaction. 

###### Is there a relationship between the extent and fractional conversion?
To understand the relationship between the extent of reaction, and the fractional conversion let's consider a simple example. Suppose we wanted to model a well-mixed liquid CSTR with a single input (s=0) and a single output (s=1) at steady-state.  Further, suppose this CSTR had no biological reactions and a single bulk-phase chemical reaction. In this case, the species mole balance for species _i_ is given by:

$$\dot{n}_{i,0} - \dot{n}_{i,1}+\sigma_{i1}\hat{r}_{1}V = 0$$

Substituting in the definition of fractional conversion of species _i_ and rearranging gives:

$$f_{i}=-\sigma_{i1}\left(\frac{\hat{r}_{1}V}{\dot{n}_{i,0}}\right)\qquad \dot{n}_{i,0}\neq{0}$$

Let's look at the units of the reaction rate term above. The units of $\hat{r}V$ terms are moles/time, or the time-dependent version of the extent of reaction that we have been exploring. Thus, we could re-write the fractional conversion expression (or the species mole balances themselves) as:

$$f_{i}=-\sigma_{i1}\left(\frac{\dot{\epsilon}_{1}}{\dot{n}_{i,0}}\right)\qquad \dot{n}_{i,0}\neq{0}$$

where the dot $\dot{\star}$ on the extent denotes that we are in an open system (and the extent has units of $\star$mol/time).

###### What happens if there is more than one reaction?
If there is more than one reaction $\hat{r}_{j}$ where $j=1,2,\dots\mathcal{R}$, then the species mole balance is given by:

$$\dot{n}_{i,0} - \dot{n}_{i,1}+\sum_{j=1}^{\mathcal{R}}\sigma_{ij}\hat{r}_{j}V = 0$$

However, the definition of the fractional conversion remains the same (in - out/in), thus:

$$\dot{n}_{i,1} = \dot{n}_{i,0} + \sum_{j=1}^{\mathcal{R}}\sigma_{ij}\hat{r}_{j}V$$

or after substituting of the fractional conversion, the extent (and rearranging) we get:

$$f_{i}=-\left(\frac{\sum_{j=1}^{\mathcal{R}}\sigma_{ij}\dot{\epsilon_{j}}}{\dot{n}_{i,0}}\right)\qquad \dot{n}_{i,0}\neq{0}$$

where $\hat{r}_{j}V=\dot{\epsilon}_{i}$.

"""

# ╔═╡ b7333440-ab75-471d-b932-2c8b8de12706


# ╔═╡ d4b785d8-7871-4993-a0c2-a71dfccf59ad
md"""
### Objective 3: What are the _kinetics_ of a chemical reaction?
The _kinetics_ of a chemical reaction describes the _rate_ at which the reaction proceeds as a function of the conditions in the reactor vessel. Kinetic rate laws have units of $\star$mol/volume-time, and their mathematical form varies significantly with the type of reaction being considered. Let's start by considering the simple non-enzymatic (no catalyst) _reversible_ reaction:

$$A+B\leftrightharpoons{C}$$

A general form for the _net_ rate of this reaction ($\hat{r}_{1}$) is given by:

$$\hat{r}_{1} = k_{1}\prod_{i=1}^{\mathcal{M}}\left[C_{i}\right]^{\alpha_{i1}} - k_{1}^{\prime}\prod_{j=1}^{\mathcal{M}}\left[C_{j}\right]^{\beta_{i1}}$$

where $\left[C_{i}\right]$ denotes the concentration of component $i=1,2,\dots,\mathcal{M}$, and $\alpha_{i1}$ and $\beta_{i1}$ denote the _reaction order_ of component $i$ in reaction $\hat{r}_{1}$. The values of the reation orders $\alpha_{i1}$ and $\beta_{i1}$ depend upon the reaction, and may _not_ always be integer values. 
Lastly, the quantities $k_{1}$ and $k_{1}^{\prime}$ denote the rate constant for the forward and reverse directions, respectively. Rate constants have various units depending upon the values of $\alpha_{i1}$
and $\beta_{i1}$. 

There is no requirement that $\alpha_{i1}$ and $\beta_{i1}$ be integers (or the stoichiometric coefficients). This is often only true when we have a complete (or simplified) picture of the chemistry that is occurring. In real-life, fractional values for $\alpha_{i1}$ and $\beta_{i1}$ are common in many application areas.  

__Confused?__
Another way to think about the kinetic rate laws and rate constants is that the overall rate of a reaction is proportional to the concentrations of the species that are participating in the reaction (raised to some power). Given this perspective, the rate constants are then simply constants of proportionality for each direction of the rate. 
"""

# ╔═╡ 8d737835-7442-46a6-bb96-858cce538a77
md"""
##### The Law of Mass Action and Mass Action Kinetics

The [law of mass action](https://en.wikipedia.org/wiki/Law_of_mass_action) assumes that the net rate of a chemical reaction is proportional to the concentration of the components raised to the $-{1}\times$ the stoichiometric coefficient of that component in _a particular reaction direction_. For example, for the reaction $A+B\leftrightharpoons{C}$, the mass action rate law would be:

$$\hat{r}_{1} = k_{1}\left[A\right]\left[B\right] - k^{\prime}_{1}\left[C\right]$$

Thus, a general statement of the law of mass action is for reaction $j$ (that could involve autocatalysis):

$$\hat{r}_{j} = k_{j}\prod_{i=1}^{\mathcal{M}}\left[C_{i}\right]^{-\sigma_{ij}} - 
k^{\prime}_{j}\prod_{i=1}^{\mathcal{M}}\left[C_{i}\right]^{-\sigma_{ij}}$$

"""

# ╔═╡ 21a1f45f-1b5c-406c-b88a-ac3ee194f0b4
md"""

##### Temperature dependence of rate constants $k_{i}^{\star}$

The rate constants for some reaction $\hat{r}_{i}$ denoted by $k_{i}$ and $k_{i}^{\prime}$ are functions of temperature in the reactor $T$. One way to model this dependece is:

$$k_{i}^{\star} = A^{\star}_{i}\exp(-\frac{E^{\star}_{i}}{RT})$$

where $A^{\star}_{i}$ denotes a _frequency factor_ (units: variable) for reaction $i$, $E^{\star}_{i}$ denotes the _activation energy_ (units: J/mol) for reaction $i$, and the superscript $\cdot^{\star}$ denotes the reaction direction. This expression, known as the [Arrhenius equation](https://en.wikipedia.org/wiki/Arrhenius_equation), is only one (albeit very commonly used) model of the temperature dependence of rate constants, however, not all reactions obey this expression.

We can estimate the activation energy and the frequency factor from experimental measurements of the rate constants at different temperatures. Rearranging the Arrhenius equation and taking the $\ln\star$ of both sides gives the expression:

$$\ln{k^{\star}_{i}} = \ln{A^{\star}_{i}} - \frac{1}{T}\left(\frac{E^{\star}_{i}}{RT}\right)$$

This expression is of the form $y$=$mx+b$ where $x$ is the inverse temperature, the activation energy term is the slope and the natural log of the frequency factor is the y-intercept.
"""

# ╔═╡ 1bf20268-3bbd-11ec-352b-55a41c839578
html"""
<style>
main {
    max-width: 1200px;
    width: 90%;
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

[compat]
PlutoUI = "~0.7.18"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0ec322186e078db08ea3e7da5b8b2885c099b393"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.0"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "5efcf53d798efede8fee5b2c8b09284be359bf24"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.2"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

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
git-tree-sha1 = "57312c7ecad39566319ccf5aa717a20788eb8c1f"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.18"

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
# ╟─6ab6a977-13ec-412f-b80e-09cd9252624c
# ╟─7debf40c-5e61-4ac6-a1d5-4b82927d3dbc
# ╟─148be56c-7926-43b7-b120-f39b252a3380
# ╟─bad7bc52-bece-4d40-aa23-dbc6e268a546
# ╟─b7333440-ab75-471d-b932-2c8b8de12706
# ╟─d4b785d8-7871-4993-a0c2-a71dfccf59ad
# ╟─8d737835-7442-46a6-bb96-858cce538a77
# ╟─21a1f45f-1b5c-406c-b88a-ac3ee194f0b4
# ╟─a3ef3e3e-81ce-4645-b5a4-1e816803a7fc
# ╟─1bf20268-3bbd-11ec-352b-55a41c839578
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
