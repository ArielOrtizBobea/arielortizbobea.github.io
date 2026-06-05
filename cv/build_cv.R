#!/usr/bin/env Rscript
# ============================================================================
#  build_cv.R — Generate the CV PDF from _data/*.yml
#
#  Usage:    Rscript cv/build_cv.R
#  Output:   cv/output/ortiz-bobea-cv.pdf
#
#  Pipeline:
#    1. Read every _data/*.yml the CV uses.
#    2. Build each section as a character vector of LaTeX lines.
#    3. Write cv/cv-body.tex (auto-generated; gitignored).
#    4. Compile cv/cv.tex with pdflatex (via tinytex).
#    5. Move the resulting PDF to cv/output/.
#
#  Base R + yaml only. No tidyverse, no external CSL/biblatex.
# ============================================================================

suppressPackageStartupMessages({
  library(yaml)
})

# ----- Paths -----
script_args <- commandArgs(trailingOnly = FALSE)
fa <- grep("--file=", script_args, fixed = TRUE, value = TRUE)
if (length(fa) > 0) {
  script_path <- normalizePath(sub("--file=", "", fa[1]))
} else if (!is.null(attr(sys.frames()[[1L]], "ofile"))) {
  script_path <- normalizePath(attr(sys.frames()[[1L]], "ofile"))
} else {
  script_path <- normalizePath(file.path(getwd(), "cv", "build_cv.R"))
}
cv_dir     <- dirname(script_path)
repo_root  <- dirname(cv_dir)
data_dir   <- file.path(repo_root, "_data")
output_dir <- file.path(cv_dir, "output")
body_tex   <- file.path(cv_dir, "cv-body.tex")

dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# ----- Read data -----
read_d <- function(n) yaml::read_yaml(file.path(data_dir, paste0(n, ".yml")))

profile    <- read_d("profile")
education  <- read_d("education")
employment <- read_d("employment")
papers     <- read_d("papers")
talks      <- read_d("talks")
grants     <- read_d("grants")
awards     <- read_d("awards")
service    <- read_d("service")
students   <- read_d("students")
referee    <- read_d("referee")
teaching   <- read_d("teaching")
topics     <- read_d("topics")
team       <- read_d("team")

# ============================================================================
#  Helpers
# ============================================================================

`%||%` <- function(a, b) if (is.null(a) || length(a) == 0) b else a

tex_escape <- function(x) {
  if (is.null(x)) return("")
  x <- as.character(x)
  x <- gsub("\\", "\\textbackslash{}", x, fixed = TRUE)
  x <- gsub("&", "\\&",  x, fixed = TRUE)
  x <- gsub("%", "\\%",  x, fixed = TRUE)
  x <- gsub("$", "\\$",  x, fixed = TRUE)
  x <- gsub("#", "\\#",  x, fixed = TRUE)
  x <- gsub("_", "\\_",  x, fixed = TRUE)
  x <- gsub("{", "\\{",  x, fixed = TRUE)
  x <- gsub("}", "\\}",  x, fixed = TRUE)
  x <- gsub("~", "\\textasciitilde{}", x, fixed = TRUE)
  x <- gsub("^", "\\textasciicircum{}", x, fixed = TRUE)
  x
}

# Build name+alias set from team.yml so we can bold AOB in author lists
aob_entry <- Filter(function(m) identical(m$name, "Ariel Ortiz-Bobea"), team)[[1]]
aob_names <- tolower(c(aob_entry$name, aob_entry$aliases))
is_aob <- function(s) tolower(s) %in% aob_names

render_author <- function(name) {
  esc <- tex_escape(name)
  if (is_aob(name)) paste0("\\textbf{", esc, "}") else esc
}

# Map a free-form link label (e.g. "press release", "code + data") to a
# normalized short tag for pill rendering. Returns NA for labels we
# choose not to show on the CV (e.g. podcast, coverage).
normalize_link_label <- function(label) {
  if (is.null(label)) return(NA_character_)
  s <- tolower(label)
  if (grepl("code",        s)) return("code")
  if (grepl("preprint",    s)) return("preprint")
  if (grepl("press",       s)) return("press")
  if (grepl("award",       s)) return("award")
  if (grepl("polic",       s)) return("policy")
  NA_character_  # skip everything else (coverage, podcast, op-ed, etc.)
}

