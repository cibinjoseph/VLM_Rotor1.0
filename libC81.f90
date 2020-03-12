module libC81
  use libMath 
  implicit none

  ! Define C81 class
  type C81_class
    character(len=30) :: airfoilName
    integer :: ML, NL, MD, ND, MM, NM
    real(dp), allocatable, dimension(:) :: MaL, MaD, MaM
    real(dp), allocatable, dimension(:) :: AL, AD, AM
    real(dp), allocatable, dimension(:,:) :: CL, CD, CM
  contains
    procedure :: writefile
    procedure :: readfile
    procedure :: getCL
    procedure :: getCD
    procedure :: getCM
  end type C81_class

contains

  ! Writes data arrays to C81 file
  subroutine writefile(this,C81filename)
  class(C81_class) :: this
    character(len=*), intent(in) :: C81filename
    integer :: i, j
    integer :: stat
    character(len=10) :: formatChar
    character(len=1) :: overwriteOption

    open(unit=10,file=C81filename, status='new', action='write', iostat=stat)
    if (stat>0) then
      print*, 'File '//trim(C81filename)//' already exists!'
      write(*,'(A)',advance='no') ' Okay to overwrite (y/n)? '
      read(*,*) overwriteOption
      print*
      if (overwriteOption .ne. 'y') stop
    endif

    this%ML = size(this%MaL,1)
    this%MD = size(this%MaD,1)
    this%MM = size(this%MaM,1)
    this%NL = size(this%AL,1)
    this%ND = size(this%AD,1)
    this%NM = size(this%AM,1)

    write(10,100) this%airfoilName,this%ML,this%NL,this%MD,this%ND,this%MM,this%NM
    ! Lift
    write(10,101) (this%MaL(i),i=1,min(9,this%ML))
    if (this%ML>9) then 
      write(formatChar,'(A4,I1,A5)') '(7X,',this%ML-9,'F7.3)'
      write(10,formatChar) (this%MaL(i),i=10,this%ML)
    endif
    do i=1,this%NL
      write(10,102) this%AL(i), (this%CL(i,j),j=1,min(9,this%ML))
      if (this%ML>9)  write(10,formatChar) (this%CL(i,j),j=10,this%ML)
    enddo

    ! Drag
    write(10,101) (this%MaD(i),i=1,min(9,this%MD))
    if (this%MD>9) then 
      write(formatChar,'(A4,I1,A5)') '(7X,',this%MD-9,'F7.3)'
      write(10,formatChar) (this%MaD(i),i=10,this%MD)
    endif
    do i=1,this%ND
      write(10,102) this%AD(i), (this%CD(i,j),j=1,min(9,this%MD))
      if (this%MD>9)  write(10,formatChar) (this%CD(i,j),j=10,this%MD)
    enddo

    ! Moment
    write(10,101) (this%MaM(i),i=1,min(9,this%MM))
    if (this%MM>9) then 
      write(formatChar,'(A4,I1,A5)') '(7X,',this%MM-9,'F7.3)'
      write(10,formatChar) (this%MaM(i),i=10,this%MM)
    endif
    do i=1,this%NM
      write(10,102) this%AM(i), (this%CM(i,j),j=1,min(9,this%MM))
      if (this%MM>9)  write(10,formatChar) (this%CM(i,j),j=10,this%MM)
    enddo

    close(10)

    100 format (A30,6I2)
    101 format (7X,9F7.3)
    102 format (F7.2,9F7.3)
  end subroutine writefile

  ! Reads from C81 file to allocatable arrays
  subroutine readfile(this,C81filename)
  class(C81_class) :: this
    character(len=*), intent(in) :: C81filename
    integer :: i, j
    integer :: stat
    character(len=10) :: formatChar

    open(unit=10, file=C81filename, status='old', action='read', iostat=stat)
    if (stat>0) then
      print*, 'ERROR: '//trim(C81filename)//' file not found'
      error stop
    endif

    read(10,100) this%airfoilName,this%ML,this%NL,this%MD,this%ND,this%MM,this%NM
    allocate(this%MaL(this%ML))
    allocate(this%MaD(this%MD))
    allocate(this%MaM(this%MM))
    allocate(this%AL(this%NL))
    allocate(this%AD(this%ND))
    allocate(this%AM(this%NM))
    allocate(this%CL(this%NL,this%ML))
    allocate(this%CD(this%ND,this%MD))
    allocate(this%CM(this%NM,this%MM))

    ! Lift
    read(10,101) (this%MaL(i),i=1,min(9,this%ML))
    if (this%ML>9) then 
      write(formatChar,'(A4,I1,A5)') '(7X,',this%ML-9,'F7.0)'
      read(10,formatChar) (this%MaL(i),i=10,this%ML)
    endif
    do i=1,this%NL
      read(10,102) this%AL(i), (this%CL(i,j),j=1,min(9,this%ML))
      if (this%ML>9)  read(10,formatChar) (this%CL(i,j),j=10,this%ML)
    enddo

    ! Drag
    read(10,101) (this%MaD(i),i=1,min(9,this%MD))
    if (this%MD>9) then 
      write(formatChar,'(A4,I1,A5)') '(7X,',this%MD-9,'F7.0)'
      read(10,formatChar) (this%MaD(i),i=10,this%MD)
    endif
    do i=1,this%ND
      read(10,102) this%AD(i), (this%CD(i,j),j=1,min(9,this%MD))
      if (this%MD>9)  read(10,formatChar) (this%CD(i,j),j=10,this%MD)
    enddo

    ! Moment
    read(10,101) (this%MaM(i),i=1,min(9,this%MM))
    if (this%MM>9) then 
      write(formatChar,'(A4,I1,A5)') '(7X,',this%MM-9,'F7.0)'
      read(10,formatChar) (this%MaM(i),i=10,this%MM)
    endif
    do i=1,this%NM
      read(10,102) this%AM(i), (this%CM(i,j),j=1,min(9,this%MM))
      if (this%MM>9)  read(10,formatChar) (this%CM(i,j),j=10,this%MM)
    enddo

    close(10)

    100 format (A30,6I2)
    101 format (7X,9F7.0)
    102 format (10F7.0)
  end subroutine readfile

  ! Returns value of 2-d interpolated CL
  ! for given alphaQuery and machQuery queries
  function getCL(this,alphaQuery,machQuery)
  class(C81_class) :: this
    real(dp), intent(in) :: alphaQuery, machQuery
    real(dp) :: getCL
    integer, dimension(2) :: alphaIndx, machIndx

    alphaIndx = getInterval(this%AL,alphaQuery)
    machIndx = getInterval(this%MaL,machQuery)

    if (alphaIndx(1) .eq. alphaIndx(2)) then
      if (machIndx(1) .eq. machIndx(2)) then
        getCL = this%CL(alphaIndx(1),machIndx(1))
      else
        getCL = this%CL(alphaIndx(1),machIndx(1))+ &
          (machQuery-this%MaL(machIndx(1))) * &
          (this%CL(alphaIndx(1),machIndx(2))-this%CL(alphaIndx(1),machIndx(1)))/ &
          (this%MaL(machIndx(2))-this%MaL(machIndx(1)))
      endif
    elseif (machIndx(1) .eq. machIndx(2)) then
      getCL = this%CL(alphaIndx(1),machIndx(1))+ &
        (alphaQuery-this%AL(alphaIndx(1))) * &
        (this%CL(alphaIndx(2),machIndx(1))-this%CL(alphaIndx(1),machIndx(1)))/ &
        (this%AL(alphaIndx(2))-this%AL(alphaIndx(1)))
    else
      getCL = getBilinearInterp(alphaQuery,machQuery, &
        (/this%AL(alphaIndx(1)),this%AL(alphaIndx(2))/), &
        (/this%MaL(machIndx(1)),this%MaL(machIndx(2))/), &
        this%CL(alphaIndx(1),machIndx(1)), &
        this%CL(alphaIndx(1),machIndx(2)), &
        this%CL(alphaIndx(2),machIndx(1)), &
        this%CL(alphaIndx(2),machIndx(2)))
    endif
  end function getCL

  ! Returns value of 2-d interpolated CD
  ! for given alphaQuery and machQuery queries
  function getCD(this,alphaQuery,machQuery)
  class(C81_class) :: this
    real(dp), intent(in) :: alphaQuery, machQuery
    real(dp) :: getCD
    integer, dimension(2) :: alphaIndx, machIndx

    alphaIndx = getInterval(this%AD,alphaQuery)
    machIndx = getInterval(this%MaD,machQuery)

    if (alphaIndx(1) .eq. alphaIndx(2)) then
      if (machIndx(1) .eq. machIndx(2)) then
        getCD = this%CD(alphaIndx(1),machIndx(1))
      else
        getCD = this%CD(alphaIndx(1),machIndx(1))+ &
          (machQuery-this%MaD(machIndx(1))) * &
          (this%CD(alphaIndx(1),machIndx(2))- &
          this%CD(alphaIndx(1),machIndx(1)))/ &
          (this%MaD(machIndx(2))-this%MaD(machIndx(1)))
      endif
    elseif (machIndx(1) .eq. machIndx(2)) then
      getCD = this%CD(alphaIndx(1),machIndx(1))+ &
        (alphaQuery-this%AD(alphaIndx(1))) * &
        (this%CD(alphaIndx(2),machIndx(1))- &
        this%CD(alphaIndx(1),machIndx(1)))/ &
        (this%AD(alphaIndx(2))-this%AD(alphaIndx(1)))
    else
      getCD = getBilinearInterp(alphaQuery,machQuery, &
        (/this%AD(alphaIndx(1)),this%AD(alphaIndx(2))/), &
        (/this%MaD(machIndx(1)),this%MaD(machIndx(2))/), &
        this%CD(alphaIndx(1),machIndx(1)), &
        this%CD(alphaIndx(1),machIndx(2)), &
        this%CD(alphaIndx(2),machIndx(1)), &
        this%CD(alphaIndx(2),machIndx(2)))
    endif
  end function getCD

  ! Returns value of 2-d interpolated CM
  ! for given alphaQuery and machQuery queries
  function getCM(this,alphaQuery,machQuery)
  class(C81_class) :: this
    real(dp), intent(in) :: alphaQuery, machQuery
    real(dp) :: getCM
    integer, dimension(2) :: alphaIndx, machIndx

    alphaIndx = getInterval(this%AM,alphaQuery)
    machIndx = getInterval(this%MaM,machQuery)

    if (alphaIndx(1) .eq. alphaIndx(2)) then
      if (machIndx(1) .eq. machIndx(2)) then
        getCM = this%CM(alphaIndx(1),machIndx(1))
      else
        getCM = this%CM(alphaIndx(1),machIndx(1))+ &
          (machQuery-this%MaM(machIndx(1))) * &
          (this%CM(alphaIndx(1),machIndx(2))- &
          this%CM(alphaIndx(1),machIndx(1)))/ &
          (this%MaM(machIndx(2))-this%MaM(machIndx(1)))
      endif
    elseif (machIndx(1) .eq. machIndx(2)) then
      getCM = this%CM(alphaIndx(1),machIndx(1))+ &
        (alphaQuery-this%AM(alphaIndx(1))) * &
        (this%CM(alphaIndx(2),machIndx(1))- &
        this%CM(alphaIndx(1),machIndx(1)))/ &
        (this%AM(alphaIndx(2))-this%AM(alphaIndx(1)))
    else
      getCM = getBilinearInterp(alphaQuery,machQuery, &
        (/this%AM(alphaIndx(1)),this%AM(alphaIndx(2))/), &
        (/this%MaM(machIndx(1)),this%MaM(machIndx(2))/), &
        this%CM(alphaIndx(1),machIndx(1)), &
        this%CM(alphaIndx(1),machIndx(2)), &
        this%CM(alphaIndx(2),machIndx(1)), &
        this%CM(alphaIndx(2),machIndx(2)))
    endif
  end function getCM

  ! Returns upper and lower indices of a 1-d sorted array 
  ! using binary search in which a search value lies 
  function getInterval(A,x) result(indx)
    real(dp), intent(in), dimension(:) :: A
    real(dp), intent(in) :: x
    integer, dimension(2) :: indx  ! Left and right indices 
    integer :: n, i

    n = size(A,1)
    indx(1) = 1
    indx(2) = n

    ! Binary search algorithm
    do while ((indx(1) .ne. indx(2)) .and. (indx(2) .ne. (indx(1)+1)))
      i = floor((indx(1)+indx(2))*0.5)
      if (x < A(i)) then
        indx(2) = i
      elseif (x > A(i)) then
        indx(1) = i
      else
        indx(1) = i
        indx(2) = i
      endif
    enddo

    ! Check end cases
    if (abs(A(indx(1))-x) .le. epsilon(1.)) then
      indx(2) = indx(1)
    elseif (abs(A(indx(2))-x) .le. epsilon(1.)) then
      indx(1) = indx(2)
    endif
  end function getInterval

  ! Get bilinearly interpolated values at (x,y)
  function getBilinearInterp(x,y,xvec,yvec,f11,f12,f21,f22)
    real(dp), intent(in) :: x, y
    real(dp), intent(in), dimension(2) :: xvec, yvec
    real(dp), intent(in) :: f11, f12, f21, f22
    real(dp) :: getBilinearInterp
    real(dp), dimension(2,2) :: fMat

    fMat(1,:) = (/f11,f12/)
    fMat(2,:) = (/f21,f22/)

    getBilinearInterp = dot_product((/xvec(2)-x,x-xvec(1)/),matmul(fMat,(/yvec(2)-y,y-yvec(1)/)))
    getBilinearInterp = getBilinearInterp/(xvec(2)-xvec(1))/(yvec(2)-yvec(1))

  end function getBilinearInterp

  ! Gets data from csv formatted file
  function getTable(filename,rows,cols)
    character(len=*), intent(in) :: filename
    integer, intent(in) :: rows, cols
    integer :: i, j
    integer :: stat
    real(dp), dimension(rows,cols) :: getTable

    open(unit=10, file=filename, status='old', action='read', iostat=stat)
    if (stat>0) then
      print*, 'ERROR: '//trim(filename)//' file not found'
      error stop 
    endif
    do i=1,rows
      read(10,*) (getTable(i,j),j=1,cols)
    enddo
    close(10)
    end function getTable

end module libC81
