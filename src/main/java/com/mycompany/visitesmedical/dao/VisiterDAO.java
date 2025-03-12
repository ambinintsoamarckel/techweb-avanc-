package com.mycompany.visitesmedical.dao;

import com.mycompany.visitesmedical.models.Visiter;
import com.mycompany.visitesmedical.models.VisiterId;
import com.mycompany.visitesmedical.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class VisiterDAO {
    public boolean save(Visiter visiter) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction transaction = session.beginTransaction();
            try {
                session.save(visiter);
                transaction.commit();
                return true;
            } catch (Exception e) {
                transaction.rollback();
                e.printStackTrace();
                return false;
            }
        }
    }
    
    public Visiter getById(VisiterId id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Visiter.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public List<Visiter> getAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Visiter order by date desc", Visiter.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Visiter> getByMedecinAndPatient(Long codemed, Long codepat) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                "from Visiter where medecin.codemed = :codemed and patient.codepat = :codepat order by date desc",
                Visiter.class)
                .setParameter("codemed", codemed)
                .setParameter("codepat", codepat)
                .list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Visiter> getByMedecin(Long codemed) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Visiter where medecin.codemed = :codemed order by date desc", Visiter.class)
                .setParameter("codemed", codemed)
                .list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Visiter> getByPatient(Long codepat) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Visiter where patient.codepat = :codepat order by date desc", Visiter.class)
                .setParameter("codepat", codepat)
                .list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean delete(VisiterId visiterId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction transaction = session.beginTransaction();
            try {
                Visiter visiter = session.get(Visiter.class, visiterId);
                if (visiter != null) {
                    session.remove(visiter);
                    transaction.commit();
                    return true;
                } else {
                    transaction.rollback();
                    return false;
                }
            } catch (Exception e) {
                transaction.rollback();
                e.printStackTrace();
                return false;
            }
        }
    }
}
