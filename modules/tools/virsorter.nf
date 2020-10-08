process virsorter {
      label 'virsorter'
      errorStrategy 'ignore'
    input:
      tuple val(name), file(fasta) 
      file(database) 
    output:
      tuple val(name), file("virsorter_*.list"), file("virsorter")
      // output collection stream
      tuple val(name), file("virsorter_results_*.tar")
    script:
      """
      wrapper_phage_contigs_sorter_iPlant.pl -f ${fasta} -db 2 --wdir virsorter --ncpu \$(( ${task.cpus} * 2 )) --data-dir ${database}
      cat virsorter/Predicted_viral_sequences/VIRSorter_*-[${params.vs_filter}].fasta | grep ">" | sed -e s/\\>VIRSorter_//g | sed -e s/-cat_1//g |  sed -e s/-cat_2//g | sed -e s/-cat_3//g | sed -e s/-circular//g | awk 'BEGIN{FS="_gene"};{print \$1}' > virsorter_\${PWD##*/}.list

      tar cf virsorter_results_\${PWD##*/}.tar virsorter
      """
}

process virsorter_virome {
      label 'virsorter'
      errorStrategy 'ignore'
    input:
      tuple val(name), file(fasta) 
      file(database) 
    output:
      tuple val(name), file("virsorter_*.list"), file("virsorter")
      // output collection stream
      tuple val(name), file("virsorter_results_*.tar")
    script:
      """
      wrapper_phage_contigs_sorter_iPlant.pl -f ${fasta} -db 2 --virome --wdir virsorter --ncpu \$(( ${task.cpus} * 2 )) --data-dir ${database}
      cat virsorter/Predicted_viral_sequences/VIRSorter_*-[${params.vs_filter}].fasta | grep ">" | sed -e s/\\>VIRSorter_//g | sed -e s/-cat_1//g |  sed -e s/-cat_2//g | sed -e s/-cat_3//g | sed -e s/-circular//g | awk 'BEGIN{FS="_gene"};{print \$1}' > virsorter_\${PWD##*/}.list

      tar cf virsorter_results_\${PWD##*/}.tar virsorter
      """
}