#' Output a gt table object as LateX
#'
#' Take a \code{gt_tbl} table object and emit LateX.
#' @param data a table object that is created using the \code{gt()} function.
#' @import rlang
#' @importFrom dplyr mutate group_by summarize ungroup rename arrange
#' @importFrom stats setNames
#' @examples
#' \dontrun{
#' # Create a `gt` table using the `sleep`
#' # dataset and output as Latex
#' gt(data = sleep) %>%
#'   as_latex()
#' }
#' @family table export functions
#' @export
as_latex <- function(data) {

  # Build all table data objects through a common pipeline
  built_data <- data %>% build_data(context = "latex")

  # Use Latex-specific builders to generate the Latex table code
  with(built_data, {

    # Add footnote glyphs to boxhead elements
    boxh_df <-
      set_footnote_glyphs_boxhead(footnotes_resolved, boxh_df, output = "latex")

    # Add footnote glyphs to the `data` rows
    output_df <-
      apply_footnotes_to_output(output_df, footnotes_resolved, output = "latex")

    # Add footnote glyphs to stub group title elements
    groups_rows_df <-
      set_footnote_glyphs_stub_groups(
        footnotes_resolved, groups_rows_df, output = "latex")

    # Add footnote glyphs to the `summary` rows
    list_of_summaries <-
      apply_footnotes_to_summary(list_of_summaries, footnotes_resolved)

    # Extraction of body content as a vector ----------------------------------
    body_content <- as.vector(t(output_df))

    # Composition of Latex ----------------------------------------------------

    # Split `body_content` by slices of rows
    row_splits <- split(body_content, ceiling(seq_along(body_content)/n_cols))

    # Create a Latex fragment for the start of the table
    table_start <- create_table_start_l()

    # Create the heading component of the table
    heading_component <-
      create_heading_component(
        heading, footnotes_resolved, n_cols = n_cols, output = "latex")

    # Create a Latex fragment for the beginning tabular statement
    tabular_start <-
      create_tabular_start_l(col_alignment)

    # Create the boxhead component of the table
    boxhead_component <-
      create_boxhead_component_l(
        boxh_df, output_df, stub_available, spanners_present,
        stubhead_caption)

    # Create the body component of the table
    body_component <-
      create_body_component_l(
        row_splits, groups_rows_df, col_alignment, stub_available,
        summaries_present, list_of_summaries, n_rows, n_cols)

    # Create a Latex fragment for the ending tabular statement
    tabular_end <- create_tabular_end_l()

    # Create the footnote component of the table
    footnote_component <-
      create_footnote_component_l(
        footnotes_resolved, opts_df)

    # Create the source note component of the table
    source_note_component <-
      create_source_note_component_l(source_note)

    # Create the closing Latex element of a table
    table_end <- create_table_end_l()

    # Compose the Latex table
    latex_table <-
      paste0(
        table_start,
        heading_component,
        tabular_start,
        boxhead_component,
        body_component,
        tabular_end,
        footnote_component,
        source_note_component,
        table_end,
        collapse = "") %>%
      knitr::asis_output() %>%
      knitr::knit_print()

    latex_table
  })
}