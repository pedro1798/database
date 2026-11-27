// static/js/main.js
// UI 전용 코드입니다. 실제 SQL 조회·등록·수정·삭제는 아직 실행하지 않습니다.
// 아래 필드 이름은 UI용이며 실제 DB 스키마에 맞게 연결해야 합니다.

const features = {
    stock: {
        title: "재료 재고 목록",
        columns: ["재료 ID", "재료명", "재료 유형", "재고량", "단위"],
        fields: [["ingredient", "재료명"]],
        description: "재료별 현재 재고를 확인합니다."
    },
    sales: {
        title: "판매량 목록",
        columns: ["매장명", "메뉴명", "판매량", "판매금액"],
        fields: [["menu", "메뉴명"]],
        description: "선택한 기간의 메뉴별 판매량을 확인합니다."
    },
    frequent: {
        title: "자주 사용하는 재료",
        columns: ["순위", "재료명", "사용 횟수", "소비량", "단위"],
        fields: [["ingredient", "재료명"]],
        description: "선택한 기간에 자주 사용한 재료를 조회합니다."
    },
    waste: {
        title: "폐기량 많은 재료",
        columns: ["순위", "재료명", "폐기량", "단위", "폐기금액"],
        fields: [["ingredient", "재료명"]],
        description: "폐기량과 폐기금액을 확인합니다. 수량 비교 시 단위를 확인하세요."
    },
    price: {
        title: "공급자별 재료 시세",
        columns: ["재료명", "공급자", "가격", "기준 단위", "기준일"],
        fields: [["ingredient", "재료명"], ["supplier", "공급자명"]],
        description: "동일 재료를 같은 단위로 환산하여 공급자별 가격을 비교합니다."
    },
    margin: {
        title: "메뉴별 마진율",
        columns: ["매장명", "메뉴명", "판매가", "재료비", "마진율(%)"],
        fields: [["menu", "메뉴명"]],
        description: "마진율 = (판매가 − 재료비) ÷ 판매가 × 100"
    },
    depletion: {
        title: "재료 소진 시점 예측",
        columns: ["재료명", "현재 재고", "일평균 소비량", "단위", "남은 일수", "예상 소진일"],
        fields: [["ingredient", "재료명"]],
        description: "선택한 기간의 평균 소비량을 기준으로 소진 시점을 예측합니다."
    },
    type: {
        title: "재료 유형별 검색",
        columns: ["재료명", "재료 유형", "재고량", "단위", "단가", "폐기량"],
        fields: [["ingredient_type", "재료 유형", "예: 냉동제품"]],
        description: "재료 유형을 입력하고 정렬 기준을 선택하세요."
    },
    ranking: {
        title: "동종업계 이익 순위",
        columns: ["순위", "업종", "매장명", "메뉴명", "단위이윤", "판매량", "총이익"],
        fields: [["industry", "업종"]],
        description: "같은 업종끼리 비교합니다. 순위 기준 = (판매가 − 재료비) × 판매량"
    },
    recipe: {
        title: "공통 재료 레시피 목록",
        columns: ["레시피 ID", "레시피명", "공통 재료", "전체 재료"],
        fields: [["ingredients", "공통 재료", "예: 우유, 밀가루"]],
        description: "쉼표로 구분한 재료가 모두 포함된 레시피를 검색합니다."
    },
    manage: {
        title: "재료 관리 목록",
        columns: ["재료 ID", "재료명", "재료 유형", "재고량", "단위", "단가"],
        fields: [["ingredient", "재료명"]],
        description: "신규 등록은 재료 정보를 입력하고, 수정·삭제는 재료 ID를 지정합니다."
    }
};

const searchForm = document.getElementById("search-form");
const featureSelect = document.getElementById("feature");
const extraFilters = document.getElementById("extra-filters");
const managePanel = document.getElementById("manage-panel");
const manageForm = document.getElementById("manage-form");
const resultTitle = document.getElementById("result-title");
const resultCount = document.getElementById("result-count");
const resultHead = document.getElementById("result-head");
const resultBody = document.getElementById("result-body");
const description = document.getElementById("query-description");
const status = document.getElementById("status");

