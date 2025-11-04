#import "@preview/scienceicons:0.1.0": orcid-icon, email-icon, open-access-icon, github-icon, cc-icon, cc-zero-icon, cc-by-icon, cc-nc-icon, cc-nd-icon, cc-sa-icon, ror-icon
#import "./validate-frontmatter.typ": load, show-citation

/// Create a ORCID link with an ORCID logo
///
/// ```example
/// #pubmatter.orcid-link(orcid: "0000-0002-7859-8394")
/// ```
///
/// - orcid (str): Use an ORCID identifier with no URL, e.g. `0000-0000-0000-0000`
/// -> content
#let orcid-link(
  orcid: none,
  orcid-color: rgb("#AECD54"),
) = {
  if (orcid == none) { return [#orcid-icon(color: orcid-color) <pm-orcid>]}
  if (orcid.starts-with("https://")) { return [#link(orcid, orcid-icon(color: orcid-color)) <pm-orcid>] }
  return [#link("https://orcid.org/" + orcid, orcid-icon(color: orcid-color)) <pm-orcid>]
}

/// Create a DOI link
///
/// ```example
/// #pubmatter.doi-link(doi: "10.1190/tle35080703.1")
/// ```
///
/// - doi (str): Only include the DOI identifier, not the URL
/// -> content
#let doi-link(doi: none) = {
  if (doi == none) { return none }
  // Proper practices are to show the whole DOI link in text
  if (doi.starts-with("https://")) { return [#link(doi, doi) <pm-doi>]};
  return [#link("https://doi.org/" + doi, "https://doi.org/" + doi) <pm-doi>]
}

/// Create a ROR link
///
/// ```example
/// #pubmatter.ror-link(ror: "02mz0e468")
/// ```
///
/// - ror (str): Only include the ROR identifier, not the URL
/// -> content
#let ror-link(ror: none,
    ror-color: rgb("#2c2c2c"),
) = {
  if (ror == none) { return none }
  if (ror.starts-with("https://")) { return link(ror, ror-icon(color: ror-color)) };
  return link("https://ror.org/" + ror, ror-icon(color: ror-color))
}

/// Create a mailto link with an email icon
///
/// ```example
/// #pubmatter.email-link(email: "rowan@curvenote.com")
/// ```
///
/// - email (str): Email as a string
/// -> content
#let email-link(email: none,
  email-color: gray) = {
  if (email == none) { return none }
  return link("mailto:" + email, email-icon(color: email-color))
}

/// Create a link to Wikipedia with an OpenAccess icon.
///
/// ```example
/// #pubmatter.open-access-link()
/// ```
///
/// -> content
#let open-access-link(oa-color: rgb("#E78935") = {
  return link("https://en.wikipedia.org/wiki/Open_access", open-access-icon(color: oa-color))
}


/// Create a link to a GitHub profile with the GitHub icon.
///
/// ```example
/// #pubmatter.github-link(github: "rowanc1")
/// ```
///
/// - github (str): GitHub username (no `@`)
/// -> content
#let github-link(github: none) = {
  if (github.starts-with("https://")) { return link(github, github-icon()) }
  return link("https://github.com/" + github, github-icon())
}


/// Create a spaced content array separated with a `spacer`.
///
/// The default spacer is `  |  `, and undefined elements are removed.
///
/// ```example
/// #pubmatter.show-spaced-content(("Hello", "There"))
/// ```
///
/// - spacer (content): How to join the content
/// - content (array): The various things to going together
/// -> content
#let show-spaced-content(spacer: text(fill: gray)[#h(8pt) | #h(8pt)], content) = {
  content.filter(h => h != none and h != "").join(spacer)
}


/// Show license badge
///
/// Works for creative common license and other license.
///
/// ```example
/// #pubmatter.show-license-badge(pubmatter.load((license: "CC0")))
/// ```
///
/// ```example
/// #pubmatter.show-license-badge(pubmatter.load((license: "CC-BY-4.0")))
/// ```
///
/// ```example
/// #pubmatter.show-license-badge(pubmatter.load((license: "CC-BY-NC-4.0")))
/// ```
///
/// ```example
/// #pubmatter.show-license-badge(pubmatter.load((license: "CC-BY-NC-ND-4.0")))
/// ```
///
/// - fm (fm): The frontmatter object
/// -> content
#let show-license-badge(license-color: black, fm) = {
  let license = if ("license" in fm) { fm.license }
  if (license == none) { return none }
  if (license.id == "CC0-1.0") {
    return link(license.url, [#cc-icon(color: license-color)#cc-zero-icon(color: license-color)])
  }
  if (license.id == "CC-BY-4.0") {
    return link(license.url, [#cc-icon(color: license-color)#cc-by-icon(color: license-color)])
  }
  if (license.id == "CC-BY-NC-4.0") {
    return link(license.url, [#cc-icon(color: license-color)#cc-by-icon(color: license-color)#cc-nc-icon(color: license-color)])
  }
  if (license.id == "CC-BY-NC-SA-4.0") {
    return link(license.url, [#cc-icon(color: license-color)#cc-by-icon(color: license-color)#cc-nc-icon(color: license-color)])
  }
  if (license.id == "CC-BY-ND-4.0") {
    return link(license.url, [#cc-icon(color: license-color)#cc-by-icon(color: license-color)#cc-nd-icon(color: license-color)])
  }
  if (license.id == "CC-BY-NC-ND-4.0") {
    return link(license.url, [#cc-icon(color: license-color)#cc-by-icon(color: license-color)#cc-nc-icon(color: license-color)#cc-nd-icon(color: license-color)])
  }
}

/// Show copyright
///
/// Function chose a short citation with the copyright year followed by the license text.
/// If the license is a Creative Commons License, additional explainer text is shown.
///
/// ```example
/// #pubmatter.show-copyright(fm)
/// ```
///
/// - fm (fm): The frontmatter object
/// -> content
#let show-copyright(fm) = {
  let year = if (fm.date != none) { fm.date.display("[year]") }
  let citation = show-citation(show-year: false, fm)
  let license = if ("license" in fm) { fm.license }
  if (license == none) {
    return [Copyright © #{ year }
      #citation#{if (fm.at("open-access", default: none) == true){[. This article is open-access.]}} <pm-copyright>]
  }
  return [Copyright © #{ year }
    #citation.
    This #{if (fm.at("open-access", default: none) == true){[is an open-access article]} else {[article is]}} distributed under the terms of the
    #link(license.url, license.name) license#{
      if (license.id == "CC-BY-4.0") {
        [, which enables reusers to distribute, remix, adapt, and build upon the material in any medium or format, so long as attribution is given to the creator]
      } else if (license.id == "CC-BY-NC-4.0") {
        [, which enables reusers to distribute, remix, adapt, and build upon the material in any medium or format for _noncommercial purposes only_, and only so long as attribution is given to the creator]
      } else if (license.id == "CC-BY-NC-SA-4.0") {
        [, which enables reusers to distribute, remix, adapt, and build upon the material in any medium or format for noncommercial purposes only, and only so long as attribution is given to the creator. If you remix, adapt, or build upon the material, you must license the modified material under identical terms]
      } else if (license.id == "CC-BY-ND-4.0") {
        [, which enables reusers to copy and distribute the material in any medium or format in _unadapted form only_, and only so long as attribution is given to the creator]
      } else if (license.id == "CC-BY-NC-ND-4.0") {
        [, which enables reusers to copy and distribute the material in any medium or format in _unadapted form only_, for _noncommercial purposes only_, and only so long as attribution is given to the creator]
      }
    }. <pm-copyright>]
}

/// Get corresponding author
///
/// Returns the first author marked as corresponding author, or the first author with an email.
///
/// ```example
/// #let author = pubmatter.get-corresponding-author(authors)
/// ```
///
/// - authors (fm, array): The frontmatter object or authors directly
/// -> dictionary
#let get-corresponding-author(authors) = {
  // Allow to pass frontmatter as well
  let authors = if (type(authors) == dictionary and "authors" in authors) {authors.authors} else { authors }
  if authors.len() == 0 { return none }

  // First, look for an author with corresponding: true
  for author in authors {
    if ("corresponding" in author and author.corresponding == true) {
      return author
    }
  }

  // If none found, look for first author with email that doesn't have corresponding: false
  for author in authors {
    if ("email" in author and ("corresponding" not in author or author.corresponding != false)) {
      return author
    }
  }

  return none
}

/// Show authors
///
/// ```example
/// #pubmatter.show-authors(authors)
/// ```
///
/// - show-affiliations (boolean): Show affiliations text
/// - show-orcid (boolean): Show orcid logo
/// - show-email (boolean): Show email logo
/// - show-github (boolean): Show github logo
/// - show-equal-contributor (boolean): Show equal contributor asterisk
/// - authors (fm, array): The frontmatter object or authors directly
/// -> content
#let show-authors(
  show-affiliations: true,
  show-orcid: true,
  show-email: true,
  show-github: true,
  show-equal-contributor: true,
  authors,
) = {
  // Allow to pass frontmatter as well
  let authors = if (type(authors) == dictionary and "authors" in authors) {authors.authors} else { authors }
  if authors.len() == 0 { return none }
      authors.map(author => {
        text([#author.name <pm-author-name>])
        if (show-affiliations and "affiliations" in author) {
          text(size: 2.5pt, [~]) // Ensure this is not a linebreak
          if (type(author.affiliations) == str) {
            super(author.affiliations)
          } else if (type(author.affiliations) == array) {
            super(author.affiliations.map((affiliation) => str(affiliation.index)).join(","))
          }
          if (show-equal-contributor and "equal-contributor" in author and author.equal-contributor) {
            super("†")
          }
        }
        if (show-orcid and "orcid" in author) {
          orcid-link(orcid: author.orcid)
        }
        if (show-github and "github" in author) {
          github-link(github: author.github)
        }
        if (show-email and "email" in author) {
          email-link(email: author.email)
        }
      }).join(", ", last: ", and ")
}


/// Show affiliations
///
/// ```example
/// #pubmatter.show-affiliations(affiliations)
/// ```
///
/// - size (length): Size of the affiliations text
/// - fill (color): Color of of the affiliations text
/// - show-ror (boolean): Show ror logo
/// - show-equal-contributor (boolean): Show equal contributor note
/// - separator (str): Separator between affiliations
/// - affiliations (fm, array): The frontmatter object or affiliations directly
/// -> content
#let show-affiliations(
  show-ror: true,
  show-equal-contributor: true,
  separator: ", ",
  affiliations
  ) = {
  // Allow to pass frontmatter as well
  let fm = affiliations
  let affiliations = if (type(affiliations) == dictionary and "affiliations" in affiliations) {affiliations.affiliations} else { affiliations }
  if affiliations.len() == 0 { return none }

  // Check if any author has equal-contributor
  let has-equal-contributor = false
  if (show-equal-contributor and type(fm) == dictionary and "authors" in fm) {
    has-equal-contributor = fm.authors.any(author => "equal-contributor" in author and author.equal-contributor)
  }

  affiliations.map(affiliation => {
    super(str(affiliation.index))
    text(size: 2.5pt, [~]) // Ensure this is not a linebreak
    if ("name" in affiliation) {
      [#affiliation.name <pm-affiliation>]
    } else if ("institution" in affiliation) {
      affiliation.institution
    }
    if ("ror" in affiliation) {
      text(size: 2.5pt, [~]) // Ensure this is not a linebreak
      ror-link(ror: affiliation.ror)
      }
  }).join(separator)

  if (has-equal-contributor) {
    "; "
    super("†")
    text(size: 2.5pt, [~]) // Ensure this is not a linebreak
    [Contributed Equally]
  }
}


/// Show author block, including author, icon links (e.g. ORCID, email, etc.) and affiliations
///
/// ```example
/// #pubmatter.show-author-block(fm)
/// ```
///
/// - fm (fm): The frontmatter object
/// -> content
#let show-author-block(fm) = {
  show-authors(fm)
  show-affiliations(fm)
}

/// Show title and subtitle
///
/// ```example
/// #pubmatter.show-title(fm)
/// ```
///
/// - fm (fm): The frontmatter object
/// -> content
#let show-title(fm) = {
    let title = if (type(fm) == dictionary and "title" in fm) {fm.title} else if (type(fm) == str or type(fm) == content) { fm } else { none }
    let subtitle = if (type(fm) == dictionary and "subtitle" in fm) {fm.subtitle} else { none }
    if (title != none) {
      text([#title <pm-title>])
    }
    if (subtitle != none) {
      parbreak()
      text([#subtitle <pm-subtitle>])
    }
}

/// Show title block - title, authors and affiliations
///
/// ```example
/// #pubmatter.show-title-block(fm)
/// ```
///
/// - fm (fm): The frontmatter object
/// -> content
#let show-title-block(fm) = {
  show-title(fm)
  show-author-block(fm)
}


/// Show all abstracts (e.g. abstract, plain language summary)
///
/// ```example
/// #pubmatter.show-abstracts(fm)
/// ```
///
/// - fm (fm): The frontmatter object
/// -> content
#let show-abstracts(fm) = {
  let abstracts
  if (type(fm) == content) {
    abstracts = ((title: "Abstract", content: fm),)
  } else if (type(fm) == dictionary and "abstracts" in fm) {
    abstracts = fm.abstracts
  } else {
    return
  }
    abstracts.map(abs => {
      text(abs.title)
      parbreak()
      abs.content)
    }).join(parbreak())
}

/// Show keywords
///
/// ```example
/// #pubmatter.show-keywords(fm)
/// ```
///
/// - fm (fm): The frontmatter object
/// -> content
#let show-keywords(fm) = {
  let keywords
  if (type(fm) == dictionary and "keywords" in fm) {
    keywords = fm.keywords
  } else {
    return
  }
  if (keywords.len() > 0) {
    keywords.join(", ")
  }
}

/// Show abstract-block including all abstracts and keywords
///
/// ```example
/// #pubmatter.show-abstract-block(fm)
/// ```
///
/// - fm (fm): The frontmatter object
/// -> content
#let show-abstract-block(fm) = {
  show-abstracts(fm)
  show-keywords(fm)
}
