prepare_fluxes_threeD_fun <- function(read_fluxes_threeD) {
read_fluxes_threeD |>
      filter(
        "grazing" == "C"
        & "Namount_kg_ha_y" == 0
        & "type" %in% c("NEE", "ER")
        & is.na("par_correction")
      ) |>
      rename(
        treatment = "warming",
        plot_id = "turfID",
        carbon_type = "type",
        PAR = "PAR_ave",
        chamber_temperature = "f_temp_air_ave",
        soil_temperature_5cm = "temp_soil_ave", # ours is at 2cm, but this is the closest they have
      ) |>
      mutate(
        treatment = case_when(
          treatment == "W" ~ "others",
          treatment == "A" ~ "CTL"
        ),
        flux_date = date(date_time),
        flux_time = as_hms(date_time),
        flux_year = year(date_time),
        flux_doy = yday(date_time),
        carbon_type = case_when(
          carbon_type == "NEE" ~ "NEE",
          carbon_type == "ER" ~ "Rec"
        ),
        CO2_raw = f_flux * 1000 / 3600, # convert from mmol/m2/h to umol/m2/s
        CO2_raw_unit = "umol CO2 m-2 s-1",
        CO2_raw_slope = "non-linear slope",
        flux_duration = if (flux_year == 2020) 120 else 180, # 120 seconds in 2020, 180 seconds in 2021
      )
}