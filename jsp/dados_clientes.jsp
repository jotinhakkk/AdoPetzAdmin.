<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ include file="conexao.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession Session = request.getSession(false);
    if (Session == null || Session.getAttribute("email") == null) {
        response.sendRedirect("../CadastroCliente/login.html");
        return;
    }

    String email = request.getParameter("email");
    String message = "";

    Connection connection = (Connection) pageContext.getAttribute("messageConnection");
    if (email != null && !email.isEmpty()) {
        PreparedStatement stmt = null;
        ResultSet resultSet = null;
        try {
            if (connection != null) {
                String sql = "SELECT * FROM pessoafisica WHERE email = ?";
                stmt = connection.prepareStatement(sql);
                stmt.setString(1, email);
                resultSet = stmt.executeQuery();

                if (resultSet.next()) {
                    String cpf = resultSet.getString("cpf");
                    String nome = resultSet.getString("nome");
                    String telefone = resultSet.getString("telefone");
                    String senha = resultSet.getString("senha");
                    String cep = resultSet.getString("cep");
                    String datanasc = resultSet.getString("datanasc");
                    String estado = resultSet.getString("estado");
                    String genero = resultSet.getString("genero");

                    message = "CPF: " + cpf + "\\n" +
                              "Nome: " + nome + "\\n" +
                              "Email: " + email + "\\n" +
                              "Telefone: " + telefone + "\\n" +
                              "CEP: " + cep + "\\n" +
                              "Data de Nascimento: " + datanasc + "\\n" +
                              "Estado: " + estado + "\\n" +
                              "Gênero: " + genero + "\\n" +
                              "Senha: " + senha;
                } else {
                    sql = "SELECT * FROM pessoajuridica WHERE email = ?";
                    stmt = connection.prepareStatement(sql);
                    stmt.setString(1, email);
                    resultSet = stmt.executeQuery();

                    if (resultSet.next()) {
                        String nome = resultSet.getString("nome");
                        String telefone = resultSet.getString("telefone");
                        String senha = resultSet.getString("senha");
                        String cnpj = resultSet.getString("cnpj");

                        message = "Nome: " + nome + "\\n" +
                                  "Email: " + email + "\\n" +
                                  "Telefone: " + telefone + "\\n" +
                                  "CNPJ: " + cnpj + "\\n" +
                                  "Senha: " + senha;
                    } else {
                        message = "E-mail não encontrado.";
                    }
                }
            } else {
                message = "Erro na conexão com o banco de dados.";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            message = "Erro ao consultar dados.";
        } finally {
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buscar Cliente</title>
    <link rel="stylesheet" href="../css/buscar.css">
   
</head>
<body>
    <div class="container">
        <h1>Buscar Dados do Cliente</h1>
        <form action="dados_clientes.jsp" method="get">
            <label for="email">Digite o e-mail do cliente:</label><br>
            <input type="email" id="email" name="email" required placeholder="Digite o e-mail" aria-required="true">
            <br>
            <input type="submit" value="Buscar">
        </form>
        <a href="admin-dashboard.jsp" class="button">Voltar ao Painel de Controle</a>
    </div>
     <script>
        // Exibir o pop-up se houver uma mensagem
        <% if (!message.isEmpty()) { %>
            alert("<%= message %>");
        <% } %>
    </script>
</body>
</html>
