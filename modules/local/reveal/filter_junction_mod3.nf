process FILTER_JUNCTION_MOD3 {
    tag "$meta.id"
    label 'immcantation'
    label 'process_single'

    conda "bioconda::r-enchantr=0.1.2"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/r-enchantr:0.1.2--r42hdfd78af_0':
        'biocontainers/r-enchantr:0.1.2--r42hdfd78af_0' }"

    input:
    tuple val(meta), path(tab) // sequence tsv in AIRR format

    output:
    tuple val(meta), path("*junction-pass.tsv"), emit: tab // sequence tsv in AIRR format
    path("*_command_log.txt"), emit: logs //process logs
    path "versions.yml", emit: versions

    script:
    """
    reveal_mod_3_junction.R --repertoire $tab --outname ${meta.id} > ${meta.id}_jmod3_command_log.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        alakazam: \$(Rscript -e "library(alakazam); cat(paste(packageVersion('alakazam'), collapse='.'))")
        optparse: \$(Rscript -e "library(optparse); cat(paste(packageVersion('optparse'), collapse='.'))")
        airr: \$(Rscript -e "library(airr); cat(paste(packageVersion('airr'), collapse='.'))")
        R: \$(echo \$(R --version 2>&1) | awk -F' '  '{print \$3}')
    END_VERSIONS
    """
}