# Render pills for a paper's `links` array (skips unsupported categories).
render_link_pills <- function(links) {
  if (is.null(links) || length(links) == 0) return("")
  parts <- character(0)
  for (l in links) {
    tag <- normalize_link_label(l$label)
    if (is.na(tag)) next
    parts <- c(parts, paste0("\\cvpill{", l$url, "}{", tag, "}"))
  }
  if (length(parts) == 0) return("")
  paste0(" ", paste(parts, collapse = "\\,"))
}

render_authors <- function(authors, threshold = 10) {
  if (length(authors) == 0) return("")
  if (length(authors) <= threshold) {
    parts <- vapply(authors, render_author, character(1))
    n <- length(parts)
    if (n == 1) return(parts)
    if (n == 2) return(paste(parts, collapse = " and "))
    return(paste(paste(parts[-n], collapse = ", "), parts[n], sep = ", and "))
  }
  # > threshold authors: truncate to "First, ..., AOB, et al."
  # AOB stays visible so the credit is preserved on mega-author papers.
  aob_idx <- which(vapply(authors, is_aob, logical(1)))
  first <- render_author(authors[[1]])
  if (length(aob_idx) == 0) {
    paste0(first, ", et al.")
  } else if (aob_idx[1] == 1) {
    paste0(first, ", et al.")
  } else {
    paste0(first, ", \\ldots, ", render_author(authors[[aob_idx[1]]]), ", et al.")
  }
}

# Month/year range "MM/YYYY--MM/YYYY" or "MM/YYYY--present".
# With break_range = TRUE (default), ranges break across two lines via
# \newline so the date column in tabularx stays narrow. With FALSE,
# ranges render as a single line (used when there is no narrow column,
# e.g. when the range sits at the end of an itemize entry).
format_range_my <- function(item, break_range = TRUE) {
  start <- if (!is.null(item$month_start)) {
    sprintf("%d/%d", item$month_start, item$year_start)
  } else {
    as.character(item$year_start)
  }
  sep <- if (break_range) "--\\newline " else "--"
  if (isTRUE(item$current)) return(paste0(start, sep, "present"))
  if (!is.null(item$year_end)) {
    end <- if (!is.null(item$month_end)) {
      sprintf("%d/%d", item$month_end, item$year_end)
    } else {
      as.character(item$year_end)
    }
    if (start == end) start else paste0(start, sep, end)
  } else {
    start
  }
}

format_range_y <- function(item, break_range = TRUE) {
  sep <- if (break_range) "--\\newline " else "--"
  if (isTRUE(item$current)) return(paste0(item$year_start, sep, "present"))
  if (!is.null(item$year_end) && item$year_end != item$year_start) {
    paste0(item$year_start, sep, item$year_end)
  } else {
    as.character(item$year_start)
  }
}

# Date helpers for talks
as_date_safe <- function(x) {
  if (inherits(x, "Date")) return(x)
  if (is.null(x)) return(NA)
  as.Date(as.character(x))
}

# Day-of-month as a plain integer (portable; avoids %-d which is not
# supported on all strftime implementations including R on macOS).
day_of <- function(d) as.integer(format(d, "%d"))

format_talk_date <- function(date, date_end = NULL, approx = FALSE) {
  d <- as_date_safe(date)
  if (is.na(d)) return("")
  if (isTRUE(approx)) return(format(d, "%B %Y"))
  if (is.null(date_end)) {
    return(paste0(format(d, "%B "), day_of(d), ", ", format(d, "%Y")))
  }
  de <- as_date_safe(date_end)
  if (format(d, "%Y-%m") == format(de, "%Y-%m")) {
    paste0(format(d, "%B "), day_of(d), "--", day_of(de), ", ", format(d, "%Y"))
  } else if (format(d, "%Y") == format(de, "%Y")) {
    paste0(format(d, "%B "), day_of(d), "--", format(de, "%B "), day_of(de), ", ", format(d, "%Y"))
  } else {
    paste0(format(d, "%B "), day_of(d), ", ", format(d, "%Y"),
           "--", format(de, "%B "), day_of(de), ", ", format(de, "%Y"))
  }
}

