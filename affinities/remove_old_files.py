import os
import sys

file_mhc_alleles = '/cellar/users/ramarty/Projects/hla_new/data/affinities/human_MHC_alleles_uniq.txt'
file_mutations = '/cellar/users/ramarty/Projects/hla_new/data/mutations/mutation_names.random.txt'
affinities_directory = '/data/nrnb01/ramarty/hla/affinities_random/'

with open(file_mhc_alleles) as f:
    mhc_alleles = [allele.strip() for allele in f.readlines()]
with open(file_mutations) as f:
    mutations = [mutation.strip() for mutation in f.readlines()]


for index, mutation in enumerate(mutations):
    for allele in mhc_alleles:
        try:
            os.remove('{0}/{1}/{2}.affinities'.format(affinities_directory, mutation, allele))
        except:
            None
            #print "no file" + '{0}/{1}/{2}.affinities'.format(affinities_directory, mutation, allele)
    print index


