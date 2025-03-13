<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.mycompany.visitesmedical.models.Patient,  com.mycompany.visitesmedical.models.Medecin" %>

<html>
<head>
    <title>Liste des Patients</title>
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
        <h1 class="text-center text-primary mt-5 mb-5"><i class="bi bi-people"></i> Liste des Patients</h1>
         <!-- Filtres -->
		<div class="row mb-3">
		    <div class="col-md-5">
		        <input type="text" id="fi" name="fi" class="form-control" required onkeyup="filtrerPatients()">        
		    </div>
		    <div class="col-md-5">
			<select id="listeFiltre" class="form-select" onchange="filtrerPatients()">
			    <option value="codepat">Code Patient</option>
			    <option value="nom">Nom</option>
			</select>

		    </div>
		</div>
		


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

        <div class="d-flex justify-content-start mb-3">
		    <button class="btn btn-success btn-custom" id="btn-add">
		        <i class="bi bi-plus-circle"></i> Nouveau
		    </button>
		</div>

        <div class="table-responsive">
            <table class="table table-bordered table-hover text-center">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Nom</th>
                        <th>Prénom</th>
                        <th>Sexe</th>
                        <th>Adresse</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% List<Patient> listPatient = (List<Patient>) request.getAttribute("patients");
                    if (listPatient != null && !listPatient.isEmpty()) {
                        for (Patient p : listPatient) { %>
                            <tr>
                                <td><%= p.getCodepat() %></td>
                                <td><%= p.getNom() %></td>
                                <td><%= p.getPrenom() %></td>
                                <td><%= p.getSexe() %></td>
                                <td><%= p.getAdresse() %></td>
                                <td>
                                    <button class="btn btn-sm btn-edit" 
                                            data-id="<%= p.getCodepat() %>"
                                            data-nom="<%= p.getNom() %>" 
                                            data-sexe="<%= p.getSexe() %>"
                                            data-prenom="<%= p.getPrenom() %>" 
                                            data-adresse="<%= p.getAdresse() %>">
                                        <i class="bi bi-pencil-fill text-warning fs-5"></i>
                                    </button>
                                    <button class="btn btn-sm btn-add-visite" 
								            data-id="<%= p.getCodepat() %>"
								            data-nom="<%= p.getNom() %>" 
								            data-prenom="<%= p.getPrenom() %>">
								        <i class="bi bi-calendar-plus text-info fs-5"></i>
								    </button>
                                    <button class="btn btn-sm btn-delete" 
                                            data-id="<%= p.getCodepat() %>">
                                        <i class="bi bi-trash-fill text-danger fs-5"></i>
                                    </button>
                                </td>
                            </tr>
                        <% }
                    } else { %>
                        <tr><td colspan="5" class="text-center text-muted">Aucun patient trouvé.</td></tr>
                    <% } %>
                </tbody>
            </table>
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
                    <p>Voulez-vous vraiment supprimer ce patient ?</p>
                </div>
                <div class="modal-footer">
                    <form action="patient?action=delete" method="post">
                        <input type="hidden" name="id" id="deleteId">
                        <button type="submit" class="btn btn-danger">Oui, supprimer</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal d'ajout et modification -->
    <div class="modal fade" id="patientModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Ajouter un Patient</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="patient" method="post">
                        <div class="mb-3">
                        <label class="form-label">Code Patient</label>
                        <input type="text" id="codepat" name="codepat"  class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Nom</label>
                            <input type="text" id="nom" name="nom" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Prénom</label>
                            <input type="text" id="prenom" name="prenom" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Sexe</label>
                            <select id="sexe" name="sexe" class="form-select">
                                <option value="Homme">Homme</option>
                                <option value="Femme">Femme</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Adresse</label>
                            <input type="text" id="adresse" name="adresse" class="form-control">
                        </div>
                        <div class="d-flex justify-content-end gap-2">
	                        <button type="submit" class="btn btn-success w-25">Enregistrer</button>
	                        <button type="button" class="btn btn-secondary w-25" data-bs-dismiss="modal">Annuler</button>
                    	</div>
                    </form>
                </div>
            </div>
        </div>
    </div>
        <!-- Modal de modification -->
    <div class="modal fade" id="patientModalm" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Modifier un Patient</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="patient?action=update" method="post">
                        <div class="mb-3">
                        <label class="form-label">Code Patient</label>
                        <input type="text" id="codepatm" name="codepat"  class="form-control" required readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Nom</label>
                            <input type="text" id="nomm" name="nom" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Prénom</label>
                            <input type="text" id="prenomm" name="prenom" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Sexe</label>
                            <select id="sexem" name="sexe" class="form-select">
                                <option value="Homme">Homme</option>
                                <option value="Femme">Femme</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Adresse</label>
                            <input type="text" id="adressem" name="adresse" class="form-control">
                        </div>
                        <div class="d-flex justify-content-end gap-2">
	                        <button type="submit" class="btn btn-success w-25">Enregistrer</button>
	                        <button type="button" class="btn btn-secondary w-25" data-bs-dismiss="modal">Annuler</button>
                    	</div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal d'ajout de visite -->
