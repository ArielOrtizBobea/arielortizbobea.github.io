---
title: talks
background: /assets/theme/images/landing/talks.png
permalink: /talks/
---

<style>
/* --- View toggle --- */
.talks-page .talks-toolbar {
  display: flex;
  gap: 6px;
  margin: 0 0 1.5rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #dee2e6;
  flex-wrap: wrap;
}
.talks-page .talks-view-btn {
  cursor: pointer;
  padding: 5px 14px;
  border: 1px solid transparent;
  border-radius: 4px;
  color: #6c757d;
  font-size: 0.9rem;
  user-select: none;
  line-height: 1.3;
}
.talks-page .talks-view-btn:hover { color: #b31b1b; }
.talks-page #talks-view-date:checked ~ .talks-toolbar label[for="talks-view-date"],
.talks-page #talks-view-event:checked ~ .talks-toolbar label[for="talks-view-event"],
.talks-page #talks-view-presenter:checked ~ .talks-toolbar label[for="talks-view-presenter"] {
  color: #fff;
  background: #b31b1b;
  border-color: #b31b1b;
}
.talks-page .talks-by-event,
.talks-page .talks-by-presenter { display: none; }
.talks-page #talks-view-event:checked ~ .talks-flat,
.talks-page #talks-view-presenter:checked ~ .talks-flat { display: none; }
.talks-page #talks-view-event:checked ~ .talks-by-event { display: block; }
.talks-page #talks-view-presenter:checked ~ .talks-by-presenter { display: block; }

