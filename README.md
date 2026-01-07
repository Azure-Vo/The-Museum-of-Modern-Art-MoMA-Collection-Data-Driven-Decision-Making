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

## 3. Data Understanding & Pre-processing
**Original Dataset:**
Initially, the dataset consisted of two raw CSV files with significant redundancy:
* **`Artworks.csv` (30 columns):** Included many physical attributes (Dimensions, Weight, Seat Height, etc.) and duplicated artist details (ArtistBio, Nationality, Gender) which already existed in the Artists table.
* **`Artists.csv` (9 columns):** Contained biographical data of artists.

**The Redundancy Problem:**
Upon inspection, I identified a **Many-to-Many relationship** issue where specific attributes (`ArtistBio`, `Nationality`, `Gender`, `BeginDate`, `EndDate`) were repeated in the `Artworks` table. Direct joining would lead to data inconsistency and performance issues (redundancy problem).

**Pre-processing Action:**
Before importing data into SQL/Power BI, I utilized **Excel** to:
1.  **Remove irrelevant attributes:** Eliminated physical dimension columns (e.g., *Circumference, Depth, Weight*) that were not relevant to the strategic decision questions.
2.  **Schema Restructuring:** Redesigned the data model into 3 focused tables to optimize SQL querying and insight extraction.

## 4. Data Modeling Strategy & Execution
To solve the redundancy problem, I normalized the data into a **Star Schema** structure consisting of 3 main tables:

### 4.1. Table Structure
**1. Dim_Artworks (Fact/Dimension):**
Stores core details about the art pieces.
* *Attributes:* `ObjectID` (PK), `Title`, `DateCreated`, `Medium`, `CreditLine`, `AccessionNumber`, `Classification`, `Department`, `DateAcquired`, `Cataloged`.

**2. Dim_Artists (Dimension):**
Stores unique artist information, removing duplicates found in the original Artworks file.
* *Attributes:* `ConstituentID` (PK), `DisplayName`, `ArtistBio`, `Nationality`, `Gender`, `BeginDate`, `EndDate`.

**3. Artwork_Artist (Bridge Table):**
Resolves the Many-to-Many relationship between Artists and Artworks (since one artwork can have multiple artists and vice versa).
* *Attributes:* `ConstituentID` (FK), `ObjectID` (FK).

**Data Re-Modeled**
*<img width="1070" height="435" alt="Ảnh chụp màn hình 2026-01-07 213854" src="https://github.com/user-attachments/assets/033de9c3-69a1-4106-999c-c982a1f3b765" />*
*(The resulting model is cleaner, lightweight, and specifically optimized for Power BI performance)*.

### 4.2. SQL Transformation
After defining the physical model in Excel, I used **SQL** to perform advanced data cleaning on these tables, such as:
* **Standardization:** Converted `0` values in Year columns to `NULL` for accurate age calculations.
* **Data Type Conversion:** Transformed `DateAcquired` from text (e.g., '4/9/1996') to SQL `DATE` format using `STR_TO_DATE`.
* **Regex Extraction:** Extracted clean 4-digit `YearCreated` from messy text fields (e.g., "c. 1917") using `REGEXP_SUBSTR`.
* **Handling Many-to-Many Relationships:** Used `JSON_TABLE` to split multi-value `ConstituentID` fields (e.g., "5640, 7234") into individual rows, creating a bridge table `Artwork_Artist`.

### 4.3. Data Modeling (Power BI)
I implemented an Extended Star Schema to optimize performance:
* **Bridge Table:** `Artwork_Artist` (linking Artists and Artworks).
* **Dimension Tables:** `Dim_Artists`, `Dim_Artworks`, `Dim_Date`, `DeparmentClean`.

**Data Model Schema**
*<img width="1131" height="743" alt="Ảnh chụp màn hình 2026-01-07 195256" src="https://github.com/user-attachments/assets/d93a2884-8436-45fa-9e1d-3054a8165f9e" />*

