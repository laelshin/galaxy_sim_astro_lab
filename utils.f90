module utils
  implicit none
contains
  subroutine cross_product(a,b,c)
    real, intent(in)  :: a(3), b(3)
    real, intent(out) :: c(3)

    c(1)=a(2)*b(3) - a(3)*b(2)
    c(2)=a(3)*b(1) - a(1)*b(3)
    c(3)=a(1)*b(2) - a(2)*b(1)

  end subroutine cross_product
end module utils 
