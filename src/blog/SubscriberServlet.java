package blog;

import static com.googlecode.objectify.ObjectifyService.ofy;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SubscriberServlet extends HttpServlet {
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        Subscriber subscriber = new Subscriber(user);

        ofy().save().entity(subscriber).now();
        resp.sendRedirect("/index.jsp");
    }

    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();

        Subscriber subscriber = null;

        for (Subscriber sub : ofy().load().type(Subscriber.class).list()) {
            if (sub.getUser().equals(user)) {
                subscriber = sub;
            }
        }

        ofy().delete().entity(subscriber).now();
        resp.sendRedirect("/index.jsp");
    }
}