### 4.4. Key DAX Measures
* **% Contemporary Art:** Calculates the ratio of artworks created after 1945.
* **Acquisition YoY Growth:** Tracks annual growth in museum acquisitions.
* **Artists with Works:** Distinct count to filter out artists with no linked artworks.

## 5. Dashboard & Visualizations
The dashboard provides a comprehensive view of the collection:

**Dashboard Overview**
*<img width="1720" height="1075" alt="image" src="https://github.com/user-attachments/assets/924e8318-5cc3-4a25-b66e-fca378ec8a6a" />*

* **KPI Cards:** Total Artworks (158K), Total Artists (16K), Avg Creation Year (1959).
* **Acquisition Trend (Line Chart):** Shows a massive surge in acquisitions during the 1960s-1970s.
* **Department Breakdown (Button Slicers):** "Drawings & Prints" and "Architecture & Design" make up the majority of the collection.

## 6. Analysis, Insights & Recommendations

### 6.1. Interpretation of Visuals
The visualization component reveals significant structural characteristics of the MoMA collection:
* **The Gender Gap:** The data exposes a severe disparity in artist representation. With **9,940 male artists** compared to only **2,435 female artists**, the collection is heavily skewed (~80% Male), reflecting historical biases in the art world.
* **Volume vs. Medium:** There is a strong correlation between the "reproducibility" of a medium and its volume in the collection. Departments like **Photography** and **Prints** have massive item counts due to the nature of the medium (one artist can produce hundreds of prints), whereas unique media like "Painting & Sculpture" have lower counts.

### 6.2. Answers to Decision Questions

**Q1: How modern are the artworks at the Museum?**
* **Finding:** While the collection spans the late 19th century, the bulk of the active inventory is **Contemporary (post-1960)**.
* **Evidence:** The "Acquisition Trend Over Time" chart shows a massive upward spike starting in the 1960s-1970s and continuing into the 2000s, proving the museum actively keeps the collection current.

**Q2: Which artists are featured the most?**
* **Finding:** The top featured artists are primarily from **Architecture & Design** and **Photography**.
* **Evidence:** **Ludwig Mies van der Rohe** is the top artist (~15,500 works), followed by **Eugène Atget**. This is driven by large-scale donations of architectural sketches and photographic prints, rather than individual paintings.

**Q3: Are there any trends in the dates of acquisition?**
* **Finding:** Acquisition is not linear; it is driven by specific events and strategic expansion.
* **Evidence:**
    * **The 1960s Surge:** A notable peak occurred due to major donations in Architecture & Design.
    * **Steady Growth (1990s-Present):** The museum has maintained a high and consistent level of acquisition in the digital age, indicating an aggressive expansion strategy.

**Q4: What types of artwork are most common?**
* **Finding:** The collection is dominated by works on paper rather than canvas.
* **Evidence:** The **Drawings & Prints** department is the largest (~80,000 artworks), followed by Architecture & Design and Photography. Traditional **Painting & Sculpture** only accounts for ~3,000 artworks. This highlights MoMA's transition from traditional physical media to capturing "multi-media" evolution.

### 6.3. Final Recommendations
Based on the data evidence, I propose the following strategic actions for MoMA:

1.  **Address the Representation Gap:** The **80/20 gender imbalance** represents a critical area for improvement. Future acquisition strategies should prioritize female and non-binary artists to diversify the collection and reflect modern societal values.
2.  **Contextualize "Top Artists" Metrics:** When evaluating artist prominence, stakeholders must account for the **Medium Bias**. A painter with 20 works might be as significant as a photographer with 500 prints. KPIs should be segmented by Department to ensure fair comparison.
3.  **Sustain Contemporary Growth:** The steady acquisition trend since the 1990s is a positive signal. MoMA should continue focusing on **Media and Performance** art (currently ~4,000 items) to stay ahead in the 21st-century digital art landscape.

**Course:** Data Driven Decision Making - Mone Lise Team
