prepare_fluxes_PFTC6_fun <- function(read_fluxes_PFTC6) {
read_fluxes_PFTC6 |>
      filter(
        type %in% c("NEE", "ER", "GPP")
        & !is.na(flux_value)
      ) |>
      rename(
        plot_id = "turfID",
        carbon_type = "type",
        site_name = "origSiteID",
        flux_time = "time"
      ) |>
      mutate(
        PAR = round(PARavg, 2),
        chamber_temperature = round(temp_airavg, 2),
        soil_temperature_5cm = round(temp_soil, 2), # ours is at 2cm, but this is the closest they have
        treatment = case_when(
          warming == "W" ~ "others",
          warming == "A" ~ "CTL"
        ),
        flux_date = date(datetime),
        flux_year = year(datetime),
        flux_doy = yday(datetime),
        carbon_type = case_when(
          carbon_type == "NEE" ~ "NEE",
          carbon_type == "ER" ~ "Rec",
          carbon_type == "GPP" ~ "GPP"
        ),
        CO2_raw = flux_value * 1000 / 3600, # convert from mmol/m2/h to umol/m2/s
        CO2_raw_unit = "umol CO2 m-2 s-1",
        CO2_raw_slope = "non-linear slope",
        flux_duration_min = 3,
        measurment_method = "Manual closed static/non-steady state chamber",
        machine = "LICOR",
        machine_type = "IR", # Li-840A is IRGA, and more recent LI are laser just need to remember for other datasets
        time_of_measurement = "Daytime", # what about the diurnals? dirunals are done like daytime (cover for ER, transparent chamber for NEE) so we mark it as daytime
        `experimental treatment` = "Other treatment", #transplant
        plot_size_m2 = 0.5 * 0.5,
        flux_plot_size_m2 = 0.25 * 0.25,
        flux_measurement_start_year = 2020,
        warming_start_year = 2019,
        latitude = case_when(
          site_name == "Joasete" ~ 60.86183,
          site_name == "Liahovden" ~ 60.85994,
          site_name == "Hogsete" ~ 	60.8760,
          site_name == "Vikesland" ~ 60.8802
        ),
        longitude = case_when(
          site_name == "Joasete" ~ 7.16800,
          site_name == "Liahovden" ~ 7.19504,
          site_name == "Hogsete" ~ 7.1766,
          site_name == "Vikesland" ~ 7.1699
        ),
        altitude_m = case_when( # not sure how to deal with transplant. This is the elevation of the orig site
          site_name == "Joasete" ~ 920,
          site_name == "Liahovden" ~ 1290,
          site_name == "Hogsete" ~ 700,
          site_name == "Vikesland" ~ 469
        ),
        mean_annual_precipitation = case_when(
          site_name == "Joasete" ~ 1256,
          site_name == "Liahovden" ~ 2089,
          site_name == "Hogsete" ~ 1432,
          site_name == "Vikesland" ~ 1292
        ),
        PI_contact = "Aud H Halbritter",
        PI_email = "aud.halbritter@uib.no",
        add_contact_1 = "Joseph Gaudard",
        email_1 = "joseph.gaudard@pm.me",
        Institue = "University of Bergen",
        Reference = "Vandvik et al. 2025, SciDat, https://doi.org/10.1038/s41597-025-05509-4"
      )
}