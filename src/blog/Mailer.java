package blog;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.util.*;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.googlecode.objectify.ObjectifyService;

public class Mailer {

    @SuppressWarnings("deprecation")
    public static void send(){
        ObjectifyService.register(Entry.class);
        ObjectifyService.register(Subscriber.class);

        List<Entry> entries = ObjectifyService.ofy().load().type(Entry.class).list();

        Collections.sort(entries);

        Date current = new Date(System.currentTimeMillis() - 24 * 60 * 60 * 1000L);

        /*
        Iterator<Entry> iter = entries.iterator();
        while(iter.hasNext()) {
            Entry entry = iter.next();
            if (entry.getDate().before(current)) {
                iter.remove();
            }
        }
        */

        for (Iterator<Entry> iterator = entries.listIterator(); iterator.hasNext(); ) {
            Entry entry = iterator.next();
            if (entry.getDate().before(current)) {
                iterator.remove();
            }
        }

        ObjectifyService.register(Email.class);

        List<Subscriber> subscribers = ObjectifyService.ofy().load().type(Subscriber.class).list();

        //1st step) Get the session object
        Properties props = new Properties();
        props.put("mail.smtp.host", "mail.javatpoint.com");//change accordingly
        props.put("mail.smtp.auth", "true");

        Session session = Session.getDefaultInstance(props);


        //2nd step: compose message
        try {

            String subject = "EE461L Blog Update - Max Wang and Yousef Abdelrazzaq";

            MimeMessage message = new MimeMessage(session);

            message.setFrom(new InternetAddress("maxwang051@gmail.com"));

            for (Subscriber subscriber : subscribers){
                message.addRecipient(Message.RecipientType.TO,new InternetAddress(subscriber.getUser().getEmail()));
            }

            message.setSubject(subject);

            String body = "";

            for (Entry entry : entries) {
                body += "<hr><p>" + entry.getUser() + ":<p><strong>" + entry.getTitle() + "</strong></p><blockquote>" + entry.getBody() + "</blockquote>";
            }

            String header = "<html><head><link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css\" integrity=\"sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u\" crossorigin=\"anonymous\"></head><body><div class=\"container\"><p>Check blog-159017.appspot.com to see new updates!</p>" + body +
                    "</div></body></html>";

            message.setContent(header, "text/html");

            //3rd step: send message

            Transport.send(message);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}  