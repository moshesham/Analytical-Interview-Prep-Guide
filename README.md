# The Product Analytics Masterclass

Welcome! This repository contains all materials for the "Product Analytics Masterclass."

The full curriculum is available as a polished, searchable website, built with mdBook.

**➡️ [Access the live curriculum here](https://your-username.github.io/Product-Analytics-Masterclass/)**
*(You must update this link in GitHub > Settings > Pages after your first deployment.)*

## Local Development

The content for the book is generated from the markdown files in the `src/` directory. To build and preview it locally:

1.  **Install mdBook:** Follow the instructions at the [official mdBook repository](https://github.com/rust-lang/mdBook).
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
