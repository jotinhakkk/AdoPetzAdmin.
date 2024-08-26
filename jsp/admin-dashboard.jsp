<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    HttpSession Session = request.getSession(false);
    if (Session == null || Session.getAttribute("email") == null) {
        response.sendRedirect("../CadastroAdministrador/login.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../css/admin-dashboard.css">
    <title>Painel do Administrador</title>
</head>
<body>
    <header>
        
        
    </header>
    <main class="container">
    
        <h1>Painel do Administrador</h1>
        <div class="button-container">
            <a href="cadastro.jsp" class="button">Cadastrar Cliente</a>
            <a href="excluir_clientes.jsp" class="button">Excluir Cliente</a>
            <a href="redefinir_dados.jsp" class="button">Alterar Cliente</a>
            <a href="buscar_dados.jsp" class="button">Puxar Dados de um Cliente</a>
        </div>
        <a href="logout.jsp" class="back-link">Finalizar Sessão</a>
    </main>
</body>
</html>
