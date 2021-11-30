# ENGRI 1120 Fall 2021 Cornell University 
This repository holds example problems discussed in lecture. The problems are structured in [Pluto](https://github.com/fonsp/Pluto.jl) notebooks and use the [Julia](https://julialang.org) programming language. 

### Installing Julia and Pluto
[Julia](https://julialang.org) is open source, free and runs on all major operating systems and platforms. To install 
[Julia](https://julialang.org) and [Pluto](https://github.com/fonsp/Pluto.jl) please check out the tutorial for 
[MIT 18.S191/6.S083/22.S092 course from Fall 2020](https://computationalthinking.mit.edu/Fall20/installation/).

1. [Install Julia (we are using v1.6.x, newer versions of Julia should also work)](https://julialang.org/downloads/)
1. [Install Pluto.jl](https://github.com/fonsp/Pluto.jl#installation)
1. Clone this repo:
    ```bash
    git clone https://github.com/varnerlab/ENGRI-1120-Cornell-Varner.git
    ```
1. From the Julia REPL (`julia`), run Pluto (a web browser window will pop-up):
    ```julia
    julia> using Pluto
    julia> Pluto.run()
    ```
    _Or you can simply type the following in a terminal:_
    ```bash
    julia -E "using Pluto; Pluto.run()"
    ```
1. From Pluto, open one of the `.jl` notebook files located in the `ENGRI-1120-Cornell-Varner/notebooks/` directory—enjoy!

### Notebooks for Lectures

* [Lecture notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Lecture-CSTR-MaterialBalances.jl.html): Lecture material for continuous stirred tank reactors (CSTR) mole balances lecture

* [Lecture notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Lecture-SteadyState-vs-Eq.jl.html): Lecture material for continuous stirred tank reactors (CSTR) steady-state versus equilibrium lecture

* [Bioprocess-I lecture: Outside of the cell.](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Lecture-CSTR-MaterialBalances-Bioreactors.jl.html): Introduction to _unstructured_ bioprocess models which describe reactor conditions outside of cells (if we knew nothing about the cells).

* [Bioprocess-II lecture: Inside the cell.](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Lecture-FluxBalanceAnalysis.jl.html): Introduction to metabolic networks, metabolic engineering and constraint analysis based tools.

### Notebooks for Lecture Examples

#### Flux balance analysis example
* [Example notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-Chip-FluxBalanceAnalysis.jl.html): 
Example calculation for the rate of product _P_ formation in a steady-state micro-reactor using Flux Balance Analysis (FBA).

* [Example notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-Chip-FluxBalanceAnalysis-Project.jl.html): 
Example calculation for the rate of product formation in a steady-state micro-reactor using Flux Balance Analysis (FBA) for the Design Project network

#### Material/mass balance examples

 * [Example notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-HFCS.jl.html): 
High-Fructose Corn Syrup (HFCS) example develops mass balances around a reactor in which a sugar S is converted to a product P by Enzyme E. 

* [Example notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-Chip.jl.html):
High-Fructose Corn Syrup (HFCS) example uses concentration balances and kinetic expressions for the reaction rates to model the performance of a reactor in which a sugar S is converted to a product P by Enzyme E. 


#### Net Present Value (NPV) and the Time Value of Money (TVM) examples

* [Example notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-DiscountRate.jl.html):
Discount rate example which discusses the time value of money (a dollar today is worth more than a dollar T days in the future).

* [Example notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-NPV.jl.html):
Net Present Value (NPV) example taken from [MIT 15.401](https://ocw.mit.edu/courses/sloan-school-of-management/15-401-finance-theory-i-fall-2008/). Should we install that new computer controlled lighting system? I don't know, let's compute the NPV and find out. 

#### Power Generation and Cooling Cycle examples

* [Example notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-LostWork-Turbine.jl.html): Lost work example for an adiabatic turbine in the [Rankine Power Generation Cycle](https://en.wikipedia.org/wiki/Rankine_cycle). 
We use the open first and second law balances to compute the work lost from an inefficient turbine. 

* [Example notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-ThrottleValve.jl.html): Analysis of the throttle valve operation in the [vapor compression refrigeration cycle (VCRC)](https://en.wikipedia.org/wiki/Vapor-compression_refrigeration).

#### Flash Separation and VLE examples

* [Example notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-FlashSeparation.jl.html): How can we separate a mixture with no moving parts? We use a [Flash Drum](https://en.wikipedia.org/wiki/Vapor–liquid_separator) which works in a similar way to the throttle valve of the VCRC. Its not magic, its just physics!

* [Example notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-GraphicalFlash.jl.html): We revisit the previous flash separation problem and develop the solution graphically using a Pressure composition (Pxy) phase diagram.

#### Chemical Reaction Equilibrium (CRE) examples

* [Example notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-LiqEqConstant.jl.html): In this example we compute the equilibrium extent of reaction for several ideal liquid phase reactions in central carbon metabolism.

* [Example notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-GasEqConstant.jl.html): In this example we compute the composition, equilibrium constant and Gibbs reaction energy for a single ideal reaction in the gas phase.
  
* [Example notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-DirectGibbsMin.jl.html): In this example we compute the equilibrium extent of reaction in a single ideal liquid phase reaction by directly minimizing the total Gibbs energy.

* [Example notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-DirectGibbsMin-MultipleRxn.jl.html): In this example we compute the equilibrium extents of reaction for multiple reactions from _E.coli_ central carbon metabolism in an ideal liquid. 

## Practice Prelim Questions/Solutions 
### Solution Notebooks for Practice Prelim 1
The notebooks for practice prelim 1 solutions can be found in the `prelims/P1/practice` directory.
Static HTML versions of the notebooks can be found here:

* [Notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Soln-PracticePrelim-CoffeeMaker.html) Coffee maker problem practice prelim 1
* [Notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Soln-PracticePrelim-FlashProblem.html) Flash separation problem practice prelim 1
* [Notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Soln-PracticePrelim-ModVCRR.html) Modified VCRC problem practice prelim 1

### Solution Notebooks for Practice Prelim 2
The notebooks for practice prelim 2 questions/solutions can be found in the `prelims/P2/practice` directory. Static HTML versions of the notebooks can be found here:

* [Notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Soln-1120-PracticePrelim-2-CRE-F21.jl.html) Chemical reaction equilibrium problem for practice prelim 2
* [Notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Soln-1120-PracticePrelim-2-CSTR-F21.jl.html) Single CSTR problem for practice prelim 2
* [Notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Soln-1120-PracticePrelim-2-Kinetics-F21.jl.html) Various questions about kinetics, steady-state and equilibrium



## Actual Prelim Solutions
### Solution Notebooks for Actual Prelim 1
The notebooks for actual prelim 1 solutions can be found in the `prelims/P1/actual` directory.
Static HTML versions of the notebooks can be found here:

* [Solution notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Soln-1120-P1A-ReactorProblem.jl.html) Reactor problem for Prelim 1
* [Solution notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Soln-1120-P1A-ModORC.jl.html) Modified organic Rankine Cycle problem from Prelim 1
* [Solution notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Soln-1120-P1A-CycleProblem.jl.html) Three component cycle analysis question for Prelim 1

### Solution Notebooks for Actual Prelim 2
The notebooks for actual prelim 1 solutions can be found in the `prelims/P2/actual` directory.
Static HTML versions of the notebooks can be found here:

* [Solution notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Soln-ENGRI-1120-P2-Actual-EqProblem.jl.html) Equilibrium problem from Prelim 2
* [Solution notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Soln-ENGRI-1120-P2-Actual-FractionalConversion.jl.html) Open fractional conversion problem from Prelim 2
* [Solution notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Soln-ENGRI-1120-P2-Actual-RateConstantProblem.jl.html) Rate constant estimation problem from Prelim 2