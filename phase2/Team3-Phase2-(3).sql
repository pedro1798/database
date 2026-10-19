-- Team 3 / Phase 2

--------------------------------------------------------
-- Query 1
--------------------------------------------------------
SELECT * FROM STORE WHERE REGEXP_LIKE(Detailed_addr, 'Busan');
/*

   STORE_ID PHONE          STORE_NAME    ZIP_CODE    DETAILED_ADDR
___________ ______________ _____________ ___________ ___________________________________
         19 02-555-1019    Busan Cafe    06019       119 Sample-ro, Busan (fictional)

*/
--------------------------------------------------------
-- Query 2
--------------------------------------------------------
SELECT S.Store_name, I.Name AS Ingredient_name FROM STORE S, INGREDIENT I, CONSISTS_OF C
  WHERE S.Store_id = C.Store_id AND C.Ingre_id = I.Ingre_id
  ORDER BY S.Store_name ASC;
/*
STORE_NAME       INGREDIENT_NAME
________________ ___________________
Bundang Cafe     Coffee Beans
Bundang Cafe     Milk
Busan Cafe       Peach Puree
Busan Cafe       Sparkling Water
Cheongju Cafe    Milk
Cheongju Cafe    Strawberry Puree
Daegu Cafe       Mango Puree
Daegu Cafe       Sparkling Water
Daejeon Cafe     Milk
Daejeon Cafe     Cocoa Powder
Gangnam Cafe     Coffee Beans
Gangnam Cafe     Filtered Water
Gangnam Cafe     Matcha Powder
Gangnam Cafe     Honey
Gangnam Cafe     Milk
Guro Cafe        Filtered Water
...

 */
--------------------------------------------------------
-- Query 3
--------------------------------------------------------
 SELECT S.Store_name, I.Name as Ingre_name, I.Base_unit, SUM(SO.Quantity) as total_out
 FROM STORE S
 JOIN INVENTORY_BATCH IB ON S.Store_id = IB.Store_id
 JOIN INGREDIENT I ON IB.Ingre_id = I.Ingre_id
 JOIN STOCK_OUT SO ON IB.Batch_id = SO.Batch_id
 GROUP BY S.Store_name, I.Name, I.Base_unit;
/*
STORE_NAME      INGRE_NAME          BASE_UNIT       TOTAL_OUT
_______________ ___________________ ____________ ____________
Gangnam Cafe    Coffee Beans        g                     300
Gangnam Cafe    Filtered Water      ml                   1800
Gangnam Cafe    Honey               g                     500
Hongdae Cafe    Coffee Beans        g                     600
Hongdae Cafe    Milk                ml                   1000
Hongdae Cafe    Honey               g                     300
Jamsil Cafe     Coffee Beans        g                     400
Jamsil Cafe     Oat Milk            ml                   2200
Jamsil Cafe     Honey               g                     600
Seongsu Cafe    Matcha Powder       g                     200
Seongsu Cafe    Milk                ml                    700
Seongsu Cafe    Honey               g                     200
Yeouido Cafe    Black Tea           g                     250
Yeouido Cafe    Filtered Water      ml                   1300
Yeouido Cafe    Honey               g                     100
Jongno Cafe     Cocoa Powder        g                     150
Jongno Cafe     Milk                ml                    900
Sinchon Cafe    Strawberry Puree    g                     250
Sinchon Cafe    Milk                ml                   1300
Itaewon Cafe    Mango Puree         g                     100
Itaewon Cafe    Sparkling Water     ml                    700
Mapo Cafe       Peach Puree         g                     200
Mapo Cafe       Sparkling Water     ml                   1100
Guro Cafe       Decaf Beans         g                     300
Guro Cafe       Filtered Water      ml                    500

STORE_NAME       INGRE_NAME          BASE_UNIT       TOTAL_OUT
________________ ___________________ ____________ ____________
Suwon Cafe       Coffee Beans        g                     150
Suwon Cafe       Filtered Water      ml                    900
Bundang Cafe     Coffee Beans        g                     250
Bundang Cafe     Milk                ml                   1300
Pangyo Cafe      Coffee Beans        g                     100
Pangyo Cafe      Oat Milk            ml                    700
Ilsan Cafe       Matcha Powder       g                     200
Ilsan Cafe       Milk                ml                   1100
Incheon Cafe     Black Tea           g                     300
Incheon Cafe     Filtered Water      ml                    500
Daejeon Cafe     Cocoa Powder        g                     150
Daejeon Cafe     Milk                ml                    900
Cheongju Cafe    Strawberry Puree    g                     250
Cheongju Cafe    Milk                ml                   1300
Daegu Cafe       Mango Puree         g                     100
Daegu Cafe       Sparkling Water     ml                    700
Busan Cafe       Peach Puree         g                     200
Busan Cafe       Sparkling Water     ml                   1100
Gwangju Cafe     Decaf Beans         g                     300
Gwangju Cafe     Filtered Water      ml                    500
Jeonju Cafe      Coffee Beans        g                     150
Jeonju Cafe      Filtered Water      ml                    900
Ulsan Cafe       Coffee Beans        g                     250
Ulsan Cafe       Milk                ml                   1300
Jeju Cafe        Coffee Beans        g                     100


50 rows selected.
*/

