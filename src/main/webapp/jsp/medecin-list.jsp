<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.mycompany.visitesmedical.models.Medecin" %>

<html>
<head>
    <title>Liste des Médecins</title>
    <!-- Bootstrap CSS -->
    <link href="<%= request.getContextPath() %>/assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="<%= request.getContextPath() %>/assets/js/bootstrap.bundle.min.js" defer></script>
</head>

<body class="bg-light">

    <div class="container mt-5">
        <h1 class="text-center text-primary">Liste des Médecins</h1>

        <!-- Affichage des messages -->
        <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
        <% if (errorMessage != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <% String successMessage = (String) request.getAttribute("successMessage"); %>
        <% if (successMessage != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= successMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <!-- Bouton Ajouter un médecin -->
        <div class="d-flex justify-content-end mb-3">
            <a href="medecin?action=new" class="btn btn-primary">
                <i class="bi bi-plus-lg"></i> Ajouter un médecin
            </a>
        </div>

        <%
        List<Medecin> listMedecin = (List<Medecin>) request.getAttribute("listMedecin");
        if (listMedecin != null && !listMedecin.isEmpty()) {
        %>
        <!-- Tableau Bootstrap -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Nom</th>
                        <th>Prénom</th>
                        <th>Grade</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Medecin m : listMedecin) { %>
                    <tr>
                        <td><%= m.getCodemed() %></td>
                        <td><%= m.getNom() %></td>
                        <td><%= m.getPrenom() %></td>
                        <td><%= m.getGrade() %></td>
                        <td>
                            <a href="medecin?action=edit&codemed=<%= m.getCodemed() %>" class="btn btn-sm btn-warning">
                                <i class="bi bi-pencil"></i> Modifier
                            </a>
                            <a href="medecin?action=delete&id=<%= m.getCodemed() %>" class="btn btn-sm btn-danger"
                               onclick="return confirm('Voulez-vous vraiment supprimer ce médecin ?');">
                                <i class="bi bi-trash"></i> Supprimer
                            </a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
            <p class="text-center text-muted">Aucun médecin trouvé.</p>
        <% } %>
    </div>

</body>
</html>
