#!/bin/bash

echo "🚀 Initializing Product Analytics Masterclass Project..."

# --- Configuration ---
PROJECT_NAME="Analytical-Interview-Prep-Guide"
MDBOOK_VERSION="0.4.36" # This MUST match the version in the deploy-mdbook.yml workflow

# Function to create a file only if it doesn't exist

# Function to create a file only if it doesn't exist
create_if_not_exists() {
    if [ ! -f "$1" ]; then
        touch "$1"
        echo "   -> Created placeholder: $1"
    else
        echo "   -> File exists, skipping: $1"
    fi
}


# === 1. Create ALL Core Project Directories ===
echo "-> Creating project directory structure..."
# If you want to create and enter the project directory, uncomment the next two lines:
# mkdir -p "$PROJECT_NAME"
# cd "$PROJECT_NAME" || exit

# Main curriculum source directories
mkdir -p src/week1_core_skills/python src/week1_core_skills/sql src/week1_core_skills/statistics
mkdir -p src/week2_product_thinking
mkdir -p src/week3_execution
mkdir -p src/resources
mkdir -p src/templates

# mdBook source directory
mkdir -p book-src/src

# GitHub Actions directory
mkdir -p .github/workflows

# Scripts directory
mkdir -p scripts

# === 2. Generate Core Project & Environment Files (if they don't exist) ===
echo "-> Generating root configuration and mdBook files..."

# .gitignore
if [ ! -f .gitignore ]; then
cat > .gitignore << EOL
# mdBook build output
/book-src/book/

# Python virtual environment
.venv/
venv/
__pycache__/
*.pyc

# IDE & OS specific
.idea/
.vscode/
.DS_Store
EOL
echo "   -> Created .gitignore"
fi

# Main Project README.md
if [ ! -f README.md ]; then
cat > README.md << EOL
# The Product Analytics Masterclass

Welcome! This repository contains all materials for the "Product Analytics Masterclass."

The full curriculum is available as a polished, searchable website, built with mdBook.

