Team 3 - Phase 2: 실행 환경 및 제출 안내
프로젝트: 식재료 매니저 - 채움

1. 제출 파일

Team3-Phase2-(1).sql: 테이블 10개와 모든 DDL 제약조건.
Team3-Phase2-(2).sql: 500개 INSERT, SET DEFINE OFF, 마지막 COMMIT.
Team3-Phase2-(3).sql: Query 1~10 및 결과 예시 주석.
Team3-etr_mapping.txt: 전체 엔티티와 관계의 매핑, 역할, 정정 사항 및 차이.
Team3-README.txt: 이 안내서.
Team3-ER-Schema.pdf: 제공된 2.pdf의 첫 페이지를 그대로 추출한 최종 기준 ERD.

제출 SQL 3개는 사용자가 제공한 Team3 파일을 변경 없이 복사하였다.
ERD는 원본의 크기와 도형을 유지하고 관계형 스키마가 실린 2페이지는 제외했다.
매핑 설명과 실행 안내는 요구된 일반 텍스트(.txt), UTF-8 형식이다.

2. SQL 동작 환경

대상 DBMS: Oracle Database. VARCHAR2, NUMBER, DATE, TIMESTAMP,
REGEXP_LIKE, TO_DATE, TO_TIMESTAMP 등 Oracle 구문을 사용한다.
대상 버전 예: 기존 접속 로그의 Oracle AI Database 26ai Free
(23.26.3.0.0). 이 버전 서버에서 이번 산출물을 직접 실행한 것은 아니다.
클라이언트: SQLcl 또는 SQL*Plus 권장. SQL Developer에서는 Run Script(F5).
SET DEFINE OFF와 REM은 스크립트 클라이언트 명령이므로 JDBC로 파일 전체를
한 SQL문처럼 실행하지 않는다.

준비 조건:
- CREATE SESSION, CREATE TABLE 권한과 사용 테이블스페이스 할당량이 있는 계정.
- 제출 테이블이 아직 없는 전용 스키마. 기존 데이터가 있는 스키마에 실행하지 않는다.
- 압축을 풀고 여섯 파일을 같은 폴더에 둔다.
- SQLcl/SQL*Plus에서 해당 폴더를 작업 폴더로 사용하거나 절대 경로를 지정한다.
- UTF-8 텍스트를 읽을 수 있는 클라이언트를 사용한다.

3. 실행 순서

DB에 자신의 계정으로 접속한 후 동일 스키마에서 아래 순서로 전체 실행한다.
비밀번호와 접속 정보는 개인 환경에 맞추며 제출 파일에 비밀번호를 저장하지 않는다.

NLS_NUMERIC_CHARACTERS를 '.' 소수점 기준으로 맞춘다. TO_TIMESTAMP의
X 형식은 세션 소수점 문자에 영향을 받으므로 다음 설정을 권장한다.

ALTER SESSION SET NLS_NUMERIC_CHARACTERS = '.,';

@"Team3-Phase2-(1).sql"
@"Team3-Phase2-(2).sql"
@"Team3-Phase2-(3).sql"

SQL Developer는 각 파일을 순서대로 열어 Run Script(F5)로 실행한다.
(1) 전체에 제약조건이 포함되어 있으므로 중간에 분리 실행할 필요가 없다.
(2)는 부모 테이블부터 입력한다:
STORE -> INGREDIENT -> PROVIDER -> INGREDIENT_TYPE -> RECIPE ->
INVENTORY_BATCH -> CONSISTS_OF -> SALE -> SETS_POLICY_FOR -> STOCK_OUT.
마지막 COMMIT은 INSERT를 확정한다. DDL에는 Oracle의 암시적 커밋이 적용된다.

(1)은 기존 테이블을 삭제하지 않으며 반복 실행용 스크립트가 아니다.
(1)을 재실행하면 기존 객체 오류, (2)를 재실행하면 PK 중복 오류가 발생할 수 있다.
에러가 발생하면 해당 원인을 해결하고 진행한다. 클라이언트가 이후 명령을
계속 실행할 수 있으므로 출력 전체에 ORA- 오류가 없는지 확인한다.
임의 DROP이나 기존 데이터 삭제를 자동으로 수행하지 않는다.

