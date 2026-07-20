document.querySelectorAll(".product").forEach(card => {
    card.addEventListener("click", () => {
        const id = card.dataset.id;
        window.location.href = `/SingleItem?=${id}`;
    });
});