// Declare syntax version
nextflow.enable.dsl=2

process RSEM_PREPAREREFERENCE {

    container = "${projectDir}/../singularity-images/depot.galaxyproject.org-singularity-mulled-v2-cf0123ef83b3c38c13e3b0696a3f285d3f20f15b-64aad4a4e144878400649e71f42105311be7ed87-0.img"

    input:
    path fasta
    path gtf

    output:
    path "*tar.gz"
    path "*transcripts.fa"

    script:
    """
    mkdir rsem_genome
    rsem-prepare-reference \\
        --gtf $gtf \\
        --num-threads ${params.threads_num} \\
        $fasta \\
        rsem_genome/rsem_genome
    cp rsem_genome/*.transcripts.fa .
    tar -czvf rsem_genome.tar.gz rsem_genome
    rm -rf rsem_genome
    cp -r *.fa rsem_genome.tar.gz ${launchDir}/${params.outdir}/
    """
}

workflow{
    fasta = Channel.of(params.fasta)
    gtf   = Channel.of(params.gtf)
    RSEM_PREPAREREFERENCE(fasta, gtf)
}

