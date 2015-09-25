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

output = []
for allele in mhc_alleles:
    cmd = "/cellar/users/ramarty/programs/mhc_ii/mhc_II_binding.py consensus3 {0} /cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/random/{1}.fsa".format(allele, mutation)
    # IEDB_recommended '{0}' /cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/random/{1}.fsa > /data/nrnb01/ramarty/hla/affinities_random_ii/{1}/all.affinities".format(allele, mutation)"
    cmd_list = cmd.split()
    try:
        output.append(subprocess.check_output(cmd_list))
        print allele
        print subprocess.check_output(cmd_list)
    except:
        print "fail: ", allele

print len(output)

#print "/data/nrnb01/ramarty/hla/affinities_random_ii/{0}/all.affinities".format(mutation)
with open("/data/nrnb01/ramarty/hla/affinities_random_ii/{0}/all.affinities".format(mutation), 'w') as outfile:
    print output
    outfile.write(output)