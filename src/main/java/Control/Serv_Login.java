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

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String username = req.getParameter("Username");
        String email = req.getParameter("Email");
        String password = req.getParameter("Password");
        List<Composizione> carrello = null;
        HttpSession session = req.getSession();
        Client client;
        try {
            client = clienteDAO.getClienteByUsername(username);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        if (client != null) {
            try{
                carrello = daoComposizione.getComposizioniByUsernameAndEmail(client.getUsername(), client.getEmail());
            } catch (SQLException e) {
                String error = "Errore per il carrello, riprova";
                res.sendError(500, error);
                throw new RuntimeException(e);
            }

            List<Composizione> guestCart = (List<Composizione>) session.getAttribute("guestCart");
            if(carrello==null){
                carrello = new ArrayList<>();
            }
            if (guestCart != null && !carrello.isEmpty()) {
                for(Composizione Gcomposizione : guestCart){
                    Boolean prod = false;
                    for(Composizione ClientComposizione : carrello){
                        if(ClientComposizione.getIdProdotto() == Gcomposizione.getIdProdotto()){
                            ClientComposizione.setQuantita_prodotto(ClientComposizione.getQuantita_prodotto() + Gcomposizione.getQuantita_prodotto());
                            prod = true;
                            break;
                        }
                    }
                    if(!prod){
                        Gcomposizione.setUsername(client.getUsername());
                        Gcomposizione.setEmail(client.getEmail());
                        carrello.add(Gcomposizione);
                    }
                }
            }
            session.removeAttribute("guestCart");
            session.setAttribute("carrello", carrello);
            String sessionToken = UUID.randomUUID().toString();
            session.setAttribute("sessionToken", sessionToken);
            session.setAttribute("Cliente",  client);

            res.sendRedirect("");
        }
        else{
            String errorM = "Username o password non validi";
            req.setAttribute("errorMessage", errorM);
            req.getRequestDispatcher("Log-sign.jsp").forward(req, res);
        }
    }

    @Override
    public void init() throws ServletException {
        ds= DBConnection.getDataSource();
        clienteDAO = new ClienteDAO(ds);
        daoComposizione = new DaoComposizione(ds);
    }
}
