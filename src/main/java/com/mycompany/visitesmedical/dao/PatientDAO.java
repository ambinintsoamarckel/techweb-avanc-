package com.mycompany.visitesmedical.dao;

import com.mycompany.visitesmedical.models.Patient;
import com.mycompany.visitesmedical.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class PatientDAO {
    public boolean save(Patient patient) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction transaction = session.beginTransaction();
            try {
                session.save(patient);
                transaction.commit();
                return true;
            } catch (Exception e) {
                transaction.rollback();
                e.printStackTrace();
                return false;
            }
        }
    }

    public List<Patient> getAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Patient", Patient.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Patient getById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Patient.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean update(Patient patient) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction transaction = session.beginTransaction();
            try {
                session.update(patient);
                transaction.commit();
                return true;
            } catch (Exception e) {
                transaction.rollback();
                e.printStackTrace();
                return false;
            }
        }
    }

    public boolean delete(Long codepat) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Patient patient = session.get(Patient.class, codepat);

            if (patient != null) {
                session.remove(patient);
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
