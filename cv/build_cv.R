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

render_authors <- function(authors) {
  if (length(authors) == 0) return("")
  parts <- vapply(authors, render_author, character(1))
  n <- length(parts)
  if (n == 1) return(parts)
  if (n == 2) return(paste(parts, collapse = " and "))
  paste(paste(parts[-n], collapse = ", "), parts[n], sep = ", and ")
}

# Month/year range "MM/YYYY--MM/YYYY" or "MM/YYYY--present"
format_range_my <- function(item) {
  start <- if (!is.null(item$month_start)) {
    sprintf("%d/%d", item$month_start, item$year_start)
  } else {
    as.character(item$year_start)
  }
  if (isTRUE(item$current)) return(paste0(start, "--present"))
  if (!is.null(item$year_end)) {
    end <- if (!is.null(item$month_end)) {
      sprintf("%d/%d", item$month_end, item$year_end)
    } else {
      as.character(item$year_end)
    }
    if (start == end) start else paste0(start, "--", end)
  } else {
    start
  }
}

format_range_y <- function(item) {
  if (isTRUE(item$current)) return(paste0(item$year_start, "--present"))
  if (!is.null(item$year_end) && item$year_end != item$year_start) {
    paste0(item$year_start, "--", item$year_end)
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

# ============================================================================
#  Section builders
# ============================================================================

# ----- Header -----
build_header <- function() {
  addr <- paste(vapply(profile$address, tex_escape, character(1)), collapse = "\\\\\n")
  cit  <- paste(vapply(profile$citizenship, tex_escape, character(1)), collapse = ", ")
  website_display <- sub("^https?://", "", profile$website)
  c(
    "{\\centering\\Large\\textbf{",
    tex_escape(profile$name),
    "}\\par}",
    "\\vspace{0.4em}",
    "\\noindent",
    "\\begin{minipage}[t]{0.65\\textwidth}\\raggedright",
    addr,
    "\\end{minipage}\\hfill",
    "\\begin{minipage}[t]{0.33\\textwidth}\\raggedleft",
    paste0("\\href{mailto:", profile$email, "}{", tex_escape(profile$email), "}\\\\"),
    paste0(tex_escape(profile$phone), " (office)\\\\"),
    paste0("\\href{", profile$website, "}{", tex_escape(website_display), "}\\\\"),
    paste0("Citizenship: ", cit),
    "\\end{minipage}",
    "\\par"
  )
}

# ----- Education -----
build_education <- function() {
  # tabularx with X (wrap-friendly content) + r (year). Guarantees year stays
  # right-aligned and a long content row wraps without crashing into the year.
  # institution_now (if any) appears small on a second row.
  rows <- character(0)
  for (e in education) {
    main <- paste0("\\textbf{", tex_escape(e$degree), "}")
    if (!is.null(e$field))      main <- paste0(main, ", ", tex_escape(e$field))
    main <- paste0(main, ", ", tex_escape(e$institution))
    if (!is.null(e$department)) main <- paste0(main, ", ", tex_escape(e$department))
    rows <- c(rows, paste0(main, " & ", as.character(e$year_end), " \\\\"))
    if (!is.null(e$institution_now)) {
      rows <- c(rows, paste0(
        "\\multicolumn{2}{@{}l@{}}{\\hspace{1em}{\\small (now ",
        tex_escape(e$institution_now), ")}} \\\\"
      ))
    }
  }
  c(
    "\\begin{tabularx}{\\textwidth}{@{}>{\\raggedright\\arraybackslash}Xr@{}}",
    rows,
    "\\end{tabularx}"
  )
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

# ----- Appointments (current or past) -----
build_appointments <- function(current) {
  items <- Filter(function(x) isTRUE(x$current) == current, employment)
  vapply(items, function(a) {
    range <- format_range_my(a)
    body <- tex_escape(a$title)
    if (!is.null(a$department))  body <- paste0(body, ", ", tex_escape(a$department))
    if (!is.null(a$institution)) body <- paste0(body, ", ", tex_escape(a$institution))
    if (!is.null(a$location))    body <- paste0(body, ", ", tex_escape(a$location))
    paste0(
      "\\noindent\\makebox[1.5in][l]{", range, "} ",
      "\\begin{minipage}[t]{5in}", body, "\\end{minipage}\\par"
    )
  }, character(1))
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
    out <- c(out, paste0(
      "\\item ", title, " \\\\ ",
      auths, " \\\\ \\textit{", status, "}"
    ))
  }
  c(out, "\\end{enumerate}")
}

# ----- Publications (Published, grouped by year, newest first) -----
build_publications <- function() {
  pub <- Filter(function(p) {
    identical(p$status, "Published") &&
      (is.null(p$journal) || !grepl("^Chapter in", p$journal))
  }, papers)
  if (length(pub) == 0) return(character(0))
  pub <- pub[order(vapply(pub, function(p) -as.integer(p$year %||% 0L), integer(1)))]
  out <- "\\begin{itemize}"
  for (p in pub) {
    title <- if (!is.null(p$doi)) {
      paste0("\\href{", p$doi, "}{``", tex_escape(p$title), "''}")
    } else {
      paste0("``", tex_escape(p$title), "''")
    }
    auths <- render_authors(p$authors)
    cite <- paste0(" \\textit{", tex_escape(p$journal %||% ""), "} (", as.character(p$year), ")")
    if (!is.null(p$volume)) cite <- paste0(cite, " Vol.~", as.character(p$volume))
    if (!is.null(p$issue))  cite <- paste0(cite, ", No.~", as.character(p$issue))
    if (!is.null(p$pages))  cite <- paste0(cite, ", pp.~", tex_escape(as.character(p$pages)))
    if (!is.null(p$article_no)) cite <- paste0(cite, ", ", tex_escape(as.character(p$article_no)))
    out <- c(out, paste0("\\item ", auths, ", ", title, ".", cite, "."))
  }
  c(out, "\\end{itemize}")
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

# ----- Teaching -----
build_teaching <- function() {
  items <- teaching
  vapply(items, function(t) {
    paste0(
      tex_escape(t$course_number), ", ", tex_escape(t$course_title), ", ",
      tex_escape(t$term), " ", as.character(t$year),
      " (", tex_escape(as.character(t$enrollment)), " students)\\\\"
    )
  }, character(1))
}

# ----- Service (grouped by kind) -----
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
    out <- c(out, "\\begin{itemize}")
    for (s in items) {
      line <- tex_escape(s$role)
      if (!is.null(s$journal)) line <- paste0(line, ", \\textit{", tex_escape(s$journal), "}")
      if (!is.null(s$group)) line <- paste0(line, ", ", tex_escape(s$group))
      if (!is.null(s$institution)) line <- paste0(line, ", ", tex_escape(s$institution))
      range <- format_range_y(s)
      line <- paste0(line, ", ", range)
      if (!is.null(s$note)) line <- paste0(line, " (", tex_escape(s$note), ")")
      out <- c(out, paste0("\\item ", line))
    }
    out <- c(out, "\\end{itemize}")
  }
  out
}

# ----- Honors & Awards -----
build_awards <- function() {
  if (length(awards) == 0) return(character(0))
  out <- "\\begin{itemize}"
  for (a in awards) {
    line <- tex_escape(a$title)
    if (!is.null(a$granter)) line <- paste0(line, ", ", tex_escape(a$granter))
    if (!is.null(a$paper))   line <- paste0(line, " for ``", tex_escape(a$paper), "''")
    if (!is.null(a$collaborators)) line <- paste0(line, " (", tex_escape(a$collaborators), ")")
    if (!is.null(a$venue))   line <- paste0(line, ", ", tex_escape(a$venue))
    line <- paste0(line, ", ", as.character(a$year))
    if (!is.null(a$note))    line <- paste0(line, " (", tex_escape(a$note), ")")
    out <- c(out, paste0("\\item ", line))
  }
  c(out, "\\end{itemize}")
}

# ----- Grants -----
build_grants <- function() {
  if (length(grants) == 0) return(character(0))
  out <- "\\begin{enumerate}"
  for (g in grants) {
    pieces <- c(tex_escape(g$funder))
    if (!is.null(g$program))        pieces <- c(pieces, tex_escape(g$program))
    if (!is.null(g$project_number)) pieces <- c(pieces, paste0("project ", tex_escape(g$project_number)))
    head <- paste(pieces, collapse = ", ")
    line <- paste0(head, ". ``", tex_escape(g$title), ".''")
    if (!is.null(g$role)) line <- paste0(line, " Role: ", tex_escape(g$role), ".")
    if (!is.null(g$collaborators)) line <- paste0(line, " ", tex_escape(g$collaborators), ".")
    amt <- format_amount(g)
    if (nchar(amt) > 0) line <- paste0(line, " Award: ", amt, ".")
    line <- paste0(line, " Period: ", format_range_y(g), ".")
    out <- c(out, paste0("\\item ", line))
  }
  c(out, "\\end{enumerate}")
}

# ----- Conferences & Seminars (grouped by year, newest year first) -----
build_talks <- function(non_research = FALSE) {
  items <- Filter(function(t) {
    is_aob(t$presenter) && (isTRUE(t$non_research) == non_research)
  }, talks)
  if (length(items) == 0) return(character(0))
  # Extract year from date
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
      out <- c(out, "", paste0("\\textbf{", as.character(y), "}\\\\"))
    }
    venue <- tex_escape(t$venue)
    loc <- if (!is.null(t$location)) paste0(", ", tex_escape(t$location)) else ""
    d <- format_talk_date(t$date, t$date_end, t$date_approx)
    role_note <- if (!is.null(t$role)) paste0(" [", tex_escape(t$role), "]") else ""
    out <- c(out, paste0(
      "\\hspace{1em}", venue, loc, ", ", d, role_note, "\\\\"
    ))
  }
  out
}