# Map papers.yml status values to the CV labels AOB prefers
# ("Revisions requested" → "R&R", "Under review" → "Submitted").
status_label <- function(s) {
  switch(s,
    "Revisions requested (R1)" = "R\\&R (R1)",
    "Revisions requested (R2)" = "R\\&R (R2)",
    "Revisions requested (R3)" = "R\\&R (R3)",
    "Under review"             = "Submitted",
    s
  )
}

format_thousands <- function(n) {
  formatC(n, big.mark = ",", format = "d")
}

format_amount <- function(item) {
  if (is.null(item$amount_total)) return("")
  s <- paste0("\\$", format_thousands(item$amount_total))
  if (isTRUE(item$amount_approx)) s <- paste(s, "approx.")
  if (!is.null(item$amount_managed)) {
    s <- paste0(s, " (AOB-managed: \\$", format_thousands(item$amount_managed), ")")
  }
  s
}

cv_section <- function(title) {
  c("", paste0("\\cvsection{", tex_escape(title), "}"), "")
}

cv_subsection <- function(title) {
  paste0("\\cvsubsection{", tex_escape(title), "}")
}

# Render a single "date-prefix" entry as a paragraph with hanging indent,
# so the year/range sits at the left margin and the description wraps to
# align with where the description starts. Paragraph-flow lets LaTeX
# break between entries — unlike a tabularx which is atomic per page.
date_entry <- function(date, body, date_width = "0.85in") {
  paste0(
    "\\noindent\\hangindent=", date_width, "\\hangafter=1",
    "\\makebox[", date_width, "][l]{", date, "}",
    body,
    "\\par"
  )
}

# ============================================================================
#  Section builders
# ============================================================================

# Country name → ISO 3166-1 alpha-3 code (for the compact citizenship line).
# Extend as needed; falls back to the original name if not listed.
country_code <- function(name) {
  codes <- list(
    "Dominican Republic" = "DOM",
    "Italy"              = "ITA",
    "United States"      = "USA",
    "France"             = "FRA",
    "Spain"              = "ESP",
    "Germany"            = "DEU",
    "United Kingdom"     = "GBR"
  )
  codes[[name]] %||% name
}

# ----- Header (Blevins style: name uppercase, date on a separate line) -----
build_header <- function() {
  addr <- paste(vapply(profile$address, tex_escape, character(1)), collapse = "\\\\\n")
  cit  <- paste(vapply(profile$citizenship, function(c) tex_escape(country_code(c)), character(1)),
                collapse = ", ")
  website_display <- sub("^https?://", "", profile$website)
  today <- paste0(format(Sys.Date(), "%B "), format(Sys.Date(), "%Y"))
  c(
    paste0("\\noindent{\\LARGE\\uppercase{", tex_escape(profile$name), "}}\\par"),
    "\\vspace{0.4em}",
    paste0("\\noindent ", tex_escape(today), "\\par"),
    "\\vspace{0.8em}",
    "\\noindent",
    "\\begin{minipage}[t]{0.7\\textwidth}\\raggedright",
    addr,
    "\\end{minipage}\\hfill",
    "\\begin{minipage}[t]{0.28\\textwidth}\\raggedright",
    paste0("\\href{", profile$website, "}{", tex_escape(website_display), "}\\\\"),
    paste0("\\href{mailto:", profile$email, "}{", tex_escape(profile$email), "}\\\\"),
    paste0(tex_escape(profile$phone), " (office)\\\\"),
    paste0("Citizenship: ", cit),
    "\\end{minipage}",
    "\\par"
  )
}

