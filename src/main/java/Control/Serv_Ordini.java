package Control;

import DAO.DBConnection;
import DAO.DaoComposizione;
import DAO.DaoOrdine;
import DAO.DaoProdotto;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.mysql.cj.xdevapi.JsonArray;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Client;
import model.Composizione;
import model.Ordine;
import model.Prodotto;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/Ordini")
public class Serv_Ordini extends HttpServlet {
    private static final long serialVersionUID = 8L;
    private DaoComposizione composizioneDAO;
    private Gson gson;
    private DaoOrdine ordineDAO;
    private DaoProdotto prodottoDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Client cliente = (Client) session.getAttribute("cliente");

        if (cliente == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        try {

            List<Ordine> ordini = ordineDAO.getOrdineForUser(cliente.getUsername(), cliente.getEmail());
            JsonObject resultJson = new JsonObject();

            for (Ordine ordine : ordini) {
                int ordineId = ordine.getIdOrdine();
                List<Composizione> composizioni = composizioneDAO.findOrderedItemsByOrderId(cliente.getUsername(),
                        cliente.getEmail(), ordineId);

                JsonObject ordineJson = new JsonObject();
                ordineJson.addProperty("orderId", ordine.getIdOrdine());

                ordineJson.addProperty("orderDate", ordine.getDataInserimento().toString());
                ordineJson.addProperty("totalAmount", ordine.getPrezzoVendita().toString());
                ordineJson.addProperty("orderStatus", ordine.getStatoOrdine());

                JsonArray composizioniJson = new JsonArray();
                for (Composizione composizione : composizioni) {
                    JsonObject composizioneJson = new JsonObject();

                    Prodotto prodotto = prodottoDAO.getOrderProduct(composizione.getIdProdotto());
                    JsonObject prodottoJson = new JsonObject();
                    prodottoJson.addProperty("price", prodotto.getPrezzo().toString());
                    prodottoJson.addProperty("name", prodotto.getNomeProdotto());
                    prodottoJson.addProperty("description", prodotto.getDescrizione());

                    prodottoJson.addProperty("image", prodotto.getPath_immagine());

                    composizioneJson.add("product", prodottoJson);
                    composizioneJson.addProperty("quantity", composizione.getQuantita_prodotto());
                    composizioneJson.addProperty("price", composizione.getPrezzo_vendita().toString());

                    composizioniJson.add(composizioneJson);
                }

                ordineJson.add("composizioni", composizioniJson);
                resultJson.add(String.valueOf(ordineId), ordineJson);
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(resultJson));
        } catch (SQLException e) {
            String errorMessage = "There was an error during the retrieval of your ordini, try again " + e;
            response.sendError(500, errorMessage);
        }
    }

    @Override
    public void init() {
        ordineDAO = new DaoOrdine(DBConnection.getDataSource());
        composizioneDAO = new DaoComposizione(DBConnection.getDataSource());
        prodottoDAO = new DaoProdotto(DBConnection.getDataSource());
        gson = new GsonBuilder().setPrettyPrinting().create();
    }
}
