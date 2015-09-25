__author__ = 'rachel'

import os
import sys

#mutation = sys.argv[1]

# TODO: create a list of human mhc II alleles
file_mhc_alleles = '/cellar/users/ramarty/Projects/hla_new/data/affinities/mhc_ii_alleles.unique.txt'
affinities_directory = '/data/nrnb01/ramarty/hla/affinities_random_ii'
file_mutations = '/cellar/users/ramarty/Projects/hla_new/data/mutations/mutation_names.random.0_10000.txt'

with open(file_mhc_alleles) as f:
    mhc_alleles = [allele.strip() for allele in f.readlines()]

with open(file_mutations) as f:
    mutations = [allele.strip() for allele in f.readlines()]

for mutation in mutations:

    cmd = 'mkdir /data/nrnb01/ramarty/hla/affinities_random_ii/{0}'.format(mutation)
    os.system(cmd)
    print "trying"
    allele = mhc_alleles[0]
    cmd_1 = '/cellar/users/ramarty/programs/mhc_ii/mhc_II_binding.py IEDB_recommended {0} /cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/random/{1}.fsa > /data/nrnb01/ramarty/hla/affinities_random_ii/{2}/all.affinities'.format(allele, mutation, mutation)
    print cmd_1
    os.system(cmd_1)



    for allele in mhc_alleles[1:]:
        cmd_2 = '/cellar/users/ramarty/programs/mhc_ii/mhc_II_binding.py IEDB_recommended {0} /cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/random/{1}.fsa >> /data/nrnb01/ramarty/hla/affinities_random_ii/{2}/all.affinities'.format(allele, mutation, mutation)
        print cmd_2
        os.system(cmd_2)


    print mutation
