threeD_plan <- list(
  tar_target(
    name = import_fluxes_threeD,
    command = download_zenodo(
      doi = "10.5281/zenodo.17301125",
      path = "data/",
      files = "xiii_Three-D_clean_co2_fluxes_2020-2021.csv"
    ), type = "file"
  ),
  tar_target(
    name = read_fluxes_threeD,
    command = read_csv(import_fluxes)
  )
)