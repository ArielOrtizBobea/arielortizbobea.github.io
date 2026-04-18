---
title: research
background: /assets/theme/images/landing/research.png
permalink: /research/
---

<style>
.research-page h2,
.research-page h3 {
  color: #b31b1b;
  font-size: 1.5rem;
  font-weight: 600;
}
.research-page h2 { margin-top: 2rem; }
.research-page h2:first-child { margin-top: 0; }
.research-page h3 { margin-top: 1.5rem; }

.research-page .paper-entry {
  padding-bottom: 1rem;
  margin-bottom: 1rem;
  border-bottom: 1px solid #e9ecef;
}
.research-page .paper-entry:last-child {
  border-bottom: none;
  padding-bottom: 0;
}
.research-page .paper-body { min-width: 0; }
.research-page .paper-title {
  font-weight: 600;
  line-height: 1.35;
  font-size: 0.95rem;
  margin-bottom: 0.3rem;
}
.research-page .paper-title a { color: inherit; }
.research-page .paper-title a:hover { color: #b31b1b; }
.research-page .paper-authors {
  font-size: 0.95rem;
  line-height: 1.5;
  margin-bottom: 0.3rem;
}
.research-page .paper-authors a {
  color: inherit;
  text-decoration: none;
  font-weight: 500;
}
.research-page .paper-authors a:hover { color: #b31b1b; }
.research-page .paper-meta {
  font-size: 0.95rem;
  margin-bottom: 0.3rem;
}
.research-page .paper-status {
  display: inline-block;
  font-size: 0.72rem;
  font-weight: 600;
  padding: 1px 7px;
  border-radius: 3px;
  background: #fff;
  color: #b31b1b;
  border: 1px solid #b31b1b;
  margin-right: 8px;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  vertical-align: middle;
}
.research-page .paper-journal {
  font-weight: 600;
  color: #495057;
  vertical-align: middle;
}
.research-page .paper-abstract {
  margin-top: 0.25rem;
  margin-bottom: 0;
}
.research-page .paper-abstract summary {
  cursor: pointer;
  font-size: 0.95rem;
  color: #6c757d;
  font-weight: 500;
  list-style: none;
  display: inline-flex;
  align-items: center;
  gap: 4px;
}
.research-page .paper-abstract summary::before {
  content: "▸";
  font-size: 0.8rem;
  transition: transform 0.15s;
  display: inline-block;
}
.research-page .paper-abstract[open] summary::before {
  transform: rotate(90deg);
}
.research-page .paper-abstract summary:hover { color: #b31b1b; }
.research-page .paper-abstract .abstract-content {
  color: #6c757d;
  font-size: 0.95rem;
  line-height: 1.55;
  margin-top: 0.4rem;
  padding-left: 0.6rem;
  border-left: 2px solid #e9ecef;
  display: flex;
  gap: 1rem;
  align-items: flex-start;
}
.research-page .paper-abstract .abstract-thumbnail {
  flex-shrink: 0;
  width: 280px;
  height: 280px;
}
.research-page .paper-abstract .abstract-thumbnail img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 4px;
  border: 1px solid #dee2e6;
  display: block;
}
.research-page .paper-abstract .abstract-text { flex: 1; min-width: 0; }
.research-page .paper-abstract .abstract-text p { margin-bottom: 0.5rem; }
.research-page .paper-abstract .abstract-text p:last-child { margin-bottom: 0; }
.research-page .paper-links {
  font-size: 0.95rem;
  color: #6c757d;
  margin-top: 0.25rem;
}
.research-page .paper-links a { color: #6c757d; text-decoration: underline; }
.research-page .paper-links a:hover { color: #b31b1b; }
.research-page .scholar-link {
  font-size: 0.95rem;
  margin-bottom: 1.5rem;
}
</style>

<div class="research-page" markdown="0">
<p class="scholar-link">Access my <a href="https://scholar.google.com/citations?user=MALB7wEAAAAJ" target="_blank" rel="noopener">Google Scholar</a> page.</p>

{%- assign papers = site.data.papers -%}
{%- assign in_progress = papers | where_exp: "p", "p.status != 'Published'" -%}
{%- assign published = papers | where: "status", "Published" -%}

<h2>In progress</h2>
{%- for paper in in_progress -%}
  {% include paper_entry.html %}
{%- endfor -%}

<h2>Publications</h2>
{%- assign years = published | map: "year" | uniq | sort | reverse -%}
{%- for yr in years -%}
<h3>{{ yr }}</h3>
{%- assign year_papers = published | where: "year", yr -%}
{%- for paper in year_papers -%}
  {% include paper_entry.html %}
{%- endfor -%}
{%- endfor -%}
</div>
