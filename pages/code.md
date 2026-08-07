---
title: code
background: /assets/images/landing/people.png
permalink: /code/
---

<style>
.code-page .code-intro {
  line-height: 1.7;
  margin-bottom: 2rem;
}
.code-page .code-entry {
  display: flex;
  gap: 1.25rem;
  align-items: flex-start;
  padding-bottom: 1.5rem;
  margin-bottom: 1.5rem;
  border-bottom: 1px solid #e9ecef;
}
.code-page .code-entry:last-child {
  border-bottom: none;
  padding-bottom: 0;
  margin-bottom: 0;
}
.code-page .code-thumbnail {
  flex-shrink: 0;
  width: 300px;
}
.code-page .code-thumbnail img {
  width: 100%;
  height: auto;
  border-radius: 4px;
  display: block;
  background: #fff;
}
/* Widen the code page content area beyond the default col-lg-8 */
@media (min-width: 992px) {
  .code-page {
    margin-left: -100px;
    margin-right: -100px;
  }
}
.code-page .code-body { flex: 1; min-width: 0; }
.code-page .code-title {
  font-weight: 600;
  line-height: 1.35;
  font-size: 1.02rem;
  margin-bottom: 0.3rem;
}
.code-page .code-desc {
  font-size: 0.95rem;
  line-height: 1.6;
  color: #495057;
  margin-bottom: 0.3rem;
}
.code-page .code-desc em { font-style: italic; }
.code-page .code-links {
  margin-top: 0.5rem;
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}
.code-page .code-links a {
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
.code-page .code-links a:hover {
  color: #b31b1b;
  border-color: #b31b1b;
}
@media (max-width: 700px) {
  .code-page .code-entry { flex-direction: column; }
  .code-page .code-thumbnail { width: 100%; max-width: 300px; }
}
</style>

<div class="code-page" markdown="0">

<p class="code-intro">This page includes links to code that some might find useful.</p>

<div class="code-entry">
  <div class="code-thumbnail">
    <a href="https://www.sciencedirect.com/science/article/pii/S1574007221000025" target="_blank" rel="noopener"><img src="{{ '/assets/images/papers/2021ageconhandbook.jpg' | relative_url }}" alt=""></a>
  </div>
  <div class="code-body">
    <div class="code-title">R code for common empirical tasks in climate change impact assessment</div>
    <div class="code-desc">
      Reproducible R code and data for common tasks of data preparation and model estimation in
      the climate change impacts literature, from the chapter
      <a href="https://www.sciencedirect.com/science/article/pii/S1574007221000025" target="_blank" rel="noopener">The Empirical Analysis of Climate Change Impacts and Adaptation in Agriculture</a>,
      <em>Handbook of Agricultural Economics</em> 5 (2021) 3981&ndash;4073.
      Tasks covered include: fast aggregation of point and gridded weather data; construction of
      temperature exposure bins; semi-parametric estimation of non-linear and within-season
      varying effects of weather; dealing with spatial dependence; and common robustness checks
      presented in specification charts.
    </div>
    <div class="code-links">
      <a href="https://archive.ciser.cornell.edu/reproduction-packages/2856" target="_blank" rel="noopener">code + data</a>
      <a href="https://www.sciencedirect.com/science/article/pii/S1574007221000025" target="_blank" rel="noopener">chapter</a>
      <a href="https://arxiv.org/abs/2105.12044" target="_blank" rel="noopener">preprint</a>
    </div>
  </div>
</div>

<div class="code-entry">
  <div class="code-thumbnail">
    <a href="https://github.com/ArielOrtizBobea/spec_chart" target="_blank" rel="noopener"><img src="{{ '/assets/images/papers/2021natclim.png' | relative_url }}" alt=""></a>
  </div>
  <div class="code-body">
    <div class="code-title">R code for specification charts</div>
    <div class="code-desc">
      An R function for building specification charts, a compact way to visualize the robustness
      of results across many model specifications. Adapted from the charts in
      <a href="https://doi.org/10.1038/s41558-021-01000-1" target="_blank" rel="noopener">Anthropogenic climate change has slowed global agricultural productivity growth</a>,
      <em>Nature Climate Change</em> 11 (2021) 306&ndash;312.
    </div>
    <div class="code-links">
      <a href="https://github.com/ArielOrtizBobea/spec_chart" target="_blank" rel="noopener">GitHub repo</a>
      <a href="https://doi.org/10.1038/s41558-021-01000-1" target="_blank" rel="noopener">paper</a>
    </div>
  </div>
</div>

</div>
