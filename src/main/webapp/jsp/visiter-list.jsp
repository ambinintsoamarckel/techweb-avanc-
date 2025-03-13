<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.visitesmedical.dao.VisiterDAO,java.util.List, java.util.ArrayList, com.mycompany.visitesmedical.models.Visiter, com.mycompany.visitesmedical.models.Patient, com.mycompany.visitesmedical.models.Medecin" %>
<%@ page import="java.time.format.DateTimeFormatter, java.time.LocalDateTime" %>

<%
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<% 
// Récupération des attributs et gestion des valeurs nulles
List<Patient> patients = (List<Patient>) request.getAttribute("patients");
List<Medecin> medecins = (List<Medecin>) request.getAttribute("medecins");
List<Visiter> visites = (List<Visiter>) request.getAttribute("listVisites");
String patientParam = (String)request.getAttribute("patientParam");
String medecinParam = (String)request.getAttribute("medecinParam");


if (patients == null) patients = new ArrayList<>();
if (medecins == null) medecins = new ArrayList<>();
if (visites == null) visites = new ArrayList<>();
%>


<html>
<head>
    <title>Visites Médicales</title>
    <link href="<%= request.getContextPath() %>/assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="<%= request.getContextPath() %>/assets/js/bootstrap.bundle.min.js" defer></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">

    <style>
        body { background-color: #f8f9fa; }
        .navbar { background: linear-gradient(45deg, #007bff, #6610f2); }
        .navbar-brand { font-weight: bold; font-size: 1.3rem; }
        .card { border-radius: 10px; box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1); }
        .btn-custom { border-radius: 50px; padding: 10px 20px; }
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

        <h1 class="text-center text-primary mt-5 mb-5"><i class="bi bi-calendar-check"></i> Visites Médicales</h1>

 <!-- Filtres -->
    <div class="row mb-3">
        <div class="col-md-5">
            <select id="patientSelect" class="form-select">
                <option value="">Tout les patients</option>
                <% for (Patient p : patients) { %>
                    <option value="<%= p.getCodepat() %>"
                        <%= (patientParam != null && patientParam.equals(p.getCodepat())) ? "selected" : "" %>>
                        <%= p.getNom() %> <%= p.getPrenom() %>
                    </option>
                <% } %>
            </select>
        </div>
        <div class="col-md-5">
            <select id="medecinSelect" class="form-select">
                <option value="">Tout les médecins</option>
                <% for (Medecin m : medecins) { %>
                    <option value="<%= m.getCodemed() %>"
                        <%= (medecinParam != null && medecinParam.equals(m.getCodemed()) ? "selected" : "" %>>
                        <%= m.getNom() %> <%= m.getPrenom() %>
                    </option>
                <% } %>
            </select>
        </div>
        <div class="col-md-2">
            <button id="btnFiltrer" class="btn btn-primary w-50">
                <i class="bi bi-funnel"></i> Filtrer
            </button>
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

		<!-- Bouton Ajouter une visite -->
		<div class="d-flex justify-content-start mb-3">
		    <button class="btn btn-success btn-custom" id="btn-add">
		        <i class="bi bi-plus-circle"></i> Nouveau
		    </button>
		</div>

        <!-- Liste des visites -->
        <div class="row">
            <% if (!visites.isEmpty()) { 
                for (Visiter v : visites) { %>
                    <div class="col-md-4">
                        <div class="card p-3 mb-3">
                            <h5 class="card-title"><i class="bi bi-person"></i> <%= v.getPatient().getNom() %> <%= v.getPatient().getPrenom() %></h5>
                            <p class="card-text"><i class="bi bi-stethoscope"></i> <%= v.getMedecin().getNom() %> <%= v.getMedecin().getPrenom() %></p>
                            <p class="card-text"><i class="bi bi-calendar"></i> <%= v.getDateTime().format(formatter) %></p>
                            <div class="d-flex justify-content-between">
                                <button class="btn btn-warning btn-sm btn-edit text-white" data-medecin="<%= v.getMedecin().getCodemed() %>"
                                            data-patient="<%= v.getPatient().getCodepat() %>" 
                                            data-date="<%= v.getDateTime().format(formatter) %>"><i class="bi bi-pencil-fill"></i> Modifier</button>
                                <button class="btn btn-danger btn-sm btn-delete" data-medecin="<%= v.getMedecin().getCodemed() %>"
                                            data-patient="<%= v.getPatient().getCodepat() %>" 
                                            data-date="<%= v.getDateTime().format(formatter) %>"><i class="bi bi-trash-fill"  ></i> Supprimer</button>
                               <button class="btn btn-info btn-sm btn-details text-white"
								    data-patient-nom="<%= v.getPatient().getNom() + " " + v.getPatient().getPrenom() %>"
								    data-patient-sexe="<%= v.getPatient().getSexe() %>"
								    data-patient-adresse="<%= v.getPatient().getAdresse() %>"
								    data-medecin-nom="<%= v.getMedecin().getNom() + " " + v.getMedecin().getPrenom() %>"
								    data-medecin-grade="<%= v.getMedecin().getGrade() %>"
								    data-visite-date="<%= v.getDateTime().format(formatter) %>">
								    <i class="bi bi-eye-fill"></i> Détails
								</button>

                            </div>
                        </div>
                    </div>
            <% } } else { %>
                <p class="text-center text-muted">Aucune visite trouvée.</p>
            <% } %>
        </div>
    </div>


<!-- Modal Ajout/Modification -->
<div class="modal fade" id="visiteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Ajouter une Visite</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="visiter" method="post">
                    
                    <div class="mb-3">
                        <label class="form-label">Patient</label>
                        <select class="form-select" name="patient" id="patient" required>
                            <% for (Patient p : patients) { %>
                                <option value="<%= p.getCodepat() %>"><%= p.getNom() %> <%= p.getPrenom() %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Médecin</label>
                        <select class="form-select" name="medecin" id="medecin" required>
                            <% for (Medecin m : medecins) { %>
                                <option value="<%= m.getCodemed() %>"><%= m.getNom() %> <%= m.getPrenom() %></option>
                            <% } %>
                        </select>
                    </div>
<!--                     <div class="mb-3"> -->
<!--                         <label class="form-label">Date</label> -->
<!--                         <input type="date" class="form-control" name="dateVisite" id="dateVisite" required> -->
<!--                     </div> -->
                    <div class="d-flex justify-content-end gap-2">
                    	<button type="submit" class="btn btn-success w-25">Enregistrer</button>
                    	<button type="button" class="btn btn-secondary w-25" data-bs-dismiss="modal">Annuler</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- Modal Modification -->

<div class="modal fade" id="visiteModaledit" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Modifier une Visite</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="visiter?action=update" method="post">
				    <input type="hidden" name="oldCodemed" id="codemededit">
				    <input type="hidden" name="oldCodepat" id="codepatedit">
				    <input type="hidden" name="oldDateVisite" id="dateVisiteHidden">
				    
				    <div class="mb-3">
				        <label class="form-label">Patient</label>
				        <select class="form-select" name="patient" id="patientedit" required>
				            <% for (Patient p : patients) { %>
				                <option value="<%= p.getCodepat() %>"><%= p.getNom() %> <%= p.getPrenom() %></option>
				            <% } %>
				        </select>
				    </div>
				    <div class="mb-3">
				        <label class="form-label">Médecin</label>
				        <select class="form-select" name="medecin" id="medecinedit" required>
				            <% for (Medecin m : medecins) { %>
				                <option value="<%= m.getCodemed() %>"><%= m.getNom() %> <%= m.getPrenom() %></option>
				            <% } %>
				        </select>
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
                    <form action="visiter?action=delete" method="post">
                        <input type="hidden" name="codemed" id="codemed">
                        <input type="hidden" name="codepat" id="codepat">
                        <input type="hidden" name="dateV" id="dateV">
                        <button type="submit" class="btn btn-danger">Oui, supprimer</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
	<!-- Modal Détails Visite -->
	<div class="modal fade" id="detailsVisiteModal" tabindex="-1" aria-labelledby="detailsVisiteLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="detailsVisiteLabel">Détails de la Visite</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	            </div>
	            <div class="modal-body">
	                <p><strong>Nom du Patient :</strong> <span id="patientNom"></span></p>
	                <p><strong>Sexe :</strong> <span id="patientSexe"></span></p>
	                <p><strong>Adresse :</strong> <span id="patientAdresse"></span></p>
	                <hr>
	                <p><strong>Médecin :</strong> <span id="medecinNom"></span></p>
	                <p><strong>Grade :</strong> <span id="medecinGrade"></span></p>
	                <hr>
	                <p><strong>Date de la Visite :</strong> <span id="visiteDate"></span></p>

	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
	            </div>
	        </div>
	    </div>
	</div>
    
 <script>
    document.addEventListener("DOMContentLoaded", function() {
//    	 	let patientSelect = document.getElementById("patientSelect");
//    	    let medecinSelect = document.getElementById("medecinSelect");
//    	    let btnFiltrer = document.getElementById("btnFiltrer");

//    	    function checkFilters() {
//    	        if (patientSelect.value === "" && medecinSelect.value === "") {
//    	            btnFiltrer.disabled = true;
//    	        } else {
//    	            btnFiltrer.disabled = false;
//    	        }
//    	    }
//    	    patientSelect.addEventListener("change", checkFilters);
//    	    medecinSelect.addEventListener("change", checkFilters);
//    	    checkFilters(); 
        document.querySelectorAll('.btn-delete').forEach(button => {
            button.addEventListener('click', function() {
            	console.log(this.dataset);
                document.getElementById('codepat').value = this.dataset.patient;
                document.getElementById('codemed').value = this.dataset.medecin;
                document.getElementById('dateV').value = this.dataset.date;
                
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
            // Remplir les champs cachés pour garder les valeurs originales
            document.getElementById('codemededit').value = this.dataset.medecin;
            document.getElementById('codepatedit').value = this.dataset.patient;
            document.getElementById('dateVisiteHidden').value = this.dataset.date;
            
            // Remplir les champs visibles dans le formulaire d'édition
            document.getElementById('patientedit').value = this.dataset.patient;
            document.getElementById('medecinedit').value = this.dataset.medecin;

            
            // Afficher la modal d'édition
            new bootstrap.Modal(document.getElementById('visiteModaledit')).show();
        });
    });
    document.getElementById("btnFiltrer").addEventListener("click", function() {
        let patient = document.getElementById("patientSelect").value;
        let medecin = document.getElementById("medecinSelect").value;

        // Rediriger vers la même page avec les paramètres sélectionnés
        let url = "visiter?";
        if (patient !== "") url += "patient=" + patient + "&";
        if (medecin !== "") url += "medecin=" + medecin;
        
        window.location.href = url;
    });

        document.querySelectorAll(".btn-details").forEach(button => {
            button.addEventListener("click", function() {
                // Récupérer les données depuis les attributs data-*
                document.getElementById("patientNom").textContent = this.getAttribute("data-patient-nom");
                document.getElementById("patientSexe").textContent = this.getAttribute("data-patient-sexe");
                document.getElementById("patientAdresse").textContent = this.getAttribute("data-patient-adresse");
                document.getElementById("medecinNom").textContent = this.getAttribute("data-medecin-nom");
                document.getElementById("medecinGrade").textContent = this.getAttribute("data-medecin-grade");
                document.getElementById("visiteDate").textContent = this.getAttribute("data-visite-date");
              

                // Afficher la modal
                new bootstrap.Modal(document.getElementById("detailsVisiteModal")).show();
            });
        });



    document.getElementById('btn-add').addEventListener('click', function() {
        document.querySelector('.modal-title').innerText = 'Ajouter une Visite';
        document.getElementById('medecin').value = "";
        document.getElementById('patient').value = "";
//         document.getElementById('dateVisite').value = "";
        new bootstrap.Modal(document.getElementById('visiteModal')).show();
    });
    </script>
</body>
</html>
