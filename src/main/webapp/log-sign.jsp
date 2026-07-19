<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Login - Registrazione</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="styles/style.css">
    <link rel="stylesheet" href="styles/search-bar.css">
    <link rel="stylesheet" href="styles/style-log-sign.css">
</head>
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
        <form action="LogoutServlet" method="post">
            <button type="submit" class="overlay-button danger">Logout</button>
        </form>
    </div>
    <% } else { %>
    <p class="overlay-message">Accedi al tuo account oppure crea un nuovo profilo.</p>
    <a class="overlay-button primary full-width" href="log-sign.jsp">Accedi / Registrati</a>
    <% } %>
</div>

<main class="auth-page">
    <div class="container">
        <section id="loginCard" class="card auth-card active-card" aria-labelledby="loginTitle">
            <h2 id="loginTitle">LOGIN</h2>
            <p class="auth-description">
                Accedi al tuo account per continuare.
            </p>
            <!-- LoginServlet-->
            <form id="loginForm" action="loginServ" method="post">
                <div class="input-group">
                    <label for="loginEmail">
                        Email
                    </label>
                    <input
                            id="loginEmail"
                            type="email"
                            name="email"
                            placeholder="Inserisci la tua email"
                            autocomplete="email"
                            required>
                </div>
                <div class="input-group">
                    <label for="loginPassword">
                        Password
                    </label>
                    <input
                            id="loginPassword"
                            type="password"
                            name="password"
                            placeholder="Inserisci la password"
                            autocomplete="current-password"
                            required>
                </div>
                <div class="remember">
                    <input
                            type="checkbox"
                            id="remember"
                            name="remember">
                    <label for="remember">
                        Ricordami
                    </label>
                </div>
                <button type="submit" class="btn">
                    LOGIN
                </button>
            </form>

            <div class="auth-switch">
                <p>Non possiedi ancora un account?</p>
                <button
                        id="showRegisterButton"
                        class="btn switch-button"
                        type="button">
                    Crea un account
                </button>
            </div>
        </section>
        <section
                id="registerCard"
                class="card auth-card hidden-card"
                aria-labelledby="registerTitle"
                aria-hidden="true">
            <h2 id="registerTitle">SIGN UP</h2>
            <p class="auth-description">
                Compila i campi per creare il tuo account.
            </p>
            <!-- RegisterServlet-->
            <form id="registerForm" action="RegistrazioneServ" method="post">
                <div class="row">
                    <div class="input-group">
                        <label for="registerName">
                            Nome
                        </label>
                        <input
                                id="registerName"
                                type="text"
                                name="nome"
                                autocomplete="given-name"
                                required>
                    </div>
                    <div class="input-group">
                        <label for="registerSurname">
                            Cognome
                        </label>
                        <input
                                id="registerSurname"
                                type="text"
                                name="cognome"
                                autocomplete="family-name"
                                required>
                    </div>
                </div>
                <div class="input-group">
                    <label for="registerUsername">
                        Username
                    </label>
                    <input
                            id="registerUsername"
                            type="text"
                            name="username"
                            autocomplete="username"
                            required>
                </div>
                <div class="input-group">
                    <label for="registerEmail">
                        Email
                    </label>
                    <input
                            id="registerEmail"
                            type="email"
                            name="email"
                            autocomplete="email"
                            required>
                </div>
                <div class="row">
                    <div class="input-group">
                        <label for="registerPassword">
                            Password
                        </label>
                        <input
                                id="registerPassword"
                                type="password"
                                name="password"
                                autocomplete="new-password"
                                required>
                    </div>
                    <div class="input-group">
                        <label for="confirmPassword">
                            Conferma password
                        </label>
                        <input
                                id="confirmPassword"
                                type="password"
                                name="confermaPassword"
                                autocomplete="new-password"
                                required>
                    </div>
                </div>
                <div class="input-group">
                    <label for="registerAddress">
                        Indirizzo
                    </label>
                    <input
                            id="registerAddress"
                            type="text"
                            name="indirizzo"
                            autocomplete="street-address"
                            required>
                </div>

                <div class="row">
                    <div class="input-group">
                        <label for="registerCity">
                            Città
                        </label>
                        <input
                                id="registerCity"
                                type="text"
                                name="citta"
                                autocomplete="address-level2"
                                required>
                    </div>
                    <div class="input-group">
                        <label for="registerProvince">
                            Provincia
                        </label>
                        <input
                                id="registerProvince"
                                type="text"
                                name="provincia"
                                maxlength="2"
                                placeholder="RM"
                                autocomplete="address-level1"
                                required>
                    </div>
                </div>
                <div class="input-group">
                    <label for="registerCap">
                        CAP
                    </label>
                    <input
                            id="registerCap"
                            type="text"
                            name="cap"
                            maxlength="5"
                            pattern="[0-9]{5}"
                            inputmode="numeric"
                            autocomplete="postal-code"
                            required>
                </div>
                <button type="submit" class="btn">
                    SIGN UP
                </button>
            </form>
            <div class="auth-switch">
                <p>Possiedi già un account?</p>
                <button
                        id="showLoginButton"
                        class="btn switch-button"
                        type="button">
                    Torna al login
                </button>
            </div>
        </section>
    </div>
</main>

<!-- SIGN/LOG-IN-->
<script src="scripts/log-sign.js"></script>
<!-- CARRELLO -->
<script src="scripts/carrello.js"></script>
<!-- OVERLAY UTENTE -->
<script src="scripts/user-overlay.js"></script>

</body>
</html>