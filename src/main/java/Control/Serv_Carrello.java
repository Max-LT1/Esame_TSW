package Control;


import DAO.DaoComposizione;
import DAO.DaoProdotto;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;


import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Client;
import model.Composizione;
import model.Prodotto;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/carrelloServ")
public class Serv_Carrello extends HttpServlet {
    private static final long serialVersionUID = 2L;
    private DaoProdotto daoProdotto;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<Composizione> composizione = null;
        if((Client) session.getAttribute("cliente") == null){
            composizione = (List<Composizione>) session.getAttribute("guesscarrello");
        }else{
            composizione = (List<Composizione>) session.getAttribute("carrello");
        }
        List<Composizione> itemsToRemove = new ArrayList<>();

        JsonArray composizioniJson = new JsonArray();
        BigDecimal prezzoTotale = BigDecimal.ZERO;
        if(composizione != null){
            for(Composizione c : composizione){
                Prodotto product = new Prodotto();
                try{
                    product = daoProdotto.getProdottoById(c.getIdProdotto());
                    if(product == null){
                        itemsToRemove.add(c);
                        continue;
                    }
                    JsonObject composizioneJson = new JsonObject();
                    composizioneJson.addProperty("path_immagine", product.getPath_immagine());

                    composizioneJson.addProperty("nomeProdotto", product.getIdProdotto());
                    composizioneJson.addProperty("descrizione", product.getDescrizione());
                    composizioneJson.addProperty("prezzo", product.getPrezzo());
                    composizioneJson.addProperty("Categoria", product.getCategoria());
                    composizioneJson.addProperty("quantity", c.getQuantita_prodotto());
                    prezzoTotale.add(prezzoTotale.add(product.getPrezzo().multiply(BigDecimal.valueOf(c.getQuantita_prodotto()))));

                    composizioniJson.add(composizioneJson);

                } catch (SQLException e) {
                    String err = "Errore nel caricamento del carrello";
                    response.sendError(500, err);
                    return;
                } catch (NullPointerException e) {
                    String err = "Errore nel caricamento del carrello";
                    response.sendError(500, err);
                    return;
                }
            }
            composizione.removeAll(itemsToRemove);
        }
        request.setAttribute("composizioniJson", composizioniJson.toString());
        request.setAttribute("prezzoTotale", prezzoTotale);
        RequestDispatcher dispatcher = request.getRequestDispatcher("cart.jsp");
        dispatcher.forward(request, response);
    }

}
