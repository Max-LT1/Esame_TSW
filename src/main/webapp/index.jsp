<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.CartItem" %>

<%
    List<CartItem> carrello = (List<CartItem>) session.getAttribute("carrello");
    double totale = 0;
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>La Forgia Celeste</title>
    <link rel="stylesheet" href="style.css">
    <!--<link rel="stylesheet" href="responsive.css">-->
</head>
<body>
<header class="navbar">
    <div class="search-container">
        <input type="text" placeholder="Cerca..." class="searchbar">
    </div>
    <nav class="nav-links">
        <a href="#">Armi</a>
        <a href="#">Armature</a>
        <a href="#">Scudi</a>
        <a href="#">Accessori</a>
        <a href="#">Contatti</a>
    </nav>
    <div class="user-area">
        <span class="icon-user">👤</span>
        <span class="icon-cart" id="cart-icon">🛒</span>
    </div>
</header>

<!-- OVERLAY CARRELLO -->
<div id="cart-overlay" class="overlay hidden" style="z-index: 10">
    <div class="overlay-content">
        <h3>Carrello</h3>


        <%
            if(carrello != null && !carrello.isEmpty()){

                for(CartItem item : carrello){
                    totale += item.getTotale();
        %>
        <div class="prodotto">

            <div class="info">
                <span class="nome"><%= item.getNome() %></span>
                <span class="prezzo">€ <%= item.getPrezzo() %></span>
                <span>Quantità: <%= item.getQuantita() %></span>
            </div>
            <div>
                € <%= item.getTotale() %>

                <form action="RimuoviDalCarrello" method="post">
                    <input type="hidden" name="nome" value="<%= item.getNome() %>">
                    <button type="submit">Rimuovi</button>
                </form>
            </div>

        </div>
        <%
            }
        %>
        <div class="totale">
            Totale: € <%= totale %>
        </div>
        <%
        }else{
        %>
        <p>Il carrello è vuoto.</p>
        <%
            }
        %>
    </div>

        <button class="btn-cart">Svuota Carrello</button>
        <button class="btn-cart">Vai al Checkout</button>
    </div>
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

<!-- CARRELLO -->
<script>
    const cartIcon = document.getElementById('cart-icon');
    const overlay = document.getElementById('cart-overlay');

    cartIcon.addEventListener('click', () => {
        overlay.classList.toggle('hidden');
    });
</script>

<!-- CAROSELLO -->
<script>
    function setupCarousel(carouselId) {
        const carousel = document.getElementById(carouselId);
        const left = carousel.parentElement.querySelector(".left");
        const right = carousel.parentElement.querySelector(".right");

        left.addEventListener("click", () => {
            carousel.scrollLeft -= 400;
        });

        right.addEventListener("click", () => {
            carousel.scrollLeft += 400;
        });
    }

    setupCarousel("carousel1");
    setupCarousel("carousel2");
    setupCarousel("carousel3");
</script>

<!-- PRODOTTI -->
<script>
    document.querySelectorAll(".product").forEach(card => {
        card.addEventListener("click", () => {
            const id = card.dataset.id;
            window.location.href = `/prodotto?=${id}`;
        });
    });
</script>

</body>
</html>
