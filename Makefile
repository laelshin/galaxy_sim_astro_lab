FC=gfortran
FFLAGS=-O3
SRC=output.f90 utils.f90 poten.f90 init.f90 step.f90 main.f90
OBJ=${SRC:.f90=.o}

%.o: %.f90
	$(FC) $(FFLAGS) -o $@ -c $<

runsim: $(OBJ)
	$(FC) $(FFLAGS) -o $@ $(OBJ)

main.o: output.o utils.o poten.o init.o step.o

clean:
	@rm *.o *.mod runsim
	@echo 'cleaned files'
