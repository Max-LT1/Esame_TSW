<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    // LoginServlet deve salvare lo username nella sessione:
    // session.setAttribute("username", username);
    String username = (String) session.getAttribute("username");
    boolean utenteLoggato = username != null && !username.trim().isEmpty();
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrello</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="styles/style.css">
    <link rel="stylesheet" href="styles/cart.css">
    <link rel="stylesheet" href="styles/search-bar.css">

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function() {

            // Funzione unica per inviare i dati alla Servlet tramite Fetch API
            function aggiornaQuantitaServer(prodottoId, nuovaQuantita, elementoErrore) {
                if (elementoErrore) elementoErrore.textContent = '';

                fetch('AggiornaCarrello', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        quantita: nuovaQuantita,
                        prodottoId: prodottoId
                    })
                })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Errore nel salvataggio');
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.success) {
                            // Reindirizza alla servlet che mostra il carrello aggiornato
                            window.location.href = 'cart.jsp';
                        } else {
                            if (elementoErrore) elementoErrore.textContent = data.message;
                        }
                    })
                    .catch(error => {
                        console.error('Errore:', error);
                        if (elementoErrore) elementoErrore.textContent = 'Errore durante l\'aggiornamento del carrello.';
                    });
            }

            // 1. Gestione della modifica manuale dell'input numerico
            document.querySelectorAll('.quantity-input').forEach(input => {
                input.addEventListener('change', function() {
                    var articolo = this.closest('.cart-item');
                    var prodottoId = articolo.getAttribute('data-product-id');
                    var quantita = parseInt(this.value);
                    var errorText = articolo.querySelector('.error-text');

                    if (isNaN(quantita) || quantita < 1 || quantita > 10) {
                        if (errorText) errorText.textContent = 'La quantità deve essere maggiore di 1 e minore di 11.';
                        this.value = 1; // Reset di sicurezza
                        return;
                    }

                    aggiornaQuantitaServer(prodottoId, quantita, errorText);
                });
            });

            // 2. Gestione del click sul bottone Aumenta (+)
            document.querySelectorAll('.increase-button').forEach(button => {
                button.addEventListener('click', function() {
                    var articolo = this.closest('.cart-item');
                    var prodottoId = articolo.getAttribute('data-product-id');
                    var input = articolo.querySelector('.quantity-input');
                    var errorText = articolo.querySelector('.error-text');
                    var attuale = parseInt(input.value);

                    if (attuale < 10) {
                        aggiornaQuantitaServer(prodottoId, nuovaQuantita, errorText);
                    } else {
                        if (errorText) errorText.textContent = 'Massimo 10 articoli consentiti.';
                    }
                });
            });

            // 3. Gestione del click sul bottone Diminuisci (-)
            document.querySelectorAll('.decrease-button').forEach(button => {
                button.addEventListener('click', function() {
                    var articolo = this.closest('.cart-item');
                    var prodottoId = articolo.getAttribute('data-product-id');
                    var input = articolo.querySelector('.quantity-input');
                    var errorText = articolo.querySelector('.error-text');
                    var attuale = parseInt(input.value);

                    if (attuale > 1) {
                        aggiornaQuantitaServer(prodottoId, nuovaQuantita, errorText);
                    } else {
                        if (errorText) errorText.textContent = 'La quantità minima è 1.';
                    }
                });
            });
        });
    </script>

</head>

<div id="confirmationModal" class="confirmation-modal hidden" role="dialog" aria-modal="true" aria-labelledby="confirmationTitle">
    <div class="confirmation-backdrop"></div>
    <div class="confirmation-card">
        <h2 id="confirmationTitle">
            Conferma operazione
        </h2>
        <p id="confirmationMessage">
            Vuoi davvero continuare?
        </p>
        <div class="confirmation-actions">
            <button id="cancelConfirmation" class="secondary-button" type="button">Annulla</button>
            <button id="confirmAction" class="primary-button danger-button" type="button">Conferma</button>
        </div>
    </div>
</div>

