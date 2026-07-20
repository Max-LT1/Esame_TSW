package Control;

import DAO.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.*;

import javax.sql.DataSource;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/Checkout")
public class Serv_Checkout extends HttpServlet {
    private static final long serialVersionUID = 12L;
    private DaoComposizione composizioneDAO;
    private DaoOrdine ordineDAO;
    private DaoProdotto prodottoDAO;
    private DaoPagamento pagamentoDAO;
    private DataSource ds;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String sessionToken = ((String) session.getAttribute("sessionToken"));
        String clientToken = (request.getParameter("clientToken"));
        BigDecimal totalPrice = new BigDecimal(request.getParameter("prezzoTotale"));

        Client cliente = (Client) session.getAttribute("cliente");
        java.sql.Date localDate = new java.sql.Date(System.currentTimeMillis());

        if (cliente == null || !sessionToken.equals(clientToken)) {
            String errorMessage = "You are not logged in, please login";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("log-sign.jsp").forward(request, response);
            return;
        }
        if (cliente.getNome() == null || !cliente.getNome().matches("^[a-zA-Z ]{1,30}$")) {
            String errorMessage = "Cliente Profile must be compiled before Checkout (First Name missing)";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("ProfiloUtente.jsp").forward(request, response);

            return;
        }
        if (cliente.getCognome() == null || !cliente.getCognome().matches("^[a-zA-Z ]{1,30}$")) {
            String errorMessage = "Cliente Profile must be compiled before Checkout (Last Name missing)";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("ProfiloUtente.jsp").forward(request, response);

            return;
        }

        if (cliente.getIndirizzo() == null || !cliente.getIndirizzo().matches("[a-zA-Z0-9 ]{1,100}$")) {
            String errorMessage = "Cliente Profile must be compiled before Checkout (Home Address missing)";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("ProfiloUtente.jsp").forward(request, response);

            return;
        }
        String numeroCarta = request.getParameter("numeroCarta");
        String titolareConto = request.getParameter("titolareConto");
        String dataScadenzaString = request.getParameter("dataScadenza");
        java.util.Date utilDate = null;

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        try {
            utilDate = dateFormat.parse(dataScadenzaString);
        } catch (ParseException e) {
            String errorMessage = "There was an error in retrieving the data ";
            response.sendError(500, errorMessage);
            return;
        }
        java.sql.Date dataScadenza = new java.sql.Date(utilDate.getTime());
        if (dataScadenza.before(localDate)) {
            String errorMessage = "La carta è scaduta.";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("Cart.jsp").forward(request, response);
            return;

        }
        // Controllo che il numero della carta sia composto solo da cifre
        if (!numeroCarta.matches("^\\d+$")) {
            String errorMessage = "Il numero della carta deve essere composto solo da cifre.";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("Cart.jsp").forward(request, response);
            return;
        }

        // Controllo che la data di scadenza sia nel formato corretto (YYYY-MM-DD)
        if (!dataScadenzaString.matches("^\\d{4}-\\d{2}-\\d{2}$")) {
            String errorMessage = "La data di scadenza deve essere nel formato corretto (YYYY-MM-DD).";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            return;
        }

        // Controllo che il titolare del conto sia stato inserito
        if (titolareConto.trim().isEmpty()) {
            String errorMessage = "Inserisci il titolare del conto.";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            return;
        }

        List<Composizione> composizioni;
        if (((Client) session.getAttribute("cliente")) == null) {
            composizioni = (List<Composizione>) session.getAttribute("guestCart");
        } else {
            composizioni = (List<Composizione>) session.getAttribute("carrello");
        }
        try {
            composizioneDAO.saveAllComposizioni(composizioni);
        } catch (SQLException e) {
            String errorMessage = "There was an error in saving your cart data to the database";
            response.sendError(500, errorMessage);
            return;
        }

        Ordine ordine = new Ordine();
        Prodotto product;

        ordine.setIdOrdine(0);
        ordine.setDataInserimento(localDate);
        ordine.setPrezzoVendita(totalPrice);
        ordine.setEmailCliente(cliente.getEmail());
        ordine.setUsernameCliente(cliente.getUsername());
        ordine.setStatoOrdine("In attesa di spedizione");
        int ordineId;
        try {
            ordineId = ordineDAO.saveOrdine(ordine);
        } catch (SQLException e) {
            String errorMessage = "There was an error in creating the ordine, try again";
            response.sendError(500, errorMessage);
            return;
        }

        for (Composizione composizione : composizioni) {
            try {

                product = prodottoDAO.getProdottoById(composizione.getIdProdotto());
                if (product == null) {
                    String errorMessage = "The item you were buying got deleted, return to the cart";
                    response.sendError(500, errorMessage);
                    return;
                }

            } catch (SQLException e) {
                String errorMessage = "There was an error in retrieving the product in your cart, try removing each cart item";
                response.sendError(500, errorMessage);
                return;

            }
            composizione.setPrezzo_vendita(product.getPrezzo());
            try {
                composizioneDAO.updateComposizione(ordineId, cliente.getUsername(), cliente.getEmail(),
                        product.getPrezzo(), product.getIdProdotto());
            } catch (SQLException e) {
                String errorMessage = "There was an error in updating the product in your cart, try removing each cart item";
                response.sendError(500, errorMessage);
                return;
            }
            session.setAttribute("carrello", null);
        }

        Pagamento pagamento = new Pagamento();
        pagamento.setIdPagamento(0); // o l'ID appropriato se ne hai uno
        pagamento.setDataPagamento(localDate); // Imposta la data di pagamento come la data corrente
        pagamento.setImportoPagamento(totalPrice); // Imposta l'importo del pagamento con il prezzo totale
        pagamento.setNumeroCarta(numeroCarta); // Ottieni il numero di carta dalla richiesta, se
        // è presente

        pagamento.setDataScadenza(dataScadenza); // Ottieni la data di scadenza dalla richiesta, se è presente
        pagamento.setTitolareConto(titolareConto); // Ottieni il titolare del conto dalla
        // richiesta, se è presente
        pagamento.setIdOrdine(ordineId); // Imposta l'ID dell'ordine associato al pagamento

        try {
            pagamentoDAO.insertPagamento(pagamento);
        } catch (SQLException e) {
            String errorMessage = "There was an error in saving the payment data to the database";
            response.sendError(500, errorMessage);
            return;
        }

        response.sendRedirect("Ordini.jsp");
    }

    @Override
    public void init() throws ServletException {
        ds = DBConnection.getDataSource();
        composizioneDAO = new DaoComposizione(ds);
        ordineDAO = new DaoOrdine(ds);
        prodottoDAO = new DaoProdotto(ds);
        pagamentoDAO = new DaoPagamento(ds);
    }
}
