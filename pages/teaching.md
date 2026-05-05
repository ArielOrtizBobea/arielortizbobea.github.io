---
title: courses
background: /assets/images/landing/teaching1.png
permalink: /teaching/
---

<style>
.course-list { list-style: none; padding-left: 0; margin: 0; }
.course-entry {
  display: grid;
  grid-template-columns: auto 1fr;
  column-gap: 0.9rem;
  row-gap: 0.35rem;
  align-items: baseline;
  margin-bottom: 1.5rem;
}
.course-code {
  display: inline-block;
  padding: 2px 10px;
  border: 1px solid #b31b1b;
  color: #b31b1b;
  background: #fff;
  border-radius: 3px;
  font-weight: 600;
  font-size: 0.78rem;
  letter-spacing: 0.04em;
  text-decoration: none;
  text-transform: uppercase;
  line-height: 1.4;
  white-space: nowrap;
  justify-self: start;
}
a.course-code:hover {
  background: #b31b1b;
  color: #fff;
  text-decoration: none;
}
.course-title {
  font-weight: 500;
  line-height: 1.4;
  color: #b31b1b;
}
a.course-title {
  color: #b31b1b;
  text-decoration: none;
}
a.course-title:hover {
  color: #b31b1b;
  text-decoration: underline;
}
.offerings-stack {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 0.05rem;
  justify-self: start;
  margin-top: 0.25rem;
}
.offering-row {
  font-size: 0.85rem;
  line-height: 1.55;
  white-space: nowrap;
}
.offering-row .offering-link {
  color: #6c757d;
  text-decoration: none;
}
.offering-row a.offering-link:hover {
  color: #b31b1b;
  text-decoration: underline;
}
.offering-row.is-upcoming .offering-link {
  color: #b31b1b;
  font-weight: 500;
}
.offering-row.is-upcoming a.offering-link:hover {
  text-decoration: underline;
}
.course-description {
  color: #495057;
  font-size: 0.95rem;
  line-height: 1.55;
  margin: 0;
}
.teaching-page h3 {
  color: #b31b1b;
  font-size: 1.5rem;
  font-weight: normal;
  margin-top: 2rem;
  margin-bottom: 1rem;
}
.teaching-page h3:first-child { margin-top: 0; }
.course-catalog-link {
  display: inline-block;
  margin-left: 0.35em;
  color: #6c757d;
  text-decoration: none;
  opacity: 0.65;
  transition: opacity 0.15s ease, color 0.15s ease;
  vertical-align: 0.05em;
}
.course-catalog-link:hover {
  opacity: 1;
  color: #b31b1b;
  text-decoration: none;
}
.course-catalog-link svg {
  width: 0.78em;
  height: 0.78em;
  display: inline;
}
</style>

<div class="teaching-page" markdown="0">

<h3>Current courses</h3>

<ul class="course-list">
  <li class="course-entry">
    <a href="https://arielortizbobea.github.io/aem7010" class="course-code">AEM 7010</a>
    <span><a href="https://arielortizbobea.github.io/aem7010" class="course-title">Doing Applied Economics Research: Practical Skills</a><a href="https://classes.cornell.edu/browse/roster/SP26/class/AEM/7010" class="course-catalog-link" target="_blank" rel="noopener" title="View in Cornell course catalog" aria-label="View AEM 7010 in Cornell course catalog"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg></a></span>
    <div class="offerings-stack">
      <span class="offering-row is-upcoming"><a class="offering-link" href="https://arielortizbobea.github.io/aem7010">Spring 2026</a></span>
    </div>
    <p class="course-description">
      Graduate course on practical research skills, team-taught by three instructors. My section covers trends in empirical economics research, reproducibility, version control with Git, and effective use of AI tools, with a focus on working with secondary data. See the <a href="https://arielortizbobea.github.io/aem7010" target="_blank" rel="noopener">course site</a> for my materials.
    </p>
  </li>
  <li class="course-entry">
    <span class="course-code">AEM 6850</span>
    <span><span class="course-title">Empirical Methods for Applied Economists</span><a href="https://classes.cornell.edu/browse/roster/FA26/class/AEM/6850" class="course-catalog-link" target="_blank" rel="noopener" title="View in Cornell course catalog" aria-label="View AEM 6850 in Cornell course catalog"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg></a></span>
    <div class="offerings-stack">
      <span class="offering-row is-upcoming"><span class="offering-link">Fall 2026</span></span>
    </div>
    <p class="course-description">
      Introduction to empirical research workflows for applied economists: writing R from scratch, data wrangling and visualization, version control with Git and GitHub, and using AI tools effectively. Weekly assignments are submitted via GitHub and audited by classmates for reproducibility, followed by a team or individual research project in the second half of the semester. Aimed at MS, MPS, and second-year PhD students; some coding experience recommended.
    </p>
  </li>
  <li class="course-entry">
    <span class="course-code">AEM 6851</span>
    <span class="course-title">Advanced Empirical Methods for Applied Economists</span>
    <div class="offerings-stack">
      <span class="offering-row is-upcoming"><span class="offering-link">Spring 2027</span></span>
    </div>
    <p class="course-description">
      Sequel to AEM 6850. Focuses on understanding the small-sample properties of econometric estimators through Monte Carlo simulations. Students first build on version control and AI tools, then work through regular GitHub-based exercises on specific estimators, and finish with a course project on an estimator of their choice, ideally tied to their own research. Best suited for PhD and advanced MS students active in a research project who have completed graduate econometrics coursework.
    </p>
  </li>
  <li class="course-entry">
    <span class="course-code">AEM 1500</span>
    <span class="course-title">An Introduction to the Economics of Environmental and Natural Resources</span>
    <div class="offerings-stack">
      <span class="offering-row is-upcoming"><span class="offering-link">Spring 2027</span></span>
    </div>
    <p class="course-description">
      Undergraduate introduction to using economics to understand and address environmental and natural resource problems. No prerequisites, open to students without prior economics coursework. Large-lecture format; first offering in Spring 2027, with possible guest speakers and field-oriented experiences as the course develops.
    </p>
  </li>
</ul>

<h3>Previous courses</h3>

<ul class="course-list">
  <li class="course-entry">
    <span class="course-code">AEM 2500</span>
    <span class="course-title">Environmental and Resource Economics</span>
    <div class="offerings-stack">
      <span class="offering-row"><span class="offering-link">Fall 2025</span></span>
      <span class="offering-row"><span class="offering-link">Fall 2024</span></span>
      <span class="offering-row"><span class="offering-link">Fall 2022</span></span>
      <span class="offering-row"><span class="offering-link">Fall 2021</span></span>
      <span class="offering-row"><span class="offering-link">Fall 2020</span></span>
      <span class="offering-row"><span class="offering-link">Fall 2019</span></span>
      <span class="offering-row"><span class="offering-link">Fall 2018</span></span>
      <span class="offering-row"><span class="offering-link">Fall 2017</span></span>
      <span class="offering-row"><span class="offering-link">Fall 2016</span></span>
      <span class="offering-row"><span class="offering-link">Spring 2015</span></span>
    </div>
    <p class="course-description">
      Uses microeconomics to understand the causes of environmental and natural resource problems and to devise solutions. Subjects include valuation, benefit-cost analysis, policy design, and property rights. The course relies on these concepts to explore major current policy issues such as economic incentives in environmental policy, air and water pollution, depletion of renewable and nonrenewable resources, and global warming. Prerequisites: introductory microeconomics and calculus.
    </p>
  </li>
</ul>

</div>
