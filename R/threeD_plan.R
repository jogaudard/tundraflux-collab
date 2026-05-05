threeD_plan <- list(
  tar_target(
    name = import_fluxes_threeD,
    command = download_zenodo(
      doi = "10.5281/zenodo.17301125",
      path = "data/",
      files = "xiii_Three-D_clean_co2_fluxes_2020-2021.csv"
    ),
    format = "file"
  ),
  tar_target(
    name = read_fluxes_threeD,
    command = read_csv(import_fluxes_threeD)
  ),
  tar_target(
    name = prepare_fluxes_threeD,
    command = prepare_fluxes_threeD_fun(read_fluxes_threeD)
  ),
  tar_target(
    name = output_fluxes_threeD,
    command = prepare_fluxes_threeD |>
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
        flux_duration
      ) |>
      write_csv("data/threeD_fluxes_tundrafluxready.csv"),
    format = "file"
  )
)