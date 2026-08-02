# nolint start
# Expects: root, FONT.SIZE.BODY, FONT.SIZE.HEADER
# Overfitting diagnostic for the accepted model of each response family.
# Compact headers; definitions live in the caption.

OF <- fread(file.path(root, "data", "summary", "overfit.csv"))

DT <- OF[, .(response, method,
             rmse.in = round(rmse_in, 3), rmse.cv = round(rmse_cv_mean, 3),
             optimism = round(rel_optimism, 2), flag)]
setorder(DT, -response, method)

TBL <- DT |> buildTable(library = "flextable", align.body = "center",
                        font.size.body = FONT.SIZE.BODY, font.size.header = FONT.SIZE.HEADER)
TBL <- flextable::set_table_properties(TBL, layout = "autofit")
# nolint end
