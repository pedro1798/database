-- Team 3 / Phase 2

--------------------------------------------------------
--  파일이 생성됨 - 금요일-10월-09-2026   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table CONSISTS_OF
--------------------------------------------------------

  CREATE TABLE "CONSISTS_OF" 
   (	"RECIPE_NAME" VARCHAR2(100 BYTE), 
	"STORE_ID" NUMBER, 
	"INGRE_ID" NUMBER, 
	"AMOUNT_PER_PORTION" NUMBER(12,3)
   ) ;
--------------------------------------------------------
--  DDL for Table INGREDIENT
--------------------------------------------------------

  CREATE TABLE "INGREDIENT" 
   (	"INGRE_ID" NUMBER, 
	"NAME" VARCHAR2(100 BYTE), 
	"BASE_UNIT" VARCHAR2(10 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table INGREDIENT_TYPE
--------------------------------------------------------

  CREATE TABLE "INGREDIENT_TYPE" 
   (	"INGRE_ID" NUMBER, 
	"TYPE" VARCHAR2(50 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table INVENTORY_BATCH
--------------------------------------------------------

  CREATE TABLE "INVENTORY_BATCH" 
   (	"BATCH_ID" NUMBER, 
	"UNIT_PRICE" NUMBER(12,2), 
	"EXP_DATE" DATE, 
	"RECEIVED_AT" TIMESTAMP (6), 
	"RECEIVED_QUANTITY" NUMBER(12,3), 
	"STORE_ID" NUMBER, 
	"PROVIDER_ID" NUMBER, 
	"INGRE_ID" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table PROVIDER
--------------------------------------------------------

  CREATE TABLE "PROVIDER" 
   (	"PROVIDER_ID" NUMBER, 
	"PHONE" VARCHAR2(20 BYTE), 
	"PROVIDER_NAME" VARCHAR2(100 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Table RECIPE
--------------------------------------------------------

  CREATE TABLE "RECIPE" 
   (	"RECIPE_NAME" VARCHAR2(100 BYTE), 
	"STORE_ID" NUMBER, 
	"PRICE" NUMBER(12,2)
   ) ;
--------------------------------------------------------
--  DDL for Table SALE
--------------------------------------------------------

  CREATE TABLE "SALE" 
   (	"SALES_ID" NUMBER, 
	"SALES_DATE" DATE, 
	"SOLD_QUANTITY" NUMBER(12,3), 
	"SALE_UNIT_PRICE" NUMBER(12,2), 
	"RECIPE_NAME" VARCHAR2(100 BYTE), 
	"STORE_ID" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table SETS_POLICY_FOR
--------------------------------------------------------

  CREATE TABLE "SETS_POLICY_FOR" 
   (	"STORE_ID" NUMBER, 
	"INGRE_ID" NUMBER, 
	"PREORDER_POINT" NUMBER(12,3)
   ) ;
--------------------------------------------------------
--  DDL for Table STOCK_OUT
--------------------------------------------------------

  CREATE TABLE "STOCK_OUT" 
   (	"OUT_ID" NUMBER, 
	"OCCURRED_AT" TIMESTAMP (6), 
	"OUT_TYPE" VARCHAR2(20 BYTE), 
	"QUANTITY" NUMBER(12,3), 
	"BATCH_ID" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table STORE
--------------------------------------------------------

  CREATE TABLE "STORE" 
   (	"STORE_ID" NUMBER, 
	"PHONE" VARCHAR2(20 BYTE), 
	"STORE_NAME" VARCHAR2(100 BYTE), 
	"ZIP_CODE" VARCHAR2(5 BYTE), 
	"DETAILED_ADDR" VARCHAR2(200 BYTE)
   ) ;

-- ===== B. 제약조건 추가 =====
--------------------------------------------------------
--  Constraints for Table CONSISTS_OF
--------------------------------------------------------

  ALTER TABLE "CONSISTS_OF" ADD PRIMARY KEY ("RECIPE_NAME", "STORE_ID", "INGRE_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table INGREDIENT
--------------------------------------------------------

  ALTER TABLE "INGREDIENT" ADD PRIMARY KEY ("INGRE_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table INGREDIENT_TYPE
--------------------------------------------------------

  ALTER TABLE "INGREDIENT_TYPE" ADD PRIMARY KEY ("INGRE_ID", "TYPE")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table INVENTORY_BATCH
--------------------------------------------------------

  ALTER TABLE "INVENTORY_BATCH" ADD PRIMARY KEY ("BATCH_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table PROVIDER
--------------------------------------------------------

  ALTER TABLE "PROVIDER" ADD PRIMARY KEY ("PROVIDER_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table RECIPE
--------------------------------------------------------

  ALTER TABLE "RECIPE" ADD PRIMARY KEY ("RECIPE_NAME", "STORE_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table SALE
--------------------------------------------------------

  ALTER TABLE "SALE" MODIFY ("RECIPE_NAME" NOT NULL ENABLE);
  ALTER TABLE "SALE" MODIFY ("STORE_ID" NOT NULL ENABLE);
  ALTER TABLE "SALE" ADD PRIMARY KEY ("SALES_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table SETS_POLICY_FOR
--------------------------------------------------------

  ALTER TABLE "SETS_POLICY_FOR" ADD PRIMARY KEY ("STORE_ID", "INGRE_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table STOCK_OUT
--------------------------------------------------------

  ALTER TABLE "STOCK_OUT" ADD PRIMARY KEY ("OUT_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table STORE
--------------------------------------------------------

  ALTER TABLE "STORE" ADD CHECK (REGEXP_LIKE(Zip_code, '^[0-9]{5}$')) ENABLE;
  ALTER TABLE "STORE" ADD PRIMARY KEY ("STORE_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table CONSISTS_OF
--------------------------------------------------------

  ALTER TABLE "CONSISTS_OF" ADD FOREIGN KEY ("RECIPE_NAME", "STORE_ID")
	  REFERENCES "RECIPE" ("RECIPE_NAME", "STORE_ID") ON DELETE CASCADE ENABLE;
  ALTER TABLE "CONSISTS_OF" ADD FOREIGN KEY ("INGRE_ID")
	  REFERENCES "INGREDIENT" ("INGRE_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table INGREDIENT_TYPE
--------------------------------------------------------

  ALTER TABLE "INGREDIENT_TYPE" ADD FOREIGN KEY ("INGRE_ID")
	  REFERENCES "INGREDIENT" ("INGRE_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table INVENTORY_BATCH
--------------------------------------------------------

  ALTER TABLE "INVENTORY_BATCH" ADD FOREIGN KEY ("STORE_ID")
	  REFERENCES "STORE" ("STORE_ID") ENABLE;
  ALTER TABLE "INVENTORY_BATCH" ADD FOREIGN KEY ("PROVIDER_ID")
	  REFERENCES "PROVIDER" ("PROVIDER_ID") ON DELETE SET NULL ENABLE;
  ALTER TABLE "INVENTORY_BATCH" ADD FOREIGN KEY ("INGRE_ID")
	  REFERENCES "INGREDIENT" ("INGRE_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table RECIPE
--------------------------------------------------------

  ALTER TABLE "RECIPE" ADD FOREIGN KEY ("STORE_ID")
	  REFERENCES "STORE" ("STORE_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table SALE
--------------------------------------------------------

  ALTER TABLE "SALE" ADD FOREIGN KEY ("RECIPE_NAME", "STORE_ID")
	  REFERENCES "RECIPE" ("RECIPE_NAME", "STORE_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table SETS_POLICY_FOR
--------------------------------------------------------

  ALTER TABLE "SETS_POLICY_FOR" ADD FOREIGN KEY ("STORE_ID")
	  REFERENCES "STORE" ("STORE_ID") ENABLE;
  ALTER TABLE "SETS_POLICY_FOR" ADD FOREIGN KEY ("INGRE_ID")
	  REFERENCES "INGREDIENT" ("INGRE_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table STOCK_OUT
--------------------------------------------------------

  ALTER TABLE "STOCK_OUT" ADD FOREIGN KEY ("BATCH_ID")
	  REFERENCES "INVENTORY_BATCH" ("BATCH_ID") ON DELETE CASCADE ENABLE;


