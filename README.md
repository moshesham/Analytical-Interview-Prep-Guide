
# Product Analytics Interview Prep Handbook

Welcome! This repository contains all materials for the "Product Analytics Interview Prep Handbook"—a modern, applied curriculum designed to help you ace data science and product analytics interviews.

The full curriculum is available as a polished, searchable website, built with mdBook.

**➡️ [Access the live curriculum here](https://your-username.github.io/Product-Analytics-Masterclass/)**
*(Update this link in GitHub > Settings > Pages after your first deployment.)*

## What's Inside?
- **SQL (Fundamentals to Advanced):** Real-world queries, window functions, and analytics use cases.
- **Applied Statistics:** Interview-ready theory, product analytics scenarios, and expert-level deep dives.
- **Python for Analytics:** Data cleaning, advanced visualization, and time series analysis for product data.
- **Product Thinking:** Metrics, experimentation, and case studies.

All content is structured for interview prep, blending theory with hands-on product analytics examples.

## Local Development

The book is generated from markdown files in the `src/` directory. To build and preview it locally:

1.  **Install mdBook:** See the [official mdBook repository](https://github.com/rust-lang/mdBook).
2.  **Run the build script:** This script copies and formats content into the `book-src` directory.
    ```bash
    ./scripts/build_book.sh
    ```
3.  **Serve the book:**
    ```bash
    mdbook serve book-src
    ```
4.  Open your browser to `http://localhost:3000`.

## Deployment
Any push to the `main` branch will automatically trigger the GitHub Actions workflow. This runs `./scripts/build_book.sh` and then deploys the site to GitHub Pages.
