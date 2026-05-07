prepare_fluxes_incline_fun <- function(read_fluxes_incline_2022, read_incline_metadata) {
      
      read_fluxes_incline_2022 |>
        left_join(read_incline_metadata) |>
      filter(
        treatment == "C"
        & type %in% c("NEE", "GPP")
        & is.na(par_correction)
      ) |>
      mutate(
    date = date(f_datetime),
    OTC = str_replace_all(OTC, c("C" = "CTL", "W" = "OTC")),
    ITEX_ID = case_when(
      siteID == "Lavisdalen" ~ "NOR_9",
      siteID == "Gudmedalen" ~ "NOR_11",
      siteID == "Ulvehaugen" ~ "NOR_10",
      siteID == "Skjellingahaugen" ~ "NOR_12"
    ),
    f_flux = f_flux * 0.04401 # they want g CO2 / m2 / h
  ) |>
  select(plotID, siteID, date, OTC, temp_soil_ave, f_flux, f_temp_air_ave, ITEX_ID,  f_RMSE, PAR_ave, type) |>
  rename(
    treatment = "OTC",
    RMSE = "f_RMSE",
    flux = "f_flux",
    temp_airavg = "f_temp_air_ave",
    temp_soilavg = "temp_soil_ave"
  ) |>
  drop_na(date, flux) |>
  pivot_wider(names_from = "type", values_from = "flux") |>
  arrange(ITEX_ID) |>
  relocate(ITEX_ID, date, treatment, plotID, NEE, GPP, RMSE, temp_airavg, temp_soilavg, siteID)
}