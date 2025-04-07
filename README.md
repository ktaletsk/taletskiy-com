# Konstantin Taletskiy's Personal Website
[![Netlify Status](https://api.netlify.com/api/v1/badges/b3eb950e-d04c-4986-9c74-257ee928ceb2/deploy-status)](https://app.netlify.com/sites/konstantintaletskiy/deploys)

This repository contains the source code for my personal website built with Hugo and the hugo-noir theme.

## Setup and Development

1. Clone this repository
2. Install Hugo: https://gohugo.io/installation/
3. Run the development server:
```
hugo server -D
```

## Adding Content

### Blog Posts

To create a new blog post:

1. Create a new markdown file in the `content/blogs/` directory with a descriptive filename:
```
content/blogs/my-new-post.md
```

2. Add front matter to the top of the file with the following structure:
```yaml
---
title: "Your Blog Post Title"
date: YYYY-MM-DD
draft: false
summary: "A brief summary of your blog post that will appear on the blog list page"
tags: ["tag1", "tag2", "tag3"]
---
```

3. Write your content below the front matter using Markdown syntax.

4. Example blog post:
```markdown
---
title: "Getting Started with Hugo"
date: 2024-04-10
draft: false
summary: "Learn how to set up a Hugo site and create your first content"
tags: ["hugo", "web development", "tutorial"]
---

# Getting Started with Hugo

This is the content of my blog post...

## Subheading

More content here...
```

5. Preview your post by running the Hugo development server:
```
hugo server -D
```

6. When ready to publish, set `draft: false` in the front matter.

### External Blog Links

To add links to blogs published on external platforms (like Medium):

1. Edit the `hugo.toml` file
2. Add a new entry under `[[params.blogs]]` with the following structure:
```toml
[[params.blogs]]
    title = "Your Article Title"
    date = "YYYY-MM-DD"
    summary = "Brief description of the article"
    tags = ["tag1", "tag2", "tag3"]
    link = "https://example.com/your-article"
```

## Building and Deployment

To build the site for production:

```
hugo
```

This will generate static files in the `public/` directory that can be deployed to any web hosting service. 
