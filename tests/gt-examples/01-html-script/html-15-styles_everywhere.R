library(gt)

# Create a table based on `mtcars`, add all of the different types of
# table parts, and add styles in every type of part
many_styles_tbl <-
  gt(mtcars, rownames_to_stub = TRUE) %>%
  cols_move_to_start(columns = c("gear", "carb")) %>%
  tab_stubhead_label(label = "cars") %>%
  cols_hide(columns = "mpg") %>%
  cols_hide(columns = "vs") %>%
  tab_row_group(
    group = "Mercs",
    rows = contains("Merc")
  ) %>%
  tab_row_group(
    group = "Mazdas",
    rows = contains("Mazda")
  ) %>%
  tab_spanner(
    label = "gear_carb_cyl",
    columns = vars(gear, carb, cyl)
  ) %>%
  row_group_order(groups = c("Mazdas", "Mercs")) %>%
  cols_merge_range(
    col_begin = "disp",
    col_end = "drat"
  ) %>%
  tab_header(
    title = "Title",
    subtitle = "Subtitle"
  ) %>%
  tab_source_note(source_note = "this is a source note") %>%
  cols_label(cyl = md("*cyls*")) %>%
  summary_rows(
    groups = c("Mazdas", "Mercs"),
    columns = vars(hp, wt, qsec),
    fns = list(
      ~mean(., na.rm = TRUE),
      ~sum(., na.rm = TRUE))
  ) %>%
  tab_style(
    style = cells_styles(bkgd_color = "lightgray"),
    locations = list(
      cells_column_labels(columns = TRUE),
      cells_stub(rows = TRUE))
  ) %>%
  tab_style(
    style = cells_styles(bkgd_color = "steelblue", text_color = "white"),
    locations = cells_stub(rows = "Merc 240D")
  ) %>%
  tab_style(
    style = cells_styles(text_align = "left"),
    locations = cells_title(groups = "title")
  ) %>%
  tab_style(
    style = cells_styles(text_align = "left"),
    locations = cells_title(groups = "subtitle")
  ) %>%
  tab_style(
    style = cells_styles(bkgd_color = "green", text_color = "white"),
    locations = cells_summary(
      groups = "Mercs",
      columns = "hp",
      rows = 2)
  ) %>%
  tab_style(
    style = cells_styles(bkgd_color = "lightgreen"),
    locations = cells_column_labels(groups = "gear_carb_cyl")
  ) %>%
  tab_style(
    style = cells_styles(bkgd_color = "turquoise"),
    locations = cells_column_labels(columns = "gear")
  ) %>%
  tab_style(
    style = cells_styles(bkgd_color = "pink"),
    locations = cells_column_labels(columns = "hp")
  ) %>%
  tab_style(
    style = cells_styles(
      bkgd_color = "lightgray",
      text_style = "italic"),
    locations = cells_data(
      columns = "hp",
      rows = "Datsun 710")
  ) %>%
  tab_style(
    style = cells_styles(bkgd_color = "yellow"),
    locations = cells_data(
      columns = "disp",
      rows = "Mazda RX4")
  )

many_styles_tbl
