package com.mycompany.visitesmedical.models;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

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
    private LocalDateTime dateTime; // Changement ici

    // Constructeurs
    public Visiter() {}

    public Visiter(Medecin medecin, Patient patient, LocalDateTime dateTime) {
        this.medecin = medecin;
        this.patient = patient;
        this.dateTime = dateTime.withSecond(0).withNano(0);
    }

    // Getters et Setters
    public Medecin getMedecin() { return medecin; }
    public void setMedecin(Medecin medecin) { this.medecin = medecin; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public LocalDateTime getDateTime() { return dateTime; }
    public void setDateTime(LocalDateTime dateTime) {     this.dateTime = dateTime.withSecond(0).withNano(0); }
}