<div class="modal fade" id="addVisiteModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Ajouter une visite</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="visiter" method="post">
                    <input type="hidden" id="patientId" name="patient">
                    <div class="mb-3">
                        <label class="form-label">Patient</label>
                        <input type="text" id="patientNomPrenom" class="form-control" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Médecin</label>
                        <select class="form-select" name="medecin" id="medecin" required>
                            <% 
                            List<Medecin> medecins = (List<Medecin>) request.getAttribute("medecins");
                            if (medecins != null) {
                                for (Medecin m : medecins) { 
                            %>
                                <option value="<%= m.getCodemed() %>"><%= m.getNom() %> <%= m.getPrenom() %></option>
                            <% 
                                }
                            }
                            %>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-success">Enregistrer la visite</button>
                </form>
            </div>
        </div>
    </div>
</div>

    <script>
    function attachEventListeners() {
        // Gestion du bouton d'édition
        document.querySelectorAll(".btn-edit").forEach(button => {
            button.addEventListener("click", function () {
                document.getElementById("codepat").value = this.dataset.id;
                document.getElementById("nom").value = this.dataset.nom;
                document.getElementById("prenom").value = this.dataset.prenom;
                document.getElementById("sexe").value = this.dataset.sexe;
                document.getElementById("adresse").value = this.dataset.adresse;
                new bootstrap.Modal(document.getElementById("patientModal")).show();
            });
        });
        document.querySelectorAll('.btn-add-visite').forEach(button => {
            button.addEventListener('click', function() {
                document.getElementById('patientId').value = this.dataset.id;
                document.getElementById('patientNomPrenom').value = this.dataset.nom + ' ' + this.dataset.prenom;
                
                new bootstrap.Modal(document.getElementById('addVisiteModal')).show();
            });
        });

        // Gestion du bouton de suppression
        document.querySelectorAll(".btn-delete").forEach(button => {
            button.addEventListener("click", function () {
                document.getElementById("deleteId").value = this.dataset.id;
                new bootstrap.Modal(document.getElementById("deleteModal")).show();
            });
        });
    }

    // Fonction pour filtrer les patients
    function filtrerPatients() {
        let filtre = document.getElementById("listeFiltre").value;
        let valeur = document.getElementById("fi").value;
        
        fetch("patient?action=search&critere=" + filtre + "&valeur=" + valeur)
            .then(response => response.text())
            .then(data => {
                document.querySelector("tbody").innerHTML = data;
                attachEventListeners(); // Réattacher les événements après mise à jour
            })
            .catch(error => console.error("Erreur lors du filtrage :", error));
    }

    document.addEventListener("DOMContentLoaded", function() {
    	   attachEventListeners();
        document.querySelectorAll('.btn-edit').forEach(button => {
            button.addEventListener('click', function() {
                document.getElementById('codepatm').value = this.dataset.id;
                document.getElementById('nomm').value = this.dataset.nom;
                document.getElementById('sexem').value = this.dataset.sexe;
                document.getElementById('prenomm').value = this.dataset.prenom;
                document.getElementById('adressem').value = this.dataset.adresse;
                document.querySelector('.modal-title').innerText = 'Modifier un Patient';
                new bootstrap.Modal(document.getElementById('patientModalm')).show();
            });
        });

        document.querySelectorAll('.btn-add-visite').forEach(button => {
            button.addEventListener('click', function() {
                document.getElementById('patientId').value = this.dataset.id;
                document.getElementById('patientNomPrenom').value = this.dataset.nom + ' ' + this.dataset.prenom;
                
                new bootstrap.Modal(document.getElementById('addVisiteModal')).show();
            });
        });
   
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

        document.getElementById('btn-add').addEventListener('click', function() {
            document.querySelector('.modal-title').innerText = 'Ajouter un Patient';
            document.getElementById('codepat').value = "";
            document.getElementById('nom').value = "";
            document.getElementById('prenom').value = "";
            document.getElementById('adresse').value = "";
            new bootstrap.Modal(document.getElementById('patientModal')).show();
        });


     
    });
    </script>
</body>
</html>
