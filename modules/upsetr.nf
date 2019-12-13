process upsetr_plot {
      publishDir "${params.output}/${name}", mode: 'copy', pattern: "upsetr.svg"
      label 'upsetr'
      errorStrategy{task.exitStatus=1 ?'ignore':'terminate'}
    input:
      tuple val(name), file(files)
    output:
      tuple val(name), file("upsetr.svg")
    script:
      """
      #!/usr/bin/env Rscript

      library(UpSetR)

      files_for_upset <- list.files(path="./",full.names=T)

      sets <- lapply(files_for_upset, readLines)

      #sets_names <- sapply(files_for_upset,function(x){
      #		 splits <- strsplit(strsplit(x,"//")[[1]][2],"_")[[1]]
      #	 	 return(paste0(substr(splits[1],1,1),substr(splits[2],1,2)))
      #})

      #names(sets) <- sets_names
      names(sets) <- files_for_upset

      svg(filename="upsetr.svg", 
          width=10, 
          height=8, 
          pointsize=12)

      upset(fromList(sets), nsets = 20, nintersects = 40, sets = names(sets), 
          mainbar.y.label = "No. of common viral contigs", sets.x.label = "No. of identified \\nviral contigs", 
          order.by = "freq", sets.bar.color = "#56B4E9", keep.order = T, 
          text.scale = 1.4, point.size = 2.6, line.size = 0.8,
          set_size.show = TRUE, empty.intersections = "off")

      dev.off()
      """
}