# ----- Education -----
build_education <- function() {
  out <- character(0)
  for (e in education) {
    main <- paste0("\\textit{", tex_escape(e$degree), "}")
    if (!is.null(e$field))       main <- paste0(main, ", ", tex_escape(e$field))
    main <- paste0(main, ", ", tex_escape(e$institution))
    if (!is.null(e$department))  main <- paste0(main, ", ", tex_escape(e$department))
    out <- c(out, date_entry(as.character(e$year_end), main, date_width = "0.45in"))
    if (!is.null(e$institution_now)) {
      out <- c(out, date_entry("",
        paste0("{\\small (now ", tex_escape(e$institution_now), ")}"),
        date_width = "0.45in"))
    }
  }
  out
}

# ----- Topics -----
build_topics <- function() {
  t_main <- paste(vapply(topics$topics, tex_escape, character(1)), collapse = "; ")
  gf <- paste(vapply(topics$cornell_graduate_fields, tex_escape, character(1)), collapse = "; ")
  c(
    paste0(t_main, "."),
    "",
    paste0("Graduate Fields at Cornell: ", gf, ".")
  )
}

# ----- Appointments (grouped by institution, Blevins-style) -----
# Top-level item: institution + location. Nested items: title + department
# + date range, in YAML order. If an institution has only one entry, it
# renders inline (no nested list). Current roles still come before past.
build_appointments <- function() {
  current_items <- Filter(function(x) isTRUE(x$current), employment)
  past_items    <- Filter(function(x) !isTRUE(x$current), employment)
  items <- c(current_items, past_items)
  # Group by institution, preserving first-seen order
  by_inst <- list()
  inst_order <- character(0)
  for (e in items) {
    key <- e$institution %||% "(unknown)"
    if (is.null(by_inst[[key]])) {
      by_inst[[key]] <- list()
      inst_order <- c(inst_order, key)
    }
    by_inst[[key]] <- c(by_inst[[key]], list(e))
  }
  render_role <- function(a) {
    pieces <- tex_escape(a$title)
    if (!is.null(a$department)) pieces <- paste0(pieces, ", ", tex_escape(a$department))
    paste0(pieces, ", ", format_range_my(a, break_range = FALSE), ".")
  }
  # Override the global label-less itemize: bullets for institutions, en-dash
  # for nested positions.
  out <- "\\begin{itemize}[label={\\textbullet}]"
  for (inst_key in inst_order) {
    group <- by_inst[[inst_key]]
    first <- group[[1]]
    inst_label <- tex_escape(inst_key)
    if (!is.null(first$location)) {
      inst_label <- paste0(inst_label, ", ", tex_escape(first$location))
    }
    if (length(group) == 1) {
      # Single role: inline
      a <- group[[1]]
      body <- inst_label
      body <- paste0(body, ", ", tex_escape(a$title))
      if (!is.null(a$department)) body <- paste0(body, ", ", tex_escape(a$department))
      body <- paste0(body, ", ", format_range_my(a, break_range = FALSE), ".")
      out <- c(out, paste0("\\item ", body))
    } else {
      # Multiple roles: nested itemize with en-dash markers
      out <- c(out, paste0("\\item ", inst_label))
      out <- c(out, "\\begin{itemize}[label={--}]")
      for (a in group) {
        out <- c(out, paste0("\\item ", render_role(a)))
      }
      out <- c(out, "\\end{itemize}")
    }
  }
  c(out, "\\end{itemize}")
}

# ----- Working papers / Work in progress -----
build_working_papers <- function() {
  items <- Filter(function(p) !identical(p$status, "Published"), papers)
  if (length(items) == 0) return(character(0))
  out <- "\\begin{enumerate}"
  for (p in items) {
    title <- if (!is.null(p$doi)) {
      paste0("\\href{", p$doi, "}{", tex_escape(p$title), "}")
    } else {
      tex_escape(p$title)
    }
    auths <- render_authors(p$authors)
    status <- status_label(p$status)
    if (!is.null(p$journal)) status <- paste0(status, ", ", tex_escape(p$journal))
    pills <- render_link_pills(p$links)
    out <- c(out, paste0(
      "\\item ", title, " \\\\ ",
      auths, " \\\\ \\textit{", status, "}", pills
    ))
  }
  c(out, "\\end{enumerate}")
}

