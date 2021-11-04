### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 2bb195db-311f-4191-95a1-04d6a4b75d74
md"""
#### Practice Problem: Some interesting nuggets about equilibrium and kinetics

a) Starting from the mass-action kinetic expression for the _net_ rate of reaction of $j$ denoted by $\hat{r}_{j}$:

$$\hat{r}_{j} = k^{+}_{j}\prod_{i\in\mathcal{M}^{+}}\left[X_{i}\right]^{-\sigma_{ij}} - 
k^{-}_{j}\prod_{i\in\mathcal{M}^{-}}\left[X_{i}\right]^{-\sigma_{ij}}$$ show that equilibrium constant for reaction $j$, denoted by $K_{j}$, equals:

$$K_{j} = \frac{k_{j}^{+}}{k_{j}^{-}}$$ 

where $\left[X_{i}\right]$ denotes the concetration of component $i$, $k_{j}^{+}$ denotes the forward rate constant, $k_{j}^{+}$ denotes the backward rate constant, $i\in\mathcal{M}^{+}$ denotes the indicies of the reactants for the forward reaction, and $i\in\mathcal{M}^{-}$ denotes the indicies of the reactants in the reverse direction for reaction $j$. The quantity $\sigma_{ij}$ denotes the stoichiometric coefficient governing the behavior of component $i$ in reaction $j$. 

b) If $k_{j}^{-}\rightarrow{0}$, what does that say about the $\Delta{G}$ of the reaction $j$?

c) Can chemical equilibrium occur in an _open_ system? Explain your answer in terms of an open system at steady-state with a single in/out stream, and the reaction $A\rightleftharpoons{B}$, versus a closed system with the same reaction.

d) If we gave you concentration measurements for $A$ as a function of time at different temperatures for a closed system in which the reaction $A\rightleftharpoons{B}$ was occurring, explain how you would use it to compute rate constants, activation energies, frequency factors, etc, assuming the kinetics were first-order? 

"""

# ╔═╡ 40f90c69-76c9-41fa-9fe5-2c3410d6bc43


# ╔═╡ 6a67ec88-3d92-11ec-0fca-f5f1f3e769b3
html"""
<style>
main {
    max-width: 1200px;
    width: 75%;
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
# ╟─2bb195db-311f-4191-95a1-04d6a4b75d74
# ╠═40f90c69-76c9-41fa-9fe5-2c3410d6bc43
# ╟─6a67ec88-3d92-11ec-0fca-f5f1f3e769b3
