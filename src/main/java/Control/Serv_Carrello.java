package Control;

import DAO.DBConnection;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Client;
import model.Composizione;
import DAO.DaoComposizione;
import model.Prodotto;
import DAO.DaoProdotto;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/carrelloServ")
public class Serv_Carrello extends HttpServlet {
    private static final long serialVersionUID = 7L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String format = request.getParameter("format");
        boolean isJsonRequest = "json".equals(format);

        HttpSession session = request.getSession();
        Client client = (Client) session.getAttribute("cliente");

        List<Composizione> carrello = new ArrayList<>();

        DaoComposizione composizioneDAO = new DaoComposizione(DBConnection.getDataSource());
        DaoProdotto prodottoDAO = new DaoProdotto(DBConnection.getDataSource());

        // 1. RECUPERO ALLINEATO (Usiamo carrelloNoLog ovunque per gli ospiti)
        if (client != null) {
            try {
                carrello = (List<Composizione>) composizioneDAO.getComposizioniByUsernameAndEmail(client.getUsername(), client.getEmail());
                session.setAttribute("carrello", carrello);
            } catch (Exception e) {
                e.printStackTrace();
                List<Composizione> sessionCart = (List<Composizione>) session.getAttribute("carrello");
                if (sessionCart != null) carrello = sessionCart;
            }
        } else {
            List<Composizione> carrelloNoLog = (List<Composizione>) session.getAttribute("carrelloNoLog");
            if (carrelloNoLog != null) {
                carrello = carrelloNoLog;
            }
        }

        // 2. COSTRUZIONE JSON CON ENTRAMBE LE CHIAVI (Per compatibilità JS e JSP)
        int numeroArticoli = 0;
        BigDecimal prezzoTotale = BigDecimal.ZERO;
        JsonArray articoliArray = new JsonArray();

        if (carrello != null) {
            for (Composizione comp : carrello) {
                numeroArticoli += comp.getQuantita_prodotto();

                try {
                    Prodotto prod = prodottoDAO.getProdottoById(comp.getIdProdotto());
                    if (prod != null) {
                        BigDecimal prezzoBase = prod.getPrezzo() != null ? prod.getPrezzo() : BigDecimal.ZERO;
                        BigDecimal quotaProdotto = prezzoBase.multiply(BigDecimal.valueOf(comp.getQuantita_prodotto()));
                        prezzoTotale = prezzoTotale.add(quotaProdotto);

                        JsonObject prodottoJson = new JsonObject();
                        prodottoJson.addProperty("idProdotto", prod.getIdProdotto());
                        prodottoJson.addProperty("nomeProdotto", prod.getNomeProdotto());
                        prodottoJson.addProperty("descrizione", prod.getDescrizione());
                        prodottoJson.addProperty("prezzo", prezzoBase);
                        prodottoJson.addProperty("path_immagine", prod.getPath_immagine());

                        // Fondamentale: le inseriamo entrambe così nessuno si lamenta più!
                        prodottoJson.addProperty("quantita_prodotto", comp.getQuantita_prodotto()); // Per la JSP
                        prodottoJson.addProperty("quantita", comp.getQuantita_prodotto());          // Per il JS (prodotto.js riga 144)

                        articoliArray.add(prodottoJson);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        // 3. SPEDIZIONE
        if (isJsonRequest) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("numeroArticoli", numeroArticoli);
            jsonResponse.addProperty("prezzoTotale", prezzoTotale.doubleValue());
            jsonResponse.add("articoli", articoliArray);
            response.getWriter().write(new Gson().toJson(jsonResponse));
        } else {
            request.setAttribute("prezzoTotale", prezzoTotale);
            request.setAttribute("composizioniJson", articoliArray.toString());
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
        }
    }

}