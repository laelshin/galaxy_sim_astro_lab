module step
 implicit none

contains
 subroutine step_leapfrog(x,v,a,m,ngal,np,dt)
  use poten
  integer, intent(in)    :: ngal,np
  real,    intent(inout) :: x(3,np), v(3,np), a(3,np)
  real,    intent(in)    :: m(np)
  real,    intent(in)    :: dt
  integer                :: i

  do i=1,np
    v(:,i) = v(:,i) + 0.5*dt*a(:,i)
    x(:,i) = x(:,i) + dt*v(:,i)
  enddo

  call get_accel(x,a,m,ngal,np)

  do i=1,np
    v(:,i) = v(:,i) + 0.5*dt*a(:,i)
  enddo

 end subroutine step_leapfrog

end module step
