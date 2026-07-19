package Control;


import DAO.ClienteDAO;
import DAO.DBConnection;
import DAO.DaoComposizione;
import DAO.DaoProdotto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Client;
import model.Composizione;
import model.Prodotto;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet({"/HomePage", "/ContextCheck2", "/AdmCat"})
public class Serv_product extends HttpServlet {
    private DataSource dataSource;
    private DaoProdotto daoProdotto;

    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String servletPath = req.getServletPath();

        if(servletPath.equals("/ContextCheck")){
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
        if(servletPath.equals("/HomePage")){
            List<Prodotto> prodottiScontati;
            List<Prodotto> Nuoviprodotti;
            try {
                prodottiScontati = daoProdotto.getAllSconto();
                Nuoviprodotti = daoProdotto.getLatestadds();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            req.setAttribute("ListaSconti", prodottiScontati);
            req.setAttribute("Nuoviprodotti", Nuoviprodotti);
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
        if(servletPath.equals("/AdmCat")){

        }
    }


    public void init() throws ServletException {
        dataSource = DBConnection.getDataSource();
        daoProdotto = new DaoProdotto();
        daoProdotto.setDataSource(dataSource);
    }
}
