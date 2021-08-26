import pandas as pd
import numpy as np

import sys

def save_failed_het(path):
    het = pd.read_table(file,delim_whitespace=True)
    het['rate'] = (het['N(NM)'] - het["O(HOM)"]) / het["N(NM)"]
    m = het['rate'].mean() 
    std = het['rate'].std()
    success = het[np.logical_or(het['rate'] <= (m+3*std),het['rate']>= (m-3*std))]
    np.savetxt(f'{path}/EUR.valid.sample', success[['FID','IID']].values, fmt='%d')

if __name__ == "__main__":
    file = sys.argv[1]
    print(file)
    save_failed_het(file)