prepare_fluxes_threeD_fun <- function(read_fluxes_threeD) {
read_fluxes_threeD |>
      filter(
        grazing == "C"
        & Namount_kg_ha_y == 0
        & type %in% c("NEE", "ER")
        & is.na(par_correction)
        & !is.na(f_flux)
      ) |>
      rename(
        plot_id = "turfID",
        carbon_type = "type",
        site_name = "origSiteID"
      ) |>
      mutate(
        PAR = round(PAR_ave, 2),
        chamber_temperature = round(f_temp_air_ave, 2),
        soil_temperature_5cm = round(temp_soil_ave, 2), # ours is at 2cm, but this is the closest they have
        treatment = case_when(
          warming == "W" ~ "others",
          warming == "A" ~ "CTL"
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
        flux_duration = case_when(
          flux_year == 2020 ~ 120,
          flux_year == 2021 ~ 180
        ),
        measurment_method = "Manual closed static/non-steady state chamber",
        machine = "LICOR",
        machine_type = "IR", # Li-840A is IRGA, and more recent LI are laser just need to remember for other datasets
        time_of_measurement = "Daytime", # what about the diurnals?
        `experimental treatment` = "Other treatment", #transplant
        plot_size_m2 = 0.5 * 0.5,
        flux_plot_size_m2 = 0.25 * 0.25,
        flux_measurement_start_year = 2020,
        warming_start_year = 2019,
        latitude = case_when(
          site_name == "Joasete" ~ 60.86183,
          site_name == "Liahovden" ~ 60.85994
        ),
        longitude = case_when(
          site_name == "Joasete" ~ 7.16800,
          site_name == "Liahovden" ~ 7.19504
        ),
        altitude_m = case_when( # not sure how to deal with transplant. This is the elevation of the orig site
          site_name == "Joasete" ~ 920,
          site_name == "Liahovden" ~ 1290
        ),
        mean_annual_precipitation = case_when(
          site_name == "Joasete" ~ 1256,
          site_name == "Liahovden" ~ 2089 
        ),
        PI_contact = "Aud H Halbritter",
        PI_email = "aud.halbritter@uib.no",
        add_contact_1 = "Joseph Gaudard",
        email_1 = "joseph.gaudard@pm.me",
        Institue = "University of Bergen",
        Reference = "Halbritter et al. 2026, SciDat. https://doi.org/10.1038/s41597-025-06503-6"
      )
}