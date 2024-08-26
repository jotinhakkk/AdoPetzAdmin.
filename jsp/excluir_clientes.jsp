<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.SQLException" %>
<%@ include file="conexao.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession Session = request.getSession(false);
    if (Session == null || Session.getAttribute("email") == null) {
        response.sendRedirect("../CadastroCliente/login.html");
        return;
    }

    String messageResult = "";
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String email = request.getParameter("email");
        Connection connection = (Connection) pageContext.getAttribute("messageConnection");
        if (email != null && !email.isEmpty()) {
            PreparedStatement stmt = null;
            try {
                if (connection != null) {
                    // Excluir dados da tabela pessoafisica
                    String sql = "DELETE FROM pessoafisica WHERE email = ?";
                    stmt = connection.prepareStatement(sql);
                    stmt.setString(1, email);
                    int rowsAffected = stmt.executeUpdate();

                    // Se não encontrar na pessoafisica, tentar na pessoajuridica
                    if (rowsAffected == 0) {
                        sql = "DELETE FROM pessoajuridica WHERE email = ?";
                        stmt = connection.prepareStatement(sql);
                        stmt.setString(1, email);
                        rowsAffected = stmt.executeUpdate();
                    }

                    // Verificar se algum dado foi excluído
                    if (rowsAffected > 0) {
                        messageResult = "Dados excluídos com sucesso!";
                    } else {
                        messageResult = "E-mail não encontrado em nenhum registro.";
                    }
                } else {
                    messageResult = "Erro na conexão com o banco de dados.";
                }
            } catch (SQLException e) {
                e.printStackTrace();
                messageResult = "Erro ao tentar excluir os dados.";
            } finally {
                if (stmt != null) {
                    try {
                        stmt.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        } else {
            messageResult = "Por favor, forneça um e-mail válido.";
        }
    }
%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Excluir Dados do Cliente</title>
    <link rel="stylesheet" href="../css/excluir.css">
    <script>
        // Exibir o pop-up se houver uma mensagem de resultado
        <% if (!messageResult.isEmpty()) { %>
            alert("<%= messageResult %>");
        <% } %>
    </script>
</head>
<body>
    <div class="container">
        <h1>Excluir Dados do Cliente</h1>
        <form action="" method="post">
            <label for="email">Digite o e-mail do cliente:</label><br>
            <input type="email" id="email" name="email" required placeholder="Digite o e-mail">
            <br>
            <input type="submit" value="Excluir">
            <a href="admin-dashboard.jsp" class="button">Voltar ao Painel de Controle</a>
        </form>
    </div>
</body>
</html>
