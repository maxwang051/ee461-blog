
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="blog.Entry" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
  <head>
    <title>Blog</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" href="style/main.css">
  </head>
  <body>

  <div class="container">


  <%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();

    if (user != null) {
        pageContext.setAttribute("user", user);

  %>

  <p>
    Hi ${fn:escapeXml(user.nickname)}
     | <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign Out</a>
  </p>

  <%
    } else {
  %>

  <p>
    <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign In</a>
  </p>

  <%
    }

    ObjectifyService.register(Entry.class);
    List<Entry> entries = ObjectifyService.ofy().load().type(Entry.class).list();
    Collections.sort(entries);

    if (entries.isEmpty()) {

  %>

  <p>There are no blog entries</p>

  <%
    } else {
      for (Entry entry : entries) {
          pageContext.setAttribute("entry_title", entry.getTitle());
          pageContext.setAttribute("entry_body", entry.getBody());
          pageContext.setAttribute("entry_user", entry.getUser());

  %>

  <p>${fn:escapeXml(entry_user.nickname)}:</p>
  <p>${fn:escapeXml(entry_title)}</p>
  <hr>
  <blockquote>${fn:escapeXml(entry_body)}</blockquote>

  <%
      }
    }

    if (user != null) {
  %>

  <form action="/postentry" method="post">
    <div><input type="text" name="title"></div>
    <div><textarea name="body" cols="60" rows="10"></textarea></div>
    <div><input type="submit" value="Post"></div>
  </form>

  <%
    }
  %>

  </div>

  </body>
</html>
