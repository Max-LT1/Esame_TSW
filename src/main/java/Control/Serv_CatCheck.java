package Control;

import DAO.DBConnection;
import DAO.DaoProdotto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Prodotto;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/notSameAsBefore")
public class Serv_CatCheck extends HttpServlet {
    private DataSource dataSource;
    private DaoProdotto daoProdotto;

    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //legge Cat (categoria) e poi da i valori giusti
        String categoria = req.getParameter("Cat");
        List<Prodotto> prodotti;
        try {
            prodotti = daoProdotto.prodottiPerCategoria(categoria);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        req.setAttribute("Categoria", categoria);
        req.setAttribute("Lista", prodotti);
    }


    public void init() throws ServletException {
        dataSource = DBConnection.getDataSource();
        daoProdotto = new DaoProdotto();
        daoProdotto.setDataSource(dataSource);
    }
}
