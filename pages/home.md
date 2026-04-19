---
layout: home
title: home
#description: Associate Professor of Applied Economics and Policy
permalink: /
---

<!--
PLEASE READ THIS BEFORE EDIT THE HOME PAGE
- To have two columns, use an html table to emulate a table with two columns

- This is how embeed links in a html code
<a href="https://dyson.cornell.edu" target="_blank">Charles H. Dyson School of Applied Economics and Management</a>

<br/> is just space between paragraphs in html
-->
<div class="container-fluid px-4">
  <div class="row">
    <div class="text-center col-md-auto">
      <p class='text-center'>
        <img src="/assets/theme/images/landing/aob1.jpg" alt="Photo of Ariel Ortiz-Bobea" style="width: 350px"/>      
        </p>
    </div>
    <div class="col" style="line-height: 1.8;">
    <h5 style="color: #b31b1b; margin-bottom: 6px;">Research Focus</h5>
    <div style="padding-left: 1rem;">
    <p style="font-size: 1.1em;">I am an applied economist studying how climate and environmental change reshape economic activity, with a particular focus on agriculture.</p>
    </div>

    <h5 style="color: #b31b1b; margin-top: 24px; margin-bottom: 6px;">Positions & Affiliations</h5>
    <div style="padding-left: 1rem;">
    Associate Professor, <a href="https://dyson.cornell.edu" target="_blank">Charles H. Dyson School of Applied Economics and Management</a> & <a href="https://publicpolicy.cornell.edu" target="_blank">Jeb E. Brooks School of Public Policy</a>, Cornell University
    <br/> Faculty Fellow, <a href="https://www.atkinson.cornell.edu" target="_blank">Cornell Atkinson Center for Sustainability</a>
    </div>

    <h5 style="color: #b31b1b; margin-top: 24px; margin-bottom: 6px;">Editorial</h5>
    <div style="padding-left: 1rem;">
    Editorial Council, <a href="https://www.journals.uchicago.edu/journal/jaere" target="_blank"><em>Journal of the Association of Environmental and Resource Economists</em></a>
    <br/> Associate Deputy Editor, <a href="https://link.springer.com/journal/10584" target="_blank"><em>Climatic Change</em></a>
    <br/> Editorial Board, <a href="https://iopscience.iop.org/journal/2976-601X" target="_blank"><em>Environmental Research: Food Systems</em></a>
    <br/> Editorial Advisory Board, <a href="https://www.cambridge.org/core/journals/journal-of-wine-economics" target="_blank"><em>Journal of Wine Economics</em></a>
    </div>

    <h5 style="color: #b31b1b; margin-top: 24px; margin-bottom: 6px;">Contact</h5>
    <div style="padding-left: 1rem;">
    <i class="fa-solid fa-location-dot" style="color: #b31b1b; width: 18px;"></i> 450B Warren Hall
    <br/> <i class="fa-solid fa-envelope" style="color: #b31b1b; width: 18px;"></i> <a href="mailto:ao332@cornell.edu">ao332@cornell.edu</a>
    <br/> <i class="fa-solid fa-phone" style="color: #b31b1b; width: 18px;"></i> 607.255.0220
    <br/>
    <span style="font-size: 1.3em; margin-top: 8px; display: inline-block;">
    <a href="https://scholar.google.com/citations?user=MALB7wEAAAAJ&hl=en" target="_blank" title="Google Scholar" style="margin: 0 5px;"><i class="fa-brands fa-google-scholar"></i></a>
    <a href="https://github.com/arielortizbobea" target="_blank" title="GitHub" style="margin: 0 5px;"><i class="fa-brands fa-github"></i></a>
    <a href="https://bsky.app/profile/arielob.bsky.social" target="_blank" title="Bluesky" style="margin: 0 5px;"><i class="fa-brands fa-bluesky"></i></a>
    <a href="https://x.com/ArielOrtizBobea" target="_blank" title="X / Twitter" style="margin: 0 5px;"><i class="fa-brands fa-x-twitter"></i></a>
    <a href="https://www.linkedin.com/in/ariel-ortiz-bobea-a904637" target="_blank" title="LinkedIn" style="margin: 0 5px;"><i class="fa-brands fa-linkedin"></i></a>
    </span>
    </div>
    </div>
  </div>
</div>