# ----- Publications (Published, newest at top, but numbered oldest=1) -----
build_publications <- function() {
  pub <- Filter(function(p) {
    identical(p$status, "Published") &&
      (is.null(p$journal) || !grepl("^Chapter in", p$journal))
  }, papers)
  if (length(pub) == 0) return(character(0))
  # Display newest first, but assign numbers so the oldest paper is 1.
  pub <- pub[order(vapply(pub, function(p) -as.integer(p$year %||% 0L), integer(1)))]
  total <- length(pub)
  out <- character(0)
  for (i in seq_along(pub)) {
    p <- pub[[i]]
    num <- total - i + 1L
    title <- if (!is.null(p$doi)) {
      paste0("\\href{", p$doi, "}{``", tex_escape(p$title), "''}")
    } else {
      paste0("``", tex_escape(p$title), "''")
    }
    auths <- render_authors(p$authors)
    cite <- paste0(" \\textit{", tex_escape(p$journal %||% ""), "} (", as.character(p$year), ")")
    if (!is.null(p$volume))     cite <- paste0(cite, " Vol.~", as.character(p$volume))
    if (!is.null(p$issue))      cite <- paste0(cite, ", No.~", as.character(p$issue))
    if (!is.null(p$pages))      cite <- paste0(cite, ", pp.~", tex_escape(as.character(p$pages)))
    if (!is.null(p$article_no)) cite <- paste0(cite, ", ", tex_escape(as.character(p$article_no)))
    pills <- render_link_pills(p$links)
    body <- paste0(auths, ", ", title, ".", cite, ".", pills)
    # Manual number prefix with hanging indent so wrapped lines align after "N."
    out <- c(out, paste0(
      "\\noindent\\hangindent=2.2em\\hangafter=1",
      "\\makebox[2em][r]{", num, ".}\\hspace{0.2em}", body, "\\par"
    ))
  }
  out
}

# ----- Book Chapters -----
build_book_chapters <- function() {
  ch <- Filter(function(p) {
    identical(p$status, "Published") &&
      !is.null(p$journal) && grepl("^Chapter in", p$journal)
  }, papers)
  if (length(ch) == 0) return(character(0))
  ch <- ch[order(vapply(ch, function(p) -as.integer(p$year %||% 0L), integer(1)))]
  out <- "\\begin{enumerate}"
  for (p in ch) {
    title <- if (!is.null(p$doi)) {
      paste0("\\href{", p$doi, "}{``", tex_escape(p$title), "''}")
    } else {
      paste0("``", tex_escape(p$title), "''")
    }
    auths <- render_authors(p$authors)
    out <- c(out, paste0(
      "\\item ", auths, ", ", title, ". \\textit{", tex_escape(p$journal), "}, ",
      as.character(p$year), "."
    ))
  }
  c(out, "\\end{enumerate}")
}

# ----- Teaching (one row per course, terms+years aggregated) -----
# Collapse consecutive years to ranges within each term: e.g. "Fall 2014-2019"
# instead of "Fall 2014, Fall 2015, ..., Fall 2019".
collapse_years <- function(years) {
  years <- sort(unique(years))
  if (length(years) == 0) return("")
  groups <- list()
  current <- c(years[1])
  for (y in years[-1]) {
    if (y == tail(current, 1) + 1) current <- c(current, y)
    else { groups <- c(groups, list(current)); current <- y }
  }
  groups <- c(groups, list(current))
  parts <- vapply(groups, function(g) {
    if (length(g) == 1) as.character(g) else paste0(g[1], "--", tail(g, 1))
  }, character(1))
  paste(parts, collapse = ", ")
}

