import matplotlib.pyplot as plt
import numpy

# Get data points (timestep and Force)
filename = 'Results/r01forceHist.txt'
timestamp = []
CT = []
with open(filename) as forceFile:
    for line in forceFile:
        # Handle empty lines and comments
        if line and (line[0][0] != '#'):
            data = line.split()
            timestamp.append(float(data[0].strip()))
            CT.append(float(data[1].strip()))

plt.plot(timestamp, CT, 'b')
plt.xlabel('Iteration')
plt.ylabel('CT')
plt.grid()

plt.show(block=True)
# input('Press Enter to exit')
