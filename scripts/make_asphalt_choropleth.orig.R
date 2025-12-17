# --------------------------------------------------------------
# Title:   Create a U.S. states choropleth of asphalt emissions (2018)
# Author:  Your Name
# Date:    2025‑11‑03
# --------------------------------------------------------------

## ---- Packages -------------------------------------------------
# Use pacman so that packages are installed automatically if missing
if (!requireNamespace("pacman", quietly = TRUE)) {
  install.packages("pacman")
}
suppressPackageStartupMessages({
  pacman::p_load(
    "ggplot2",
    "usmap",          # provides us_map()
    "readxl",         # read Excel files
    "dplyr",
    "here",           # for tidy folder/file paths
    "readr"           # write CSV/TSV if needed (already in base)
  )
})

## ---- Helper functions -----------------------------------------

# Create a folder if it does not exist
make_folder <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)
}

## ---- Ensure data folder exists -----------------------------------
data_dir   <- here::here("data")
plot_dir   <- here::here("plots")
make_folder(data_dir)
make_folder(plot_dir)

## ---- Conditional download of the Excel file ----------------------
excel_path <- file.path(data_dir, "AP_2018_State_County_Inventory.xlsx")

if (!file.exists(excel_path)) {
  url <- "https://pasteur.epa.gov/uploads/10.23719/1531683/AP_2018_State_County_Inventory.xlsx"
  # binary mode download
  download.file(url, destfile = excel_path, mode = "wb")
  message("✅ Downloaded Excel file to ", excel_path)
} else {
  message("ℹ️  Excel file already present – skipping download.")
}

## ---- Read the \"Output - State\" sheet ----------------------------
# Suppress warnings from readxl when converting factor → numeric
suppressWarnings({
  raw_data <- suppressMessages(
    readxl::read_excel(path = excel_path,
                       sheet = "Output - State",
                       .name_repair = "unique_quiet")
  )
})

## ---- Keep only required columns ------------------------------------
state_emissions <- raw_data %>%
  dplyr::select(State, `Total kg/person`) %>%
  # Convert Total kg/person to numeric (some rows may be factors)
  dplyr::mutate(
    `Total kg/person` = suppressWarnings(as.numeric(`Total kg/person`))
  ) %>%
  # Clean up spaces in column names
  dplyr::rename(state_name_raw = State,
                total_kg_per_person = `Total kg/person`) %>%
  # Convert state names to lower case for easier matching later
  dplyr::mutate(state_name_lc = tolower(state_name_raw))

## ---- Load US states shapefile ------------------------------------
# usmap returns an sf object (geom column holds polygons)
us_map_df <- usmap::us_map(resolution = "high") %>%
  # Keep only the 'state' column which contains full state names
  dplyr::rename(state_full = state)

## ---- Merge emissions data with map data ---------------------------
# Convert both state identifiers to lower case for a robust join
merged_df <- us_map_df %>%
  dplyr::left_join(
    state_emissions,
    by = c("state_full" = "state_name_lc")
  ) %>%
  # Remove rows that could not be matched (e.g., territories)
  dplyr::filter(!is.na(total_kg_per_person))

## ---- Build the choropleth ----------------------------------------
p <- ggplot2::ggplot(data = merged_df) +
  ggplot2::geom_polygon(
    aes(x = geom,               # geometry column supplied by usmap
        y = "",                   # dummy to keep syntax happy
        group = state_fips),      # unique identifier for each polygon
    color = "grey30",
    fill = "white",              # default background; will be overridden per tile
    linewidth = 0.6               # equivalent of `size` in newer ggplot2
  ) +
  # Color fill based on emissions
  ggplot2::scale_fill_gradient(
    low   = "#1a9850",   # dark green (low)
    high  = "#d73027",   # vivid red (high)
    na.value = "grey90",
    name  = "Total kg/person"
  ) +
  # Apply fill to polygons
  ggplot2::guides(fill = ggplot2::guide_legend(
    title.position = "top",
    title.hjust = 0.5,
    override.aes = list(colour = "black", linewidth = 1)
  )) +
  # Background & theme tweaks
  ggplot2::theme_void() +                # removes all axes, ticks, etc.
  ggplot2::theme(
    plot.title    = ggplot2::element_text(hjust = 0.5, face = "bold", size = 18),
    plot.subtitle = ggplot2::element_text(hjust = 0.5, size = 14, colour = "grey30"),
    plot.caption  = ggplot2::element_text(hjust = 0, size = 10, colour = "grey30"),
    legend.position = "right",
    legend.title    = ggplot2::element_text(face = "bold")
  ) +
  # Manually set fill based on our computed column
  ggplot2::aes(fill = total_kg_per_person) +
  ggplot2::scale_fill_gradient(
    low   = "#1a9850",
    high  = "#d73027",
    na.value = "grey90"
  ) +
  # Add title, subtitle and caption
  ggplot2::labs(
    title      = paste0("U.S. Asphalt Emissions (", format(Sys.Date(), "%Y"), ")"),
    subtitle   = "Total kilograms of asphalt emitted per person, 2018",
    caption    = paste0(
      "Source: EPA – *Anthropogenic secondary organic aerosol and ozone production from ",
      "asphalt‑related emissions*, Environ. Sci.: Atmos., 2023,3, 1221-1230. DOI: ",
      "<https://doi.org/10.1039/D3EA00066D>"
    )
  )

## ---- Save as PNG -------------------------------------------------
png_path <- file.path(plot_dir, "us_asphalt_2018.png")
ggplot2::ggsave(
  filename = png_path,
  plot     = p,
  width    = 12, height = 9, units = "in", dpi = 300
)

message("✅ Map saved to ", png_path)
