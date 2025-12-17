
## **Coding Prompt**

### **Goal**

Write an R script that creates a choropleth map of U.S. states using **ggplot2**, based on asphalt emissions data provided by the U.S. Environmental Protection Agency (EPA). The data file is: `AP_2018_State_County_Inventory.xlsx`. Download URL: `https://pasteur.epa.gov/uploads/10.23719/1531683/AP_2018_State_County_Inventory.xlsx`

***

### **Requirements**

#### **Data Handling**

1.  Use the **"Output - State"** sheet from the Excel file.
2.  Extract columns:
    *   `State`
    *   `Total kg/person`
3.  Ensure state names match between the emissions data and the map data. One approach might be to convert the state names in both data sources to lower case before merging them.
4.  Suppress warnings when converting values to numeric.
5.  Print a success message after reading the data, but **do not** show `read_excel` informational messages (e.g., "New names:").
    * Consider using the `.name_repair = "unique_quiet"` argument to read_excel().
6.  Conditionally download the data file if it does not exist locally.
    *   Make sure to download the Excel data file in binary mode.
    *   Save the file in a `data/` folder.
    *   In the R script, create the `data/` folder if it does not exist.

***

#### **Map Visualization**

1.  Create a U.S. states choropleth map.
    * Use `usmap::plot_usmap()` for creating the base map.
    * Then use **ggplot** functions for adding additional features.
    * Be sure to include Alaska and Hawaii.
    * NOTE: In usmap ≥ 0.7.0, us_map() now returns an sf object with a geometry column (geom), not the older fortified data frame with x, y, and group columns.
2.  Color scale for `Total kg/person`:
    *   Low values: **dark green**
    *   Medium values: **yellow**
    *   High values: **red**
    *   Ensure colors are vivid and distinct (not washed out or muddy).
    *   Use `linewidth` instead of `size` with functions like `geom_polygon()`.
3.  State borders: **grey**.
4.  Plot background: **white**.
5.  Add:
    *   **Title**: Include `(2018)` at the end because this is the year of the State County Inventory data file.
    *   **Subtitle**: Provide context for the visualization.
    *   **Caption**: Cite the data source in the lower-left margin.
6.  Remove:
    *   **Axis Titles**: Do *not* include x and y axis titles, labels, or ticks.
7.  Save the map as a **PNG** in a `plots/` folder.
    *   In the R script, create the `plots/` folder if it does not exist.

***

#### **Project Structure**

Create the following files:

*   `README.md`:
    *   Show the map by linking to the PNG file.
    *   Cite the research paper:  
        *Anthropogenic secondary organic aerosol and ozone production from asphalt-related emissions, Environ. Sci.: Atmos., 2023,3, 1221-1230* 
        DOI: <https://doi.org/10.1039/D3EA00066D>
    *   Include links to all markdown files.
    *   Include a **Project Structure** section listing all files.
*   `plan.md`: Implementation plan.
*   `tasks.md`: Task checklist used to implement the plan.
*   `walkthrough.md`: Step-by-step walkthrough.
*   `.gitignore`: Generic for R projects. Exclude VS Code and RStudio metadata files.
    **Do not** exclude `data/` or `plots/` folders.

***

#### **Technical Details**

*   Use `pacman::p_load()` for package loading.
*   Use `here::here()` for folder and file access.
*   Include error handling throughout the script.
*   Test and debug the code to ensure:
    *   Creation of data and plots folders.
    *   Correct merging of map and emissions data.
    *   Proper color differentiation between states.

***

### **Deliverables**

*   R script implementing all requirements.
*   `README.md` with:
    *   Map preview.
    *   Citation and DOI link.
    *   Links to all markdown files.
    *   Project structure section.
*   `plan.md`, `prompt.md`, `tasks.md`, `walkthrough.md`, `.gitignore`.
