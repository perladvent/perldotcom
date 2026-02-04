# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Perl.com is a Hugo-powered static site for publishing articles about Perl programming. The site uses a dual-repository deployment model: content lives in the public GitHub repo, while the generated static files are pushed to a private TPF-managed staging repository that serves the live site.

## Common Commands

### Setup
```bash
# Install Perl dependencies
cpm install -g --cpanfile cpanfile

# Install Node dependencies (for Prettier)
npm install
```

### Article Creation and Development
```bash
# Create a new article (interactive prompt)
make new

# Start local development server (generates JSON metadata and runs Hugo)
make start

# Start server with pinned Hugo version (requires Docker)
make legacy-start

# List draft articles
make show_drafts
```

### Metadata and JSON Generation
```bash
# Generate all JSON metadata files (in static/json/)
make json

# Generate contributors list
make contributors
```

### Deployment
```bash
# Deploy to live site (must be on master branch, no uncommitted changes)
make deploy

# Check live site build status
make show_live_build
```

### Testing
```bash
# Run Perl tests
prove -lv t/

# Run specific test
prove -lv t/metadata.t
```

## Architecture

### Content Model

Articles are Markdown files with front matter in either TOML (new articles) or JSON (legacy) format. Front matter includes:
- `title`, `date`, `description`
- `authors` (array of slugs referencing `/data/author/*.json` files)
- `tags` (array), `categories` (single value)
- `image` (featured image), `thumbnail` (circular display)
- `draft` (boolean)
- `canonicalUrl` (for republished content)

Author profiles are stored as JSON files in `/data/author/` with fields: `name`, `key`, `bio`, `image`.

### Build Pipeline

1. **Metadata Extraction**: `lib/Local/Metadata.pm` parses article front matter
2. **JSON Generation**: `bin/collate_metadata` creates various JSON files in `static/json/`:
   - `all_articles.json`, `previous_ten_articles.json`
   - `tags.json`, `by_tag/*.json`
   - `authors.json`, `by_author/*.json`
   - `categories.json`, `by_category/*.json`
3. **Build Tagging**: `bin/tag_the_build` creates `build.json` with deployment metadata
4. **Hugo Build**: Generates static site in `public/` or `built/` directory
5. **Deployment**: `bin/deploy` pushes to `perl.com-staging` repository

### Key Directories

- `content/article/` - Current articles (1146+ files)
- `content/legacy/` - Historical articles from original Perl.com
- `data/author/` - Author profile JSON files (170+ authors)
- `layouts/` - Hugo templates (partials, shortcodes, taxonomy pages)
- `static/` - Static assets (CSS, images, fonts)
- `static/json/` - Generated JSON metadata files
- `bin/` - Perl scripts for article management and deployment
- `lib/Local/` - Perl modules (primarily `Metadata.pm`)

### Hugo Configuration

- Uses Hugo v0.147.5 for deployment (Docker-based reproducible builds)
- Code syntax highlighting enabled (Pygments with Monokai style)
- Raw HTML allowed in Markdown (articles are editor-reviewed)
- Taxonomies: authors, tags, categories
- RSS feed limited to 25 items

## Article Writing Standards

### Style Guidelines

- American English, 300-1,000 words per article
- Use simple English and prefer first-person, active voice
- Link to MetaCPAN on first mention of Perl modules
- Use header 2 with dash style for subtitles:
  ```markdown
  Subtitle
  --------
  ```
- Format inline code as \`code\` or in code blocks
- Only use example.com, internal IPs, and -555- numbers in examples
- Avoid starting with justifications ("I thought it would be interesting...")
- Delete unnecessary words, especially adverbs
- Use subheadings to divide articles logically

### Adding Images

Featured images are set in the front matter:
```toml
image = "/images/article-name/featured.png"
thumbnail = "/images/article-name/thumb.png"
```

Or for external images:
```toml
image = "https://example.com/image.png"
```

Thumbnails are displayed in circular format on listing pages.

## Deployment Process

**Critical constraints**:
- Must be on `master` branch
- Working directory must be clean (no uncommitted changes)
- Must be up-to-date with origin (not ahead or behind)

The `make deploy` command:
1. Validates git status
2. Generates JSON metadata
3. Runs Hugo in Docker (v0.147.5)
4. Commits and pushes to `perl.com-staging` repository
5. Tags the deployment with `deployed` tag
6. Live site updates within minutes

## Metadata System

The `Local::Metadata` module provides article metadata parsing:
- Auto-detects TOML vs JSON front matter
- Parses all standard fields
- Adds computed fields: `filename`, `url_path`, `epoch`, `is_legacy`
- Query methods: `has_tag()`, `has_author()`, `has_category()`
- Accessors: `tags()`, `authors()`, `categories()`, etc.

Used by build scripts to generate JSON files and validate article metadata.
