package com.mycompany.visitesmedical.servlets;

import com.mycompany.visitesmedical.dao.MedecinDAO;
import com.mycompany.visitesmedical.models.Medecin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                // Ajouter un objet Medecin vide pour éviter l'erreur dans JSP
                request.setAttribute("medecin", new Medecin());
                request.getRequestDispatcher("jsp/medecin-form.jsp").forward(request, response);
                break;
            case "edit":
                try {
                    int id = Integer.parseInt(request.getParameter("codemed"));
                    Medecin medecin = medecinDAO.getById(id);
                    if (medecin != null) {
                        request.setAttribute("medecin", medecin);
                    } else {
                        // Si le médecin n'existe pas, renvoyer à la liste avec un message d'erreur
                        request.setAttribute("errorMessage", "Médecin introuvable.");
                        response.sendRedirect("medecin");
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "ID invalide.");
                    response.sendRedirect("medecin");
                    return;
                }
                request.getRequestDispatcher("jsp/medecin-form.jsp").forward(request, response);
                break;
            case "delete":
                try {
                    int idToDelete = Integer.parseInt(request.getParameter("id"));
                    medecinDAO.delete(idToDelete);
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "ID invalide pour suppression.");
                }
                response.sendRedirect("medecin");
                break;
            default:
                List<Medecin> listMedecin = medecinDAO.getAll();
                request.setAttribute("listMedecin", listMedecin);
                request.getRequestDispatcher("jsp/medecin-list.jsp").forward(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	String codemedStr = request.getParameter("codemed");
    	Long codemed = 0L;
    	try {
    	    if (codemedStr != null && !codemedStr.isEmpty() && !"null".equals(codemedStr)) {
    	        codemed = Long.parseLong(codemedStr);
    	    }
    	} catch (NumberFormatException e) {
    	    request.setAttribute("errorMessage", "ID invalide.");
    	    response.sendRedirect("medecin");
    	    return;
    	}


        String nom = request.getParameter("nom");
        String prenom= request.getParameter("prenom");
        String grade= request.getParameter("grade");

        Medecin medecin = new Medecin( nom,prenom, grade);

        if (codemed == 0) {
            medecinDAO.save(medecin);
        } else {
        	medecin.setCodemed(codemed);
            medecinDAO.update(medecin);
        }

        response.sendRedirect("medecin");
    }
}