--------------------------------------------------------
-- Query 4
--------------------------------------------------------
SELECT S.Store_name, R.Recipe_name, R.Price FROM STORE S
  JOIN RECIPE R ON S.Store_id = R.Store_id
  WHERE R.Price > (
  SELECT AVG(Price) FROM RECIPE
);
/*
STORE_NAME       RECIPE_NAME              PRICE
________________ _____________________ ________
Gangnam Cafe     Matcha Latte              5400
Hongdae Cafe     Honey Cafe Latte          4900
Jamsil Cafe      Honey Oat Latte           5000
Seongsu Cafe     Honey Matcha Latte        5400
Seongsu Cafe     Strawberry Milk           5500
Yeouido Cafe     Mango Soda                5700
Jongno Cafe      Peach Soda                5100
Sinchon Cafe     Strawberry Milk           5500
Itaewon Cafe     Mango Soda                5700
Mapo Cafe        Peach Soda                5100
Pangyo Cafe      Oat Latte                 5200
Ilsan Cafe       Matcha Latte              5600
Daejeon Cafe     Cocoa                     5000
Cheongju Cafe    Strawberry Milk           5700
Daegu Cafe       Mango Soda                5300
Busan Cafe       Peach Soda                5300
Jeju Cafe        Oat Latte                 5400

17 rows selected.
*/
--------------------------------------------------------
-- Query 5
--------------------------------------------------------
SELECT S.Store_name, R.Recipe_name
  FROM RECIPE R
  JOIN STORE S ON R.Store_id = S.Store_id
  WHERE EXISTS (
    SELECT 1
    FROM CONSISTS_OF C
    JOIN INGREDIENT I ON C.Ingre_id = I.Ingre_id
    WHERE C.Recipe_name = R.Recipe_name
      AND C.Store_id = R.Store_id
      AND I.Name = 'Milk'
  )
ORDER BY S.Store_name, R.Recipe_name;
/*
STORE_NAME       RECIPE_NAME
________________ _____________________
Bundang Cafe     Cafe Latte
Cheongju Cafe    Strawberry Milk
Daejeon Cafe     Cocoa
Gangnam Cafe     Matcha Latte
Hongdae Cafe     Honey Cafe Latte
Ilsan Cafe       Matcha Latte
Jamsil Cafe      Cocoa
Jongno Cafe      Cocoa
Seongsu Cafe     Honey Matcha Latte
Seongsu Cafe     Strawberry Milk
Sinchon Cafe     Strawberry Milk
Ulsan Cafe       Cafe Latte

12 rows selected.
*/
--------------------------------------------------------
-- Query 6
--------------------------------------------------------
SELECT S.Store_name, R.Recipe_name
FROM RECIPE R
JOIN STORE S ON R.Store_id = S.Store_id
WHERE (R.Recipe_name, R.Store_id) IN (
    SELECT C.Recipe_name, C.Store_id
    FROM CONSISTS_OF C
    JOIN INGREDIENT I ON C.Ingre_id = I.Ingre_id
    WHERE I.Name = 'Milk'
)
ORDER BY S.Store_name;
/*
STORE_NAME       RECIPE_NAME
________________ _____________________
Bundang Cafe     Cafe Latte
Cheongju Cafe    Strawberry Milk
Daejeon Cafe     Cocoa
Gangnam Cafe     Matcha Latte
Hongdae Cafe     Honey Cafe Latte
Ilsan Cafe       Matcha Latte
Jamsil Cafe      Cocoa
Jongno Cafe      Cocoa
Seongsu Cafe     Strawberry Milk
Seongsu Cafe     Honey Matcha Latte
Sinchon Cafe     Strawberry Milk
Ulsan Cafe       Cafe Latte

12 rows selected.
*/
--------------------------------------------------------
-- Query 7
--------------------------------------------------------
SELECT *
FROM (
    SELECT Name, Base_unit
    FROM INGREDIENT
) V;

