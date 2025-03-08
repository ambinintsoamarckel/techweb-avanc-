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
@Table(name = "medecin")
public class Medecin {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long codemed;

    @Column(nullable = false)
    private String nom;

    private String prenom;
    private String grade;

    // Constructeur par défaut (obligatoire pour Hibernate)
    public Medecin() {}

    // Constructeur avec paramètres
    public Medecin(String nom, String prenom, String grade) {
        this.nom = nom;
        this.prenom = prenom;
        this.grade = grade;
    }

    // Getters et Setters
    public Long getCodemed() { return codemed; }
    public void setCodemed(Long codemed) { this.codemed = codemed; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }
}
