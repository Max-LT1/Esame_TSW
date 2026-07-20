<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // LoginServlet deve salvare lo username nella sessione:
    // session.setAttribute("username", username);
    String username = (String) session.getAttribute("username");
    boolean utenteLoggato = username != null && !username.trim().isEmpty();
    String ctx = request.getContextPath();
%>
<header class="navbar">
    <form class="navbar-search" action="search.jsp" method="get">
        <input class="searchbar" type="search" name="query" placeholder="Cerca nel Codex..." aria-label="Cerca prodotti">
        <button class="search-button" type="submit" aria-label="Avvia ricerca">Cerca</button>
    </form>
    <nav class="nav-links">
        <a href="<%= ctx %>/HomePage" class="navbar-logo">Home</a>
        <a href="<%= ctx %>/ContextCheck?categoria=armi">Armi</a>
        <a href="<%= ctx %>/ContextCheck?categoria=armature">Armature</a>
        <a href="<%= ctx %>/ContextCheck?categoria=scudi">Scudi</a>
        <a href="<%= ctx %>/ContextCheck?categoria=accessori">Accessori</a>
        <a href="<%= ctx %>/contacts.jsp">Contatti</a>
    </nav>
    <div class="user-area">
        <span class="icon-user" id="user-icon" role="button" tabindex="0" aria-label="Apri area utente">👤</span>
        <a href="<%= ctx %>/cart.jsp" class="navbar-icon cart-link" aria-label="Apri il carrello">
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
        <a class="overlay-button primary" href="<%= ctx %>/user-area.jsp">Visualizza profilo</a>
        <form action="<%= ctx %>/logoutServ" method="post">
            <button type="submit" class="overlay-button danger">Logout</button>
        </form>
    </div>
    <% } else { %>
    <p class="overlay-message">Accedi al tuo account oppure crea un nuovo profilo.</p>
    <a class="overlay-button primary full-width" href="<%= ctx %>/log-sign.jsp">Accedi / Registrati</a>
    <% } %>
</div>

<!-- OVERLAY UTENTE -->
<script src="scripts/user-overlay.js"></script>
