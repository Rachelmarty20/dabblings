
# coding: utf-8

# #Running Fisher's exact test without using affinities
# 
# ####We want to test if there is any correlation between hla type and somatic mutation

# In[1]:

import pandas as pd
import numpy as np
import scipy.stats as sp


# In[2]:

best_types = pd.read_csv('/cellar/users/ramarty/Projects/hla_new/data/typing_the_hla/best_types.csv', index_col=0)


# In[3]:

# need to change to singles 
types_a_1 = best_types[['Sample', 'A1']]
types_a_1.columns = ['Sample', 'Type']
types_a_2 = best_types[['Sample','A2']]
types_a_2.columns = ['Sample' , 'Type']
types_a = pd.concat([types_a_1, types_a_2])
types_a = types_a[types_a.Type != '-']
types_a = types_a[pd.notnull(types_a['Type'])]

types_b_1 = best_types[['Sample', 'B1']]
types_b_1.columns = ['Sample', 'Type']
types_b_2 = best_types[['Sample','B2']]
types_b_2.columns = ['Sample' , 'Type']
types_b = pd.concat([types_b_1, types_b_2])
types_b = types_b[types_b.Type != '-']
types_b = types_b[pd.notnull(types_b['Type'])]

types_c_1 = best_types[['Sample', 'C1']]
types_c_1.columns = ['Sample', 'Type']
types_c_2 = best_types[['Sample','C2']]
types_c_2.columns = ['Sample' , 'Type']
types_c = pd.concat([types_c_1, types_c_2])
types_c = types_c[types_c.Type != '-']
types_c = types_c[pd.notnull(types_c['Type'])]

# todo: remove the rows with NA
types = [types_a, types_b, types_c]


# In[9]:

types[0].head()


# In[4]:

mutations = pd.read_csv('/cellar/users/ramarty/Projects/hla_new/data/mutations/Variant.Result.2015-08-17.tsv',
                        sep='\t', skiprows=11)


# In[6]:

def combine(x):
    return x[0] + "_" + x[1]


# In[7]:

mutations2 = mutations[['Sample ID', 'HUGO symbol', 'Sequence ontology protein sequence change']]
mutations2.columns = ['Sample', 'gene', 'residue']
mutations2['Mutation'] = mutations2[['gene', 'residue']].apply(combine, axis=1)
mutations3 = mutations2[['Sample', 'Mutation']]
mutations3.head()


# In[10]:

# start by merging dataframes so we only keep the relevant samples
merged_a = pd.merge(types_a, mutations3, on='Sample', how='left')


# In[11]:

merged_a.head()


# In[43]:

from scipy import misc
def lamp_test(p_type, p_mut, total):
    significance = 0.05
    tests = 2503339*3
    sigma = float(significance)/float(tests)
    function = misc.comb(p_mut, p_type)/misc.comb(total, p_type)
    if sigma < function:
        return False
    else:
        return True


# In[44]:

grouped_both = merged_a.groupby(['Type', 'Mutation'])
grouped_mutation = merged_a.groupby('Mutation')
grouped_type = merged_a.groupby('Type')


# In[ ]:

results = []
types = merged_a.Type.unique()
muts = merged_a.Mutation.unique()
patients = merged_a.Sample.unique()

for type in types:
    for mutation in muts:
        try:
            p_type = list(grouped_type.get_group(type).Sample.unique())
            p_mut = list(grouped_mutation.get_group(mutation).Sample.unique())

            if lamp_test(len(p_type), len(p_mut), len(patients)): 
                p_non_type = [patient for patient in patients if patient not in p_type]
                p_wt = [patient for patient in patients if patient not in p_mut]

                one = len(grouped_both.get_group((type, mutation)))
                two = len(p_type) - one
                three = len(p_mut) - one
                four = len(p_wt) - two
                all_type = len(p_type) + len(p_non_type)
                all_mut = len(p_mut) + len(p_wt)

                oddsratio, pvalue = sp.fisher_exact([[one, two], [three, four]])
                results.append([type, mutation, oddsratio, pvalue, one, two, three, four, len(p_type), len(p_non_type),                     len(p_mut), len(p_wt), all_type, all_mut])
        except:
            None
        


# In[1]:

results_df = pd.Dataframe(results)


# In[ ]:

results_df.to_csv('/cellar/users/ramarty/Projects/hla_new/data/analysis/a_fisher.csv')

