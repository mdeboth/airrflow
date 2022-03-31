process PRESTO_ASSEMBLEPAIRS {
    tag "$meta.id"
    label 'process_long_parallelized'

    conda (params.enable_conda ? "bioconda::presto=0.7.0" : null)              // Conda package
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/presto:0.7.0--pyhdfd78af_0' :
        'quay.io/biocontainers/presto:0.7.0--pyhdfd78af_0' }"

    input:
    tuple val(meta), path(R1), path(R2)

    output:
    tuple val(meta), path("*_assemble-pass.fastq"), emit: reads
    path("*_command_log.txt"), emit: logs
    path("*.log")
    path("*_table.tab")

    script:
    def args = task.ext.args ?: ''
    def args2 = task.ext.args2 ?: ''
    """
    AssemblePairs.py align -1 $R1 -2 $R2 --nproc ${task.cpus} \\
        $args \\
        --outname ${meta.id} --log ${meta.id}.log > ${meta.id}_command_log.txt
    ParseLog.py -l "${meta.id}.log" $args2
    """
}