<body>
<header class="navbar">
    <form class="navbar-search" action="search.jsp" method="get">
        <input class="searchbar" type="search" name="query" placeholder="Cerca nel Codex..." aria-label="Cerca prodotti">
        <button class="search-button" type="submit" aria-label="Avvia ricerca">Cerca</button>
    </form>
    <nav class="nav-links">
        <a href="index.jsp" class="navbar-logo">Home</a>
        <a href="codex.jsp?tipo=armi">Armi</a>
        <a href="codex.jsp?tipo=armature">Armature</a>
        <a href="codex.jsp?tipo=scudi">Scudi</a>
        <a href="codex.jsp?tipo=accessori">Accessori</a>
        <a href="contacts.jsp">Contatti</a>
    </nav>
    <div class="user-area">
        <span class="icon-user" id="user-icon">👤</span>
        <a href="cart.jsp" class="navbar-icon cart-link" aria-label="Apri il carrello">
            <span class="icon-cart" id="cart-icon">🛒</span>
        </a>
    </div>
</header>

<!-- OVERLAY UTENTE -->
<div id="user-overlay" class="overlay hidden" role="dialog" aria-label="Area utente">
    <div class="overlay-content">
        <h3>Profilo</h3>
        <button type="button" class="overlay-close" data-close-overlay aria-label="Chiudi">&times;</button>
    </div>
    <% if (utenteLoggato) { %>
    <div class="user-summary">
        <div class="user-avatar" aria-hidden="true">👤</div>
        <div>
            <span class="overlay-label">Bentornato</span>
            <strong class="user-name"><%= username %></strong>
        </div>
    </div>
    <div class="overlay-actions">
        <a class="overlay-button primary" href="user-area.jsp">Visualizza profilo</a>
        <form action="logoutServ" method="post">
            <button type="submit" class="overlay-button danger">Logout</button>
        </form>
    </div>
    <% } else { %>
    <p class="overlay-message">Accedi al tuo account oppure crea un nuovo profilo.</p>
    <a class="overlay-button primary full-width" href="log-sign.jsp">Accedi / Registrati</a>
    <% } %>
</div>

