package Control;

import DAO.DBConnection;
import DAO.DaoComposizione;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Composizione;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet({"/logoutServ", "/foreLogoutServ"})
public class Serv_Logout extends HttpServlet {
    private static final long serialVersionUID = 4L;
    private DaoComposizione composizioneDAO;
    private DataSource ds;
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String serveletpath = request.getServletPath();

        if(serveletpath.equals("/logoutServ")){
            if(session!=null){

                List<Composizione> composizioneList = (List<Composizione>) session.getAttribute("composizioneList");

                //salviamo la composizione prima di logout
                if(composizioneList!=null && !composizioneList.isEmpty()){
                    try {
                        composizioneDAO.saveAllComposizioni(composizioneList);
                        session.invalidate();
                        response.sendRedirect("index.jsp");
                    } catch (SQLException e) {
                        String errorM = "Problema durante il logout, il carrello non è stato salvato\n" + e;
                        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, errorM);
                        return;

                    }
                }
            }
        }
        else if(serveletpath.equals("/foreLogoutServ")){
            session.invalidate();
            response.sendRedirect("index.jsp");
        }

    }

    public void init(){
        ds = DBConnection.getDataSource();
        composizioneDAO = new DaoComposizione(ds);
    }
}
