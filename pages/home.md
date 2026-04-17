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
    <p style="font-size: 1.1em;">I am an applied economist studying how climate and environmental change reshape economic activity, with a particular focus on agriculture.</p>

    <h5 style="color: #b31b1b; margin-top: 24px; margin-bottom: 6px;">Positions & Affiliations</h5>
    Associate Professor, <a href="https://dyson.cornell.edu" target="_blank">Charles H. Dyson School of Applied Economics and Management</a> & <a href="https://publicpolicy.cornell.edu" target="_blank">Jeb E. Brooks School of Public Policy</a>, Cornell University
    <br/> Faculty Fellow, <a href="https://www.atkinson.cornell.edu" target="_blank">Cornell Atkinson Center for Sustainability</a>

    <h5 style="color: #b31b1b; margin-top: 24px; margin-bottom: 6px;">Editorial</h5>
    Editorial Council, <a href="https://www.journals.uchicago.edu/journal/jaere" target="_blank"><em>Journal of the Association of Environmental and Resource Economists</em></a>
    <br/> Associate Deputy Editor, <a href="https://link.springer.com/journal/10584" target="_blank"><em>Climatic Change</em></a>
    <br/> Editorial Board, <a href="https://iopscience.iop.org/journal/2976-601X" target="_blank"><em>Environmental Research: Food Systems</em></a>
    <br/> Editorial Advisory Board, <a href="https://www.cambridge.org/core/journals/journal-of-wine-economics" target="_blank"><em>Journal of Wine Economics</em></a>

    <h5 style="color: #b31b1b; margin-top: 24px; margin-bottom: 6px;">Contact</h5>
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

<!-- Upcoming talks teaser: pulls next 3 from _data/talks.yml -->
<div class="container-fluid px-4" style="margin-top: 36px;">
  <h5 style="color: #b31b1b; margin-bottom: 12px;">Upcoming Talks</h5>
  <div style="line-height: 1.7;">
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