**➡️ [Access the live curriculum here](https://moshesham.github.io/Analytical-Interview-Prep-Guide/)**

## Local Development

The content for the book is generated from the markdown files in the \`src/\` directory. To build and preview it locally:

1.  **Install mdBook:** Follow the instructions at the [official mdBook repository](https://github.com/rust-lang/mdBook).
2.  **Run the build script:** This script copies and formats content into the \`book-src\` directory.
    \`\`\`bash
    ./scripts/build_book.sh
    \`\`\`
3.  **Serve the book:**
    \`\`\`bash
    mdbook serve book-src
    \`\`\`
4.  Open your browser to \`http://localhost:3000\`.

## Deployment
Any push to the \`main\` branch will automatically trigger the GitHub Actions workflow. This runs \`./scripts/build_book.sh\` and then deploys the site to GitHub Pages.
EOL
echo "   -> Created README.md"
fi

# mdBook configuration
if [ ! -f book-src/book.toml ]; then
cat > book-src/book.toml << EOL
[book]
title = "Analytical Interview Prep Guide"
authors = ["Moshe Shamouilian"]
src = "src"


[output.html]
git-repository-url = "https://github.com/moshesham/Analytical-Interview-Prep-Guide"
edit-url-template = "https://github.com/moshesham/Analytical-Interview-Prep-Guide/edit/main/{path}"
EOL
echo "   -> Created book-src/book.toml"
fi

# === 3. Generate Placeholder Curriculum Files (if they don't exist) ===
echo "-> Generating placeholder curriculum markdown files..."

# Week 1
create_if_not_exists "src/week1_core_skills/review_synthesis.md"
create_if_not_exists "src/week1_core_skills/python/data_cleaning_project.md"
create_if_not_exists "src/week1_core_skills/sql/fundamentals.md"
create_if_not_exists "src/week1_core_skills/sql/intermediate.md"
create_if_not_exists "src/week1_core_skills/sql/advanced_window_functions.md"
create_if_not_exists "src/week1_core_skills/statistics/probability_distributions.md"
create_if_not_exists "src/week1_core_skills/statistics/hypothesis_testing.md"

# Week 2
create_if_not_exists "src/week2_product_thinking/review_synthesis.md"
create_if_not_exists "src/week2_product_thinking/product_sense.md"
create_if_not_exists "src/week2_product_thinking/metrics_frameworks.md"
create_if_not_exists "src/week2_product_thinking/ab_testing_design.md"
create_if_not_exists "src/week2_product_thinking/ab_testing_analysis.md"
create_if_not_exists "src/week2_product_thinking/case_study_framework.md"
create_if_not_exists "src/week2_product_thinking/product_case_study_practice.md"

# Week 3
create_if_not_exists "src/week3_execution/review_refine_rest.md"
create_if_not_exists "src/week3_execution/data_storytelling.md"
create_if_not_exists "src/week3_execution/behavioral_interview.md"
create_if_not_exists "src/week3_execution/timed_sql_python_challenge.md"
create_if_not_exists "src/week3_execution/mock_interview_technical.md"
create_if_not_exists "src/week3_execution/mock_interview_product.md"
create_if_not_exists "src/week3_execution/final_polish_mindset.md"

# Resources & Templates
create_if_not_exists "src/resources/general_links.md"
create_if_not_exists "src/templates/daily_plan_template.md"

# === 4. Generate the GitHub Actions Deployment Workflow ===
echo "-> Generating GitHub Actions workflow for mdBook deployment..."
if [ ! -f .github/workflows/deploy-mdbook.yml ]; then
cat > .github/workflows/deploy-mdbook.yml << EOL
name: Deploy mdBook Site to Pages

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    env:
      MDBOOK_VERSION: "${MDBOOK_VERSION}"
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Install mdBook
        uses: peaceiris/actions-mdbook@v3
        with:
          mdbook-version: \${{ env.MDBOOK_VERSION }}

      - name: Grant execute permission for build script
        run: chmod +x ./scripts/build_book.sh

      - name: Run the Custom Book Build Script
        run: ./scripts/build_book.sh

      - name: Setup GitHub Pages
        uses: actions/configure-pages@v5

      - name: Build the book with mdBook
        run: mdbook build ./book-src

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./book-src/book

  deploy:
    environment:
      name: github-pages
      url: \${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
EOL
echo "   -> Created .github/workflows/deploy-mdbook.yml"
fi

# === 5. Create the Bridge Script (build_book.sh) ===
echo "-> Generating the 'build_book.sh' script to assemble content..."
cat > scripts/build_book.sh << 'EOL'
#!/bin/bash

# This script prepares the content for the mdBook build.
# It copies all curriculum markdown files from `src/` into the book's source
# directory (`book-src/src`) and generates the SUMMARY.md table of contents.

echo "📚 Preparing content for mdBook build..."

# --- Configuration ---
SRC_DIR="src"
BOOK_CONTENT_DIR="book-src/src"
SUMMARY_FILE="${BOOK_CONTENT_DIR}/SUMMARY.md"

# --- Clean Slate & Copy ---
echo "-> Clearing old content and copying new curriculum..."
rm -rf "${BOOK_CONTENT_DIR}"/*
# Copy the entire src directory structure to the book content directory
# This preserves the relative paths for images and links within the book
cp -r "${SRC_DIR}"/* "${BOOK_CONTENT_DIR}/"

# --- Generate SUMMARY.md ---
echo "-> Generating book table of contents (SUMMARY.md)..."
# Create or overwrite the summary file
> "${SUMMARY_FILE}"

# Add a custom introduction page if it exists, otherwise use README
if [ -f "${SRC_DIR}/introduction.md" ]; then
    cp "${SRC_DIR}/introduction.md" "${BOOK_CONTENT_DIR}/introduction.md"
    echo "# Summary" >> "${SUMMARY_FILE}"
    echo "" >> "${SUMMARY_FILE}"
    echo "[Introduction](./introduction.md)" >> "${SUMMARY_FILE}"
    echo "" >> "${SUMMARY_FILE}"
else
    echo "# Summary" >> "${SUMMARY_FILE}"
    echo "" >> "${SUMMARY_FILE}"
    echo "[Welcome](./README.md)" >> "${SUMMARY_FILE}"
    echo "" >> "${SUMMARY_FILE}"
fi

# --- Week 1 ---
echo "---" >> "${SUMMARY_FILE}"
echo "# Week 1: Core Skills" >> "${SUMMARY_FILE}"
echo "" >> "${SUMMARY_FILE}"
echo "- [Review & Synthesis](./week1_core_skills/review_synthesis.md)" >> "${SUMMARY_FILE}"
echo "- **SQL**" >> "${SUMMARY_FILE}"
echo "  - [Fundamentals](./week1_core_skills/sql/fundamentals.md)" >> "${SUMMARY_FILE}"
echo "  - [Intermediate](./week1_core_skills/sql/intermediate.md)" >> "${SUMMARY_FILE}"
echo "  - [Advanced Window Functions](./week1_core_skills/sql/advanced_window_functions.md)" >> "${SUMMARY_FILE}"
echo "- **Statistics**" >> "${SUMMARY_FILE}"
echo "  - [Probability & Distributions](./week1_core_skills/statistics/probability_distributions.md)" >> "${SUMMARY_FILE}"
echo "  - [Hypothesis Testing](./week1_core_skills/statistics/hypothesis_testing.md)" >> "${SUMMARY_FILE}"
echo "- **Python**" >> "${SUMMARY_FILE}"
echo "  - [Data Cleaning Project](./week1_core_skills/python/data_cleaning_project.md)" >> "${SUMMARY_FILE}"

# --- Week 2 ---
echo "" >> "${SUMMARY_FILE}"
echo "# Week 2: Product Thinking & A/B Testing" >> "${SUMMARY_FILE}"
echo "" >> "${SUMMARY_FILE}"
echo "- [Review & Synthesis](./week2_product_thinking/review_synthesis.md)" >> "${SUMMARY_FILE}"
echo "- [Product Sense](./week2_product_thinking/product_sense.md)" >> "${SUMMARY_FILE}"
echo "- [Metrics Frameworks](./week2_product_thinking/metrics_frameworks.md)" >> "${SUMMARY_FILE}"
echo "- [A/B Test Design](./week2_product_thinking/ab_testing_design.md)" >> "${SUMMARY_FILE}"
echo "- [A/B Test Analysis](./week2_product_thinking/ab_testing_analysis.md)" >> "${SUMMARY_FILE}"
echo "- [Case Study Framework](./week2_product_thinking/case_study_framework.md)" >> "${SUMMARY_FILE}"
echo "- [Product Case Study Practice](./week2_product_thinking/product_case_study_practice.md)" >> "${SUMMARY_FILE}"

# --- Week 3 ---
echo "" >> "${SUMMARY_FILE}"
echo "# Week 3: Execution & Interviews" >> "${SUMMARY_FILE}"
echo "" >> "${SUMMARY_FILE}"
echo "- [Review, Refine & Rest](./week3_execution/review_refine_rest.md)" >> "${SUMMARY_FILE}"
echo "- [Data Storytelling](./week3_execution/data_storytelling.md)" >> "${SUMMARY_FILE}"
echo "- [Behavioral Interview](./week3_execution/behavioral_interview.md)" >> "${SUMMARY_FILE}"
echo "- [Timed Technical Challenge](./week3_execution/timed_sql_python_challenge.md)" >> "${SUMMARY_FILE}"
echo "- [Technical Mock Interview](./week3_execution/mock_interview_technical.md)" >> "${SUMMARY_FILE}"
echo "- [Product Mock Interview](./week3_execution/mock_interview_product.md)" >> "${SUMMARY_FILE}"
echo "- [Final Polish & Mindset](./week3_execution/final_polish_mindset.md)" >> "${SUMMARY_FILE}"

# --- Resources & Templates ---
echo "" >> "${SUMMARY_FILE}"
echo "# Appendices" >> "${SUMMARY_FILE}"
echo "" >> "${SUMMARY_FILE}"
echo "- [Resource Links](./resources/general_links.md)" >> "${SUMMARY_FILE}"
echo "- [Daily Plan Template](./templates/daily_plan_template.md)" >> "${SUMMARY_FILE}"


echo "✅ mdBook content preparation complete."
EOL
chmod +x scripts/build_book.sh
echo "   -> Created scripts/build_book.sh"

# === 6. Final Message ===
echo ""
echo "✅ Project skeleton generation complete for '$PROJECT_NAME'!"
echo ""
echo "Next Steps:"
echo "1. Update URLs in 'README.md' and 'book-src/book.toml' to match your GitHub repository."
echo "2. Populate the markdown files in the 'src/' directory with your curriculum content."
echo "3. Run './scripts/build_book.sh' to test the book generation locally."
echo "4. Run 'mdbook serve book-src' to preview your book at http://localhost:3000."
echo "5. Initialize git, commit, and push to GitHub to trigger the deployment."

cd ..