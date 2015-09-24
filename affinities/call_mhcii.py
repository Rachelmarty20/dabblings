__author__ = 'rachel'

import os
import sys

mutation = sys.argv[1]

file_mhc_alleles = '/cellar/users/ramarty/Projects/hla_new/data/affinities/mhc_ii_alleles.unique.txt'
affinities_directory = '/data/nrnb01/ramarty/hla/affinities_random_ii'

with open(file_mhc_alleles) as f:
    mhc_alleles = [allele.strip() for allele in f.readlines()]

allele = mhc_alleles[0]
cmd = '/cellar/users/ramarty/programs/mhc_i/src/predict_binding.py IEDB_recommended {0} /cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/random/{1}.fsa > /data/nrnb01/ramarty/hla/affinities_random_ii/{1}/all.affinities'.format(allele, mutation)
os.system(cmd)


for allele in mhc_alleles[1:]:
    cmd = '/cellar/users/ramarty/programs/mhc_i/src/predict_binding.py IEDB_recommended {0} /cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/random/{1}.fsa >> /data/nrnb01/ramarty/hla/affinities_random_ii/{1}/all.affinities'.format(allele, mutation)
    os.system(cmd)
