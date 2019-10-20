program nbody
 use init
 use poten
 use utils
 use step
 use output
 implicit none
 integer, parameter :: maxp=10000
 real               :: x(3, maxp), v(3, maxp), a(3, maxp)
 real               :: m(maxp)
 real               :: mom(3), angmom(3)
 real               :: e, tmax, time, en, dt, dtout
 integer            :: i, nsteps, ngal, np, nout
 character(100)     :: outdir,plotquery

 write(6,1001)
 1001 format(' Output directory (will create if does not exist, format output/ or output\)')
 read(*,'(A)') outdir
 call system('mkdir '//trim(outdir))
 
 call initialize(x,v,m,ngal,np,maxp,outdir)
 call get_accel(x,a,m,ngal,np)

 write(6,1002)
 1002 format(' Enter timestep, interval between snapshots, and total integration time (recommended ~0.01,~10,~5000)')
 read(5,*) dt,dtout,tmax

 nsteps = int(tmax/dt) + 1
 nout = nint(dtout/dt)

 do i=1,nsteps
  call step_leapfrog(x,v,a,m,ngal,np,dt)
  time = i*dt
  if (mod(i,nout).eq.0) call write_output(x, v, m, np, time, outdir)
 enddo

 write(6,1003)
 1003 format('Plot?')
 read(5,*) plotquery

 if (plotquery == 'yes') then
   call system('python plot-sim.py')
 endif

end program nbody
