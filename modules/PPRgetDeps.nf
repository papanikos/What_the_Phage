process pprgetdeps {
        storeDir 'nextflow-autodownload-databases/pprmeta'
        label 'ubuntu'    
      output:
        file("PPR-Meta")
      script:
        """
        git clone https://github.com/Stormrider935/PPR-Meta.git
        """
    }