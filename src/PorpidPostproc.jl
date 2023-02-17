module PorpidPostproc

#as this is only the demux, none of the other modules are needed

export # demux_functions
    unique_not_substr,
    longest_conserved_5p,
    iterative_primer_match,
    sliding_demux_dic,
    chunked_filter_apply,
    chunked_quality_demux

using BioSequences, FASTX


#include("apobec_model.jl")
include("functions.jl")
#include("molev_functions.jl")
#include("porpid_analysis_methods.jl")
#include("postproc_functions.jl")
include("demux_functions.jl")
#include("contam-filter_functions.jl")
#include("porpid_functions.jl")
#include("blast_functions.jl")

end # module
