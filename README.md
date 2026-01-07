# MoMA Art Collection Analysis - Data Driven Decision Making Project

## 1. Project Overview & Data Problem Definition
**Project Topic:** Analysis of the Museum of Modern Art (MoMA) Collection.

**Datasets Overview** comprises 157,630 accessioned artworks along with their associated metadata, including artist, title, medium, creation date, dimensions, and acquisition date.

**General Goal:** To explore patterns in MoMA's collecting behavior, understand trends in artistic mediums/artist representation over time, and identify potential gaps in the dataset.

**Decision Context:**
* **Who needs to decide?**
    The primary stakeholders are **Museum Curators, Exhibition Strategists, and Collection Managers**. They are responsible for shaping the museum's identity and ensuring its relevance in the modern art world.
* **What decisions need data?**
    To maintain MoMA's prestige and cultural relevance, these stakeholders need data-driven evidence to:
    1.  **Exhibition Planning:** Determine which artistic movements or mediums (e.g., Photography vs. Painting) are trending to curate attractive exhibitions.
    2.  **Acquisition Strategy:** Identify gaps in the collection (e.g., underrepresented artists or time periods) to guide future artwork purchases.
    3.  **Diversity & Inclusion:** Assess the gender and nationality balance within the collection to address historical biases.

**Business Relevance:**
The insights derived help MoMA identify artistic trends, significant time periods, and assess cultural diversity (gender/nationality) within their collection. This supports effective exhibition strategies and collection management decisions.

## 2. Problem Statement & Decision Questions
**The Business Issue:**
While MoMA possesses a vast historical archive, the raw data contains significant inconsistencies, redundancy, and missing values (e.g., unformatted dates, duplicate artist entries). Without processing this data, the museum operates on intuition rather than evidence, risking:
* **Stagnation:** Failing to capture contemporary art trends (post-1960s) effectively.
* **Bias:** Unknowingly perpetuating a gender gap or lack of diversity in artist representation.
* **Inefficiency:** Inability to visualize the "Acquisition Trend" over decades to forecast future resource allocation.

**Project Goal:**
This project aims to clean, model, and visualize the MoMA dataset to provide a transparent view of the collection's evolution. By transforming raw records into actionable KPIs (e.g., *% Contemporary Art*, *Acquisition YoY Growth*), we empower stakeholders to make informed decisions about collection management and exhibition strategies.

To achieve the project goals, this analysis answers the following key decision questions:
1.  **How modern are the artworks at the Museum?** (Tracking trends across creation and acquisition dates).
2.  **Which artists are featured the most?** (Identifying top contributors).
3.  **Are there any trends in the dates of acquisition?** (Analyzing growth periods like the 1960s surge).
4.  **What types of artwork are most common?** (Department and classification breakdown).

## 3. Data Source & Tech Stack
* **Dataset:** MoMA Collection (157,630 records) including `Artists.csv` and `Artworks.csv`.
* **Tools Used:**
    * **SQL (MySQL):** For data cleaning, transformation, and normalization.
    * **Power BI:** For data modeling (Star Schema), DAX measures, and interactive visualization.

## 4. Methodology & Execution

### 4.1. Data Cleaning & Transformation (SQL)
The raw data contained inconsistencies and redundancy. Key SQL techniques applied:
* **Standardization:** Converted `0` values in Year columns to `NULL` for accurate age calculations.
* **Data Type Conversion:** Transformed `DateAcquired` from text (e.g., '4/9/1996') to SQL `DATE` format using `STR_TO_DATE`.
* **Regex Extraction:** Extracted clean 4-digit `YearCreated` from messy text fields (e.g., "c. 1917") using `REGEXP_SUBSTR`.
* **Handling Many-to-Many Relationships:** Used `JSON_TABLE` to split multi-value `ConstituentID` fields (e.g., "5640, 7234") into individual rows, creating a bridge table `Artwork_Artist`.

### 4.2. Data Modeling (Power BI)
I implemented an Extended Star Schema to optimize performance:
* **Bridge Table:** `Artwork_Artist` (linking Artists and Artworks).
* **Dimension Tables:** `Dim_Artists`, `Dim_Artworks`, `Dim_Date`.

**Data Model Schema**
*<img width="1131" height="743" alt="Ảnh chụp màn hình 2026-01-07 195256" src="https://github.com/user-attachments/assets/d93a2884-8436-45fa-9e1d-3054a8165f9e" />*

### 4.3. Key DAX Measures
* **% Contemporary Art:** Calculates the ratio of artworks created after 1945.
* **Acquisition YoY Growth:** Tracks annual growth in museum acquisitions.
* **Artists with Works:** Distinct count to filter out artists with no linked artworks.

## 5. Dashboard & Visualizations
The dashboard provides a comprehensive view of the collection:

**Dashboard Overview**
*<img width="1720" height="1075" alt="image" src="https://github.com/user-attachments/assets/924e8318-5cc3-4a25-b66e-fca378ec8a6a" />*

* **KPI Cards:** Total Artworks (158K), Total Artists (16K), Avg Creation Year (1959).
* **Acquisition Trend (Line Chart):** Shows a massive surge in acquisitions during the 1960s-1970s.
* **Department Breakdown (Donut Chart):** "Drawings & Prints" and "Architecture & Design" make up the majority of the collection.

## 6. Key Insights & Recommendations
Based on the visual analysis:
1.  **Modernity:** While the collection covers the late 19th century, the bulk of active inventory is **Contemporary (post-1960)**.
2.  **Top Contributors:** **Ludwig Mies van der Rohe** is the top featured artist (~15k works), driven by large donations in Architecture & Design.
3.  **Gender Disparity:** The collection is heavily skewed with approx. **80% male artists** vs. 20% female artists, highlighting a gap in representation.
4.  **Medium Dominance:** High reproducibility mediums (Photography, Prints) have much higher counts compared to Painting & Sculpture.

**Course:** Data Driven Decision Making
