incline_plan <- list(
  tar_target(
    name = import_fluxes_incline_2022,
    command = get_file(
      node = "zhk3m",
      file = "INCLINE_c-flux_2022.csv",
      path = "data",
      remote_path = "C-Flux"
    ),
    format = "file"
    ),
  tar_target(
    name = import_incline_metadata,
    command = get_file(
      node = "zhk3m",
      file = "INCLINE_metadata.csv",
      path = "data",
      remote_path = "RawData"
    ),
    format = "file"
    ),
    tar_target(
        name = read_incline_metadata,
        command = read_csv2(import_incline_metadata, show_col_types = FALSE)
    ),
    tar_target(
        name = read_fluxes_incline_2022,
        command = read_csv(import_fluxes_incline_2022, show_col_types = FALSE)
    ),
    tar_target(
        name = prepare_fluxes_incline,
        command = prepare_fluxes_incline_fun(read_fluxes_incline_2022, read_incline_metadata)
    ),
    tar_target(
        name = output_fluxes_incline,
        command = write_csv(prepare_fluxes_incline, "data/incline_fluxes_tundrafluxready.csv")
))