/*
 NAME                BASE_UNIT
___________________ ____________
Coffee Beans        g
Milk                ml
Oat Milk            ml
Almond Milk         ml
Cocoa Powder        g
Vanilla Syrup       ml
Caramel Syrup       ml
Matcha Powder       g
Black Tea           g
Green Tea           g
Honey               g
Sugar               g
Strawberry Puree    g
Mango Puree         g
Peach Puree         g
Lemon Juice         ml
Lime Juice          ml
Mint Leaves         g
Chai Powder         g
Whipping Cream      ml
Coconut Milk        ml
Decaf Beans         g
Sparkling Water     ml
Filtered Water      ml
Chocolate Sauce     g

25 rows selected.
 */

--------------------------------------------------------
-- Query 8
--------------------------------------------------------
SELECT
  S.Store_name,
  I.Name AS Ingre_name,
  SO.Quantity AS Out_quantity
FROM STORE S, INVENTORY_BATCH IB, INGREDIENT I, STOCK_OUT SO
WHERE S.Store_id = IB.Store_id
  AND IB.Ingre_id = I.Ingre_id
  AND IB.Batch_id = SO.Batch_id
ORDER BY S.Store_name ASC, I.Name ASC;

/*
 STORE_NAME       INGRE_NAME             OUT_QUANTITY
________________ ___________________ _______________
Bundang Cafe     Coffee Beans                    250
Bundang Cafe     Milk                           1300
Busan Cafe       Peach Puree                     200
Busan Cafe       Sparkling Water                1100
Cheongju Cafe    Milk                           1300
Cheongju Cafe    Strawberry Puree                250
Daegu Cafe       Mango Puree                     100
Daegu Cafe       Sparkling Water                 700
Daejeon Cafe     Cocoa Powder                    150
Daejeon Cafe     Milk                            900
Gangnam Cafe     Coffee Beans                    150
Gangnam Cafe     Coffee Beans                    150
Gangnam Cafe     Filtered Water                  900
Gangnam Cafe     Filtered Water                  900
Gangnam Cafe     Honey                           250
Gangnam Cafe     Honey                           250
Guro Cafe        Decaf Beans                     300
Guro Cafe        Filtered Water                  500
Gwangju Cafe     Decaf Beans                     300
Gwangju Cafe     Filtered Water                  500
Hongdae Cafe     Coffee Beans                    300
Hongdae Cafe     Coffee Beans                    300
Hongdae Cafe     Honey                           150
Hongdae Cafe     Honey                           150
Hongdae Cafe     Milk                            500
Hongdae Cafe     Milk                            500
Ilsan Cafe       Matcha Powder                   200
Ilsan Cafe       Milk                           1100
Incheon Cafe     Black Tea                       300
Incheon Cafe     Filtered Water                  500
Itaewon Cafe     Mango Puree                     100
Itaewon Cafe     Sparkling Water                 700
Jamsil Cafe      Coffee Beans                    200
Jamsil Cafe      Coffee Beans                    200
Jamsil Cafe      Honey                           300
Jamsil Cafe      Honey                           300

STORE_NAME      INGRE_NAME             OUT_QUANTITY
_______________ ___________________ _______________
Jamsil Cafe     Oat Milk                       1100
Jamsil Cafe     Oat Milk                       1100
Jeju Cafe       Coffee Beans                    100
Jeonju Cafe     Coffee Beans                    150
Jeonju Cafe     Filtered Water                  900
Jongno Cafe     Cocoa Powder                    150
Jongno Cafe     Milk                            900
Mapo Cafe       Peach Puree                     200
Mapo Cafe       Sparkling Water                1100
Pangyo Cafe     Coffee Beans                    100
Pangyo Cafe     Oat Milk                        700
Seongsu Cafe    Honey                           200
Seongsu Cafe    Matcha Powder                   100
Seongsu Cafe    Matcha Powder                   100
Seongsu Cafe    Milk                            700
Sinchon Cafe    Milk                           1300
Sinchon Cafe    Strawberry Puree                250
Suwon Cafe      Coffee Beans                    150
Suwon Cafe      Filtered Water                  900
Ulsan Cafe      Coffee Beans                    250
Ulsan Cafe      Milk                           1300
Yeouido Cafe    Black Tea                       250
Yeouido Cafe    Filtered Water                 1300
Yeouido Cafe    Honey                           100
 */

--------------------------------------------------------
-- Query 9
--------------------------------------------------------
 SELECT S.Store_name, I.Name as Ingre_name, I.Base_unit, SUM(SO.Quantity) as total_out
 FROM STORE S
 JOIN INVENTORY_BATCH IB ON S.Store_id = IB.Store_id
 JOIN INGREDIENT I ON IB.Ingre_id = I.Ingre_id
 JOIN STOCK_OUT SO ON IB.Batch_id = SO.Batch_id
 GROUP BY S.Store_name, I.Name, I.Base_unit
 ORDER BY Store_name, Ingre_name ASC;
