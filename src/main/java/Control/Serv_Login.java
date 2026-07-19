package Control;

import DAO.ClienteDAO;
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
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/loginServ")
public class Serv_Login extends HttpServlet {
    private ClienteDAO clienteDAO;
    private DataSource ds;
    private DaoComposizione daoComposizione;

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String clientename = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        HttpSession session = request.getSession();
        // Perform authentication logic here (e.g., checking against a database)
        Client cliente = null;
        List<Composizione> carrelloItems = null;

        try {
            cliente = clienteDAO.getClienteByUsernamePassword(clientename, password);
        } catch (SQLException e) {
            String errorMessage = "There was an error during the login, try again";
            response.sendError(500, errorMessage);

            return;
        }


        if (cliente != null) {

            try {
                carrelloItems = daoComposizione.getComposizioniByUsernameAndEmail(cliente.getUsername(),
                        cliente.getEmail());
            } catch (SQLException e) {
                String errorMessage = "There was an error during the retrieval of your carrello items, try again";
                response.sendError(500, errorMessage);
                return;
            }
            // Get the guest carrello from the guest session
            List<Composizione> guestCart = (List<Composizione>) session.getAttribute("guestCart");

            // Get the cliente carrello from the session or create a new carrello if it
            // doesn't exist
            if (carrelloItems == null) {
                carrelloItems = new ArrayList<>();
            }

            if (guestCart != null && !guestCart.isEmpty()) {
                for (Composizione guestComposizione : guestCart) {
                    boolean productExists = false;
                    for (Composizione clienteComposizione : carrelloItems) {
                        if (guestComposizione.getIdProdotto() == clienteComposizione.getIdProdotto()) {
                            // Update the quantity of the existing carrello item
                            clienteComposizione.setQuantita_prodotto((clienteComposizione.getQuantita_prodotto()
                                    + guestComposizione.getQuantita_prodotto()));
                            productExists = true;
                            break;
                        }
                    }
                    if (!productExists) {
                        // Add the guest carrello item as a new carrello item
                        guestComposizione.setUsername(cliente.getUsername());
                        guestComposizione.setEmail(cliente.getEmail());
                        carrelloItems.add(guestComposizione);
                    }
                }
            }

            // Remove the guest carrello from the session
            session.removeAttribute("guestCart");

            // Save the updated cliente carrello in the session
            session.setAttribute("carrello", carrelloItems);

            String sessionToken = UUID.randomUUID().toString();

            session.setAttribute("cliente", cliente);
            session.setAttribute("sessionToken", sessionToken);

            // Redirect to a protected resource or home page
            response.sendRedirect("HomePage");
        } else {

            String errorMessage = "Username o password non validi";
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("log-sign.jsp").forward(request, response);

        }
    }

    @Override
    public void init() throws ServletException {
        ds= DBConnection.getDataSource();
        clienteDAO = new ClienteDAO(ds);
        daoComposizione = new DaoComposizione(ds);
    }
}
