###############################################################################################################
## Calculate Mitonuclear DNA Discordance using global ancestry estimates and mtDNA haplogroup for GTEx samples.
###############################################################################################################

# Python libraries.
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats
import statistics
import seaborn as sns; sns.set(style="ticks", color_codes=True)
from Bio import SeqIO
import sys


# Import global ancestry estimates (assuming K=2).
df_global_q = pd.read_table('GTEx_CEU_YRI_dataset.2.Q', sep='\t', header=None)
df_global_q.columns = ['pop','subject','global_af','global_eu']

# Import the IDs (.fam) matching the global ancestry file.
df_global_ids = pd.read_table('GTEx_CEU_YRI_dataset.fam', sep='\t', header=None)
df_global_ids.columns = ['pop','subject']

# Concatenate by columns: IDs to the global ancestry estimates.
df_global_anc = pd.concat([df_global_ids,df_global_q], axis=1)


## Import the mtDNA haplogroups from GTEx individuals (generated using HaploGrep).
df_mito = pd.read_table('GTEx_mtDNAhaplogroups.haplo', sep='\t', header=None)
df_mito.columns = ['subject','mito_haplo','self_rep']

# Merge mtDNA haplogroup with global ancestry estimates.
df_mito_anc = pd.DataFrame.merge(df_mito,df_global_anc, on='subject')


## Make a dictionary with the necessary mtDNA ancestry.
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

# Add mtDNA ancestry using the dictionary.
df_mito_anc['mt_ancestry'] = df_mito_anc['mito_haplo'].map(dict_mitohaplo)


# Keep only necessary columns.
df_discord = df_mito_anc[['subject','self_rep','mito_haplo','mt_ancestry','global_af','global_eu']]


# Calculate mitonuclear DNA discordance.
df_discord_af = df_discord[df_discord['mt_ancestry'] == 'African'].reset_index()
df_discord_af['mitonucl_discord'] = df_discord_af['global_eu']

df_discord_eu = df_discord[df_discord['mt_ancestry'] == 'European'].reset_index()
df_discord_eu['mitonucl_discord'] = df_discord_eu['global_af']


# Merge the final results.
df_discord_final = pd.concat([df_discord_af,df_discord_eu]).iloc[:,1:]


# Export the Mitonuclear Discordance estimates.
pd.DataFrame.to_csv(df_discord_final,"mitonuclearDiscordance_globalK2_GTExv8.txt", sep='\t')


# Plot the distribution of mitonuclear discordance values.
sns.displot(df_discord_final['mitonucl_discord'])
plt.xlim(0,1)
plt.xlabel("Mitonuclear discordance")
plt.ylabel('Number of Individuals')


