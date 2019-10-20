module output
 implicit none
 integer, private :: nfile = 1

 contains
  subroutine write_output(x,v,m,np,time,outdir)
   integer, intent(in) :: np
   real,    intent(in) :: x(3,np), v(3,np)
   real,    intent(in) :: m(np)
   real,    intent(in) :: time
   integer             :: i
   character(100)      :: filename,outdir
  
   write(filename,"(a,i5.5)") trim(outdir)//'snap_',nfile
   nfile = nfile + 1

   print "(a,f8.3)",' writing '//trim(filename)//' t = ',time
   open(unit=67,file=filename,status='replace')
   write(67,*) time
   do i=1,np
     write(67,*) x(:,i), v(:,i), m(i)
   enddo

   close(unit=67)

  end subroutine write_output

  subroutine write_params(ngal,m,e,rmin,thetadeg,nrings,ninner,dr,outdir)
   integer, intent(in) :: ngal,nrings(ngal),ninner(ngal)
   real, intent(in) :: rmin,dr(ngal)
   real, intent(in) :: m(ngal),e(ngal-1),thetadeg(ngal)
   character(100)   :: par_filename,outdir

   write(par_filename,"(a,i5.5)") trim(outdir)//'parameters.par'

   open(unit=68,file=par_filename,status='replace')
   write(68,*) ngal
   write(68,*) m
   write(68,*) e
   write(68,*) rmin
   write(68,*) thetadeg
   write(68,*) nrings
   write(68,*) ninner
   write(68,*) dr

   close(unit=68)
  end subroutine write_params
end module output
