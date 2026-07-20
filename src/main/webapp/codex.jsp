<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="model.Prodotto" %>

<%!
    private String escapeHtml(Object value) {
        if (value == null) {
            return "";
        }

        return String.valueOf(value)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
    private String encodeUrl(String value) {
        if (value == null) {
            return "";
        }

        try {
            return java.net.URLEncoder.encode(
                    value,
                    java.nio.charset.StandardCharsets.UTF_8
            );
        } catch (Exception exception) {
            return "";
        }
    }
%>

<%
    String contextPath = request.getContextPath();

    String categoria = (String) request.getAttribute("Categoria");

    @SuppressWarnings("unchecked")
    List<Prodotto> prodotti =
            (List<Prodotto>) request.getAttribute("Lista");

    @SuppressWarnings("unchecked")
    Set<String> tipi = (Set<String>) request.getAttribute("Tipi");

    if (prodotti != null) {
        for (Prodotto prodotto : prodotti) {
            if (
                    prodotto != null &&
                            prodotto.getTipo() != null &&
                            !prodotto.getTipo().trim().isEmpty() &&
                            !tipi.contains(prodotto.getTipo())
            ) {
                tipi.add(prodotto.getTipo().trim());
            }
        }
    }

    String titoloCategoria =
            categoria == null || categoria.trim().isEmpty()
                    ? "Tutti i prodotti"
                    : categoria;

    NumberFormat formatoPrezzo =
            NumberFormat.getCurrencyInstance(Locale.ITALY);
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Codex - La Forgia Celeste</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= contextPath %>/styles/style.css">
    <link rel="stylesheet" href="<%= contextPath %>/styles/search-bar.css">
    <link rel="stylesheet" href="<%= contextPath %>/styles/codex.css">
</head>
<body>

<jsp:include page="nav-bar.jsp" />

<main class="codex-page">
    <header class="codex-heading">
        <div>
                <span class="codex-eyebrow">
                    Archivio della Forgia
                </span>
            <h1>
                <%= escapeHtml(titoloCategoria) %>
            </h1>
        </div>
        <p id="result-count" class="result-count" aria-live="polite"></p>
    </header>
    <section class="filter-panel" aria-label="Filtra prodotti per tipo">
            <span class="filter-label">Filtra per tipo</span>
        <div id="type-filters" class="filter-buttons">
            <button type="button" class="filter-button active" data-filter="all">Tutti</button>
            <%
                for (String tipo : tipi) {
            %>
            <button type="button" class="filter-button" data-filter="<%= escapeHtml(tipo) %>"><%= escapeHtml(tipo) %></button>
            <%
                }
            %>
        </div>
    </section>
    <%
        if (prodotti == null || prodotti.isEmpty()) {
    %>
    <section class="empty-codex">
                <span aria-hidden="true">
                    ⚒
                </span>
        <h2>Nessun prodotto trovato</h2>
        <p>Non risultano oggetti disponibili per questa categoria.</p>
    </section>
    <%
    } else {
    %>
    <section id="product-grid" class="product-grid" aria-label="Elenco prodotti">
        <%
            for (Prodotto prodotto : prodotti) {
                if (prodotto == null) {
                    continue;
                }

                String id =
                        String.valueOf(prodotto.getIdProdotto());

                String nome =
                        prodotto.getNomeProdotto() != null
                                ? prodotto.getNomeProdotto()
                                : "Prodotto senza nome";

                String tipo =
                        prodotto.getTipo() != null
                                ? prodotto.getTipo()
                                : "Non specificato";

                String immagine =
                        prodotto.getPath_immagine() != null ? prodotto.getPath_immagine() : "images/placeholder-product.png";

                String prezzoFormattato = formatoPrezzo.format(prodotto.getPrezzo());
        %>
        <article class="codex-product" data-id="<%= escapeHtml(id) %>" data-tipo="<%= escapeHtml(tipo) %>">
            <a class="product-link" href="<%= contextPath %>/SingleItem?id=<%= id %>" aria-label="Apri <%= escapeHtml(nome) %>">
                <div class="product-image-wrapper">
                    <img class="product-image" src="<%= contextPath %>/<%= escapeHtml(immagine) %>" alt="<%= escapeHtml(nome) %>" loading="lazy" onerror="this.onerror=null; this.src='<%= contextPath %>/images/placeholder-product.png';">
                    <span class="price-badge"><%= escapeHtml(prezzoFormattato) %></span>
                </div>
                <div class="product-info">
                    <h2 class="product-title"><%= escapeHtml(nome) %></h2>
                    <span class="product-type"><%= escapeHtml(tipo) %></span>
                </div>
            </a>
        </article>
        <%
            }
        %>
    </section>
    <section id="no-filter-results" class="empty-codex hidden" aria-live="polite">
        <span aria-hidden="true">⌕</span>
        <h2>Nessun oggetto di questo tipo</h2>
        <p>
            Seleziona un altro filtro per visualizzare
            i prodotti disponibili.
        </p>
    </section>
    <%
        }
    %>
</main>

<script src="<%= contextPath %>/scripts/codex.js"></script>

</body>
</html>