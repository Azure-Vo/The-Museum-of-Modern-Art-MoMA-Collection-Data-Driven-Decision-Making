# MoMA Art Collection Analysis - Data Driven Decision Making Project

## 1. Project Overview & Problem Definition
**Project Topic:** Analysis of the Museum of Modern Art (MoMA) Collection.
[cite_start]**Goal:** To explore patterns in MoMA's collecting behavior, understand trends in artistic mediums/artist representation over time, and identify potential gaps in the dataset[cite: 78].

**Business Relevance:**
The insights derived help MoMA identify artistic trends, significant time periods, and assess cultural diversity (gender/nationality) within their collection. [cite_start]This supports effective exhibition strategies and collection management decisions [cite: 86-88].

## 2. Decision Questions
[cite_start]To achieve the project goals, this analysis answers the following key decision questions [cite: 203-204]:
1.  **How modern are the artworks at the Museum?** (Tracking trends across creation and acquisition dates).
2.  **Which artists are featured the most?** (Identifying top contributors).
3.  **Are there any trends in the dates of acquisition?** (Analyzing growth periods like the 1960s surge).
4.  **What types of artwork are most common?** (Department and classification breakdown).

## 3. Data Source & Tech Stack
* [cite_start]**Dataset:** MoMA Collection (157,630 records) including `Artists.csv` and `Artworks.csv`[cite: 77, 82].
* **Tools Used:**
    * **SQL (MySQL):** For data cleaning, transformation, and normalization.
    * **Power BI:** For data modeling (Star Schema), DAX measures, and interactive visualization.

## 4. Methodology & Execution

### 4.1. Data Cleaning & Transformation (SQL)
The raw data contained inconsistencies and redundancy. Key SQL techniques applied:
* [cite_start]**Standardization:** Converted `0` values in Year columns to `NULL` for accurate age calculations[cite: 208].
* [cite_start]**Data Type Conversion:** Transformed `DateAcquired` from text (e.g., '4/9/1996') to SQL `DATE` format using `STR_TO_DATE`[cite: 214].
* [cite_start]**Regex Extraction:** Extracted clean 4-digit `YearCreated` from messy text fields (e.g., "c. 1917") using `REGEXP_SUBSTR`[cite: 260].
* [cite_start]**Handling Many-to-Many Relationships:** Used `JSON_TABLE` to split multi-value `ConstituentID` fields (e.g., "5640, 7234") into individual rows, creating a bridge table `Artwork_Artist`[cite: 262].

### 4.2. Data Modeling (Power BI)
[cite_start]I implemented an Extended Star Schema [cite: 368] to optimize performance:
* **Bridge Table:** `Artwork_Artist` (linking Artists and Artworks).
* **Dimension Tables:** `Dim_Artists`, `Dim_Artworks`, `Dim_Date`.

![Data Model Schema](images/data_model_schema.png)
*(Place screenshot of your Power BI Model View here - similiar to page 25 of report)*

### 4.3. Key DAX Measures
* [cite_start]**% Contemporary Art:** Calculates the ratio of artworks created after 1945[cite: 426].
* [cite_start]**Acquisition YoY Growth:** Tracks annual growth in museum acquisitions[cite: 432].
* [cite_start]**Artists with Works:** Distinct count to filter out artists with no linked artworks[cite: 421].

## 5. Dashboard & Visualizations
The dashboard provides a comprehensive view of the collection:

![Dashboard Overview](images/dashboard_overview.png)
*(Place screenshot of your Final Dashboard here - similiar to page 30/32 of report)*

* [cite_start]**KPI Cards:** Total Artworks (158K), Total Artists (16K), Avg Creation Year (1959) [cite: 461-465].
* [cite_start]**Acquisition Trend (Line Chart):** Shows a massive surge in acquisitions during the 1960s-1970s[cite: 595].
* [cite_start]**Department Breakdown (Donut Chart):** "Drawings & Prints" and "Architecture & Design" make up the majority of the collection[cite: 611].

## 6. Key Insights & Recommendations
Based on the visual analysis:
1.  [cite_start]**Modernity:** While the collection covers the late 19th century, the bulk of active inventory is **Contemporary (post-1960)**[cite: 596].
2.  [cite_start]**Top Contributors:** **Ludwig Mies van der Rohe** is the top featured artist (~15k works), driven by large donations in Architecture & Design[cite: 600, 607].
3.  **Gender Disparity:** The collection is heavily skewed with approx. [cite_start]**80% male artists** vs. 20% female artists, highlighting a gap in representation[cite: 587].
4.  [cite_start]**Medium Dominance:** High reproducibility mediums (Photography, Prints) have much higher counts compared to Painting & Sculpture[cite: 588].

---
**Author:** [Your Name]
**Course:** Data Driven Decision Making
