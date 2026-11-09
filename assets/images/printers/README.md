# User-supplied printer photos

Sources: `PRODUCTOS/00001-II` through `00004-II`, uploaded by the user. All three photos per product are retained. The HP 315 AVIF images are converted to JPEG for cross-platform Flutter decoding; the other JPEGs are copied unchanged. Source files are never overwritten. `tool/prepare_printer_assets.py` reproduces this preparation using Pillow in `.dart_tool/asset-conversion`.

Descriptions and base prices come from the accompanying text files: HP Smart Tank 315 (S/ 650), Epson EcoTank L3110 (S/ 740), Epson EcoTank L3160 (S/ 950), HP Smart Tank 515 (S/ 850). Duplicated prose is removed, and the fourth document's stray Epson heading is ignored in favor of its HP 515 description and photos. No additional technical capabilities are inferred.

The catalog includes 20 entries per base product, reusing its photos and specifications. Copies after the first have a visible `Demo NN` name and distinct IDs. Stock and ratings are demonstration values, not verified availability or customer reviews. The catalog contains only these 80 printer examples. Some have fictional crossed-out previous prices to demonstrate discounts; source current prices are preserved.