function addFilter(name, title, placeholder = "전체") {
    const container = document.createElement("div");
    container.className = "filter";

    const label = document.createElement("label");
    label.htmlFor = `filter-${name}`;
    label.textContent = title;

    const input = document.createElement("input");
    input.id = label.htmlFor;
    input.name = name;
    input.placeholder = placeholder;

    container.append(label, input);
    extraFilters.append(container);
}

function addSortFilter() {
    const container = document.createElement("div");
    container.className = "filter";

    const label = document.createElement("label");
    label.htmlFor = "sort";
    label.textContent = "정렬 기준";

    const select = document.createElement("select");
    select.id = "sort";
    select.name = "sort";

    [
        ["stock_desc", "재고량 많은 순"],
        ["stock_asc", "재고량 적은 순"],
        ["price_asc", "단가 낮은 순"],
        ["price_desc", "단가 높은 순"],
        ["waste_desc", "폐기량 많은 순"]
    ].forEach(([value, text]) => {
        select.add(new Option(text, value));
    });

    container.append(label, select);
    extraFilters.append(container);
}

function renderResults(rows = []) {
    const config = features[featureSelect.value];
    resultHead.replaceChildren();
    resultBody.replaceChildren();

    const headerRow = document.createElement("tr");

    config.columns.forEach(column => {
        const th = document.createElement("th");
        th.scope = "col";
        th.textContent = column;
        headerRow.append(th);
    });

    resultHead.append(headerRow);
    resultCount.textContent = `${rows.length}건`;

    if (rows.length === 0) {
        const tr = document.createElement("tr");
        const td = document.createElement("td");
        td.colSpan = config.columns.length;
        td.className = "empty";
        td.textContent = "표시할 데이터가 없습니다.";
        tr.append(td);
        resultBody.append(tr);
        return;
    }

    // rows 형식: 각 행이 표시할 값의 배열인 2차원 배열
    rows.forEach(row => {
        const tr = document.createElement("tr");

        config.columns.forEach((_, index) => {
            const td = document.createElement("td");
            td.textContent = row[index] ?? "";
            tr.append(td);
        });

        resultBody.append(tr);
    });
}

function changeFeature() {
    const key = featureSelect.value;
    const config = features[key];

    extraFilters.replaceChildren();
    config.fields.forEach(field => addFilter(...field));

    if (key === "type") {
        addSortFilter();
    }

    managePanel.hidden = key !== "manage";
    resultTitle.textContent = config.title;
    description.textContent = config.description;
    status.textContent = "조회 조건을 입력하세요. 현재는 UI만 구현되어 있습니다.";
    renderResults();
}

featureSelect.addEventListener("change", changeFeature);

searchForm.addEventListener("submit", event => {
    event.preventDefault();

    const start = searchForm.elements.start_date.value;
    const end = searchForm.elements.end_date.value;

    if (start && end && start > end) {
        status.textContent = "조회 종료일은 시작일 이후로 선택하세요.";
        searchForm.elements.end_date.focus();
        return;
    }

    const conditions = Object.fromEntries(new FormData(searchForm));

    // TODO: conditions를 조회 API에 전달한 뒤 renderResults(결과배열) 호출
    status.textContent = `${features[conditions.feature].title}: 조회 API 연결 전입니다.`;
});

searchForm.addEventListener("reset", () => {
    // 기본 선택값으로 돌아간 다음 추가 필터를 다시 만듭니다.
    setTimeout(changeFeature, 0);
});

manageForm.addEventListener("submit", event => {
    event.preventDefault();

    const action = event.submitter.value;
    const values = Object.fromEntries(new FormData(manageForm));
    const names = { insert: "등록", update: "수정", delete: "삭제" };

    if (action !== "insert" && !values.ingredient_id.trim()) {
        status.textContent = `${names[action]}할 재료 ID를 입력하세요.`;
        manageForm.elements.ingredient_id.focus();
        return;
    }

    if (action === "insert" && !values.ingredient_name.trim()) {
        status.textContent = "등록할 재료명을 입력하세요.";
        manageForm.elements.ingredient_name.focus();
        return;
    }

    // TODO: action과 values를 등록·수정·삭제 API에 전달
    // 실제 삭제 API 연결 시 사용자 확인 단계를 추가하세요.
    status.textContent = `${names[action]} API 연결 전입니다. 실제 데이터는 변경되지 않았습니다.`;
});

changeFeature();
