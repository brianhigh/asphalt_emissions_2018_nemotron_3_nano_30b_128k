# --------------------------------------------------------------
# Create a U.S. states choropleth of asphalt emissions (2018)
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
  dplyr::mutate(state = tolower(state_name_raw))

## ---- Build the choropleth ----------------------------------------
p <- plot_usmap(data = state_emissions, values = "total_kg_per_person") +
  # Color fill based on emissions
  scale_fill_gradient2(
    low = "darkgreen",
    mid = "yellow",
    high = "red",
    midpoint = median(state_emissions$total_kg_per_person, na.rm = TRUE),
    name = "Total kg/person"
  )  +
  # Background & theme tweaks
  ggplot2::theme_void() +                # removes all axes, ticks, etc.
  ggplot2::theme(
    plot.title    = ggplot2::element_text(hjust = 0.5, face = "bold", size = 18),
    plot.subtitle = ggplot2::element_text(hjust = 0.5, size = 14, colour = "grey30"),
    plot.caption  = ggplot2::element_text(hjust = 0, size = 10, colour = "grey30"),
    legend.position = "bottom",
    legend.title    = ggplot2::element_text(face = "bold")
  ) +
  # Add title, subtitle and caption
  ggplot2::labs(
    title      = paste0("U.S. Asphalt Emissions (2018)"),
    subtitle   = "Total kilograms of asphalt emitted per person",
    caption    = paste0(
      "Source: Anthropogenic secondary organic aerosol and ozone production from ",
      "asphalt‑related emissions,\nEnviron. Sci.: Atmos., 2023,3, 1221-1230. DOI: ",
      "https://doi.org/10.1039/D3EA00066D"
    )
  )

## ---- Save as PNG -------------------------------------------------
png_path <- file.path(plot_dir, "us_asphalt_2018.png")
ggplot2::ggsave(
  filename = png_path,
  plot     = p,
  width    = 12, height = 9, units = "in", dpi = 300,
  bg = "white" # Explicitly set background for PNG
)

message("✅ Map saved to ", png_path)
