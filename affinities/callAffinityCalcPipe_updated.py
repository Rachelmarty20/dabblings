#! /usr/bin/env python

import sys
import itertools
from optparse import OptionParser
#from Bio import SeqIO

"""
Generate sge script to call mhc_i and netchop 3.1 in parallel
Inputs:  List of HLA alleles
         List of mutations
         Directory where protein fasta files are located
         Directory where results should be stored
Outputs: Affinity file with affinities for 
"""

class CmdOpts(object):
   usage="""%prog [options] -f <path to file> -a <path to file> -d <path to dir> -o <path to dir> -k <integer>

   Generate a file with commands to run affinity calculation pipeline
   
   -f file with gene-mutation pairs, 1 per line 
   -a file with HLA alleles, 1 per line
   -k kmer size (8,9 or 10)
   -d path to directory where fasta files are stored
   -o path to directory where outputs will be written

   Example:
      scripts/callAffinityCalcPipe -f  -a  -k -d -o  > run_affinity_pipe_sge.sh
   
   """
   def __init__(self):
      parser = OptionParser(usage=CmdOpts.usage)
      parser.add_option("-f", "--file", dest="mutationfile",
                        help="""File with gene mutation pairs, 1 pair per line""")
      parser.add_option("-a", "--alleles", dest="allelefile",
                        default="/scratch", help="""List of HLA alleles, 1 per line """)
      parser.add_option("-k", "--kmer", dest="kmersize",
                        default="10", help="""Size of kmer to consider """)
      parser.add_option("-d", "--datadir", dest="datadir",
                        help="""Directory where fasta files are stored """)
      parser.add_option("-o", "--output", dest="outputdir",
                        default="/scratch",help="""Directory where output files will be written """)
      parser.add_option("-p", "--python", dest="python_script",
                        default= "/cellar/users/ramarty/Projects/hla_new/scripts/affinities/call_mhci.sh")
      (opts, args) = parser.parse_args()

      if not opts.mutationfile or not opts.allelefile:
         parser.error("Incorrect input args")
      
      if opts.datadir.endswith("/"):
         opts.datadir = opts.dataloc[:-1]

      if opts.outputdir.endswith("/"):
         opts.outputdir = opts.outputdir[:-1]

      self.__dict__.update(opts.__dict__)


def main():
   
   opts = CmdOpts()

   # Read in mutations
   #f = file(opts.mutationfile,'r')
   #pairs = [x for x in f.readlines()]
   #pairs = [[x.strip().split("_")[0],x.strip().split("_")[1]] for x in f.readlines()]
   #f.close()
   
   # Read in hla alleles
   f = file(opts.allelefile,'r')
   hlalist = [x.strip() for x in f.readlines()]
   f.close()

   # Location where fasta files will be stored
   fadir = opts.datadir
   
   # Location where files will be saved
   destdir = opts.outputdir

   # Generate all combinations of mutation vs MHC allele
   #genes = []
   mutations = []
   alleles1 = []
   alleles2 = []
   for allele in hlalist:
     alleles1.append(allele.split("*")[0])
     alleles2.append(allele.split("*")[1])
     #genes.append(pair[0])

   # Output sge script      
   print "#! /bin/csh"
   print "#$ -S /bin/csh "
   print "#$ -o /data/nrnb01_nobackup/ramarty/sge-system-files"
   print "#$ -e /data/nrnb01_nobackup/ramarty/sge-system-files"
   print "#$ -cwd"
   print "#$ -t 1-" +  str(len(hlalist))
   print "#$ -l h_rt=08:00:00,h_vmem=1G"
   print "#$ -l long"
   print "#$ -p -11"
   print ""

   print "set hlas=(" + " ".join(alleles1) + ")"
   print "set nums=(" + " ".join(alleles2) + ")"
   print ""

   print "set hla=$hlas[$SGE_TASK_ID]"
   print "set num=$nums[$SGE_TASK_ID]"
   print ""

   print ""
   print "date"
   print "hostname"
   print ""
   print "bash /cellar/users/ramarty/Projects/hla_new/scripts/affinities/call_mhci.sh $hla $num "
   print "date"


if __name__ == "__main__":
   main()
