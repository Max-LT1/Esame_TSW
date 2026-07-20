<%@ page contentType="text/html; charset=UTF-8" language="java" %>

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

<jsp:include page="nav-bar.jsp" />

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
            <a href="HomePage" class="primary-button">Torna alla Home</a>
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
                        € 149,70
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

</body>
</html>