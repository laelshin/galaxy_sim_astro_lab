import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.animation as animation
import pandas as pd
import os

datadir = input("Data directory (format: inputs/ or inputs\)\n ")
while not os.path.isdir(datadir):
    print(datadir + " is not a directory or does not exist")
    datadir = input("Data directory (format: inputs/ or inputs\)\n ")
while ('\\' not in datadir) and ('/' not in datadir):
    print("Directory name must contain / or \\")
    datadir = input("Data directory (format: inputs/ or inputs\)\n ")
dtout, tmax = input("Interval between snapshots, and animation run time (space separated)\n ").split(' ')
dtout = float(dtout)
tmax = float(tmax)

print("Plotting animation...")

nsnaps = int(tmax / dtout)

xyzdata = np.array([[0,0,0]])
time = []
#Read in and combine data
for i in range(1,nsnaps+1):
    newsnap = [line.rstrip('\n').split() for line in open(datadir+'snap_'+'0'*(5-len(str(i)))+str(i))]
    time.append([float(newsnap[0][0])]*(len(newsnap)-1))
    newsnap = np.array(newsnap[1:])
    newsnap = newsnap.astype(np.float)
    newxyz = newsnap[:,0:3]
    xyzdata = np.concatenate((xyzdata,newxyz))

a = xyzdata[1:]
t = [i/dtout for snap in time for i in snap]    # normalize time for smoother animation
df = pd.DataFrame({"time": t ,"x" : a[:,0], "y" : a[:,1], "z" : a[:,2]})
print(df)

def update_graph(num):
    data=df[df['time']==num]
    graph.set_data (data.x, data.y)
    graph.set_3d_properties(data.z)
    physt = 1.5 * dtout * num # physical time. t=1 corresponds to 1.5 Myr
    if physt < 100:
        physt = round(1.5 * dtout * num, 1)
        tscale = 'time={} Myr'
    else:
        physt = round(1.5 * dtout * num / 1e3, 2)
        tscale = 'time={} Gyr'
    title.set_text(tscale.format(physt))
    return title, graph,

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
title = ax.set_title('')
ax.set_xlabel('x (kpc)')
ax.set_ylabel('y (kpc)')
ax.set_zlabel('z (kpc)')

limquery = input("Set manual limits? (default=no)\n ")
if limquery == 'yes':
    autolim = False
    xmin, xmax = [float(x) for x in input("xmin and xmax (space separated)\n ").split(' ')]
    ymin, ymax = [float(y) for y in input("ymin and ymax (space separated)\n ").split(' ')]
    zmin, zmax = [float(z) for z in input("zmin and zmax (space separated)\n ").split(' ')]
else:
    autolim = True

if autolim:
    autolimx = np.mean(a[:,0])
    autolimy = np.mean(a[:,1])
    autolimz = np.mean(a[:,2])
    ax.set_xlim([-autolimx,autolimx])
    ax.set_ylim([-autolimy,autolimy])
    ax.set_zlim([-autolimz,autolimz])
elif not autolim:
    ax.set_xlim([xmin,xmax])
    ax.set_ylim([ymin,ymax])
    ax.set_zlim([zmin,zmax])

data=df[df['time']==0]
graph, = ax.plot(data.x, data.y, data.z, linestyle="", marker=".", markersize=1, color="b")

ani = animation.FuncAnimation(fig, update_graph, int(tmax/dtout), 
                               interval=40, blit=True)

try:
    # TODO: account for any number of galaxies
    params = [line.rstrip('\n').split() for line in open(datadir+'parameters.par')]
    print('No. of galaxies =',params[0][0])
    print('Masses =',params[1][0],params[1][1],params[1][2])
    print('Eccentricities (wrt central galaxy) =',params[2][0],params[2][1])
    print('Minimum separation (kpc) =',params[3][0])
    print('Inclination angles (deg) =',params[4][0],params[4][1],params[4][2])
    print('No. of rings =',params[5][0],params[5][1],params[5][2])
    print('No. of particles on inner ring =',params[6][0],params[6][1],params[6][2])
    print('Spacing between rings (kpc) =',params[7][0],params[7][1],params[7][2])
except:
    print("No parameters file")

plt.show()

savequery = input("Save animation to file? (requires ffmpeg or imagemagick, default=no)\n ")
if savequery == 'yes':
    backend = input("Choose backend (ffmpeg for .mp4 or imagemagick for .gif)\n ")
    while (backend != 'ffmpeg') and (backend != 'imagemagick'):
        print("Invalid backend!")
        backend = input("Choose backend (ffmpeg for .mp4 or imagemagick for .gif)\n ")
    save_filename = input("Save filename\n ")
    print("Saving animation...")
    if backend == "ffmpeg":
        br = 1800
    else:
        br = 800
    Writer = animation.writers[backend]
    writer = Writer(fps=24, bitrate=br)
    ani.save(save_filename, writer=writer)

print("Done.")

