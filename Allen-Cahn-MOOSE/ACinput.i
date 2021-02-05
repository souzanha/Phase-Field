
[Mesh]
  type = GeneratedMesh # Can generate simple lines, rectangles and rectangular prisms
  dim = 2 # Dimension of the mesh
  nx = 10 # Number of elements in the x direction
  ny = 10 # Number of elements in the y direction
  xmin = 0
  xmax = 100 # Length of test chamber
  ymin= 0
  ymax = 100 # Test chamber radius
[]

[Variables]
  [./eta]
  [../]
[]

[ICs]
  [./eta]
    type = MultiSmoothCircleIC #Random distribution of smooth circles with given minimum spacing
    variable = eta #The variable this initial condition is supposed to provide values for
    invalue = 1.000 #The variable value inside the circle
    outvalue = 0.000 #The variable value outside the circle
    bubspac = 0 #minimum spacing of bubbles, measured from center to center
    numbub = 12 #The number of bubbles to place
    radius = 10.0 #Mean radius value for the circles
    int_width = 1 #The interfacial width of the void surface. Defaults to sharp interface
    #radius_variation = 5 #Plus or minus fraction of random variation in the bubble radius for uniform, standard deviation for normal
    #radius_variation_type = uniform #Type of distribution that random circle radii will follow
  [../]
[]

[Kernels]
  [./eta]
    type =  TimeDerivative
    variable = eta
  []

  [./ACBulk]
    type = AllenCahn
    variable = eta
    f_name = F
    mob_name = 1.0
  [../]

  [./ACint]
  type = ACInterface
  variable = eta
  mob_name = 1.0
  kappa_name = 0.5
[../]
[]

[Materials]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = F
    args = 'eta'
    function = '2 * eta^2 * (1-eta)^2 - 0.2*eta'
    derivative_order = 2
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  scheme = bdf2

  # Preconditioning using the additive Schwartz method and LU decomposition
  petsc_options_iname = '-pc_type -sub_ksp_type -sub_pc_type'
  petsc_options_value = 'asm      preonly       lu          '

  # Alternative preconditioning options using Hypre (algebraic multi-grid)
  #petsc_options_iname = '-pc_type -pc_hypre_type'
  #petsc_options_value = 'hypre    boomeramg'

  l_tol = 1e-4
  l_max_its = 30

  dt = 1e-2
  end_time = 50

  [./Adaptivity]
    # Mesh adaptivity.
    initial_adaptivity = 2 # Number of times mesh is adapted to initial condition
    refine_fraction = 0.7 # Fraction of high error that will be refined
    coarsen_fraction = 0.1 # Fraction of low error that will coarsened
    max_h_level = 4 # Max number of refinements used, starting from initial mesh (before uniform refinement)
  [../]

[]

[Outputs]
  interval = 500
  exodus = true
  perf_graph = true
[]
