<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.mycompany.visitesmedical.models.Medecin" %>

<html>
<head>
    <title>Liste des Médecins</title>
    <link href="<%= request.getContextPath() %>/assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="<%= request.getContextPath() %>/assets/js/bootstrap.bundle.min.js" defer></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">

    <style>
        body {
            background-color: #f8f9fa;
        }
        .navbar {
            background: linear-gradient(45deg, #007bff, #6610f2);
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.3rem;
        }
        .table-hover tbody tr:hover {
            background-color: #f1f1f1;
        }
        .btn-custom {
            border-radius: 50px;
            padding: 10px 20px;
        }
    </style>
</head>

<body>
    <!-- Navbar -->
       <nav class="navbar navbar-expand-lg navbar-dark shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="<%= request.getContextPath() %>/">
                <i class="bi bi-hospital"></i> Visites Médicales
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/medecin"><i class="bi bi-clipboard-heart"></i> Médecins</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/patient"><i class="bi bi-people"></i> Patients</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/visiter"><i class="bi bi-people"></i> Visites</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <h1 class="text-center text-primary"><i class="bi bi-clipboard-heart"></i> Liste des Médecins</h1>

        <!-- Notifications -->
        <div id="notifications">
            <% if (session.getAttribute("successMessage") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill"></i> <%= session.getAttribute("successMessage") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% session.removeAttribute("successMessage"); %>
            <% } %>

            <% if (session.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i> <%= session.getAttribute("errorMessage") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% session.removeAttribute("errorMessage"); %>
            <% } %>
        </div>

        <!-- Bouton Ajouter un médecin -->
        <div class="d-flex justify-content-end mb-3">
            <button class="btn btn-primary btn-custom" id="btn-add">
                <i class="bi bi-person-plus-fill"></i> Ajouter un médecin
            </button>
        </div>

        <!-- Tableau des médecins -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover text-center">
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
                    <% List<Medecin> listMedecin = (List<Medecin>) request.getAttribute("listMedecin");
                    if (listMedecin != null && !listMedecin.isEmpty()) {
                        for (Medecin m : listMedecin) { %>
                            <tr>
                                <td><%= m.getCodemed() %></td>
                                <td><%= m.getNom() %></td>
                                <td><%= m.getPrenom() %></td>
                                <td><%= m.getGrade() %></td>
                                <td>
                                    <button class="btn btn-warning btn-sm btn-edit" 
                                            data-id="<%= m.getCodemed() %>"
                                            data-nom="<%= m.getNom() %>" 
                                            data-prenom="<%= m.getPrenom() %>" 
                                            data-grade="<%= m.getGrade() %>">
                                        <i class="bi bi-pencil-fill"></i>
                                    </button>
                                    <button class="btn btn-danger btn-sm btn-delete" 
                                            data-id="<%= m.getCodemed() %>">
                                        <i class="bi bi-trash-fill"></i>
                                    </button>
                                </td>
                            </tr>
                        <% }
                    } else { %>
                        <tr><td colspan="5" class="text-center text-muted">Aucun médecin trouvé.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Modal Ajout/Modification -->
    <div class="modal fade" id="medecinModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Ajouter un Médecin</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="medecin" method="post">
                        <input type="hidden" name="codemed" id="codemed">
                        <div class="mb-3">
                            <label class="form-label">Nom</label>
                            <input type="text" name="nom" id="nom" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Prénom</label>
                            <input type="text" name="prenom" id="prenom" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Grade</label>
                            <input type="text" name="grade" id="grade" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-success">Enregistrer</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

        <!-- Modal Confirmation Suppression -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirmation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Voulez-vous vraiment supprimer ce médecin ?</p>
                </div>
                <div class="modal-footer">
                    <form action="medecin?action=delete" method="post">
                        <input type="hidden" name="id" id="deleteId">
                        <button type="submit" class="btn btn-danger">Oui, supprimer</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
    document.addEventListener("DOMContentLoaded", function() {
        document.querySelectorAll('.btn-delete').forEach(button => {
            button.addEventListener('click', function() {
                document.getElementById('deleteId').value = this.dataset.id;
                new bootstrap.Modal(document.getElementById('deleteModal')).show();
            });
        });

        setTimeout(function() {
            let alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                new bootstrap.Alert(alert).close();
            });
        }, 2000);
    });
    document.querySelectorAll('.btn-edit').forEach(button => {
        button.addEventListener('click', function() {
            document.getElementById('codemed').value = this.dataset.id;
            document.getElementById('nom').value = this.dataset.nom;
            document.getElementById('prenom').value = this.dataset.prenom;
            document.getElementById('grade').value = this.dataset.grade;
            document.querySelector('.modal-title').innerText = 'Modifier un Médecin';
            new bootstrap.Modal(document.getElementById('medecinModal')).show();
        });
    });



    document.getElementById('btn-add').addEventListener('click', function() {
        document.querySelector('.modal-title').innerText = 'Ajouter un Médecin';
        document.getElementById('codemed').value = "";
        document.getElementById('nom').value = "";
        document.getElementById('prenom').value = "";
        document.getElementById('grade').value = "";
        new bootstrap.Modal(document.getElementById('medecinModal')).show();
    });
    </script>

</body>
</html>
