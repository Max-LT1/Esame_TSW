<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List"%>
<%@ page import="model.Prodotto"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>La Forgia Celeste</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="./styles/style.css">
    <link rel="stylesheet" href="./styles/style-home.css">
    <link rel="stylesheet" href="styles/search-bar.css">
</head>
<body>

<jsp:include page="nav-bar.jsp" />

<main class="content">
    <section class="group">
        <h2>Novità</h2>

        <div class="carousel-container">
            <button class="arrow left">&#9664;</button>
            <div class="carousel" id="carousel1">
                <%
                    String contextPath = request.getContextPath();
                    List<Prodotto> prodottiNuovi = (List<Prodotto>) request.getAttribute("NuoviProdotti");
                %>
                <%
                    if (prodottiNuovi == null || prodottiNuovi.isEmpty()) {
                %>
                <p>Nessun prodotto disponibile</p>
                <%
                } else {
                %>
                <%
                    for (Prodotto prodotto : prodottiNuovi) {
                %>
                <a href="<%= contextPath %>/SingleItem?id=<%= prodotto.getIdProdotto()%>">
                    <div class="product tall skew" >
                        <div class="product-name">
                            <%= prodotto.getNomeProdotto()%>
                        </div>
                        <div class="product-price">
                            <%= prodotto.getPrezzo()%>>
                        </div>
                    </div>
                </a>
                <%      }
                    }%>
            </div>

            <button class="arrow right">&#9654;</button>
        </div>
    </section>

    <section class="group">
        <h2>Sconti</h2>
        <div class="carousel-container">
            <button class="arrow left">&#9664;</button>
            <div class="carousel" id="carousel2">
                <%
                    List<Prodotto> prodottiScontati = (List<Prodotto>) request.getAttribute("ListaSconti");
                %>
                <%
                    if (prodottiScontati == null || prodottiScontati.isEmpty()) {
                %>
                <p>Nessun prodotto disponibile</p>
                <%
                } else {
                %>
                <%
                    for (Prodotto prodotto : prodottiScontati) {
                %>
                <a href="<%= contextPath %>/SingleItem?id=<%= prodotto.getIdProdotto()%>">
                    <div class="product tall skew">
                        <div class="product-name">
                            <%= prodotto.getNomeProdotto()%>
                        </div>
                        <div class="product-prezzo">
                            <%= prodotto.getPrezzo()%>
                        </div>
                    </div>
                </a>
                <% }
                    }%>
            </div>
            <button class="arrow right">&#9654;</button>
        </div>
    </section>

</main>
<footer class="footer">
    <p>© Forgia Medievale</p>
</footer>

<!-- CAROSELLO -->
<script src="scripts/carosello.js"></script>

</body>
</html>
