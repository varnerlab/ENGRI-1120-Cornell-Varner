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
    _Or you can simply the following in a terminal:_
    ```bash
    julia -E "using Pluto; Pluto.run()"
    ```
1. From Pluto, open one of the `.jl` notebook files located in the `ENGRI-1120-Cornell-Varner/notebooks/` directory—enjoy!

### Notebooks for Lecture Examples
 * [Example notebook](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-HFCS.jl.html): 
High-Fructose Corn Syrup (HFCS) example develops mass balances around a reactor in which a sugar S is converted to a product P by Enzyme E. 

* [Example](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-Chip.jl.html)
High-Fructose Corn Syrup (HFCS) example uses concentration balances and kinetic expressions for the reaction rates to model the performance of a reactor in which a sugar S is converted to a product P by Enzyme E. 

* [Example](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-DiscountRate.jl.html)
Discount rate example which discusses the time value of money (a dollar today is worth more than a dollar T days in the future).

* [Example](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-NPV.jl.html)
Net Present Value (NPV) example taken from [MIT 15.401](https://ocw.mit.edu/courses/sloan-school-of-management/15-401-finance-theory-i-fall-2008/). Should we install that new computer controlled lighting system? I don't know, let's compute the NPV and find out. 

* [Example](https://htmlview.glitch.me/?https://github.com/varnerlab/ENGRI-1120-Cornell-Varner/blob/main/html/Example-LostWork-Turbine.jl.html)
Lost work example for an adiabatic turbine in the [Rankine Power Generation Cycle](https://en.wikipedia.org/wiki/Rankine_cycle). 
We use the open first and second law balances to compute the work lost from an inefficient turbine. 