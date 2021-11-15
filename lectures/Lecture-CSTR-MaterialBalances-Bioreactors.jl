### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 215136d6-9313-4849-81e1-b269f699aa33
md"""
## Processes with Cells: Outside the Cell

Up to now, we have not considered chemical transformations and processes involving cells (called Bioprocesses). However, bioreactors and bioprocesses are important areas for Chemical Engineering. Toward this point, by the end of this lecture you should be able to:

__Objectives__ 
* Write the species mole and mass balances for substrate $S$, product $P$ and cells $X$ in a bioreactor
* Formulate _simple_ models for the rate of cell growth and product formation
* Solve _simple_ models of cell growth and product formation in different types of well-mixed continuous stirred tank reactors 

"""

# ╔═╡ 4464cb96-2778-4946-978d-50961869d59a
md"""
##### Objective 1: Material balances for substrates $S_{i}$, products $P_{j}$ and cells $X$ in a bioreactor
This is the easy part: we've sort of seen these balance equations before. Let's consider a bioprocess in a well-mixed continuous stirred tank reactor that may (or may not) be at a steady state. Substrates (starting materials) $S_{1},S_{2},\dots,S_{A}$ are transformed to product(s) $P_{1},P_{2},\dots,P_{\mathcal{P}}$ and cells $X$ in the bioreactor.  

__General case__: Let's start with the species mole balances around substrates, products and cells where we number the substrate and product species $i=1,2,\dots,\mathcal{M}$ and denote cell concentration by X (units: gDW/L):

$$\begin{eqnarray}
\frac{dn_{i}}{dt} & = & \sum_{s=1}^{\mathcal{S}}v_{s}\dot{F}_{s}n_{is} + \left(\sum_{j=1}^{\mathcal{T}}\tau_{ij}q_{j}X\right)V\qquad{i=1,2,\dots,\mathcal{M}}\\
V\frac{dX}{dt} & = & \sum_{s=1}^{\mathcal{S}}v_{s}\dot{F}_{s}X_{is} + \left(\mu-d\right)XV
\end{eqnarray}$$

where $n_{i}$ denotes the number of moles of species $i$ in the reactor, $n_{is}$ denotes the number of moles of species $i$ in stream $s$, where
$v_{s}$ denotes the direction parameter for stream $s$. There are $s=1,2,\dots,\mathcal{S}$ possible streams into and from the bioreactor. 
The second set of terms on the right-hand side of the first equation are the (bio)reaction terms: the symbol $\tau_{ij}$ denotes the 
_stoichiometric_ coefficient for species $i$ in rate process $j$, where $q_{j}$ denotes the _specific_ rate of biotransformation $j$ (units: $\star$mol/gDW-time), $X$ denotes the cellmass concentration (units: gDW/L) and $V$ denotes the volume of the reacting fluid in the reactor. 
The second equation is the cellmass balance, where the first term on the right-hand side if the transport of cells into and from the bioreactor in the streams, and the second term is the _net_ rate of cell growth, where $\mu$ denotes the specific growth rate (units: 1/time) and $d$ denotes the specific rate of cell death (units: 1/time).

"""

# ╔═╡ 3a0df0cc-b0aa-4232-9275-389d378114aa
md"""
##### Objective 2: Formulate _simple_ models for the specific rate of cell growth and product formation
The _simple_ way to formulate the rate of substrate utilization and product formation in bioprocesses is to treat cells as black boxes: substrate goes into the box and more cells and product(s) come out the box. Thus, the rates at which these processes occur are often _empirical_, meaning they describe data but are not necessarily mechanistic. 
"""

# ╔═╡ 84091166-c516-4767-bf9c-cf6b6a80ceb8
md"""
##### Objective 3: Solve models of cell growth and product formation in a well-mixed continuous stirred bioreactor
"""

# ╔═╡ a0aa5eee-4601-11ec-1d3c-2d0230a4a0a3
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
# ╟─215136d6-9313-4849-81e1-b269f699aa33
# ╟─4464cb96-2778-4946-978d-50961869d59a
# ╟─3a0df0cc-b0aa-4232-9275-389d378114aa
# ╟─84091166-c516-4767-bf9c-cf6b6a80ceb8
# ╟─a0aa5eee-4601-11ec-1d3c-2d0230a4a0a3
