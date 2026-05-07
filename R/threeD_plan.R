threeD_plan <- list(
  tar_target(
    name = import_fluxes_threeD,
    command = {
      download_zenodo(
      doi = "10.5281/zenodo.17301125",
      path = "data/",
      files = "xiii_Three-D_clean_co2_fluxes_2020-2021.csv"
    )
    file.path("data", "xiii_Three-D_clean_co2_fluxes_2020-2021.csv") # because download zenodo doesn't return the path to the file, we need to specify it here for the target
  },
    format = "file"
  ),
  # tar_target(
  #   name = raw_fluxes_threeD,
  #   command = "data/xiii_Three-D_clean_co2_fluxes_2020-2021.csv",
  #   format = "file"
  # ),
  tar_target(
    name = read_fluxes_threeD,
    command = read_csv(import_fluxes_threeD, show_col_types = FALSE)
  ),
  tar_target(
    name = prepare_fluxes_threeD,
    command = prepare_fluxes_threeD_fun(read_fluxes_threeD)
  ),
  tar_target(
    name = import_fluxes_PFTC6,
    command = get_file(
      node = "fcbw4",
      file = "PFTC6_clean_GlobalChangeExperiment_cflux_2022.csv",
      path = "data",
      remote_path = "v. c_flux_data"
    ),
    format = "file"
  ),
  # tar_target(
  #   name = raw_fluxes_PFTC6,
  #   command = "data/PFTC6_clean_GlobalChangeExperiment_cflux_2022.csv",
  #   format = "file"
  # ),
  tar_target(
    name = read_fluxes_PFTC6,
    command = read_csv(import_fluxes_PFTC6, show_col_types = FALSE)
  ),
  tar_target(
    name = prepare_fluxes_PFTC6,
    command = prepare_fluxes_PFTC6_fun(read_fluxes_PFTC6)
  ),
  tar_target(
    name = gather_fluxes_threeD_PFTC6,
    command = bind_rows(prepare_fluxes_threeD, prepare_fluxes_PFTC6)
  ),
  tar_target(
    name = output_fluxes_threeD,
    command = gather_fluxes_threeD_PFTC6 |>
      select(
        treatment,
        plot_id,
        flux_date,
        flux_time,
        flux_year,
        flux_doy,
        carbon_type,
        CO2_raw,
        CO2_raw_unit,
        CO2_raw_slope,
        PAR,
        soil_temperature_5cm,
        chamber_temperature,
        flux_duration_min,
        measurment_method,
        machine,
        machine_type,
        time_of_measurement,
        `experimental treatment`,
        plot_size_m2,
        flux_plot_size_m2,
        flux_measurement_start_year,
        warming_start_year,
        site_name,
        latitude,
        longitude,
        altitude_m,
        mean_annual_precipitation,
        PI_contact,
        PI_email,
        add_contact_1,
        email_1,
        Institue,
        Reference
      ) |>
      write_csv("data/threeD_fluxes_tundrafluxready.csv")
  )
)