__author__ = 'rachel'

sys.path.insert(0, '/cellar/users/ramarty/programs/mhc_ii')

import os
import sys
import mhc_II_binding

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

for allele in mhc_alleles:
    infile = "/cellar/users/ramarty/Projects/hla_new/data/mutations/fasta_files/random/{1}.fsa".format(mutation)
    allele = allele.replace("_","-").replace("H-2","H2")
    method = "consensus3""
    seq = [('sequence_format', 'auto'), ('sort_output', 'position_in_sequence'), ('cutoff_type', 'none'), ('output_format', 'ascii'), ('allele', allele), ('sequence_file', infile), ('pred_method', method)]
    form = dict(seq)

    mhc_II_binding.main(form)
