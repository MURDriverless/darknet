'''
Author: Steven Lee

Python script to plot precision-recall curve using the output from darknet
https://github.com/AlexeyAB/darknet/issues/3236

Usage: python3 plot_pr_curve.py /path/to/darknet/output.txt

Note that the resulting precision-recall curve will be placed in a `output`
directory.
'''

import re
import argparse
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
import seaborn as sns


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('output_path', type=str,
                        help='path to the output txt file')
    args = parser.parse_args()
    
    with open(args.output_path) as f:
        lines = f.readlines()
        
        # prepare list of numpy arrays
        # 1 list for x values (recall)
        # 1 list for y values (precision)
        x = []
        y = []
        cur_class = 0
        
        recall = []
        precision = []
        
        for l in lines:
            # line example:
            # ['class_id = 2', ' point = 44', ' cur_recall = 0.4400', ' cur_precision = 0.9861 \n']
            l_split = l.split(',')
            
            if "class_id" in l_split[0] and "point" in l_split[1]:
                vals = re.findall(r'[\d\.\d]+', l)
                class_id = vals[0]
                point = vals[1]
                cur_recall = vals[2]
                cur_precision = vals[3]
                
                # print(class_id, point, cur_recall, cur_precision)
                
                if int(class_id) == cur_class:
                    recall.append(float(cur_recall))
                    precision.append(float(cur_precision))
                else:
                    cur_class = int(class_id)
                    x.append(recall)
                    y.append(precision)
                    recall = []
                    precision = []
                
                if class_id == '2' and point == '100':
                    x.append(recall)
                    y.append(precision)
                    break
    
    # start plotting using the collected values
    sns.set()
    colours = ['b', 'darkorange', 'gold']
    labels = ['Blue Cone', 'Orange Cone', 'Yellow Cone']
    
    # Can use tex formatting
    # plt.rc('text', usetex=True)
    # plt.rcParams['text.latex.preamble'] = [r"\usepackage{amsmath}"]
    
    for idx, _ in enumerate(x):
        plt.plot(x[idx], y[idx], '-', color=colours[idx], label=labels[idx])
    
    # add labels and legends
    plt.xlabel('Recall')
    plt.ylabel('Precision')
    plt.legend(loc="lower left")
    
    # use percentage representation for x y axes
    ax = plt.gca()
    ax.xaxis.set_major_formatter(mtick.PercentFormatter(1.0))
    ax.yaxis.set_major_formatter(mtick.PercentFormatter(1.0))
    
    plt.show()
