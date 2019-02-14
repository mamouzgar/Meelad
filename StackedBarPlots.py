"""
Meelad Amouzgar

Stacked Bar Graph


This is an example for creating a stacked bar plot.
Use-case example of how the percent distribution of phenotypes differs for  different genes.
Each % of each phenotype for 1 gene is stacked on top of the other phenotype so that it adds to 100% distribution. 
This shows a clear visual representation of how certain phenotypes are distributed and allows for easy visual comparison to other genes.
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

plt.style.use('seaborn')

# Sample DataFrame
df = pd.DataFrame([['Bipolar, < 4 centrioles', 1.052631579, 0.0, 1.041666667, 2.43902439, 5.263157895], ['Bipolar, 4 centrioles', 92.63157895, 38.18181818, 58.33333333, 52.03252033, 70.17543859999999], ['Bipolar, >4 centrioles', 2.105263158, 36.36363636, 21.875, 30.89430894, 17.54385965], ['Multipolar, < 4 centrioles', 0.0, 0.0, 0.0, 0.0, 0.0], ['Multipolar, 4 centrioles', 0.0, 0.0, 0.0, 0.0, 0.0], ['Multipolar, >4 centrioles', 4.210526316, 25.45454545, 18.75, 14.63414634, 7.01754386]])
df.columns = ['phenotype','gene1','gene2','gene3','gene4','gene5'] 
df
# df = pd.read_csv('phenotypes.csv')


# Creates a dictionary where each row corresponds to the phenotype(KEY). 
# Each KEY corresponds to the % distribution (VALUES) of each gene for that phenotype.
genes_dict = {} 
for i in range(len(df.iloc[:,0])):
    genes_dict[df.iloc[i,0]] = df.iloc[i,1:]
genes_dict


# develop the bar container and assign the arguments for plt.bar() 
ax = plt.subplot(1,1,1) # create a subplot for the legend to be inserted next to the bar plot.
ind = np.arange(len(df.columns)-1) # Array containing x locations for each bar
width = 0.4  # the width of the bars

colors = ['greenyellow', 'limegreen','green','lightskyblue','dodgerblue','blue'] # list of specific colors for each phenotype

bar_stacks = pd.Series(0,index = ['gene1','gene2','gene3','gene4','gene5']) # empty Pandas series where the previous bar values are summed, stacking each phenotype (bar) on top of the previous.
bar_containers = [] # list containing the bars that create each genes information

for (key,i) in zip(genes_dict, range(len(colors))):
    bar_containers += plt.bar(ind, genes_dict[key], width, bottom = bar_stacks, color = colors[i] )
    bar_stacks = bar_stacks.add(genes_dict[key])
    
# label axes and legend
plt.title('oncogene spindle \n phenotype distributions', size = 20)
plt.ylabel('% of cells', size = 10)
plt.xticks(ind, ('PURO', 'HRAS', 'MYC', 'CYCD', 'AURKB'), size = 10)
plt.yticks(np.arange(0, 110, 10), size = 10)

box = ax.get_position()
ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])

ax.legend(df.iloc[:,0],
         bbox_to_anchor=(1, 0.5),loc=2, borderaxespad=0.,
         prop={'size': 10})

plt.show() 
