### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ a4feb3e1-48dd-4b74-9e64-65eec798b34c
md"""
The teaching team built a reactor in the basement of Olin Hall to produce H$_{2}$ continuously by decomposing NH$_{3}(g)$ according to the reaction:

$$2NH_{3}~{\rightleftharpoons}~{N_{2}+3H_{2}}$$

The feed stream into the reactor (stream 1) consists of 30.52 mol/s of NH$_{3}$(g) and 0.06 mol/s of H$_{2}$O(g) (a contaminant that does not participate in the reaction).  There are no products in the feed stream. At the outlet (stream 2), the teaching team measured 45.1 mol/s of H$_{2}$ leaving the reactor.

__Assumptions__
* The gas phase is ideal
* The ideal gas law is a valid equation of state for this reactor
* The reactor operates at steady-state
* The reactor has a constant T, P and V

__Compute__
* Compute the open extent of reaction $\dot{\epsilon}_{1}$ for the decomposition reaction
* Compute the missing values in the state table XXX.
* Compute the fractional conversion of NH$_{3}$(g).

"""

# ╔═╡ ba730327-4135-4301-9a78-a86c2a777834
30.52+0.058

# ╔═╡ 65225bd2-4186-11ec-3709-6bba7ee9bd05
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

# ╔═╡ Cell order:
# ╟─a4feb3e1-48dd-4b74-9e64-65eec798b34c
# ╠═ba730327-4135-4301-9a78-a86c2a777834
# ╟─65225bd2-4186-11ec-3709-6bba7ee9bd05
