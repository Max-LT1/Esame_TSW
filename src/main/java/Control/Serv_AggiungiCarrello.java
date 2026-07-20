package Control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Client;
import model.Composizione;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AggiungiCarrello")
public class Serv_AggiungiCarrello extends HttpServlet {

    private static final long serialVersionUID = 6L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        StringBuilder sb = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        int productId = 0;
        int quantita = 0;

        try {
            JsonObject json = JsonParser.parseString(sb.toString()).getAsJsonObject();

            // Estraiamo in modo flessibile sia se arrivano come stringhe che come numeri
            productId = (json.get("idProdotto").getAsInt());
            quantita = (json.get("quantita").getAsInt());
        } catch (Exception e) {
            // Se il JSON è malformato, vuoto o contiene NaN, rispondi con un errore pulito (addio Errore 500!)
            response.getWriter().write("{\"success\": false, \"message\": \"Dati JSON inviati non validi o mancanti.\"}");
            return;
        }

        HttpSession session = request.getSession();

        if (quantita <= 0 || quantita > 99) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"Quantità non valida\"}");
            return;
        }

        Client client = (Client) session.getAttribute("cliente");
        List<Composizione> carrello;

        if (client == null) {
            carrello = (List<Composizione>) session.getAttribute("carrelloNoLog");
        } else {
            carrello = (List<Composizione>) session.getAttribute("carrello");
        }

        if (carrello == null) {
            carrello = new ArrayList<>();
        }

        boolean productExists = false;
        for (Composizione composizione : carrello) {
            if (composizione.getIdProdotto() == productId) {
                productExists = true;

                composizione.setQuantita_prodotto(quantita);
                break;
            }
        }

        if (!productExists) {
            Composizione newComposizione = new Composizione();
            newComposizione.setIdProdotto(productId);
            newComposizione.setQuantita_prodotto(quantita);
            if (client != null) {
                newComposizione.setEmail(client.getEmail());
                newComposizione.setUsername(client.getUsername());
            }
            carrello.add(newComposizione);
        }

        // Salviamo nuovamente in sessione
        if (client == null) {
            session.setAttribute("carrelloNoLog", carrello);
        } else {
            session.setAttribute("carrello", carrello);
        }

        // Ritorna una risposta JSON di successo come si aspetta il JS (.then(data => data.success))
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\": true}");
    }
}