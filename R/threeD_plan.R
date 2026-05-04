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
  ),
  tar_target(
    name = prepare_fluxes_threeD,
    command = read_fluxes_threeD |>
      filter(
        grazing == "C"
        & Namount_kg_ha_y == 0
        & type %in% c("NEE", "ER")
        & is.na(par_correction)
      ) |>
      rename(
        treatment = "warming",
        plot_id = "turfID",
        carbon_type = "type",
        CO2_raw = "f_flux",
        PAR = "PAR_ave",
        chamber_temperature = "f_temp_air_ave",
        soil_temperature_5cm = "temp_soil_ave", # ours is at 2cm, but this is the closest they have
      ) |>
      mutate(
        treatment = case_when(
          treatment == "W" ~ "Warming",
          treatment == "A" ~ "Ambient"
        ),
        flux_date = date(date_time),
        flux_time = as_hms(date_time),
        flux_year = year(date_time),
        flux_doy = yday(date_time),
        carbon_type = case_when(
          carbon_type == "NEE" ~ "NEE",
          carbon_type == "ER" ~ "Reco"
        ),
        CO2_raw = f_flux * 1000, # convert from mmol/m2/h to umol/m2/h
        CO2_raw_unit = "umol/m2/h",
        CO2_raw_slope = "non-linear slope",
        flux_duration = if (flux_year == 2020) 120 else 180, # 120 seconds in 2020, 180 seconds in 2021
      )
  )
)