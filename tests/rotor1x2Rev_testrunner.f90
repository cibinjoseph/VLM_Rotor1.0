program rotor1x2Rev_testrunner
  use rotor1x2Rev_test
  integer :: exit_code

  call testsuite_initialize()

  call setup()
  call test_coords()
  call test_aic()
  call test_force_gamma()

  call testsuite_summary()
  call testsuite_finalize(exit_code)
  call exit(exit_code)
end program rotor1x2Rev_testrunner
