<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head><title>PS Assignment - Sample WAR</title></head>
  <body>
    <h1>Hello from Tomcat in Docker</h1>
    <p>Server time: <%= new java.util.Date() %></p>
    <p>Host name: <%= java.net.InetAddress.getLocalHost().getHostName() %></p>
  </body>
</html>
