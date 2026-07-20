<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>
    <title>{Prod.name}</title>
</head>
<body>
<%@ page import="java.util.List"%>
<%@ page import="model.Prodotto"%>
    <%
        Prodotto prodotto = (Prodotto) request.getAttribute("prodotto");
    %>
    <h1><%=prodotto.getNomeProdotto()%></h1>
</body>
</html>