build_teaching <- function() {
  # Group offerings by course_number, preserving first-seen order
  courses <- list()
  course_order <- character(0)
  for (t in teaching) {
    key <- t$course_number
    if (is.null(courses[[key]])) {
      courses[[key]] <- list(
        course_number = t$course_number,
        course_title  = t$course_title,
        level         = t$level,
        offerings     = list()
      )
      course_order <- c(course_order, key)
    }
    courses[[key]]$offerings <- c(courses[[key]]$offerings, list(t))
  }
  rows <- character(0)
  for (key in course_order) {
    co <- courses[[key]]
    # Within each course: group years by term
    by_term <- list()
    for (o in co$offerings) {
      by_term[[o$term]] <- c(by_term[[o$term]] %||% integer(0), o$year)
    }
    term_strs <- vapply(names(by_term), function(tn) {
      paste0(tn, " ", collapse_years(by_term[[tn]]))
    }, character(1))
    offerings_text <- paste(term_strs, collapse = "; ")
    level_tag <- if (!is.null(co$level)) paste0(" \\textit{(", co$level, ")}") else ""
    rows <- c(rows, paste0(
      "\\noindent\\textbf{", tex_escape(co$course_number), "}, ",
      tex_escape(co$course_title), " --- ", offerings_text, level_tag, "\\par"
    ))
  }
  rows
}

# ----- Service (grouped by kind, year-range paragraph flow) -----
build_service <- function() {
  kinds <- list(
    department    = "Department",
    university    = "University",
    faculty_senate = "Faculty Senate",
    external      = "External",
    editorial     = "Editorial"
  )
  out <- character(0)
  for (k in names(kinds)) {
    items <- Filter(function(s) identical(s$kind, k), service)
    if (length(items) == 0) next
    out <- c(out, cv_subsection(kinds[[k]]))
    for (s in items) {
      line <- tex_escape(s$role)
      if (!is.null(s$journal))     line <- paste0(line, ", \\textit{", tex_escape(s$journal), "}")
      if (!is.null(s$group))       line <- paste0(line, ", ", tex_escape(s$group))
      if (!is.null(s$institution)) line <- paste0(line, ", ", tex_escape(s$institution))
      if (!is.null(s$note))        line <- paste0(line, " (", tex_escape(s$note), ")")
      out <- c(out, date_entry(format_range_y(s, break_range = FALSE), line))
    }
  }
  out
}

# ----- Honors & Awards (year-prefix paragraph flow) -----
build_awards <- function() {
  if (length(awards) == 0) return(character(0))
  out <- character(0)
  for (a in awards) {
    desc <- tex_escape(a$title)
    if (!is.null(a$granter))        desc <- paste0(desc, ", ", tex_escape(a$granter))
    if (!is.null(a$paper))          desc <- paste0(desc, " for ``", tex_escape(a$paper), "''")
    if (!is.null(a$collaborators))  desc <- paste0(desc, " (", tex_escape(a$collaborators), ")")
    if (!is.null(a$venue))          desc <- paste0(desc, ", ", tex_escape(a$venue))
    if (!is.null(a$note))           desc <- paste0(desc, " (", tex_escape(a$note), ")")
    out <- c(out, date_entry(as.character(a$year), desc))
  }
  out
}

# ----- Grants (year-range-prefix paragraph flow) -----
build_grants <- function() {
  if (length(grants) == 0) return(character(0))
  out <- character(0)
  for (g in grants) {
    pieces <- c(tex_escape(g$funder))
    if (!is.null(g$program))        pieces <- c(pieces, tex_escape(g$program))
    if (!is.null(g$project_number)) pieces <- c(pieces, paste0("project ", tex_escape(g$project_number)))
    head <- paste(pieces, collapse = ", ")
    desc <- paste0(head, ". ``", tex_escape(g$title), ".''")
    if (!is.null(g$role))           desc <- paste0(desc, " Role: ", tex_escape(g$role), ".")
    if (!is.null(g$collaborators))  desc <- paste0(desc, " ", tex_escape(g$collaborators), ".")
    amt <- format_amount(g)
    if (nchar(amt) > 0)             desc <- paste0(desc, " Award: ", amt, ".")
    out <- c(out, date_entry(format_range_y(g, break_range = FALSE), desc))
  }
  out
}

# ----- Conferences & Seminars (year heading, month-day on left) -----
# Since the year is the heading, each entry only needs month-day on the
# left, matching the date-left convention used by other sections.
format_talk_date_short <- function(date, date_end = NULL, approx = FALSE) {
  d <- as_date_safe(date)
  if (is.na(d)) return("")
  if (isTRUE(approx)) return(format(d, "%B"))
  if (is.null(date_end)) return(paste0(format(d, "%b "), day_of(d)))
  de <- as_date_safe(date_end)
  if (format(d, "%Y-%m") == format(de, "%Y-%m")) {
    paste0(format(d, "%b "), day_of(d), "--", day_of(de))
  } else {
    paste0(format(d, "%b "), day_of(d), "--", format(de, "%b "), day_of(de))
  }
}

