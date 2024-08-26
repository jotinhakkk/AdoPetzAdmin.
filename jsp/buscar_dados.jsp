<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page contentType="text/html; charset=UTF-8" %>
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
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../css/buscar_dados.css">
    <title>Buscar Clientes</title>
    
</head>
<body>
    <div class="container">
        <h1>Lista de Clientes</h1>
        
        <input type="text" id="searchInput" onkeyup="filterTable()" placeholder="Digite para pesquisar...">
        
        <table id="clientsTable">
            <thead>
                <tr>
                    <th>Nome</th>
                    <th>Email</th>
                    <th>Telefone</th>
                    <th>Tipo de Pessoa</th>
                    <th>Documento</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Connection connection = null;
                    ResultSet resultSet = null;
                    PreparedStatement stmt = null;
                    String url = "jdbc:mysql://localhost:3306/meu_banco"; // Substitua com sua URL do banco
                    String user = "root"; // Substitua com seu usuário do banco
                    String password = "root"; // Substitua com sua senha do banco

                    try {
                        // Estabelece a conexão com o banco de dados
                        Class.forName("com.mysql.cj.jdbc.Driver"); // Certifique-se de ter o driver MySQL JDBC no seu classpath
                        connection = DriverManager.getConnection(url, user, password);

                        if (connection != null) {
                            // Ajuste a consulta SQL para refletir a estrutura correta das tabelas
                            String sql = "SELECT nome, email, telefone, 'Pessoa Física' AS tipo_pessoa, cpf AS documento FROM pessoafisica " +
                                         "UNION ALL " +
                                         "SELECT nome, email, telefone, 'Pessoa Jurídica' AS tipo_pessoa, cnpj AS documento FROM pessoajuridica";
                            stmt = connection.prepareStatement(sql);
                            resultSet = stmt.executeQuery();

                            if (!resultSet.isBeforeFirst()) {
                                // Nenhum dado encontrado
                                out.println("<tr><td colspan='5'>Nenhum dado encontrado.</td></tr>");
                            } else {
                                while (resultSet.next()) {
                                    String nome = resultSet.getString("nome");
                                    String email = resultSet.getString("email");
                                    String telefone = resultSet.getString("telefone");
                                    String tipoPessoa = resultSet.getString("tipo_pessoa");
                                    String documento = resultSet.getString("documento");
                %>
                <tr>
                    <td><%= nome %></td>
                    <td><%= email %></td>
                    <td><%= telefone %></td>
                    <td><%= tipoPessoa %></td>
                    <td><%= documento %></td>
                </tr>
                <% 
                                }
                            }
                        } else {
                            out.println("<tr><td colspan='5'>Erro na conexão com o banco de dados.</td></tr>");
                        }
                    } catch (ClassNotFoundException e) {
                        out.println("<tr><td colspan='5'>Driver do banco de dados não encontrado.</td></tr>");
                        e.printStackTrace();
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='5'>Erro ao executar a consulta SQL: " + e.getMessage() + "</td></tr>");
                        e.printStackTrace();
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
                        if (connection != null) {
                            try {
                                connection.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                %>
            </tbody>
        </table>
        <a href="admin-dashboard.jsp" class="button">Voltar ao Painel de Controle</a>
    </div>

    <script>
        function filterTable() {
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("searchInput");
            filter = input.value.toUpperCase();
            table = document.getElementById("clientsTable");
            tr = table.getElementsByTagName("tr");

            for (i = 1; i < tr.length; i++) {
                tr[i].style.display = "none";
                td = tr[i].getElementsByTagName("td");
                for (var j = 0; j < td.length; j++) {
                    if (td[j]) {
                        txtValue = td[j].textContent || td[j].innerText;
                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                            tr[i].style.display = "";
                            break;
                        }
                    }
                }
            }
        }
    </script>
</body>
</html>
