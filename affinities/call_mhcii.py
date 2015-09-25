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

mut_dir = '/data/nrnb01/ramarty/hla/affinities_random_ii/{0}'.format(mutation)
try:
    os.mkdir(mut_dir)
except:
    print "directory exists"


with open("/data/nrnb01/ramarty/hla/affinities_random_ii/{0}/all.affinities".format(mutation)) as outfile:
    allele = mhc_alleles[0]
    cmd = "/cellar/users/ramarty/programs/mhc_ii/mhc_II_binding.py consensus3 {0} /cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/random/{1}.fsa".format(allele, mutation)
    # IEDB_recommended '{0}' /cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/random/{1}.fsa > /data/nrnb01/ramarty/hla/affinities_random_ii/{1}/all.affinities".format(allele, mutation)"
    cmd_list = cmd.split()
    print cmd_list
    subprocess.call(cmd_list, stdout=outfile)


    cmd = "/cellar/users/ramarty/programs/mhc_ii/mhc_II_binding.py consensus3 '{0}' /cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/random/{1}.fsa > /data/nrnb01/ramarty/hla/affinities_random_ii/{1}/all.affinities".format(allele, mutation)
    cmd_list = cmd.split()
    print cmd_list
    subprocess.call(cmd_list, stdout=outfile)

    print "one done"

    for allele in mhc_alleles[1:]:
    cmd = '/cellar/users/ramarty/programs/mhc_ii/mhc_II_binding.py consensus3 {0} /cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/random/{1}.fsa >> /data/nrnb01/ramarty/hla/affinities_random_ii/{1}/all.affinities'.format(allele, mutation)
    cmd_list = cmd.split()
    subprocess.call(cmd_list, stdout=outfile)
