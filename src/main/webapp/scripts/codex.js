document.addEventListener("DOMContentLoaded", () => {
    const buttons = [...document.querySelectorAll(".filter-button")];
    const products = [...document.querySelectorAll(".codex-product")];
    const resultCount = document.getElementById("result-count");
    const noResults = document.getElementById("no-filter-results");
    const grid = document.getElementById("product-grid");

    const normalize = value => (value || "")
        .trim()
        .toLocaleLowerCase("it-IT");

    function updateCount(visible) {
        if (!resultCount) return;

        resultCount.textContent =
            `${visible} ${visible === 1 ? "prodotto" : "prodotti"}`;
    }

    function applyFilter(selectedType) {
        const normalizedFilter = normalize(selectedType);
        let visible = 0;

        products.forEach(product => {
            const productType = normalize(product.dataset.tipo);

            const mustShow =
                normalizedFilter === "all" ||
                productType === normalizedFilter;

            product.classList.toggle("filtered-out", !mustShow);

            if (mustShow) {
                visible++;
            }
        });

        if (grid) {
            grid.classList.toggle("hidden", visible === 0);
        }

        if (noResults) {
            noResults.classList.toggle("hidden", visible !== 0);
        }

        updateCount(visible);
    }

    buttons.forEach(button => {
        button.addEventListener("click", () => {
            buttons.forEach(item => {
                item.classList.remove("active");
            });

            button.classList.add("active");

            applyFilter(button.dataset.filter);
        });
    });

    updateCount(products.length);
});