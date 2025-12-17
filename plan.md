# Project Plan – Asphalt Emissions Choropleth (EPA State County Inventory)

**Goal** – Create a visual choropleth of U.S. states using EPA’s 2018 asphalt emissions data, saved as PNG under `plots/`.

## 1. Environment Setup  
| Step | Action |
|------|--------|
| 1️⃣   | Install R (≥4.2) and RStudio (optional). |
| 2️⃣   | Create a project folder (`my-asphalt-map`). |
| 3️⃣   | Inside the repo, create subfolders: `data/`, `plots/`, `scripts/`. |
| 4️⃣   | Save `make_asphalt_chloropleth.R` inside `scripts/`. |

## 2. Packages & Dependencies  
| Package | Reason |
|---------|--------|
| `pacman` | Auto‑install if missing, manageload order |
| `readxl` | Read Excel `.xlsx` files |
| `here`   | Clean path handling across OS |
| `usmap`  | Provides U.S. state shapefiles (sf) |
| `ggplot2`| Plotting & choropleth construction |
| `dplyr`  | Data manipulation |

*Installation command:*  

```r
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(readxl, usmap, ggplot2, dplyr, here)
```

## 3. Data Acquisition & Cleaning  
| Step | Action |
|------|--------|
| 1️⃣   | Conditionally download `AP_2018_State_County_Inventory.xlsx` into `data/` if not present (binary mode). |
| 2️⃣   | Read the sheet **“Output - State”**. |
| 3️⃣   | Keep columns: `State` and `Total kg/person`. |
| 4️⃣   | Lower‑case all state names for robust matching. |
| 5️⃣   | Convert `Total kg/person` to numeric suppressing warnings; assign to `total_kg_per_person`. |

## 4. Map Construction (usmap & ggplot2)  
| Step | Action |
|------|--------|
| 1️⃣   | Load a high‑resolution US map (`us_map(resolution = "high")`). |
| 2️⃣   | Convert state names to lower case in both datasets, join by name. |
| 3️⃣   | Remove unmatched rows (e.g., territories). |
| 4️⃣   | Build a `ggplot` object: `geom_polygon()` with grey borders (`color = "grey30"`); fill based on emissions. |
| 5️⃣   | Set gradient colors: low **dark green** `#1a9850`, high **red** `#d73027`. |
| 6️⃣   | Add title `(2018)`, subtitle describing the dataset, caption with citation and DOI. |
| 7️⃣   | Remove all axis elements (`theme_void()` plus custom theme). |
| 8️⃣   | Save to `plots/us_asphalt_2018.png` (12×9 in, 300 dpi). |

## 5. Post‑Processing & Validation  
| Checkpoint | Expected outcome |
|------------|------------------|
| Folder creation succeeded (`data/` & `plots/`). | No errors, console prints “✅ Downloaded …” or “ℹ️ Already present”. |
| Data frame merge includes all 50 states (plus DC) and no NA values. | `nrow(merged_df) == 51`. |
| PNG file saved in `plots/`. | File exists, size > 0 bytes. |

## 6. Documentation  
* Create four README‑style files (`README.md`, `plan.md`, `tasks.md`, `walkthrough.md`).  
* Add a `.gitignore` that **excludes** RStudio/VS Code metadata but **does not ignore** `data/` and `plots/`.  

## 7. Final Steps  
| Step | Action |
|------|--------|
| Run the script (`Rscript scripts/make_asphalt_chloropleth.R`). |
| Verify PNG output visually matches expectations (green‑yellow‑red gradient). |
| Commit all files to Git and push to remote repository. |
