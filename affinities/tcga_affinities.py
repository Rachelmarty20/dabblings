__author__ = 'rachel'

import pandas as pd


mutated = pd.read_csv('/cellar/users/ramarty/Projects/hla_new/data/affinities/all_affinities.mutated.csv',
                     index_col=0)

trans_mutated = mutated.transpose()

merged = pd.read_csv('/cellar/users/ramarty/Projects/hla_new/data/mutations/sample_type_mutation_df.csv',
                     index_col=0)

# maybe I can just add a column to merged
def add_affinity(x):
    hla_type = 'HLA-'+str(x[0])
    mutation = x[1]
    try:
        return mutated.loc[hla_type, mutation]
    except:
        return '-'

merged['affinity'] = merged[['Type', 'Mutation']].apply(add_affinity, axis=1)

merged.to_csv('/cellar/users/ramarty/Projects/hla_new/data/mutations/sample_type_mutation_affinity_df.csv')