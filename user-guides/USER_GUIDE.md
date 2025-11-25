# User Guide

Guide for lab researchers and analysts using the Small Shiny Apps Platform.

---

## 🚀 Getting Started

### Access the Platform

**Live Demo**: [https://ssankhe.shinyapps.io/Small-Shiny-Apps-Platform/](https://ssankhe.shinyapps.io/Small-Shiny-Apps-Platform/)

**Or run locally**:
1. Open RStudio
2. Open the file `app_launcher.R`
3. Click the **Run App** button at the top of RStudio

---

## 📱 Using the Platform

### Selecting a Tool

1. When the app opens, you'll see a **dropdown menu** in the sidebar
2. Click the dropdown to see all available tools
3. Select the tool you want to use
4. The tool's interface will load in the main area

### Switching Between Tools

- Simply select a different tool from the dropdown menu
- Each tool runs independently—no data is shared between tools

---

## 🔬 Available Tools

### Module Template

**Purpose**: Demonstrates how the platform works

**What it shows**:
- The README.md file (this documentation)
- The source code of the template module

**Use**: Reference for developers creating new modules

---

### Exploratory Data Visualizations

**Purpose**: Interactive analysis of expression data with sample metadata

#### What You Need

**Two CSV files**:

1. **Metadata file**: Must contain:
   - `sampleName` column (sample identifiers)
   - At least one additional column (e.g., `group`, `treatment`, `condition`)

2. **Expression matrix file**:
   - First column: Feature/target names (e.g., genes, proteins)
   - Remaining columns: Sample names (matching metadata `sampleName`)
   - Values: Numeric expression levels

#### How to Use

1. **Upload your files**:
   - Click "Metadata CSV" to upload metadata
   - Click "Expression Matrix CSV" to upload matrix
   - Wait for files to process

2. **View visualizations**:
   - **Boxplot tab**: Compare expression levels across groups
     - Select a feature from the dropdown
     - Choose which metadata column to group by
   - **Heatmap tab**: View top variable features
     - Adjust number of features to display
   - **PCA tab**: Explore sample relationships
     - Choose which principal components to plot
     - Samples colored by metadata groups

3. **Interpret results**:
   - **Boxplot**: Differences in expression between groups
   - **Heatmap**: Features that vary most across samples
   - **PCA**: Overall similarity/difference patterns

#### Example Data Format

**Metadata (metadata.csv)**:
```csv
sampleName,group,batch
Sample_1,Control,A
Sample_2,Control,A
Sample_3,Treatment,B
Sample_4,Treatment,B
```

**Expression Matrix (expression.csv)**:
```csv
feature,Sample_1,Sample_2,Sample_3,Sample_4
Gene_A,5.2,5.1,8.3,8.5
Gene_B,10.1,9.8,10.2,9.9
Gene_C,2.1,2.3,2.2,2.0
```

---

## ❓ Frequently Asked Questions

### General

**Q: The app shows an error or won't start. What should I do?**

A:
- If using the web version: Refresh your browser
- If running locally: Close RStudio completely and restart
- If the problem persists, contact support

**Q: Can I use two tools at the same time?**

A: No, each tool is isolated for safety and simplicity. You can only use one tool at a time. To switch tools, select a different one from the dropdown.

**Q: Is my data saved or shared?**

A:
- **Web version**: Data is processed in your browser session only and is not stored on servers
- **Local version**: Data is processed on your computer only
- Data is not shared between tools or saved after you close the app

**Q: Can I download my results?**

A: Currently, visualization tools do not include download functionality. To save results, use your operating system's screenshot feature.

### Exploratory Module

**Q: My files won't upload. What's wrong?**

A:
- Check that files are in CSV format
- Ensure files are under 30MB
- Verify that metadata has a `sampleName` column
- Make sure sample names in metadata match column names in expression matrix

**Q: I get an error about "sample alignment." What does this mean?**

A: The sample names in your metadata file don't match the column names in your expression matrix. Check:
- Spelling (case-sensitive)
- Extra spaces
- Special characters

**Q: The heatmap shows fewer features than I requested. Why?**

A: Features with zero variance (constant values across all samples) are excluded from the heatmap.

**Q: What does the PCA plot show?**

A: PCA (Principal Component Analysis) reduces your multi-dimensional data to 2D. Points close together have similar expression patterns; points far apart are different.

**Q: How do I choose which covariate to use?**

A: In the sidebar, select which metadata column to use for grouping/coloring. This should be the experimental variable you're interested in (e.g., treatment, genotype).

---

## 💡 Tips & Best Practices

### Data Preparation

1. **Clean your data before upload**:
   - Remove any summary rows (totals, averages)
   - Ensure consistent sample naming
   - Check for missing values (use NA or leave blank)

2. **Metadata tips**:
   - Use simple column names (no spaces or special characters)
   - Use consistent values (e.g., "Control" vs "control" matters)
   - Include only relevant metadata columns

3. **Expression matrix tips**:
   - First column should be feature IDs (will become row names)
   - Column headers should exactly match metadata `sampleName`
   - All values should be numeric (no text)

### Troubleshooting

**If visualizations look strange**:
- Check for outliers or extreme values in your data
- Verify that samples are correctly labeled in metadata
- Try adjusting the number of features shown in heatmap

**If the app is slow**:
- Reduce the number of features (filter before upload)
- Use a smaller number of samples for initial exploration
- Close other browser tabs or applications

---

## 🆘 Getting Help

### Request a New Tool

Have an idea for a new analysis tool? Email your request with:
- What you want to analyze
- What inputs you have
- What outputs you need

### Report an Issue

If you encounter a bug or error:
- Note what you were doing when it occurred
- Take a screenshot if possible
- Email the details to support

### Contact

**Sumedh Sankhe**
Email: [sumedh.sankhe@gmail.com](mailto:sumedh.sankhe@gmail.com)

---

## 📚 Additional Resources

- **Developer Guide**: [user-guides/DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) - For creating new modules
- **Project README**: [README.md](../README.md) - Technical overview and architecture
