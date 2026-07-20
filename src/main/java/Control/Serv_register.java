package Control;


import DAO.ClienteDAO;
import DAO.DBConnection;
import com.password4j.Password;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Client;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;

@WebServlet("/RegistrazioneServ")
public class Serv_register extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ClienteDAO clienteDAO;
    private DataSource dataSource;
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Client client = new Client();
        client.setUsername(request.getParameter("username"));
        client.setPassword(Password.hash(request.getParameter("password")).addRandomSalt().withArgon2().getResult());
        client.setEmail(request.getParameter("email"));
        client.setRuolo_cliente("cliente");
        client.setNome(request.getParameter("nome"));
        client.setCognome(request.getParameter("cognome"));
        client.setIndirizzo(request.getParameter("indirizzo"));
        client.setCitta(request.getParameter("citta"));
        client.setProvincia(request.getParameter("provincia"));
        client.setCap(request.getParameter("cap"));
        try {
            clienteDAO.addCliente(client);
            request.getRequestDispatcher("user-area.jsp").forward(request, response);
        } catch (SQLException e) {
            if (e instanceof SQLIntegrityConstraintViolationException) {
                // Errore utente già esistente
                String errorMessage = "username o email già esistono";
                request.setAttribute("errorMessage", errorMessage);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                request.getRequestDispatcher("/log-sign").forward(request, response);
            } else {
                // Errore generico
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Problema durante la registrazione.");
            }
        }

    }

    @Override
    public void init() throws ServletException {
        dataSource = DBConnection.getDataSource();
        clienteDAO = new ClienteDAO(dataSource);
    }
}
