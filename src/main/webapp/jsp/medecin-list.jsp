<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.mycompany.visitesmedical.models.Medecin" %>

<html>
<head>
    <title>Liste des Médecins</title>
    <link href="<%= request.getContextPath() %>/assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="<%= request.getContextPath() %>/assets/js/bootstrap.bundle.min.js" defer></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
</head>

<body class="bg-light">
    <div class="container mt-5">
        <h1 class="text-center text-primary"><i class="bi bi-clipboard-heart"></i> Liste des Médecins</h1>

        <!-- Notifications -->
        <div id="notifications">
            <% if (session.getAttribute("successMessage") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill"></i> <%= session.getAttribute("successMessage") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("successMessage"); %>
            <% } %>

            <% if (session.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i> <%= session.getAttribute("errorMessage") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% session.removeAttribute("errorMessage"); %>
            <% } %>
        </div>

        <!-- Bouton Ajouter un médecin -->
        <div class="d-flex justify-content-end mb-3">
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#medecinModal">
                <i class="bi bi-person-plus-fill"></i> Ajouter un médecin
            </button>
        </div>

        <!-- Tableau des médecins -->
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
                    <% List<Medecin> listMedecin = (List<Medecin>) request.getAttribute("listMedecin");
                    if (listMedecin != null && !listMedecin.isEmpty()) {
                        for (Medecin m : listMedecin) { %>
                            <tr>
                                <td><%= m.getCodemed() %></td>
                                <td><%= m.getNom() %></td>
                                <td><%= m.getPrenom() %></td>
                                <td><%= m.getGrade() %></td>
                                <td>
                                    <button class="btn btn-sm btn-warning btn-edit" data-id="<%= m.getCodemed() %>"
                                            data-nom="<%= m.getNom() %>" data-prenom="<%= m.getPrenom() %>" 
                                            data-grade="<%= m.getGrade() %>">
                                        <i class="bi bi-pencil-fill"></i> Modifier
                                    </button>
                                    <button class="btn btn-sm btn-danger btn-delete" data-id="<%= m.getCodemed() %>">
                                        <i class="bi bi-trash-fill"></i> Supprimer
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
                    <h5 class="modal-title" id="modalTitle">Ajouter un Médecin</h5>
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

                        <div class="d-flex">
                            <button type="submit" class="btn btn-success">Enregistrer</button>
                            <button type="button" class="btn btn-secondary ms-2" data-bs-dismiss="modal">Annuler</button>
                        </div>
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

    <!-- Scripts pour gérer les modals -->
    <script>
        document.querySelectorAll('.btn-edit').forEach(button => {
            button.addEventListener('click', function() {
                document.getElementById('codemed').value = this.dataset.id;
                document.getElementById('nom').value = this.dataset.nom;
                document.getElementById('prenom').value = this.dataset.prenom;
                document.getElementById('grade').value = this.dataset.grade;
                document.getElementById('modalTitle').innerText = 'Modifier un Médecin';
                new bootstrap.Modal(document.getElementById('medecinModal')).show();
            });
        });

        document.querySelectorAll('.btn-delete').forEach(button => {
            button.addEventListener('click', function() {
                document.getElementById('deleteId').value = this.dataset.id;
                new bootstrap.Modal(document.getElementById('deleteModal')).show();
            });
        });
    </script>
</body>
</html>
