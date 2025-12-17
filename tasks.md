# Implementation Task Checklist – Asphalt Emissions Choropleth

- [x] **Create project folders** (`data/`, `plots/`, `scripts/`).
- [ ] **Download R packages** (install via `pacman::p_load`).  
  - ✔️ Verify each package loads without error.
- [ ] **Write conditional download logic**:
  - Check existence of `AP_2018_State_County_Inventory.xlsx`.  
  - If missing → download in binary mode to `data/`.
- [ ] **Read “Output - State” sheet** with suppressed warnings.  
  - Use `.name_repair = "unique_quiet"` to avoid rename messages.
- [ ] **Select & clean columns**:
  - Keep only `State` and `Total kg/person`.  
  - Convert state names → lowercase for merging.  
  - Cast emissions column to numeric, suppress warnings.
- [ ] **Load US map data** via `usmap::us_map(resolution = "high")`.  
  - Rename the built‑in state column to `state_full`.
- [ ] **Merge emission data with map geometry**.  
  - Use left join on lower‑cased state name.  
  - Filter out rows where emissions are NA.
- [ ] **Create Plot**:
  - Initialize `ggplot` object on merged data.  
  - Add `geom_polygon()`:
    - Aesthetic mapping: `x = geom`, `group = state_fips`, `fill = total_kg_per_person`.  
    - Border colour `"grey30"` and `linewidth = 0.6`.  
  - Apply `scale_fill_gradient(low = "#1a9850", high = "#d73027")`.
- [ ] **Styling**:
  - Add title (`paste0("U.S. Asphalt Emissions (", year, ")")`).  
  - Subtitle describing dataset.  
  - Caption with citation & DOI.  
  - Use `theme_void()` + custom theme for white background and no axes.  
- [ ] **Save map**:
  - Ensure folder `plots/` exists (`make_folder()`).  
  - Call `ggsave(..., filename = "us_asphalt_2018.png")` with desired dimensions (12×9 in, 300 dpi).
- [ ] **Suppress informational messages** from `read_excel`.  
- [ ] **Print success message** after final save.  
- [ ] **Create markdown files**: `README.md`, `plan.md`, `tasks.md`, `walkthrough.md`.  
  - Populate them with required content (preview link, citation, structure section).  
- [ ] **Draft `.gitignore`**:
  - Exclude `.Rproj.user/`, `.Rhistory*`, `.RData*`, `*.html`, `*.aux`, etc.  
  - Keep `data/` and `plots/` under version control.
- [ ] **Test the whole workflow end‑to‑end** on a clean R session.  
    * Verify folder creation, download, read, merge, plot, save.  
    * Confirm PNG appears in correct location with expected colors and no axis labels.  
    * Run `git status` – only intended files tracked.
