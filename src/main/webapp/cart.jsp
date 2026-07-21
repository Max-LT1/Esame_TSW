<%@ page import="model.Composizione" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Client" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.JsonArray"%>
<%@ page import="com.google.gson.JsonParser"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="model.Prodotto" %>
<%@ page import="java.math.BigDecimal" %>

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
    <script src="scripts/gestione-carrello.js"></script>
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
            <%
                List<Composizione> composizioni = null;
                Client cliente = (Client)session.getAttribute("cliente");
                if (cliente == null) {
                    composizioni = (List<Composizione>) session.getAttribute("carrelloNoLog");

                } else {
                    composizioni = (List<Composizione>) session.getAttribute("carrello");
                }
            %>
            <div id="emptyCart" class="empty-cart hidden">
                <div class="empty-cart-icon">◇</div>
                <h2>Il tuo carrello è vuoto</h2>
                <p>
                    Esplora la forgia e aggiungi nuovi oggetti
                    al tuo equipaggiamento.
                </p>
                <a href="HomePage" class="primary-button">Torna alla Home</a>
            </div>
            <% if (composizioni != null && !composizioni.isEmpty()) {
                    for (int i = 0; i < composizioni.size(); i++) {
                        JsonArray cartItemsJson = new JsonParser().parse(request.getAttribute("composizioniJson").toString()).getAsJsonArray();
                        Prodotto prodotto = new Gson().fromJson(cartItemsJson.get(i), Prodotto.class);
                        int quantita = composizioni.get(i).getQuantita_prodotto();
                        BigDecimal subtotal = prodotto.getPrezzo().multiply(BigDecimal.valueOf(quantita));
            %>
            <article class="cart-item" data-cart-item data-product-id="<%=prodotto.getIdProdotto()%>" data-price="<%=prodotto.getPrezzo()%>">
                <a href="product.jsp?id=<%=prodotto.getIdProdotto()%>" class="cart-item-image-link">
                    <img class="cart-item-image" src="<%=prodotto.getPath_immagine()%>" alt="<%=prodotto.getNomeProdotto()%>">
                </a>
                <div class="cart-item-info">
                    <a href="product.jsp?id=<%=prodotto.getIdProdotto()%>" class="cart-item-name">
                        <h3><%=prodotto.getNomeProdotto()%></h3>
                    </a>
                    <p class="cart-item-description"><%=prodotto.getDescrizione()%></p>
                </div>
                <div class="cart-item-price">
                    <span class="price-label">Prezzo</span>
                    <span class="unit-price">€<%=prodotto.getPrezzo()%></span>
                </div>
                <div class="cart-item-quantity">
                    <span class="quantity-label">Quantità</span>
                    <div class="quantity-selector">
                        <button class="quantity-button decrease-button" type="button" aria-label="Diminuisci quantità">−</button>
                        <input class="quantity-input" type="number" value="<%=quantita%>" min="1" max="99" aria-label="Quantità del prodotto">
                        <button class="quantity-button increase-button" type="button" aria-label="Aumenta quantità">+</button>
                    </div>
                </div>
                <div class="cart-item-subtotal">
                    <span class="subtotal-label">Totale</span>
                    <span class="subtotal-value">€<%=subtotal%></span>
                </div>
                <button class="remove-item-button" type="button" aria-label="Rimuovi Spada lunga del cavaliere">Rimuovi</button>
            </article>
            <%
                }
            %>
        </div>
        <div id="cartSummary" class="cart-summary">
            <%
                String sessionToken = (String) session.getAttribute("sessionToken");
                BigDecimal prezzoTotale = (BigDecimal) request.getAttribute("prezzoTotale");
            %>
            <div class="summary-information">
                <div class="summary-row">
                    <span>Subtotale</span>
                    <span id="cartSubtotal">€<%=prezzoTotale%></span>
                </div>
                <div class="summary-row">
                    <span>Spedizione</span>
                    <span>Calcolata al checkout</span>
                </div>
                <div class="summary-row summary-total">
                    <span>Totale</span>
                    <span id="cartTotal">€<%=prezzoTotale%></span>
                </div>
            </div>
            <div class="cart-actions">
                <button id="clearCartButton" class="secondary-button danger-button" type="button">Svuota carrello</button>
                <a href="checkout.jsp" class="primary-button checkout-button">Passa al checkout</a>
            </div>
            <%
                }
            %>
        </div>
    </section>
</main>

<!-- CARRELLO -->
<script src="scripts/carrello.js"></script>

</body>
</html>