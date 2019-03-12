import java.io.IOException;
import java.util.HashMap;

public class InfoServlet extends javax.servlet.http.HttpServlet {
    protected void doPost(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {

    }

    protected void doGet(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        HashMap info = DB.getInfos();
        request.setAttribute("version", info.get("version"));
        request.setAttribute("author", info.get("author"));
        request.setAttribute("contact", info.get("contact"));
        request.getRequestDispatcher("/WEB-INF/index.jsp").forward(request, response);
    }
}
