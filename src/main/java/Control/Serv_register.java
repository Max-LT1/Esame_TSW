package Control;


import DAO.ClienteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Client;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;

@WebServlet("/RegistrazioneServ")
public class Serv_register extends HttpServlet {
    private static final long serialVersionUID = 1L;
    ClienteDAO clienteDAO;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");

        Client client = new Client();
        client.setUsername(username);
        client.setPassword(password);
        client.setEmail(email);
        client.setRuolo_cliente("cliente");

        try {
            clienteDAO.addCliente(client);
            request.getRequestDispatcher("").forward(request, response);
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
}
