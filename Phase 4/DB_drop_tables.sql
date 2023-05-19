-- SET FOREIGN_KEY_CHECKS = 0; Disable foreign key constraint checking before dropping the tables.
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS RestaurantData;
DROP TABLE IF EXISTS RestaurantFacility;
DROP TABLE IF EXISTS ItemData;
DROP TABLE IF EXISTS CustomerData;
DROP TABLE IF EXISTS CustomerFavouriteFood;
DROP TABLE IF EXISTS EmployeeData;
DROP TABLE IF EXISTS OrdersData;
DROP TABLE IF EXISTS OrderHasItems;
DROP TABLE IF EXISTS ReviewsData;
SET FOREIGN_KEY_CHECKS = 1;
-- SET FOREIGN_KEY_CHECKS = 1; Enable foreign key constraint checking before dropping the tables.