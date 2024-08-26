<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ include file="conexao.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%

    HttpSession Session = request.getSession(false);
    if (Session == null || Session.getAttribute("email") == null) {
        response.sendRedirect("../CadastroCliente/login.html");
        return;
    }
%>
<%
    String email = request.getParameter("email");
    String nome = request.getParameter("nome");
    String cpfCnpj = request.getParameter("cpf_cnpj");
    String cep = request.getParameter("cep");
    String telefone = request.getParameter("telefone");
    String senha = request.getParameter("senha");
    String estado = request.getParameter("estado");
    String genero = request.getParameter("genero");
    Connection connection = (Connection) pageContext.getAttribute("messageConnection");

    String statusMessage = "";

    if (request.getMethod().equalsIgnoreCase("POST") && email != null && !email.isEmpty()) {
        try {
            if (connection != null) {
                boolean emailExistente = false;

                // Verificar se o e-mail existe na tabela de Pessoa Física
                String sql = "SELECT 1 FROM pessoafisica WHERE email = ?";
                PreparedStatement stmt = connection.prepareStatement(sql);
                stmt.setString(1, email);
                ResultSet resultSet = stmt.executeQuery();

                if (resultSet.next()) {
                    // Atualizar dados na tabela de Pessoa Física
                    sql = "UPDATE pessoafisica SET nome = ?, cpf = ?, cep = ?, telefone = ?, senha = ?, estado = ?, genero = ? WHERE email = ?";
                    PreparedStatement updateStmt = connection.prepareStatement(sql);
                    updateStmt.setString(1, nome);
                    updateStmt.setString(2, cpfCnpj); // Assume que é CPF
                    updateStmt.setString(3, cep);
                    updateStmt.setString(4, telefone);
                    updateStmt.setString(5, senha);
                    updateStmt.setString(6, estado);
                    updateStmt.setString(7, genero);
                    updateStmt.setString(8, email);
                    int rowsUpdated = updateStmt.executeUpdate();
                    emailExistente = true;
                } else {
                    // Verificar se o e-mail existe na tabela de Pessoa Jurídica
                    sql = "SELECT 1 FROM pessoajuridica WHERE email = ?";
                    stmt = connection.prepareStatement(sql);
                    stmt.setString(1, email);
                    resultSet = stmt.executeQuery();

                    if (resultSet.next()) {
                        // Atualizar dados na tabela de Pessoa Jurídica
                        sql = "UPDATE pessoajuridica SET nome = ?, cnpj = ?, cep = ?, telefone = ?, senha = ?, estado = ? WHERE email = ?";
                        PreparedStatement updateStmt = connection.prepareStatement(sql);
                        updateStmt.setString(1, nome);
                        updateStmt.setString(2, cpfCnpj); // Assume que é CNPJ
                        updateStmt.setString(3, cep);
                        updateStmt.setString(4, telefone);
                        updateStmt.setString(5, senha);
                        updateStmt.setString(6, estado);
                        updateStmt.setString(7, email);
                        int rowsUpdated = updateStmt.executeUpdate();
                        emailExistente = true;
                    }
                }

                if (emailExistente) {
                    statusMessage = "success";
                } else {
                    statusMessage = "email_not_found";
                }
            } else {
                statusMessage = "db_connection_error";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            statusMessage = "sql_error";
        }
    } else {
        statusMessage = "missing_fields";
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atualizar Dados</title>
    <link rel="stylesheet" href="../css/redefinir.css">
    <script src="../CadastroCliente/js/alterarFormulario.js" defer></script>
  
</head>
<body>
    
    <div class="container form-container">
        <h1>Atualizar Dados</h1>
        <form id="formSelector">
            <div class="radio-buttons">
                <input type="radio" id="pessoaFisica" name="tipoPessoa" value="pessoafisica" onclick="alterarFormulario()" checked>
                <label for="pessoaFisica">Pessoa Física</label>
                <input type="radio" id="pessoaJuridica" name="tipoPessoa" value="pessoajuridica" onclick="alterarFormulario()">
                <label for="pessoaJuridica">Pessoa Jurídica</label>
            </div>
        </form>

        <!-- Formulário Pessoa Física -->
        <form id="formPessoaFisica" action="redefinir_dados.jsp" method="post">
            <input type="email" placeholder="Email" id="emailPF" name="email" required>
            <input type="text" placeholder="Nome" id="nomePF" name="nome" required>
            <input type="text" placeholder="CPF" id="cpfPF" name="cpf_cnpj" required maxlength="14">
            <input type="text" placeholder="CEP" id="cepPF" name="cep" required>
            <input type="tel" placeholder="Telefone" id="telefonePF" name="telefone" required>
            <input type="password" placeholder="Senha" id="senhaPF" name="senha" required>
            <select id="estadoPF" name="estado" required>
                <option value="">Selecione o Estado</option>
                    <option value="AC">Acre</option>
                    <option value="AL">Alagoas</option>
                    <option value="AP">Amapá</option>
                    <option value="AM">Amazonas</option>
                    <option value="BA">Bahia</option>
                    <option value="CE">Ceará</option>
                    <option value="DF">Distrito Federal</option>
                    <option value="ES">Espírito Santo</option>
                    <option value="GO">Goiás</option>
                    <option value="MA">Maranhão</option>
                    <option value="MT">Mato Grosso</option>
                    <option value="MS">Mato Grosso do Sul</option>
                    <option value="MG">Minas Gerais</option>
                    <option value="PA">Pará</option>
                    <option value="PB">Paraíba</option>
                    <option value="PR">Paraná</option>
                    <option value="PE">Pernambuco</option>
                    <option value="PI">Piauí</option>
                    <option value="RJ">Rio de Janeiro</option>
                    <option value="RN">Rio Grande do Norte</option>
                    <option value="RS">Rio Grande do Sul</option>
                    <option value="RO">Rondônia</option>
                    <option value="RR">Roraima</option>
                    <option value="SC">Santa Catarina</option>
                    <option value="SP">São Paulo</option>
                    <option value="SE">Sergipe</option>
                    <option value="TO">Tocantins</option> 
                <!-- Outros estados... -->
            </select>
            <select id="generoPF" name="genero" required>
                <option value="">Selecione o Gênero</option>
                <option value="Masculino">Masculino</option>
                <option value="Feminino">Feminino</option>
                <option value="Outro">Outro</option>
                <option value="Prefiro não dizer">Prefiro não dizer</option>
            </select>
            <button class="inputSubmit" type="submit">Atualizar Dados</button>
            <a href="admin-dashboard.jsp" class="button">Voltar ao Painel de Controle</a>
        </form>

        <!-- Formulário Pessoa Jurídica -->
        <form id="formPessoaJuridica" action="redefinir_dados.jsp" method="post" style="display: none;">
            <input type="email" placeholder="Email" id="emailPJ" name="email" required>
            <input type="text" placeholder="Razão Social" id="nomePJ" name="nome" required>
            <input type="text" placeholder="CNPJ" id="cnpjPJ" name="cpf_cnpj" required maxlength="18">
            <input type="text" placeholder="CEP" id="cepPJ" name="cep" required>
            <input type="tel" placeholder="Telefone" id="telefonePJ" name="telefone" required>
            <input type="password" placeholder="Senha" id="senhaPJ" name="senha" required>
            <select id="estadoPJ" name="estado" required>
                <option value="">Selecione o Estado</option>
                    <option value="AC">Acre</option>
                    <option value="AL">Alagoas</option>
                    <option value="AP">Amapá</option>
                    <option value="AM">Amazonas</option>
                    <option value="BA">Bahia</option>
                    <option value="CE">Ceará</option>
                    <option value="DF">Distrito Federal</option>
                    <option value="ES">Espírito Santo</option>
                    <option value="GO">Goiás</option>
                    <option value="MA">Maranhão</option>
                    <option value="MT">Mato Grosso</option>
                    <option value="MS">Mato Grosso do Sul</option>
                    <option value="MG">Minas Gerais</option>
                    <option value="PA">Pará</option>
                    <option value="PB">Paraíba</option>
                    <option value="PR">Paraná</option>
                    <option value="PE">Pernambuco</option>
                    <option value="PI">Piauí</option>
                    <option value="RJ">Rio de Janeiro</option>
                    <option value="RN">Rio Grande do Norte</option>
                    <option value="RS">Rio Grande do Sul</option>
                    <option value="RO">Rondônia</option>
                    <option value="RR">Roraima</option>
                    <option value="SC">Santa Catarina</option>
                    <option value="SP">São Paulo</option>
                    <option value="SE">Sergipe</option>
                    <option value="TO">Tocantins</option> 
                
            </select>
            <button class="inputSubmit" type="submit">Atualizar Dados</button>
            <a href="admin-dashboard.jsp" class="button">Voltar ao Painel de Controle</a>
        </form>
    </div>
      <script>
        // Função para mostrar a mensagem de resultado do JSP
        function showMessage() {
            const status = '<%= statusMessage %>';

            if (status === 'success') {
                alert('Dados atualizados com sucesso!');
            } else if (status === 'email_not_found') {
                alert('E-mail não encontrado.');
            } else if (status === 'db_connection_error') {
                alert('Erro na conexão com o banco de dados.');
            } else if (status === 'sql_error') {
                alert('Erro ao executar a operação no banco de dados.');
            
        }
        window.onload = showMessage;
    </script>
</body>
</html>
