<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    // Inicializa a variável de mensagem de erro
    String messageError = "";
    String email = request.getParameter("email");
    String senha = request.getParameter("senha");
    HttpSession userSession = request.getSession();
    Connection connection = null;

    if (request.getMethod().equalsIgnoreCase("POST")) {
        if (email != null && senha != null && !email.trim().isEmpty() && !senha.trim().isEmpty()) {
            try {
                String dbUrl = "jdbc:mysql://localhost:3306/meu_banco";
                String dbUser = "root";
                String dbPassword = "root";

                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

                if (connection != null && !connection.isClosed()) {
                    String sql = "SELECT senha FROM administrador WHERE email = ?";
                    PreparedStatement stmt = connection.prepareStatement(sql);
                    stmt.setString(1, email);
                    ResultSet resultSet = stmt.executeQuery();

                    if (resultSet.next()) {
                        String storedPassword = resultSet.getString("senha");
                        if (senha.equals(storedPassword)) {
                            userSession.setAttribute("email", email);
                            userSession.setAttribute("tipo", "admin");
                            response.sendRedirect("admin-dashboard.jsp");
                            return;
                        } else {
                            messageError = "E-mail ou senha incorretos.";
                        }
                    } else {
                        messageError = "E-mail não encontrado.";
                    }
                } else {
                    messageError = "Erro ao conectar com o banco de dados: conexão fechada.";
                }

            } catch (Exception e) {
                e.printStackTrace();
                messageError = "Erro ao conectar com o banco de dados: " + e.getMessage();
            } finally {
                if (connection != null) {
                    try {
                        connection.close();
                    } catch (Exception e) {
                        messageError = "Erro ao fechar a conexão: " + e.getMessage();
                    }
                }
            }
        } else {
            messageError = "Por favor, preencha todos os campos.";
        }
    }
    %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../CadastroCliente/css/login.css">
    <title>Resultado do Login</title>
</head>
<body>
    <div class="container">
        <h1>Resultado do Login</h1>
        <div id="error-message">
            <%= request.getAttribute("messageError") %>
        </div>
        <a href="../CadastroAdministrador/login.html">Voltar ao Login</a>
    </div>
</body>
</html>