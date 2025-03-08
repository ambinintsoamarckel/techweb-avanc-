/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.visitesmedical.models;

import jakarta.persistence.*;
import java.util.Date;

/**
 *
 * @author Lucia
 */

@Entity
@Table(name = "visiter")
public class Visiter {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "codemed", nullable = false)
    private Medecin medecin;

    @ManyToOne
    @JoinColumn(name = "codepat", nullable = false)
    private Patient patient;

    @Temporal(TemporalType.DATE)
    private Date date;

    // Constructeur par défaut
    public Visiter() {}

    // Constructeur avec paramètres
    public Visiter(Medecin medecin, Patient patient, Date date) {
        this.medecin = medecin;
        this.patient = patient;
        this.date = date;
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Medecin getMedecin() { return medecin; }
    public void setMedecin(Medecin medecin) { this.medecin = medecin; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
}

