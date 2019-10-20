module poten
 implicit none

contains
 subroutine get_accel(x,a,m,ngal,np)
  integer, intent(in)  :: ngal
  integer, intent(in)  :: np
  real,    intent(in)  :: x(3,np)
  real,    intent(out) :: a(3,np)
  real,    intent(in)  :: m(ngal)
  real                 :: dx(3)
  real                 :: r2, r
  integer              :: i,j

  a = 0.    ! set all accelerations to zero
  do i=1,np
    do j=1,ngal
      if (j /= i) then    ! to avoid division by zero
        dx = x(:,i) - x(:,j)
        r2 = dot_product(dx,dx)
        r = sqrt(r2)
        a(:,i) = a(:,i) - m(j) * dx / (r**3)
      endif
    enddo
  enddo

 end subroutine get_accel

 real function potential(x,m,ngal,np)
  integer, intent(in) :: ngal
  integer, intent(in) :: np
  real,    intent(in) :: x(3,np)
  real,    intent(in) :: m(np)
  real                :: dx(3)
  real                :: phi, r
  integer             :: i, j

  potential = 0.
  do i=1,ngal
    phi = 0.
    do j=i+1,ngal
      dx = x(:,i) - x(:,j)
      r = sqrt(dot_product(dx,dx))
      phi = phi - m(j)/r
    enddo
    potential = potential + m(i)*phi
  enddo

 end function potential

end module poten
