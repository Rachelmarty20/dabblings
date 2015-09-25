__author__ = 'rachel'

import os
import sys
import time
import subprocess

mutation = sys.argv[1]

file_mhc_alleles = '/cellar/users/ramarty/Projects/hla_new/data/affinities/mhc_ii_alleles.unique.txt'
affinities_directory = '/data/nrnb01/ramarty/hla/affinities_random_ii'

with open(file_mhc_alleles) as f:
    mhc_alleles = [allele.strip() for allele in f.readlines()]

allele = mhc_alleles[0]

with open("/data/nrnb01/ramarty/hla/affinities_random_ii/{0}/all.affinities".format(mutation), 'w') as outfile:

    cmd = "python /cellar/users/ramarty/programs/mhc_ii/mhc_II_binding.py consensus3 {0} /cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/random/{1}.fsa".format(allele, mutation)
    outfile.write(cmd+"\n")

    for allele in mhc_alleles[1:]:
        cmd = "python /cellar/users/ramarty/programs/mhc_ii/mhc_II_binding.py consensus3 {0} /cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/random/{1}.fsa".format(allele, mutation)
        outfile.write(cmd+"\n")