build_talks <- function() {
  # All AOB-presented talks, research + non-research combined. Dates are
  # not rendered; year is the grouping heading and venue/location is the line.
  items <- Filter(function(t) is_aob(t$presenter), talks)
  if (length(items) == 0) return(character(0))
  years <- vapply(items, function(t) {
    d <- as_date_safe(t$date)
    if (is.na(d)) NA_integer_ else as.integer(format(d, "%Y"))
  }, integer(1))
  ord <- order(-years, vapply(items, function(t) -as.numeric(as_date_safe(t$date)), numeric(1)))
  items <- items[ord]
  years <- years[ord]

  out <- character(0)
  current_year <- NA
  for (i in seq_along(items)) {
    t <- items[[i]]
    y <- years[i]
    if (is.na(current_year) || y != current_year) {
      current_year <- y
      out <- c(out, "", paste0("\\textbf{", as.character(y), "}\\par"))
    }
    venue <- tex_escape(t$venue)
    loc <- if (!is.null(t$location)) paste0(", ", tex_escape(t$location)) else ""
    role_note <- if (!is.null(t$role)) paste0(" [", tex_escape(t$role), "]") else ""
    out <- c(out, paste0(
      "{\\leftskip=1em\\noindent ", venue, loc, role_note, "\\par}"
    ))
  }
  out
}

# ----- Students -----
build_students <- function() {
  # Render the year span: range if both start+end, single year if only end,
  # "YYYY-" if only start (ongoing postdoc), empty otherwise.
  year_span <- function(s) {
    if (!is.null(s$year_start) && !is.null(s$year_end)) {
      if (s$year_start == s$year_end) as.character(s$year_end)
      else paste0(s$year_start, "--", s$year_end)
    } else if (!is.null(s$year_end)) {
      as.character(s$year_end)
    } else if (!is.null(s$year_start)) {
      paste0(s$year_start, "--")
    } else {
      ""
    }
  }
  levels <- list(postdoc = "Postdocs", phd = "PhD Students", ms = "MS Students")
  # Legend goes at the top of the section
  out <- "{\\small ** indicates chair; * indicates co-chair.}"
  for (lv in names(levels)) {
    items <- Filter(function(s) identical(s$level, lv), students)
    if (length(items) == 0) next
    out <- c(out, cv_subsection(levels[[lv]]))
    out <- c(out, "\\begin{itemize}")
    for (s in items) {
      line <- tex_escape(s$name)
      if (!is.null(s$chair_role)) {
        marker <- switch(s$chair_role, chair = "**", co_chair = "*", "")
        if (nzchar(marker)) line <- paste0(line, "\\,", marker)
      }
      if (!is.null(s$field)) line <- paste0(line, " (", tex_escape(s$field), ")")
      span <- year_span(s)
      if (nchar(span) > 0) line <- paste0(line, ", ", span)
      if (!is.null(s$placement)) line <- paste0(line, " --- ", tex_escape(s$placement))
      if (!is.null(s$note))      line <- paste0(line, ". ", tex_escape(s$note))
      out <- c(out, paste0("\\item ", line))
    }
    out <- c(out, "\\end{itemize}")
  }
  out
}