/* --- Talk entry --- */
.talks-page .talk-entry {
  display: flex;
  gap: 1rem;
  margin-bottom: 1.5rem;
  align-items: flex-start;
}
.talks-page .talk-thumbnail img {
  width: 72px;
  height: 72px;
  object-fit: cover;
  border-radius: 4px;
  display: block;
}
.talks-page .talk-body { flex: 1; min-width: 0; }
.talks-page .talk-title {
  font-weight: 600;
  margin-bottom: 0.3rem;
  line-height: 1.35;
  font-size: 1.02rem;
}
.talks-page .talk-title a { color: inherit; }
.talks-page .talk-title a:hover { color: #b31b1b; }
.talks-page .talk-meta-line {
  font-size: 0.9rem;
  line-height: 1.5;
}
.talks-page .talk-avatar-link {
  flex-shrink: 0;
  display: block;
  line-height: 0;
}
.talks-page .talk-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
  display: block;
}
.talks-page .talk-presenter-name {
  color: inherit;
  text-decoration: none;
  font-weight: 500;
}
.talks-page .talk-presenter-name:hover { color: #b31b1b; }
.talks-page .talk-loc-icon {
  color: #b31b1b;
  opacity: 0.85;
  margin-right: 2px;
}
.talks-page .talk-meta { color: #6c757d; }

/* --- Grouped: by event --- */
.talks-page .event-group { margin-bottom: 2.25rem; }
.talks-page .event-group-header {
  font-size: 1.05rem;
  font-weight: 600;
  margin: 0 0 0.75rem;
  padding-bottom: 0.35rem;
  border-bottom: 1px solid #dee2e6;
  line-height: 1.4;
}
.talks-page .event-group-header .talk-meta {
  font-weight: normal;
  font-size: 0.9rem;
}

/* --- Grouped: by presenter --- */
.talks-page .presenter-group { margin-bottom: 2.25rem; }
.talks-page .presenter-group-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin: 0 0 0.9rem;
  padding-bottom: 0.4rem;
  border-bottom: 1px solid #dee2e6;
}
.talks-page .presenter-group-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  object-fit: cover;
  display: block;
  flex-shrink: 0;
}
.talks-page .presenter-group-name {
  font-size: 1.1rem;
  font-weight: 600;
  color: inherit;
  text-decoration: none;
}
.talks-page .presenter-group-name:hover { color: #b31b1b; }

/* --- Section headings --- */
.talks-page h2 {
  margin-top: 1.5rem;
  font-size: 1.3rem;
  color: #b31b1b;
}
.talks-page h2:first-child { margin-top: 0; }

/* --- Stacked meta (used in "By presenter" view) --- */
.talks-page .talk-meta-row {
  font-size: 0.9rem;
  line-height: 1.6;
  display: flex;
  align-items: baseline;
  gap: 6px;
}
.talks-page .talk-cal-icon {
  color: #b31b1b;
  opacity: 0.85;
  width: 14px;
  text-align: center;
}
.talks-page .talk-meta-row .talk-loc-icon {
  width: 14px;
  text-align: center;
  margin-right: 0;
}
</style>

{%- assign now_s = site.time | date: "%s" | plus: 0 -%}
{%- assign year_ago_s = now_s | minus: 31536000 -%}
{%- assign sorted = site.data.talks | sort: "date" -%}

<div class="talks-page" markdown="0">

<input type="radio" name="talks-view" id="talks-view-date" checked hidden>
<input type="radio" name="talks-view" id="talks-view-event" hidden>
<input type="radio" name="talks-view" id="talks-view-presenter" hidden>

<div class="talks-toolbar">
  <label for="talks-view-date" class="talks-view-btn">By date</label>
  <label for="talks-view-event" class="talks-view-btn">By event</label>
  <label for="talks-view-presenter" class="talks-view-btn">By presenter</label>
</div>

<!-- ========== BY DATE ========== -->
<div class="talks-flat">
<h2>Upcoming</h2>
{%- assign any_upcoming = false -%}
{%- for talk in sorted -%}
  {%- assign t_s = talk.date | date: "%s" | plus: 0 -%}
  {%- if t_s >= now_s -%}
    {%- assign any_upcoming = true -%}
    {% include talk_entry.html %}
  {%- endif -%}
{%- endfor -%}
{%- if any_upcoming == false -%}
<p class="talk-meta">No upcoming talks scheduled.</p>
{%- endif -%}

<h2>Recent</h2>
{%- assign reversed = sorted | reverse -%}
{%- assign any_recent = false -%}
{%- for talk in reversed -%}
  {%- assign t_s = talk.date | date: "%s" | plus: 0 -%}
  {%- if t_s < now_s and t_s >= year_ago_s -%}
    {%- assign any_recent = true -%}
    {% include talk_entry.html %}
  {%- endif -%}
{%- endfor -%}
{%- if any_recent == false -%}
<p class="talk-meta">No talks in the past year.</p>
{%- endif -%}
</div>

<!-- ========== BY EVENT ========== -->
<div class="talks-by-event">
{%- assign by_venue = sorted | group_by: "venue" -%}

<h2>Upcoming</h2>
{%- assign any_upcoming_event = false -%}
{%- for group in by_venue -%}
  {%- assign last_talk = group.items | last -%}
  {%- if last_talk.date_end -%}
    {%- assign group_end_s = last_talk.date_end | date: "%s" | plus: 0 -%}
  {%- else -%}
    {%- assign group_end_s = last_talk.date | date: "%s" | plus: 0 -%}
  {%- endif -%}
  {%- if group_end_s >= now_s -%}
    {%- assign any_upcoming_event = true -%}
    {%- assign first_talk = group.items | first -%}
    <div class="event-group">
      <div class="event-group-header">
        {{ group.name }}
        <span class="talk-meta">
          &middot; {{ first_talk.location }}
          &middot;
          {%- if first_talk.date_end -%}
            {%- assign sm = first_talk.date | date: "%m" -%}
            {%- assign em = first_talk.date_end | date: "%m" -%}
            {%- if sm == em -%}
            {{ first_talk.date | date: "%b %-d" }}&ndash;{{ first_talk.date_end | date: "%-d, %Y" }}
            {%- else -%}
            {{ first_talk.date | date: "%b %-d" }} &ndash; {{ first_talk.date_end | date: "%b %-d, %Y" }}
            {%- endif -%}
          {%- else -%}
          {{ first_talk.date | date: "%b %-d, %Y" }}
          {%- endif -%}
        </span>
      </div>
      {%- for talk in group.items -%}
        {% include talk_entry.html hide_venue=true hide_date=true %}
      {%- endfor -%}
    </div>
  {%- endif -%}
{%- endfor -%}
{%- if any_upcoming_event == false -%}
<p class="talk-meta">No upcoming events.</p>
{%- endif -%}

<h2>Past</h2>
{%- assign by_venue_rev = by_venue | reverse -%}
{%- assign any_past_event = false -%}
{%- for group in by_venue_rev -%}
  {%- assign last_talk = group.items | last -%}
  {%- if last_talk.date_end -%}
    {%- assign group_end_s = last_talk.date_end | date: "%s" | plus: 0 -%}
  {%- else -%}
    {%- assign group_end_s = last_talk.date | date: "%s" | plus: 0 -%}
  {%- endif -%}
  {%- if group_end_s < now_s and group_end_s >= year_ago_s -%}
    {%- assign any_past_event = true -%}
    {%- assign first_talk = group.items | first -%}
    <div class="event-group">
      <div class="event-group-header">
        {{ group.name }}
        <span class="talk-meta">
          &middot; {{ first_talk.location }}
          &middot;
          {%- if first_talk.date_end -%}
            {%- assign sm = first_talk.date | date: "%m" -%}
            {%- assign em = first_talk.date_end | date: "%m" -%}
            {%- if sm == em -%}
            {{ first_talk.date | date: "%b %-d" }}&ndash;{{ first_talk.date_end | date: "%-d, %Y" }}
            {%- else -%}
            {{ first_talk.date | date: "%b %-d" }} &ndash; {{ first_talk.date_end | date: "%b %-d, %Y" }}
            {%- endif -%}
          {%- else -%}
          {{ first_talk.date | date: "%b %-d, %Y" }}
          {%- endif -%}
        </span>
      </div>
      {%- for talk in group.items -%}
        {% include talk_entry.html hide_venue=true hide_date=true %}
      {%- endfor -%}
    </div>
  {%- endif -%}
{%- endfor -%}
{%- if any_past_event == false -%}
<p class="talk-meta">No past events in the last year.</p>
{%- endif -%}
</div>

<!-- ========== BY PRESENTER ========== -->
<div class="talks-by-presenter">
{%- assign by_presenter = sorted | group_by: "presenter" -%}
{%- for group in by_presenter -%}
  {%- assign group_in_window = false -%}
  {%- for talk in group.items -%}
    {%- assign t_s = talk.date | date: "%s" | plus: 0 -%}
    {%- if t_s >= year_ago_s -%}
      {%- assign group_in_window = true -%}
      {%- break -%}
    {%- endif -%}
  {%- endfor -%}

  {%- if group_in_window -%}
    {%- assign p_data = site.data.team | where: "name", group.name | first -%}
    <div class="presenter-group">
      <div class="presenter-group-header">
        {%- if p_data.image -%}
        <a href="{{ '/people/' | relative_url }}#{{ group.name | strip | url_encode }}">
          <img src="{{ p_data.image | relative_url }}" alt="{{ group.name }}" class="presenter-group-avatar">
        </a>
        {%- endif -%}
        {%- if p_data -%}
        <a href="{{ '/people/' | relative_url }}#{{ group.name | strip | url_encode }}" class="presenter-group-name">{{ group.name }}</a>
        {%- else -%}
        <span class="presenter-group-name">{{ group.name }}</span>
        {%- endif -%}
      </div>
      {%- for talk in group.items -%}
        {%- assign t_s = talk.date | date: "%s" | plus: 0 -%}
        {%- if t_s >= year_ago_s -%}
          {% include talk_entry.html hide_presenter=true stacked_meta=true %}
        {%- endif -%}
      {%- endfor -%}
    </div>
  {%- endif -%}
{%- endfor -%}
</div>

</div>
