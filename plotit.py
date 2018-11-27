#!/usr/bin/python
# code to quickly plot wake, tip, lift and drag curves using VisIt

import visit
import argparse
import signal, os, sys
from subprocess import call
from time import sleep

# Functions to be invoked for asynchronous keyboard signals ctrl+Z and ctrl+C
def ctrlZ_func(signum, frame):
    print('Reloading plots...')
    os.execl(sys.executable, 'python', __file__, *sys.argv[1:])  # Rerun code

def ctrlC_func(signum, frame):
    try:
        os.remove('visitlog.py')
    except OSError:
        pass
    print('Program exit...')  # Exit program
    sys.exit(0)

# Attach signal to the respective signal handlers (functions)
signal.signal(signal.SIGTSTP, ctrlZ_func)
signal.signal(signal.SIGINT, ctrlC_func)

# Define input arguments
parser = argparse.ArgumentParser(
        description = ('Visualize plots using visit'), 
        epilog = 'Author: Cibin Joseph')
parser.add_argument('-w', '--wake', help='Plot wake structure', action = 'store_true')
parser.add_argument('-f', '--force', help='Plot rotor force', action = 'store_true')
parser.add_argument('-s', '--span', help='Plot blade force', action = 'store_true')
parser.add_argument('-i', '--inflow', help='Plot blade inflow', action = 'store_true')
parser.add_argument('-t', '--tip', help='Plot wake tip', action = 'store_true')
parser.add_argument('-p', '--panel', help='Plot wing alone', action = 'store_true')
parser.add_argument('-g', '--gamma', help='Plot gamma sectional', action = 'store_true')
parser.add_argument('-l', '--lift', help='Plot lift', action = 'store_true')
parser.add_argument('-d', '--drag', help='Plot drag', action = 'store_true')

args = parser.parse_args()

src_plot_dir = 'src_plot'

if args.wake == True:
    filename = 'plot_wake.py'

if args.force == True:
    filename = 'plot_force.py'

if args.span == True:
    filename = 'plot_forceDist.py'

if args.inflow == True:
    filename = 'plot_inflow.py'

elif args.tip == True:
    filename = 'plot_tip.py'

elif args.panel == True:
    filename = 'plot_panel.py'

elif args.gamma == True:
    filename = 'plot_gamma.py'

elif args.lift == True:
    filename = 'plot_lift.py'
    if os.path.exists('Results/lift.curve') == False:
        print('Waiting for file creation...') 
    while os.path.exists('Results/lift.curve') == False:
        sleep(1)

elif args.drag == True:
    filename = 'plot_drag.py'
    if os.path.exists('Results/drag.curve') == False:
        print('Waiting for file creation...') 
    while os.path.exists('Results/drag.curve') == False:
        print('Waiting for file creation...') 
        sleep(1)

else:
    # print('Error: Wrong input arguments')
    # raise ValueError 
    filename = 'plot_wake.py'  # Assume -w flag by dfault


call(['visit', '-np', '4', '-s', '{}/{}'.format(src_plot_dir, filename)])
try:
    os.remove('visitlog.py')
except OSError:
    pass
