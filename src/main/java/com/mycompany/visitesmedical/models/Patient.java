/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.visitesmedical.models;

import jakarta.persistence.*;

/**
 *
 * @author Lucia
 */
@Entity
@Table(name = "patient")
public class Patient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long codepat;

    private String nom;
    private String prenom;
    private String sexe;
    private String adresse;

    // Constructeur par défaut
    public Patient() {}

    // Constructeur avec paramètres
    public Patient(String nom, String prenom, String sexe, String adresse) {
        this.nom = nom;
        this.prenom = prenom;
        this.sexe = sexe;
        this.adresse = adresse;
    }

    // Getters et Setters
    public Long getCodepat() { return codepat; }
    public void setCodepat(Long codepat) { this.codepat = codepat; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getSexe() { return sexe; }
    public void setSexe(String sexe) { this.sexe = sexe; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }
}

