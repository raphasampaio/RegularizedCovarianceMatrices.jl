#!/bin/bash

julia +1.11 --project -e "using Pkg; Pkg.develop(PackageSpec(path=dirname(pwd()))); Pkg.instantiate()"
julia +1.11 --project make.jl