<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="blog.Entry" %>
<%@ page import="blog.Subscriber" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.TimeZone" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>New Post</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link rel="stylesheet" href="/main.css">
</head>
<body>
    <div class="container">
        <img src="/banner.jpg" alt="" style="max-width: 100%; padding-bottom: 30px;">

            <%
        ObjectifyService.register(Subscriber.class);
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        if (user != null) {
          pageContext.setAttribute("user", user);
      %>

        <a href="/index.jsp">Cancel</a>
        <form action="/postentry" method="post">
            <h2 class="form-element">New Post</h2>
            <div class="form-element"><input type="text" name="title" placeholder="Title"></div>
            <div class="form-element"><textarea name="body" cols="60" rows="10" placeholder="Body"></textarea></div>
            <div class="form-element"><input class="btn btn-primary" type="submit" value="Post"></div>
        </form>
        <%
            } else {
        %>

        <p>You are not authorized to view this page. Click <a href="/index.jsp">here</a> to go back.</p>

        <%
            }
        %>
</body>
</html>
