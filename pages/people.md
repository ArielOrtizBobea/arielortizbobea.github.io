---
layout: team
title: people
background: /assets/images/landing/people.png
#description: Who we are
permalink: /people/
---

<style>
/* Alumni divider is injected as an <h3> inside an <h5> via _data/team.yml — force red */
.team-member h5 h3 {
  color: #b31b1b !important;
  font-weight: 600;
  margin: 0;
}

/* Shrink alumni photos to roughly the height of two lines of text */
.team-member.alumni .flex-shrink-0 img {
  width: 60px !important;
  height: 60px !important;
  max-width: 60px !important;
  max-height: 60px !important;
  object-fit: cover;
}

/* Shift only the alumni photo to the right, without moving the text */
.team-member.alumni .flex-shrink-0 img {
  transform: translateX(20px);
}

/* Tighten the gap between the alumni name line and the placement line */
.team-member.alumni h5 {
  margin-bottom: 0.1rem;
}
.team-member.alumni h5 + p {
  margin-top: 0;
}
</style>