package Control;


import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Client;
import model.Composizione;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/AggiornaCarrello")
public class Serv_AggiornaCarrello extends HttpServlet {
    private static final long serialVersionUID = 5162781596625596474L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String requestBody = request.getReader().lines().collect(Collectors.joining());
        JsonObject json = new Gson().fromJson(requestBody, JsonObject.class);

        int quantita = json.get("quantita").getAsInt();
        int prodottoId = json.get("prodottoId").getAsInt();
        HttpSession session = request.getSession();

        Client client = (Client) session.getAttribute("cliente");

        List<Composizione> carrello = null;

        if(client == null){
            carrello = (List<Composizione>) session.getAttribute("carrelloNoLog");
        }else{
            carrello = (List<Composizione>) session.getAttribute("carrello");
        }
        if(carrello != null){
            for(Composizione cartItem : carrello){
                if(cartItem.getIdProdotto() == prodottoId){
                    if (quantita < 1 || quantita > 99) {
                        response.setStatus(
                                HttpServletResponse.SC_BAD_REQUEST
                        );
                        response.setContentType(
                                "application/json"
                        );
                        response.setCharacterEncoding("UTF-8");
                        response.getWriter().write(
                                "{\"success\":false,\"message\":\"Quantità non valida\"}"
                        );
                        return;
                    }
                    cartItem.setQuantita_prodotto(quantita);
                    break;
                }
            }
        }

        if (client == null) {
            session.setAttribute("carrelloNoLog", carrello);
        } else {
            session.setAttribute("carrello", carrello);
        }

        JsonObject responseJson = new JsonObject();
        responseJson.addProperty("success", true);
        String json2 = new Gson().toJson(responseJson);
        response.setContentType("application/json");
        response.getWriter().write(json2);
    }
}
