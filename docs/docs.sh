#!/bin/bash

julia +1.12 --project -e "using Pkg; Pkg.develop(PackageSpec(path=dirname(pwd()))); Pkg.instantiate()"
julia +1.12 --project make.jl