/*
STORE_NAME       INGRE_NAME          BASE_UNIT       TOTAL_OUT
________________ ___________________ ____________ ____________
Bundang Cafe     Coffee Beans        g                     250
Bundang Cafe     Milk                ml                   1300
Busan Cafe       Peach Puree         g                     200
Busan Cafe       Sparkling Water     ml                   1100
Cheongju Cafe    Milk                ml                   1300
Cheongju Cafe    Strawberry Puree    g                     250
Daegu Cafe       Mango Puree         g                     100
Daegu Cafe       Sparkling Water     ml                    700
Daejeon Cafe     Cocoa Powder        g                     150
Daejeon Cafe     Milk                ml                    900
Gangnam Cafe     Coffee Beans        g                     300
Gangnam Cafe     Filtered Water      ml                   1800
Gangnam Cafe     Honey               g                     500
Guro Cafe        Decaf Beans         g                     300
Guro Cafe        Filtered Water      ml                    500
Gwangju Cafe     Decaf Beans         g                     300
Gwangju Cafe     Filtered Water      ml                    500
Hongdae Cafe     Coffee Beans        g                     600
Hongdae Cafe     Honey               g                     300
Hongdae Cafe     Milk                ml                   1000
Ilsan Cafe       Matcha Powder       g                     200
Ilsan Cafe       Milk                ml                   1100
Incheon Cafe     Black Tea           g                     300
Incheon Cafe     Filtered Water      ml                    500
Itaewon Cafe     Mango Puree         g                     100

STORE_NAME      INGRE_NAME          BASE_UNIT       TOTAL_OUT
_______________ ___________________ ____________ ____________
Itaewon Cafe    Sparkling Water     ml                    700
Jamsil Cafe     Coffee Beans        g                     400
Jamsil Cafe     Honey               g                     600
Jamsil Cafe     Oat Milk            ml                   2200
Jeju Cafe       Coffee Beans        g                     100
Jeonju Cafe     Coffee Beans        g                     150
Jeonju Cafe     Filtered Water      ml                    900
Jongno Cafe     Cocoa Powder        g                     150
Jongno Cafe     Milk                ml                    900
Mapo Cafe       Peach Puree         g                     200
Mapo Cafe       Sparkling Water     ml                   1100
Pangyo Cafe     Coffee Beans        g                     100
Pangyo Cafe     Oat Milk            ml                    700
Seongsu Cafe    Honey               g                     200
Seongsu Cafe    Matcha Powder       g                     200
Seongsu Cafe    Milk                ml                    700
Sinchon Cafe    Milk                ml                   1300
Sinchon Cafe    Strawberry Puree    g                     250
Suwon Cafe      Coffee Beans        g                     150
Suwon Cafe      Filtered Water      ml                    900
Ulsan Cafe      Coffee Beans        g                     250
Ulsan Cafe      Milk                ml                   1300
Yeouido Cafe    Black Tea           g                     250
Yeouido Cafe    Filtered Water      ml                   1300
Yeouido Cafe    Honey               g                     100


50 rows selected.
*/
-------------------------------------------------------
-- Query 10
--------------------------------------------------------
SELECT S.Store_name, R.Recipe_name
  FROM RECIPE R
  JOIN STORE S ON R.Store_id = S.Store_id
  WHERE EXISTS (
    SELECT 1
    FROM CONSISTS_OF C
    JOIN INGREDIENT I ON C.Ingre_id = I.Ingre_id
    WHERE C.Recipe_name = R.Recipe_name
      AND C.Store_id = R.Store_id
      AND I.Name = 'Milk'
  )
INTERSECT
SELECT S.Store_name, R.Recipe_name
  FROM RECIPE R
  JOIN STORE S ON R.Store_id = S.Store_id
  WHERE EXISTS (
    SELECT 1
    FROM CONSISTS_OF C
    JOIN INGREDIENT I ON C.Ingre_id = I.Ingre_id
    WHERE C.Recipe_name = R.Recipe_name
      AND C.Store_id = R.Store_id
      AND I.Name = 'Milk'
);
/*
 STORE_NAME       RECIPE_NAME
________________ _____________________
Gangnam Cafe     Matcha Latte
Hongdae Cafe     Honey Cafe Latte
Jamsil Cafe      Cocoa
Seongsu Cafe     Strawberry Milk
Seongsu Cafe     Honey Matcha Latte
Jongno Cafe      Cocoa
Sinchon Cafe     Strawberry Milk
Bundang Cafe     Cafe Latte
Ilsan Cafe       Matcha Latte
Daejeon Cafe     Cocoa
Cheongju Cafe    Strawberry Milk
Ulsan Cafe       Cafe Latte

12 rows selected.
 */
-- end test
