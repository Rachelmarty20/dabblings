__author__ = 'rachel'

# Parse the random affinity files

import os
import sys
import pandas as pd
import time


def main():

    # define path names
    file_mutations = '/cellar/users/ramarty/Projects/hla_new/data/mutations/mutation_names.random.txt'
    affinities_directory = '/data/nrnb01/ramarty/hla/affinities_random'

    # get a list of all of the mutations
    with open(file_mutations) as f:
        # ensure that last letter is a letter!!!
        mutations = [mutation.strip() for mutation in f.readlines() if mutation.strip()[-1].isalpha()]

    # create a list of dataframes for each mutation list
    # TODO: remove restriction of first thousand
    all_mutation_dfs = []
    for mutation in mutations:
        try:
            print mutation
            all_mutation_dfs.append(get_min_affinities('{0}/{1}/all.affinities'.format(affinities_directory, mutation),
                                                       mutation))
        except:
            print "failed: ", mutation

    # concat all of the data frames and output to a file
    # TODO: we might get a weird extra numerical row... not sure why
    result = pd.concat(all_mutation_dfs, axis=1)
    result.to_csv('/cellar/users/ramarty/Projects/hla_new/data/affinities/all_affinities.random.csv')



#########################################   Helper Methods ##################################

# combine all ic50 scores into the method selected
def aggregate_ic50(x):
    method = x[0]
    ann_ic50 = x[1]
    smm_ic50 = x[2]
    netmhcpan_ic50 = x[3]
    if method == "Consensus (ann/smm)":
        return min(float(ann_ic50),float(smm_ic50))
    elif method == "netmhcpan":
        return float(netmhcpan_ic50)
    elif method == "smm":
        return float(smm_ic50)
    elif method == "ann":
        return float(ann_ic50)
    else:
        return "none"


# get the minimum ic50 from each peptide
def get_min_affinities(file, mutation):
    df = pd.read_csv(file, sep='\t')
    df = df[df['allele'] != 'allele']
    df['ic50'] = df[['method', 'ann_ic50', 'smm_ic50', 'netmhcpan_ic50']].apply(aggregate_ic50, axis=1)
    grouped = df.groupby('allele')
    new = pd.DataFrame(grouped['ic50'].min())
    new[mutation] = new['ic50']
    return new[[mutation]]



###########################################  Main Method  #####################################

if __name__ == "__main__":
    start_time = time.time()
    if len(sys.argv) != 1:
        sys.exit()
    sys.exit(main())
