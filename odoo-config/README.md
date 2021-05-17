## Odoo Metadata Configuration
======================================================================

This folder contains the templates of the CSV files used to configure Odoo's metadata.
Please refer to the steps below to import the CSV files in Odoo.

### Steps to import CSV files
- login into Odoo with a user with admin role;
- navigate to the list of metadata to be updated (the table below contains the paths to use for each CSV file);
- if the metadata list is displayed as cards, change the display view to "List" by clicking on the last icon at right just bellow the search field;
- click on import and then load the CSV file;
- click on "+ Options…" and change the Encoding to "latin1" to avoid validation errors;
- click on "Validate" at the top of the page and confirm that the CSV file is valid before importing;
- click on "Import" at the top op of the page to load the metadata from the CSV file into Odoo.

### Navigation paths to Odoo pages where to import CSV files

File | Path
--- | ---
`Product_list.csv` and `Service_list.csv` | Tab `Inventory` <br/> Menu `Products` (it's under section `Inventory Control`)
`product.category.csv` | Tab `Inventory` <br/> Menu `Product Categories` (it's under section `Configuration` and sub-section `Products`)
`res.company.info.csv` and `Service_list.csv` | Tab `Settings` <br/> Menu `Companies` (it's under section `Users`)
`res.users.csv` and `Service_list.csv` | Tab `Settings` <br/> Menu `Users` (it's under section `Users`)
`stock.location.csv` | Tab `Inventory` <br/> Menu `Locations` (it's under section `Configuration` and sub-section `Warehouse Management`)
`stock.production.lot.csv` | Tab `Inventory` <br/> Menu `Lots/Serial Numbers` (it's under section `Inventory Control`)
`stock.warehouse.csv` | Tab `Inventory` <br/> Menu `Warehouses` (it's under section `Configuration` and sub-section `Warehouse Management`)
`venders.csv` | Tab `Purchases` <br/> Menu `Vendors` (it's under section `Purchase`)
