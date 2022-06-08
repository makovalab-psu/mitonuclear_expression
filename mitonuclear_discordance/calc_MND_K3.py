## November 10, 2020
## Calculate MN Discordance from GTEx global ancestry estimates produced by me.
# The mitonuclear discordance file has the ethnicity values wrong. Must check if the GTEx IDs are correct.

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats
import statistics
import seaborn as sns; sns.set(style="ticks", color_codes=True)

from Bio import SeqIO
import sys


# Import 
df_global_anc = pd.read_table('globalK3_NATMER_v8.txt', sep='\t', header=None)
df_global_anc.columns = ['pop','subject','global_as','global_eu','global_af']

# Need to wrangle the global ancestry estimates into this df.

## Use the *Mt-DNA haplogroups* from *GTEx* individuals.
df_mito = pd.read_table('ids_aa_ea_GTEx_v8.haplo', sep='\t', header=None)
df_mito.columns = ['subject','mito_haplo','self_rep']

df_mito_anc = pd.DataFrame.merge(df_mito,df_global_anc, on='subject')

## Make a dictionary with the necessary Mt-DNA ancestry.
# According to Zaidi et al. 2019, and Pipek et al. Nature 2019 (https://www.nature.com/articles/s41598-019-48093-5)
# They disagree on 'D' (NatAm vs Asian).
dict_mitohaplo = {
    'L':'African',
    'A':'NatAm',
    'B':'NatAm',
    'C':'NatAm',
    'D':'NatAm',
    'H':'European',
    'I':'European',
    'J':'European',
    'K':'European',
    'T':'European',
    'U':'European',
    'V':'European',
    'W':'European',
    'X':'European',
    'M':'Asian',
    'N':'Asian',
    'R':'Asian'
}

# Add MT-DNA ancestry using the dictionary.
df_mito_anc['mt_ancestry'] = df_mito_anc['mito_haplo'].map(dict_mitohaplo)

# Calculate mitonuclear discordance.
# Keep only necessary columns.
df_discord = df_mito_anc[['subject','self_rep','mito_haplo','mt_ancestry','global_af','global_eu','global_as']]


# Calculate mitonuclear discordance.
df_discord_af = df_discord[df_discord['mt_ancestry'] == 'African'].reset_index()
df_discord_af['mitonucl_discord'] = df_discord_af['global_eu'] + df_discord_af['global_as']

df_discord_eu = df_discord[df_discord['mt_ancestry'] == 'European'].reset_index()
df_discord_eu['mitonucl_discord'] = df_discord_eu['global_af'] + df_discord_eu['global_as']

df_discord_as = df_discord[(df_discord['mt_ancestry'] == 'Asian') | (df_discord['mt_ancestry'] == 'NatAm')].reset_index()
df_discord_as['mitonucl_discord'] = df_discord_as['global_af'] + df_discord_as['global_eu']


# Merge them back.
df_discord_final = pd.concat([df_discord_af,df_discord_eu,df_discord_as]).iloc[:,1:]


# `Export` the Mitonuclear Discordance estimates.
pd.DataFrame.to_csv(df_discord_final,"mitonuclearDiscordance_globalK3_GTExv8.txt", sep='\t')

# Plot the distribution of mitonuclear discordance values.
sns.displot(df_discord_final['mitonucl_discord'])
plt.xlim(0,1)
plt.xlabel("Mitonuclear discordance")
plt.ylabel('Number of Individuals')


