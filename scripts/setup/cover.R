# nolint start
# cover.R
# ----------------------------------------------------------------------
# Functions to build cover pages from params.yml data.
# Each function receives `params` (parsed from params.yml$params).
# ----------------------------------------------------------------------

# -- Internal helper ---------------------------------------------------
.escapeHtml <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  x <- gsub('"', "&quot;", x, fixed = TRUE)
  x
}

# -- Citation builder ---------------------------------------------------
# {consultant}. {year}. {title}: {site}. {location} prepared for {client}, {city}.
.buildCitation <- function(params) {
  paste0(
    params$consultant$name, ". ", params$year, ". ",
    params$title, ": ", params$site, ". ",
    params$location, " prepared for ",
    params$client$name, ", ", params$client$city, "."
  )
}

# -- Report cover (HTML) -----------------------------------------------
buildCoverReport <- function(params) {
  h <- .escapeHtml

  SiteLocation <- paste0(params$site, ". ", params$location)
  ProjectLines <- paste0(
    '          <div class="srk-cover__project-line">', h(params$title), "</div>",
    collapse = "\n"
  )

  # Client block
  ClientAddr <- paste0("            <p>", h(params$client$address), "</p>", collapse = "\n")
  ClientWebDisplay <- sub("^https?://", "", params$client$web)
  ClientBlock <- paste0(
    '        <section class="srk-cover__block">\n',
    '          <h2 class="srk-cover__block-title">Prepared for:</h2>\n',
    '          <div class="srk-cover__block-body">\n',
    '            <p>', h(params$client$name), '</p>\n',
    ClientAddr, '\n',
    '            <p><a href="', h(params$client$web), '">', h(ClientWebDisplay), '</a></p>\n',
    '          </div>\n',
    '        </section>'
  )

  # Consultant block
  ConsultAddr <- paste0("            <p>", h(params$consultant$address), "</p>", collapse = "\n")
  ConsultantBlock <- paste0(
    '        <section class="srk-cover__block">\n',
    '          <h2 class="srk-cover__block-title">Prepared by:</h2>\n',
    '          <div class="srk-cover__block-body">\n',
    '            <p>', h(params$consultant$name), '</p>\n',
    ConsultAddr, '\n',
    '            <p><a href="', h(params$consultant$web), '">', h(params$consultant$web), '</a></p>\n',
    '          </div>\n',
    '        </section>'
  )

  # Roles (report uses Lead Author + Reviewer)
  ReportLabels <- c("Lead Author", "Reviewer")
  RoleRows <- vapply(params$roles, function(Role) {
    if (!Role$label %in% ReportLabels) return("")
    paste0(
      '        <div class="srk-cover__role-row">\n',
      '          <div class="srk-cover__role-label">', h(Role$label), ':</div>\n',
      '          <div class="srk-cover__role-value">', h(Role$name), ', ', h(Role$title), '</div>\n',
      '          <div class="srk-cover__role-label">Initials:</div>\n',
      '          <div class="srk-cover__role-value">', h(Role$initials), '</div>\n',
      '        </div>'
    )
  }, character(1))
  RoleRows <- RoleRows[nzchar(RoleRows)]
  RolesHtml <- paste(RoleRows, collapse = "\n")

  # Citation
  CitationText <- .buildCitation(params)
  CitationHtml <- paste0(
    '        <div class="srk-cover__meta-item srk-cover__meta-item--citation">\n',
    '          <div class="srk-cover__meta-label">How to cite:</div>\n',
    '          <div class="srk-cover__meta-value">\n',
    '            ', CitationText, '\n',
    '          </div>\n',
    '        </div>'
  )

  # Assemble
  Html <- paste0(
    '<section class="srk-cover">\n',
    '  <div class="srk-cover__layout">\n',
    '    <div class="srk-cover__content">\n',
    '      <div class="srk-cover__title-group">\n',
    '        <div class="srk-cover__kicker">', h(SiteLocation), '</div>\n',
    '        <div class="srk-cover__project">\n',
    ProjectLines, '\n',
    '        </div>\n',
    '      </div>\n',
    '      <div class="srk-cover__blocks">\n',
    ClientBlock, '\n',
    ConsultantBlock, '\n',
    '      </div>\n',
    '      <div class="srk-cover__roles">\n',
    RolesHtml, '\n',
    '      </div>\n',
    '      <div class="srk-cover__meta">\n',
    CitationHtml, '\n',
    '      </div>\n',
    '    </div>\n',
    '  </div>\n',
    '</section>'
  )

  Html
}

# -- PPT cover (Markdown) ----------------------------------------------
buildCoverPpt <- function(params, title = params$title) {
  Title <- title
  Subtitle <- paste0(params$site, ". ", params$location)

  RoleLines <- vapply(params$roles, function(Role) {
    paste0(
      Role$label, ": ", Role$name, ". ", Role$title,
      ' <a href="mailto:', Role$email, '"><i class="fa fa-envelope"></i></a>'
    )
  }, character(1))

  Md <- paste0(
    '::: {.coverSlide}\n',
    '\n',
    '<div class="ppt-cover">\n',
    '<div class="ppt-cover__title-group">\n',
    '<div class="ppt-cover__title">', Title, '</div>\n',
    '<div class="ppt-cover__title">', params$site, '</div>\n',
    '<div class="ppt-cover__subtitle">', params$location, '</div>\n',
    '<div class="ppt-cover__subtitle">', params$client$name, '</div>\n',
    '</div>\n',
    '<p class="cover-authors" markdown="1">\n',
    'Project ID: ', params$project_id, '<br>\n',
    paste0(RoleLines, '<br>', collapse = "\n"), '\n',
    '</p>\n',
    '</div>\n',
    '\n',
    ':::'
  )

  Md
}

# nolint end
