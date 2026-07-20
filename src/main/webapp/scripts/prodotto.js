"use strict";

document.addEventListener("DOMContentLoaded", () => {
    const body = document.body;
    const contextPath = body.dataset.contextPath || "";
    const idProdotto = Number.parseInt(body.dataset.productId, 10);
    const quantityInput = document.getElementById("productQuantity");
    const decreaseButton = document.getElementById("decreaseQuantity");
    const increaseButton = document.getElementById("increaseQuantity");
    const addToCartButton = document.getElementById("addToCartButton");
    const productMessage = document.getElementById("productMessage");
    const endpointAggiunta = `${contextPath}/AggiungiCarrello`;
    const endpointAggiornamento = `${contextPath}/AggiornaCarrello`;
    const endpointCarrello = `${contextPath}/carrelloServ?format=json`;
    if (!quantityInput || !addToCartButton) {console.error("Input quantità o pulsante di aggiunta non trovato.");
        return;
    }

    if (!Number.isInteger(idProdotto) || idProdotto <= 0) {
        mostraMessaggio("ID del prodotto non valido.", true);
        addToCartButton.disabled = true;
        return;
    }
    caricaCarrelloDallaSessione();
    decreaseButton?.addEventListener("click", () => {
        const quantita = normalizzaQuantita(quantityInput.value);
        quantityInput.value = Math.max(1, quantita - 1);
    });

    increaseButton?.addEventListener("click", () => {
        const quantita = normalizzaQuantita(quantityInput.value);
        quantityInput.value = Math.min(99, quantita + 1);
    });

    quantityInput.addEventListener("change", normalizzaInput);
    quantityInput.addEventListener("blur", normalizzaInput);
    addToCartButton.addEventListener("click", aggiungiProdotto);

    async function caricaCarrelloDallaSessione() {
        try {
            const response = await fetch(
                endpointCarrello,
                {
                    method: "POST",
                    headers: {
                        "Accept": "application/json"
                    },
                    credentials: "same-origin",
                    cache: "no-store"
                }
            );

            const carrello = await leggiRispostaJson(response);

            if (carrello.success !== true) {
                throw new Error(carrello.message || "Errore nel caricamento del carrello.");
            }

            aggiornaInterfacciaCarrello(carrello);

            return carrello;

        } catch (errore) {
            console.error("Errore caricamento carrello:", errore);
            return null;
        }
    }

    async function aggiungiProdotto() {
        const quantita = normalizzaQuantita(quantityInput.value);
        quantityInput.value = quantita;

        const isPresent = addToCartButton.dataset.inCart ==="true";
        impostaCaricamento(true);
        mostraMessaggio("");

        try {
            let risposta;
            if(isPresent){
                risposta = await inviaJson(endpointAggiornamento, {prodottoId: idProdotto, quantita: quantita});
            }else{
                risposta = await inviaJson(endpointAggiunta, {idProdotto: idProdotto, quantita: quantita});
            }
            if(risposta.success !== true){
                throw new Error(risposta.message);
            }
            const carrello = await caricaCarrelloDallaSessione();

            if(isPresent){
                mostraMessaggio("Carrello Aggiornato", false);
            }else{
                mostraMessaggio( "Aggiunto al carrello", false);
            }
            if(carrello){
                impostaQuantitaProdottoCorrente(carrello);
            }
        }catch (errore){
            console.error("Errore nel carrello: ", errore);
            mostraMessaggio(errore.message || "Impossibile completare l'operazione.", true);
        } finally {
            impostaCaricamento(false);
        }
    }

    async function aggiornaQuantitaCarrello(idProdotto, quantita
    ) {
        const quantitaNormalizzata = normalizzaQuantita(quantita);
        const risposta = await inviaJson(endpointAggiornamento,
            {
                prodottoId: idProdotto,
                quantita: quantitaNormalizzata
            }
        );

        if (risposta.success !== true) {
            throw new Error(risposta.message || "Impossibile aggiornare la quantità.");
        }

        return caricaCarrelloDallaSessione();
    }

    async function inviaJson(endpoint, dati) {
        const response = await fetch(endpoint,
            {
                method: "POST",
                headers: {
                    "Content-Type": "application/json;charset=UTF-8",
                    "Accept": "application/json"
                },
                credentials:
                    "same-origin",
                body:
                    JSON.stringify(dati)
            }
        );

        return leggiRispostaJson(response);
    }

    async function leggiRispostaJson(response) {
        const contentType = response.headers.get("content-type") || "";
        if (!contentType.includes("application/json")) {
            const testo = await response.text();
            throw new Error(`La servlet non ha restituito JSON ` + `(HTTP ${response.status}): ` + testo.substring(0, 160));
        }

        const json = await response.json();
        if (!response.ok) {
            throw new Error(json.message || json.error || `Errore HTTP ${response.status}`);
        }
        return json;
    }

    function aggiornaInterfacciaCarrello(carrello) {
        aggiornaContatoreCarrello(carrello.numeroArticoli);
        aggiornaTotaleCarrello(carrello.prezzoTotale);
        impostaQuantitaProdottoCorrente(carrello);
    }

    function impostaQuantitaProdottoCorrente(carrello) {
        const articoli = Array.isArray(carrello.articoli) ? carrello.articoli : [];
        const articoloCorrente = articoli.find(articolo => Number(articolo.idProdotto) === idProdotto);

        if (articoloCorrente) {
            quantityInput.value = normalizzaQuantita(articoloCorrente.quantita);
            addToCartButton.textContent = "Aggiorna nel carrello";
            addToCartButton.dataset.inCart = "true";
        } else {
            quantityInput.value = normalizzaQuantita(quantityInput.value);
            addToCartButton.textContent = "Aggiungi al carrello";
            addToCartButton.dataset.inCart = "false";
        }
    }

    function aggiornaContatoreCarrello(numeroArticoli) {
        const contatori = document.querySelectorAll("#cartCounter, [data-cart-counter]");
        contatori.forEach(contatore => {
                contatore.textContent = Number(numeroArticoli) || 0;
            }
        );
    }

    function aggiornaTotaleCarrello(
        prezzoTotale
    ) {
        const elementiTotale = document.querySelectorAll("#cartTotalNavbar, [data-cart-total]");
        const totaleFormattato = new Intl.NumberFormat("it-IT", {
                style: "currency",
                currency: "EUR"
            }
        ).format(Number(prezzoTotale) || 0);
        elementiTotale.forEach(elemento => {
                elemento.textContent = totaleFormattato;
            }
        );
    }

    function normalizzaInput() {
        quantityInput.value = normalizzaQuantita(quantityInput.value);
    }

    function normalizzaQuantita(valore) {
        const numero = Number.parseInt(valore, 10);

        if (Number.isNaN(numero)) {
            return 1;
        }

        return Math.min(99, Math.max(1, numero));
    }

    function impostaCaricamento(caricamento) {
        addToCartButton.disabled = caricamento;

        if (caricamento) {
            addToCartButton.textContent = "Operazione in corso...";
            return;
        }

        const presente = addToCartButton.dataset.inCart === "true";

        addToCartButton.textContent = presente ? "Aggiorna nel carrello" : "Aggiungi al carrello";
    }

    function mostraMessaggio(messaggio, errore = false) {
        if (!productMessage) {
            if (messaggio) {
                alert(messaggio);
            }
            return;
        }

        productMessage.textContent = messaggio;
        productMessage.classList.toggle("error", errore);
        productMessage.classList.toggle("success", Boolean(messaggio) && !errore);
    }

    window.caricaCarrelloDallaSessione = caricaCarrelloDallaSessione;
    window.aggiornaQuantitaCarrello = aggiornaQuantitaCarrello;
});