<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="blog.Entry" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.TimeZone" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>All Posts</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" href="/main.css">
</head>
<body>

<div class="container" style="padding-bottom: 50px;">
    <img src="/banner.jpg" alt="" style="max-width: 100%; padding-bottom: 30px;">


    <%
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        if (user != null) {
            pageContext.setAttribute("user", user);
    %>

    <p>
        Hi ${fn:escapeXml(user.email)}
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
    %>

    <a href="index.jsp">Back to Landing Page</a>


    <%
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
            SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
            dateFormat.setTimeZone(TimeZone.getTimeZone("CST"));
            pageContext.setAttribute("entry_time", dateFormat.format(entry.getDate()));
    %>

    <hr>
    <p>${fn:escapeXml(entry_user.email)}:</p>
    <p>${fn:escapeXml(entry_title)}</p>
    <blockquote>${fn:escapeXml(entry_body)}</blockquote>
    <p>${fn:escapeXml(entry_time)}</p>

    <%
            }
        }
    %>

</div>

</body>
</html>