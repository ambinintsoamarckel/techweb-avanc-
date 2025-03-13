<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.visitesmedical.models.Medecin" %>
<jsp:useBean id="medecin" scope="request" type="com.mycompany.visitesmedical.models.Medecin"/>
<html>
<head>
    <title>Formulaire Médecin</title>
    <link href="<%= request.getContextPath() %>/assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="<%= request.getContextPath() %>/assets/js/bootstrap.bundle.min.js" defer></script>
</head>
<body class="container mt-5">

    <div class="card shadow-sm p-4">
        <%
            if (medecin == null || medecin.getCodemed() == null) {
        %>
            <h1 class="mb-4 text-primary">Ajouter un Médecin</h1>
        <%
            } else {
        %>
            <h1 class="mb-4 text-primary">Modifier le Médecin</h1>
        <%
            }
        %>

        <form action="medecin" method="post">
            <input type="hidden" name="codemed" value="<%= medecin.getCodemed() != null ? medecin.getCodemed() : "" %>">

            <div class="mb-3">
                <label class="form-label">Nom</label>
                <input type="text" name="nom" value="<%= medecin.getNom() != null ? medecin.getNom() : "" %>"
                       class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Prénoms</label>
                <input type="text" name="prenom" value="<%= medecin.getPrenom() != null ? medecin.getPrenom() : "" %>"
                       class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Grade</label>
                <input type="text" name="grade" value="<%= medecin.getGrade() != null ? medecin.getGrade() : "" %>"
                       class="form-control" required>
            </div>

            <div class="d-flex">
                <button type="submit" class="btn btn-success">
                    <%= medecin.getCodemed() == null ? "Ajouter" : "Mettre à jour" %>
                </button>
                <a href="medecin" class="btn btn-secondary ms-2">Annuler</a>
            </div>
        </form>
    </div>
</body>
</html>
