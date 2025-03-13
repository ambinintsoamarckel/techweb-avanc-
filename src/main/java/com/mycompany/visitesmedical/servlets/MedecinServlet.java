package com.mycompany.visitesmedical.servlets;

import com.mycompany.visitesmedical.dao.MedecinDAO;
import com.mycompany.visitesmedical.models.Medecin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/medecin")
public class MedecinServlet extends HttpServlet {
    private MedecinDAO medecinDAO;

    public void init() {
        medecinDAO = new MedecinDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if (action == null) {
            action = "list";
        }

        try {
     
                    List<Medecin> listMedecin = medecinDAO.getAll();
                    request.setAttribute("listMedecin", listMedecin);
                    request.getRequestDispatcher("jsp/medecin-list.jsp").forward(request, response);
                 
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID invalide.");
            response.sendRedirect("medecin");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        // Vérification si l'action est une suppression
        if ("delete".equals(action)) {
            String codemedStr = request.getParameter("id");
            if (codemedStr != null && !codemedStr.isEmpty()) {
                try {
             
                    boolean success = medecinDAO.delete(codemedStr);

                    if (success) {
                        session.setAttribute("successMessage", "Médecin supprimé avec succès !");
                    } else {
                        session.setAttribute("errorMessage", "Erreur lors de la suppression !");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("errorMessage", "ID invalide.");
                }
                catch (Exception e) {
                    session.setAttribute("errorMessage", "Erreur du serveur.");
                }
            }
            response.sendRedirect("medecin");
            return;
        }

        // Si l'action n'est pas une suppression, traiter l'ajout ou la mise à jour
        String codemedStr = request.getParameter("codemed");
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String grade = request.getParameter("grade");

        Medecin medecin = new Medecin(codemedStr,nom, prenom, grade);
        boolean success;

        if ("update".equals(action)) {
        	 success = medecinDAO.update(medecin);
             if (success)session.setAttribute("successMessage", "Médecin mis à jour avec succès !" );
             else session.setAttribute("errorMessage", "Erreur lors de la mise à jour du médecin.");
           
        } else {
        	 success = medecinDAO.save(medecin);
             if (success)session.setAttribute("successMessage", "Médecin ajouté avec succès !" );
             else session.setAttribute("errorMessage",  "Erreur lors de l'ajout du médecin.");
           
        }

        response.sendRedirect("medecin");
    }

}
