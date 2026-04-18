---
title: research
background: /assets/theme/images/landing/research.png
permalink: /research/
---

<style>
.research-page h2 {
  color: #b31b1b;
  font-size: 1.5rem;
  font-weight: 600;
  margin-top: 2rem;
}
.research-page h2:first-child { margin-top: 0; }
.research-page h3 {
  color: #b31b1b;
  font-size: 1.5rem;
  font-weight: normal;
  margin-top: 1.5rem;
}

/* Three-column layout: [year] [number] [paper content] */
.research-page .papers-grid {
  display: grid;
  grid-template-columns: 55px 30px 1fr;
  column-gap: 18px;
  row-gap: 0;
  margin-top: 1.5rem;
  align-items: baseline;
}
.research-page .cell-year {
  font-size: 1.5rem;
  color: #b31b1b;
  font-weight: normal;
}
.research-page .cell-num {
  font-size: 0.9rem;
  color: #6c757d;
  font-family: ui-monospace, "SF Mono", Menlo, Consolas, monospace;
  text-align: right;
}
.research-page .cell-paper { min-width: 0; }
@media (max-width: 700px) {
  .research-page .papers-grid {
    display: block;
  }
  .research-page .cell-year:not(:empty) {
    padding-top: 0;
    margin-top: 1rem;
    margin-bottom: 0.5rem;
    font-size: 1.3rem;
  }
  .research-page .cell-year:empty { display: none; }
  .research-page .cell-num { display: none; }
  .research-page .cell-paper { display: block; }
}

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
.research-page .paper-journal {
  font-style: italic;
  font-size: 0.95rem;
  color: #495057;
}
.research-page .paper-status-line {
  margin-top: 0.2rem;
  margin-bottom: 0.2rem;
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
  text-transform: uppercase;
  letter-spacing: 0.04em;
  vertical-align: middle;
}
.research-page .paper-abstract {
  margin-top: 0.15rem;
  margin-bottom: 0;
  border: none;
  background: transparent;
  box-shadow: none;
  padding: 0;
}
.research-page details { border: none; margin: 0; padding: 0; }
.research-page details > summary { border: none; margin: 0; padding: 0; }
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
  object-fit: contain;
  border-radius: 4px;
  display: block;
  background: #fff;
}
.research-page .paper-abstract .abstract-text { flex: 1; min-width: 0; }
.research-page .paper-abstract .abstract-text p { margin-bottom: 0.5rem; }
.research-page .paper-abstract .abstract-text p:last-child { margin-bottom: 0; }

/* On narrow screens, stack thumbnail above abstract text */
@media (max-width: 700px) {
  .research-page .paper-abstract .abstract-content {
    flex-direction: column;
  }
  .research-page .paper-abstract .abstract-thumbnail {
    width: 100%;
    max-width: 240px;
    height: auto;
    aspect-ratio: 1 / 1;
  }
}
.research-page .paper-links {
  margin-top: 0.5rem;
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}
.research-page .paper-links a {
  display: inline-block;
  font-size: 0.78rem;
  font-weight: 500;
  padding: 1px 8px;
  border: 1px solid #6c757d;
  border-radius: 3px;
  color: #6c757d;
  text-decoration: none;
  background: #fff;
  line-height: 1.4;
}
.research-page .paper-links a:hover {
  color: #b31b1b;
  border-color: #b31b1b;
}
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
<div class="papers-grid">
{%- for paper in in_progress -%}
  <div class="cell-year"></div>
  <div class="cell-num">{{ forloop.index }}.</div>
  <div class="cell-paper">
    {% include paper_entry.html %}
  </div>
{%- endfor -%}
</div>

<h2>Publications</h2>
{%- assign years = published | map: "year" | uniq | sort | reverse -%}
{%- assign counter = published.size -%}
<div class="papers-grid">
{%- for yr in years -%}
  {%- assign year_papers = published | where: "year", yr -%}
  {%- for paper in year_papers -%}
    <div class="cell-year">{%- if forloop.first -%}{{ yr }}{%- endif -%}</div>
    <div class="cell-num">{{ counter }}.</div>
    <div class="cell-paper">
      {% include paper_entry.html %}
    </div>
    {%- assign counter = counter | minus: 1 -%}
  {%- endfor -%}
{%- endfor -%}
</div>
</div>