<main class="cart-page">
    <section class="cart-card">
        <div class="cart-header">
            <div>
                <p class="section-label">Il tuo equipaggiamento</p>
                <h1>Carrello</h1>
            </div>
            <p class="cart-counter">
                <span id="cartTotalItems">3</span> articoli
            </p>
        </div>

        <div id="cartItems" class="cart-items">
            <article class="cart-item" data-cart-item data-product-id="1" data-price="49.90">
                <a href="product.jsp?id=1" class="cart-item-image-link">
                    <!-- manca immagine-->
                    <img class="cart-item-image" src="" alt="Spada lunga del cavaliere">
                </a>
                <div class="cart-item-info">
                    <!-- DINAMICO -->
                    <a href="product.jsp?id=1" class="cart-item-name">
                        <h3>Spada lunga del cavaliere</h3>
                    </a>
                    <!-- DINAMICO -->
                    <p class="cart-item-description">
                        Spada a una mano con lama rinforzata e
                        impugnatura rivestita in cuoio.
                    </p>
                </div>
                <div class="cart-item-price">
                    <span class="price-label">
                        Prezzo
                    </span>
                    <!-- DINAMICO -->
                    <span class="unit-price">
                        € 49,90
                    </span>
                </div>
                <div class="cart-item-quantity">
                    <span class="quantity-label">
                        Quantità
                    </span>
                    <!-- DINAMICO -->
                    <div class="quantity-selector">
                        <button class="quantity-button decrease-button" type="button" aria-label="Diminuisci quantità">−</button>
                        <input class="quantity-input" type="number" value="1" min="1" aria-label="Quantità del prodotto">
                        <button class="quantity-button increase-button" type="button" aria-label="Aumenta quantità">+</button>
                    </div>
                </div>
                <div class="cart-item-subtotal">
                    <span class="subtotal-label">Totale</span>
                    <!-- DINAMICO -->
                    <span class="subtotal-value">€ 49,90</span>
                </div>
                <button class="remove-item-button" type="button" aria-label="Rimuovi Spada lunga del cavaliere">Rimuovi</button>
            </article>
            <article class="cart-item" data-cart-item data-product-id="1" data-price="49.90">
                <a href="product.jsp?id=1" class="cart-item-image-link">
                    <!-- manca immagine-->
                    <img class="cart-item-image" src="" alt="Spada lunga del cavaliere">
                </a>
                <div class="cart-item-info">
                    <!-- DINAMICO -->
                    <a href="product.jsp?id=1" class="cart-item-name">
                        <h3>Spada lunga del cavaliere</h3>
                    </a>
                    <!-- DINAMICO -->
                    <p class="cart-item-description">
                        Spada a una mano con lama rinforzata e
                        impugnatura rivestita in cuoio.
                    </p>
                </div>
                <div class="cart-item-price">
                    <span class="price-label">
                        Prezzo
                    </span>
                    <!-- DINAMICO -->
                    <span class="unit-price">
                        € 49,90
                    </span>
                </div>
                <div class="cart-item-quantity">
                    <span class="quantity-label">
                        Quantità
                    </span>
                    <!-- DINAMICO -->
                    <div class="quantity-selector">
                        <button class="quantity-button decrease-button" type="button" aria-label="Diminuisci quantità">−</button>
                        <input class="quantity-input" type="number" value="1" min="1" aria-label="Quantità del prodotto">
                        <button class="quantity-button increase-button" type="button" aria-label="Aumenta quantità">+</button>
                    </div>
                </div>
                <div class="cart-item-subtotal">
                    <span class="subtotal-label">Totale</span>
                    <!-- DINAMICO -->
                    <span class="subtotal-value">€ 49,90</span>
                </div>
                <button class="remove-item-button" type="button" aria-label="Rimuovi Spada lunga del cavaliere">Rimuovi</button>
            </article>
            <article class="cart-item" data-cart-item data-product-id="1" data-price="49.90">
                <a href="product.jsp?id=1" class="cart-item-image-link">
                    <!-- manca immagine-->
                    <img class="cart-item-image" src="" alt="Spada lunga del cavaliere">
                </a>
                <div class="cart-item-info">
                    <!-- DINAMICO -->
                    <a href="product.jsp?id=1" class="cart-item-name">
                        <h3>Spada lunga del cavaliere</h3>
                    </a>
                    <!-- DINAMICO -->
                    <p class="cart-item-description">
                        Spada a una mano con lama rinforzata e
                        impugnatura rivestita in cuoio.
                    </p>
                </div>
                <div class="cart-item-price">
                    <span class="price-label">
                        Prezzo
                    </span>
                    <!-- DINAMICO -->
                    <span class="unit-price">
                        € 49,90
                    </span>
                </div>
                <div class="cart-item-quantity">
                    <span class="quantity-label">
                        Quantità
                    </span>
                    <!-- DINAMICO -->
                    <div class="quantity-selector">
                        <button class="quantity-button decrease-button" type="button" aria-label="Diminuisci quantità">−</button>
                        <input class="quantity-input" type="number" value="1" min="1" aria-label="Quantità del prodotto">
                        <button class="quantity-button increase-button" type="button" aria-label="Aumenta quantità">+</button>
                    </div>
                </div>
                <div class="cart-item-subtotal">
                    <span class="subtotal-label">Totale</span>
                    <!-- DINAMICO -->
                    <span class="subtotal-value">€ 49,90</span>
                </div>
                <button class="remove-item-button" type="button" aria-label="Rimuovi Spada lunga del cavaliere">Rimuovi</button>
            </article>
        </div>
        <div id="emptyCart" class="empty-cart hidden">
            <div class="empty-cart-icon">◇</div>
            <h2>Il tuo carrello è vuoto</h2>
            <p>
                Esplora la forgia e aggiungi nuovi oggetti
                al tuo equipaggiamento.
            </p>
            <a href="index.jsp" class="primary-button">Torna alla Home</a>
        </div>
        <div id="cartSummary" class="cart-summary">
            <div class="summary-information">
                <div class="summary-row">
                    <span>
                        Subtotale
                    </span>
                    <!-- DINAMICO -->
                    <span id="cartSubtotal">
                        € 149,70
                    </span>
                </div>
                <div class="summary-row">
                    <span>
                        Spedizione
                    </span>
                    <span>
                        Calcolata al checkout
                    </span>
                </div>
                <div class="summary-row summary-total">
                    <span>
                        Totale
                    </span>
                    <!-- DINAMICO -->
                    <span id="cartTotal">

                    </span>
                </div>
            </div>
            <div class="cart-actions">
                <button id="clearCartButton" class="secondary-button danger-button" type="button">
                    Svuota carrello
                </button>
                <!-- manca link checkout-->
                <a href="" class="primary-button checkout-button">
                    Passa al checkout
                </a>
            </div>
        </div>
    </section>
</main>

<!-- CARRELLO -->
<script src="scripts/carrello.js"></script>
<!-- OVERLAY UTENTE -->
<script src="scripts/user-overlay.js"></script>

</body>
</html>