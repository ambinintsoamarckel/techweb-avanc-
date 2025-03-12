package com.mycompany.visitesmedical.servlets;

import com.mycompany.visitesmedical.dao.MedecinDAO;
import com.mycompany.visitesmedical.dao.PatientDAO;
import com.mycompany.visitesmedical.models.Medecin;
import com.mycompany.visitesmedical.models.Patient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
@WebServlet("/patient")
public class PatientServlet extends HttpServlet {
    private final PatientDAO patientDAO = new PatientDAO();
    private final MedecinDAO medecinDAO = new MedecinDAO(); // Ajout de MedecinDAO

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        try {
            PatientDAO patientDAO = new PatientDAO();
            
            if ("search".equals(action)) {
                String critere = request.getParameter("critere");
                String valeur = request.getParameter("valeur");
                
                List<Patient> patientsFiltres = patientDAO.getByFilter(critere, valeur);
                
                response.setContentType("text/html;charset=UTF-8");
                PrintWriter out = response.getWriter();
                
                for (Patient p : patientsFiltres) {
                    out.println("<tr>");
                    out.println("<td>" + p.getCodepat() + "</td>");
                    out.println("<td>" + p.getNom() + "</td>");
                    out.println("<td>" + p.getPrenom() + "</td>");
                    out.println("<td>" + p.getSexe() + "</td>");
                    out.println("<td>" + p.getAdresse() + "</td>");
                    out.println("<td>");
                    out.println("<button class='btn btn-warning btn-sm btn-edit' data-id='" + p.getCodepat() + "' data-nom='" + p.getNom() + "' data-sexe='" + p.getSexe() + "' data-prenom='" + p.getPrenom() + "' data-adresse='" + p.getAdresse() + "'>");
                    out.println("<i class='bi bi-pencil-fill'></i></button>");
                    out.println("<button class='btn btn-danger btn-sm btn-delete' data-id='" + p.getCodepat() + "'>");
                    out.println("<i class='bi bi-trash-fill'></i></button>");
                    // Ajout du bouton pour ajouter une visite
                    out.println("<button class='btn btn-success btn-sm btn-add-visite' data-id='" + p.getCodepat() + "' data-nom='" + p.getNom() + "' data-prenom='" + p.getPrenom() + "'>");
                    out.println("<i class='bi bi-calendar-plus'></i></button>");
                    out.println("</td>");
                    out.println("</tr>");
                }
                return; // Éviter d'exécuter la suite du code après avoir écrit la réponse HTML
            }
            
            List<Patient> patients = patientDAO.getAll();
            List<Medecin> medecins = medecinDAO.getAll(); // Récupération des médecins
            
            request.setAttribute("patients", patients);
            request.setAttribute("medecins", medecins); // Ajout des médecins aux attributs de la requête
            request.getRequestDispatcher("jsp/patient-list.jsp").forward(request, response);

        } catch (Exception e) {
            session.setAttribute("errorMessage", "Erreur du serveur.");
            response.sendRedirect("patient");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                boolean success = patientDAO.delete(id);
                if (success)session.setAttribute("successMessage", "Patient supprimé avec succès !" );
                else session.setAttribute("errorMessage", "Erreur lors de la suppression du patient."); 
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID invalide.");
            }
            catch (Exception e)
            {
            	 session.setAttribute("errorMessage", "Erreur du serveur.");
            }
            response.sendRedirect("patient");
            return;
        }

        String idParam = request.getParameter("codepat");
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String sexe = request.getParameter("sexe");
        String adresse = request.getParameter("adresse");

        Patient patient = new Patient(nom, prenom, sexe, adresse);
        boolean success;

        try {
            if (idParam != null && !idParam.isEmpty()) {
                patient.setCodepat(Long.parseLong(idParam));
                success = patientDAO.update(patient);
                if (success)session.setAttribute("successMessage",  "Patient mis à jour avec succès !"  );
                else session.setAttribute("errorMessage", "Erreur lors de la mise à jour du patient.");
            } else {
                success = patientDAO.save(patient);
                if (success)session.setAttribute("successMessage", "Patient ajouté avec succès !"  );
                else session.setAttribute("errorMessage", "Erreur lors de l'ajout du patient.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID invalide.");
        }
        catch (Exception e)
        {
        	 session.setAttribute("errorMessage", "Erreur du serveur.");
        }

        response.sendRedirect("patient");
    }
}
