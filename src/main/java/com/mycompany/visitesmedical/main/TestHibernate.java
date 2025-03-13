package com.mycompany.visitesmedical.main;

import org.hibernate.Session;
import org.hibernate.Transaction;
import com.mycompany.visitesmedical.models.*;
import com.mycompany.visitesmedical.utils.*;

public class TestHibernate {
    public static void main(String[] args) {
        // Ouvrir une session Hibernate
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = session.beginTransaction();

        // Insérer un médecin
        Medecin medecin = new Medecin("MED1","Dr Dupont"," Paul", "Cardiologie");
        session.save(medecin);

        // Valider la transaction
        transaction.commit();
        session.close();

        System.out.println("Médecin ajouté avec succès !");
    }
}
