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
import java.util.*;

@WebServlet({"/HomePage", "/ContextCheck", "/AdmCat", "/SingleItem"})
public class Serv_product extends HttpServlet {
    private DataSource dataSource;
    private DaoProdotto daoProdotto;

    public void init() throws ServletException {
        dataSource = DBConnection.getDataSource();
        daoProdotto = new DaoProdotto(dataSource);
    }

    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String servletPath = req.getServletPath();

        try {
            switch (servletPath) {
                case "/ContextCheck":
                    mostraCodex(req, resp);
                    break;
                case "/HomePage":
                    mostraHome(req, resp);
                    break;
                case "/AdmCat":
                    //TODO
                    break;
                case "/SingleItem":
                    singleItem(req, resp);
                    break;
                default:
                    //TODO
            }
        } catch (SQLException e) {
            throw new ServletException("Errore durante il caricamento dei prodotti", e);
        }
    }

    private void mostraCodex(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {

        String categoria = req.getParameter("categoria");
        if (categoria == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Categoria non specificata");
            return;
        }
        List<Prodotto> prodotti = daoProdotto.prodottiPerCategoria(categoria);
        if (prodotti == null) {
            prodotti = new ArrayList<>();
        }
        Set<String> tipi = new LinkedHashSet<>();
        for (Prodotto prodotto : prodotti) {
            if (prodotto.getTipo() != null && !prodotto.getTipo().isBlank()) {
                tipi.add(prodotto.getTipo());
            }
        }
        req.setAttribute("Categoria", categoria);
        req.setAttribute("Lista", prodotti);
        req.setAttribute("Tipi", tipi);
        req.getRequestDispatcher("/codex.jsp").forward(req, resp);
    }

    private void mostraHome(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        req.setAttribute("ListaSconti", daoProdotto.getAllSconto());
        req.setAttribute("NuoviProdotti", daoProdotto.getLatestadds());
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    private void singleItem(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        String s = req.getAttribute("NomeProdotto").toString();
        Prodotto p = daoProdotto.getProdottoByNome(s);
        req.setAttribute("prodotto", p);
    }
}
