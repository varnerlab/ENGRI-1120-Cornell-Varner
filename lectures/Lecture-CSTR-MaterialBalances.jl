### A Pluto.jl notebook ###
# v0.17.0

using Markdown
using InteractiveUtils

# ╔═╡ 6ab6a977-13ec-412f-b80e-09cd9252624c
md"""
#### Material Balances for Single and Multiple Continuous Stirred Tank Reactors (CSTR) 
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
##### Objective 1: Total Mass and Species Balance Equations for a Single CSTR
If we consider a single liquid well-mixed CSTR as our system, then we can use the species mols balances that we have already developed to describe the steady-state behavior of the reactor. The steady-state species mole balance for component $i=1,2,\dots\mathcal{M}$ is given by:

$$\sum_{s=1}^{\mathcal{S}}v_{s}\dot{n}_{is} + \left(\sum_{k=1}^{\mathcal{R}}\sigma_{ik}\hat{r}_{k} + \sum_{j=1}^{\mathcal{T}}\tau_{ij}q_{j}X\right)V = 0$$

where $\dot{n}_{is}$ denotes the flow rate of moles of component _i_ in stream _s_, 
$v_{s}$ denotes the direction parameter of stream _s_, and $\mathcal{S}$ denotes the total number of streams. 
The second set of summations denotes the reaction terms for both bulk-liquid and possible biological reactions, respectively. 
The quantity $\hat{r}_{k}$ denotes the rate per unit volume of chemical reaction _k_ occurring in the bulk fluid, $\tau_{ij}$ denotes the stoichiometric coefficient linking species _i_ with biological reaction _j_, $q_{j}$ denotes the rate per unit cellmass of biological rate _j_ (units: mmol/gDW-hr), and $X$ denotes the cellmass in the reactor (units: gDW/L). Lastly, the symbol $V$ denotes the volume of the _reacting_ fluid in the raector.

"""

# ╔═╡ bad7bc52-bece-4d40-aa23-dbc6e268a546
md"""
##### Objective 2: Relationship between the fractional conversion and extent $\dot{\epsilon}$ for a Single CSTR
The fractional conversion is a relationship between the number of mol of _reactant_ species _i_ that is entering the reactor (or series of reactors) and the number of moles of species _i_ that are leaving the reactor (or series of reactors). Let's consider a single well-mixed liquid phase CSTR are steady-state, that has a single input and a single output. Then, we can write the fractional conversion of _reactant_ species _i_ as (single in and out consecutively numbered):

$$f_{i} = \frac{\dot{n}_{i,j-1} - \dot{n}_{i,j}}{\dot{n}_{i,j-1}}\qquad \dot{n}_{i,j-1}\neq{0}$$

or after some re-arrangement:

$$\dot{n}_{i,j} = \dot{n}_{i,j-1}\left(1-f_{i}\right)$$

where $\dot{n}_{i,j-1}$ denotes the mol flow rate of species _i_ in-stream $j-1$ (inlet), and $\dot{n}_{i,j}$ denotes the mol flow rate of species _i_ in-stream $j$ (outlet). The fractional conversion $f_{i}$ gives additional information about the chemical reactions that are occurring in the reactor. Alternatively, we could also think about the extent of the reaction. 

__Q: Is there a relationship between the extent and fractional conversion?__

To understand the relationship between the extent of reaction, and the fractional conversion let's consider a simple example. Suppose we wanted to model a well-mixed liquid CSTR with a single input (s=0) and a single output (s=1) at steady-state.  Further, suppose this CSTR had no biological reactions and a single bulk-phase chemical reaction. In this case, the species mole balance for species _i_ is given by:

$$\dot{n}_{i,0} - \dot{n}_{i,1}+\sigma_{i1}\hat{r}_{1}V = 0$$

Substituting in the definition of fractional conversion of species _i_ and rearranging gives:

$$f_{i}=-\sigma_{i1}\left(\frac{\hat{r}_{1}V}{\dot{n}_{i,0}}\right)\qquad \dot{n}_{i,0}\neq{0}$$

Let's look at the units of the reaction rate term above. The units of $\hat{r}V$ terms are moles/time, or the time-dependent version of the extent of reaction that we have been exploring. Thus, we could re-write the fractional conversion expression (or the species mole balances themselves) as:

$$f_{i}=-\sigma_{i1}\left(\frac{\dot{\epsilon}_{1}}{\dot{n}_{i,0}}\right)\qquad \dot{n}_{i,0}\neq{0}$$

where the dot $\dot{\star}$ on the extent denotes that we are in an open system (and the extent has units of $\star$mol/time).

__Q: What happens if there is more than one reaction?__

If there is more than one reaction, the species mole balance is given by:

$$\dot{n}_{i,0} - \dot{n}_{i,1}+\sum_{j=1}^{\mathcal{R}}\sigma_{ij}\hat{r}_{j}V = 0$$

However, the definition of the fractional conversion remains the same, thus:

$$\dot{n}_{i,1} = \dot{n}_{i,0} + \sum_{j=1}^{\mathcal{R}}\sigma_{ij}\hat{r}_{j}V$$

or after substituting of the fractional conversion, the extent (and rearranging) we get:

$$f_{i}=-\left(\frac{\sum_{j=1}^{\mathcal{R}}\sigma_{ij}\dot{\epsilon_{j}}}{\dot{n}_{i,0}}\right)\qquad \dot{n}_{i,0}\neq{0}$$

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

# ╔═╡ Cell order:
# ╟─6ab6a977-13ec-412f-b80e-09cd9252624c
# ╟─7debf40c-5e61-4ac6-a1d5-4b82927d3dbc
# ╟─bad7bc52-bece-4d40-aa23-dbc6e268a546
# ╟─1bf20268-3bbd-11ec-352b-55a41c839578
