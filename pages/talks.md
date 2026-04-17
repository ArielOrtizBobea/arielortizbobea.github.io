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
.talks-page #talks-view-event:checked ~ .talks-toolbar label[for="talks-view-event"] {
  color: #fff;
  background: #b31b1b;
  border-color: #b31b1b;
}
.talks-page .talks-grouped { display: none; }
.talks-page #talks-view-event:checked ~ .talks-flat { display: none; }
.talks-page #talks-view-event:checked ~ .talks-grouped { display: block; }

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
.talks-page .talk-presenter {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  color: inherit;
  text-decoration: none;
  vertical-align: middle;
}
.talks-page .talk-presenter:hover { color: #b31b1b; }
.talks-page .talk-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  object-fit: cover;
}
.talks-page .talk-meta { color: #6c757d; }

/* --- Grouped view --- */
.talks-page .talk-group { margin-bottom: 2.25rem; }
.talks-page .talk-group-header {
  font-size: 1.05rem;
  font-weight: 600;
  margin: 0 0 0.75rem;
  padding-bottom: 0.35rem;
  border-bottom: 1px solid #dee2e6;
  line-height: 1.4;
}
.talks-page .talk-group-header .talk-meta {
  font-weight: normal;
  font-size: 0.9rem;
}

/* --- Section headings --- */
.talks-page .talks-flat h2 {
  margin-top: 1.5rem;
  font-size: 1.3rem;
}
.talks-page .talks-flat h2:first-child { margin-top: 0; }
</style>

{%- assign now_s = site.time | date: "%s" | plus: 0 -%}
{%- assign year_ago_s = now_s | minus: 31536000 -%}
{%- assign sorted = site.data.talks | sort: "date" -%}

<div class="talks-page" markdown="0">

<input type="radio" name="talks-view" id="talks-view-date" checked hidden>
<input type="radio" name="talks-view" id="talks-view-event" hidden>

<div class="talks-toolbar">
  <label for="talks-view-date" class="talks-view-btn">By date</label>
  <label for="talks-view-event" class="talks-view-btn">By event</label>
</div>

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

<div class="talks-grouped">
{%- assign grouped = sorted | group_by: "venue" -%}
{%- for group in grouped -%}
  {%- assign group_in_window = false -%}
  {%- for talk in group.items -%}
    {%- assign t_s = talk.date | date: "%s" | plus: 0 -%}
    {%- if t_s >= year_ago_s -%}
      {%- assign group_in_window = true -%}
      {%- break -%}
    {%- endif -%}
  {%- endfor -%}

  {%- if group_in_window -%}
    {%- assign first_talk = group.items | first -%}
    <div class="talk-group">
      <div class="talk-group-header">
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
        {%- assign t_s = talk.date | date: "%s" | plus: 0 -%}
        {%- if t_s >= year_ago_s -%}
          {% include talk_entry.html grouped=true %}
        {%- endif -%}
      {%- endfor -%}
    </div>
  {%- endif -%}
{%- endfor -%}
</div>

</div>
