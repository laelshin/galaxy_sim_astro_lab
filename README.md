# galaxy-sim

Just a fun little numerical N-body disk galaxy collision simulation.

Easiest way to install is by entering

`$ git clone https://github.com/astro-kris/galaxy-sim.git`

on the command line. Once inside the directory, simply type `make` to compile the code and then type `./runsim` and follow the prompts (see below for requirements).

The galaxies are constructed with a central (point) mass, representing the bulge, surrounded by a series of concentric rings of non-interacting massless particles undergoing simple Keplerian rotation. The program allows you to alter various parameters of up to four galaxies, including the:

* central mass
* number of rings of each galaxy
* number particles per ring of each galaxy
* initial distances
* initial velocities
* inclination angles

![Here's a galaxy](milky-way.gif)

Example of a lone Milky Way analog.

As well as the physical parameters you can also choose the calculation time step, the time step between which the coordinates update, and total integration time.

![Example with three galaxies on a collision course](triple-collision.gif)

Boom.

## requirements

The simulation code assumes gfortran as the compiler, though of course you can change this by editing the Makefile if required.

The Python plotting script that comes with the code requires the `numpy`, `matplotlib`, and `pandas` external packages.

Have fun destroying some galaxies! :)
