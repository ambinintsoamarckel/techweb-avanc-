package com.mycompany.visitesmedical.dao;

import com.mycompany.visitesmedical.models.Medecin;
import com.mycompany.visitesmedical.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class MedecinDAO {
    public boolean save(Medecin medecin) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction transaction = session.beginTransaction();
            try {
                session.save(medecin);
                transaction.commit();
                return true;
            } catch (Exception e) {
                transaction.rollback();
                e.printStackTrace();
                return false;
            }
        }
    }

    public List<Medecin> getAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Medecin", Medecin.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Medecin getById(String id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Medecin.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean update(Medecin medecin) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction transaction = session.beginTransaction();
            try {
                session.update(medecin);
                transaction.commit();
                return true;
            } catch (Exception e) {
                transaction.rollback();
                e.printStackTrace();
                return false;
            }
        }
    }

    public boolean delete(String codemed) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Medecin medecin = session.get(Medecin.class, codemed);

            if (medecin != null) {
                session.remove(medecin);
                transaction.commit();
                return true;
            } else {
                if (transaction != null) transaction.rollback();
                return false;
            }
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

}
