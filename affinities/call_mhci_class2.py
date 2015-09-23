__author__ = 'rachel'

import os
import sys

mutation = sys.argv[1]

# TODO: create a list of human mhc II alleles
file_mhc_alleles = '/cellar/users/ramarty/Projects/hla_new/data/affinities/human_MHC_alleles_uniq.ii.unique.txt'
affinities_directory = '/data/nrnb01/ramarty/hla/affinities_random_ii'

with open(file_mhc_alleles) as f:
    mhc_alleles = [allele.strip() for allele in f.readlines()]

print "trying"
allele = mhc_alleles[0]
cmd = '/cellar/users/ramarty/programs/mhc_ii/mhc_II_binding.py IEDB_recommended {0} /cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/random/{1}.fsa > /data/nrnb01/ramarty/hla/affinities_random/{1}/all.affinities'.format(allele, mutation)
os.system(cmd)


for allele in mhc_alleles[1:]:
    cmd = '/cellar/users/ramarty/programs/mhc_ii/mhc_II_binding.py IEDB_recommended {0} /cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/random/{1}.fsa >> /data/nrnb01/ramarty/hla/affinities_random/{1}/all.affinities'.format(allele, mutation)
    os.system(cmd)