<!-- Recent publications: pulls papers with featured_home: true from _data/papers.yml -->
<style>
.recent-pubs-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-top: 0.5rem;
}
@media (max-width: 900px) {
  .recent-pubs-grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 500px) {
  .recent-pubs-grid { grid-template-columns: 1fr; }
}
.recent-pub-card { display: flex; flex-direction: column; }
.recent-pub-card .thumb {
  width: 100%;
  aspect-ratio: 1 / 1;
  overflow: hidden;
  border-radius: 4px;
  background: #f8f9fa;
  margin-bottom: 10px;
  display: block;
}
.recent-pub-card .thumb img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  display: block;
  transition: transform 0.2s ease;
}
.recent-pub-card .thumb:hover img { transform: scale(1.03); }
.recent-pub-card .journal {
  font-style: italic;
  font-size: 0.85rem;
  color: #b31b1b;
  margin-bottom: 4px;
  line-height: 1.35;
}
.recent-pub-card .title {
  font-weight: 600;
  font-size: 0.95rem;
  line-height: 1.35;
  margin-bottom: 6px;
  color: inherit;
  text-decoration: none;
  display: block;
}
.recent-pub-card a.title:hover { color: #b31b1b; }
.recent-pub-card .meta {
  font-size: 0.85rem;
  color: #6c757d;
  line-height: 1.4;
}
</style>
<div class="container-fluid px-4" style="margin-top: 36px;">
  <h5 style="color: #b31b1b; margin-bottom: 12px;">Recent Publications</h5>
  <div style="padding-left: 1rem;">
  {%- assign featured = site.data.papers | where: "featured_home", true | sort: "year" | reverse -%}
  <div class="recent-pubs-grid">
  {%- for paper in featured -%}
    <div class="recent-pub-card">
      {%- if paper.thumbnail -%}
        {%- if paper.doi -%}
          <a href="{{ paper.doi }}" target="_blank" rel="noopener" class="thumb"><img src="{{ paper.thumbnail }}" alt="{{ paper.title | escape }}"></a>
        {%- else -%}
          <div class="thumb"><img src="{{ paper.thumbnail }}" alt="{{ paper.title | escape }}"></div>
        {%- endif -%}
      {%- endif -%}
      <div class="journal">{{ paper.journal }}</div>
      {%- if paper.doi -%}
        <a href="{{ paper.doi }}" target="_blank" rel="noopener" class="title">{{ paper.title }}</a>
      {%- else -%}
        <span class="title">{{ paper.title }}</span>
      {%- endif -%}
      <div class="meta">
        {%- if paper.authors.size <= 3 -%}
          {{ paper.authors | join: ", " }}
        {%- else -%}
          {{ paper.authors | first }} et al.
        {%- endif -%}
        {%- if paper.year %} &middot; {{ paper.year }}{%- endif -%}
      </div>
    </div>
  {%- endfor -%}
  </div>
  <div style="margin-top: 12px; font-size: 0.9em;"><a href="{{ '/research/' | relative_url }}">See all publications &rarr;</a></div>
  </div>
</div>

<!-- Upcoming talks teaser: pulls next 3 from _data/talks.yml -->
<div class="container-fluid px-4" style="margin-top: 36px;">
  <h5 style="color: #b31b1b; margin-bottom: 12px;">Upcoming Talks</h5>
  <div style="line-height: 1.7; padding-left: 1rem;">
  {%- assign now_s = site.time | date: "%s" | plus: 0 -%}
  {%- assign sorted = site.data.talks | sort: "date" -%}
  {%- assign count = 0 -%}
  {%- for talk in sorted -%}
    {%- assign t_s = talk.date | date: "%s" | plus: 0 -%}
    {%- if t_s >= now_s and count < 3 -%}
      <div style="margin-bottom: 4px;">
        <strong>{{ talk.date | date: "%b %-d" }}</strong>
        &middot;
        {% if talk.paper %}<a href="{{ talk.paper }}" target="_blank" rel="noopener">{{ talk.title }}</a>{% else %}{{ talk.title }}{% endif %}
        <span style="color: #6c757d;">&mdash; {{ talk.presenter }}, {{ talk.venue }}</span>
      </div>
      {%- assign count = count | plus: 1 -%}
    {%- endif -%}
  {%- endfor -%}
  {%- if count == 0 -%}
  <div style="color: #6c757d;">No upcoming talks scheduled.</div>
  {%- endif -%}
  <div style="margin-top: 10px; font-size: 0.9em;"><a href="{{ '/talks/' | relative_url }}">See all talks &rarr;</a></div>
  </div>
</div>

<!-- This is Markdown 
    So links are [text](link).
--->