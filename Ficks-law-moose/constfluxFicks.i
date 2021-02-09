

[Mesh]
  type = GeneratedMesh # Can generate simple lines, rectangles and rectangular prisms
  dim = 2 # Dimension of the mesh
  nx = 10 # Number of elements in the x direction
  ny = 10 # Number of elements in the y direction
  xmin = 0
  xmax = 1e-9
  ymin= 0
  ymax = 1e-9
[]

[Variables]
  [./c]
  [../]
[]

[ICs]
  [./c]
    type = ConstantIC
    variable = c
    value = 1
  [../]
[]

[BCs]
  [./right]
  type = NeumannBC #constant flux kg/s*m^2
  variable = c
  boundary = right
  value = 100
  [../]
[]


[Kernels]
  [./time]
    type=TimeDerivative
    variable = c
  [../]

  [./diff]
    type=MatDiffusion
    variable = c
    diffusivity = 1e-10
  [../]

[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  scheme = bdf2

  # Preconditioning using the additive Schwartz method and LU decomposition
  #petsc_options_iname = '-pc_type -sub_ksp_type -sub_pc_type'
  #petsc_options_value = 'asm      preonly       lu          '

  # Alternative preconditioning options using Hypre (algebraic multi-grid)
  #petsc_options_iname = '-pc_type -pc_hypre_type'
  #petsc_options_value = 'hypre    boomeramg'

  #l_tol = 1e-4

  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-8

  l_max_its = 30

  dt = 1e-12
  end_time = 1e-9
[]

[Outputs]
  exodus = true
  perf_graph = true
[]
