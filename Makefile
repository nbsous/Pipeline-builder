### Makefile to lay out project

# Path variables
PIPELINEPATH=NGS_map_call_0.1
BINPATH=bin
WORKFLOWPATH=workflow
RESOURCESPATH=resources
READMEPATH=README.md
LOGPATH=logs

# Software variables
WDLVERSION=0.14
CROMWELLVERSION=29
BWAVERSION=0.7.12
PICARDVERSION=2.12.1
GATKVERSION=3.8-0
#BOWTIE2VERSION=
#BEDTOOLS=

# Resource variables
#EXACVERSION

# Other components
.PHONY: all structure tools scripts


## Build directory structure for project
structure: 
# Dir containing workflows
	mkdir -p $(PIPELINEPATH)/$(WORKFLOWPATH)
# Dir containing resources  
	mkdir -p $(PIPELINEPATH)/$(RESOURCESPATH)
# Dir containing log files and SQLite DB to keep overview of processing  
	mkdir -p $(PIPELINEPATH)/$(LOGPATH)
# Dir containing binaries & java tools
	mkdir -p $(PIPELINEPATH)/$(BINPATH)
	touch $(PIPELINEPATH)/$(READMEPATH)
	echo '# $(PIPELINEPATH) README' > $(PIPELINEPATH)/$(READMEPATH)
  
  
## Gather tools required to run pipeline
tools: structure
	# WDL tool
	wget https://github.com/broadinstitute/wdltool/releases/download/$(WDLVERSION)/wdltool-$(WDLVERSION).jar
	mv wdltool-$(WDLVERSION).jar $(PIPELINEPATH)/$(BINPATH)/
	# CROMWELL
	wget https://github.com/broadinstitute/cromwell/releases/download/$(CROMWELLVERSION)/cromwell-$(CROMWELLVERSION).jar
	mv cromwell-$(CROMWELLVERSION).jar $(PIPELINEPATH)/$(BINPATH)/
	# BWAKIT including SAMTOOLS and tools to generate grch38 (hg38) ref genome index
	wget --output-document=$(PIPELINEPATH)/$(BINPATH)/bwakit-$(BWAVERSION)_x64-linux.tar.bz2 https://sourceforge.net/projects/bio-bwa/files/bwakit/bwakit-$(BWAVERSION)_x64-linux.tar.bz2/download
	tar -xzvf $(PIPELINEPATH)/$(BINPATH)/bwakit-$(BWAVERSION)_x64-linux.tar.bz2 -C $(PIPELINEPATH)/$(BINPATH)/
	rm $(PIPELINEPATH)/$(BINPATH)/bwakit-$(BWAVERSION)_x64-linux.tar.bz2
	# GATK # https://software.broadinstitute.org/gatk/
	wget --output-document=$(PIPELINEPATH)/$(BINPATH)/GenomeAnalysisTK-$(GATKVERSION).tar.bz2 https://software.broadinstitute.org/gatk/download/auth?package=GATK
	tar -xzvf $(PIPELINEPATH)/$(BINPATH)/GenomeAnalysisTK-$(GATKVERSION).tar.bz2 -C $(PIPELINEPATH)/$(BINPATH)/
	rm $(PIPELINEPATH)/$(BINPATH)/GenomeAnalysisTK-$(GATKVERSION).tar.bz2
	mv $(PIPELINEPATH)/$(BINPATH)/GenomeAnalysisTK* $(PIPELINEPATH)/$(BINPATH)/GenomeAnalysisTK-$(GATKVERSION)
	#BOWTIE2
	# needs building
	#PICARD # http://broadinstitute.github.io/picard/
	wget https://github.com/broadinstitute/picard/releases/download/$(PICARDVERSION)/picard.jar
	mv picard.jar $(PIPELINEPATH)/$(BINPATH)/
	# symlinks for java tools
	#ln -s  $(PIPELINEPATH)/$(BINPATH)/GenomeAnalysisTK-$(GATKVERSION)/GenomeAnalysisTK.jar $(PIPELINEPATH)/$(BINPATH)/GenomeAnalysisTK.jar
  #BEDTOOLS
  
  

## Gather reference VCFs, liftover chains, etc
#resources: structure
	#https://www.ncbi.nlm.nih.gov/variation/docs/human_variation_vcf/


	
## Workflows 
scripts: structure
	# Get WDL scripts
	git clone https://github.com/nbsous/WDL-pipelines
	mv WDL-pipelines/*.wdl $(PIPELINEPATH)/$(WORKFLOWPATH)
	mv WDL-pipelines/*.json $(PIPELINEPATH)/$(WORKFLOWPATH)
	rm -rf WDL-pipelines/*
	# place R scripts in resources directory
	cp R-scripts/* $(PIPELINEPATH)/$(RESOURCESPATH)
  # rm -rf R-scripts/*




## MAKE ALL
all: structure tools scripts
	#resources