# ----- Students -----
build_students <- function() {
  levels <- list(postdoc = "Postdocs", phd = "PhD Students", ms = "MS Students")
  out <- character(0)
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
      if (!is.null(s$year_end)) line <- paste0(line, ", ", as.character(s$year_end))
      if (!is.null(s$placement)) line <- paste0(line, " --- ", tex_escape(s$placement))
      if (!is.null(s$note))      line <- paste0(line, ". ", tex_escape(s$note))
      out <- c(out, paste0("\\item ", line))
    }
    out <- c(out, "\\end{itemize}")
  }
  c(out, "", "{\\small ** indicates chair; * indicates co-chair.}")
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
  cv_section("Education"),                            build_education(),
  cv_section("Topics and Fields of Interest"),        build_topics(),
  cv_section("Current Appointments"),                 build_appointments(current = TRUE),
  cv_section("Past Appointments"),                    build_appointments(current = FALSE),
  cv_section("Working Papers and Work in Progress"),  build_working_papers(),
  cv_section("Publications"),                         build_publications(),
  cv_section("Book Chapters"),                        build_book_chapters(),
  cv_section("Teaching"),                             build_teaching(),
  cv_section("Service"),                              build_service(),
  cv_section("Honors and Awards"),                    build_awards(),
  cv_section("Grants"),                               build_grants(),
  cv_section("Conferences and Seminars"),             build_talks(non_research = FALSE),
  cv_section("Select Non-Research Talks"),            build_talks(non_research = TRUE),
  cv_section("Professional Organizations"),           build_prof_orgs(),
  cv_section("Graduate Students"),                    build_students(),
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
