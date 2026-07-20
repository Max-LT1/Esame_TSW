<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="model.Prodotto" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.DecimalFormatSymbols" %>
<%@ page import="java.util.Locale" %>

<%!
    private String escapeHtml(String valore) {
        if (valore == null) {
            return "";
        }

        return valore
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
    private String normalizzaPercorso(String percorso) {
        if (percorso == null) {
            return "";
        }

        percorso = percorso.trim();

        while (percorso.startsWith("/")) {
            percorso = percorso.substring(1);
        }

        return percorso;
    }
%>

<%
    String contextPath = request.getContextPath();

    Prodotto prodotto =
            (Prodotto) request.getAttribute("prodotto");

    BigDecimal prezzoOriginale =
            (BigDecimal) request.getAttribute(
                    "prezzoOriginale"
            );

    BigDecimal prezzoFinale =
            (BigDecimal) request.getAttribute(
                    "prezzoFinale"
            );

    Integer valoreSconto =
            (Integer) request.getAttribute("sconto");

    int sconto = valoreSconto != null ? valoreSconto : 0;

    if (prodotto == null) {
        response.sendError(
                HttpServletResponse.SC_NOT_FOUND,
                "Prodotto non disponibile"
        );

        return;
    }

    if (prezzoOriginale == null) {
        prezzoOriginale = prodotto.getPrezzo() != null ? prodotto.getPrezzo() : BigDecimal.ZERO;
    }

    if (prezzoFinale == null) {
        prezzoFinale = prezzoOriginale;
    }

    DecimalFormatSymbols simboli =
            new DecimalFormatSymbols(Locale.ITALY);

    simboli.setCurrencySymbol("€");

    DecimalFormat formatoPrezzo =
            new DecimalFormat("#,##0.00 ¤", simboli);

    String nomeProdotto = escapeHtml(prodotto.getNomeProdotto());

    String descrizione = prodotto.getDescrizione() != null && !prodotto.getDescrizione().isBlank() ? escapeHtml(prodotto.getDescrizione()) : "Nessuna descrizione disponibile.";

    String categoria = escapeHtml(prodotto.getCategoria());

    String materiale = escapeHtml(prodotto.getMateriale());

    String tipo = escapeHtml(prodotto.getTipo());

    String percorsoImmagine = normalizzaPercorso(prodotto.getPath_immagine());

    String urlImmagine;

    if (percorsoImmagine.isBlank()) {
        urlImmagine = contextPath + "/images/placeholder.png";
    } else {
        urlImmagine = contextPath + "/" + percorsoImmagine;
    }
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= nomeProdotto %></title>
    <link rel="stylesheet" href="<%= contextPath %>/styles/style.css">
    <link rel="stylesheet" href="<%= contextPath %>/styles/product.css">
    <link rel="stylesheet" href="<%= contextPath %>/styles/search-bar.css">
</head>

<body data-context-path="<%= contextPath %>" data-product-id="<%= prodotto.getIdProdotto() %>">

<jsp:include page="nav-bar.jsp" />

<main class="product-page">
    <section class="product-detail">

        <!-- Colonna sinistra -->
        <div class="product-image-section">
            <img
                    class="product-image"
                    src="<%= urlImmagine %>"
                    alt="<%= nomeProdotto %>"
            >
        </div>

        <!-- Colonna destra -->
        <div class="product-information">

            <% if (!categoria.isBlank()) { %>
            <p class="product-category">
                <%= categoria %>
            </p>
            <% } %>

            <h1 class="product-name">
                <%= nomeProdotto %>
            </h1>

            <div class="product-price-container">

                <% if (sconto > 0) { %>

                <span class="original-price">
                            <%= formatoPrezzo.format(
                                    prezzoOriginale
                            ) %>
                        </span>

                <span class="discounted-price">
                            <%= formatoPrezzo.format(
                                    prezzoFinale
                            ) %>
                        </span>

                <span class="discount-badge">
                            -<%= sconto %>%
                        </span>

                <% } else { %>

                <span class="regular-price">
                            <%= formatoPrezzo.format(
                                    prezzoFinale
                            ) %>
                        </span>

                <% } %>

            </div>

            <div class="product-description">
                <h2>Descrizione</h2>

                <p>
                    <%= descrizione %>
                </p>
            </div>

            <% if (!materiale.isBlank()) { %>
            <div class="product-property">
                        <span class="property-label">
                            Materiale:
                        </span>

                <span>
                            <%= materiale %>
                        </span>
            </div>
            <% } %>

            <% if (!tipo.isBlank()) { %>
            <div class="product-property">
                        <span class="property-label">
                            Tipo:
                        </span>

                <span>
                            <%= tipo %>
                        </span>
            </div>
            <% } %>

            <div class="product-purchase-section">
                <label
                        class="quantity-label"
                        for="productQuantity"
                >
                    Quantità
                </label>

                <div class="quantity-selector">
                    <button
                            id="decreaseQuantity"
                            class="quantity-button"
                            type="button"
                            aria-label="Diminuisci quantità"
                    >
                        −
                    </button>

                    <input
                            id="productQuantity"
                            class="quantity-input"
                            type="number"
                            value="1"
                            min="1"
                            max="99"
                            inputmode="numeric"
                            aria-label="Quantità da acquistare"
                    >

                    <button
                            id="increaseQuantity"
                            class="quantity-button"
                            type="button"
                            aria-label="Aumenta quantità"
                    >
                        +
                    </button>
                </div>

                <button id="addToCartButton" class="add-to-cart-button" type="button">Aggiungi al carrello</button>
                <p
                        id="productMessage"
                        class="product-message"
                        role="status"
                        aria-live="polite"
                ></p>
            </div>
        </div>
    </section>
</main>

<script src="<%=contextPath%>/scripts/prodotto.js" defer></script>

</body>
</html>