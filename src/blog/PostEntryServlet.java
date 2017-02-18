package blog;

import static com.googlecode.objectify.ObjectifyService.ofy;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;

public class PostEntryServlet extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Date current = new Date();

        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        String title = req.getParameter("title");
        String body = req.getParameter("body");

        if (title.equals("") || body.equals("") ) {
            resp.sendRedirect("/newPost.jsp");
        } else {

            Entry entry = new Entry(user, title, body);

            ofy().save().entity(entry).now();
            resp.sendRedirect("/index.jsp");
        }

    }
}
