<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ include file="conexao.jsp" %>

<%@ page import="javax.servlet.http.HttpSession" %>
<%

    HttpSession Session = request.getSession(false);
    if (Session == null || Session.getAttribute("email") == null) {
        response.sendRedirect("../CadastroAdministrador/login.html");
        return;
    }
%>
<%
    String messageCadastro = ""; // Mensagens relacionadas ao cadastro
    boolean isSuccess = false; // Para controlar o sucesso da operação

    // Obtém a conexão do contexto da página
    Connection connection = (Connection) pageContext.getAttribute("messageConnection");

    if (connection != null) {
        try {
            // Verifica qual botão de submit foi pressionado
            if (request.getParameter("submit1") != null) {
                // Dados do formulário de pessoa física
                String nome = request.getParameter("nome");
                String email = request.getParameter("email");
                String cpf = request.getParameter("cpf");
                String cep = request.getParameter("cep");
                String telefone = request.getParameter("telefone");
                String senha = request.getParameter("senha");
                String datanasc = request.getParameter("datanasc");
                String estado = request.getParameter("estado");
                String genero = request.getParameter("genero");

                if (nome != null && email != null && cpf != null && cep != null && telefone != null &&
                    senha != null && datanasc != null && estado != null && genero != null) {
                    
                    // Verificar comprimento do CEP
                    if (cep.length() > 9) {
                        messageCadastro = "CEP não pode ter mais de 9 caracteres.";
                    } else {
                        // Verificar se o CPF já existe
                        String checkCpfQuery = "SELECT 1 FROM pessoafisica WHERE cpf = ?";
                        try (PreparedStatement pstmt = connection.prepareStatement(checkCpfQuery)) {
                            pstmt.setString(1, cpf);

                            if (pstmt.executeQuery().next()) {
                                messageCadastro = "O CPF já está registrado.";
                            } else {
                                // Inserir dados no banco de dados
                                String insertQuery = "INSERT INTO pessoafisica (cpf, nome, email, cep, telefone, senha, datanasc, estado, genero) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                                try (PreparedStatement pstmtInsert = connection.prepareStatement(insertQuery)) {
                                    pstmtInsert.setString(1, cpf);
                                    pstmtInsert.setString(2, nome);
                                    pstmtInsert.setString(3, email);
                                    pstmtInsert.setString(4, cep);
                                    pstmtInsert.setString(5, telefone);
                                    pstmtInsert.setString(6, senha);
                                    pstmtInsert.setString(7, datanasc);
                                    pstmtInsert.setString(8, estado);
                                    pstmtInsert.setString(9, genero);

                                    if (pstmtInsert.executeUpdate() > 0) {
                                        isSuccess = true;
                                        messageCadastro = "Cadastro realizado com sucesso!";
                                    } else {
                                        messageCadastro = "Erro ao inserir registro.";
                                    }
                                }
                            }
                        }
                    }
                } else {
                    messageCadastro = "Todos os campos obrigatórios devem ser preenchidos.";
                }
            } else if (request.getParameter("submit2") != null) {
                // Dados do formulário de pessoa jurídica
                String nome = request.getParameter("nome");
                String email = request.getParameter("email");
                String cnpj = request.getParameter("cnpj");
                String cep = request.getParameter("cep");
                String telefone = request.getParameter("telefone");
                String senha = request.getParameter("senha");
                String estado = request.getParameter("estado");

                if (nome != null && email != null && cnpj != null && cep != null && telefone != null && senha != null && estado != null) {
                    
                    // Verificar comprimento do CEP
                    if (cep.length() > 9) {
                        messageCadastro = "CEP não pode ter mais de 9 caracteres.";
                    } else {
                        // Verificar se o CNPJ já existe
                        String checkCnpjQuery = "SELECT 1 FROM pessoajuridica WHERE cnpj = ?";
                        try (PreparedStatement pstmt = connection.prepareStatement(checkCnpjQuery)) {
                            pstmt.setString(1, cnpj);

                            if (pstmt.executeQuery().next()) {
                                messageCadastro = "O CNPJ já está registrado.";
                            } else {
                                // Inserir dados no banco de dados
                                String insertQuery = "INSERT INTO pessoajuridica (cnpj, nome, email, cep, telefone, senha, estado) VALUES (?, ?, ?, ?, ?, ?, ?)";
                                try (PreparedStatement pstmtInsert = connection.prepareStatement(insertQuery)) {
                                    pstmtInsert.setString(1, cnpj);
                                    pstmtInsert.setString(2, nome);
                                    pstmtInsert.setString(3, email);
                                    pstmtInsert.setString(4, cep);
                                    pstmtInsert.setString(5, telefone);
                                    pstmtInsert.setString(6, senha);
                                    pstmtInsert.setString(7, estado);

                                    if (pstmtInsert.executeUpdate() > 0) {
                                        isSuccess = true;
                                        messageCadastro = "Cadastro realizado com sucesso!";
                                    } else {
                                        messageCadastro = "Erro ao inserir registro.";
                                    }
                                }
                            }
                        }
                    }
                } else {
                    messageCadastro = "Todos os campos obrigatórios devem ser preenchidos.";
                }
            } else {
                messageCadastro = "Tipo de pessoa inválido.";
            }
        } catch (SQLException e) {
            messageCadastro = "Erro: " + e.getMessage();
            e.printStackTrace();
        }
    } else {
        messageCadastro = "Não foi possível estabelecer uma conexão com o banco de dados.";
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../css/cadastro.css">
    <title>Cadastro</title>
    <link rel="shortcut icon" href="../Images/favicon.ico" type="image/x-icon">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap" rel="stylesheet">
    <script src="../CadastroCliente/js/alterarFormulario.js"></script>
</head>
<body>
   
    <div class="container">
        <div class="login">
            <h1>Cadastro</h1>
            
            <div class="radio-buttons">
                <div class="radio-labels">
                    <label for="pessoaFisica">Pessoa Física</label>
                    <label for="pessoaJuridica">Pessoa Jurídica</label>
                </div>
                <div class="radio-inputs">
                    <input type="radio" id="pessoaFisica" name="tipoPessoa" value="pessoafisica" onclick="alterarFormulario()" checked>
                    <input type="radio" id="pessoaJuridica" name="tipoPessoa" value="pessoajuridica" onclick="alterarFormulario()">
                </div>
            </div>

            <h3>Insira os Dados</h3>
            
            <!-- Formulário Pessoa Física -->
            <form id="formPessoaFisica" action="<%= request.getRequestURI() %>" method="post" style="display: none;">
                <input type="text" placeholder="Nome" id="nomePF" name="nome" required>
                <input type="email" placeholder="E-mail" id="emailPF" name="email" required>
                <input type="text" placeholder="CPF" id="cpfPF" name="cpf" required oninput="formatarCPF(this)" maxlength="14">
                <input type="text" placeholder="CEP" id="cepPF" name="cep" required>
                <input type="tel" placeholder="Ex: (21) 12345-6789" id="telefonePF" name="telefone" required>
                <input type="password" placeholder="Senha" id="senhaPF" name="senha" required>
                <input type="date" id="datanascPF" name="datanasc" required>
                <div class="labels-container">
                    <label for="estadoPF">Estado:</label>
                     <select id="estadoPF" name="estado" required>
                     <option value="">Selecione o Estado</option>
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
                    <label for="generoPF">Gênero:</label>
                    <select id="generoPF" name="genero" required>
                        <option value="">Selecione o Gênero</option>
                        <option value="Masculino">Masculino</option>
                        <option value="Feminino">Feminino</option>
                        <option value="Outro">Outro</option>
                        <option value="Prefiro não dizer">Prefiro não dizer</option>
                    </select>
                </div>
               
                 
                </div>
                <button type="submit" name="submit1">Cadastrar</button>
            </form>
            
            <!-- Formulário Pessoa Jurídica -->
            <form id="formPessoaJuridica" action="<%= request.getRequestURI() %>" method="post" style="display: none;">
                <input type="text" placeholder="Razão Social" id="nomePJ" name="nome" required>
                <input type="email" placeholder="E-mail" id="emailPJ" name="email" required>
                <input type="text" placeholder="CNPJ" id="cnpjPJ" name="cnpj" required oninput="formatarCNPJ(this)" maxlength="18">
                <input type="text" placeholder="CEP" id="cepPJ" name="cep" required>
                <input type="tel" placeholder="Ex: (21) 12345-6789" id="telefonePJ" name="telefone" required>
                <input type="password" placeholder="Senha" id="senhaPJ" name="senha" required>
                <label for="estadoPJ">Estado:</label>
                <select id="estadoPJ" name="estado" required>
                    <option value="">Selecione o Estado</option>
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
                    <!-- Opções do select... -->
                </select>
                <button type="submit" name="submit2">Cadastre-se</button>
            </form>
            
            <br>
             <a href="admin-dashboard.jsp" class="button">Voltar ao Painel de Controle</a>
        </div>
    </div>
    <script>
        // Exibe a mensagem em um pop-up se houver uma mensagem de cadastro
        <%= isSuccess ? "alert('" + messageCadastro.replace("'", "\\'") + "');" : "" %>
    </script>
</body>
</html>
