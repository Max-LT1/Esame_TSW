package Control;

import DAO.DBConnection;
import DAO.DaoComposizione;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Client;
import model.Composizione;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/RimuoviProdotto")
public class Serv_Rem_prod extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private DaoComposizione composizioneDAO;
    private DataSource dataSource;
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Recupera i parametri dalla richiesta
        String idProdottoString = request.getParameter("prodottoId");

        // Controlla se l'ID del prodotto è stato fornito
        if (idProdottoString != null) {
            int idProdotto = Integer.parseInt(idProdottoString);

            // Recupera il cliente dalla sessione
            HttpSession session = request.getSession();

            // Rimuovi il prodotto dal carrello nella sessione
            List<Composizione> carrello = null;

            if (((Client) session.getAttribute("cliente")) == null) {
                carrello = (List<Composizione>) session.getAttribute("guestCart");
            } else {
                carrello = (List<Composizione>) session.getAttribute("carrello");

            }
            if (carrello != null) {
                carrello.removeIf(composizione -> composizione.getIdProdotto() == idProdotto);
                if (((Client) session.getAttribute("cliente")) == null) {
                    session.setAttribute("guestCart", carrello);

                } else {
                    session.setAttribute("carrello", carrello);
                    try {
                        Client cliente = (Client) session.getAttribute("cliente");

                        composizioneDAO.removeComposizione(cliente.getUsername(), cliente.getEmail(), idProdotto);
                    } catch (SQLException e) {
                        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,"Errore nel rimuovere prodotti");
                        return;
                    }

                }
            }

            // Rimuovi il prodotto dal carrello nel database

            // Reindirizza alla pagina del carrello
            response.sendRedirect("Cart");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,"ID prodotto non ricevuto");

        }
    }

    @Override
    public void init() {
        dataSource = DBConnection.getDataSource();
        composizioneDAO = new DaoComposizione(dataSource);
    }
}
