package com.mycompany.visitesmedical.servlets;

import com.mycompany.visitesmedical.dao.VisiterDAO;
import com.mycompany.visitesmedical.dao.MedecinDAO;
import com.mycompany.visitesmedical.dao.PatientDAO;
import com.mycompany.visitesmedical.models.Visiter;
import com.mycompany.visitesmedical.models.VisiterId;
import com.mycompany.visitesmedical.models.Medecin;
import com.mycompany.visitesmedical.models.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;

@WebServlet("/visiter")
public class VisiterServlet extends HttpServlet {
    private VisiterDAO visiterDAO;
    private MedecinDAO medecinDAO;
    private PatientDAO patientDAO;

    public void init() {
        visiterDAO = new VisiterDAO();
        medecinDAO = new MedecinDAO();
        patientDAO = new PatientDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        try {

                    List<Visiter> listVisites = visiterDAO.getAll();;
                    List<Medecin> medecins = medecinDAO.getAll();
                    List<Patient> patients = patientDAO.getAll();
                    String patientParam = request.getParameter("patient");
                    String medecinParam = request.getParameter("medecin");

                    try {
                        if (patientParam != null && !patientParam.isEmpty() && medecinParam != null && !medecinParam.isEmpty()) {
                            listVisites = visiterDAO.getByMedecinAndPatient(patientParam, medecinParam);
                            request.setAttribute("medecinParam", medecinParam);
                            request.setAttribute("patientParam",patientParam);
                        } else if (patientParam != null && !patientParam.isEmpty()) {
                            listVisites = visiterDAO.getByPatient(patientParam);
                            request.setAttribute("patientParam",patientParam);
                        } else if (medecinParam != null && !medecinParam.isEmpty()) {
                            listVisites = visiterDAO.getByMedecin(medecinParam);
                            request.setAttribute("medecinParam", medecinParam);
                        }
                    } catch (Exception e) {
                        request.getSession().setAttribute("errorMessage", "Erreur lors du filtrage : " + e.getMessage());
                    }

          
                    request.setAttribute("medecins", medecins);
                    request.setAttribute("patients", patients);
                    request.setAttribute("listVisites", listVisites);
                    request.getRequestDispatcher("jsp/visiter-list.jsp").forward(request, response);
                
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur de traitement.");
            response.sendRedirect("visiter");
        }
    }

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        boolean redirectNeeded = true; // Contrôle la redirection à la fin

        try {
            if ("delete".equals(action)) {
                try {
                    System.out.println("\n\n\n" + request.getParameter("codemed") + " " + request.getParameter("codepat") + " " + request.getParameter("dateVisite"));

                    String codemed = request.getParameter("codemed");
                    String codepat = request.getParameter("codepat");
                    String dateStr = request.getParameter("dateV");
                    LocalDateTime date = LocalDateTime.parse(dateStr, DATE_FORMATTER);

                    VisiterId visiterId = new VisiterId(codemed, codepat, date);
                    boolean deleted = visiterDAO.delete(visiterId);
                    
                    session.setAttribute("successMessage", deleted ? "Visite supprimée !" : "Erreur lors de la suppression.");
                    
                } catch ( RuntimeException e) {
                    session.setAttribute("errorMessage", "Données invalides. "+e);
                }
            } 
            else if ("update".equals(action)) {
                try {
                    String oldCodemed = request.getParameter("oldCodemed");
                    String oldCodepat = request.getParameter("oldCodepat");
                    String oldDateStr = request.getParameter("oldDateVisite");
                    LocalDateTime oldDate = LocalDateTime.parse(oldDateStr, DATE_FORMATTER);

                    String newCodemed =request.getParameter("medecin");
                    String newCodepat =request.getParameter("patient");


                    Medecin newMedecin = medecinDAO.getById(newCodemed);
                    Patient newPatient = patientDAO.getById(newCodepat);

                    if (newMedecin == null || newPatient == null) {
                        session.setAttribute("errorMessage", "Médecin ou patient introuvable.");
                        response.sendRedirect("visiter");
                        redirectNeeded = false;
                        return;
                    }

                    VisiterId oldVisiterId = new VisiterId(oldCodemed, oldCodepat, oldDate);
                    Visiter existingVisite = visiterDAO.getById(oldVisiterId);

                    if (existingVisite != null) {
                        visiterDAO.delete(oldVisiterId);
                    }

                    Visiter newVisiter = new Visiter(newMedecin, newPatient, oldDate);
                    boolean success = visiterDAO.save(newVisiter);

                    session.setAttribute("successMessage", success ? "Visite mise à jour !" : "Erreur de mise à jour.");

                } catch ( RuntimeException e) {
                    session.setAttribute("errorMessage", "Données invalides. "+e);
                } catch (Exception e) {
                    session.setAttribute("errorMessage", "Erreur du serveur.");
                }
            }
            else { // Ajout d'une nouvelle visite
                try {
                    String codemed = request.getParameter("medecin");
                    String codepat = request.getParameter("patient");
                    LocalDateTime date = LocalDateTime.now(); // Date actuelle

                    Medecin medecin = medecinDAO.getById(codemed);
                    Patient patient = patientDAO.getById(codepat);

                    if (medecin == null || patient == null) {
                        session.setAttribute("errorMessage", "Médecin ou patient introuvable.");
                        response.sendRedirect("visiter");
                        redirectNeeded = false;
                        return;
                    }

                    Visiter visiter = new Visiter(medecin, patient, date);
                    boolean success = visiterDAO.save(visiter);
                    if (success) session.setAttribute("successMessage",  "Visite enregistrée !" );
                    else  session.setAttribute("errorMessage",  "Erreur d'enregistrement.");
                   

                } catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "Données invalides.");
                }
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Erreur du serveur.");
        }

        if (redirectNeeded) {
            response.sendRedirect("visiter");
        }
    }
}