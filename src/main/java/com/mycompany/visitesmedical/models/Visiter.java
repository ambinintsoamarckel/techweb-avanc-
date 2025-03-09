package com.mycompany.visitesmedical.models;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Date;

/**
 * Représente une visite médicale entre un patient et un médecin
 */
@Entity
@Table(name = "visiter")
@IdClass(VisiterId.class) // Définition de la clé primaire composite
public class Visiter implements Serializable {

    @Id
    @ManyToOne
    @JoinColumn(name = "codemed", nullable = false)
    private Medecin medecin;

    @Id
    @ManyToOne
    @JoinColumn(name = "codepat", nullable = false)
    private Patient patient;

    @Id
    @Temporal(TemporalType.DATE)
    private Date date;

    // Constructeurs
    public Visiter() {}

    public Visiter(Medecin medecin, Patient patient, Date date) {
        this.medecin = medecin;
        this.patient = patient;
        this.date = date;
    }

    // Getters et Setters
    public Medecin getMedecin() { return medecin; }
    public void setMedecin(Medecin medecin) { this.medecin = medecin; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
}
