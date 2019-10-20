module init
 use output
 implicit none
 real, parameter :: pi = 3.1415926536

contains
 subroutine initialize(x,v,m,ngal,np,maxp,outdir)
  integer, intent(in)  :: maxp
  integer, intent(out) :: ngal, np
  real,    intent(out) :: x(3,maxp), v(3,maxp)
  real,    intent(out) :: m(maxp)
  real                 :: a(maxp),e(maxp),r(maxp),thetadeg(maxp),theta(maxp),dr(maxp)
  real                 :: mtot,rmin,v0
  integer              :: i,k,nrings(maxp),ninner(maxp)
  character(100), intent(in) :: outdir       
  
  x = 0.    ! set all positions to zero
  v = 0.    ! all velocities to zero
  m = 0.    ! masses of all particles to zero

  write(6,1000)
  1000 format(' Enter number of galaxies (max 3)')
  read(5,*) ngal

  do while (ngal > 3)
    write(6,1001)
    1001 format(' Too many galaxies! Enter number of galaxies (max 3)')
    read(5,*) ngal
  enddo

  np = ngal

  write(6,1002)
  1002 format(' Enter masses')
  do i=1,ngal
    read(5,*) m(i)
  enddo

  write(6,1003)
  1003 format(' Enter eccentricities')
  do i=1,ngal-1
    read(5,*) e(i)
  enddo

  write(6,1004)
  1004 format(' Enter minimum separation (kpc) (>30 recommended)')
  read(5,*) rmin

  write(6,1005)
  1005 format(' Enter inclination angles (deg)')
  do i=1,ngal
    read(5,*) thetadeg(i)
  enddo
  
  theta = thetadeg*(pi/180.)    ! inclination angle
  a = rmin/(1. - e)
  r = a*(1. + e)    ! apastron distance
  
  x(1,1) = 0
  v(1,1) = 0
  do i=2,ngal
    mtot = m(1) + m(i)
    x(i-1,i) = r(i-1)    ! initial positions

    v0 = sqrt(a(i-1)*(1.-e(i-1)**2)*mtot)/r(i-1)
    v(mod(i,3),i) = v0    ! initial velocities
  enddo

  write(6,1006)
  1006 format(' Enter number of rings')
  do i=1,ngal
    read(5,*) nrings(i)
  enddo

  write(6,1007)
  1007 format(' Enter number of particles on inner ring')
  do i=1,ngal
    read(5,*) ninner(i)
  enddo

  write(6,1008)
  1008 format(' Enter ring spacing (kpc)')
  do i=1,ngal
    read(5,*) dr(i)
  enddo
  
  do i=1,ngal
    call add_galaxy(x,v,np,maxp,x(:,i),v(:,i),m(i),theta(i),nrings(i),ninner(i),dr(i))
  enddo
  
  call write_params(ngal,m,e,rmin,thetadeg,nrings,ninner,dr,outdir)

 end subroutine initialize

 subroutine add_galaxy(x,v,np,maxp,x0,v0,m0,theta,nrings,ninner,dr)
  integer, intent(in)    :: maxp
  real,    intent(out)   :: x(3,maxp), v(3,maxp)
  integer, intent(inout) :: np
  real,    intent(in)    :: x0(3),v0(3)
  real,    intent(in)    :: m0
  integer                :: nrings,ninner,nphi,j,i
  real                   :: dphi,dr,ri,phi,vphi,theta

  do j=1,nrings
    ri = j*dr
    nphi = ninner + (ninner/2)*(j-1) ! see toomre
    vphi = sqrt(m0/ri) ! keplerian rotation
    dphi = 2.*pi/nphi
    print*,'r = ',ri,' nphi = ',nphi,' dphi = ',dphi
    
    do i=1,nphi
      phi = (i-1)*dphi
      np = np + 1
      if (np > maxp) stop ' np > maxp: need bigger maxp'
      x(:,np) = x0 + (/ri*cos(phi)*cos(theta), ri*sin(phi), -ri*cos(phi)*sin(theta)/)
      v(:,np) = v0 + (/-vphi*sin(phi)*cos(theta), vphi*cos(phi), vphi*sin(phi)*sin(theta)/)
    enddo
  enddo
  print*,' set up ',np,' particles'
 end subroutine add_galaxy

end module init
