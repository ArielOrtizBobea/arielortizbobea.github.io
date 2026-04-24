---
title: in the news
background: /assets/theme/images/landing/research.png
permalink: /news/
---

<style>
.news-page h2 {
  color: #b31b1b;
  font-size: 1.5rem;
  font-weight: 600;
  margin-top: 2rem;
}
.news-page h2:first-child { margin-top: 0; }

.news-page .news-list {
  margin-top: 1.5rem;
}
.news-page .news-entry {
  display: flex;
  gap: 1.25rem;
  align-items: flex-start;
  padding-bottom: 1.25rem;
  margin-bottom: 1.25rem;
  border-bottom: 1px solid #e9ecef;
}
.news-page .news-entry:last-child {
  border-bottom: none;
  margin-bottom: 0;
}
.news-page .news-thumb {
  flex: 0 0 200px;
  width: 200px;
  aspect-ratio: 16 / 10;
  overflow: hidden;
  border-radius: 4px;
  background: #f5f5f5;
}
.news-page .news-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: transform 0.2s ease;
}
.news-page .news-thumb:hover img { transform: scale(1.03); }

.news-page .news-body { min-width: 0; flex: 1; }
.news-page .news-outlet {
  font-style: italic;
  font-size: 0.9rem;
  color: #b31b1b;
  margin-bottom: 0.25rem;
}
.news-page .news-title {
  font-weight: 600;
  font-size: 1.05rem;
  line-height: 1.35;
  margin-bottom: 0.3rem;
}
.news-page .news-title a { color: inherit; text-decoration: none; }
.news-page .news-title a:hover { color: #b31b1b; }
.news-page .news-date {
  font-size: 0.85rem;
  color: #6c757d;
  margin-bottom: 0.4rem;
}
.news-page .news-description {
  font-size: 0.95rem;
  line-height: 1.55;
  color: #495057;
  margin-bottom: 0;
}

@media (max-width: 600px) {
  .news-page .news-entry {
    flex-direction: column;
  }
  .news-page .news-thumb {
    flex-basis: auto;
    width: 100%;
    max-width: 320px;
  }
}
</style>

<div class="news-page">

{%- assign items = site.data.news | sort: "date" | reverse -%}

{%- if items.size == 0 -%}
<p style="color: #6c757d;">No news items yet.</p>
{%- else -%}
<div class="news-list">
{%- for item in items -%}
  <div class="news-entry">
    {%- if item.image -%}
    <a href="{{ item.url }}" target="_blank" rel="noopener" class="news-thumb">
      <img src="{{ item.image }}" alt="{{ item.title | escape }}">
    </a>
    {%- endif -%}
    <div class="news-body">
      {%- if item.outlet -%}
      <div class="news-outlet">{{ item.outlet }}</div>
      {%- endif -%}
      <div class="news-title">
        <a href="{{ item.url }}" target="_blank" rel="noopener">{{ item.title }}</a>
      </div>
      <div class="news-date">{{ item.date | date: "%B %-d, %Y" }}</div>
      {%- if item.description -%}
      <p class="news-description">{{ item.description }}</p>
      {%- endif -%}
    </div>
  </div>
{%- endfor -%}
</div>
{%- endif -%}

</div>
