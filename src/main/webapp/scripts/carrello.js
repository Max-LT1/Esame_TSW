"use strict";

document.addEventListener("DOMContentLoaded", () => {
    const cartItemsContainer = document.getElementById("cartItems");
    const emptyCart = document.getElementById("emptyCart");
    const cartSummary = document.getElementById("cartSummary");
    const cartSubtotal = document.getElementById("cartSubtotal");
    const cartTotal = document.getElementById("cartTotal");
    const cartTotalItems = document.getElementById("cartTotalItems");
    const clearCartButton = document.getElementById("clearCartButton");
    const confirmationModal =
        document.getElementById("confirmationModal");
    const confirmationTitle =
        document.getElementById("confirmationTitle");
    const confirmationMessage =
        document.getElementById("confirmationMessage");
    const cancelConfirmation =
        document.getElementById("cancelConfirmation");
    const confirmAction =
        document.getElementById("confirmAction");
    const confirmationBackdrop =
        confirmationModal?.querySelector(".confirmation-backdrop");

    let azioneConfermata = null;
    let ultimoElementoAttivo = null;

    inizializzaProdotti();
    aggiornaCarrello();

    clearCartButton?.addEventListener("click", () => {
        const prodotti = document.querySelectorAll("[data-cart-item]");

        if (prodotti.length === 0) {
            return;
        }

        apriPopup({
            titolo: "Svuota il carrello",
            messaggio:
                "Vuoi davvero rimuovere tutti i prodotti dal carrello? Questa operazione non può essere annullata.",
            testoConferma: "Svuota carrello",
            azione: svuotaCarrello
        });
    });

    cancelConfirmation?.addEventListener("click", chiudiPopup);
    confirmationBackdrop?.addEventListener("click", chiudiPopup);

    confirmAction?.addEventListener("click", () => {
        if (typeof azioneConfermata === "function") {
            azioneConfermata();
        }

        chiudiPopup();
    });

    document.addEventListener("keydown", event => {
        if (
            event.key === "Escape" &&
            confirmationModal &&
            !confirmationModal.classList.contains("hidden")
        ) {
            chiudiPopup();
        }
    });

    function inizializzaProdotti() {
        const prodotti = document.querySelectorAll("[data-cart-item]");

        prodotti.forEach(prodotto => {
            const decreaseButton =
                prodotto.querySelector(".decrease-button");

            const increaseButton =
                prodotto.querySelector(".increase-button");

            const quantityInput =
                prodotto.querySelector(".quantity-input");

            const removeButton =
                prodotto.querySelector(".remove-item-button");

            decreaseButton?.addEventListener("click", () => {
                modificaQuantita(prodotto, -1);
            });

            increaseButton?.addEventListener("click", () => {
                modificaQuantita(prodotto, 1);
            });

            quantityInput?.addEventListener("input", () => {
                normalizzaQuantita(quantityInput);
                aggiornaSubtotaleProdotto(prodotto);
                aggiornaCarrello();
            });

            quantityInput?.addEventListener("blur", () => {
                normalizzaQuantita(quantityInput);
                aggiornaSubtotaleProdotto(prodotto);
                aggiornaCarrello();
            });

            removeButton?.addEventListener("click", () => {
                const nomeProdotto =
                    prodotto
                        .querySelector(".cart-item-name")
                        ?.textContent
                        .trim() || "questo prodotto";

                apriPopup({
                    titolo: "Rimuovi prodotto",
                    messaggio:
                        `Vuoi davvero rimuovere “${nomeProdotto}” dal carrello?`,
                    testoConferma: "Rimuovi",
                    azione: () => rimuoviProdotto(prodotto)
                });
            });

            aggiornaSubtotaleProdotto(prodotto);
        });
    }

    function modificaQuantita(prodotto, variazione) {
        const input = prodotto.querySelector(".quantity-input");

        if (!input) {
            return;
        }

        const minimo = Number(input.min) || 1;
        const massimo = Number(input.max) || 99;
        const quantitaAttuale = Number(input.value) || minimo;

        input.value = Math.min(
            massimo,
            Math.max(minimo, quantitaAttuale + variazione)
        );

        aggiornaSubtotaleProdotto(prodotto);
        aggiornaCarrello();
    }

    function normalizzaQuantita(input) {
        const minimo = Number(input.min) || 1;
        const massimo = Number(input.max) || 99;

        let quantita = parseInt(input.value, 10);

        if (Number.isNaN(quantita)) {
            quantita = minimo;
        }

        input.value = Math.min(
            massimo,
            Math.max(minimo, quantita)
        );
    }

    function aggiornaSubtotaleProdotto(prodotto) {
        const prezzo = Number(prodotto.dataset.price) || 0;

        const input =
            prodotto.querySelector(".quantity-input");

        const subtotalValue =
            prodotto.querySelector(".subtotal-value");

        if (!input || !subtotalValue) {
            return;
        }

        const quantita = Number(input.value) || 1;

        subtotalValue.textContent =
            formattaPrezzo(prezzo * quantita);
    }

    function aggiornaCarrello() {
        const prodotti =
            document.querySelectorAll("[data-cart-item]");

        let numeroArticoli = 0;
        let prezzoTotale = 0;

        prodotti.forEach(prodotto => {
            const prezzo =
                Number(prodotto.dataset.price) || 0;

            const input =
                prodotto.querySelector(".quantity-input");

            const quantita =
                Number(input?.value) || 1;

            numeroArticoli += quantita;
            prezzoTotale += prezzo * quantita;
        });

        if (cartTotalItems) {
            cartTotalItems.textContent = numeroArticoli;
        }

        if (cartSubtotal) {
            cartSubtotal.textContent =
                formattaPrezzo(prezzoTotale);
        }

        if (cartTotal) {
            cartTotal.textContent =
                formattaPrezzo(prezzoTotale);
        }

        const carrelloVuoto = prodotti.length === 0;

        /*Devo capire
        cartItemsContainer?.classList.toggle(
            "hidden",
            carrelloVuoto
        );
        */

        emptyCart?.classList.toggle(
            "hidden",
            !carrelloVuoto
        );

        cartSummary?.classList.toggle(
            "hidden",
            carrelloVuoto
        );
    }

    function rimuoviProdotto(prodotto) {
        prodotto.classList.add("cart-item-removing");

        window.setTimeout(() => {
            prodotto.remove();
            aggiornaCarrello();
        }, 300);
    }

    function svuotaCarrello() {
        const prodotti =
            document.querySelectorAll("[data-cart-item]");

        prodotti.forEach(prodotto => {
            prodotto.classList.add("cart-item-removing");
        });

        window.setTimeout(() => {
            prodotti.forEach(prodotto => prodotto.remove());
            aggiornaCarrello();
        }, 300);
    }

    function apriPopup({
                           titolo,
                           messaggio,
                           testoConferma,
                           azione
                       }) {
        if (!confirmationModal) {
            return;
        }

        ultimoElementoAttivo = document.activeElement;
        azioneConfermata = azione;

        if (confirmationTitle) {
            confirmationTitle.textContent = titolo;
        }

        if (confirmationMessage) {
            confirmationMessage.textContent = messaggio;
        }

        if (confirmAction) {
            confirmAction.textContent = testoConferma;
        }

        confirmationModal.classList.remove("hidden");
        document.body.classList.add("modal-open");

        window.requestAnimationFrame(() => {
            confirmationModal.classList.add("visible");
            confirmAction?.focus();
        });
    }

    function chiudiPopup() {
        if (!confirmationModal) {
            return;
        }

        confirmationModal.classList.remove("visible");

        window.setTimeout(() => {
            confirmationModal.classList.add("hidden");
            document.body.classList.remove("modal-open");

            azioneConfermata = null;

            if (
                ultimoElementoAttivo &&
                typeof ultimoElementoAttivo.focus === "function"
            ) {
                ultimoElementoAttivo.focus();
            }
        }, 200);
    }

    function formattaPrezzo(prezzo) {
        return new Intl.NumberFormat("it-IT", {
            style: "currency",
            currency: "EUR"
        }).format(prezzo);
    }
});