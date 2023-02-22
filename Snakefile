import subprocess, sys

configfile: "example_config.yaml"

DATASETS = [d for d in config for s in config[d]]
SAMPLES = [s for d in config for s in config[d]]
VERSION = "1.0"

sys.stderr.write("Running chunked_demux\n")
sys.stderr.write("Version: {0}\n".format(VERSION))


# demux
chunk_size = 100000  		# default 100000
index_type = "Index_primer" # default "Index_Primer"
error_rate = 0.01    		# default 0.01
min_length = 1440    		# default 2100
max_length = 3500    		# default 4000


rule all:
    input:
        expand("output/{dataset}/{dataset}_quality_report.csv",
            dataset = DATASETS)

rule demux:
    input:
        "raw-reads/{dataset}.fastq.gz"
    output:
        directory("output/{dataset}/demux"),
        "output/{dataset}/{dataset}_quality_report.csv",
        "output/{dataset}/{dataset}_demux_report.csv",
        "output/{dataset}/{dataset}_reject_report.csv"
    params:
        chunk_size = chunk_size,
        error_rate = error_rate,
        min_length = min_length,
        max_length = max_length,
        index_type = index_type,
        config = lambda wc: config[wc.dataset]
    script:
        "scripts/demux.jl"

