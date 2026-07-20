<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <title>La Forgia Celeste</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="./styles/style.css">
    <link rel="stylesheet" href="./styles/style-home.css">
    <link rel="stylesheet" href="styles/search-bar.css">
</head>
<body>
<header class="navbar">
    <form class="navbar-search" action="search.jsp" method="get">
        <input class="searchbar" type="search" name="query" placeholder="Cerca nel Codex..." aria-label="Cerca prodotti">
        <button class="search-button" type="submit" aria-label="Avvia ricerca">Cerca</button>
    </form>
    <nav class="nav-links">
        <a href="index.jsp" class="navbar-logo">Home</a>
        <a href="ContextCheck?categoria=armi">Armi</a>
        <a href="ContextCheck?categoria=armature">Armature</a>
        <a href="ContextCheck?categoria=scudi">Scudi</a>
        <a href="ContextCheck?categoria=accessori">Accessori</a>
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
        <form action="LogoutServlet" method="post">
            <button type="submit" class="overlay-button danger">Logout</button>
        </form>
    </div>
    <% } else { %>
    <p class="overlay-message">Accedi al tuo account oppure crea un nuovo profilo.</p>
    <a class="overlay-button primary full-width" href="log-sign.jsp">Accedi / Registrati</a>
    <% } %>
</div>

<main class="content">
    <section class="group">
        <h2>Novità</h2>
        <div class="carousel-container">
            <button class="arrow left">&#9664;</button>
            <div class="carousel" id="carousel1">
                <div class="product tall skew" >
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
            </div>

            <button class="arrow right">&#9654;</button>
        </div>
    </section>

    <section class="group">
        <h2>Sconti</h2>
        <div class="carousel-container">
            <button class="arrow left">&#9664;</button>
            <div class="carousel" id="carousel2">
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
            </div>

            <button class="arrow right">&#9654;</button>
        </div>
    </section>

    <section class="group">
        <h2>Popolari</h2>
        <div class="carousel-container">
            <button class="arrow left">&#9664;</button>
            <div class="carousel" id="carousel3">
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
                <div class="product tall skew">
                    <div class="product-content">
                        Prodotto 1
                    </div>
                    <div class="product-name">
                        Spada del Drago
                    </div>
                </div>
            </div>
            <button class="arrow right">&#9654;</button>
        </div>
    </section>
</main>
<footer class="footer">
    <p>© Forgia Medievale</p>
</footer>

<!-- OVERLAY UTENTE -->
<script src="scripts/user-overlay.js"></script>

<!-- CAROSELLO -->
<script src="scripts/carosello.js"></script>

<!-- PRODOTTI -->
<script src="scripts/prodotto.js"></script>

</body>
</html>
