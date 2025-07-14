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
echo "- [Relational Databases](./week1_core_skills/sql/Relational_Databases.md)" >> "${SUMMARY_FILE}"
echo "- [SQL Fundamentals](./week1_core_skills/sql/fundamentals.md)" >> "${SUMMARY_FILE}"
echo "- [SQL Intermediate](./week1_core_skills/sql/intermediate.md)" >> "${SUMMARY_FILE}"
echo "- [SQL Advanced Window Functions](./week1_core_skills/sql/advanced_window_functions.md)" >> "${SUMMARY_FILE}"
echo "- [Python: Data Cleaning Project](./week1_core_skills/python/data_cleaning_project.md)" >> "${SUMMARY_FILE}"
echo "- [Python: Time Series](./week1_core_skills/python/time_series_analysis.md)" >> "${SUMMARY_FILE}"
echo "- [Python: Data Visualization](./week1_core_skills/python/advanced_visualization.md)" >> "${SUMMARY_FILE}"

echo "- [Statistics: Probability & Distributions](./week1_core_skills/statistics/probability_distributions.md)" >> "${SUMMARY_FILE}"
echo "- [Statistics: Hypothesis Testing](./week1_core_skills/statistics/hypothesis_testing.md)" >> "${SUMMARY_FILE}"
echo "- [Statistics: Theory & Product Analytics in Action](./week1_core_skills/statistics/Theory-Product-Analytics-Action.md)" >> "${SUMMARY_FILE}"
echo "- [Statistics: Advanced (Expert & Applied)](./week1_core_skills/statistics/advanced_statistics_expert.md)" >> "${SUMMARY_FILE}"

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