# ----- Professional organizations (incl. refereeing) -----
build_prof_orgs <- function() {
  out <- character(0)
  # Memberships
  out <- c(out, cv_subsection("Memberships"))
  out <- c(out, "\\begin{itemize}")
  for (m in referee$professional_organizations) {
    line <- tex_escape(m$name)
    if (!is.null(m$year_start)) {
      yr <- if (isTRUE(m$current)) paste0(m$year_start, "--") else as.character(m$year_start)
      line <- paste0(line, ", ", yr)
    }
    if (!is.null(m$note)) line <- paste0(line, " (", tex_escape(m$note), ")")
    out <- c(out, paste0("\\item ", line))
  }
  out <- c(out, "\\end{itemize}")
  # Referee
  out <- c(out, cv_subsection("Referee activities"))
  out <- c(out, paste0("\\textit{",
                       paste(vapply(referee$journals, tex_escape, character(1)),
                             collapse = "; "),
                       "}"))
  # Invited editor
  if (!is.null(referee$invited_editor) && length(referee$invited_editor) > 0) {
    out <- c(out, cv_subsection("Invited editor"))
    out <- c(out, paste(vapply(referee$invited_editor, tex_escape, character(1)),
                        collapse = "; "))
  }
  # Panels
  if (!is.null(referee$panels) && length(referee$panels) > 0) {
    out <- c(out, cv_subsection("External reviews, grant and panel reviews"))
    out <- c(out, "\\begin{itemize}")
    for (p in referee$panels) {
      yrs <- if (!is.null(p$years)) paste(p$years, collapse = ", ") else as.character(p$year)
      out <- c(out, paste0("\\item ", tex_escape(p$funder),
                           ", ", tex_escape(p$program), ", ", yrs))
    }
    out <- c(out, "\\end{itemize}")
  }
  out
}

# ----- Languages -----
build_languages <- function() {
  parts <- vapply(profile$languages, function(l) {
    paste0(tex_escape(l$language), " (", tex_escape(l$level), ")")
  }, character(1))
  paste(parts, collapse = "; ")
}

# ============================================================================
#  Compose body
# ============================================================================

body <- c(
  build_header(),
  # ----- Identity / position -----
  cv_section("Appointments"),                         build_appointments(),
  cv_section("Education"),                            build_education(),
  # ----- Scholarly output -----
  cv_section("Work in progress"),                     build_working_papers(),
  cv_section("Publications"),                         build_publications(),
  cv_section("Book Chapters"),                        build_book_chapters(),
  cv_section("Honors and Awards"),                    build_awards(),
  cv_section("Grants"),                               build_grants(),
  cv_section("Conferences and Seminars"),             build_talks(),
  # ----- Teaching, advising, service (admin / institutional) -----
  cv_section("Teaching"),                             build_teaching(),
  cv_section("Graduate Students"),                    build_students(),
  cv_section("Service"),                              build_service(),
  cv_section("Professional Organizations"),           build_prof_orgs(),
  cv_section("Languages"),                            build_languages()
)

writeLines(body, body_tex)
cat("Wrote ", body_tex, " (", length(body), " lines)\n", sep = "")

# ============================================================================
#  Compile
# ============================================================================

old_wd <- getwd()
setwd(cv_dir)
on.exit(setwd(old_wd))

pdf_out <- tryCatch(
  tinytex::pdflatex("cv.tex", clean = TRUE),
  error = function(e) {
    cat("\nLaTeX compilation failed:\n", conditionMessage(e), "\n", sep = "")
    cat("Check cv/cv.log for details.\n")
    quit(status = 1)
  }
)

final_pdf <- file.path("output", "ortiz-bobea-cv.pdf")
file.copy("cv.pdf", final_pdf, overwrite = TRUE)

# Public location: the website's /assets/cv.pdf link picks this up.
assets_pdf <- file.path(repo_root, "assets", "cv.pdf")
file.copy("cv.pdf", assets_pdf, overwrite = TRUE)

# Yearly snapshot: written only on first build of each calendar year, so
# old CVs stay browsable at stable URLs (e.g. /assets/cv-archive/cv-2026.pdf).
archive_dir <- file.path(repo_root, "assets", "cv-archive")
dir.create(archive_dir, showWarnings = FALSE, recursive = TRUE)
year_snap <- file.path(archive_dir, paste0("cv-", format(Sys.Date(), "%Y"), ".pdf"))
if (!file.exists(year_snap)) {
  file.copy("cv.pdf", year_snap)
  cat("Wrote year snapshot: ", year_snap, "\n", sep = "")
}

file.remove("cv.pdf")
cat("Built ", file.path(cv_dir, final_pdf), "\n", sep = "")
cat("Updated ", assets_pdf, "\n", sep = "")