4. 데이터 구성 및 확인

STORE                 25
INGREDIENT            25
PROVIDER              25
INGREDIENT_TYPE       35
RECIPE                30
INVENTORY_BATCH       70
CONSISTS_OF           65
SALE                 140
SETS_POLICY_FOR       25
STOCK_OUT             60
합계                 500

모든 테이블에 25개 이상, 전체에 500개의 레코드를 넣는다.
카페명·주소 등에 fictional이 포함된 과제용 샘플 데이터이다.
입고와 판매의 날짜는 주로 2026년의 샘플 시점이며 현재 날짜를 뜻하지 않는다.

전체 건수 확인 예:
SELECT 'STORE' AS TABLE_NAME, COUNT(*) AS CNT FROM STORE
UNION ALL SELECT 'INGREDIENT', COUNT(*) FROM INGREDIENT
UNION ALL SELECT 'PROVIDER', COUNT(*) FROM PROVIDER
UNION ALL SELECT 'INGREDIENT_TYPE', COUNT(*) FROM INGREDIENT_TYPE
UNION ALL SELECT 'RECIPE', COUNT(*) FROM RECIPE
UNION ALL SELECT 'INVENTORY_BATCH', COUNT(*) FROM INVENTORY_BATCH
UNION ALL SELECT 'CONSISTS_OF', COUNT(*) FROM CONSISTS_OF
UNION ALL SELECT 'SALE', COUNT(*) FROM SALE
UNION ALL SELECT 'SETS_POLICY_FOR', COUNT(*) FROM SETS_POLICY_FOR
UNION ALL SELECT 'STOCK_OUT', COUNT(*) FROM STOCK_OUT;

제약조건 확인 예:
SELECT TABLE_NAME, CONSTRAINT_TYPE, STATUS
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('STORE','INGREDIENT','PROVIDER','INGREDIENT_TYPE',
 'RECIPE','INVENTORY_BATCH','CONSISTS_OF','SALE','SETS_POLICY_FOR','STOCK_OUT')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;

5. 질의 10개와 과제 유형 대응

Query 1 / Type 1: STORE 단일 테이블, REGEXP_LIKE 선택, SELECT * 투영.
Query 2 / Type 2: STORE·INGREDIENT·CONSISTS_OF, WHERE의 다중 조인 조건.
Query 3 / Type 3: 다중 조인, SUM, GROUP BY.
Query 4 / Type 4: 평균 가격을 구하는 서브쿼리.
Query 5 / Type 5: EXISTS 상관 서브쿼리.
Query 6 / Type 6: 복합값 IN 조건과 투영.
Query 7 / Type 7: FROM 절의 인라인 뷰.
Query 8 / Type 8: WHERE의 다중 조인 조건과 ORDER BY.
Query 9 / Type 9: 다중 조인, SUM, GROUP BY, ORDER BY.
Query 10 / Type 10: INTERSECT 집합 연산.

파일 내 주석은 결과 예시이며 Query 2 등 일부 출력은 생략되어 있다.


6. ERD 및 매핑 문서의 범위

최종 ERD에는 STORE, PROVIDER, INGREDIENT, RECIPE, INVENTORY_BATCH,
SALE, STOCK_OUT와 8개 관계가 있다. INGREDIENT.Type은 다중값 속성이므로
INGREDIENT_TYPE으로, M:N 관계는 CONSISTS_OF·SETS_POLICY_FOR로 매핑한다.
따라서 관계형 테이블은 10개이다.
ORDER 및 ORDER_LINE과 공동구매·가격 이력 등의 확장 구조는 포함하지 않는다.
각 관계의 양쪽 역할과 전체 속성은 Team3-etr_mapping.txt에 설명하였다.

주요 차이:
- ERD의 Reorder_point는 SQL에서 PREORDER_POINT라는 이름을 쓴다.
- ERD의 필수 참여 일부는 nullable FK 때문에 SQL에서 강제되지 않는다.
- SUPPLIES는 ERD에서 배치의 공급처가 필수지만 SQL은 공급처 삭제 시
  ON DELETE SET NULL을 적용한다.
- 유도 속성 Current_quantity, Sales_amount, Waste_cost,
  Expected_depletion_date는 저장 컬럼이 아니다.

